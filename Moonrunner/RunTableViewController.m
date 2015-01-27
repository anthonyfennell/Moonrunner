//
//  RunTableViewController.m
//  Moonrunner
//
//  Created by Anthony Fennell on 1/26/15.
//  Copyright (c) 2015 Anthony Fennell. All rights reserved.
//

#import "RunTableViewController.h"
#import "AppModel.h"

static NSString * const RunTableToDetail = @"RunTableToDetailView";

@interface RunTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property int row;

@end

@implementation RunTableViewController

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[AppModel sharedModel] fetchRuns] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * runs = [[AppModel sharedModel] fetchRuns];
    Run *run = [runs objectAtIndex:indexPath.row];
    NSString *time = [NSString stringWithFormat:@"Time: %@",
                      [[AppModel sharedModel] stringifySecondCount:run.duration.intValue usingLongFormat:YES]];
    NSString *pace = [NSString stringWithFormat:@"Pace: %@",
                      [[AppModel sharedModel] stringifyAvgPaceFromDist:run.distance.floatValue
                                                              overTime:run.duration.intValue
                                                               driving:run.isDriving]];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = pace;
    cell.detailTextLabel.text = time;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.row = (int)indexPath.row;
    [self performSegueWithIdentifier:RunTableToDetail sender:self];
}

- (void)tableView:(UITableView *)tableView
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end












