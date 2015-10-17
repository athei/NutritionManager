//
//  SSCheckMark.h
//  NutritionManager
//
//  Created by Alexander Theißen on 17.10.15.
//
//

@import UIKit;

typedef NS_ENUM( NSUInteger, SSCheckMarkStyle )
{
    SSCheckMarkStyleOpenCircle,
    SSCheckMarkStyleGrayedOut
};

@interface SSCheckMark : UIView

@property (nonatomic, readwrite) bool checked;
@property (nonatomic, readwrite) SSCheckMarkStyle checkMarkStyle;

@end