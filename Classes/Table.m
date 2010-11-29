// Copyright 2010 Brightec Ltd

#import "Table.h"


@implementation Table

@synthesize _sections;
@synthesize title = _title;


-(id)init {
    if (self = [super init]) {
        self._sections = [NSMutableArray array];
    }
    return self;
}


-(void)dealloc {
    self._sections = nil;
    [super dealloc];
}


-(void)addSection:(Section *)s {
    [_sections addObject:s];
}


-(Section *)sectionAtIndex:(NSUInteger)index {
    return [_sections objectAtIndex:index];
}


-(NSUInteger)numberOfSections {
    return [_sections count];
}


@end
