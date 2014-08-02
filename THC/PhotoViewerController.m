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
@property (strong, nonatomic) NSMutableDictionary     *imageToImageView;



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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createNoteBox:)];


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
        [imageView addGestureRecognizer:tapGesture];
        NSLog(@"image size  %f , %f", imageView.image.size.width, imageView.image.size.height);

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

- (void)createNoteBox:(UITapGestureRecognizer *) tap {
    
    CGPoint centre = [tap locationInView:tap.view];
    UIView  *view = tap.view;
//    UIImageView *imageView = (UIImageView *) tap.view;
    
    
    
//    NSLog(@"View frame %@", NSStringFromCGRect(view.frame));

    CGRect textFrame = CGRectMake(centre.x, centre.y, 120, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFrame];
    [textField setFont:[UIFont boldSystemFontOfSize:25]];
    [textField setTextColor:[UIColor whiteColor]];
    [view addSubview:textField];
    
//    imageView.image = [self screenshot:imageView.image.size];
//    imageView.image = [self Snapshot:imageView];
}


-(UIImage *)screenshot:(CGSize) imageSize
{
//    CGSize imageSize = CGSizeZero;
//    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (UIInterfaceOrientationIsPortrait(orientation)) {
//        imageSize = [UIScreen mainScreen].bounds.size;
//    } else {
//        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *) Snapshot:(UIImageView *) imageView
{
    UIImage *image;
    UIGraphicsBeginImageContext(imageView.frame.size);
    //new iOS 7 method to snapshot
    [imageView drawViewHierarchyInRect:imageView.frame afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    //...code to save to photo album omitted for brevity
}
@end
