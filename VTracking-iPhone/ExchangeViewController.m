//
//  ExchangeViewController.m
//  VTracking-iPhone
//
//  Created by WangYZ on 27/10/15.
//  Copyright © 2015 WangYZ. All rights reserved.
//

#import "ExchangeViewController.h"
#import "BarcodeScanViewController.h"

@interface ExchangeViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSArray *orders;

@end

@implementation ExchangeViewController
@synthesize orders = _orders;
@synthesize exchangeCodeTextField;

- (NSArray *)orders
{
    if (!_orders)
    {
        _orders = [[NSArray alloc] init];
    }
    return _orders;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)hideKeyboard:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.order) {
        self.tracknumberLabel.text = self.order.do_number;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ScanView"])
    {
        UINavigationController *navigationController =
        segue.destinationViewController;
        BarcodeScanViewController
        *ViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
        ViewController.delegate = self;
    }
}

- (IBAction)scanBarcode:(id)sender {
    [self performSegueWithIdentifier: @"ScanView" sender: self];
    
    
}


- (IBAction)SubmitButton:(id)sender {
    //TODO valuate TRIM the space
    if ([self.exchangeCodeTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"The Exchange Code can't be EMPTY!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        NSString *warningMessage = [[NSString alloc] initWithFormat:@"Tracking Number: %@ Exchange Code: %@",self.order.do_number,self.exchangeCodeTextField.text];
        UIAlertController *alert=   [UIAlertController
                                     alertControllerWithTitle:@"Exchange Confirm"
                                     message:warningMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesButton = [UIAlertAction
                                    actionWithTitle:@"Confirmed"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                        if([self.delegate respondsToSelector:@selector(exchangeViewController:exchangeConfirmed:remarks:)])
                                        {
                                            [self.delegate exchangeViewController:self exchangeConfirmed:self.exchangeCodeTextField.text remarks:self.remarksTextView.text];
                                        }
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
        UIAlertAction *noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)CancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)evaluateExchangeCode
{
    if (![exchangeCodeTextField.text hasPrefix:@"YE"])
    {
        NSString *warningMessage = [[NSString alloc] initWithFormat:@"%@ is not an Exchange Code, Please scan again.",exchangeCodeTextField.text];
        UIAlertController *alert=   [UIAlertController
                                     alertControllerWithTitle:@"Warning"
                                     message:warningMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        exchangeCodeTextField.text = @"";
    }
}


#pragma mark - BarcodeScanViewControllerDelegate

- (void)BarcodeScanViewControllerDidCancel:(BarcodeScanViewController *)controller
{
    NSLog(@"cancel---2");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)BarcodeScanViewController:(BarcodeScanViewController *)controller scanDone:(NSString *)scanResult
{
    exchangeCodeTextField.text = scanResult;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self evaluateExchangeCode];
}

@end
