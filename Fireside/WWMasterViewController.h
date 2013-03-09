//
//  WWMasterViewController.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWDetailViewController;

@interface WWMasterViewController : UITableViewController

@property (strong, nonatomic) WWDetailViewController *detailViewController;

@end
