//
//  CampfireAccountsListViewController.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireAccountsListViewController.h"
#import "FiresideSession.h"
#import "LaunchPadAccount.h"
#import "CampfireAPIClient.h"

@interface CampfireAccountsListViewController ()
{
    NSMutableArray* campfireAccounts;
}
@end

@implementation CampfireAccountsListViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        campfireAccounts = [[NSMutableArray alloc] init];
        [self loadListOfCampfireAccounts];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Accounts";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadListOfCampfireAccounts {
    @synchronized(campfireAccounts) {
        for (LaunchPadAccount* account in [[[FiresideSession sharedInstance] launchPadAuthorization] accounts]) {
            NSLog(@"account product = %@", account.product);
            if ([account.product isEqualToString:@"campfire"]) {
                [campfireAccounts addObject:account];
            }
        }
    }
}

#pragma mark - UITableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [campfireAccounts count];
    NSLog(@"count is %d", count);
    return count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountCell"];
    }
    
    LaunchPadAccount* account = [campfireAccounts objectAtIndex:indexPath.row];
    cell.textLabel.text = account.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LaunchPadAccount* account = [campfireAccounts objectAtIndex:indexPath.row];
    [[FiresideSession sharedInstance] setCurrentLaunchPadAccount:account];
    
    NSURL* accountUrl = [NSURL URLWithString:account.href];
#warning Refactor this
    [[CampfireAPIClient sharedInstance] initWithBaseURL:accountUrl];
    NSString* accountToken = [[[FiresideSession sharedInstance] oAuthAuthorization] accessToken];
    [[CampfireAPIClient sharedInstance] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"BEARER %@", accountToken]];
    
    [self performSegueWithIdentifier:@"ShowRoomList" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowRoomList"]) {
        
        // set delegate
        //CampfireRoomsListViewController* roomsList = segue.destinationViewController;
        
    }
}

@end
