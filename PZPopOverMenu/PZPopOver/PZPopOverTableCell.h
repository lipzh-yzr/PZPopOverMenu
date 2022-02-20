//
//  PZPopOverTableCellTableViewCell.h
//  PZPopOverMenu
//
//  Created by lipzh7 on 2022/2/16.
//

#import <UIKit/UIKit.h>
#import "PZPopOverAction.h"

UIKIT_EXTERN float const PopoverViewCellHorizontalMargin; ///< 水平间距边距
UIKIT_EXTERN float const PopoverViewCellVerticalMargin; ///< 垂直边距
UIKIT_EXTERN float const PopoverViewCellTitleLeftEdge; ///< 标题左边边距
#define POPOVERTITLEFONT ([UIFont systemFontOfSize:15])

@interface PZPopOverTableCell : UITableViewCell
@property(nonatomic) PZPopOverViewStyle style;

-(void) configWithAction:(PZPopOverAction *) action;
-(void) setBottomLineHidden:(BOOL) hidden;
+(UIColor *) bottomLineColorForStyle:(PZPopOverViewStyle) style;
@end


