//
//  CamViewController.m
//  Kouleur
//
//  Created by iMac on 10/18/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "CamViewController.h"

@interface CamViewController ()

@end

@implementation CamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cameraButtonView.layer.cornerRadius = self.cameraButtonView.frame.size.height / 2;
    self.cameraPhotoButton.layer.cornerRadius = self.cameraPhotoButton.frame.size.height / 2;
    self.yesPhotoButton.layer.cornerRadius = self.yesPhotoButton.frame.size.height / 2;
    self.cancelPhotoButton.layer.cornerRadius = self.cancelPhotoButton.frame.size.height / 2;
    self.selectButton.layer.cornerRadius = self.selectButton.frame.size.height / 2;
    self.selectButton.clipsToBounds = TRUE;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
