// Copyright 2010 Brightec Ltd

#import "AlphaCaptionTableCell.h"
#import "AlphaStyle.h"


@implementation AlphaCaptionTableCell


-(void)layoutSubviews {
	[super layoutSubviews];
	self.selectionStyle = UITableViewCellSelectionStyleGray;
	self.detailTextLabel.textColor = [AlphaStyle brownColor];  // main text
	self.captionLabel.textColor = [AlphaStyle lightGrayColor];
}


@end
