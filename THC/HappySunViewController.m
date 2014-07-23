//
//  HappySunViewController.m
//  THC
//
//  Created by David Bernthal on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "HappySunViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "GetStartedButton.h"

@interface HappySunViewController ()

- (IBAction)onLoginTap:(UITapGestureRecognizer *)sender;
- (IBAction)onGetStartedTap:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet GetStartedButton *getStartedView;

//Sun Animation
@property (weak, nonatomic) IBOutlet UIView *sunContainerView;
@property(strong, nonatomic) UIImageView *rayImageView;
@property(strong, nonatomic) UIView *rayRotate;
@property(strong, nonatomic) UIImageView *leftEyeImageView;
@property(strong, nonatomic) UIImageView *rightEyeImageView;
@property(strong, nonatomic) UIImageView *cloudImageView1;
@property(strong, nonatomic) UIImageView *cloudImageView2;
@property(strong, nonatomic) UIImageView *cloudImageView3;
@property(strong, nonatomic) UIImageView *cloudImageView4;
@property(assign, nonatomic) BOOL animating;
@property(assign, nonatomic) CGFloat screenWidth;

@end

@implementation HappySunViewController

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
    
    self.loginLabel.userInteractionEnabled = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    
    UIImage *rayImage = [UIImage imageNamed:@"ray"];
    self.rayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rayImage.size.width, rayImage.size.height)];
    self.rayImageView.image = rayImage;
    
    self.rayRotate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rayImageView.frame.size.width, self.rayImageView.frame.size.height)];
    
    UIImage *faceImage = [UIImage imageNamed:@"face"];
    UIImageView *faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.rayImageView.frame.size.width - faceImage.size.width) / 2, (self.rayImageView.frame.size.height - faceImage.size.height) / 2, faceImage.size.width, faceImage.size.height)];
    faceImageView.image = faceImage;
    
    UIImage *leftEyeImage = [UIImage imageNamed:@"eye"];
    self.leftEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 63, leftEyeImage.size.width, leftEyeImage.size.height)];
    self.leftEyeImageView.image = leftEyeImage;
    
    UIImage *rightEyeImage = [UIImage imageNamed:@"eye"];
    self.rightEyeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 63, rightEyeImage.size.width, rightEyeImage.size.height)];
    self.rightEyeImageView.image = rightEyeImage;
    
    UIView *sunContainer = [[UIView alloc] initWithFrame:CGRectMake((self.screenWidth - self.rayImageView.frame.size.width) / 2, 30, self.rayImageView.frame.size.width, self.rayImageView.frame.size.height)];
    
    UIImage *cloud1 = [UIImage imageNamed:@"clouds2"];
    UIImage *cloud2 = [UIImage imageNamed:@"clouds3"];
    
    self.cloudImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cloud2.size.width, cloud2.size.height)];
    self.cloudImageView1.image = cloud2;
    
    self.cloudImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, cloud2.size.width, cloud2.size.height)];
    self.cloudImageView2.image = cloud2;
    
    self.cloudImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cloud1.size.width, cloud1.size.height)];
    self.cloudImageView3.image = cloud1;
    
    self.cloudImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, cloud1.size.width, cloud1.size.height)];
    self.cloudImageView4.image = cloud1;
    
    UIView *cloudBackContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
    cloudBackContainer.clipsToBounds = YES;
    
    UIView *cloudFrontContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
    cloudFrontContainer.clipsToBounds = YES;
    
    UIImage *gradient = [UIImage imageNamed:@"gradient"];
    UIImageView *gradientImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, gradient.size.width, gradient.size.height)];
    gradientImageView.image = gradient;
    
    UIView *mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 307, 330)];
    mainContainer.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:230.0/255.0 blue:195.0/255.0 alpha:1];
    
    [cloudBackContainer addSubview:self.cloudImageView1];
    [cloudBackContainer addSubview:self.cloudImageView2];
    [cloudFrontContainer addSubview:self.cloudImageView3];
    [cloudFrontContainer addSubview:self.cloudImageView4];
    
    [self.rayRotate addSubview:self.rayImageView];
    
    [sunContainer addSubview:self.rayRotate];
    [sunContainer addSubview:faceImageView];
    [sunContainer addSubview:self.leftEyeImageView];
    [sunContainer addSubview:self.rightEyeImageView];
    
    [mainContainer addSubview:cloudBackContainer];
    [mainContainer addSubview:sunContainer];
    [mainContainer addSubview:cloudFrontContainer];
    [mainContainer addSubview:gradientImageView];
    
    [mainContainer addSubview:self.getStartedView];
    [mainContainer addSubview:self.loginLabel];
    
    [self.view addSubview:mainContainer];
    
    srandom(time(NULL));
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:(arc4random() % 3) + 5 target:self selector:@selector(blinking) userInfo:nil repeats:YES];
    
    [self cloudAnimation:self.cloudImageView1 firstDuration:12 secondDuration:24 delay:0];
    [self cloudAnimation:self.cloudImageView2 firstDuration:24 secondDuration:24 delay:0];
    [self cloudAnimation:self.cloudImageView3 firstDuration:8 secondDuration:16 delay:0];
    [self cloudAnimation:self.cloudImageView4 firstDuration:16 secondDuration:16 delay:0];
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.rayRotate.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        
    }];
    
    if(!self.animating) {
        self.animating = YES;
        [self rayRotateWithOptions:UIViewAnimationOptionCurveLinear];
    }
}

- (void)cloudAddShadow:(UIImageView *) cloud {
    cloud.layer.shadowColor = [UIColor grayColor].CGColor;
    cloud.layer.shadowOffset = CGRectMake(0, 0, 5, 5).size;
    cloud.layer.shadowOpacity = 0.2;
    cloud.layer.shadowRadius = 10;
}

- (void)rayRotateWithOptions:(UIViewAnimationOptions) options {
    [UIView animateWithDuration:2
                          delay:0
                        options:options
                     animations:^{
                         self.rayImageView.transform = CGAffineTransformRotate(self.rayImageView.transform, M_PI / 2);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (self.animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self rayRotateWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self rayRotateWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void)cloudAnimation:(UIImageView *)cloud firstDuration:(NSInteger)firstDuration secondDuration:(NSInteger)secondDuration delay:(NSInteger)delay {
    [UIView animateWithDuration:firstDuration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        cloud.center = CGPointMake(-cloud.frame.size.width / 2, cloud.center.y);
    } completion:^(BOOL finished) {
        cloud.center = CGPointMake(self.screenWidth + cloud.frame.size.width / 2, cloud.center.y);
        [UIView animateWithDuration:secondDuration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
            cloud.center = CGPointMake(-cloud.frame.size.width / 2, cloud.center.y);
        } completion:nil];
    }];
}

- (void)blinking {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:1];
        self.leftEyeImageView.transform = CGAffineTransformMakeScale(1, 0.1);
        self.rightEyeImageView.transform = CGAffineTransformMakeScale(1, 0.1);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.leftEyeImageView.transform = CGAffineTransformMakeScale(1, 1);
            self.rightEyeImageView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginTap:(UITapGestureRecognizer *)sender {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (IBAction)onGetStartedTap:(UITapGestureRecognizer *)sender {
    SignupViewController *signUpViewController = [[SignupViewController alloc] init];
    [self presentViewController:signUpViewController animated:YES completion:nil];
}

@end




