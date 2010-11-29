// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface JsonModel : TTURLRequestModel {

	NSString *_url;
	NSObject *_parsedObject;

}

@property (nonatomic, readonly) NSString *url;
@property (nonatomic, retain) id parsedObject;

-(id)initWithURL:(NSString *)url;

@end
