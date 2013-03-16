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
    
    FiresideSession* session = [FiresideSession savedSession];
    if (session.currentLaunchPadAccount) {
        [self setupCampfireAPIClient:session];
        [self performSegueWithIdentifier:@"ShowRoomList" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadListOfCampfireAccounts {
    @synchronized(campfireAccounts) {
        FiresideSession* session = [FiresideSession savedSession];
        for (LaunchPadAccount* account in [[session launchPadAuthorization] accounts]) {
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
    FiresideSession* session = [FiresideSession savedSession];
    [session setCurrentLaunchPadAccount:account];
    [session setLastRoom:nil];
    [session saveSession];

    [self setupCampfireAPIClient:session];

    [self performSegueWithIdentifier:@"ShowRoomList" sender:self];
}

- (void) setupCampfireAPIClient:(FiresideSession*)session {
    
    NSURL* accountUrl = [NSURL URLWithString:session.currentLaunchPadAccount.href];
#warning Refactor this
    [[CampfireAPIClient sharedInstance] initWithBaseURL:accountUrl];
    NSString* accountToken = [[session oAuthAuthorization] accessToken];
    [[CampfireAPIClient sharedInstance] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"BEARER %@", accountToken]];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowRoomList"]) {
        
        // set delegate
        //CampfireRoomsListViewController* roomsList = segue.destinationViewController;
        
    }
}

@end
