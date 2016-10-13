//
//  EditingViewController.h
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "HUMSlider.h"
#import "MZFormSheetPresentationViewController.h"
#import "MZFormSheetPresentationViewControllerSegue.h"

@import QuartzCore;
@import CoreImage;
@import AVFoundation;
@import OpenGLES;
@import CoreMedia;
@import CoreVideo;

@interface EditingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UIImage *editingImage;

@property (nonatomic, strong) HMSegmentedControl *filtersSegmentedControl;
@property (nonatomic, strong) HMSegmentedControl *bottomSegmentedControl;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *categoriesView;

@property (nonatomic, weak) CIFilter *colorMonochrome;
@property (nonatomic, weak) CIFilter *WhitePointAdjust;

@property (nonatomic, strong) UIView *brightnessView;
@property (nonatomic, strong) UIView *opacityView;
@property (nonatomic, strong) UIView *saturationView;

@property (nonatomic, strong) HUMSlider *brightnessSlider;
@property (nonatomic, strong) HUMSlider *opacitySlider;
@property (nonatomic, strong) HUMSlider *saturationSlider;
@property (weak, nonatomic) IBOutlet UIView *filterView;


@end
