//
//  loginPageViewController.m
//  SZFPv2
//
//  Created by Mateusz Siepietowski on 28.12.2015.
//  Copyright © 2015 SZFP. All rights reserved.
//

#import "loginPageViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface loginPageViewController () <UITextFieldDelegate>
{
    NSMutableData *webData;
    NSString *login;
    NSString *password;
}
@end

@implementation loginPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self idTextField] setDelegate:self];
    
    _ids = @[@"1",@"2"];
    
}

/*
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    bool segueShouldOccur = NO;
    if([identifier isEqualToString:@"loginsegue"])
    {
        if (self.idTextField.text.length !=0)
        {
            segueShouldOccur = YES;
            return segueShouldOccur;
        }
        if (!segueShouldOccur) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Niepoprawny identyfikator" message:@"Identyfikator musi składać się z 4 cyfr" delegate:nil cancelButtonTitle:@"Popraw" otherButtonTitles:nil, nil];
            [alert show];
            
            return  NO;
        }
    
    }
    
    return YES;

}
*/
-(void)textFieldDidEndEditing:(UITextField *)TextField
{
    login = self.idTextField.text;
    NSLog(@"login: %@", login);
    [self network];
}

-(void)network
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *post = [NSString stringWithFormat:@"idKierowcy=%@&request=logowanie",login];
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
        webData = [[NSMutableData alloc] init];
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
    [webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    //appDel.idPojazdu = nil;
    NSDictionary *all = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    NSLog(@"all: %@", all);
    password = [all objectForKey:@"password"];
    appDel.password = password;
    
}





-(IBAction)loginButtonClicked
{
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appDel.idKierowcy = self.idTextField.text;
    
    if(self.idTextField.text.length == 0)
    {
        UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:@"Podaj identyfikator kierowcy!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [dataAlert show];
        
    }
    else
    {
        if(self.passwordTextField.text.length == 0)
        {
            UIAlertView *przebiegAlert = [[UIAlertView alloc] initWithTitle:@"Podaj hasło!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [przebiegAlert show];
        }
        else
        {
            if ([self.passwordTextField.text isEqualToString:password])
            {
                [self performSegueWithIdentifier:@"loginsegue" sender:self];
            }
            else
            {
                UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Niepoprawny login lub hasło" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [passwordAlert show];

            }
        }
    }

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.idTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[MainViewController class]])
    {
        MainViewController *mvc = (MainViewController *) segue.destinationViewController;
        mvc.zalogowano = self.idTextField.text;
    }
}


@end
