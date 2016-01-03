//
//  badanieTheSecondViewController.m
//  System zarządzania flotą pojazdów
//
//  Created by user on 02.01.2016.
//  Copyright © 2016 Mateusz Siepietowski. All rights reserved.
//

#import "badanieTheSecondViewController.h"
#import "AppDelegate.h"

@interface badanieTheSecondViewController ()

@end

@implementation badanieTheSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Dodaj przegląd";
    
    //[self now:[NSDate date]];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:)forControlEvents:UIControlEventValueChanged];
    [self.dataTextField setInputView:datePicker];
    
    
}
-(void)updateTextField:(UIDatePicker *)sender
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSString* dateTimeNow = [dateFormatter stringFromDate:datetime];
    self.dataTextField.text = [dateFormatter stringFromDate:sender.date];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)sendButtonClicked:(id)sender
{
    if(self.dataTextField.text.length == 0)
    {
        UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:@"Podaj datę" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [dataAlert show];
        
    }
    else
    {
        if(self.opisTextField.text.length == 0)
        {
            UIAlertView *przebiegAlert = [[UIAlertView alloc] initWithTitle:@"Podaj opis" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [przebiegAlert show];
        }
        else
        {
            if (self.typTextField.text.length == 0)
            {
                UIAlertView *przebiegAlert = [[UIAlertView alloc] initWithTitle:@"Podaj typ" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [przebiegAlert show];
            }
            else
            {
                [self network];
                self.sendButton.enabled = NO;
            }
        }
    }
}

-(void)network
{
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.idOplaty = appDel.idOplaty;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *post = [NSString stringWithFormat:@"dataNastepnego=%@&opisPrzegladu=%@&idOplaty=%@&typPrzegladu=%@&request=dodajPrzeglad", self.dataTextField.text, self.opisTextField.text, self.idOplaty, self.typTextField.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://szfp.mybluemix.net"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn)
    {
        NSLog(@"Good");
        self.sendButton.enabled = NO;
    }
    else
    {
        NSLog(@"Bad");
    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error");
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.sendButton.titleLabel.text = @"Wysłano przegląd";
    [NSThread sleepForTimeInterval:2.0f];
    //[self performSegueWithIdentifier:@"Pobadaniu" sender:self];
    
}

- (void)now:(NSDate *)datetime
{
    // Purpose: Return a string of the current date-time in UTC (Zulu) time zone in ISO 8601 format.
    //[self toStringFromDateTime:[NSDate date]];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateTimeNow = [dateFormatter stringFromDate:datetime];
    //self.dataTextField.text = dateTimeNow;
}

@end
