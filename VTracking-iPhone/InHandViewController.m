//
//  InHandViewController.m
//  VTracking-iPhone
//
//  Created by WangYZ on 24/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import "InHandViewController.h"
#import "DetailViewController.h"
#import <RestKit/RestKit.h>
#import "Order.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


@interface InHandViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) NSArray *orders;

@end

@implementation InHandViewController

@synthesize orders = _orders;

- (NSArray *)orders
{
    if (!_orders)
    {
        _orders = [[NSArray alloc] init];
    }
    return _orders;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scanBarcode:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    self.refreshControl.backgroundColor = RGBCOLOR(53,123,253);
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(download_orders)
                  forControlEvents:UIControlEventValueChanged];
    
    //[self download_orders];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self download_orders];
}

//- (void)initScanView
//{
//    scanner = [[RSScannerViewController alloc]
//               initWithCornerView:YES
//               controlView:YES
//               barcodesHandler:^(NSArray *barcodeObjects) {
//                   if (barcodeObjects.count > 0) {
//                       [barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                               
//                               // DATA PROCESSING 1
//                               AVMetadataMachineReadableCodeObject *code = obj;
//                               
//                               NSArray *filtered = [self.orders filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(do_number == %@)", code.stringValue]];
//                               NSDictionary *item = [filtered objectAtIndex:0];
//                               NSInteger anIndex=[self.orders indexOfObject:item];
//                               
//                               dispatch_async(dispatch_get_main_queue(), ^{
//                                   // UI UPDATION 1
//                                   [scanner dismissViewControllerAnimated:true completion:nil];
//                               });
//                               
//                               /* I expect the control to come here after UI UPDATION 1 */
//                               
//                               // DATA PROCESSING 2
//                               
//                               dispatch_async(dispatch_get_main_queue(), ^{
//                                   // UI UPDATION 2
//                                   //                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Barcode found"
//                                   //                                             message:code.stringValue
//                                   //                                             delegate:self
//                                   //                                             cancelButtonTitle:@"OK"
//                                   //                                             otherButtonTitles:nil];
//                                   //                                             [scanner dismissViewControllerAnimated:true completion:nil];
//                                   //                                  [alert show];
//                                   
//                               });
//                               
//                               /* I expect the control to come here after UI UPDATION 2 */
//                               
//                               // DATA PROCESSING 3
//                               
//                               dispatch_async(dispatch_get_main_queue(), ^{
//                                   // UI UPDATION 3
//                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:anIndex inSection:0];
//                                   
//                                   if ([self.tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
//                                       [self.tableView.delegate tableView:self.tableView willSelectRowAtIndexPath:indexPath];
//                                   }
//                                   
//                                   [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition: UITableViewScrollPositionNone];
//                                   
//                                   if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
//                                       [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
//                                   }
//                                   
//                                   [self performSegueWithIdentifier: @"showDetail" sender: self];
//                                   
//                               });
//                               
//                           });
//                           
//                           
//                           
//                       }];
//                   }
//               }
//               
//               preferredCameraPosition:AVCaptureDevicePositionBack];
//    
//    [scanner setIsButtonBordersVisible:YES];
//    [scanner setStopOnFirst:YES];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - BarcodeScanViewControllerDelegate

- (void)BarcodeScanViewControllerDidCancel:(BarcodeScanViewController *)controller
{
    NSLog(@"cancel---2");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)BarcodeScanViewController:(BarcodeScanViewController *)controller scanDone:(NSString *)scanResult
{
    NSArray *filtered = [self.orders filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(do_number == %@)", scanResult]];
    
    if ([filtered count] != 0) {
        NSDictionary *item = [filtered objectAtIndex:0];
        NSInteger anIndex=[self.orders indexOfObject:item];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:anIndex inSection:0];
        
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
            [self.tableView.delegate tableView:self.tableView willSelectRowAtIndexPath:indexPath];
        }
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition: UITableViewScrollPositionNone];
        
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
        
        [self performSegueWithIdentifier: @"showDetail" sender: self];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't find this DO"
                                                        message:scanResult
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];}


- (void)download_orders {
    // setup object mappings
    [self.activityIndicatorView startAnimating];
    
    RKObjectMapping *UserMapping = [RKObjectMapping mappingForClass:[Order class]];
    [UserMapping addAttributeMappingsFromDictionary:@{ @"do_number": @"do_number",
                                                       @"order_type":@"order_type",
                                                       @"s_name": @"s_name",
                                                       @"s_company_name": @"s_company_name",
                                                       @"r_name": @"r_name",
                                                       @"r_company_name": @"r_company_name",
                                                       @"r_contact_number1": @"r_contact_number1",
                                                       @"r_contact_number2": @"r_contact_number2",
                                                       @"r_address1": @"r_address1",
                                                       @"r_address2": @"r_address2",
                                                       @"r_address3": @"r_address3",
                                                       @"r_postcode": @"r_postcode",
                                                       @"remarks": @"remarks",
                                                       @"cod_amount": @"cod_amount",
                                                       @"payment_term": @"payment_term",
                                                       @"exchange_code": @"exchange_code",
                                                       @"latest_status": @"latest_status"}];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:UserMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/hpapi/get_in_hand.json"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *queryParams = @{@"handset_user_id" : [defaults objectForKey:@"handset_user_id"]};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/get_in_hand.json"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  self.orders = mappingResult.array;
                                                  
                                                  [self.activityIndicatorView stopAnimating];
                                                  [self reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
}

- (void)scanBarcode:(id)sender {
    //[self presentViewController:scanner animated:YES completion:nil];
    [self performSegueWithIdentifier: @"ScanView" sender: self];
    
    
}

- (void)reloadData {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Order *order = self.orders[indexPath.row];
        [[segue destinationViewController] setOrder:order];
        
    }else if ([segue.identifier isEqualToString:@"ScanView"])
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return [self.orders count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InHandCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    Order *order = self.orders[indexPath.row];
    cell.textLabel.text = order.do_number;
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

@end
