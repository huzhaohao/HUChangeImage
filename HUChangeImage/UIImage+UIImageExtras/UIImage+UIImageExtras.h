//
//  UIImage+UIImageExtras.h
//  CHangeImage
//
//  Created by elec on 16/4/28.
//  Copyright © 2016年 elec. All rights reserved.
//

#import<UIKit/UIKit.h>

@interface UIImage (UIImageExtras)
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;
@end