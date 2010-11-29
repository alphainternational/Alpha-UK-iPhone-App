// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>


@interface Page : NSObject {
	
	NSString *title;
	NSString *internalURL;
	NSString *externalURL;
	NSNumber *hasToolbar;
	NSNumber *hideTabBar;

}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *internalURL;
@property (nonatomic, retain) NSString *externalURL;
@property (nonatomic, retain) NSNumber *hasToolbar;
@property (nonatomic, retain) NSNumber *hideTabBar;

@end
