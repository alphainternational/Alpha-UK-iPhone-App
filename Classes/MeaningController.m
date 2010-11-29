// Copyright 2010 Brightec Ltd

#import "MeaningController.h"
#import "JsonModel.h"
#import "Statistics.h"
#import "Constants.h"
#import "AlphaStyle.h"
#import "AlphaTextTableCell.h"


@implementation MeaningController

@synthesize modelURL = _modelURL;
@synthesize statGroupView = _statGroupView;
@synthesize tableView = _tableView;
@synthesize submitURL = _submitURL;
@synthesize savedIndexPath = _savedIndexPath;


-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query {
	NSString *modelURL = [query objectForKey:@"modelURL"];
	BOOL national = [[query objectForKey:@"national"] intValue] != 0;
	
	if (self = [super initWithNibName:nil bundle:nil]) {
		
		_modelURL = [modelURL copy];
		self.title = @"The Meaning of Life";
		self.statGroupView = [[[StatGroupView alloc] initWithFrame:CGRectZero] autorelease];

		if (national) {
			self.tableView = [[[UITableView alloc] initWithFrame:CGRectZero] autorelease];
			self.tableView.delegate = self;
			self.tableView.dataSource = self;
		}
		
	}
	return self;
}


-(void)dealloc {
	[_modelURL release];
	self.statGroupView = nil;
	self.tableView = nil;
	self.submitURL = nil;
	self.savedIndexPath = nil;
	[super dealloc];
}


-(void)loadView {
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;

	CGFloat width = appFrame.size.width;
	CGFloat height = appFrame.size.height - kTabBarHeight - kNavBarHeight;
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)] autorelease];
	self.view.backgroundColor = [AlphaStyle lightYellowColor];
	
	self.statGroupView.frame = CGRectMake(0, kNavSpacerHeight, 320, 240);
	self.statGroupView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.statGroupView];

	if (self.tableView) {
		self.tableView.frame = CGRectMake(0, 258, 320, 109);
		self.tableView.tableFooterView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow-gradient-background-top-line.png"]] autorelease];
		self.tableView.scrollEnabled = NO;
		[self.view addSubview:self.tableView];
	}
	
}


-(void)createModel {
	JsonModel *model = [(JsonModel *)[JsonModel alloc] initWithURL:self.modelURL];
	self.model = model;
	[model release];
}


-(void)didLoadModel:(BOOL)firstTime {
	StatGroup *sg = ((JsonModel *)self.model).parsedObject;
	self.submitURL = sg.submitURL;
	[self.statGroupView populate:sg];
}


#pragma mark TableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		
		UIViewController *vc = [[TTNavigator navigator] viewControllerForURL:self.submitURL];
		self.savedIndexPath = indexPath;
		[self.navigationController pushViewController:vc animated:YES];
		
	} else if (indexPath.row == 1) {
		
		NSString *countiesModelURL = [BASE_URL stringByAppendingString:@"meaning-counties"];
		NSString *url = [@"alpha://table?title=Counties&style=0&modelURL=" stringByAppendingString:[countiesModelURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		UIViewController *vc = [[TTNavigator navigator] viewControllerForURL:url];
		self.savedIndexPath = indexPath;
		[self.navigationController pushViewController:vc animated:YES];
		
	}
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.savedIndexPath) {
		[self.tableView deselectRowAtIndexPath:self.savedIndexPath animated:NO];
	}
	
	if (self.model && [((TTURLRequestModel *)self.model).loadedTime timeIntervalSinceNow] < (0 - kModelCacheLifetime)) {
		[self invalidateModel];
	}
}


#pragma mark TableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *text;
	if (indexPath.row == 0) {
		text = @"Submit your answer";
	} else if (indexPath.row == 1) {
		text = @"Results by county";
	}
	
	static NSString *cellIdentifier = @"MeaningControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [[[AlphaTextTableCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = text;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


@end


#pragma mark -
#pragma mark StatGroupView


@implementation StatGroupView


-(id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
		areaLabel.textAlignment = UITextAlignmentCenter;
		areaLabel.font = [UIFont boldSystemFontOfSize:20];
		areaLabel.backgroundColor = [UIColor clearColor];
		areaLabel.textColor = [UIColor colorWithRed:0.0 green:(148.0/255.0) blue:(196.0/255.0) alpha:1.000];
		[self addSubview:areaLabel];
		
		itemView0 = [[StatItemView alloc] initWithFrame:CGRectMake(20, 50, 130, 80)];
		[self addSubview:itemView0];
		
		itemView1 = [[StatItemView alloc] initWithFrame:CGRectMake(170, 50, 130, 80)];
		[self addSubview:itemView1];
		
		itemView2 = [[StatItemView alloc] initWithFrame:CGRectMake(20, 150, 130, 80)];
		[self addSubview:itemView2];
		
		itemView3 = [[StatItemView alloc] initWithFrame:CGRectMake(170, 150, 130, 80)];
		[self addSubview:itemView3];
		
	}
	return self;
}


-(void)dealloc {
	[areaLabel release];
	[itemView0 release];
	[itemView1 release];
	[itemView2 release];
	[itemView3 release];
	[super dealloc];
}


-(void)populate:(StatGroup *)sg {
	areaLabel.text = [sg.area uppercaseString];
	[itemView0 populate:[sg.items objectAtIndex:0]];
	[itemView1 populate:[sg.items objectAtIndex:1]];
	[itemView2 populate:[sg.items objectAtIndex:2]];
	[itemView3 populate:[sg.items objectAtIndex:3]];
}


@end


#pragma mark -
#pragma mark StatItemView


@implementation StatItemView

@synthesize percentLabel = _percentLabel;
@synthesize thinkLabel = _thinkLabel;
@synthesize subjectLabel = _subjectLabel;


-(id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor clearColor];
		
		UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 25)];
		percentLabel.textAlignment = UITextAlignmentCenter;
		percentLabel.backgroundColor = [UIColor clearColor];
		percentLabel.font = [UIFont boldSystemFontOfSize:20];
		percentLabel.textColor = [UIColor colorWithRed:(69.0/255.0) green:(188.0/255.0) blue:(82.0/255.0) alpha:1.000];
		self.percentLabel = percentLabel;
		[percentLabel release];
		[self addSubview:self.percentLabel];

		UILabel *thinkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 130, 20)];
		thinkLabel.textAlignment = UITextAlignmentCenter;
		thinkLabel.backgroundColor = [UIColor clearColor];
		thinkLabel.textColor = [AlphaStyle brownColor];	
		thinkLabel.font = [UIFont systemFontOfSize:14];
		self.thinkLabel = thinkLabel;
		[thinkLabel release];
		[self addSubview:self.thinkLabel];
		
		UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 130, 20)];
		subjectLabel.textAlignment = UITextAlignmentCenter;
		subjectLabel.backgroundColor = [UIColor clearColor];
		subjectLabel.textColor = [AlphaStyle brownColor];	
		subjectLabel.font = [UIFont boldSystemFontOfSize:18];
		self.subjectLabel = subjectLabel;
		[subjectLabel release];
		[self addSubview:self.subjectLabel];
		
	}
	return self;
}


-(void)dealloc {
	self.percentLabel = nil;
	self.thinkLabel = nil;
	self.subjectLabel = nil;
	[super dealloc];
}


-(void)populate:(StatItem *)si {
	self.percentLabel.text = si.percent;
	self.thinkLabel.text = si.think;
	self.subjectLabel.text = si.subject;
}


@end

