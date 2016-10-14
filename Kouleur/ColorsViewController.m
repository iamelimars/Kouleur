//
//  ColorsViewController.m
//  Kouleur
//
//  Created by iMac on 10/12/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "ColorsViewController.h"
#import "MZFormSheetPresentationViewController.h"
#import "MZFormSheetPresentationViewControllerSegue.h"


@interface ColorsViewController ()


@end

@implementation ColorsViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 360;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ColorsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHue:indexPath.row/360.0 saturation:0.7 brightness:1.0 alpha:1.0];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@"%f", indexPath.row/360.0);
    int hue = indexPath.row;
    NSLog(@"%d", hue);
    [delegate passColor:&hue];
    
    EditingViewController *editingVC = [[EditingViewController alloc]init];
        editingVC.currentHue = indexPath.row/360.0;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
    
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
