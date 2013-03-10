//
//  CampfireRoomViewController.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireRoomViewController.h"
#import "CampfireRoomAPI.h"
#import "CampfireMessageAPI.h"

@interface CampfireRoomViewController ()
{
    NSMutableArray* messages;
}

@end

@implementation CampfireRoomViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        messages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = self.room.name;
    
//    CampfireMessage* message = [[CampfireMessage alloc] init];
//    message.type = @"TextMessage";
//    message.body = @"I. Am. Here.";
//    
//    [CampfireMessageAPI speakMessage:message toRoom:self.room success:^{
//        NSLog(@"spoke!");
//    } failure:^(NSError *error) {
//        NSLog(@"didn't speak! %@", error);
//    }];
    
    [CampfireMessageAPI getRecentMessagesForRoom:self.room limit:nil sinceMessageId:nil success:^(NSArray *recentMessages) {
        
        for (CampfireMessage* message in recentMessages) {
            if ([message.type isEqualToString:@"TextMessage"]) {
                [messages addObject:message];
            }
        }
        
        [self.roomTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error getting recent messages: %@", error);
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
    NSInteger count = [messages count];
    
    return count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    }
    
    CampfireMessage* message = [messages objectAtIndex:indexPath.row];
    
    cell.textLabel.text = message.body;
    
    return cell;
}

@end
