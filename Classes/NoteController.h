// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class NoteView;


@interface NoteController : TTViewController <TTPostControllerDelegate> {

	NSString *_filename;
	NSString *_subtitle;
	NSString *_text;
	NoteView *_noteView;
	
}

@property (nonatomic, readonly) NSString *filename;
@property (nonatomic, readonly) NSString *subtitle;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NoteView *noteView;

-(id)initWithNavigatorURL:(NSURL *)url query:(NSDictionary*)query;

@end


#pragma mark -
#pragma mark NoteView


@interface NoteView : UIScrollView {

	UILabel *titleLabel;
	UILabel *textLabel;

}

-(void)populateTitle:(NSString *)title text:(NSString *)text;

@end

