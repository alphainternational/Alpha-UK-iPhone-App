// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "Statistics.h"

@class StatGroupView;
@class StatItemView;


@interface MeaningController : TTModelViewController <UITableViewDataSource, UITableViewDelegate> {

	NSString *_modelURL;
	StatGroupView *_statGroupView;
	UITableView *_tableView;
	NSString *_submitURL;
	NSIndexPath *_savedIndexPath;
	
}

@property (nonatomic, readonly) NSString *modelURL;
@property (nonatomic, retain) StatGroupView *statGroupView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *submitURL;
@property (nonatomic, retain) NSIndexPath *savedIndexPath;

-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query;

@end


#pragma mark -
#pragma mark StatGroupView


@interface StatGroupView : UIView {
	
	UILabel *areaLabel;
	StatItemView *itemView0;
	StatItemView *itemView1;
	StatItemView *itemView2;
	StatItemView *itemView3;
	
}

-(void)populate:(StatGroup *)sg;

@end


#pragma mark -
#pragma mark StatItemView


@interface StatItemView : UIView {
	
	UILabel *_percentLabel;
	UILabel *_thinkLabel;
	UILabel *_subjectLabel;
	
}

@property (nonatomic, retain) UILabel *percentLabel;
@property (nonatomic, retain) UILabel *thinkLabel;
@property (nonatomic, retain) UILabel *subjectLabel;

-(void)populate:(StatItem *)si;

@end


