// Copyright 2010 Brightec Ltd

#import "TableController.h"
#import "JsonModel.h"
#import "TableDataSource.h"
#import "Constants.h"
#import "AlphaStyle.h"


@implementation TableController

@synthesize modelURL = _modelURL;


-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query {
	
	NSString *title = [query objectForKey:@"title"];
	NSString *modelURL = [query objectForKey:@"modelURL"];
	int style = [[query objectForKey:@"style"] intValue];
	
	if (self = [self initWithStyle:style]) {
		self.title = title;
		self.modelURL = modelURL;
	}
	
	return self;
}


-(id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.variableHeightRows = YES;
		self.view.backgroundColor = [AlphaStyle lightYellowColor];
	}
	return self;
}


-(void)loadView {
	
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)] autorelease];
	
	CGRect tableFrame = CGRectMake(0, kNavSpacerHeight, appFrame.size.width,
									appFrame.size.height - kNavBarHeight - kNavSpacerHeight - kTabBarHeight);
	
	self.tableView.autoresizingMask = UIViewAutoresizingNone;
	self.tableView.frame = tableFrame;
	self.tableView.backgroundColor = [AlphaStyle lightYellowColor];
	
	// table footer
	if (self.tableViewStyle == UITableViewStylePlain) {
		UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,kYellowGradientHeight)];
		footer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow-gradient-background-top-line.png"]];
		self.tableView.tableFooterView = footer;
		[footer release];
	}
	
}


-(void)dealloc {
	self.modelURL = nil;
	[super dealloc];
}


-(void)createModel {
	JsonModel *model = [(JsonModel *)[JsonModel alloc] initWithURL:self.modelURL];
	TableDataSource *ds = [[TableDataSource alloc] initWithJsonModel:model];
	self.dataSource = ds;
	[ds release];
	[model release];
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.model && [((TTURLRequestModel *)self.model).loadedTime timeIntervalSinceNow] < (0 - kModelCacheLifetime)) {
		[self invalidateModel];
	}
}


@end
