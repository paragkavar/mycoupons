//
//  MICouponsTableViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MICouponsTableViewController.h"
#import "MIAddCouponTableViewController.h"
#import "MICouponDetailsViewController.h"
#import "MICouponTableViewCell.h"
#import "UIAlertView+NWToolbox.h"
#import "MIPoolTableViewController.h"

@implementation MICouponsTableViewController

@synthesize connection;

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        coupons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [connection release];
    [alert dismiss];
    [super dealloc];
}

- (void)addCouponService:(UIBarButtonItem*)barbuttonItem{
    MIAddCouponTableViewController* viewController = [[[MIAddCouponTableViewController alloc] initWithStyle:UITableViewStylePlain Category:-1] autorelease];
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    [self presentModalViewController:navController animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // headerView.headerLabel.text = @"My Deals";
	//[headerView.poolButton setTitle:@"Pool" forState:UIControlStateNormal];
	[headerView.poolButton setBackgroundImage:[UIImage imageNamed:@"DealMe-Pool-L-Button.png"] forState:UIControlStateNormal];
	[headerView.poolButton addTarget:self action:@selector(poolButtonPress) forControlEvents:UIControlEventTouchUpInside];
	
    alert = [UIAlertView showActivityAlertWithTitle:@"Fetching deals" message:@"Hang on..."];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCouponService:)] autorelease];
}


- (void)poolButtonPress {
//	[self dismissModalViewControllerAnimated:NO];
	
    MIPoolTableViewController* viewController = [[[MIPoolTableViewController alloc] initWithStyle:UITableViewStylePlain Category:-2] autorelease];
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    [self presentModalViewController:navController animated:YES];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.connection fetchDealsWithDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [coupons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    MICouponTableViewCell *cell = (MICouponTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MICouponTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
    }
    
    [cell configureWithCoupon:[coupons objectAtIndex:indexPath.row]];
    // Configure the cell...
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MICoupon* coupon = [coupons objectAtIndex:indexPath.row]; 
    MICouponDetailsViewController *detailViewController = [[MICouponDetailsViewController alloc] initWithCoupon:coupon NavController:self.navigationController];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
}

#pragma mark - MIFetchDealsDelegate

- (void)fetchDealsFinishedWithDeals:(NSArray *)deals {
    [alert dismiss]; alert = nil;
    [coupons release];
    coupons = [deals retain];
    [self.tableView reloadData];
}

- (void)fetchDealsFailedWithError:(NSError *)error {
    [alert dismiss]; alert = nil;
    [UIAlertView showBasicAlertWithTitle:@"Whoops!" message:[error localizedDescription]];
}


@end
