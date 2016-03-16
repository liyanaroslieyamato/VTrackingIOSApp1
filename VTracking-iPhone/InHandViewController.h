//
//  InHandViewController.h
//  VTracking-iPhone
//
//  Created by WangYZ on 24/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <RSBarcodes/RSBarcodes.h>
#import "BarcodeScanViewController.h"

@interface InHandViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, BarcodeScanViewControllerDelegate>
{
    RSScannerViewController *scanner;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;




@end
