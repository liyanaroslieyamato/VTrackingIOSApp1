//
//  DashboardViewController.m
//  VTracking-iPhone
//
//  Created by WangYZ on 2/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import "DashboardViewController.h"
#import "LoginViewController.h"

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation DashboardViewController
@synthesize UserNameLabel;
@synthesize DateLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    LoginViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    
    [self presentViewController:loginView
                       animated:YES
                     completion:nil];
    [self displayVersion];
}

- (void)displayVersion
{
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString * versionBuildString = [NSString stringWithFormat:@"Version: %@ (%@)", appVersionString, appBuildString];
    
    self.versionLabel.text = versionBuildString;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.UserNameLabel.text = [defaults objectForKey:@"user_name"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MMM-yyyy";
    self.DateLabel.text = [formatter stringFromDate:[NSDate date]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GoToOrderBase"]) {
        
    }else if ([[segue identifier] isEqualToString:@"GoToInHand"]) {
        
    }
}


- (IBAction)GoToOrderBase:(UIButton *)sender {
    [self performSegueWithIdentifier:@"GoToOrderBase" sender:self];
}

- (IBAction)GoToInHand:(UIButton *)sender {
    [self performSegueWithIdentifier:@"GoToInHand" sender:self];
}


@end
