// Copyright 2010 Brightec Ltd

#import "WelcomeLink.h"


@implementation WelcomeLink

@synthesize URL = _URL;


-(void)dealloc {
	self.URL = nil;
	[super dealloc];
}


@end
