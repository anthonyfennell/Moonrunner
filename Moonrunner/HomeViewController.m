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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setIsADrive:NO];
}

- (IBAction)newDriveButtonTapped:(id)sender {
    [self performSegueWithIdentifier:driveSegueName sender:self];
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
