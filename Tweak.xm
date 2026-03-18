#import <Foundation/Foundation.h>

/*
 * XXTouch Explorer Tweak - Havoc Auth Spoof
 * Target: ch.xxtou.XXTExplorer
 */

%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    if (completionHandler && [request.URL.absoluteString containsString:@"havoc.app/api/sileo/authenticate"]) {
        
        // Wrap the completion handler to inject our fake response
        void (^fakeCompletion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *fakeResponseString = @"sileo://authentication_success?token=0c2fba0dc33ccfe8875b13b71dd93956657d5342195065e81a0c0f8400254d9d&payment_secret=fb0e28d0d50e4753330993f6f7ad2175c92f996711589c99c3fa0558f9ecd093";
            NSData *fakeData = [fakeResponseString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSHTTPURLResponse *fakeResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL 
                                                                        statusCode:200 
                                                                       HTTPVersion:@"HTTP/1.1" 
                                                                      headerFields:@{@"Content-Type": @"text/plain"}];
            
            completionHandler(fakeData, fakeResponse, nil);
        };
        
        return %orig(request, fakeCompletion);
    }
    return %orig;
}

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    if (completionHandler && [url.absoluteString containsString:@"havoc.app/api/sileo/authenticate"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        return [self dataTaskWithRequest:request completionHandler:completionHandler];
    }
    return %orig;
}

%end

// Fallback for older NSURLConnection if used
%hook NSURLConnection

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    if ([request.URL.absoluteString containsString:@"havoc.app/api/sileo/authenticate"]) {
        NSString *fakeResponseString = @"sileo://authentication_success?token=0c2fba0dc33ccfe8875b13b71dd93956657d5342195065e81a0c0f8400254d9d&payment_secret=fb0e28d0d50e4753330993f6f7ad2175c92f996711589c99c3fa0558f9ecd093";
        if (response) {
            *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type": @"text/plain"}];
        }
        return [fakeResponseString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return %orig;
}

%end
