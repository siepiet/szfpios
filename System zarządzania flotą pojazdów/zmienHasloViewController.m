//
//  zmienHasloViewController.m
//  System zarządzania flotą pojazdów
//
//  Created by user on 02.01.2016.
//  Copyright © 2016 Mateusz Siepietowski. All rights reserved.
//

#import "zmienHasloViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface zmienHasloViewController ()
{
    NSString *password;
    NSString *newPassword;
    NSString *confirmNewPassword;
    NSString *idKierowcy;
}
@end

@implementation zmienHasloViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Zmień hasło"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController)
    {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}



- (IBAction)sendButtonClicked:(id)sender
{
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    password = appDel.password;
    
    if(self.obecneHasloTextField.text.length == 0)
    {
        UIAlertView *obecneHasloAlert = [[UIAlertView alloc] initWithTitle:@"Podaj obecne hasło!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [obecneHasloAlert show];
        
    }
    else
    {
        if ([self.obecneHasloTextField.text isEqualToString:password])
        {
            if(self.noweHasloTextField.text.length == 0)
            {
                UIAlertView *noweHasloAlert = [[UIAlertView alloc] initWithTitle:@"Podaj nowe hasło!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [noweHasloAlert show];
            }
            else
            {
                if ([self.noweHasloTextField.text isEqualToString:password])
                {
                    UIAlertView *noweHasloAlert = [[UIAlertView alloc] initWithTitle:@"Nowe hasło musi różnić się od obecnego!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [noweHasloAlert show];
                }
                else
                {
                    newPassword = self.noweHasloTextField.text;
                    if ([self.potwierdzNoweHasloTextField.text isEqualToString:newPassword])
                    {
                        [self network];
                        appDel.password = newPassword;
                        self.sendButton.enabled = NO;
                    }
                    else
                    {
                        UIAlertView *potwierdzNoweHasloAlert = [[UIAlertView alloc] initWithTitle:@"Hasła różnią się od siebie!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [potwierdzNoweHasloAlert show];
                    }
                }
            }
        }
        else
        {
            UIAlertView *obecneHasloAlert = [[UIAlertView alloc] initWithTitle:@"Podaj poprawne obecne hasło!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [obecneHasloAlert show];
        }
    }
}

-(void)network
{
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    idKierowcy = appDel.idKierowcy;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *post = [NSString stringWithFormat:@"idKierowcy=%@&noweHaslo=%@&request=zmienHaslo",idKierowcy, newPassword];
    NSLog(post);
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
    self.sendButton.titleLabel.text = @"Zmieniono hasło";
}

@end
