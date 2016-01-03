//
//  zmienHasloViewController.h
//  System zarządzania flotą pojazdów
//
//  Created by user on 02.01.2016.
//  Copyright © 2016 Mateusz Siepietowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zmienHasloViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITextField *obecneHasloTextField;
@property (weak, nonatomic) IBOutlet UITextField *noweHasloTextField;
@property (weak, nonatomic) IBOutlet UITextField *potwierdzNoweHasloTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonClicked:(id)sender;


@end
