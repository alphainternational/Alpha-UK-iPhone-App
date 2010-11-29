// Copyright 2010 Brightec Ltd

#import "Pin.h"


@implementation Pin

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize URL = _URL;
@synthesize color = _color;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


-(void)dealloc {
	self.title = nil;
	self.subtitle = nil;
	self.URL = nil;
	self.color = nil;
	self.latitude = nil;
	self.longitude = nil;
	[super dealloc];
}


#pragma mark MKAnnotation


-(CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D c;
	c.latitude = [self.latitude doubleValue];
	c.longitude = [self.longitude doubleValue];
	return c;
}


@end
