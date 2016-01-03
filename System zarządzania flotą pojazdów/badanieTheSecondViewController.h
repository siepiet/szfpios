//
//  badanieTheSecondViewController.h
//  System zarządzania flotą pojazdów
//
//  Created by user on 02.01.2016.
//  Copyright © 2016 Mateusz Siepietowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface badanieTheSecondViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dataTextField;
@property (weak, nonatomic) IBOutlet UITextField *opisTextField;
@property (weak, nonatomic) IBOutlet UITextField *typTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButtonClicked;
@property(strong, nonatomic) NSString *idOplaty;

@property (strong, nonatomic) UIDatePicker *datePicker;

@end
