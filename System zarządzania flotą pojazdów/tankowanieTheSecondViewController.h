//
//  tankowanieTheSecondViewController.h
//  System zarządzania flotą pojazdów
//
//  Created by user on 01.01.2016.
//  Copyright © 2016 Mateusz Siepietowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tankowanieTheSecondViewController : UIViewController

@property(strong, nonatomic) NSString *idOplaty;

@property (weak, nonatomic) IBOutlet UITextField *przebiegTextField;
@property (weak, nonatomic) IBOutlet UITextField *litryTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@end
