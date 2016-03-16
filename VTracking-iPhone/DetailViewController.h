//
//  DetailViewController.h
//  VTracking-iPhone
//
//  Created by WangYZ on 1/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import <CoreLocation/CoreLocation.h>
#import "ExchangeViewController.h"

@interface DetailViewController : UIViewController <CLLocationManagerDelegate,ExchangeDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tracknumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *postcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *oRemarksLabel;
@property (weak, nonatomic) IBOutlet UILabel *cod_amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentModeLabel;

@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic, retain) CLPlacemark *placemark;
@property (strong, nonatomic) Order *order;


@end

