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

@protocol passColorProtocol <NSObject>

@required
-(void)passColor:(int *)hue;

@end

@interface ColorsViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id<passColorProtocol> delegate;
@property int *hue;

@end
