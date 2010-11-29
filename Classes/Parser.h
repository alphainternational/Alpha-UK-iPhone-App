// Copyright 2010 Brightec Ltd

#import <Foundation/Foundation.h>


@protocol Parser

- (NSObject *)parse:(NSData *)data encoding:(NSStringEncoding)encoding;

@end
