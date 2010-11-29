// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Section.h"
#import "Row.h"


@interface Table : NSObject <Row> {

    NSMutableArray *_sections;
	NSString *_title;

}

@property (nonatomic, retain) NSArray *_sections;
@property (nonatomic, retain) NSString *title;

-(void)addSection:(Section *)s;
-(Section *)sectionAtIndex:(NSUInteger)index;
-(NSUInteger)numberOfSections;

@end
