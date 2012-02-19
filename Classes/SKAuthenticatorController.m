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
    STSheetCompletionHandler _handler;
    NSInteger _returnCode;
    NSDictionary *_accessInformation;
    id _context;
    SKAuthenticationScope _scopeOptions;
}

@synthesize webView=_webView;
@synthesize error=_error;
@synthesize progressIndicator=_progressIndicator;
@synthesize accessInformation=_accessInformation;

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
    _returnCode = NSNotFound;
    _scopeOptions = 0;
    [_handler release], _handler = nil;
    [_accessInformation release], _accessInformation = nil;
    [self setError:nil];
    
}

- (void)didAppear:(id)sender {
    NSMutableArray *scopes = [NSMutableArray array];
    if (_scopeOptions & SKAuthenticationScopeReadInbox) {
        [scopes addObject:@"read_inbox"];
    }
    if (_scopeOptions & SKAuthenticationScopeNoExpiration) {
        [scopes addObject:@"no_expiry"];
    }
    
    NSString *clientID = [[SKSettings sharedSettings] clientID];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:SKRedirectURI forKey:@"redirect_uri"];
    [d setObject:clientID forKey:@"client_id"];
    
    if ([scopes count] > 0) {
        NSString *scope = [scopes componentsJoinedByString:@","];
        [d setObject:scope forKey:@"scope"];
    }
    
    NSString *query = SKQueryString(d);
    NSString *urlString = [NSString stringWithFormat:@"https://stackexchange.com/oauth/dialog?%@", query];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}

- (void)presentInContext:(id)context scope:(SKAuthenticationScope)scope handler:(STSheetCompletionHandler)handler {
    _context = context;
    _scopeOptions = scope;
    _handler = [handler copy];
    _returnCode = NSNotFound;
    
#if StackKitMac
    [self didAppear:nil];
    [NSApp beginSheet:[self window] 
       modalForWindow:_context 
        modalDelegate:self 
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) 
          contextInfo:NULL];
#elif StackKitMobile
    if (_context == nil) {
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
    [NSApp endSheet:[self window] returnCode:code];
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

- (BOOL)webView:(SKWebView *)webView shouldLoadRequest:(NSURLRequest *)request {
    NSURL *redirectURL = [NSURL URLWithString:SKRedirectURI];
    
    NSURL *url = [[request URL] absoluteURL];
    
    if ([[url path] isEqualToString:[redirectURL path]] && [[url host] isEqualToString:[redirectURL host]]) {
        NSString *fragment = [url fragment];
        _accessInformation = [SKDictionaryFromQueryString(fragment) retain];
        [self endWithCode:NSOKButton];
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
#elif StackKitMobile
        SKWebView *webView = [[SKWebView alloc] initWithFrame:CGRectMake(0,0,320,480)];
        [webView setWebDelegate:self];
        
        UIViewController *root = [[UIViewController alloc] init];
        [root setView:webView];
        [webView release];
        
        [root setTitle:@"Log In"];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [[root navigationItem] setLeftBarButtonItem:cancelButton];
        [cancelButton release];
        
        _progressIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorStyleWhite] autorelease];
        UIBarButtonItem *progressItem = [[UIBarButtonItem alloc] initWithCustomView:_progressIndicator];
        [[root navigationItem] setRightBarButtonItem:progressItem];
        [progressItem release];
        
        [self pushViewController:root animated:NO];
        [root release];
#endif
    }
    return self;
}

@end
