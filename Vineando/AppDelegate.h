//
//  AppDelegate.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 08/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSDictionary *usuario;

@property (strong, nonatomic) NSURL *openedURL;
@property (strong, nonatomic) id<FBGraphUser> user;

@end
