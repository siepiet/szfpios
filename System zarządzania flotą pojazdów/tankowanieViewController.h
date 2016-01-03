//
//  tankowanieViewController.h
//  SidebarDemo
//
//  Created by Mateusz Siepietowski on 28.12.2015.
//  Copyright © 2015 SZFP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tankowanieViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITextField *wartoscTextField;
@property (weak, nonatomic) IBOutlet UITextField *nrFakturyTextField;
@property (weak, nonatomic) IBOutlet UITextField *dataTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
