//
//  ExchangeViewController.h
//  VTracking-iPhone
//
//  Created by WangYZ on 27/10/15.
//  Copyright © 2015 WangYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import <CoreLocation/CoreLocation.h>
#import <RSBarcodes/RSBarcodes.h>
#import "BarcodeScanViewController.h"

@class ExchangeViewController;

@protocol ExchangeDelegate <NSObject>

- (void)exchangeViewController:(ExchangeViewController *)controller exchangeConfirmed:(NSString *)exchangeCode remarks:(NSString*)exchangeRemarks;

@end

@interface ExchangeViewController : UIViewController<CLLocationManagerDelegate,BarcodeScanViewControllerDelegate>
{
    RSScannerViewController *scanner;
}

@property (nonatomic, weak) id <ExchangeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *tracknumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *postcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *oRemarksLabel;
@property (weak, nonatomic) IBOutlet UILabel *cod_amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *exchangeCodeTextField;

@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic, retain) CLPlacemark *placemark;
@property (strong, nonatomic) Order *order;


- (IBAction)SubmitButton:(id)sender;
- (IBAction)scanBarcode:(id)sender;
- (IBAction)CancelButton:(id)sender;


@end
