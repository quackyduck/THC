//
//  PhotoViewerController.m
//  THC
//
//  Created by Hunaid Hussain on 7/31/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "PhotoViewerController.h"

@interface PhotoViewerController ()

@property (weak, nonatomic) IBOutlet UIScrollView     *scrollView;
@property (strong, nonatomic) NSArray                 *imagesToShow;
@property (strong, nonatomic) NSArray                 *imageOrientations;



@end

@implementation PhotoViewerController

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
    [self initializeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeView {
    
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.userInteractionEnabled = YES;
    
//    [self.scrollView setContentMode:UIViewContentModeScaleAspectFit];
    
    // Set them up in the scroll view


    
//    NSLog(@"image orientations %@", self.imageOrientations);
    int imageCount = 0;
    for (UIImage *image in self.imagesToShow) {
        
        UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
        

        CGRect imageViewFrame = self.scrollView.frame;
//        NSLog(@"imageview frame: %@", NSStringFromCGRect(imageViewFrame));
        imageViewFrame.origin.x = (self.scrollView.frame.size.width) * imageCount;
//        UIImage *image = [UIImage imageWithData:imageData];
        
        int orientation = [self.imageOrientations[imageCount] integerValue];
//        NSLog(@"orientation %d", orientation);
        UIImage *image1 = [UIImage imageWithCGImage:image.CGImage
                                    scale:1.0f
                              orientation:orientation];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image1];
//        imageViewFrame.size.width = image.size.width;
//        imageViewFrame.size.height = image.size.height;
        
        imageView.frame = imageViewFrame;
        if (orientation == UIImageOrientationRight) {
//            NSLog(@"scale to fill");
            imageView.contentMode =  UIViewContentModeScaleToFill;
        } else {
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
//        [imageView sizeToFit];
//        imageView.clipsToBounds = YES;

//        NSLog(@"imageView frame %@", NSStringFromCGRect(imageViewFrame));
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:downSwipe];

        [self.scrollView addSubview:imageView];
        ++imageCount;
    }
    
    CGSize contentSize = CGSizeZero;
    contentSize.width = (self.scrollView.bounds.size.width) * self.imagesToShow.count;
    
    contentSize.height = self.scrollView.frame.size.height;
    self.scrollView.contentSize = contentSize;
    [self.scrollView setPagingEnabled:YES];


}

- (void)setImagesForViewing:(NSArray *) imageList withOrientations:(NSArray *) orientations {
    
    self.imagesToShow = [NSArray arrayWithArray:imageList];
    self.imageOrientations = [NSArray arrayWithArray:orientations];

}

- (void)dismiss:(UISwipeGestureRecognizer *) swipe {
    
    NSLog(@"Got Swipe!");
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown || swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
