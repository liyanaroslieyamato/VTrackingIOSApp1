//
//  LoginViewController.h
//  VTracking-iPhone
//
//  Created by WangYZ on 2/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <RSBarcodes/RSBarcodes.h>
#import "BarcodeScanViewController.h"

@interface LoginViewController : UIViewController<BarcodeScanViewControllerDelegate>
{
    RSScannerViewController *scanner;
}
- (IBAction)SubmitButton:(id)sender;


@end
