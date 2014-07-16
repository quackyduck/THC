//
//  PhotoCollectionController.m
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "PhotoCollectionController.h"
#import "AsseptPicker.h"
#import "AssetWrapper.h"
#import "PhotoCell.h"


@interface PhotoCollectionController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *fetchedAssets;
@property (strong, nonatomic) UIImagePickerController *cameraPicker;

@end

@implementation PhotoCollectionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fetchedAssets = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeView];
    // Fetch the assets.
    [self fetchAssets];

}

- (void)initializeView {
    self.navigationItem.title = @"Loading";
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
//    self.collectionView.backgroundColor = [UIColor colorWithRed: 0.106f green: 0.157f blue: 0.333f alpha: 1];

    
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneButtonAction:)];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PhotoCell"];
    
    
    self.cameraPicker = [[UIImagePickerController alloc] init];
    self.cameraPicker.delegate = self;
    self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    self.cameraPicker.showsCameraControls = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetching Code

- (void)fetchAssets
{
    // TODO: Listen to ALAssetsLibrary changes in order to update the library if it changes.
    // (e.g. if user closes, opens Photos and deletes/takes a photo, we'll get out of range/other error when they come back.
    // IDEA: Perhaps the best solution, since this is a modal controller, is to close the modal controller.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (!result || index == NSNotFound) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"1. Calling collection view reload");
                    [self.collectionView reloadData];
                    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
                });
                
                return;
            }
            
            AssetWrapper *assetWrapper = [[AssetWrapper alloc] initWithAsset:result];
            [assetWrapper setSelected:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.fetchedAssets addObject:assetWrapper];
                
            });
            
        }];
    });
    
    NSLog(@"2. Calling collection view reload");
    
    //[self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    [self.collectionView reloadData];
}

#pragma mark - Actions

- (void)doneButtonAction:(id)sender
{
    NSLog(@"Picked %lu images", (unsigned long)[self.assetPicker.selectedAssets count]);
    [self.delegate finishedPhotoPicker:self withUserSelectedAssets:self.assetPicker.selectedAssets];
}

#pragma mark - UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)cv {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView*)cv numberOfItemsInSection:(NSInteger)section {
    NSLog(@"total fetched assets %lu", (unsigned long)[self.fetchedAssets count]);
    return [self.fetchedAssets count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    PhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        UIImage *cameraImage = [UIImage imageNamed:@"camera"];
        //NSLog(@"camera image %@", cameraImage);
        cell.imageView.image = cameraImage;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        AssetWrapper *assetWrapper = self.fetchedAssets[indexPath.row-1];
        UIImage *thumbNail = [UIImage imageWithCGImage:assetWrapper.asset.thumbnail];
        cell.imageView.image = thumbNail;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([assetWrapper isSelected]) {
            [cell selectCell:YES];
        } else {
            [cell selectCell:NO];
        }
        //NSLog(@"returning image for row %d", indexPath.row);
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView*)cv layout:(UICollectionViewLayout*)cvl sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
//
//    AssetWrapper *assetWrapper = self.fetchedAssets[indexPath.row];
//    UIImage *thumbNail = [UIImage imageWithCGImage:assetWrapper.asset.thumbnail];
//
//    CGSize retval = thumbNail.size.width > 0.0f ? thumbNail.size : CGSizeMake(100.0f, 100.0f);
//    NSLog(@"size of thumbnail W: %f h: %f", retval.width, retval.height);
//    retval.height += 35.0f;
//    retval.width += 35.0f;
//    return retval
//}
//
- (UIEdgeInsets)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)cvl insetForSectionAtIndex:(NSInteger)section {
    
    //return UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    
    return UIEdgeInsetsZero;
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        //[self.delegate swapToCameraFromPhotoPicker:self];
        [self presentViewController:self.cameraPicker animated:YES completion:NULL];
        
        // Launch the camera
        //        UIImage *cameraImage = [UIImage imageNamed:@"camera"];
        //        NSLog(@"camera image %@", cameraImage);
        
    }
    //    else {
    //        AssetWrapper *assetWrapper = self.fetchedAssets[indexPath.row-1];
    //        [assetWrapper setSelected:![assetWrapper isSelected]];
    //        [self.assetPickerState changeSelectionState:[assetWrapper isSelected] forAsset:assetWrapper.asset];
    //        PhotoCell *cell =[cv cellForItemAtIndexPath:indexPath];
    //
    //
    //
    //        UIImage *thumbNail = [UIImage imageWithCGImage:assetWrapper.asset.thumbnail];
    //        NSLog(@"selecting image for row %d", indexPath.row);
    //    }
    
}

- (BOOL)collectionView:(UICollectionView *)cv shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // Launch the camera
        //        UIImage *cameraImage = [UIImage imageNamed:@"camera"];
        //        NSLog(@"camera image %@", cameraImage);
        
        return YES;
        
    } else {
        AssetWrapper *assetWrapper = self.fetchedAssets[indexPath.row-1];
        [assetWrapper setSelected:![assetWrapper isSelected]];
        [self.assetPicker changeSelectionState:[assetWrapper isSelected] forAsset:assetWrapper.asset];
        PhotoCell *cell = (PhotoCell *)[cv cellForItemAtIndexPath:indexPath];
        
        if ([assetWrapper isSelected]) {
            [cell selectCell:YES];
        } else {
            [cell selectCell:NO];
        }
        //[cell setHighlighted:[assetWrapper isSelected]];
        //[cell setNeedsDisplay];
        
        
        
        NSLog(@"Selecting image for row %ld", (long)indexPath.row);
        return [assetWrapper isSelected];
    }
}

#pragma ImagePicker Delegate Protocols
- (void)imagePickerController:(UIImagePickerController *)cameraPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    
    [cameraPicker dismissViewControllerAnimated:NO completion:^{
        NSArray *selectedImages = @[chosenImage];
        [self.delegate finishedPhotoPicker:self withCameraTakenImages:selectedImages];
    }];
    
}



@end
