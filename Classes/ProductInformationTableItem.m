// Copyright 2010 Brightec Ltd

#import "ProductInformationTableItem.h"


@implementation ProductInformationTableItem

@synthesize author = _author;
@synthesize price = _price;
@synthesize description = _description;
@synthesize buyURL = _buyURL;


-(void)dealloc {
	self.author = nil;
	self.price = nil;
	self.description = nil;
	self.buyURL = nil;
	[super dealloc];
}


@end
