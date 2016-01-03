//
//  badanieViewController.h
//  SidebarDemo
//
//  Created by Mateusz Siepietowski on 28.12.2015.
//  Copyright © 2015 SZFP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface badanieViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITextField *dataTextField;
@property (weak, nonatomic) IBOutlet UITextField *wartoscTextField;
@property (weak, nonatomic) IBOutlet UITextField *numerFakturyTextField;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (IBAction)sendButtonClicked:(id)sender;

@end
