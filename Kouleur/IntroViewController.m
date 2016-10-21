//
//  IntroViewController.m
//  Kouleur
//
//  Created by iMac on 10/18/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "IntroViewController.h"


@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.INTROVIEW.backgroundColor = [[UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.INTROVIEW.frame andColors:@[[[UIColor colorWithHexString:@"DAE2F8"]colorWithAlphaComponent:1.0],[[UIColor colorWithHexString:@"D6A4A4"]colorWithAlphaComponent:0.80]]]colorWithAlphaComponent:0.8];
    
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
