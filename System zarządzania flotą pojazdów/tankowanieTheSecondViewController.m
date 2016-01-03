//
//  tankowanieTheSecondViewController.m
//  System zarządzania flotą pojazdów
//
//  Created by user on 01.01.2016.
//  Copyright © 2016 Mateusz Siepietowski. All rights reserved.
//

#import "tankowanieTheSecondViewController.h"
#import "AppDelegate.h"

@interface tankowanieTheSecondViewController ()

@end

@implementation tankowanieTheSecondViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Dodaj tankowanie";
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)sendButtonClicked:(id)sender
{
    if(self.przebiegTextField.text.length == 0)
    {
        UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:@"Podaj przebieg" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [dataAlert show];
        
    }
    else
    {
        if(self.litryTextField.text.length == 0)
        {
            UIAlertView *przebiegAlert = [[UIAlertView alloc] initWithTitle:@"Podaj ilość litrów" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [przebiegAlert show];
        }
        else
        {
            [self network];
            self.sendButton.enabled = NO;
        }
    }
}

-(void)network
{
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.idOplaty = appDel.idOplaty;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *post = [NSString stringWithFormat:@"przebiegTankowania=%@&iloscPaliwa=%@&idOplaty=%@&request=dodajTankowanie", self.przebiegTextField.text, self.litryTextField.text, self.idOplaty];
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
    self.sendButton.titleLabel.text = @"Wysłano tankowanie";
    [NSThread sleepForTimeInterval:2.0f];
    //[self performSegueWithIdentifier:@"Po tankowaniu" sender:self];
}

@end
