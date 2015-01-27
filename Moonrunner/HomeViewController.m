//
//  HomeViewController.m
//  Moonrunner
//
//  Created by Anthony Fennell on 1/26/15.
//  Copyright (c) 2015 Anthony Fennell. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "NewRunViewController.h"
#import "AppModel.h"

static NSString * const driveSegueName = @"StartDrive";
static NSString * const pastRunsSegueName  = @"PastRuns";

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.description isEqualToString:driveSegueName]) {
        NewRunViewController *newRunVC = [[[segue destinationViewController] viewControllers] firstObject];
        [newRunVC setIsDriving:YES];
    }
}

- (IBAction)newDriveButtonTapped:(id)sender {
    [self performSegueWithIdentifier:driveSegueName sender:self];
}

- (IBAction)pastRunsButtonTapped:(id)sender {
    [self performSegueWithIdentifier:pastRunsSegueName sender:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
