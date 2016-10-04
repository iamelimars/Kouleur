//
//  EditingViewController.m
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "EditingViewController.h"


@interface EditingViewController ()

@end

@implementation EditingViewController
@synthesize filtersSegmentedControl, bottomSegmentedControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createEditingControls];
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
        NSLog(@"Selected index %ld (via block)", (long)index);
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
            break;
        case 1:
            self.filtersSegmentedControl.hidden = YES;
            break;
        case 2:
            self.filtersSegmentedControl.hidden = YES;
            break;
        case 3:
            self.filtersSegmentedControl.hidden = YES;
            break;
        case 4:
            self.filtersSegmentedControl.hidden = YES;
            break;
        default:
            break;
    }
    

}

-(void)filterSegmentedControl:(id)sender{

    switch (self.filtersSegmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            NSLog(@"1");
            break;
        case 2:
            NSLog(@"2");
            break;
        case 3:
            NSLog(@"3");
            break;
        
        default:
            break;
    }
    


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
