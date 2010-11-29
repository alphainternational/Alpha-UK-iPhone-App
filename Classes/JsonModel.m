// Copyright 2010 Brightec Ltd

#import "JsonModel.h"
#import "JsonParser.h"


@implementation JsonModel

@synthesize url = _url;
@synthesize parsedObject = _parsedObject;


-(id)initWithURL:(NSString *)url {
	if (self = [self init]) {
		_url = [url copy];
	}
	return self;
}	


-(void)dealloc {
	[_url release];
	self.parsedObject = nil;
	[super dealloc];
}


-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	if (!self.isLoading && TTIsStringWithAnyText(self.url)) {
		TTURLRequest *request = [TTURLRequest requestWithURL:self.url
													delegate:self];

		request.cachePolicy = TTURLRequestCachePolicyNone;
		request.cacheExpirationAge = 30;   // seconds
		
		id<TTURLResponse> response = [[TTURLDataResponse alloc] init];
		request.response = response;
		TT_RELEASE_SAFELY(response);
		
		[request send];
	}
}


-(void)requestDidFinishLoad:(TTURLRequest *)request {
	TTURLDataResponse *response = request.response;
	
	JsonParser *parser = [[JsonParser alloc] init];
	
	self.parsedObject = [parser parse:response.data encoding:NSUTF8StringEncoding];
	
	[super requestDidFinishLoad:request];
	[parser release];
}


@end
