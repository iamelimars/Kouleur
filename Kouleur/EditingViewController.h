//
//  EditingViewController.h
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface EditingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UIImage *editingImage;

@property (nonatomic, strong) HMSegmentedControl *filtersSegmentedControl;
@property (nonatomic, strong) HMSegmentedControl *bottomSegmentedControl;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *categoriesView;


@property (nonatomic, strong) UIView *brightnessView;
@property (nonatomic, strong) UIView *opacityView;
@property (nonatomic, strong) UIView *saturationView;

@end
