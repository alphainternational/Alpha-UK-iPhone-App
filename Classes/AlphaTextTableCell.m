// Copyright 2010 Brightec Ltd

#import "AlphaTextTableCell.h"
#import "AlphaStyle.h"


@implementation AlphaTextTableCell


-(void)layoutSubviews {
	[super layoutSubviews];

	self.selectionStyle = UITableViewCellSelectionStyleGray;
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow-gradient-background-top-line.png"]];
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.textLabel.textColor = [AlphaStyle brownColor];

	// we're only interested in the contentView, selectedBackgroundView and the button (if there is one)
	// get rid of anything else - this will remove the 1px grey line
	NSArray *subviews = [NSArray arrayWithArray:self.subviews];
	for (UIView *v in subviews) {
		if (v != self.selectedBackgroundView && v != self.contentView && ![v isKindOfClass:[UIButton class]]) {
			[v removeFromSuperview];
		}
	}
	
}


@end
