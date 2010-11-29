// Copyright 2010 Brightec Ltd

#import "AlphaStyle.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation AlphaStyle


+(UIColor *)lightYellowColor {
	return UIColorFromRGB(0xfffbf0);
}

+(UIColor *)brownColor {
	return UIColorFromRGB(0x6b4c1d);
}

+(UIColor *)lightGrayColor {
	return UIColorFromRGB(0x999999);
}

+(UIColor *)tintColor {
	return UIColorFromRGB(0x222222);
}

+(UIColor *)searchTintColor {
	return [UIColor colorWithRed:0.497 green:0.592 blue:0.637 alpha:1.000];
}


// three20 stylesheet stuff

-(UIColor *)navigationBarTintColor {
	//return [AlphaStyle tintColor];
	return [UIColor colorWithRed:0.497 green:0.592 blue:0.637 alpha:1.000];	
}


@end
