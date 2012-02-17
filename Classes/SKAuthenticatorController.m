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

#if StackKitMac
@interface WebView (StackKitHacks)
- (void)scheduleInRunLoop:(NSRunLoop *)runLoop forMode:(NSString *)mode;
- (void)unscheduleFromRunLoop:(NSRunLoop *)runLoop forMode:(NSString *)mode;
@end
#endif

NSString *const SKRedirectURI = @"https://stackexchange.com/oauth/login_success";

@implementation SKAuthenticatorController {
    BOOL _isModal;
    STSheetCompletionHandler _handler;
    NSInteger _returnCode;
    id _context;
}

@synthesize webView=_webView;
@synthesize error=_error;

- (NSString *)windowNibName {
    return @"SKAuthenticator_Mac";
}

- (void)didEndSheet:(id)sheet returnCode:(NSInteger)code contextInfo:(void *)info {
    // called after after everything finishes, regardless of platform
    
    _handler(_returnCode);
    
#if StackKitMac
    [_webView unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSModalPanelRunLoopMode];
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
        
        // Run the window modally until there are no events to process:
        result = [NSApp runModalSession:session];
        
        // Give the main loop some time:
//        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];        
        // Drain pool to avoid memory getting clogged:
        [pool drain];
    }
    
    [NSApp endModalSession:session];
}
#endif

- (void)presentInContext:(id)context handler:(STSheetCompletionHandler)handler {
    _context = context;
    _isModal = (_context == nil);
    
    _handler = [handler copy];
    _returnCode = NSNotFound;
    
#if StackKitMac
    
    [self didAppear:nil];
    NSRunLoop *current = [NSRunLoop currentRunLoop];
    [_webView scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSModalPanelRunLoopMode];
    if (_isModal) {
        // this re-enters the runloop
        [self runModal];
        [self didEndSheet:[self window] returnCode:0 contextInfo:NULL];
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
        [NSApp stopModalWithCode:code];
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

- (id)init {
    self = [super init];
    if (self) {
#if StackKitMac
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppear:) name:NSWindowDidBecomeKeyNotification object:[self window]];  
#endif
    }
    return self;
}

@end
