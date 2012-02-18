//
//  SKWebView.m
//  StackKit
//
//  Created by Dave DeLong on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKWebView.h"

@implementation SKWebView

@synthesize webDelegate=_webDelegate;

- (void)_initialSetup {
#if StackKitMac
    [super setFrameLoadDelegate:self];
#endif
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initialSetup];
    }
    return self;
}

- (void)setWebDelegate:(id<SKWebViewDelegate>)webDelegate {
    _webDelegate = webDelegate;
}

#pragma mark -

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script {
    NSAssert(NO, @"no way");
    return nil;
}

#if StackKitMac

- (void)loadRequest:(NSURLRequest *)request {
    [[self mainFrame] loadRequest:request];
}

- (void)stopLoading {
    [self stopLoading:self];
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
    if (frame == [self mainFrame]) {
        [_webDelegate webViewDidStartLoading:self];
    }
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    if (frame == [self mainFrame]) {
        [_webDelegate webViewDidFinishLoading:self];
    }
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener {
    
    if ([_webDelegate webView:self shouldLoadRequest:request]) {
        [listener use];
    } else {
        [listener ignore];
    }
}

- (void)setFrameLoadDelegate:(id)delegate {
    NSAssert(NO, @"yo dawg what you tryin' to do?");
}

#endif

@end
