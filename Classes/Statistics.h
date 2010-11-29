// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>

@class Table;


#pragma mark -
#pragma mark StatGroup


@interface StatGroup : NSObject {
	
	NSString *_area;
	NSArray *_items;
	NSString *_submitURL;

}

@property (nonatomic, retain) NSString *area;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSString *submitURL;

@end


#pragma mark -
#pragma mark StatItem


@interface StatItem : NSObject {

	NSString *_percent;
	NSString *_think;
	NSString *_subject;

}

@property (nonatomic, retain) NSString *percent;
@property (nonatomic, retain) NSString *think;
@property (nonatomic, retain) NSString *subject;

@end