// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class JsonModel;


@interface TableDataSource : TTSectionedDataSource {
	
}

-(id)initWithJsonModel:(JsonModel *)model;

@end
