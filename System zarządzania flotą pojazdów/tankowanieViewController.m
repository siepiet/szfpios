//
//  tankowanieViewController.m
//  SidebarDemo
//
//  Created by Mateusz Siepietowski on 28.12.2015.
//  Copyright © 2015 SZFP. All rights reserved.
//

#import "tankowanieViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "tankowanieTheSecondViewController.h"

@interface tankowanieViewController ()
{
    NSDictionary *tankowanie;
    NSString *idKierowcy;
    NSString *idPojazdu;
    NSString *dataOplaty;
    NSString *nrFaktury;
    NSString *wartoscOplaty;
    NSMutableData *webData;
    NSString *idOplaty;
}
@end

@implementation tankowanieViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
        if(self.wartoscTextField.text.length == 0)
        {
            UIAlertView *przebiegAlert = [[UIAlertView alloc] initWithTitle:@"Podaj wartość" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [przebiegAlert show];
        }
        else
        {
            if (self.nrFakturyTextField.text.length == 0)
            {
                UIAlertView *litryAlert = [[UIAlertView alloc] initWithTitle:@"Podaj numer faktury" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [litryAlert show];
            }
            else
            {
                self.textLabel.text = [NSString stringWithFormat:@"Sent"];
                [self network];
                self.sendButton.enabled = NO;
            }
        }
    }
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Dodaj opłatę";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController)
    {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self now:[NSDate date]];
    self.dataTextField.enabled = NO;
    
}


-(void)network
{
    
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    idKierowcy = appDel.idKierowcy;
    idPojazdu = appDel.idPojazdu;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *post = [NSString stringWithFormat:@"idKierowcy=%@&idPojazdu=%@&wartoscOplaty=%@&dataOplaty=%@&nrFaktury=%@&request=dodajOplate", idKierowcy,idPojazdu, self.wartoscTextField.text, self.dataTextField.text, self.nrFakturyTextField.text];
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
    [webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *oplata = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    NSLog(@"%@", oplata);
    idOplaty = [oplata objectForKey:@"idOplaty"];
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appDel.idOplaty = idOplaty;
    
    self.sendButton.titleLabel.text = @"Wysłano opłatę";
    
    if (idOplaty != nil) {
        [self performSegueWithIdentifier:@"tankowanie" sender:self];
    }
    //wstawic animacje wjazdu labelek
}
/*
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    bool segueShouldOccur = NO;
    if([identifier isEqualToString:@"tankowanie"])
    {
        if (idOplaty == nil)
        {
            return  NO;
        }
    }
    return YES;
}
*/
- (void)now:(NSDate *)datetime
{
    // Purpose: Return a string of the current date-time in UTC (Zulu) time zone in ISO 8601 format.
    //[self toStringFromDateTime:[NSDate date]];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateTimeNow = [dateFormatter stringFromDate:datetime];
    self.dataTextField.text = dateTimeNow;
}

@end
