// Copyright 2010 Brightec Ltd

#import <UIKit/UIKit.h>
#import "Page.h"


@interface PageController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {

    Page *page;
    UIWebView *browser;
    UIActivityIndicatorView *spinner;
	UIBarButtonItem *backButton;
	UIBarButtonItem *forwardButton;
	UIBarButtonItem *stopButton;
	UIBarButtonItem *actionButton;
	BOOL showToolbar;
    
}

@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) Page *page;
@property (nonatomic, retain) IBOutlet UIWebView *browser;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIBarButtonItem *forwardButton;
@property (nonatomic, retain) UIBarButtonItem *stopButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;


-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query;

-(id)initWithPage:(Page *)p;


@end
