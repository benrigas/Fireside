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
    NSNumber* lastMessageId;
    NSTimer* getMessagesTimer;
    UITextField* inputTextField;
    
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
//    CampfireMessage* message = [[CampfireMessage alloc] init];
//    message.type = @"TextMessage";
//    message.body = @"I. Am. Here.";
//    
//    [CampfireMessageAPI speakMessage:message toRoom:self.room success:^{
//        NSLog(@"spoke!");
//    } failure:^(NSError *error) {
//        NSLog(@"didn't speak! %@", error);
//    }];

    [self setupKeyboardListners];
    [self loadRecentMessages];

}

- (void) getMessages:(NSTimer*)timer {
    NSLog(@"getting messages.");
    
//    [self loadRecentMessages];
}

- (void) dealloc {
    [getMessagesTimer invalidate];
    getMessagesTimer = nil;
}

- (void) loadRecentMessages {
    [CampfireMessageAPI getRecentMessagesForRoom:self.room limit:lastMessageId sinceMessageId:nil success:^(NSArray *recentMessages) {
        
        for (CampfireMessage* message in recentMessages) {
            if ([message.type isEqualToString:@"TextMessage"]) {
                [self addNewMessage:message];
            }
        }
        
        [self.roomTableView reloadData];
        [self scrollToBottom];
    } failure:^(NSError *error) {
        NSLog(@"error getting recent messages: %@", error);
    }];
    
    if (!getMessagesTimer) {
                getMessagesTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(getMessages:) userInfo:nil repeats:YES];
    }
}

- (void) addNewMessage:(CampfireMessage*)message {
    [messages addObject:message];
    lastMessageId = message.id;
}

- (void) setupKeyboardListners {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = self.view.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    [self scrollToBottom];
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	self.view.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void) scrollToBottom {
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: messages.count-1 inSection:0];
    [self.roomTableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.view.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	self.view.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void) setupInputView {
    CGRect viewFrame = CGRectMake(0, self.view.frame.size.height-44-44, self.view.frame.size.width, 44);
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:viewFrame];
    
    viewFrame = CGRectMake(0, 0, 240, 32);
    inputTextField = [[UITextField alloc] initWithFrame:viewFrame];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    UIBarButtonItem* barText = [[UIBarButtonItem alloc] initWithCustomView:inputTextField];

    UIBarButtonItem* sendButton = [[UIBarButtonItem alloc] initWithTitle:@"send" style:UIBarButtonItemStyleBordered target:self action:@selector(tappedSendButton:)];
    toolbar.items = @[barText, sendButton];
    
    [self.view addSubview:toolbar];
}

- (void) tappedSendButton:(id)sender {
    [self sendMessage];
}

- (void) sendMessage {
    CampfireMessage* message = [[CampfireMessage alloc] init];
    message.type = @"TextMessage";
    message.body = inputTextField.text;
    
    [CampfireMessageAPI speakMessage:message toRoom:self.room success:^(CampfireMessage* message) {
        NSLog(@"spoke!");
        inputTextField.text = @"";
//        [self addNewMessage:message];
//        [self.roomTableView reloadData];
//        [self scrollToBottom];
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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    }
    
    CampfireMessage* message = [messages objectAtIndex:indexPath.row];
    
    cell.textLabel.text = message.body;
    
    return cell;
}

@end
