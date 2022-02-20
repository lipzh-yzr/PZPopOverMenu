//
//  PZPopOverAction.m
//  PZPopOverMenu
//
//  Created by lipzh7 on 2022/2/16.
//

#import "PZPopOverAction.h"

@interface PZPopOverAction ()
@property (nonatomic, strong, readwrite) UIImage *image; ///< 图标 (建议使用 60pix*60pix 的图片)
@property (nonatomic, copy, readwrite) NSString *title; ///< 标题
@property (nonatomic, copy, readwrite) void(^handler)(PZPopOverAction *action);
@end

@implementation PZPopOverAction
+ (instancetype)actionWithTitle:(NSString *)title handler:(PZPopOverActionHandler)handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(PZPopOverActionHandler)handler {
    PZPopOverAction *action = [[PZPopOverAction alloc] init];
    action.image = image;
    action.title = title? :@"";
    action.handler = handler? :NULL;
    return action;
}
@end
