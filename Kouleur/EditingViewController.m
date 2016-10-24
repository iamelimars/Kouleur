//
//  EditingViewController.m
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "EditingViewController.h"

#import "ColorsViewController.h"


@interface EditingViewController ()


@end

static NSString *currentWhitePoint = @"WhitePoint";
static NSString *currentMonochrome = @"Monochrome";
static NSString *currentFill = @"Fill";

@implementation EditingViewController
@synthesize filtersSegmentedControl, bottomSegmentedControl, brightnessView, opacityView, saturationView, brightnessSlider, saturationSlider, opacitySlider, currentHue, filter, filterColor, colors, brightnessFilter, fx_image, saturationFilter, opacityFilter, inputImage, newwImage, hueFilter, rgbFilter, gpuColor, monochromeFilter;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.currentFilter = currentWhitePoint;
    self.isHueSelected = NO;
    self.filterIsActive = YES;
    self.filterView.hidden = YES;
    self.filterName = @"CIWhitePointAdjust";
    gpuColor = [[UIColor alloc]init];
    
    brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    saturationFilter = [[GPUImageSaturationFilter alloc]init];
    opacityFilter = [[GPUImageOpacityFilter alloc] init];
    hueFilter = [[GPUImageHueFilter alloc]init];
    rgbFilter = [[GPUImageRGBFilter alloc]init];
    monochromeFilter = [[GPUImageMonochromeFilter alloc]init];
    [hueFilter setHue:5.0];
    self.imageView.image = self.editingImage;
    inputImage = self.imageView.image;
    
    newwImage = inputImage;
    fx_image = [[GPUImagePicture alloc] initWithImage:inputImage];
    [fx_image addTarget:rgbFilter];
    [rgbFilter addTarget:brightnessFilter];
    [brightnessFilter addTarget:saturationFilter];
    [saturationFilter addTarget:opacityFilter];
    [opacityFilter useNextFrameForImageCapture];
    [fx_image processImage];
    
    
    // Do any additional setup after loading the view.
    [self createEditingControls];
    [self createOpacity];
    [self createSaturation];
    [self createBrightness];
    //[self createFilter];
    
    self.nativeExpressAdView.adUnitID = @"ca-app-pub-9906091830733745/2747091311";
    self.nativeExpressAdView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [self.nativeExpressAdView loadRequest:request];
    
    self.whitePointOpacity = self.opacitySlider.value;
    self.whitePointSaturation = self.saturationSlider.value;
    self.whitePointBrightness = self.brightnessSlider.value;
    
    self.fillOpacity = 0.5;
    self.fillSaturation = 0.5;
    self.fillBrightness = 0.5;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    //self.imageView.image = self.editingImage;
    //self.editingImageView.image = self.editingImage;
    //self.filterView.backgroundColor = [UIColor colorWithHue:0.350000 saturation:1.0 brightness:1.0 alpha:1.0];
    //self.filterColor = [UIColor colorWithHue:currentHue saturation:1.0 brightness:1.0 alpha:0.7];
    

}

-(void)ColorFilter:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue{
    self.currentFilter = currentWhitePoint;
    [rgbFilter setRed:red];
    [rgbFilter setGreen:green];
    [rgbFilter setBlue:blue];
    
    [fx_image addTarget:rgbFilter];
    [rgbFilter addTarget:brightnessFilter];
    [brightnessFilter addTarget:saturationFilter];
    [saturationFilter addTarget:opacityFilter];
    [opacityFilter useNextFrameForImageCapture];
    [fx_image processImage];
}
-(void)updateUI {
    [brightnessFilter setBrightness:self.brightnessSlider.value];
    [opacityFilter useNextFrameForImageCapture];
    [fx_image processImage];
    UIImage *final_image = [opacityFilter imageFromCurrentFramebuffer];
    UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
    final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:originalOrientation];
    self.imageView.image = final_image;
    
    
}
-(void)didChangeToWhitePoint {
    
    self.opacitySlider.maximumValue = 1.0;
    self.opacitySlider.minimumValue = 0.0;
    
    self.saturationSlider.maximumValue = 2.0;
    self.saturationSlider.minimumValue = 0.0;
    
    self.brightnessSlider.maximumValue = 0.55;
    self.brightnessSlider.minimumValue = -0.5;
    
    [self.opacitySlider setValue:self.whitePointOpacity animated:YES];
    [self.saturationSlider setValue:self.whitePointSaturation animated:YES];
    [self.brightnessSlider setValue:self.whitePointBrightness animated:YES];
    
    NSLog(@"This is the whitePointOpacity value %f", self.whitePointOpacity);
    NSLog(@"This is the whitePointSaturation value %f", self.whitePointSaturation);
    NSLog(@"This is the whitePointBrightness value %f", self.whitePointBrightness);
    
}

-(void)didChangeTofill {
    
    self.opacitySlider.maximumValue = 1.0;
    self.opacitySlider.minimumValue = 0.0;
    
    self.saturationSlider.maximumValue = 1.0;
    self.saturationSlider.minimumValue = 0.0;
    
    self.brightnessSlider.maximumValue = 1.0;
    self.brightnessSlider.minimumValue = 0.0;
    
    [self.opacitySlider setValue:self.fillOpacity animated:YES];
    [self.saturationSlider setValue:self.fillSaturation animated:YES];
    [self.brightnessSlider setValue:self.fillBrightness animated:YES];
    
    
}
/*
-(void)createFilter {
    self.editingImageView.image = self.editingImage;
    
    UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
    colors = [self.filterColor CGColor];
    if (self.filterColor == nil) {
        //NSLog(@"colorssssss");
    }
    NSLog(@"%@", colors);
    
    //self.filterColor = [UIColor colorWithHue:self.currentHue saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:self.opacitySlider.value];
    //filtercolor = [filtercolor CGColor];
    CIImage *inputImage = [[CIImage alloc] initWithCGImage:[self.imageView.image CGImage]];
    filter = [CIFilter filterWithName:self.filterName];
    [filter setDefaults];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[CIColor colorWithCGColor:colors] forKey:@"inputColor"];
    CIImage *outputImage = [filter valueForKey:@"outputImage"];
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
    CIContext *myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    
    CGImageRef imgRef = [myContext createCGImage:outputImage fromRect:outputImage.extent];
    
    UIImage* img = [[UIImage alloc] initWithCGImage:imgRef scale:1.0 orientation:originalOrientation];
    
    CGImageRelease(imgRef);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.editingImageView.image = img;
    });

//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    
//    dispatch_async(concurrentQueue, ^{
//
//
//        
//        UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
//        colors = [self.filterColor CGColor];
//        if (self.filterColor == nil) {
//            //NSLog(@"colorssssss");
//        }
//        NSLog(@"%@", colors);
//        
//        //self.filterColor = [UIColor colorWithHue:self.currentHue saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:self.opacitySlider.value];
//        //filtercolor = [filtercolor CGColor];
//        CIImage *inputImage = [[CIImage alloc] initWithCGImage:[self.imageView.image CGImage]];
//        filter = [CIFilter filterWithName:self.filterName];
//        [filter setDefaults];
//        [filter setValue:inputImage forKey:@"inputImage"];
//        [filter setValue:[CIColor colorWithCGColor:colors] forKey:@"inputColor"];
//        CIImage *outputImage = [filter valueForKey:@"outputImage"];
//        EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//        NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
//        CIContext *myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
//        
//        CGImageRef imgRef = [myContext createCGImage:outputImage fromRect:outputImage.extent];
//        
//        UIImage* img = [[UIImage alloc] initWithCGImage:imgRef scale:1.0 orientation:originalOrientation];
//        
//        CGImageRelease(imgRef);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.editingImageView.image = img;
//        });
//        
//        
//    });
    
    
}
*/
-(void)removeFilter {
    
    self.imageView.image = self.editingImage;
    
}

-(void)createEditingControls {
    
    filtersSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"White Point", @"Fill", @"None"]];
    //[segmentedControl3 setFrame:CGRectMake(0, viewHeight-120, viewWidth, 60)];
    [filtersSegmentedControl setFrame:CGRectMake(self.bottomView.frame.origin.x, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
    
    [filtersSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        ;
    }];
    filtersSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    filtersSegmentedControl.selectionIndicatorHeight = 1.0f;
    filtersSegmentedControl.backgroundColor = [UIColor whiteColor];
    filtersSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    filtersSegmentedControl.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-UltraLight" size:17]};
    filtersSegmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    filtersSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    filtersSegmentedControl.selectedSegmentIndex = HMSegmentedControlNoSegment;
    self.filtersSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor flatWatermelonColor]};
    filtersSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Light" size:17]};
    filtersSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    filtersSegmentedControl.shouldAnimateUserSelection = YES;
    filtersSegmentedControl.tag = 2;
    [filtersSegmentedControl addTarget:self action:@selector(filterSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.bottomView addSubview:filtersSegmentedControl];
    filtersSegmentedControl.hidden = NO;
    self.filtersSegmentedControl.selectedSegmentIndex = 0;
    

    
    bottomSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[ @"Filters",@"Colors", @"Opacity", @"Saturation", @"Brightness",]];
    //[segmentedControl4 setFrame:CGRectMake(0, viewHeight- 60, viewWidth, 60)];
    [bottomSegmentedControl setFrame:CGRectMake(self.categoriesView.frame.origin.x, 0, self.categoriesView.frame.size.width, self.categoriesView.frame.size.height)];
    [bottomSegmentedControl setIndexChangeBlock:^(NSInteger index) {
    }];
    bottomSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    bottomSegmentedControl.selectionIndicatorHeight = 1.0f;
    bottomSegmentedControl.backgroundColor = [UIColor whiteColor];
    bottomSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    bottomSegmentedControl.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-UltraLight" size:17]};

    self.bottomSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    bottomSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Light" size:17]};
    bottomSegmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    bottomSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    bottomSegmentedControl.selectedSegmentIndex = HMSegmentedControlNoSegment;
    bottomSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    bottomSegmentedControl.shouldAnimateUserSelection = YES;
    bottomSegmentedControl.tag = 2;
    [bottomSegmentedControl addTarget:self action:@selector(bottomSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.bottomSegmentedControl.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [self.categoriesView addSubview:bottomSegmentedControl];
    

    
}

-(void)bottomSegmentedControl:(id)sender{
    
    switch (self.bottomSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.filtersSegmentedControl.hidden = NO;
            saturationView.hidden = YES;
            opacityView.hidden = YES;
            brightnessView.hidden = YES;
            break;
        case 1:
            [self toColorsViewController];
            self.filtersSegmentedControl.hidden = YES;
            break;
        case 2:
            self.filtersSegmentedControl.hidden = YES;
            saturationView.hidden = YES;
            brightnessView.hidden = YES;
            opacityView.hidden = NO;
            break;
        case 3:
            self.filtersSegmentedControl.hidden = YES;
            opacityView.hidden = YES;
            brightnessView.hidden = YES;
            saturationView.hidden = NO;
            break;
        case 4:
            self.filtersSegmentedControl.hidden = YES;
            opacityView.hidden = YES;
            saturationView.hidden = YES;
            brightnessView.hidden = NO;
            break;
        default:
            break;
    }
    

}


-(void)toColorsViewController {
    
    ColorsViewController *colorsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ColorsViewController"];
    [colorsVC setDelegate:self];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc]initWithContentViewController:colorsVC];
    formSheetController.presentationController.contentViewSize = CGSizeMake(self.view.frame.size.width * 0.80, self.view.frame.size.height * 0.75);
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    //formSheetController.presentationController.shouldApplyBackgroundBlurEffect = YES;
    formSheetController.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionAll;
    formSheetController.allowDismissByPanningPresentedView = YES;
    [self presentViewController:formSheetController animated:YES completion:nil];
    
}

-(void)filterSegmentedControl:(id)sender{

    if (self.isHueSelected == NO) {
        self.filterView.hidden = YES;
    } else {
    
        if (self.filtersSegmentedControl.selectedSegmentIndex == 0) {
            
            self.fillOpacity = self.opacitySlider.value;
            self.fillSaturation = self.saturationSlider.value;
            self.fillBrightness = self.brightnessSlider.value;
            self.filterView.hidden = YES;
            [self didChangeToWhitePoint];
            
            self.filterIsActive = YES;
            self.filterName = @"CIWhitePointAdjust";
            self.currentFilter = currentWhitePoint;
            gpuColor = [UIColor colorWithHue:self.currentHue saturation:1.0 brightness:1.0 alpha:1.0];
            
            CGFloat red, green, blue, alpha;
            [gpuColor getRed:&red green:&green blue:&blue alpha:&alpha];
            [rgbFilter setRed:red];
            [rgbFilter setGreen:green];
            [rgbFilter setBlue:blue];
            
            [self ColorFilter:red Green:green Blue:blue];

            
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Color" message:@"Adjust the brightness, saturation or opacity!" backgroundColor:[UIColor colorWithHexString:@"DAE2F8"] textColor:[UIColor flatBlackColor]];
            
            
            NSLog(@"Started on White Point");

            
        } else if (self.filtersSegmentedControl.selectedSegmentIndex == 1) {
            
            self.whitePointOpacity = self.opacitySlider.value;
            self.whitePointSaturation = self.saturationSlider.value;
            self.whitePointBrightness = self.brightnessSlider.value;
            
            
            NSLog(@"This is the whitePointOpacity value %f", self.whitePointOpacity);
            NSLog(@"This is the whitePointSaturation value %f", self.whitePointSaturation);
            NSLog(@"This is the whitePointBrightness value %f", self.whitePointBrightness);
            
            [self didChangeTofill];
            
            self.filterIsActive = NO;
            self.filterView.hidden = NO;
            self.currentFilter = currentFill;
            [self removeFilter];
            NSLog(@"Fill");
            
            [RKDropdownAlert title:@"Color" message:@"Adjust the brightness, saturation or opacity!" backgroundColor:[UIColor colorWithHexString:@"D6A4A4"] textColor:[UIColor flatBlackColor]];
            
        } else if (self.filtersSegmentedControl.selectedSegmentIndex == 2) {
            
            self.filterIsActive = NO;
            self.filterView.hidden = YES;
            [self removeFilter];
            NSLog(@"None");
            
            
        }
        
//        switch (self.filtersSegmentedControl.selectedSegmentIndex) {
//            case 0:
//                self.fillOpacity = self.opacitySlider.value;
//                self.fillSaturation = self.saturationSlider.value;
//                self.fillBrightness = self.brightnessSlider.value;
//                self.filterView.hidden = YES;
//                [self didChangeToWhitePoint];
//                
//                self.filterIsActive = YES;
//                self.filterName = @"CIWhitePointAdjust";
//                self.currentFilter = currentWhitePoint;
//                gpuColor = [UIColor colorWithHue:self.currentHue saturation:1.0 brightness:1.0 alpha:1.0];
//                
//                CGFloat red, green, blue, alpha;
//                [gpuColor getRed:&red green:&green blue:&blue alpha:&alpha];
//                [rgbFilter setRed:red];
//                [rgbFilter setGreen:green];
//                [rgbFilter setBlue:blue];
//                
//                [self ColorFilter:red Green:green Blue:blue];
//                
//                //[self createFilter];
//                
//                NSLog(@"Started on White Point");
//                
//                break;
//            case 1:
//                self.whitePointOpacity = self.opacitySlider.value;
//                self.whitePointSaturation = self.saturationSlider.value;
//                self.whitePointBrightness = self.brightnessSlider.value;
//                
//                
//                NSLog(@"This is the whitePointOpacity value %f", self.whitePointOpacity);
//                NSLog(@"This is the whitePointSaturation value %f", self.whitePointSaturation);
//                NSLog(@"This is the whitePointBrightness value %f", self.whitePointBrightness);
//                
//                [self didChangeTofill];
//                
//                self.filterIsActive = NO;
//                self.filterView.hidden = NO;
//                self.currentFilter = currentFill;
//                [self removeFilter];
//                NSLog(@"Fill");
//                break;
//            case 2:
//                self.filterIsActive = NO;
//                self.filterView.hidden = YES;
//                [self removeFilter];
//                NSLog(@"None");
//                break;
//                
//            default:
//                break;
//        }
    }


}


#pragma mark - sliders

-(void)createBrightness{
    
    int viewWidth = CGRectGetWidth(self.view.frame); //375
    int sliderWidth = viewWidth - 100;
    int sliderHeight = filtersSegmentedControl.frame.size.height - ((filtersSegmentedControl.frame.size.height/5)*2);
    
    brightnessView = [[UIView alloc]initWithFrame:filtersSegmentedControl.bounds];
    brightnessSlider = [[HUMSlider alloc]init];
    [brightnessSlider setMinimumValue:-0.5f];
    [brightnessSlider setMaximumValue:0.55f];
    [brightnessSlider setValue:0.0f];
    brightnessSlider.continuous = YES;
    
    brightnessSlider.sectionCount = 11;
    brightnessSlider.tickColor = [UIColor blackColor];
    brightnessSlider.maximumTrackTintColor = [UIColor clearColor];
    brightnessSlider.minimumTrackTintColor = [UIColor clearColor];
    
    
    [brightnessView addSubview:brightnessSlider];
    brightnessSlider.frame = CGRectMake(50, (filtersSegmentedControl.frame.size.height/5), sliderWidth, sliderHeight);
    [brightnessSlider setUserInteractionEnabled:YES];
    [brightnessSlider addTarget:self action:@selector(brightnessSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.bottomView addSubview:brightnessView];
    [brightnessView setClipsToBounds:YES];
    
    brightnessView.hidden = YES;
    
    
}

-(void)createOpacity{
    int viewWidth = CGRectGetWidth(self.view.frame); //375
    int sliderWidth = viewWidth - 100;
    int sliderHeight = filtersSegmentedControl.frame.size.height - ((filtersSegmentedControl.frame.size.height/5)*2);
    
    opacityView = [[UIView alloc]initWithFrame:filtersSegmentedControl.frame];
    opacitySlider = [[HUMSlider alloc]init];
    [opacitySlider setMinimumValue:0.2f];
    [opacitySlider setMaximumValue:1.0f];
    [opacitySlider setValue:0.6f];
    opacitySlider.continuous = YES;
    
    opacitySlider.sectionCount = 11;
    opacitySlider.tickColor = [UIColor blackColor];
    opacitySlider.maximumTrackTintColor = [UIColor clearColor];
    opacitySlider.minimumTrackTintColor = [UIColor clearColor];
    
    
    opacityView.backgroundColor = [UIColor whiteColor];
    [opacityView addSubview:opacitySlider];
    opacitySlider.frame = CGRectMake(50, (filtersSegmentedControl.frame.size.height/5), sliderWidth, sliderHeight);
    [opacitySlider setUserInteractionEnabled:YES];
    [opacitySlider addTarget:self action:@selector(opacitySliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.bottomView addSubview:opacityView];
    [opacityView setClipsToBounds:YES];
    
    opacityView.hidden = YES;
    
    
}
-(void)createSaturation{
    int viewWidth = CGRectGetWidth(self.view.frame); //375
    int sliderWidth = viewWidth - 100;
    int sliderHeight = filtersSegmentedControl.frame.size.height - ((filtersSegmentedControl.frame.size.height/5)*2);
    
    saturationView = [[UIView alloc]initWithFrame:filtersSegmentedControl.frame];
    saturationSlider = [[HUMSlider alloc]init];
    [saturationSlider setMinimumValue:0.0f];
    [saturationSlider setMaximumValue:1.0f];
    [saturationSlider setValue:0.5f];
    
    saturationSlider.sectionCount = 11;
    saturationSlider.tickColor = [UIColor blackColor];
    saturationSlider.maximumTrackTintColor = [UIColor clearColor];
    saturationSlider.minimumTrackTintColor = [UIColor clearColor];
    
    
    
    [saturationSlider setMinimumTrackTintColor:[UIColor clearColor]];
    [saturationSlider setMaximumTrackTintColor:[UIColor clearColor]];
    
    
    saturationSlider.continuous = YES;
    saturationView.backgroundColor = [UIColor whiteColor];
    [saturationView addSubview:saturationSlider];
    saturationSlider.frame = CGRectMake(50, (filtersSegmentedControl.frame.size.height/5), sliderWidth, sliderHeight);
    [saturationSlider setUserInteractionEnabled:YES];
    [saturationSlider addTarget:self action:@selector(saturationSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.bottomView addSubview:saturationView];
    [saturationView setUserInteractionEnabled:YES];
    [saturationView setClipsToBounds:YES];
    saturationView.hidden = YES;
    
}

#pragma mark - sliderActions

-(void)brightnessSliderChanged:(id)sender{
    
//    CGFloat sliderValue = self.brightnessSlider.value;
//    self.filterColor = [UIColor colorWithHue:currentHue saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:self.opacitySlider.value];
//    colors = [[UIColor colorWithHue:currentHue saturation:1.0 brightness:self.brightnessSlider.value alpha:1.0] CGColor];
//    [filter setValue:[CIColor colorWithCGColor:colors] forKey:@"inputColor"];
//    CIImage *outputImage = filter.outputImage;
//    CGImageRef imgRef = [myContext createCGImage:outputImage fromRect:outputImage.extent];
//    
//    UIImage* img = [[UIImage alloc] initWithCGImage:imgRef];
//    CGImageRelease(imgRef);
//    
//    
//    
//    self.imageView.image = img;
//        [self createFilter];
    
    if (self.filterIsActive == YES) {
        
//        if (self.currentFilter == currentMonochrome) {
//            
//            [brightnessFilter setBrightness:self.brightnessSlider.value];
//            [saturationFilter useNextFrameForImageCapture];
//            [fx_image processImage];
//            UIImage *final_image = [saturationFilter imageFromCurrentFramebuffer];
//            UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
//            final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:originalOrientation];
//            self.imageView.image = final_image;
//            
//        } else {
        
            [brightnessFilter setBrightness:self.brightnessSlider.value];
            [opacityFilter useNextFrameForImageCapture];
            [fx_image processImage];
            UIImage *final_image = [opacityFilter imageFromCurrentFramebuffer];
            UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
            final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:originalOrientation];
            self.imageView.image = final_image;
        
//        }
    } else {
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.filterView.backgroundColor = [UIColor colorWithHue:currentHue saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:self.opacitySlider.value];
        
        });
    }
    
    
    
}

-(void)opacitySliderChanged:(id)sender{
    if (self.filterIsActive == YES) {
//        if (self.currentFilter == currentMonochrome) {
//            
//            [monochromeFilter setIntensity:self.opacitySlider.value];
//            [monochromeFilter useNextFrameForImageCapture];
//            [fx_image processImage];
//            UIImage *final_image = [monochromeFilter imageFromCurrentFramebuffer];
//            UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
//            final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:originalOrientation];
//            self.imageView.image = final_image;
//            
//        } else {
        
            [opacityFilter setOpacity:[(UISlider *)sender value]];
            [opacityFilter useNextFrameForImageCapture];
            [fx_image processImage];
            UIImage *final_image = [opacityFilter imageFromCurrentFramebuffer];
            UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
            final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:originalOrientation];
            self.imageView.image = final_image;
//        }
        
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.filterView.backgroundColor = [UIColor colorWithHue:currentHue saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:self.opacitySlider.value];
            
        });
    }

    
    
    
}
-(void)saturationSliderChanged:(id)sender{
    if (self.filterIsActive == YES) {
//        if (self.currentFilter == currentMonochrome) {
//            
//            [saturationFilter setSaturation:self.saturationSlider.value];
//            [saturationFilter useNextFrameForImageCapture];
//            [fx_image processImage];
//            UIImage *final_image = [saturationFilter imageFromCurrentFramebuffer];
//            UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
//            final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:originalOrientation];
//            self.imageView.image = final_image;
//
//            
//        } else {
        
            [saturationFilter setSaturation:self.saturationSlider.value];
            [opacityFilter useNextFrameForImageCapture];
            [fx_image processImage];
            UIImage *final_image = [opacityFilter imageFromCurrentFramebuffer];
            UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
            //CGFloat originalScale = self.imageView.image.scale;
            final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:    originalOrientation];
            self.imageView.image = final_image;
        
//        }
        
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.filterView.backgroundColor = [UIColor colorWithHue:currentHue saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:self.opacitySlider.value];
            
        });
    }

    
    
    
}           

#pragma mark - PassColorDelegate Methods

-(void)passColor:(NSString *)hue {
    
    NSLog(@"%@", hue);
    NSLog(@"test");
}
-(void)passHueValue:(CGFloat)hueValue {
    
    NSLog(@"This is the hue value %f", hueValue * 360.0);
    self.currentHue = hueValue;
    
    
    
    gpuColor = [UIColor colorWithHue:hueValue saturation:1.0 brightness:1.0 alpha:1.0];
    CGFloat red, green, blue, alpha;
    
    [gpuColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [rgbFilter setRed:red];
    [rgbFilter setGreen:green];
    [rgbFilter setBlue:blue];
    [opacityFilter setOpacity:0.65];
    if (self.currentFilter == currentWhitePoint) {
        
        [self ColorFilter:red Green:green Blue:blue];
        UIImage *final_image = [opacityFilter imageFromCurrentFramebuffer];
        UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:originalOrientation];
        self.imageView.image = final_image;
        self.filtersSegmentedControl.hidden = NO;
        saturationView.hidden = YES;
        opacityView.hidden = YES;
        brightnessView.hidden = YES;
        [self.bottomSegmentedControl setSelectedSegmentIndex:0 animated:YES];
        [self.filtersSegmentedControl setSelectedSegmentIndex:0 animated:YES];
        
    } else if (self.currentFilter == currentFill) {
        
        
        self.filterView.backgroundColor = [UIColor colorWithHue:hueValue saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:self.opacitySlider.value];
        self.filtersSegmentedControl.hidden = NO;
        saturationView.hidden = YES;
        opacityView.hidden = YES;
        brightnessView.hidden = YES;
        [self.bottomSegmentedControl setSelectedSegmentIndex:0 animated:YES];
        [self.filtersSegmentedControl setSelectedSegmentIndex:1 animated:YES];
        
    }
//    else if (self.currentFilter == currentMonochrome) {
//        [self MonchromeFilter:red Green:green Blue:blue Intensity:self.opacitySlider.value];
//        UIImage *final_image = [monochromeFilter imageFromCurrentFramebuffer];
//        UIImageOrientation originalOrientation = self.imageView.image.imageOrientation;
//        final_image = [UIImage imageWithCGImage:[final_image CGImage] scale:1.0 orientation:originalOrientation];
//        self.imageView.image = final_image;
//    }
//    [opacityFilter useNextFrameForImageCapture];
//    [fx_image processImage];
    
    
}

-(void)getrgbFromHue: (CGFloat)red :(CGFloat)green :(CGFloat)blue {
    
    
    
}


-(void)isHueSelected:(BOOL)selected {
    
    self.isHueSelected = selected;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier  isEqual: @"toSharePage"]) {
        UIImage *lastImage = self.imageView.image;
        if (self.filterIsActive == NO) {
            [self.imageView addSubview:self.filterView];
            UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.imageView.layer renderInContext:context];
            UIImage *images = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.imageView.image = images;
            
            //lastImage = images;
            UINavigationController *nav = segue.destinationViewController;
            ShareViewController *shareVC = (ShareViewController *)nav.topViewController;
            shareVC.finalImage = images;
            
            NSLog(@"image was sent from editing vc");
            if (images != nil) {
                NSLog(@"YES!");
            }
            [self.filterView removeFromSuperview];

            
        }else {
            
            UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.imageView.layer renderInContext:context];
            UIImage *images = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        self.imageView.image = images;
        
            //lastImage = images;
            UINavigationController *nav = segue.destinationViewController;
            ShareViewController *shareVC = (ShareViewController *)nav.topViewController;
            shareVC.finalImage = images;
        
            NSLog(@"image was sent from editing vc");
            if (images != nil) {
                NSLog(@"YES!");
            }
            
            
        }
    }
    
    
    
    // Pass the selected object to the new view controller.
}




- (IBAction)backToCamera:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)toSharePage:(id)sender {
}
@end
