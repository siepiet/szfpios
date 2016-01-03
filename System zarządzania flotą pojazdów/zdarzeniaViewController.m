//
//  zdarzeniaViewController.m
//  SidebarDemo
//
//  Created by Mateusz Siepietowski on 28.12.2015.
//  Copyright © 2015 SZFP. All rights reserved.
//

#import "zdarzeniaViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"


@implementation zdarzeniaViewController
{
    NSString *idPojazdu;
    NSString *idKierowcy;
    NSArray *zdarzenia;
    NSArray *opisZdarzen;
    NSString *typZdarzenia;
}

@synthesize zdarzeniePicker;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Dodaj zdarzenie";
    
    zdarzenia = [[NSArray alloc] initWithObjects:@"",@"1",@"2",@"3",@"4", nil];
    opisZdarzen = [[NSArray alloc] initWithObjects:@"",@"Stłuczka z powodu kierowcy",@"Stłuczka z powodu innego kierowcy",@"Stłuczka z nieznanym sprawcą",@"Awaria", nil];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController)
    {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self now:[NSDate date]];
    self.dataTextField.enabled = NO;
    
    zdarzeniePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    zdarzeniePicker.delegate = self;
    zdarzeniePicker.dataSource = self;
    [zdarzeniePicker setShowsSelectionIndicator:YES];
    self.typZdarzeniaTextField.inputView = zdarzeniePicker;
    
    //[zdarzeniePicker release];
    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.typZdarzeniaTextField.text = [NSString stringWithFormat:@"%@", [opisZdarzen objectAtIndex:row]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return opisZdarzen.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [opisZdarzen objectAtIndex:row];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

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

- (IBAction)sendButtonClicked:(id)sender
{
    if(self.dataTextField.text.length == 0)
    {
        UIAlertView *dataAlert = [[UIAlertView alloc] initWithTitle:@"Podaj datę" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [dataAlert show];
    }
    else
    {
        
        if (self.typZdarzeniaTextField.text.length == 0)
        {
            UIAlertView *typAlert = [[UIAlertView alloc] initWithTitle:@"Podaj zdarzenia" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [typAlert show];
        }
        else
        {
            if(self.opisTextField.text == 0)
            {
                UIAlertView *opisAlert = [[UIAlertView alloc] initWithTitle:@"Podaj opis" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [opisAlert show];

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

-(NSString *)decide
{
    if ([self.typZdarzeniaTextField.text isEqualToString:@"Stłuczka z powodu kierowcy"])
    {
        typZdarzenia = @"1";
    }
    else if ([self.typZdarzeniaTextField.text isEqualToString:@"Stłuczka z powodu innego kierowcy"])
    {
        typZdarzenia = @"2";
    }
    else if ([self.typZdarzeniaTextField.text isEqualToString:@"Stłuczka z nieznanym sprawcą"])
    {
        typZdarzenia = @"3";
    }
    else if ([self.typZdarzeniaTextField.text isEqualToString:@"Awaria"])
    {
        typZdarzenia = @"4";
    }
    else
    {
        typZdarzenia = @"4";
    }
    return typZdarzenia;
}
-(void)network
{
    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
    idKierowcy = appDel.idKierowcy;
    idPojazdu = appDel.idPojazdu;
    
    [self decide];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *post = [NSString stringWithFormat:@"typZdarzenia=%@&idPojazdu=%@&idKierowcy=%@&opisZdarzenia=%@&dataZdarzenia=%@&request=dodajZdarzenie", typZdarzenia, idPojazdu, idKierowcy, self.opisTextField.text, self.dataTextField.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://szfp.mybluemix.net"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
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
    self.sendButton.titleLabel.text = @"Wysłano zdarzenie!";
    [NSThread sleepForTimeInterval:2.0f];
    //[self performSegueWithIdentifier:@"Pobadaniu" sender:self];
    
}

@end
