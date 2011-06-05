//
//  RootViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MILoginViewController.h"
#import "UIAlertView+NWToolbox.h"
#import "MICouponsTableViewController.h"

@implementation MILoginViewController
@synthesize delegate, connection;

- (BOOL)shouldLogin:(NSString**)problem {
    if ([[usernameTextField text] isEqualToString:@""] || [usernameTextField text] == nil) {
        *problem = @"Can't go anonymous!!";
        [usernameTextField becomeFirstResponder];
        return NO;
    } else if ([[passwordTextField text] isEqualToString:@""] || [passwordTextField text] == nil) {
        *problem = @"What's the password?";
        [passwordTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)loginAction:(id)sender {
    NSAssert(alert == nil, @"whoops already loggin in?");
    if (alert)
        return;
    
    NSAssert(connection == nil, @"whoops connection already created?");
    if (connection)
        return;
    
    NSString* problem = nil;
    BOOL shouldLogin = [self shouldLogin:&problem];
    if (shouldLogin) {
        connection = [[MIBackendConnection alloc] initWithUsername:usernameTextField.text password:passwordTextField.text];
        [connection loginWithDelegate:self];
        alert = [UIAlertView showActivityAlertWithTitle:@"Logging in" message:@"Hang on..."];
        // Debug
        [self performSelector:@selector(loginFinished) withObject:nil afterDelay:1.0];
    } else {
        [UIAlertView showBasicAlertWithTitle:nil message:problem];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"DealMe-Login-Button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
}

- (void)dealloc {
    [loginButton release];
    [usernameTextField release];
    [passwordTextField release];
    [problemLabel release];
    [connection release]; connection = nil;
    [scrollView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [loginButton release];
    loginButton = nil;
    [usernameTextField release];
    usernameTextField = nil;
    [passwordTextField release];
    passwordTextField = nil;
    [problemLabel release];
    problemLabel = nil;
    [scrollView release];
    scrollView = nil;
   [super viewDidUnload];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == usernameTextField){
        [passwordTextField becomeFirstResponder];
    } else if(textField == passwordTextField){
        [self loginAction:loginButton];
    }
    return YES;
}


#pragma mark -
#pragma mark MILoginDelegate

- (void)loginFinished {
    [alert dismiss]; alert = nil;
    [delegate loginViewController:self didFinishWithConnection:nil];
}

- (void)loginFailedWithError:(NSError*)error {
    [alert dismiss]; alert = nil;
    [UIAlertView showBasicAlertWithTitle:@"Whoops!" message:[error localizedDescription]];
}

@end
