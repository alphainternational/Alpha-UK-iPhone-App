// Copyright 2010 Brightec Ltd

#import "TabBarController.h"
#import "WelcomeController.h"
#import "MapController.h"
#import "TableController.h"
#import "PageController.h"
#import "Constants.h"


@implementation TabBarController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nil bundle:nil]) {

		NSMutableArray *a = [NSMutableArray arrayWithCapacity:5];

		WelcomeController *c6 = [[WelcomeController alloc] initWithNibName:nil bundle:nil];
		c6.title = @"Home";
		UINavigationController *nc6 = [[UINavigationController alloc] initWithRootViewController:c6];
		nc6.tabBarItem.title = @"Home";
		nc6.tabBarItem.image = [UIImage imageNamed:@"53-house.png"];
		[a addObject:nc6];
		[nc6 release];
		[c6 release];
		
		/*
		NSString *myAlphaModelURL = [BASE_URL stringByAppendingString:@"my-alpha"];
		NSString *myAlphaURL = [@"alpha://table?title=My%20Alpha&style=0&modelURL=" stringByAppendingString:[myAlphaModelURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		UIViewController *c4 = [[TTNavigator navigator] viewControllerForURL:myAlphaURL];
		UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:c4];
		nc4.tabBarItem.title = @"My Alpha";
		nc4.tabBarItem.image = [UIImage imageNamed:@"111-user.png"];
		[a addObject:nc4];
		[nc4 release];
		*/
		
		NSString *myNotesModelURL = [BASE_URL stringByAppendingString:@"my-notes"];
		NSString *myNotesURL = [@"alpha://table?title=My%20Notes&style=0&modelURL=" stringByAppendingString:[myNotesModelURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		UIViewController *c4 = [[TTNavigator navigator] viewControllerForURL:myNotesURL];
		UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:c4];
		nc4.tabBarItem.title = @"My Notes";
		nc4.tabBarItem.image = [UIImage imageNamed:@"111-user.png"];
		[a addObject:nc4];
		[nc4 release];
		
		MapController *c5 = [[MapController alloc] initWithNibName:nil bundle:nil];
		c5.title = @"Find a Course";
		UINavigationController *nc5 = [[UINavigationController alloc] initWithRootViewController:c5];
		nc5.tabBarItem.title = @"Courses";
		nc5.tabBarItem.image = [UIImage imageNamed:@"103-map.png"];
		[a addObject:nc5];
		[nc5 release];
		[c5 release];
		
		NSString *materialsModelURL = [BASE_URL stringByAppendingString:@"materials"];
		NSString *materialsURL = [@"alpha://table?title=Materials&style=0&modelURL=" stringByAppendingString:[materialsModelURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		UIViewController *c7 = [[TTNavigator navigator] viewControllerForURL:materialsURL];
		UINavigationController *nc7 = [[UINavigationController alloc] initWithRootViewController:c7];
		nc7.tabBarItem.title = @"Materials";
		nc7.tabBarItem.image = [UIImage imageNamed:@"96-book.png"];
		[a addObject:nc7];
		[nc7 release];

		NSString *moreModelURL = [BASE_URL stringByAppendingString:@"more"];
		NSString *moreURL = [@"alpha://table?title=More&style=0&modelURL=" stringByAppendingString:[moreModelURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		UIViewController *c9 = [[TTNavigator navigator] viewControllerForURL:moreURL];
		UINavigationController *nc9 = [[UINavigationController alloc] initWithRootViewController:c9];
		nc9.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
		[a addObject:nc9];
		[nc9 release];

		self.viewControllers = a;
	}
	return self;
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	self.customizableViewControllers = nil;
	self.moreNavigationController.delegate = self;
	
	NSLog(@"more view %@", self.moreNavigationController.view);
	for (UIView *subView in self.moreNavigationController.view.subviews) {
		NSLog(@"sub view %@", subView);
		
		if ([subView isKindOfClass:[UITableView class]]) {
			NSLog(@"yes");
			
		}
	}
	
	
	//self.moreNavigationController.view.backgroundColor = [UIColor redColor];
	
}


-(void)navigationController:(UINavigationController *)navigationController
	 willShowViewController:(UIViewController *)viewController
				   animated:(BOOL)animated {
	
    navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}


@end
