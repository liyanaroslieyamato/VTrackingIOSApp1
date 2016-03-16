//
//  LoginViewController.m
//  VTracking-iPhone
//
//  Created by WangYZ on 2/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import "LoginViewController.h"
#import <RestKit/RestKit.h>
#import "User.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSString *scanned_text;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UITextField *user_name;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LoginViewController

@synthesize scanned_text;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self displayVersion];
}

- (void)displayVersion
{
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString * versionBuildString = [NSString stringWithFormat:@"Version: %@ (%@)", appVersionString, appBuildString];
    
    self.versionLabel.text = versionBuildString;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - BarcodeScanViewControllerDelegate

- (void)BarcodeScanViewControllerDidCancel:(BarcodeScanViewController *)controller
{
    NSLog(@"cancel---2");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)BarcodeScanViewController:(BarcodeScanViewController *)controller scanDone:(NSString *)scanResult
{
    NSLog(@"done---2");
    self.scanned_text = scanResult;
    [self check_id];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)initScanView
{
    scanner = [[RSScannerViewController alloc]
               initWithCornerView:YES
               controlView:YES
               barcodesHandler:^(NSArray *barcodeObjects) {
                   if (barcodeObjects.count > 0) {
                       [barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                               
                               // DATA PROCESSING 1
                               AVMetadataMachineReadableCodeObject *code = obj;
                               
                               self.scanned_text = code.stringValue;
                               [self check_id];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   // UI UPDATION 1
                                   [scanner dismissViewControllerAnimated:true completion:nil];
                               });
                               
                               /* I expect the control to come here after UI UPDATION 1 */
                               
                               // DATA PROCESSING 2
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   // UI UPDATION 2
                                   //                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Barcode found"
                                   //                                             message:code.stringValue
                                   //                                             delegate:self
                                   //                                             cancelButtonTitle:@"OK"
                                   //                                             otherButtonTitles:nil];
                                   //                                             [scanner dismissViewControllerAnimated:true completion:nil];
                                   //                                  [alert show];
                                   
                               });
                               
                               /* I expect the control to come here after UI UPDATION 2 */
                               
                               // DATA PROCESSING 3
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   // UI UPDATION 3
                                   
                               });
                               
                           });
                           
                           
                           
                       }];
                   }
               }
               
               preferredCameraPosition:AVCaptureDevicePositionBack];
    
    [scanner setIsButtonBordersVisible:YES];
    [scanner setStopOnFirst:YES];
    
}



- (void)check_id
{
    [self.activityIndicatorView startAnimating];

    // setup object mappings
    RKObjectMapping *UserMapping = [RKObjectMapping mappingForClass:[User class]];
    [UserMapping addAttributeMappingsFromDictionary:@{ @"handset_user_id": @"handset_user_id",
                                                       @"work_id": @"work_id",
                                                       @"name": @"name",
                                                       @"status": @"status"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:UserMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/check_id.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParams = @{@"work_id" : self.scanned_text};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/check_id.json"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   _users = mappingResult.array;
                                                  [self.activityIndicatorView stopAnimating];
                                                  [self loginSuccess];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.description
                                                        delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
                                                            [alert show];
                                              }];
}

- (IBAction)SubmitButton:(id)sender {
    [self check_id];
}
//
//- (IBAction)scanBarcode:(id)sender {
//    [self presentViewController:scanner animated:YES completion:nil];
//    
//}

- (void)loginSuccess {
    if (_users.count == 1) {
        User *user = _users[0];
        if ([user.status isEqualToString:@"exist"]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:user.name forKey:@"user_name"];
            [defaults setObject:user.work_id forKey:@"user_work_id"];
            [defaults setObject:user.handset_user_id forKey:@"handset_user_id"];
            [defaults synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:user.name
                                                            message:@"Login Successfully!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            [self dismissViewControllerAnimated:YES completion:Nil];
        }else if ([user.status isEqualToString:@"none"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Sorry this account can't access!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
}
@end
