//
//  PZPopOverView.h
//  PZPopOverMenu
//
//  Created by lipzh7 on 2022/2/16.
//

#import <UIKit/UIKit.h>
#import "PZPopOverAction.h"
NS_ASSUME_NONNULL_BEGIN

@interface PZPopOverView : UIView

@property(nonatomic) BOOL hidesAfterTouchOutside;
@property(nonatomic) BOOL showShade;
@property(nonatomic) PZPopOverViewStyle pz_viewStyle;

-(void) showMenuFromView:(UIView *) view withActions:(NSArray<PZPopOverAction *> *) actionArr;

/// show menu from point
/// @param point the point must be specified in the coordinate system of the key window's bounds
/// @param actionArr action array
-(void) showMenuFromPoint:(CGPoint) point withActions:(NSArray<PZPopOverAction *> *) actionArr;
@end

NS_ASSUME_NONNULL_END
