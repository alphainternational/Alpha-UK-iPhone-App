// Copyright 2010 Brightec Ltd

#import "PageController.h"
#import "Constants.h"
#import "AlphaStyle.h"


@implementation PageController

@synthesize page;
@synthesize browser;
@synthesize spinner;
@synthesize backButton;
@synthesize forwardButton;
@synthesize stopButton;
@synthesize actionButton;


// for use with three20:
-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query {

	Page *p = [[[Page alloc] init] autorelease];
	p.title = [query objectForKey:@"title"];
	p.internalURL = [query objectForKey:@"internalURL"];
	p.externalURL = [query objectForKey:@"externalURL"];
	p.hasToolbar = [query objectForKey:@"hasToolbar"];
	p.hideTabBar = [query objectForKey:@"hideTabBar"];
	return [self initWithPage:p];
}


-(id)initWithPage:(Page *)p {
	if (self = [super initWithNibName:nil bundle:nil]) {
		self.page = p;
		self.hidesBottomBarWhenPushed = [p.hideTabBar boolValue];
		self.title = p.title;
		showToolbar = [p.hasToolbar boolValue];
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [AlphaStyle lightYellowColor];
	
    self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];

	
	// toolbar
	
	if (showToolbar) {
		
		NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:7];
		
		self.backButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowBack.png"]
															style:UIBarButtonItemStylePlain
														   target:self
														   action:@selector(backButtonClicked:)] autorelease];
		backButton.enabled = NO;
		[toolbarItems addObject:backButton];
		
		[toolbarItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
		
		self.forwardButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowForward.png"]
															   style:UIBarButtonItemStylePlain
															  target:self
															  action:@selector(forwardButtonClicked:)] autorelease];
		forwardButton.enabled = NO;
		[toolbarItems addObject:forwardButton];
		
		[toolbarItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
		[toolbarItems addObject:[[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease]];
		[toolbarItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
		
		self.stopButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
																		 target:self
																		 action:@selector(stopButtonClicked:)] autorelease];
		[toolbarItems addObject:stopButton];
		
		[toolbarItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
		
		self.actionButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																		   target:self
																		   action:@selector(actionButtonClicked:)] autorelease];
		actionButton.enabled = NO;
		[toolbarItems addObject:actionButton];
		[actionButton release];
		
		float toolbarY = 460 - kNavBarHeight - 44 - (self.hidesBottomBarWhenPushed ? 0 : kTabBarHeight);
		
		UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, toolbarY, 320, 44)];
		toolbar.items = toolbarItems;
    toolbar.tintColor = [AlphaStyle searchTintColor];
		[self.view addSubview:toolbar];
		[toolbar release];
	}

    // if there is no nib, tableView won't exist, so create a full size one here
    if (self.browser == nil) {
		
		CGFloat height = 460 - kNavBarHeight - kNavSpacerHeight - (showToolbar ? 44 : 0) - (self.hidesBottomBarWhenPushed ? 0 : kTabBarHeight);
			
		UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavSpacerHeight, 320, height)];
        wv.autoresizingMask = UIViewAutoresizingNone;
        wv.backgroundColor = [UIColor grayColor];
        wv.delegate = self;
        self.browser = wv;
        [self.view addSubview:wv];
        [wv release];
    }
    
	NSString *url = page.internalURL ? page.internalURL : page.externalURL;
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [browser loadRequest:req];
    browser.delegate = self;
    browser.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated {
	
	
}


- (void)dealloc {
    self.page = nil;
	self.browser = nil;
	self.spinner = nil;
	self.backButton = nil;
	self.forwardButton = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Toolbar action methods


- (void)backButtonClicked:(id)sender {
	[self.browser goBack];
}

- (void)forwardButtonClicked:(id)sender {
	[self.browser goForward];
}

- (void)actionButtonClicked:(id)sender {

	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
													delegate:self
										   cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
										   otherButtonTitles:@"Open in Safari", nil];
	as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[as showInView:self.view];
	[as release];
	
}

- (void)stopButtonClicked:(id)sender {
	[self.browser stopLoading];
}


#pragma mark -
#pragma mark UIWebViewDelegate


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	if (!showToolbar && navigationType == UIWebViewNavigationTypeLinkClicked) {
		// if we can't show multiple pages, open the link in safari
		[[UIApplication sharedApplication] openURL:request.URL];
		return false;

	} else {
		// otherwise, we have brower controls so stay in the app
		// want scaling unless it's the original page and that page has an internalURL
		webView.scalesPageToFit = !([page.internalURL isEqualToString:[request.URL absoluteString]]);
		return true;
	}
}


- (void)updateDisplayAfterLoad:(UIWebView *)webView {
    [spinner stopAnimating];
	backButton.enabled = webView.canGoBack;
	forwardButton.enabled = webView.canGoForward;
	stopButton.enabled = NO;
    webView.hidden = NO;
	
	if ([page.internalURL isEqualToString:[webView.request.URL absoluteString]] && !page.externalURL) {
		actionButton.enabled = NO;
	} else {
		actionButton.enabled = YES;
	}
	
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [spinner startAnimating];
	backButton.enabled = webView.canGoBack;
	forwardButton.enabled = webView.canGoForward;
	stopButton.enabled = YES;
	actionButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self updateDisplayAfterLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[spinner stopAnimating];
	[self updateDisplayAfterLoad:webView];
	NSLog(@"localizedDescription = %@", error.localizedDescription);
	NSLog(@"localizedFailureReason = %@", error.localizedFailureReason);
}



#pragma mark -
#pragma mark UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0 && self.browser.request.URL) {
		if ([page.internalURL isEqualToString:[self.browser.request.URL absoluteString]]) {
			if (page.externalURL) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:page.externalURL]];
			}
		} else {
			[[UIApplication sharedApplication] openURL:self.browser.request.URL];
		}
	}
}


@end
