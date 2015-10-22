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

@end


@implementation BKAchievementViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BadgeKeeper Sample";
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
        [[BadgeKeeper instance] preparePostValue:posts forKey:@"x"];
        
        BKFailureResponseCallback failure = ^(int code, NSString *message) {
            [self didReceiveErrorWithCode:code andMessage:message];
        };
        
        BKAchievementsUnlockedCallback success = ^(NSArray *achievements) {
            [self didReceiveSuccessWithAchievements:achievements];
        };
        
        [[BadgeKeeper instance] postPreparedValuesWithSuccess:success
                                                  withFailure:failure];
    }
}

- (IBAction)incrementButtonClick:(UIButton *)sender {
    if ([self isLoginValid]) {
        [self setLoading:YES];
        [self.responseTextView setText:@""];

        static NSInteger increments = 0;
        increments++;
        
        BKFailureResponseCallback failure = ^(int code, NSString *message) {
            [self didReceiveErrorWithCode:code andMessage:message];
        };
        
        BKAchievementsUnlockedCallback success = ^(NSArray *achievements) {
            [self didReceiveSuccessWithAchievements:achievements];
        };
        
        [BadgeKeeper instance].userId = self.loginTextField.text;
        [[BadgeKeeper instance] prepareIncrementValue:increments forKey:@"x"];
        [[BadgeKeeper instance] incrementPreparedValuesWithSuccess:success
                                                       withFailure:failure];
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

- (void)didReceiveSuccessWithAchievements:(NSArray *)achievements {
    NSString *text = [NSString stringWithFormat:@"Response: "];
    
    if (achievements != nil && achievements.count > 0) {
        for (BKUnlockedAchievement *achievement in achievements) {
            NSString *achievementText = [NSString stringWithFormat:@"Title: %@, Description: %@", achievement.displayName, achievement.desc];
            if (achievement.rewards && achievement.rewards.count > 0) {
                for (BKReward *reward in achievement.rewards) {
                    NSString *rewardText = [NSString stringWithFormat:@"Rewards: []"];
                }
            }
            //NSArray *rewards = [NSArray new];
            //[[BadgeKeeper instance] readRewardValuesForName:@"gold" withValues:&rewards];
            //for (BKEntityRewards *reward in rewards) {
            //    NSLog(@"Reward: %@, Value: %f", reward.name, reward.value);
            //}
        }
    }
    
    [self.responseTextView setText:text];
    [self setLoading:NO];
}

- (void)didReceiveErrorWithCode:(int)code andMessage:(NSString *)message {
    NSString *text = [NSString stringWithFormat:@"Code: %ld, Message: %@",
                      (unsigned long)code, message];
    
    [self.responseTextView setText:text];
    [self setLoading:NO];
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
