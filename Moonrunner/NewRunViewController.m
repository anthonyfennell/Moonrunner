//
//  NewRunViewController.m
//  Moonrunner
//
//  Created by Anthony Fennell on 1/26/15.
//  Copyright (c) 2015 Anthony Fennell. All rights reserved.
//

#import "NewRunViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HomeViewController.h"
#import "AppModel.h"
#import <MapKit/MapKit.h>

static NSString * const detialSegueName = @"RunDetails";

@interface NewRunViewController () <UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property int seconds;
@property double distance;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) Run *run;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;




@end

@implementation NewRunViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navController = [segue destinationViewController];
    [[[navController viewControllers] firstObject] setRun:self.run];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.startButton.hidden = NO;
    self.promptLabel.hidden = NO;
    
    self.timeLabel.text = @"";
    self.timeLabel.hidden = YES;
    self.distLabel.hidden = YES;
    self.paceLabel.hidden = YES;
    self.stopButton.hidden = YES;
    self.mapView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)eachSecond {
    self.seconds++;
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@",
                           [[AppModel sharedModel] stringifySecondCount:self.seconds
                                                        usingLongFormat:NO]];
    self.distLabel.text = [NSString stringWithFormat:@"Distance: %@",
                           [[AppModel sharedModel] stringifyDistance:self.distance]];
    
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@",
                           [[AppModel sharedModel] stringifyAvgPaceFromDist:self.distance
                                                                   overTime:self.seconds
                                                                    driving:self.isDriving]];
}

- (void)startLocationUpdates
{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    if (self.isDriving) {
        self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        self.locationManager.distanceFilter = 12; // meters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    } else {
        self.locationManager.activityType = CLActivityTypeFitness;
        self.locationManager.distanceFilter = 5; // meters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    // Movement threshold for new events
    [self.locationManager startUpdatingLocation];
}






















- (IBAction)startButtonTapped:(id)sender {
    self.startButton.hidden = YES;
    self.promptLabel.hidden = YES;
    
    self.timeLabel.hidden = NO;
    self.distLabel.hidden = NO;
    self.paceLabel.hidden = NO;
    self.stopButton.hidden = NO;
    
    self.seconds = 0;
    self.distance = 0;
    self.locations = [NSMutableArray array];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0)
                                                  target:self
                                                selector:@selector(eachSecond)
                                                userInfo:nil
                                                 repeats:YES];
    [self startLocationUpdates];
    self.mapView.hidden = NO;
}

- (IBAction)stopButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save", @"Discard", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

#pragma Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        
        NSDate *event = location.timestamp;
        
        NSTimeInterval howRecent = [event timeIntervalSinceNow];
        
        if (abs(howRecent) < 10.0 && location.horizontalAccuracy < 20) {
            
            // Update distance
            if (self.locations.count > 0) {
                self.distance += [location distanceFromLocation:self.locations.lastObject];
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.locations.lastObject).coordinate;
                coords[1] = location.coordinate;
                
                MKCoordinateRegion region =
                MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
                [self.mapView setRegion:region animated:YES];
                
                [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [self.locations addObject:location];
        }
    }
}

#pragma Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // save
    if (buttonIndex == 0) {
        self.run = [[AppModel sharedModel] saveRunDistance:self.distance
                                                  duration:self.seconds
                                                 locations:self.locations driving:self.isDriving];
        [self performSegueWithIdentifier:detialSegueName sender:self];
    } else if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma Map View Delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc]
                                         initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}



@end
















