// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface ProductInformationTableItem : TTTableImageItem {
	
	NSString *_author;
	NSString *_price;
	NSString *_description;
	NSString *_buyURL;

}

@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *buyURL;

@end
