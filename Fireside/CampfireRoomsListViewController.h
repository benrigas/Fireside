//
//  CampfireRoomsListViewController.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampfireRoomViewController.h"

@interface CampfireRoomsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *roomsTableView;

@end
