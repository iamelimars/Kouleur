//
//  AlbumsTableViewController.h
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosViewController.h"
@import Photos;

@interface AlbumsTableViewController : UITableViewController <PHPhotoLibraryChangeObserver>


@property (nonatomic, strong) NSArray *sectionFetchResults;
@property (nonatomic, strong) NSArray *sectionLocalizedTitles;


- (IBAction)backToCamera:(id)sender;


@end
