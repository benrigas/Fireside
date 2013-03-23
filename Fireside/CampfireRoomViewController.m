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
#import "CampfireUserAPI.h"
#import "DAKeyboardControl.h"
#import "CampfireUser.h"
#import "CampfireMessageCell.h"

@interface CampfireRoomViewController ()
{
    NSMutableArray* messages;
    NSNumber* lastMessageId;
    NSTimer* getMessagesTimer;
    UITextField* inputTextField;
    REMenu* _menu;
    BOOL viewIsResized;
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
    [self setupInputView];
    
    [self loadRecentMessages];
    
    getMessagesTimer = [NSTimer timerWithTimeInterval:4.0 target:self selector:@selector(getMessages:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:getMessagesTimer forMode:NSDefaultRunLoopMode];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(tappedMenu:)];
    
    self.navigationItem.hidesBackButton = YES;
    
    
    //[self setupMenu];
}

- (void) setupMenu {
    REMenuItem *lobbyItem = [[REMenuItem alloc] initWithTitle:@"Lobby"
                                                     subtitle:@"Return to the list of rooms"
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [self goToLobby];
                                                       }];
    
    REMenuItem *leaveItem = [[REMenuItem alloc] initWithTitle:@"Leave Room"
                                                     subtitle:@"Leave the chat room"
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [self leaveRoom];
                                                       }];
    
    //    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"Transcript"
    //                                                        subtitle:@"View chat transcript history"
    //                                                           image:nil
    //                                                highlightedImage:nil
    //                                                          action:^(REMenuItem *item) {
    //                                                              NSLog(@"Item: %@", item);
    //                                                          }];
    
    //    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"Lock"
    //                                                        subtitle:@"Stops the transcript"
    //                                                          image:nil
    //                                               highlightedImage:nil
    //                                                         action:^(REMenuItem *item) {
    ////                                                             if (self.room)
    //                                                         }];
    
    _menu = [[REMenu alloc] initWithItems:@[lobbyItem, leaveItem]];
}

- (void) tappedMenu:(id)sender {
    if (_menu.isOpen) {
        [_menu close];
    }
    else {
        [self setupMenu];
        [_menu showFromNavigationController:self.navigationController];
    }
}

- (void) goToLobby {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) leaveRoom {
    [getMessagesTimer invalidate];
    getMessagesTimer = nil;
    
    [CampfireRoomAPI leaveRoom:self.room success:^{
        [self goToLobby];
    } failure:^(NSError *error) {
        NSLog(@"error leaving room. %@", error);
    }];
}

- (void) getMessages:(NSTimer*)timer {
    NSLog(@"getting messages.");
    
    [self loadRecentMessages];
}

- (void) dealloc {
    [getMessagesTimer invalidate];
    getMessagesTimer = nil;
}

- (void) loadRecentMessages {
    [CampfireMessageAPI getRecentMessagesForRoom:self.room limit:nil sinceMessageId:lastMessageId success:^(NSArray *recentMessages) {
        
        for (CampfireMessage* message in recentMessages) {
            lastMessageId = message.id;
            if ([message.type isEqualToString:@"TextMessage"]) {
                [self addNewMessage:message];
            }
            else if ([message.type isEqualToString:@"SoundMessage"]) {
                [self addNewMessage:message];
            }
            else if ([message.type isEqualToString:@"PasteMessage"]) {
                [self addNewMessage:message];
            }
        }
        
        //[self.roomTableView reloadData];
        //[self scrollToBottom];
    } failure:^(NSError *error) {
        NSLog(@"error getting recent messages: %@", error);
    }];
}

- (void) addNewMessage:(CampfireMessage*)message {
    [messages addObject:message];
    
    [self.roomTableView beginUpdates];
    NSIndexPath* newRowIndexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [self.roomTableView insertRowsAtIndexPaths:@[newRowIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.roomTableView endUpdates];
    
    //[self scrollToBottom]; // FIXME only scroll to bottom if already at the bottom
}

- (void)viewWillDisappear:(BOOL)animated {
    [getMessagesTimer invalidate];
    getMessagesTimer = nil;
}

- (void) scrollToBottom {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [self.roomTableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionTop animated:NO];
}

- (void) setupInputView {
    CGRect viewFrame = CGRectMake(0, self.view.frame.size.height-44-44, self.view.frame.size.width, 44);
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:viewFrame];
    toolbar.tintColor = [UIColor darkGrayColor];
    viewFrame = CGRectMake(0, 0, 240, 32);
    inputTextField = [[UITextField alloc] initWithFrame:viewFrame];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //    inputTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIBarButtonItem* barText = [[UIBarButtonItem alloc] initWithCustomView:inputTextField];
    
    UIBarButtonItem* sendButton = [[UIBarButtonItem alloc] initWithTitle:@"send" style:UIBarButtonItemStyleBordered target:self action:@selector(tappedSendButton:)];
    toolbar.items = @[barText, sendButton];
    
    [self.view addSubview:toolbar];
    
    self.view.keyboardTriggerOffset = toolbar.bounds.size.height;
    
    __weak CampfireRoomViewController *weakSelf = self;
    
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        CGRect toolBarFrame = toolbar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        toolbar.frame = toolBarFrame;
        
        CGRect tableViewFrame = weakSelf.roomTableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        weakSelf.roomTableView.frame = tableViewFrame;
    }];
    
    // FIXME need to scroll to bottom after keyboard shows
}

- (void) tappedSendButton:(id)sender {
    [self sendTextMessage];
}

- (void) sendTextMessage {
    CampfireMessage* message = [[CampfireMessage alloc] init];
    message.type = @"TextMessage";
    message.body = inputTextField.text;
    
    [CampfireMessageAPI speakMessage:message toRoom:self.room success:^(CampfireMessage* message) {
        inputTextField.text = @"";
    } failure:^(NSError *error) {
        //NSLog(@"didn't speak! %@", error);
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
    
    CampfireMessage* message = [messages objectAtIndex:indexPath.row];
    UITableViewCell* cell = nil;
    
    CampfireMessageCell* messageCell = [tableView dequeueReusableCellWithIdentifier:@"TextMessageCell"];
    
    if (messageCell == nil) {
        messageCell = [[CampfireMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextMessageCell"];
    }
    
    [messageCell displayMessage:message];
    cell = messageCell;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 45.0;
    
    CampfireMessage* message = [messages objectAtIndex:indexPath.row];
    
    height = [CampfireMessageCell heightForMessage:message];
    
    return height;
}

@end
