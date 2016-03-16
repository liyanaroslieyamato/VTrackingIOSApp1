//
//  BarcodeScanViewController.h
//
//  Created by Vic Wang on 1/Sep/15.
//
//

#import <UIKit/UIKit.h>

@class BarcodeScanViewController;

@protocol BarcodeScanViewControllerDelegate <NSObject>
- (void)BarcodeScanViewControllerDidCancel:(BarcodeScanViewController *)controller;
- (void)BarcodeScanViewController:(BarcodeScanViewController *)controller scanDone:(NSString *)scanResult;
@end


@interface BarcodeScanViewController : UIViewController

@property (nonatomic, weak) id <BarcodeScanViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;

@end
