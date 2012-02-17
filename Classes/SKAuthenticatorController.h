//
//  SKAuthenticatorController.h
//  StackKit
//
//  Created by Dave DeLong on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKMacros.h>
#import <StackKit/SKWebView.h>

#if StackKitMac

#import <AppKit/AppKit.h>


typedef void(^STSheetCompletionHandler)(NSInteger code);

@interface SKAuthenticatorController : NSWindowController <SKWebViewDelegate>

#elif StackKitMobile

#import <UIKit/UIKit.h>
@interface SKAuthenticatorController : UIViewController <SKWebViewDelegate>

#endif
@property (nonatomic, assign) IBOutlet SKWebView *webView;
@property (nonatomic, retain) NSError *error;

- (IBAction)cancel:(id)sender;

- (void)presentInContext:(id)context handler:(STSheetCompletionHandler)handler;


@end
