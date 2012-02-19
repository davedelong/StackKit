//
//  SKAuthenticatorController.h
//  StackKit
//
//  Created by Dave DeLong on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKMacros.h>
#import <StackKit/SKWebView.h>
#import <StackKit/SKAuthenticator.h>

#if StackKitMac

#import <AppKit/AppKit.h>


typedef void(^STSheetCompletionHandler)(NSInteger code);

@interface SKAuthenticatorController : NSWindowController <SKWebViewDelegate>

@property (nonatomic, assign) IBOutlet NSProgressIndicator *progressIndicator;
#elif StackKitMobile

#import <UIKit/UIKit.h>
@interface SKAuthenticatorController : UINavigationController <SKWebViewDelegate>

@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *progressIndicator;
#endif
@property (nonatomic, assign) IBOutlet SKWebView *webView;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, readonly) NSDictionary *accessInformation;

- (IBAction)cancel:(id)sender;

- (void)presentInContext:(id)context scope:(SKAuthenticationScope)scope handler:(STSheetCompletionHandler)handler;


@end
