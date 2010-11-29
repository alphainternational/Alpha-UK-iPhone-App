// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Row.h"


@interface Section : NSObject {

    NSString *title;
    NSMutableArray *_rows;
    
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSMutableArray *_rows;

-(void)addRow:(id<Row>)r;
-(id<Row>)rowAtIndex:(NSUInteger)index;
-(NSUInteger)numberOfRows;

@end
