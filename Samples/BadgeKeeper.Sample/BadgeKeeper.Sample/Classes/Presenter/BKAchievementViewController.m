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
@property (weak, nonatomic) IBOutlet UIButton    *postVariablesButton;
@property (weak, nonatomic) IBOutlet UIButton    *incrementVariablesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


#pragma mark - Actions

- (IBAction)postButtonClick:(UIButton *)sender;
- (IBAction)incrementButtonClick:(UIButton *)sender;


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
    
    // subscribe post
    [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                selector:@selector(clientDidSendValues:)
                                name:kBKNotificationDidPostPreparedValues
                                object:nil];
    
    [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                selector:@selector(clientDidReceiveError:)
                                name:kBKNotificationFailedPostPreparedValues
                                object:nil];
    
    // subscribe increment
    [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                selector:@selector(clientDidSendValues:)
                                name:kBKNotificationDidIncrementPreparedValues
                                object:nil];
    
    [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                selector:@selector(clientDidReceiveError:)
                                name:kBKNotificationFailedIncrementPreparedValues
                                object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Actions

- (IBAction)postButtonClick:(UIButton *)sender {
    if ([self isLoginValid]) {
        [self setLoading:YES];
        
        static NSInteger posts = 0;
        posts++;
        
        [BadgeKeeper instance].userId = self.loginTextField.text;
        [[BadgeKeeper instance] prepareValue:posts forKey:@"Clicks"];
        [[BadgeKeeper instance] postPreparedValues];
    }
}

- (IBAction)incrementButtonClick:(UIButton *)sender {
    if ([self isLoginValid]) {
        [self setLoading:YES];

        static NSInteger increments = 0;
        increments++;
        
        [BadgeKeeper instance].userId = self.loginTextField.text;
        [[BadgeKeeper instance] prepareValue:increments forKey:@"Clicks"];
        [[BadgeKeeper instance] incrementPreparedValues];
    }
}

- (BOOL)isLoginValid {
    NSString *login = self.loginTextField.text;
    if (login.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"You should specify your User ID first!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    return YES;
}


#pragma mark - Utils

- (void)setLoading:(BOOL)isLoading {
    if (isLoading) {
        self.loginTextField.enabled = NO;
        self.postVariablesButton.enabled = NO;
        self.incrementVariablesButton.enabled = NO;
        [self.activityIndicatorView startAnimating];
    }
    else {
        self.loginTextField.enabled = YES;
        self.postVariablesButton.enabled = YES;
        self.incrementVariablesButton.enabled = YES;
        [self.activityIndicatorView stopAnimating];
    }
}


#pragma mark - Observing BadgeKeeper

- (void)clientDidSendValues:(NSNotification *)notification {
    NSArray *value = notification.userInfo[kBKNotificationKeyResponseObject];
    NSLog(@"%@", value);
    //TODO: show response data

    [self setLoading:NO];
}

- (void)clientDidReceiveError:(NSNotification *)notification {
    NSError *error = notification.userInfo[kBKNotificationKeyErrorObject];

    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    [self setLoading:NO];
}

@end
