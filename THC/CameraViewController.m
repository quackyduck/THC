//
//  CameraViewController.m
//  THC
//
//  Created by Hunaid Hussain on 7/4/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CameraViewController.h"
#import "ViolationDescriptionViewController.h"

@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) UIImagePickerController *picker;

@property (retain, nonatomic) NSData *imageData;

- (IBAction)onClick:(UIButton *)sender;
- (IBAction)pickImageFromLibrary:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;

@end

@implementation CameraViewController

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

#pragma create view elements
- (void) initializeView {
    
    //[self createTitleLabel];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
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
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.showsCameraControls = YES;
        
        [self presentViewController:self.picker animated:YES completion:NULL];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
        [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
        [self.nextButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
        //self.nextButton.enabled = NO;
        self.navigationItem.rightBarButtonItem = self.nextButton;
    }
    
    return;
}

#pragma mark -
#pragma ImagePicker Delegate Protocols
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = chosenImage;
    
    self.imageData = UIImageJPEGRepresentation(chosenImage, 0);

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    self.nextButton.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma Action outlets
- (IBAction)onClick:(UIButton *)sender {
    
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:self.picker animated:YES completion:NULL];
}

- (IBAction)pickImageFromLibrary:(UIButton *)sender {
    
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.picker animated:YES completion:NULL];
}

- (IBAction)cancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onNext {
    
    ViolationDescriptionViewController *vdc = [[ViolationDescriptionViewController alloc] init];
    [vdc setImageData:self.imageData];
    
    [self.navigationController pushViewController:vdc animated:YES];
}

@end
