//
//  PZPopOverTableCellTableViewCell.m
//  PZPopOverMenu
//
//  Created by lipzh7 on 2022/2/16.
//

#import "PZPopOverTableCell.h"
#import "Masonry.h"

float const PopoverViewCellHorizontalMargin = 15.f; ///< 水平间距边距
float const PopoverViewCellVerticalMargin = 3.f; ///< 垂直边距
float const PopoverViewCellTitleLeftEdge = 8.f; ///< 标题左边边距
#define LINECOLOR_FORSTYLE(STYLE) STYLE == PZPopOverViewStyleDefault ? [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00] : [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.00]


@interface PZPopOverTableCell ()
@property(nonatomic) UIButton *button;
@property(nonatomic) UIView *bottomLine;
@end

@implementation PZPopOverTableCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.userInteractionEnabled = NO; // has no use for UserInteraction.
        
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_button setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.leading.offset(PopoverViewCellHorizontalMargin);
            make.trailing.offset(-PopoverViewCellHorizontalMargin);
            make.top.offset(PopoverViewCellVerticalMargin);
            make.bottom.offset(-PopoverViewCellVerticalMargin);
        }];
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
        
        [self.contentView addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(1);
                    make.leading.trailing.bottom.offset(0);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = _style == PZPopOverViewStyleDefault ? [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00] : [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.00];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundColor = _style == PZPopOverViewStyleDefault ? UIColor.whiteColor : [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.5];
        }];
    }
}

#pragma mark - public
+(UIColor *) bottomLineColorForStyle:(PZPopOverViewStyle) style {
    return style == PZPopOverViewStyleDefault? [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00] : [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.00];
}
-(void) configWithAction:(PZPopOverAction *) action {
    [_button setImage:action.image forState:UIControlStateNormal];
    [_button setTitle:action.title forState:UIControlStateNormal];
    _button.titleEdgeInsets = action.image ? UIEdgeInsetsMake(0, PopoverViewCellTitleLeftEdge, 0, -PopoverViewCellTitleLeftEdge) : UIEdgeInsetsZero;
}
-(void) setBottomLineHidden:(BOOL) hidden {
    [_bottomLine setHidden:hidden];
}

- (void)setStyle:(PZPopOverViewStyle)style {
    _style = style;
    self.backgroundColor = _style == PZPopOverViewStyleDefault ? UIColor.whiteColor : [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.5];
    _bottomLine.backgroundColor = [self.class bottomLineColorForStyle:style];
    if (_style == PZPopOverViewStyleDefault) {
        [_button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    } else {
        [_button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}

#pragma mark - private


@end
