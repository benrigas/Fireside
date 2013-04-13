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
#import "CampfireEnterMessageCell.h"
#import "CampfireTimestampMessageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "CampfireSoundLoader.h"

@interface CampfireRoomViewController ()
{
    NSMutableArray* messages;
    NSNumber* lastMessageId;
    NSTimer* getMessagesTimer;
    UITextField* inputTextField;
    REMenu* _menu;
    AVAudioPlayer* player;
    BOOL doingInitialLoad;
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
    
    doingInitialLoad = YES;
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
            if ([message.type isEqualToString:@"TextMessage"]) {
                [self addNewMessage:message];
            }
            else if ([message.type isEqualToString:@"SoundMessage"]) {
                [self addNewMessage:message];
                if (doingInitialLoad == NO ) { //&& [message.id compare:lastMessageId] == NSOrderedAscending) {
                    [self playSoundForURL:message.url];
                }
            }
            else if ([message.type isEqualToString:@"PasteMessage"]) {
                [self addNewMessage:message];
            }
            else if ([message.type isEqualToString:@"TweetMessage"]) {
//                NSLog(@"message: %@", message.attributes);
                [self addNewMessage:message];
            }
            else if ([message.type isEqualToString:@"TimestampMessage"]) {
                [self addNewMessage:message];
            }
            else if ([message.type isEqualToString:@"EnterMessage"] || [message.type isEqualToString:@"LeaveMessage"]) {
                [self addNewMessage:message];
            }
            else {
                NSLog(@"Unhandled message type: %@", message.type);
            }
            lastMessageId = message.id;
        }
        
        doingInitialLoad = NO;
        
        //[self.roomTableView reloadData];
//        [self scrollToBottom];
    } failure:^(NSError *error) {
        NSLog(@"error getting recent messages: %@", error);
    }];
}

- (void) playSoundForURL:(NSString*)urlString
{
    [CampfireSoundLoader getSoundWithURL:urlString success:^(NSString *localSoundFilePath) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL* localSoundFileURL = [NSURL fileURLWithPath:localSoundFilePath];
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:localSoundFileURL error:NULL];
            player.currentTime = 0;
            player.volume = 1.0f;
            [player play];
        });
    } failure:^(NSError *error) {
        NSLog(@"error playing file: %@", urlString);
    }];
}

- (void) addNewMessage:(CampfireMessage*)message {
    [messages addObject:message];
    
    [self.roomTableView beginUpdates];
    NSIndexPath* newRowIndexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [self.roomTableView insertRowsAtIndexPaths:@[newRowIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.roomTableView endUpdates];
    
    if ([self isAtBottom]) {
        [self scrollToBottom];
    }
}

- (BOOL) isAtBottom {
    BOOL isBottom = NO;
    
    CGSize size = [self.roomTableView frame].size;
    CGPoint offset = [self.roomTableView contentOffset];
    CGSize contentSize = [self.roomTableView contentSize];
    
    // Are we at the bottom?
    if (offset.y + size.height >= contentSize.height-80) {
        isBottom = YES;
    }
    
    return isBottom;
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
    CGRect viewFrame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:viewFrame];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    toolbar.tintColor = [UIColor darkGrayColor];
    viewFrame = CGRectMake(0, 0, 215, 32);
    inputTextField = [[UITextField alloc] initWithFrame:viewFrame];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    //    inputTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIBarButtonItem* barText = [[UIBarButtonItem alloc] initWithCustomView:inputTextField];
    
    UIBarButtonItem* sendButton = [[UIBarButtonItem alloc] initWithTitle:@"send" style:UIBarButtonItemStyleBordered target:self action:@selector(tappedSendButton:)];
    
    UIBarButtonItem* soundButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(tappedSoundButton:)];
    toolbar.items = @[soundButton, barText, sendButton];
    
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
        [weakSelf scrollToBottom];
    }];
}

- (void) tappedSendButton:(id)sender {
    [self sendMessage];
}

- (void) tappedSoundButton:(id)sender {
    
}

- (void) sendMessage {
    CampfireMessage* message = [[CampfireMessage alloc] init];
    NSString* messageBody = inputTextField.text;
    
    if ([[inputTextField.text substringToIndex:5] isEqualToString:@"/play"]) {
        message.type = @"SoundMessage";
        messageBody = [messageBody substringFromIndex:6];
    }
    else {
        message.type = @"TextMessage";
    }
    
    message.body = messageBody;
    
    [CampfireMessageAPI speakMessage:message toRoom:self.room success:^(CampfireMessage* message) {
        inputTextField.text = @"";
    } failure:^(NSError *error) {
        NSLog(@"didn't speak! %@", error);
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
    
    if ([message.type isEqualToString:@"TimestampMessage"]) {
        CampfireTimestampMessageCell* timestampCell = [tableView dequeueReusableCellWithIdentifier:@"TimeMessageCell"];
        if (timestampCell == nil) {
            timestampCell = [[CampfireTimestampMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeMessageCell"];
        }
        
        [timestampCell displayMessage:message];
        cell = timestampCell;
    }
    else if ([message.type isEqualToString:@"EnterMessage"] || [message.type isEqualToString:@"LeaveMessage"]) {
        CampfireEnterMessageCell* enterCell = [tableView dequeueReusableCellWithIdentifier:@"EnterMessageCell"];
        if (enterCell == nil) {
            enterCell = [[CampfireEnterMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EnterMessageCell"];
        }
        [enterCell displayMessage:message];
        cell = enterCell;
    }
    else {
        CampfireMessageCell* messageCell = [tableView dequeueReusableCellWithIdentifier:@"TextMessageCell"];
        
        if (messageCell == nil) {
            messageCell = [[CampfireMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextMessageCell"];
        }
        
        [messageCell displayMessage:message];
        cell = messageCell;
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 45.0;
    
    CampfireMessage* message = [messages objectAtIndex:indexPath.row];
    
    height = [CampfireMessageCell heightForMessage:message];
    
    return height;
}

@end
