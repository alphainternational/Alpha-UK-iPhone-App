// Copyright 2010 Brightec Ltd

#import "Page.h"


@implementation Page

@synthesize title;
@synthesize internalURL;
@synthesize externalURL;
@synthesize hasToolbar;
@synthesize hideTabBar;


- (void)dealloc {
	self.title = nil;
	self.internalURL = nil;
	self.externalURL = nil;
	self.hasToolbar = nil;
	self.hideTabBar = nil;
	[super dealloc];
}


@end
