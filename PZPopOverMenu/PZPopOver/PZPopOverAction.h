//
//  PZPopOverAction.h
//  PZPopOverMenu
//
//  Created by lipzh7 on 2022/2/16.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PZPopOverViewStyle) {
    PZPopOverViewStyleDefault,
    PZPopOverViewStyleDark
};

@class PZPopOverAction;
typedef void(^PZPopOverActionHandler)(PZPopOverAction *action);



@interface PZPopOverAction : NSObject
@property (nonatomic, strong, readonly) UIImage *image; ///< 图标 (建议使用 60pix*60pix 的图片)
@property (nonatomic, copy, readonly) NSString *title; ///< 标题
@property (nonatomic, copy, readonly) void(^handler)(PZPopOverAction *action);

+ (instancetype)actionWithTitle:(NSString *)title handler:(PZPopOverActionHandler) handler;

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(PZPopOverActionHandler) handler;
@end


