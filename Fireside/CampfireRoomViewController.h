//
//  CampfireRoomViewController.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampfireMessage.h"
#import "CampfireRoom.h"
#import "CampfireRoomAPI.h"
#import "REMenu.h"

@interface CampfireRoomViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property (nonatomic, strong) CampfireRoom* room;
@end
