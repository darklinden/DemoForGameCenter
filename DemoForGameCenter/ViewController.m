//
//  ViewController.m
//  DemoForGameCenter
//
//  Created by darklinden on 14-8-25.
//  Copyright (c) 2014年 darklinden. All rights reserved.
//

#import "ViewController.h"
#import "GameCenterHelper.h"
#import <GameKit/GameKit.h>

#define Identifier_1    @"Identifier_1"
#define Identifier_2    @"Identifier_2"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pLb_category_1;
@property (weak, nonatomic) IBOutlet UILabel *pLb_best_scole_1;
@property (weak, nonatomic) IBOutlet UILabel *pLb_category_2;
@property (weak, nonatomic) IBOutlet UILabel *pLb_best_scole_2;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _pLb_category_1.text = Identifier_1;
    _pLb_category_2.text = Identifier_2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pBtn_load_best_clicked:(id)sender {
    [GameCenterHelper loadTopScoleWithIds:@[Identifier_1, Identifier_2]
                               completion:^(NSDictionary *scoles, NSDictionary *errors)
    {
        NSLog(@"%@", errors);
        NSLog(@"%@", scoles);
        
        if (scoles[Identifier_1]) {
            NSArray *arr = scoles[Identifier_1];
            GKScore *s = [arr firstObject];
            _pLb_best_scole_1.text = [NSString stringWithFormat:@"%lld", s.value];
        }
        
        if (scoles[Identifier_2]) {
            NSArray *arr = scoles[Identifier_2];
            GKScore *s = [arr firstObject];
            _pLb_best_scole_2.text = [NSString stringWithFormat:@"%lld", s.value];
        }
    }];
}

- (IBAction)pBtn_make_new_best_clicked:(id)sender {
    int64_t i1 = _pLb_best_scole_1.text.longLongValue;
    int64_t i2 = _pLb_best_scole_2.text.longLongValue;
    
    i1++, i2++;
    
    NSDictionary *upload = @{Identifier_1: @(i1), Identifier_2: @(i2)};
    
    [GameCenterHelper uploadScoleWithIds:upload completion:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)pBtn_present_list_clicked:(id)sender {
    if ([GameCenterHelper isAuthenticated]) {
        [GameCenterHelper showList];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authenticate Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
