//
//  AppDelegate.h
//  SidebarDemo
//
//  Created by Mateusz Siepietowski on 28.12.2015.
//  Copyright © 2015 SZFP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *idKierowcy;
@property (strong, nonatomic) NSString *idPojazdu;
@property (strong, nonatomic) NSString *idOplaty;
@property (assign, nonatomic) NSUInteger *przebieg;
@property (strong, nonatomic) NSString *password;

@end
