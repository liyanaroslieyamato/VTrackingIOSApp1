//
//  DetailViewController.m
//  VTracking-iPhone
//
//  Created by WangYZ on 1/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import "DetailViewController.h"
#import <RestKit/RestKit.h>
#import "StatusUpdateResponse.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) NSArray *responseStatus;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *currentLocation;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *exchangeCode;
@property (nonatomic, strong) NSString *undeliveredReason;

- (void)UpdateStatusWithServer:(NSInteger)StatusID;

@end

@implementation DetailViewController

@synthesize locationManager;
@synthesize geocoder;
@synthesize placemark;
@synthesize longitude;
@synthesize latitude;
@synthesize currentLocation;
@synthesize remarks;
@synthesize exchangeCode;
@synthesize undeliveredReason;

@synthesize tracknumberLabel;
@synthesize senderLabel;
@synthesize receiverLabel;
@synthesize postcodeLabel;
@synthesize addressLabel;
@synthesize remarksTextView;
@synthesize contactLabel;
@synthesize oRemarksLabel;
@synthesize cod_amountLabel;
@synthesize order_typeLabel;
@synthesize exchangeCodeLabel;
@synthesize paymentModeLabel;

@synthesize order = _order;

#pragma mark - Managing the detail item

//- (void)setOrder:(Order *)oneOrder {
//    if (_order != oneOrder) {
//        _order = oneOrder;
//
//    }
//}

- (Order *)order
{
    
    if (!_order)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please stop the app, delete it from the work queue, start again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    return _order;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
    [self startSignificantChangeUpdates];
}

-(IBAction)hideKeyboard:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - About View

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.order) {
        self.tracknumberLabel.text = self.order.do_number;
        self.senderLabel.text = self.order.s_name;
        self.receiverLabel.text = self.order.r_name;
        self.cod_amountLabel.text = self.order.cod_amount;
        self.order_typeLabel.text = self.order.order_type;
        if (self.order.payment_term) {
            self.paymentModeLabel.text = [NSString stringWithFormat:@"%@ Amount",self.order.payment_term];
        }
        else
            self.paymentModeLabel.text = [NSString stringWithFormat:@" Amount"];
        
        if (!self.order.r_address1)
            self.order.r_address1 = @"-";
        if (!self.order.r_address2)
            self.order.r_address2 = @"-";
        if (!self.order.r_address3)
            self.order.r_address3 = @"-";
        self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@",self.order.r_address1,self.order.r_address2,self.order.r_address3];
        
        if (!self.order.r_contact_number1)
            self.order.r_contact_number1 = @"-";
        if (!self.order.r_contact_number2)
            self.order.r_contact_number2 = @"-";
        self.contactLabel.text = [NSString stringWithFormat:@"%@, %@",self.order.r_contact_number1,self.order.r_contact_number2];
        
        self.postcodeLabel.text = self.order.r_postcode;
        self.oRemarksLabel.text = self.order.remarks;
        self.exchangeCodeLabel.text = self.order.exchange_code;
         
    }
}

- (void)startSignificantChangeUpdates
{
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy =
        kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
        self.geocoder = [[CLGeocoder alloc] init];
    }
    [self.locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
}

- (IBAction)OutForDeliveryConfirm:(UIButton *)sender {
    [self UpdateStatusWithServer:2];
}

- (IBAction)DeliveredConfirm:(UIButton *)sender {
    if ([self.order.order_type isEqualToString:@"Exchange"]) {
        if (self.order.exchange_code == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"This order can't be delivered without exchange"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;

        }
    }
    NSString *warningMessage = [[NSString alloc] initWithFormat:@"Tracking Number: %@ Delivered.",self.order.do_number];
    UIAlertController *alert=   [UIAlertController
                                 alertControllerWithTitle:@"Delivered Confirm?"
                                 message:warningMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                    [self UpdateStatusWithServer:3];
                                    
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

- (IBAction)UndeliveredConfirm:(UIButton *)sender {
    self.remarks = self.remarksTextView.text;
    if ([[self.remarks stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The Remarks should NOT be EMPTY!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self UpdateStatusWithServer:7];
    }
}

- (IBAction)CustomerSidePickedUpConfirm:(UIButton *)sender {
    [self UpdateStatusWithServer:6];
}

- (IBAction)ReturnToHubConfirm:(UIButton *)sender {
    [self UpdateStatusWithServer:8];
}

- (IBAction)ReturnToSenderConfirm:(UIButton *)sender {
    [self UpdateStatusWithServer:9];
}

- (IBAction)WarehouseReceivedConfirm:(UIButton *)sender {
    [self UpdateStatusWithServer:10];
}

- (IBAction)ExchangeConfirm:(UIButton *)sender {
    //[self UpdateStatusWithServer:11];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];

    ExchangeViewController *exchangeView = [storyboard instantiateViewControllerWithIdentifier:@"ExchangeView"];
    
    Order *order = self.order;
    [exchangeView setOrder:order];
    exchangeView.delegate = self;
    
    [self presentViewController:exchangeView
                       animated:YES
                     completion:nil];
}

- (void)UpdateStatusWithServer:(NSInteger)StatusID{
    [self.activityIndicatorView startAnimating];
    
    RKObjectMapping *UserMapping = [RKObjectMapping mappingForClass:[StatusUpdateResponse class]];
    [UserMapping addAttributeMappingsFromDictionary:@{ @"status": @"status" }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:UserMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/lswtal.json"
                                                 keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.remarks = self.remarksTextView.text;
    if (!self.exchangeCodeLabel.text) {
        self.exchangeCode = @"";
    }
    else
        self.exchangeCode = self.exchangeCodeLabel.text;
    NSDictionary *queryParams = @{@"do_number" : self.order.do_number,
                                  @"status_id" : [NSString stringWithFormat:@"%ld",(long)StatusID],
                                  @"responsible" : [defaults objectForKey:@"user_work_id"],
                                  @"handset_user_id" : [defaults objectForKey:@"handset_user_id"],
                                  @"longitude" : self.longitude,
                                  @"latitude" : self.latitude,
                                  @"location": self.currentLocation,
                                  @"exchange_code": self.exchangeCode,
                                  @"remarks": self.remarks
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/lswtal.json"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _responseStatus = mappingResult.array;
                                                  [self.activityIndicatorView stopAnimating];
                                                  
                                                  [self showSuccess];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];

}

- (void)showSuccess
{
    if (_responseStatus.count == 1) {
        StatusUpdateResponse *status = _responseStatus[0];
        if ([status.status isEqualToString:@"success"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"The Order Updated."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([status.status isEqualToString:@"fail"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Some error happened. Please try again!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }

}

#pragma ExchangeViewController Delegate
- (void)exchangeViewController:(ExchangeViewController *)controller exchangeConfirmed:(NSString *)exchangeCode remarks:(NSString *)exchangeRemarks
{
    self.exchangeCodeLabel.text = exchangeCode;
    self.remarksTextView.text = exchangeRemarks;
    
    [self UpdateStatusWithServer:11];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
         //If the event is recent, do something with it.
        self.longitude = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
        self.latitude = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
    }
    
    [locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.longitude = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
            self.latitude = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
            //////////////////////////////////
            self.currentLocation = [[NSString alloc] init];
            if (placemark.subThoroughfare != nil) {
                self.currentLocation = [self.currentLocation stringByAppendingString:[NSString stringWithFormat:@"%@", placemark.subThoroughfare]];
            }
            if (placemark.thoroughfare != nil) {
                self.currentLocation = [self.currentLocation stringByAppendingString:[NSString stringWithFormat:@" %@", placemark.thoroughfare]];
            }
            if (placemark.postalCode != nil) {
                self.currentLocation = [self.currentLocation stringByAppendingString:[NSString stringWithFormat:@"\n%@", placemark.postalCode]];
            }
            if (placemark.locality != nil) {
                self.currentLocation = [self.currentLocation stringByAppendingString:[NSString stringWithFormat:@" %@", placemark.locality]];
            }
            if (placemark.administrativeArea != nil) {
                self.currentLocation = [self.currentLocation stringByAppendingString:[NSString stringWithFormat:@"\n%@", placemark.administrativeArea]];
            }
            if (placemark.country != nil) {
                self.currentLocation = [self.currentLocation stringByAppendingString:[NSString stringWithFormat:@"\n%@", placemark.country]];
            }
            
//            self.currentLocation = [NSString str:@"%@ %@\n%@ %@\n%@\n%@",
//                                 placemark.subThoroughfare, placemark.thoroughfare,
//                                 placemark.postalCode, placemark.locality,
//                                 placemark.administrativeArea,
//                                 placemark.country];
            if (!self.currentLocation) {
                self.currentLocation = @"-";
            }
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];

}

@end
