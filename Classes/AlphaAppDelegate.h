// Copyright 2010 Brightec Ltd

#import <UIKit/UIKit.h>


@interface AlphaAppDelegate : NSObject <UIApplicationDelegate, UITabBarDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

