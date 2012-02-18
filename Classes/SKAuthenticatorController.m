//
//  SKAuthenticatorController.m
//  StackKit
//
//  Created by Dave DeLong on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKAuthenticatorController.h"
#import <StackKit/SKWebView.h>
#import <StackKit/SKTypes.h>
#import <StackKit/SKFunctions.h>

NSString *const SKRedirectURI = @"https://stackexchange.com/oauth/login_success";

@implementation SKAuthenticatorController {
    BOOL _isModal;
    STSheetCompletionHandler _handler;
    NSInteger _returnCode;
    id _context;
}

@synthesize webView=_webView;
@synthesize error=_error;
@synthesize progressIndicator=_progressIndicator;

- (NSString *)windowNibName {
    return @"SKAuthenticator_Mac";
}

- (void)didEndSheet:(id)sheet returnCode:(NSInteger)code contextInfo:(void *)info {
    // called after after everything finishes, regardless of platform
    
    _handler(_returnCode);
    
#if StackKitMac
    [[self window] orderOut:self];
#endif
    
    _context = nil;
    _isModal = NO;
    _returnCode = NSNotFound;
    [_handler release], _handler = nil;
    [self setError:nil];
    
}

- (void)didAppear:(id)sender {
    NSString *scope = @"read_inbox,no_expiry";
    NSString *clientID = @"50";
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:SKRedirectURI forKey:@"redirect_uri"];
    [d setObject:scope forKey:@"scope"];
    [d setObject:clientID forKey:@"client_id"];
    
    NSString *query = SKQueryString(d);
    NSString *urlString = [NSString stringWithFormat:@"https://stackexchange.com/oauth/dialog?%@", query];
    NSLog(@"loading: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}

#if StackKitMac
- (void)runModal {
    // WebView doesn't work in a regular modal session.
    // thus we have to spin the runloop manually. Yuck!
    // got this here: http://stackoverflow.com/a/4164446/115730
    NSModalSession session = [NSApp beginModalSessionForWindow:[self window]];
    NSInteger result = NSRunContinuesResponse;
    
    // Loop until some result other than continues:
    while (result == NSRunContinuesResponse)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        result = [NSApp runModalSession:session];
        // spinning in the default mode allows the webview to render
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];        
        [pool drain];
    }
    
    [NSApp endModalSession:session];
    [self didEndSheet:nil returnCode:0 contextInfo:NULL];
}
#endif

- (void)presentInContext:(id)context handler:(STSheetCompletionHandler)handler {
    _context = context;
    _isModal = (_context == nil);
    
    _handler = [handler copy];
    _returnCode = NSNotFound;
    
#if StackKitMac
    [self didAppear:nil];
    if (_isModal) {
        [self runModal];
    } else {
        [NSApp beginSheet:[self window] 
           modalForWindow:_context 
            modalDelegate:self 
           didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) 
              contextInfo:NULL];
    }
#elif StackKitMobile
    if (_isModal) {
        _context = [[UIApplication keyWindow] rootViewController];
    }
    NSAssert(_context != nil, @"the key window must have a rootViewController");
    [_context presentModalViewController:self animated:YES completion:^{
        [self didAppear:nil];
    }];
    
#endif
}

- (void)endWithCode:(NSInteger)code {
    _returnCode = code;
#if StackKitMac
    if (_isModal) {
        [NSApp stopModalWithCode:NSRunStoppedResponse];
    } else {
        [NSApp endSheet:[self window] returnCode:code];        
    }
#elif StackKitMobile
    [_context dismissModalViewControllerAnimated:YES];
    [self didEndSheet:nil returnCode:0 contextInfo:NULL];
#endif
}

- (void)cancel:(id)sender {
    NSError *e = [NSError errorWithDomain:SKErrorDomain code:SKErrorCodeAuthenticationCancelled userInfo:nil];
    [self setError:e];
    
    [_webView stopLoading];
    
    [self endWithCode:NSCancelButton];
}

- (void)webView:(SKWebView *)webView didReceiveResponse:(NSURLResponse *)response {
    
}

- (BOOL)webView:(SKWebView *)webView shouldLoadRequest:(NSURLRequest *)request {
    NSURL *url = [[request URL] absoluteURL];
    NSString *path = [url path];
    NSLog(@"attempting to load %@", path);
    
    if ([path isEqualToString:SKRedirectURI]) {
        NSLog(@"hash: %@", [url fragment]);
        NSLog(@"%@", url);
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoading:(SKWebView *)webView {
#if StackKitMac
    [_progressIndicator setUsesThreadedAnimation:YES];
    [_progressIndicator startAnimation:nil];
#elif StackKitMobile
    [_progressIndicator startAnimation];
#endif
}

- (void)webViewDidFinishLoading:(SKWebView *)webView {
#if StackKitMac
    [_progressIndicator stopAnimation:nil];
#elif StackKitMobile
    [_progressIndicator stopAnimation];
#endif
}

- (id)init {
    self = [super init];
    if (self) {
#if StackKitMac
        [self window];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppear:) name:NSWindowDidBecomeKeyNotification object:[self window]];  
#endif
    }
    return self;
}

@end
