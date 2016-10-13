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

@implementation EditingViewController
@synthesize filtersSegmentedControl, bottomSegmentedControl, brightnessView, opacityView, saturationView, brightnessSlider, saturationSlider, opacitySlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterView.hidden = YES;
    
    // Do any additional setup after loading the view.
    [self createEditingControls];
    [self createOpacity];
    [self createSaturation];
    [self createBrightness];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.imageView.image = self.editingImage;
    
}


-(void)createEditingControls {
    
    filtersSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"White Point", @"Monochrome", @"Fill", @"None"]];
    //[segmentedControl3 setFrame:CGRectMake(0, viewHeight-120, viewWidth, 60)];
    [filtersSegmentedControl setFrame:CGRectMake(self.bottomView.frame.origin.x, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
    
    [filtersSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        ;
    }];
    filtersSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    filtersSegmentedControl.selectionIndicatorHeight = 1.0f;
    filtersSegmentedControl.backgroundColor = [UIColor whiteColor];
    filtersSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    filtersSegmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    filtersSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    filtersSegmentedControl.selectedSegmentIndex = HMSegmentedControlNoSegment;
    self.filtersSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
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
        NSLog(@"Selected index %ld (via block)", (long)index);
    }];
    bottomSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    bottomSegmentedControl.selectionIndicatorHeight = 1.0f;
    bottomSegmentedControl.backgroundColor = [UIColor whiteColor];
    bottomSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.bottomSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    
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
    
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc]initWithContentViewController:colorsVC];
    formSheetController.presentationController.contentViewSize = CGSizeMake(self.view.frame.size.width * 0.80, self.view.frame.size.height * 0.75);

    [self presentViewController:formSheetController animated:YES completion:nil];
    
}

-(void)filterSegmentedControl:(id)sender{

    switch (self.filtersSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.filterView.hidden = YES;
            NSLog(@"White Point");
            break;
        case 1:
            self.filterView.hidden = YES;
            NSLog(@"Monochrome");
            break;
        case 2:
            self.filterView.hidden = NO;
            NSLog(@"Fill");
            break;
        case 3:
            self.filterView.hidden = YES;
            NSLog(@"None");
            break;
        
        default:
            break;
    }
    


}


#pragma mark - sliders

-(void)createBrightness{
    
    int viewWidth = CGRectGetWidth(self.view.frame); //375
    int sliderWidth = viewWidth - 100;
    int sliderHeight = filtersSegmentedControl.frame.size.height - ((filtersSegmentedControl.frame.size.height/5)*2);
    
    brightnessView = [[UIView alloc]initWithFrame:filtersSegmentedControl.bounds];
    brightnessSlider = [[HUMSlider alloc]init];
    [brightnessSlider setMinimumValue:0.2f];
    [brightnessSlider setMaximumValue:1.0f];
    [brightnessSlider setValue:0.6f];
    brightnessSlider.continuous = YES;
    
    brightnessSlider.sectionCount = 11;
    brightnessSlider.tickColor = [UIColor blackColor];
    brightnessSlider.maximumTrackTintColor = [UIColor clearColor];
    brightnessSlider.minimumTrackTintColor = [UIColor clearColor];
    
    
    NSArray *colors;
    //colors = [[NSArray alloc]initWithObjects:[UIColor colorWithHue:_hueInt/360.0 saturation:self.saturationSlider.value brightness:0.0f alpha:opacitySlider.value], [UIColor colorWithHue:_hueInt/360.0 saturation:self.saturationSlider.value brightness:1.0f alpha:opacitySlider.value], nil];
    //brightnessView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.brightnessView.frame.size.width, self.brightnessView.frame.size.height) andColors:colors];
    
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
    
    
    NSArray *colors;
    //colors = [[NSArray alloc]initWithObjects:[UIColor colorWithHue:_hueInt/360.0 saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:0], [UIColor colorWithHue:_hueInt/360.0 saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:1], nil];
    
    //opacityView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.opacityView.frame.size.width, self.opacityView.frame.size.height) andColors:colors];
    
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
    NSLog(@"slider Height %i", sliderHeight);
    
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
    
    NSArray *colorsSaturation;
    //colorsSaturation = [[NSArray alloc]initWithObjects:[UIColor colorWithHue:_hueInt/360.0 saturation:0/100.0 brightness:self.brightnessSlider.value alpha:1], [UIColor colorWithHue:_hueInt/360.0 saturation:100.0/100.0 brightness:self.brightnessSlider.value alpha:1], nil];
    
    //saturationView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.saturationView.frame.size.width, self.saturationView.frame.size.height) andColors:colorsSaturation];
    
    
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
-(void)brightnessSliderChanged:(id)sender{
    //_hueColor = [UIColor colorWithHue:_hueInt/360.0 saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:opacitySlider.value];
    //[self addFilter];
    
    
}

-(void)opacitySliderChanged:(id)sender{
    
   // _hueColor = [UIColor colorWithHue:_hueInt/360.0 saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:opacitySlider.value];
   // [self addFilter];
    
    
}
-(void)saturationSliderChanged:(id)sender{
    
    //NSLog(@"%f", saturationSlider.value);
    //_hueColor = [UIColor colorWithHue:_hueInt/360.0 saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:opacitySlider.value];
    //[self addFilter];
    
   // NSArray *colorsSaturation;
    //colorsSaturation = [[NSArray alloc]initWithObjects:[UIColor colorWithHue:_hueInt/360.0 saturation:0/100.0 brightness:self.brightnessSlider.value alpha:1], [UIColor colorWithHue:_hueInt/360.0 saturation:100.0/100.0 brightness:self.brightnessSlider.value alpha:1], nil];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
