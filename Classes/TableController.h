// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface TableController : TTTableViewController {

	NSString *_modelURL;
	
}

@property (nonatomic, retain) NSString *modelURL;

-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query;

@end
