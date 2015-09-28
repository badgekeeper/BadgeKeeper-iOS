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
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;


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
        [self.responseTextView setText:@""];
        
        static NSInteger posts = 0;
        posts++;
        
        [BadgeKeeper instance].userId = self.loginTextField.text;
        [[BadgeKeeper instance] preparePostValue:posts forKey:@"Clicks"];
        [[BadgeKeeper instance] preparePostValue:posts forKey:@"Posts"];
        [[BadgeKeeper instance] postPreparedValues];
    }
}

- (IBAction)incrementButtonClick:(UIButton *)sender {
    if ([self isLoginValid]) {
        [self setLoading:YES];
        [self.responseTextView setText:@""];

        static NSInteger increments = 0;
        increments++;
        
        [BadgeKeeper instance].userId = self.loginTextField.text;
        [[BadgeKeeper instance] prepareIncrementValue:increments forKey:@"Clicks"];
        [[BadgeKeeper instance] prepareIncrementValue:increments forKey:@"Posts"];
        [[BadgeKeeper instance] incrementPreparedValues];
    }
}

- (BOOL)isLoginValid {
    NSString *login = self.loginTextField.text;
    if (login.length == 0) {
        [self showAlertWithMessage:@"You should specify your User ID first!"];
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
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSArray *value = notification.userInfo[kBKNotificationKeyResponseObject];
        NSString *text = [NSString stringWithFormat:@"Response: %@", [value componentsJoinedByString:@", "]];
        [self.responseTextView setText:text];

        [self setLoading:NO];
    });
}

- (void)clientDidReceiveError:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSError *error = notification.userInfo[kBKNotificationKeyErrorObject];
        NSString *text = [NSString stringWithFormat:@"Code: %ld, Message: %@",
                          (unsigned long)error.code, error.localizedDescription];
        [self.responseTextView setText:text];
        
        [self setLoading:NO];
    });
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
