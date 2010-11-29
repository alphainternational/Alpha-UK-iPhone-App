// Copyright 2010 Brightec Ltd

#import "Statistics.h"


#pragma mark -
#pragma mark StatGroup


@implementation StatGroup

@synthesize area = _area;
@synthesize items = _items;
@synthesize submitURL = _submitURL;


-(void)dealloc {
	self.area = nil;
	self.items = nil;
	self.submitURL = nil;
	[super dealloc];
}


@end


#pragma mark -
#pragma mark StatItem


@implementation StatItem

@synthesize percent = _percent;
@synthesize think = _think;
@synthesize subject = _subject;


-(void)dealloc {
	self.percent = nil;
	self.think = nil;
	self.subject = nil;
	[super dealloc];
}


@end
