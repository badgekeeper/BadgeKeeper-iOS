//
//  BKAchievementViewController.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKAchievementViewController.h"
#import "BadgeKeeper.h"


@interface BKAchievementViewController () {
    
}

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UIButton    *clickmeButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


#pragma mark - Actions

- (IBAction)clickmeButtonClick:(UIButton *)sender;


#pragma mark - Utils

- (void)setLoading:(BOOL)isLoading;


#pragma mark - Observing BadgeKeeper

- (void)clientDidSendValues:(NSNotification *)notification;

@end


@implementation BKAchievementViewController


#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"BadgeKeeper Sample";
    
    // subscribe
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(clientDidSendValues:)
     name:kBKNotificationDidSendPreparedValues
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(clientDidSendValues:)
     name:kBKNotificationFailedSendPreparedValues
     object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Actions

- (IBAction)clickmeButtonClick:(UIButton *)sender {
    NSString *login = [self.loginTextField.text
                       stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (login.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"You should specify your Login first!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    static NSInteger clicks = 0;
    ++clicks;
    
    [self setLoading:YES];
    
    [BadgeKeeper instance].userId = login;
    [[BadgeKeeper instance] prepareValue:clicks forAchievementId:@"Achievement 1"];
    [[BadgeKeeper instance] sendPreparedValuesForUserId:nil];
}


#pragma mark - Utils

- (void)setLoading:(BOOL)isLoading {
    if (isLoading) {
        self.loginTextField.enabled = NO;
        self.clickmeButton.enabled = NO;
        [self.activityIndicatorView startAnimating];
    }
    else {
        self.loginTextField.enabled = YES;
        self.clickmeButton.enabled = YES;
        [self.activityIndicatorView stopAnimating];
    }
}


#pragma mark - Observing BadgeKeeper

- (void)clientDidSendValues:(NSNotification *)notification {
    [self setLoading:NO];
    
    NSString *value = NSStringFromClass([notification.userInfo[kBKNotificationKeyResponseObject] class]);
    
    [[[UIAlertView alloc] initWithTitle:@"Response"
                                message:value
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
