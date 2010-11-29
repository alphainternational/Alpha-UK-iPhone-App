// Copyright 2010 Brightec Ltd

#import "Section.h"


@implementation Section

@synthesize title;
@synthesize _rows;


-(id)init {
    if (self = [super init]) {
        self._rows = [NSMutableArray array];
    }
    return self;
}


-(void)dealloc {
    self.title = nil;
    self._rows = nil;
    [super dealloc];
}


-(void)addRow:(id<Row>)r {
    [_rows addObject:r];
}


-(id<Row>)rowAtIndex:(NSUInteger)index {
    return [_rows objectAtIndex:index];
}


-(NSUInteger)numberOfRows {
    return [_rows count];
}


@end
