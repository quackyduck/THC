//
//  AlbumListController.m
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AlbumListController.h"
#import "AsseptPicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCollectionController.h"

#define orangeColor [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1]

@interface AlbumListController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *assetGroups; // Model (all groups of assets).

@end

@implementation AlbumListController

@synthesize assetPicker = _assetPicker;
@synthesize assetGroups = _assetGroups;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.assetGroups = [NSMutableArray array];
        self.assetPicker = [[AsseptPicker alloc] init];
        self.assetPicker.selectionLimit = 4;
    }
    return self;
}

#pragma mark - View Lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.assetPicker clearSelection];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeView];
    // Get the Camera album assets to display
    [self getCameraLibraryAssets];
}

- (void)initializeView {

    self.navigationItem.title = @"Loading…";

//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
    
    self.navigationController.navigationBar.tintColor = orangeColor;
    self.navigationController.navigationBar.barTintColor = self.tableView.backgroundColor;


    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                           target:self
//                                                                                           action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_close_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction:)];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    
//    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];

}

- (void)getCameraLibraryAssets {
    [self.assetPicker.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // If group is nil, the end has been reached.
        if (group == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.title = @"Albums";
            });
            return;
        }
        
        // Add the group to the array.
        //NSLog(@"Adding a group %@", group);
        [self.assetGroups addObject:group];
        
        // Reload the tableview on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"Calling table reload");
            [self.tableView reloadData];
        });
        
    } failureBlock:^(NSError *error) {
        // TODO: User denied access. Tell them we can't do anything.
        NSLog(@"unable to load library %@", [error localizedDescription]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Actions

- (void)cancelButtonAction:(id)sender
{
    [self.delegate cancelPhotoPicker:self];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = self.tableView.backgroundColor;
    
    // Get the group from the datasource.
    ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]]; // TODO: Make this a delegate choice.
    
    // Setup the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", [group valueForProperty:ALAssetsGroupPropertyName], (long)[group numberOfAssets]];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]]; // TODO: Make this a delegate choice.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PhotoCollectionController *pcc = [[PhotoCollectionController alloc] init];
    pcc.assetPicker = self.assetPicker;
    pcc.assetsGroup      = group;
    pcc.delegate = self.delegate;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:pcc animated:YES];
    
    
    //
    //    WSAssetTableViewController *assetTableViewController = [[WSAssetTableViewController alloc] initWithStyle:UITableViewStylePlain];
    //    assetTableViewController.assetPickerState = self.assetPickerState;
    //    assetTableViewController.assetsGroup = group;
    //
    //    [self.navigationController pushViewController:assetTableViewController animated:YES];
}

#define ROW_HEIGHT 65.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ROW_HEIGHT;
}

@end
