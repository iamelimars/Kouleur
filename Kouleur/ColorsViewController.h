//
//  ColorsViewController.h
//  Kouleur
//
//  Created by iMac on 10/12/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorsCollectionViewCell.h"
#import "EditingViewController.h"

@protocol PassColorDelegate <NSObject>

-(void)passColor:(NSString *)hue;
-(void)passHueValue:(CGFloat)hueValue;

@end

@interface ColorsViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id<PassColorDelegate>delegate;
@property int *huee;

@end
