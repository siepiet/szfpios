//
//  ViewController.m
//  SidebarDemo
//
//  Created by Mateusz Siepietowski on 28.12.2015.
//  Copyright © 2015 SZFP. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@property (strong, nonatomic) NSString *reply;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableData *carData;
@property (strong, nonatomic) NSString *imie;
@property (strong, nonatomic) NSString *nazwisko;
@property (strong, nonatomic) NSString *idpoj;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Dane pojazdu";
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.zalogowanoLabel.text = appDel.idKierowcy;
    self.zalogowano = appDel.idKierowcy;
    NSLog(@"id: %@", appDel.idKierowcy);
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController)
    {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self network];
    
}

-(void)network
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *post = [NSString stringWithFormat:@"idKierowcy=%@&request=getData", self.zalogowano];
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
        self.webData = [[NSMutableData alloc] init];
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
    [self.webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    //appDel.idPojazdu = nil;
    NSDictionary *all = [NSJSONSerialization JSONObjectWithData:self.webData options:0 error:nil];
    NSLog(@"%@", all);
    self.imie = [all objectForKey:@"imieKierowcy"];
    self.nazwisko = [all objectForKey:@"nazwiskoKierowcy"];
    self.zalogowanoLabel.text = [NSString stringWithFormat:@"Zalogowano: %@ %@", self.nazwisko, self.imie];
    self.idpoj = [all objectForKey:@"idPojazdu"];
    self.label1.text = [all objectForKey:@"markaPojazdu"];
    self.label2.text = [all objectForKey:@"modelPojazdu"];
    self.label3.text = [all objectForKey:@"rejestracjaPojazdu"];
    self.label4.text = [all objectForKey:@"przebiegTankowania"];
    self.label5.text = [all objectForKey:@"rodzajPaliwa"];
    //AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appDel.idPojazdu = [all objectForKey:@"idPojazdu"];
    //wstawic animacje wjazdu labelek 
}





- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}










/***********************
-(void)viewWillAppear:(BOOL)animated
{
    [self showzal];
}

-(void)showzal
{
    NSLog(@"test: %@", self.zalogowano);
}
***********************/


@end
