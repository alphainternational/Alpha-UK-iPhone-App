// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "ProductInformationTableItem.h"

@class ProductDetailView;


@interface ProductDetailController : TTModelViewController {

	NSString *_modelURL;
	NSInteger _sectionIndex;
	NSInteger _rowIndex;
	ProductDetailView *_detailView;
	
}

@property (nonatomic, readonly) NSString *modelURL;
@property (nonatomic, readonly) NSInteger sectionIndex;
@property (nonatomic, readonly) NSInteger rowIndex;
@property (nonatomic, retain) ProductDetailView *detailView;

-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query;

@end


#pragma mark -
#pragma mark ProductDetailView


@interface ProductDetailView : UIScrollView {

	UIView *topSection;
	TTImageView *imageView;
	UILabel *titleLabel;
	UILabel *authorLabel;
	UIButton *buyButton;
	
	UIView *bottomSection;
	UILabel *descriptionLabel;

	NSString *_buyURL;
	
}

@property (nonatomic, retain) NSString *buyURL;

-(void)populate:(ProductInformationTableItem *)item;

-(void)buy:(id)sender;

@end
