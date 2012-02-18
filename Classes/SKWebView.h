//
//  SKWebView.h
//  StackKit
//
//  Created by Dave DeLong on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKMacros.h>

@class SKWebView;

@protocol SKWebViewDelegate <NSObject>

- (BOOL)webView:(SKWebView *)webView shouldLoadRequest:(NSURLRequest *)request;

- (void)webViewDidStartLoading:(SKWebView *)webView;
- (void)webViewDidFinishLoading:(SKWebView *)webView;

@end

#if StackKitMac

#import <WebKit/WebKit.h>

@interface SKWebView : WebView

#elif StackKitMobile

@interface SKWebView : UIWebView <UIWebViewDelegate>

#endif

@property (nonatomic, assign) IBOutlet id<SKWebViewDelegate> webDelegate;

- (void)loadRequest:(NSURLRequest *)request;
- (void)stopLoading;

@end
