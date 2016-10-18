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
#import "ColorsViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "GPUImage.h"



@import QuartzCore;
@import CoreImage;
@import AVFoundation;
@import OpenGLES;
@import CoreMedia;
@import CoreVideo;
@import CoreGraphics;
@protocol PassColorDelegate;

@interface EditingViewController : UIViewController <PassColorDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *editingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UIImage *editingImage;
@property (weak, nonatomic) UIImage *inputImage;
@property (strong, nonatomic) UIImage *newwImage;

@property (nonatomic, strong) HMSegmentedControl *filtersSegmentedControl;
@property (nonatomic, strong) HMSegmentedControl *bottomSegmentedControl;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *categoriesView;
- (IBAction)backToCamera:(id)sender;
- (IBAction)toSharePage:(id)sender;

@property (nonatomic, weak) CIFilter *colorMonochrome;
@property (nonatomic, weak) CIFilter *WhitePointAdjust;
@property (nonatomic, weak) CIFilter *filter;

@property (nonatomic, strong) UIView *brightnessView;
@property (nonatomic, strong) UIView *opacityView;
@property (nonatomic, strong) UIView *saturationView;

@property (strong, nonatomic) GPUImageBrightnessFilter *brightnessFilter;
@property (strong, nonatomic) GPUImageSaturationFilter *saturationFilter;
@property (strong, nonatomic) GPUImageRGBFilter *rgbFilter;
@property (strong, nonatomic) GPUImageOpacityFilter *opacityFilter;
@property (strong, nonatomic) GPUImagePicture *fx_image;
@property (strong, nonatomic) GPUImageHueFilter *hueFilter;
@property (strong, nonatomic) GPUImageMonochromeFilter *monochromeFilter;


@property (nonatomic, strong) HUMSlider *brightnessSlider;
@property (nonatomic, strong) HUMSlider *opacitySlider;
@property (nonatomic, strong) HUMSlider *saturationSlider;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (nonatomic) NSString *filterName;
@property (strong, nonatomic) NSString *currentFilter;

@property (strong, nonatomic) UIColor* filterColor;
@property (strong, nonatomic) UIColor* gpuColor;

@property (nonatomic) CGColorRef colors;

@property BOOL isHueSelected;
@property BOOL filterIsActive;
@property CGFloat currentHue;

-(void)updateHue;

@end
