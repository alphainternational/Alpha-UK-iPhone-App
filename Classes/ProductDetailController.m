// Copyright 2010 Brightec Ltd

#import "ProductDetailController.h"
#import "JsonModel.h"
#import "Table.h"
#import "Section.h"
#import "ProductInformationTableItem.h"
#import "Constants.h"
#import "AlphaStyle.h"

@implementation ProductDetailController

@synthesize modelURL = _modelURL;
@synthesize sectionIndex = _sectionIndex;
@synthesize rowIndex = _rowIndex;
@synthesize detailView = _detailView;


-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query {
	if (self = [self initWithNibName:nil bundle:nil]) {
		
		self.title = [query objectForKey:@"title"];
		_modelURL = [[query objectForKey:@"modelURL"] copy];
		_sectionIndex = [[query objectForKey:@"section"] intValue];
		_rowIndex = [[query objectForKey:@"row"] intValue];
		
	}
	return self;
}


-(void)dealloc {
	[_modelURL release];
	self.detailView = nil;
	[super dealloc];
}


-(void)loadView {
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)] autorelease];
	self.view.backgroundColor = [AlphaStyle lightYellowColor];
	
	CGRect detailFrame = CGRectMake(0, kNavSpacerHeight, appFrame.size.width,
									appFrame.size.height - kNavBarHeight - kNavSpacerHeight - kTabBarHeight);
	self.detailView = [[[ProductDetailView alloc] initWithFrame:detailFrame] autorelease];
	[self.view addSubview:self.detailView];
}


-(void)createModel {
	JsonModel *model = [(JsonModel *)[JsonModel alloc] initWithURL:self.modelURL];
	self.model = model;
	[model release];
}


-(void)didLoadModel:(BOOL)firstTime {
	Table *table = ((JsonModel *)self.model).parsedObject;
	Section *section = [table sectionAtIndex:self.sectionIndex];
	ProductInformationTableItem *item = (ProductInformationTableItem *)[section rowAtIndex:self.rowIndex];
	[self.detailView populate:item];
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.model && [((TTURLRequestModel *)self.model).loadedTime timeIntervalSinceNow] < (0 - kModelCacheLifetime)) {
		[self invalidateModel];
	}
}


@end


#pragma mark -
#pragma mark ProductDetailView


@implementation ProductDetailView

@synthesize buyURL = _buyURL;


-(id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [AlphaStyle lightYellowColor];
				
		topSection = [[UIView alloc] initWithFrame:CGRectZero];
		//topSection.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow-gradient-background.png"]];
		[self addSubview:topSection];
		
		imageView = [[TTImageView alloc] initWithFrame:CGRectZero];
		[topSection addSubview:imageView];
	
		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:20];
		titleLabel.textColor = [AlphaStyle brownColor];
		titleLabel.numberOfLines = 0;
		titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		[topSection addSubview:titleLabel];
	
		authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		authorLabel.backgroundColor = [UIColor clearColor];
		authorLabel.font = [UIFont systemFontOfSize:16];
		authorLabel.textColor = [AlphaStyle brownColor];
		authorLabel.numberOfLines = 0;
		authorLabel.lineBreakMode = UILineBreakModeWordWrap;
		[topSection addSubview:authorLabel];
		
		UIImage *buttonImage = [[UIImage imageNamed:@"buy-button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[buyButton setBackgroundImage:buttonImage forState:UIControlStateNormal];		
		[buyButton setTitleColor:[UIColor colorWithRed:(243.0/255.0) green:0.0 blue:(95.0/255.0) alpha:1.0] forState:UIControlStateNormal];
		[buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		[topSection addSubview:buyButton];

		[buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
		
		bottomSection = [[UIView alloc] initWithFrame:CGRectZero];
		bottomSection.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow-gradient-background-top-line.png"]];
		[self addSubview:bottomSection];
		
		descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		descriptionLabel.backgroundColor = [UIColor clearColor];
		descriptionLabel.font = [UIFont systemFontOfSize:16];
		descriptionLabel.textColor = [AlphaStyle brownColor];
		descriptionLabel.numberOfLines = 0;
		descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
		[bottomSection addSubview:descriptionLabel];

	}
	return self;
}


-(void)dealloc {
	[topSection release];
	[imageView release];
	[titleLabel release];
	[authorLabel release];
	[bottomSection release];
	[descriptionLabel release];
	self.buyURL = nil;
	[super dealloc];
}


-(void)populate:(ProductInformationTableItem *)item {
	static const float vspace = 10;
	

	// how big should everything be?
	
	CGSize titleSize = [item.text sizeWithFont:titleLabel.font
							 constrainedToSize:CGSizeMake(200, 100)
								 lineBreakMode:titleLabel.lineBreakMode];
	
	CGSize authorSize = [item.author sizeWithFont:authorLabel.font
								constrainedToSize:CGSizeMake(200, 100)
									lineBreakMode:authorLabel.lineBreakMode];
	
	CGSize descriptionSize = [item.description sizeWithFont:descriptionLabel.font
										  constrainedToSize:CGSizeMake(295, 2000)
											  lineBreakMode:descriptionLabel.lineBreakMode];
	
	
	// layout top section
	
	imageView.frame = CGRectMake(15, vspace, 74, 100);
	titleLabel.frame = CGRectMake(110, vspace, titleSize.width, titleSize.height);
	authorLabel.frame = CGRectMake(110, titleLabel.frame.origin.y + titleSize.height + vspace, authorSize.width, authorSize.height);
	buyButton.frame = CGRectMake(110, authorLabel.frame.origin.y + authorSize.height + vspace, 93, 29);
	
	float topSectionHeight = 2*vspace + MAX(imageView.frame.size.height, (titleSize.height + authorSize.height + buyButton.frame.size.height + 2*vspace));
	topSection.frame = CGRectMake(0, 0, 320, topSectionHeight);	

	
	// layout bottom section
	
	float minBottomSectionHeight = self.frame.size.height - topSectionHeight;
	float bottomSectionHeight = MAX(2*vspace + descriptionSize.height, minBottomSectionHeight);
	bottomSection.frame = CGRectMake(0, topSectionHeight, 320, bottomSectionHeight);
	
	descriptionLabel.frame = CGRectMake(15, vspace, descriptionSize.width, descriptionSize.height);
	

	// populate
	
	imageView.urlPath = item.imageURL;
	titleLabel.text = item.text;
	authorLabel.text = item.author;
	[buyButton setTitle:[@"Buy " stringByAppendingString: item.price] forState:UIControlStateNormal];
	descriptionLabel.text = item.description;
	
	self.buyURL = item.buyURL;
	
	self.contentSize = CGSizeMake(320, topSectionHeight + bottomSectionHeight);
}


-(void)buy:(id)sender {
	if (self.buyURL) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.buyURL]];
	}
}


@end



