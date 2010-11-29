// Copyright 2010 Brightec Ltd

#import "NoteController.h"
#import "AlphaStyle.h"
#import "Constants.h"


@implementation NoteController

@synthesize filename = _filename;
@synthesize subtitle = _subtitle;
@synthesize text = _text;
@synthesize noteView = _noteView;


-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query {
	
	NSString *title = [query objectForKey:@"title"];
	NSString *subtitle = [query objectForKey:@"subtitle"];
	NSString *filename = [query objectForKey:@"filename"];
	
	if (self = [super initWithNibName:nil bundle:nil]) {
		_filename = [filename copy];
		_subtitle = [subtitle copy];
		self.title = title;

		[[TTNavigator navigator].URLMap from:@"tt://post"
							toViewController:self
									selector:@selector(post:)];
		
		UIBarButtonItem *editButton =
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
													  target:@"tt://post"
													  action:@selector(openURLFromButton:)];
		self.navigationItem.rightBarButtonItem = editButton;
		[editButton release];
		
	}
	return self;
}


-(void)dealloc {
	[[TTNavigator navigator].URLMap removeURL:@"tt://post"];
	[_filename release];
	[_subtitle release];
	self.text = nil;
	self.noteView = nil;
	[super dealloc];
}


-(void)populate {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:self.filename];
	self.text = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
	
	[self.noteView populateTitle:self.subtitle text:self.text];
}



-(void)loadView {
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)] autorelease];
	self.view.backgroundColor = [AlphaStyle lightYellowColor];
	
	CGRect noteFrame = CGRectMake(0, kNavSpacerHeight, appFrame.size.width,
									appFrame.size.height - kNavBarHeight - kNavSpacerHeight - kTabBarHeight);
	
	self.noteView = [[[NoteView alloc] initWithFrame:noteFrame] autorelease];
	[self.view addSubview:self.noteView];

	[self populate];
	
}


-(UIViewController*)post:(NSDictionary*)query {
	TTPostController* controller = [[[TTPostController alloc] init] autorelease];
	controller.textView.text = self.text;
	controller.delegate = self;
	return controller;
}


- (void)postController:(TTPostController *)postController
		   didPostText:(NSString *)text
			withResult:(id)result {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:self.filename];
	[text writeToFile:fullPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	[self populate];
}


@end


#pragma mark -
#pragma mark NoteView


@implementation NoteView


-(id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {

		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel.numberOfLines = 0;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:20];
		titleLabel.textColor = [AlphaStyle brownColor];
		titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		[self addSubview:titleLabel];
		
		textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		textLabel.numberOfLines = 0;
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.font = [UIFont systemFontOfSize:16];
		textLabel.textColor = [AlphaStyle brownColor];	
		textLabel.lineBreakMode = UILineBreakModeWordWrap;
		[self addSubview:textLabel];
		
	}
	return self;
}


-(void)dealloc {
	[titleLabel release];
	[textLabel release];
	[super dealloc];
}


-(void)populateTitle:(NSString *)title
				text:(NSString *)text {
	
	float y = 10;

	// title
	
	CGSize titleSize = [title sizeWithFont:titleLabel.font
						 constrainedToSize:CGSizeMake(290, 100)
							 lineBreakMode:titleLabel.lineBreakMode];
	
	titleLabel.frame = CGRectMake(10, y, 290, titleSize.height);
	titleLabel.text = title;
	
	y += titleSize.height + 10;
	
	// text
	
	CGSize textSize = [text sizeWithFont:textLabel.font
					   constrainedToSize:CGSizeMake(290, 9999)
						   lineBreakMode:textLabel.lineBreakMode];
	
	textLabel.frame = CGRectMake(10, y, 290, textSize.height);
	textLabel.text = text;

	// make sure scrolling is correct
	
	y += textSize.height + 10;
	
	self.contentSize = CGSizeMake(320, y + 10);
}

@end


