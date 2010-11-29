// Copyright 2010 Brightec Ltd

#import "ProductDetailCell.h"
#import "ProductInformationTableItem.h"
#import "AlphaStyle.h"


@implementation ProductDetailCell

@synthesize authorLabel = _authorLabel;
@synthesize priceLabel = _priceLabel;
@synthesize imageView2 = _imageView2;


// TODO: ideally this should calculate label sizes

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
	return 110;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {

		UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:authorLabel];
		self.authorLabel = authorLabel;
		[authorLabel release];
		
		UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:priceLabel];
		self.priceLabel = priceLabel;
		[priceLabel release];
		
		TTImageView *imageView2 = [[TTImageView alloc] init];
		[self.contentView addSubview:imageView2];
		self.imageView2 = imageView2;
		[imageView2 release];

	}
	return self;
}


-(void)dealloc {
	self.authorLabel = nil;
	self.priceLabel = nil;
	self.imageView2 = nil;
	[super dealloc];
}


-(void)setObject:(id)object {
	[super setObject:object];
	ProductInformationTableItem *item = (ProductInformationTableItem *)object;
	self.textLabel.text = item.text;
	self.authorLabel.text = item.author;
	self.priceLabel.text = item.price;
	self.imageView2.urlPath = item.imageURL;
}


-(void)layoutSubviews {
	[super layoutSubviews];
	
	self.selectionStyle = UITableViewCellSelectionStyleGray;
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow-gradient-background-top-line.png"]];

	self.textLabel.font = [UIFont boldSystemFontOfSize:20];
	self.textLabel.textColor = [AlphaStyle brownColor];	
	self.textLabel.backgroundColor = [UIColor clearColor];
	
	self.authorLabel.font = [UIFont systemFontOfSize:16];
	self.authorLabel.textColor = [AlphaStyle brownColor];	
	self.authorLabel.backgroundColor = [UIColor clearColor];
	
	self.priceLabel.font = [UIFont systemFontOfSize:14];
	self.priceLabel.textColor = [UIColor colorWithRed:(243.0/255.0) green:0.0 blue:(95.0/255.0) alpha:1.0];	
	self.priceLabel.backgroundColor = [UIColor clearColor];

	// TODO: don't hardcode values

	CGFloat textWidth = 200;
	
	self.imageView2.frame = CGRectMake(10, 10, 60, 90);
	self.textLabel.frame = CGRectMake(80, 10, textWidth, 30);
	self.authorLabel.frame = CGRectMake(80, 40, textWidth, 30);
	self.priceLabel.frame = CGRectMake(80, 70, textWidth, 30);
	
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
