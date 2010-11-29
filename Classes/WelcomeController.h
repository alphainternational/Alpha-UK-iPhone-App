// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface WelcomeController : TTModelViewController <TTScrollViewDataSource, TTScrollViewDelegate> {

	UILabel *_textLabel;
	UIView *_pageControl;	
	NSArray *_images;
	NSArray *_pagerImages;
	UIImage *_activeDot;
	UIImage *_inactiveDot;
	NSArray *_urls;
  TTScrollView *_sv;
}

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIView *pageControl;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *pagerImages;
@property (nonatomic, retain) UIImage *activeDot;
@property (nonatomic, retain) UIImage *inactiveDot;
@property (nonatomic, retain) NSArray *urls;
@property (nonatomic, retain) TTScrollView *sv;

-(void)onTimer;

@end
