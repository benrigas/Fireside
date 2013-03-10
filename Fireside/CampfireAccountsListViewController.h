//
//  CampfireAccountsListViewController.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampfireRoomsListViewController.h"

@interface CampfireAccountsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *accountsTableView;

@end
