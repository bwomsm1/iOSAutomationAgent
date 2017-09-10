//
//  JSONRPCResponse.m
//  AutomationKit
//
//  Created by Boaz Warshawsky on 07/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

#import "JSONRPCResponse.h"
#import "JSONRPCRequest.h"
#import "HTTPServer.h"
#import "JSONRPCMethods.h"

@implementation JSONRPCResponse

+ (void)load
{
    [HTTPResponseHandler registerHandler:self];
}

+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
                  method:(NSString *)requestMethod
                     url:(NSURL *)requestURL
            headerFields:(NSDictionary *)requestHeaderFields
{
    return YES;
}

-(NSString *)validateRequest:(JSONRPCRequest *)jsonRequest
{
    NSString *errorMsg = nil;
    
    if (jsonRequest && jsonRequest.version && jsonRequest.method && jsonRequest.objId)
    {
        if (![jsonRequest.version isEqualToString:@"2.0"])
        {
            errorMsg = @"Invalid Request";
        }
        else
        {
            if (![[JSONRPCMethods sharedJSONRPCMethods] methodSupported:jsonRequest.method])
            {
                errorMsg = @"Method not found";
            }
        }
    }
    else
    {
        errorMsg = @"Parse error";
    }
    return errorMsg;
}

- (void)startResponse
{
    CFDataRef body = CFHTTPMessageCopyBody(request);
    NSData *requestBody = (__bridge NSData *)body;
    JSONRPCRequest *jsonRequest = [[JSONRPCRequest alloc] initWithRequestBody:requestBody];
    CFRelease(body);
    NSString *errorMsg = [self validateRequest:jsonRequest];
    NSString *postString = nil;
    
    if (!errorMsg)
    {
        postString = [[JSONRPCMethods sharedJSONRPCMethods] executeMethod:jsonRequest.method WithParams:jsonRequest.params];
        if (postString)
        {
            NSData* jsonData = nil;
            NSError *error = nil;
            NSDictionary *responseDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0", @"jsonrpc", postString, @"result", [NSString stringWithFormat:@"%@", jsonRequest.objId], @"id", nil];
            jsonData = [NSJSONSerialization dataWithJSONObject:responseDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
            postString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        }
        else
        {
            errorMsg = @"EnumerateElements error";
        }
    }
    else
    {
        postString = [NSString stringWithFormat:@"{\"jsonrpc\": \"2.0\", \"error\": {\"message\": \"%@\"}, \"id\": %@}", errorMsg, jsonRequest.objId];
    }
    
    CFHTTPMessageRef response =
    CFHTTPMessageCreateResponse(
                                kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
    CFHTTPMessageSetHeaderFieldValue(
                                     response, (CFStringRef)@"Content-Type", (CFStringRef)@"application/json");
    CFHTTPMessageSetHeaderFieldValue(
                                     response, (CFStringRef)@"Connection", (CFStringRef)@"close");
    
    NSData *      postStringData = [postString
                                    dataUsingEncoding: NSUTF8StringEncoding
                                    allowLossyConversion: YES];
    CFHTTPMessageSetBody(response,
                         (__bridge CFDataRef) postStringData);
    
    CFHTTPMessageSetHeaderFieldValue(
                                     response,
                                     (CFStringRef)@"Content-Length",
                                     (__bridge CFStringRef)[NSString stringWithFormat:@"%lu", (unsigned long)postStringData.length]);
    CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
    
    @try
    {
        [fileHandle writeData:(__bridge NSData *)headerData];
        [fileHandle writeData:postStringData];
    }
    @catch (NSException *exception)
    {
        // Ignore the exception, it normally just means the client
        // closed the connection from the other end.
    }
    @finally
    {
        CFRelease(headerData);
        [server closeHandler:self];
    }
}

@end
