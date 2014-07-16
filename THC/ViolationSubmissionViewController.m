//
//  ViolationSubmissionViewController.m
//  THC
//
//  Created by Hunaid Hussain on 7/4/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationSubmissionViewController.h"
#import "ViolationSubmissionForm.h"
#import "CaseDetailViewController.h"
#import "Building.h"
#import <Parse/Parse.h>
#import "AlbumListController.h"



@interface ViolationSubmissionViewController ()

@property (strong, nonatomic) NSData                  *imageData;
@property (strong, nonatomic) NSString                *violationDescription;
@property (strong, nonatomic) Case                    *myCase;
@property (strong, nonatomic) NSMutableArray          *imagesInScroll;
@property (strong, nonatomic) NSMutableArray          *deleteImagesInScroll;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UIScrollView     *scrollView;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;




@end

@implementation ViolationSubmissionViewController

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

- (void)initializeView {
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed: 0.106f green: 0.157f blue: 0.333f alpha: 1];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(cancelButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                          target:self
                                                                                          action:@selector(editForm)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshForm)
                                                 name:@"Addresses Retrieved"
                                               object:nil];
    
    
    // Create the FX form controller and specify the form entries
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    if (self.myCase) //This is the edit form
    {
        ViolationSubmissionForm* populatedForm = [[ViolationSubmissionForm alloc] init];
        populatedForm.firstName = self.myCase.name;
        populatedForm.lastName = self.myCase.name;
        populatedForm.unitNum = self.myCase.unit;
        populatedForm.phoneNumber = self.myCase.phoneNumber;
        populatedForm.email = self.myCase.email;
        populatedForm.languagesSpoken = self.myCase.languageSpoken;
        
        PFQuery *query = [Building query];
        [query whereKey:@"objectId" equalTo:self.myCase.buildingId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count > 0)
                {
                    populatedForm.addressForm.hotelName = ((Building*)objects[0]).buildingName;
                } else
                {
                    populatedForm.addressForm.otherAddress.streetName = self.myCase.address;
                }
            }
        }];
        self.formController.form = populatedForm;
    } else
    {
        self.formController.form = [[ViolationSubmissionForm alloc] init];
    }

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    } else {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        //self.picker.allowsEditing = YES;
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        

        self.scrollView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];

        self.scrollView.delegate = self;
        
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.scrollView addSubview:self.activityView];
        
        CGPoint scrollViewCenter = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
        CGPoint activityCenter = [self.view convertPoint:scrollViewCenter fromView:self.scrollView];
        
        self.activityView.center = activityCenter;

        
        //self.pageControl.numberOfPages = 0;
        self.imagesInScroll = [NSMutableArray array];
        self.deleteImagesInScroll = [NSMutableArray array];

        
        CGSize contentSize = CGSizeZero;
        contentSize.width = 80;
        contentSize.height = 80;
        self.scrollView.contentSize = contentSize;
        
        contentSize.width = self.scrollView.frame.size.width;
        contentSize.height = self.scrollView.frame.size.height;
        self.scrollView.contentSize = contentSize;
        
        CGFloat padding = 5.0;
        CGRect imageViewFrame = CGRectInset(self.scrollView.frame, padding, padding);
        imageViewFrame.origin.x =  padding;
        imageViewFrame.origin.y = padding;
        imageViewFrame.size.width = 70;
        imageViewFrame.size.height = 70;
        NSLog(@"scroll view frame %@", NSStringFromCGRect(self.scrollView.frame));

        //NSLog(@"library imageview frame: x: %f y: %f width %f height %f", imageViewFrame.origin.x, imageViewFrame.origin.y, imageViewFrame.size.width, imageViewFrame.size.height);
        
        UIImage *image = [UIImage imageNamed:@"camera"];
//        NSLog(@"camera image %@", image);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = imageViewFrame;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.cornerRadius = 4.f;
        imageView.layer.borderWidth = 1.f;
        
        imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
        imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        [imageView setClipsToBounds:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchPhotoPicker:)];
        tap.numberOfTapsRequired = 1;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        imageView.tag = 10000;
        
        [self.scrollView addSubview:imageView];        
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGPoint scrollViewCenter = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
    CGPoint activityCenter = [self.view convertPoint:scrollViewCenter fromView:self.scrollView];
    
    self.activityView.center = activityCenter;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //reload the table
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma Dynamic Form Changes

- (void)refreshForm {
    self.formController.form = self.formController.form;
    [self.tableView reloadData];
}
- (void)addOtherLanguage:(UITableViewCell<FXFormFieldCell> *)cell {
    ViolationSubmissionForm *form =  (ViolationSubmissionForm *) cell.field.form;
    if ([form.languagesSpoken isEqualToString:@"Other"]) {
        form.showOtherLanguage = YES;
        self.formController.form = self.formController.form;
        [self.tableView reloadData];
    }
}

- (void)changeAddress {
    ViolationSubmissionForm *form =  (ViolationSubmissionForm *) self.formController.form;
    if ([form.addressForm.hotelName isEqualToString:@"Other"]) {
        form.addressForm.showOtherAddress = YES;
        self.formController.form = self.formController.form;
        [self.tableView reloadData];
    }
}

- (void)submitViolationSubmissionForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    ViolationSubmissionForm *form =  (ViolationSubmissionForm *) cell.field.form;
    [form printFormContents];
    if (self.myCase) //case was already created, just update it
    {
        [form updateCase:self.myCase];
//        CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:self.myCase isNewCase:NO];
        [self.navigationController popViewControllerAnimated:YES];
    } else
    {
        NSMutableArray *imageDataList = nil;

        if ([self.imagesInScroll count]) {
            imageDataList = [NSMutableArray array];
            for (UIImageView *imageView in self.imagesInScroll) {
                NSData  *imageData = UIImageJPEGRepresentation(imageView.image, 0);
                [imageDataList addObject:imageData];
            }
        }
        [form createCaseWithDescription:self.violationDescription withImageDataList:imageDataList completion:^(Case* createdCase){
            CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:createdCase isNewCase:YES];
            [self presentViewController:detailvc animated:YES completion:nil];
        } error:^(NSError * onError) {
            NSLog(@"Error creating Case!");
        }];
        
//        [form createCaseWithDescription:self.violationDescription andImageData:self.imageData completion:^(Case* createdCase){
//            CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:createdCase isNewCase:YES];
//            [self presentViewController:detailvc animated:YES completion:nil];
//        } error:^(NSError * onError) {
//            NSLog(@"Error creating Case!");
//        }];
    }
    //we can then perform validation, etc
    /*
     if (form.agreedToTerms)
     {
     [[[UIAlertView alloc] initWithTitle:@"Login Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
     }
     else
     {
     [[[UIAlertView alloc] initWithTitle:@"User Error" message:@"Please agree to the terms and conditions before proceeding" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes Sir!", nil] show];
     }
     */
    
//    [[[UIAlertView alloc] initWithTitle:@"Violation Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

#pragma ImagePicker Delegate Protocols
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    CGFloat padding = 10.0;
    CGRect imageViewFrame = CGRectInset(self.scrollView.bounds, padding, padding);
    imageViewFrame.origin.x = self.scrollView.frame.size.width + padding;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:chosenImage];
    imageView.frame = imageViewFrame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //self.nextButton.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma custom picker delegate
- (void) finishedPhotoPicker:(UIViewController *)picker withUserSelectedAssets:(NSArray *)assets {
    
    NSLog(@"userSelectedAssets %@", assets);
    
    //[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //[self.scrollView.subviews removeFromSuperview];
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag != 10000) {
            [view removeFromSuperview];
        }
    }
    [self.scrollView addSubview:self.activityView];




    self.scrollView.contentSize = CGSizeZero;
//    self.pageControl.numberOfPages = 0;
//    self.pageControl.currentPage = 0;
//    self.pageControl.hidden = YES;
    
    //NSLog(@"activity view %@", self.activityView);
    // Show some activity.
    [self.activityView startAnimating];
    
    // Dismiss the picker controller.
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (assets.count == 0) {
            [self.activityView stopAnimating];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        //self.imageView.image = nil;
        
        // ScrollView setup.
        CGFloat padding = 5.0;
        CGFloat width   = 70.0;

        CGSize contentSize = CGSizeZero;
//        contentSize.width = self.scrollView.frame.size.width * assets.count;
        contentSize.width = (width + padding) * (assets.count + 1);

        contentSize.height = self.scrollView.frame.size.height;
        self.scrollView.contentSize = contentSize;
        
        // PageControl setup.
//        self.pageControl.hidden = NO;
//        self.pageControl.numberOfPages = assets.count;
        
        int index = 1;
        
        
        [self.imagesInScroll removeAllObjects];
        for (ALAsset *asset in assets) {
            

//            NSLog(@"scroll view frame %@", NSStringFromCGRect(self.scrollView.bounds));

            CGRect imageViewFrame = CGRectInset(self.scrollView.bounds, padding, padding);
            NSLog(@"image view frame %@", NSStringFromCGRect(imageViewFrame));

            imageViewFrame.size.width = width;
            imageViewFrame.size.height = width;
            imageViewFrame.origin.x = (width + padding) * index + padding;
//            NSLog(@"library imageview frame: x: %f y: %f width %f height %f", imageViewFrame.origin.x, imageViewFrame.origin.y, imageViewFrame.size.width, imageViewFrame.size.height);
            
            //            UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
            UIImage *image = [[UIImage alloc] initWithCGImage:asset.thumbnail];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = imageViewFrame;
            //imageView.contentMode = UIViewContentModeCenter;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.layer.cornerRadius = 4.f;
            imageView.layer.borderWidth = 1.f;
            
            imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
            imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
            [imageView setClipsToBounds:YES];


            CGRect deleteFrame = CGRectInset(imageView.frame, padding, padding);
            deleteFrame.origin.x += width - 4*padding;
            deleteFrame.origin.y -= 2*padding;
            deleteFrame.size.height = 4*padding;
            deleteFrame.size.width  = 4*padding;
            UIImageView *deleteImageView = [self createEditForImageOnFrame:deleteFrame];
//            NSLog(@"delete view frame %@", NSStringFromCGRect(deleteImageView.frame));
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
            tap.numberOfTapsRequired = 1;

            [deleteImageView addGestureRecognizer:tap];
            deleteImageView.userInteractionEnabled = YES;
            deleteImageView.tag = [self.imagesInScroll count];
            
            index++;
            
            
            [self.scrollView addSubview:imageView];

            [self.scrollView addSubview:deleteImageView];
            [self.imagesInScroll addObject:imageView];
            [self.deleteImagesInScroll addObject:deleteImageView];
            
        }
        
        [self.activityView stopAnimating];
        
        [self.scrollView flashScrollIndicators];
    }];
    
}

- (void) finishedPhotoPicker:(UIViewController *)picker withCameraTakenImages:(NSArray *)selectedImages {
    
    //[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.contentSize = CGSizeZero;
//    self.pageControl.numberOfPages = 0;
//    self.pageControl.currentPage = 0;
//    self.pageControl.hidden = YES;
    
//    NSLog(@"activity view %@", self.activityView);
    // Show some activity.
    
    
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag != 10000) {
            [view removeFromSuperview];
        }
    }
    
    [self.scrollView addSubview:self.activityView];

    [self.activityView startAnimating];
    
    // Dismiss the picker controller.
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (selectedImages.count == 0) {
            [self.activityView stopAnimating];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        // ScrollView setup.
        CGFloat padding = 5.0;
        CGFloat width   = 70.0;
        
        CGSize contentSize = CGSizeZero;
        //        contentSize.width = self.scrollView.frame.size.width * assets.count;
        contentSize.width = (width + padding) * (selectedImages.count + 1);
        
        contentSize.height = self.scrollView.frame.size.height;
        self.scrollView.contentSize = contentSize;
        
//        // PageControl setup.
//        self.pageControl.hidden = NO;
//        self.pageControl.numberOfPages = selectedImages.count;
        
        int index = 1;
        
        [self.imagesInScroll removeAllObjects];
        
        for (UIImage *image in selectedImages) {
            
            CGRect imageViewFrame = CGRectInset(self.scrollView.bounds, padding, padding);
            imageViewFrame.size.width = width;
            imageViewFrame.size.height = width;
            imageViewFrame.origin.x = (width + padding) * index + padding;
//            NSLog(@"library imageview frame: x: %f y: %f width %f height %f", imageViewFrame.origin.x, imageViewFrame.origin.y, imageViewFrame.size.width, imageViewFrame.size.height);
            
            //            UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = imageViewFrame;
            //imageView.contentMode = UIViewContentModeCenter;
            //imageView.contentMode = UIViewContentModeCenter;
            imageView.layer.cornerRadius = 4.f;
            imageView.layer.borderWidth = 1.f;
            
            imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
            imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
            [imageView setClipsToBounds:YES];
            
            CGRect deleteFrame = CGRectInset(imageView.frame, padding, padding);
            deleteFrame.origin.x += width - 4*padding;
            deleteFrame.origin.y -= 2*padding;
            deleteFrame.size.height = 4*padding;
            deleteFrame.size.width  = 4*padding;
            UIImageView *deleteImageView = [self createEditForImageOnFrame:deleteFrame];
//            NSLog(@"delete view frame %@", NSStringFromCGRect(deleteImageView.frame));
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
            tap.numberOfTapsRequired = 1;
            
            [deleteImageView addGestureRecognizer:tap];
            deleteImageView.userInteractionEnabled = YES;
            deleteImageView.tag = [self.imagesInScroll count];
            
            index++;
            
            [self.scrollView addSubview:imageView];
            [self.scrollView addSubview:deleteImageView];
            [self.imagesInScroll addObject:imageView];
            [self.deleteImagesInScroll addObject:deleteImageView];

            
        }
        
        [self.activityView stopAnimating];
        
        [self.scrollView flashScrollIndicators];
    }];
    
}

- (void)cancelPhotoPicker:(UIViewController *) picker {
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"page control current page: %ld", (long)self.pageControl.currentPage);
//    
//    // Update the pageControl > 50% of the previous/next page is visible.
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    self.pageControl.currentPage = page;
//
//    
//    NSLog(@"page control final page: %d", page);
}

#pragma mark - button actions

- (void)launchPhotoPicker:(UITapGestureRecognizer *) tap {
    NSLog(@"launch photo picker");
    AlbumListController *alc = [[AlbumListController alloc] init];
    alc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:alc];
    [self presentViewController:nvc animated:YES completion:NULL];
}

- (void)cancelButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editForm {
    NSLog(@"To edit Form");
}

- (void)deleteImage:(UITapGestureRecognizer *) tap {
//    NSLog(@"Deleteting image with tag %ld", (long)tap.view.tag);
    //UIView *view = tap.view;
//    CGPoint touchLocation = [tap locationInView:tap.view];
    
    

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        UIImageView *imageView = (UIImageView *)[self.imagesInScroll objectAtIndex:tap.view.tag];
        CGRect frame = imageView.frame;
        CGRect nextFrame;
        [imageView removeFromSuperview];
        [self.imagesInScroll removeObjectAtIndex:tap.view.tag];
        
        CGRect deleteImageFrame = tap.view.frame;
        CGRect nextDeleteImageFrame;
//        NSLog(@"1. deleteImagesInScroll count %lu", (unsigned long)[self.deleteImagesInScroll count]);
        [self.deleteImagesInScroll removeObjectAtIndex:tap.view.tag];
//        NSLog(@"2. deleteImagesInScroll count %lu", (unsigned long)[self.deleteImagesInScroll count]);

        tap.view.alpha = 0;
        //[tap.view removeFromSuperview];
        
        //    int index = 0;
//        BOOL removedLastDeleteImage = NO;
//        if (!removedLastDeleteImage) {
//            UIImageView *lastDeleteImageView = [self.deleteImagesInScroll lastObject];
//            [self.deleteImagesInScroll removeLastObject];
//            [lastDeleteImageView removeFromSuperview];
//            removedLastDeleteImage = YES;
//        }
        
        // Move the remaiing images up.
        
        //    for (UIImageView *iv in self.imagesInScroll) {
        for (NSUInteger i=tap.view.tag; i<[self.imagesInScroll count]; i++) {
            
            UIImageView *iv = [self.imagesInScroll objectAtIndex:i];
            nextFrame = iv.frame;
            iv.frame = frame;
            frame = nextFrame;
            
            UIImageView *deleteImageView = [self.deleteImagesInScroll objectAtIndex:i];
//            NSLog(@"deleteImagesInScroll count %lu", (unsigned long)[self.deleteImagesInScroll count]);
            [self.scrollView bringSubviewToFront:deleteImageView];
            
            nextDeleteImageFrame = deleteImageView.frame;
            deleteImageView.frame = deleteImageFrame;
            deleteImageFrame = nextDeleteImageFrame;
            deleteImageView.tag = i;
            
            
            CGFloat padding = 5.0;
            CGFloat width   = 70.0;
            
            CGSize contentSize = CGSizeZero;
            //        contentSize.width = self.scrollView.frame.size.width * assets.count;
            contentSize.width = (width + padding) * ([self.imagesInScroll count] + 1);
            
            contentSize.height = self.scrollView.frame.size.height;
            self.scrollView.contentSize = contentSize;
            
            //        if (!removedLastDeleteImage) {
            //            UIImageView *lastDeleteImageView = [self.deleteImagesInScroll lastObject];
            //            [self.deleteImagesInScroll removeLastObject];
            //            [lastDeleteImageView removeFromSuperview];
            //            removedLastDeleteImage = YES;
            //        }
        }

        
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
        
    }];

}

#pragma Image Removal

- (UIImageView *)createEditForImageOnFrame:(CGRect) frame {
    
//    frame.size.width = 5;
//    frame.size.height = 5;
    
    UIImage *image = [UIImage imageNamed:@"delete"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    
    return imageView;
}

#pragma mark -
#pragma public functions

-(void) setImageData:(NSData *) imageData {
    _imageData = imageData;
}

-(void) setViolationDescription:(NSString *) description {
    _violationDescription = description;
}

-(void) setCase:(Case *) myCase {
    _myCase = myCase;
}

@end
