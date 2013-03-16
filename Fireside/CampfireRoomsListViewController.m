//
//  CampfireRoomsListViewController.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireRoomsListViewController.h"
#import "CampfireRoomAPI.h"
#import "CampfireRoom.h"
#import "FiresideSession.h"

@interface CampfireRoomsListViewController ()
{
    NSArray* roomList;
}

@end

@implementation CampfireRoomsListViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        roomList = [[NSArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"view did load");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    FiresideSession* session = [FiresideSession savedSession];
    if (session.lastRoom) {
        [self performSegueWithIdentifier:@"ShowRoom" sender:session.lastRoom];
    }
    
    [self loadRooms];
}

- (void) loadRooms {
    [CampfireRoomAPI getRoomsSuccess:^(NSArray *rooms) {
        roomList = rooms;
        [self.roomsTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error getting room list: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [roomList count];
    
    return count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"roomCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"roomCell"];
    }
    
    CampfireRoom* campfireRoom = [roomList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = campfireRoom.name;
    cell.detailTextLabel.text = campfireRoom.topic;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CampfireRoom* campfireRoom = [roomList objectAtIndex:indexPath.row];
    
    FiresideSession* session = [FiresideSession savedSession];
    session.lastRoom = campfireRoom;
    [session saveSession];
    
    [CampfireRoomAPI joinRoom:campfireRoom success:^{
        [self performSegueWithIdentifier:@"ShowRoom" sender:campfireRoom];
    } failure:^(NSError *error) {
        NSLog(@"error joining room: %@", error);
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowRoom"]) {
        CampfireRoomViewController* roomController = segue.destinationViewController;
        
        roomController.room = (CampfireRoom*)sender;
    }
}

@end
