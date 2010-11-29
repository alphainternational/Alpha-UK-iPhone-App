// Copyright 2010 Brightec Ltd

#import "WelcomeController.h"
#import "AlphaStyle.h"
#import "JsonModel.h"
#import "Constants.h"
#import "WelcomeLink.h"


@implementation WelcomeController

@synthesize textLabel = _textLabel;
@synthesize images = _images;
@synthesize pageControl = _pageControl;
@synthesize pagerImages = _pagerImages;
@synthesize activeDot = _activeDot;
@synthesize inactiveDot = _inactiveDot;
@synthesize urls = _urls;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.title = @"Home";
		
		UILabel *textLabel = [[UILabel alloc] init];
		textLabel.text = @"Alpha is a course, open to everyone interested in discovering what Christianity is about. You can come, relax, eat, share your own thoughts and explore the meaning of life with others.";
		textLabel.lineBreakMode = UILineBreakModeWordWrap;
		textLabel.numberOfLines = 4;
		self.textLabel = textLabel;
		[textLabel release];
		
		UIView *pageControl = [[UIView alloc] initWithFrame: CGRectMake(0, 315, 320, 8)];
		self.pageControl = pageControl;
		[pageControl release];		
		
		UIImage *activeDot = [UIImage imageNamed:@"dot-active.png"];
		self.activeDot = activeDot;
		
		UIImage *inactiveDot = [UIImage imageNamed:@"dot-inactive.png"];		
		self.inactiveDot = inactiveDot;
				
		UIImageView *pagerImage0 = [[[UIImageView alloc] initWithImage:self.activeDot] autorelease];
		UIImageView *pagerImage1 = [[[UIImageView alloc] initWithImage:self.inactiveDot] autorelease];
		UIImageView *pagerImage2 = [[[UIImageView alloc] initWithImage:self.inactiveDot] autorelease];
		UIImageView *pagerImage3 = [[[UIImageView alloc] initWithImage:self.inactiveDot] autorelease];
		UIImageView *pagerImage4 = [[[UIImageView alloc] initWithImage:self.inactiveDot] autorelease];
		UIImageView *pagerImage5 = [[[UIImageView alloc] initWithImage:self.inactiveDot] autorelease];
		self.pagerImages = [NSArray arrayWithObjects:pagerImage0, pagerImage1, pagerImage2, pagerImage3, pagerImage4, pagerImage5, nil];
		
		UIImage *image0 = [UIImage imageNamed:@"welcome0.png"];
		UIImage *image1 = [UIImage imageNamed:@"welcome1.png"];
		UIImage *image2 = [UIImage imageNamed:@"welcome2.png"];
		UIImage *image3 = [UIImage imageNamed:@"welcome3.png"];
		UIImage *image4 = [UIImage imageNamed:@"welcome4.png"];
		UIImage *image5 = [UIImage imageNamed:@"welcome5.png"];
		self.images = [NSArray arrayWithObjects:image0, image1, image2, image3, image4, image5, nil];
	}
	return self;
}


-(void)dealloc {
	self.textLabel = nil;
	self.images = nil;
	self.pageControl = nil;
	self.pagerImages = nil;
	self.activeDot = nil;
	self.inactiveDot = nil;
	self.urls = nil;
	[super dealloc];
}


-(void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"welcome-wallpaper.png"]];
	
	TTScrollView *sv = [[TTScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 318)];
	sv.zoomEnabled = NO;
	sv.dataSource = self;
	sv.delegate = self;
	sv.pageSpacing = 2;
	[self.view addSubview:sv];
	[sv release];
	
	UIImageView *backgroundOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 256, 320, 155)];
	backgroundOverlay.image = [UIImage imageNamed:@"welcome-mask.png"];
	backgroundOverlay.backgroundColor = [UIColor clearColor];
	[self.view addSubview:backgroundOverlay];
	[backgroundOverlay release];
	
	// Load pager images into pageControl view
	for (UIImageView *dot in self.pagerImages) {
		dot.backgroundColor = [UIColor clearColor];
		dot.frame = CGRectMake((160 - (((self.pagerImages.count*8) + ((self.pagerImages.count-1) *5)) / 2) + ([self.pagerImages indexOfObject:dot]*13)), 0, 8, 8);
		
		[self.pageControl addSubview:dot];
	}	
	
	self.pageControl.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.pageControl];
	
	self.textLabel.frame = CGRectMake(8,330,304,74);
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.textLabel.font = [UIFont systemFontOfSize:14];
	self.textLabel.textColor = [AlphaStyle brownColor];
	self.textLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:self.textLabel];
	
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}


-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}



- (NSInteger)numberOfPagesInScrollView:(TTScrollView*)scrollView {
	return self.images.count;
}


- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex {
	UIImage *image = [self.images objectAtIndex:pageIndex];
	return [[[UIImageView alloc] initWithImage:image] autorelease];
}


- (CGSize)scrollView:(TTScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex {
	return CGSizeMake(320, 318);
}


-(void)scrollView:(TTScrollView *)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex {

	for (UIImageView *dot in self.pagerImages) {
		if ([self.pagerImages indexOfObject:dot] == pageIndex) {
			[dot setImage:self.activeDot];
		}
		else {
			[dot setImage:self.inactiveDot];
		}
	}		
}


-(void)scrollView:(TTScrollView *)scrollView tapped:(UITouch *)touch {
	WelcomeLink *link = [self.urls objectAtIndex:scrollView.centerPageIndex];
	if (link.URL) {
		UIViewController *childController = [[TTNavigator navigator] viewControllerForURL:link.URL];
		[self.navigationController pushViewController:childController animated:YES];
	}
}


-(void)createModel {
	NSString *modelUrl = [BASE_URL stringByAppendingString:@"welcome"];
	JsonModel *model = [(JsonModel *)[JsonModel alloc] initWithURL:modelUrl];
	self.model = model;
	[model release];
}


-(void)didLoadModel:(BOOL)firstTime {
	self.urls = (NSArray *) ((JsonModel *)self.model).parsedObject;
}


@end
