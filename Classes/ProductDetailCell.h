// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface ProductDetailCell : TTTableLinkedItemCell {
	
	UILabel *_authorLabel;
	UILabel *_priceLabel;
	TTImageView* _imageView2;
	
}

@property (nonatomic, retain) UILabel *authorLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) TTImageView *imageView2;

@end
