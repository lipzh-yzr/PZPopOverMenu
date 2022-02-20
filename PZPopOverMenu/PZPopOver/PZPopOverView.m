//
//  PZPopOverView.m
//  PZPopOverMenu
//
//  Created by lipzh7 on 2022/2/16.
//

#import "PZPopOverView.h"
#import "PZPopOverTableCell.h"
#import "Masonry.h"

static CGFloat const kPopoverViewMargin = 8.f;        ///< 边距
static CGFloat const kPopoverViewCellHeight = 40.f;   ///< cell指定高度
static CGFloat const kPopoverViewArrowHeight = 13.f;  ///< 箭头高度
static NSString *cellId = @"PZPopOverCellId";

float PopoverViewDegreesToRadians(float angle)
{
    return angle*M_PI/180;
}

@interface PZPopOverView () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak) UIWindow *currentWindow;
@property(nonatomic) UIView *maskView;
@property(nonatomic) UITableView *tableView;
@property(nonatomic, weak) CAShapeLayer *borderLayer;
@property(nonatomic, weak) UITapGestureRecognizer *tapGesture;

@property(nonatomic, copy) NSArray<PZPopOverAction *> *actions;
@property(nonatomic) CGFloat windowWidth;
@property(nonatomic) CGFloat windowHeight;
/// the direction of the arrow and view body, default to Yes
@property(nonatomic) BOOL isUpward;
@end

@implementation PZPopOverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _actions = @[];
        _isUpward = YES;
        _pz_viewStyle = PZPopOverViewStyleDefault;
        self.backgroundColor = [UIColor whiteColor];
        
        _currentWindow = [UIApplication sharedApplication].windows.lastObject;
        _windowWidth = CGRectGetWidth(_currentWindow.bounds);
        _windowHeight = CGRectGetHeight(_currentWindow.bounds);
        
        _maskView = [[UIView alloc] initWithFrame:_currentWindow.bounds];
        [self setShowShade:NO];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopoverView)];
        [_maskView addGestureRecognizer:tapGesture];
        _tapGesture = tapGesture;
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.trailing.offset(0);
                    make.top.offset(self.isUpward? kPopoverViewArrowHeight:0);
                    make.height.equalTo(self).offset(-kPopoverViewArrowHeight);
        }];
        
    }
    return self;
}

#pragma mark - setter
- (void)setShowShade:(BOOL)showShade {
    _showShade = showShade;
    
    _maskView.backgroundColor = _showShade? [UIColor colorWithWhite:0.f alpha:0.18f]: UIColor.clearColor;
    if (_borderLayer) {
        _borderLayer.strokeColor = _showShade? UIColor.clearColor.CGColor: _tableView.separatorColor.CGColor;
    }
}

- (void)setPz_viewStyle:(PZPopOverViewStyle)pz_viewStyle {
    _pz_viewStyle = pz_viewStyle;
    self.backgroundColor = _pz_viewStyle == PZPopOverViewStyleDefault? UIColor.whiteColor: [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.00];
}

- (void)setHidesAfterTouchOutside:(BOOL)hidesAfterTouchOutside {
    _hidesAfterTouchOutside = hidesAfterTouchOutside;
    _tapGesture.enabled = _hidesAfterTouchOutside;
}

#pragma mark - tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:PZPopOverTableCell.class forCellReuseIdentifier:cellId];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPopoverViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PZPopOverTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.style = _pz_viewStyle;
    [cell configWithAction:_actions[indexPath.row]];
    [cell setBottomLineHidden:indexPath.row == _actions.count-1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.25f animations:^{
            self.alpha = 0.f;
            self.maskView.alpha = 0.f;
        } completion:^(BOOL finished) {
            if (finished) {
                PZPopOverAction *action = self.actions[indexPath.row];
                action.handler? action.handler(action): NULL;
                [self removeFromSuperview];
                [self.maskView removeFromSuperview];
            }
        }];
}

#pragma mark - private
-(void) hidePopoverView {
    [UIView animateWithDuration:0.25f animations:^{
            self.alpha = 0.f;
            self.maskView.alpha = 0.f;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                [self.maskView removeFromSuperview];
            }
        }];
}

-(void) showMenuFromPoint:(CGPoint) point {
    CGFloat arrowWidth = 28;
    CGFloat cornerRadius = 6.f;
    CGFloat arrowCornerRadius = 2.5f;
    CGFloat arrowBottomCornerRadius = 4.f;
    
    CGFloat minX = kPopoverViewMargin + cornerRadius + arrowWidth/2 + 2;
    if (point.x < minX) {
        point.x = minX;
    }
    if (_windowWidth - point.x < minX) {
        point.x = _windowWidth - minX;
    }
    
    _maskView.alpha = 0;
    [_currentWindow addSubview:_maskView];
    
//    CGFloat currentWidth = [self calculateMaxWidth];
//    CGFloat currentHeight = 0;
//
//    if (_actions.count == 0) {
//        currentWidth = 150;
//        currentHeight = 20;
//    }
//    CGFloat currentX = point.x - currentWidth/2;
//
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(currentWidth);
//        if (self.isUpward) {
//            make.bottom.lessThanOrEqualTo(self.superview).offset(-kPopoverViewMargin).priorityHigh();
//            make.top.mas_equalTo(point.y).priorityHigh();
//        } else {
//            make.top.greaterThanOrEqualTo(self.superview).offset(kPopoverViewMargin).priorityHigh();
//            make.bottom.mas_equalTo(point.y).priorityHigh();
//        }
//    }];
//
//    if (_actions.count == 0) {
//
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//
//                    make.height.mas_equalTo(currentHeight).offset(kPopoverViewArrowHeight);
//        }];
//    } else {
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//
//                    make.height.mas_equalTo(self.tableView).offset(kPopoverViewArrowHeight);
//        }];
//    }
    // 刷新数据以获取具体的ContentSize
    [_tableView reloadData];
    // 根据刷新后的ContentSize和箭头指向方向来设置当前视图的frame
    CGFloat currentW = [self calculateMaxWidth]; // 宽度通过计算获取最大值
    CGFloat currentH = _tableView.contentSize.height;
    
    // 如果 actions 为空则使用默认的宽高
    if (_actions.count == 0) {
        currentW = 150.0;
        currentH = 20.0;
    }
    
    // 箭头高度
    currentH += kPopoverViewArrowHeight;
    
    // 限制最高高度, 免得选项太多时超出屏幕
    CGFloat maxHeight = _isUpward ? (_windowHeight - point.y - kPopoverViewMargin) : (point.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    if (currentH > maxHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
        currentH = maxHeight;
        _tableView.scrollEnabled = YES;
        if (!_isUpward) { // 箭头指向下则移动到最后一行
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_actions.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    CGFloat currentX = point.x - currentW/2, currentY = point.y;
    // x: 窗口靠左
    if (point.x <= currentW/2 + kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    // x: 窗口靠右
    if (_windowWidth - point.x <= currentW/2 + kPopoverViewMargin) {
        currentX = _windowWidth - kPopoverViewMargin - currentW;
    }
    // y: 箭头向下
    if (!_isUpward) {
        currentY = point.y - currentH;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // make the arrow
    CGPoint arrowPoint = [self convertPoint:point fromView:_currentWindow];
    CGFloat maskTop = _isUpward? kPopoverViewArrowHeight:0;
    CGFloat maskBottom = _isUpward? currentH:currentH - kPopoverViewArrowHeight;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(0, cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + maskTop) radius:cornerRadius startAngle:PopoverViewDegreesToRadians(180) endAngle:PopoverViewDegreesToRadians(270) clockwise:YES];
    
    if (_isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, arrowCornerRadius) controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, arrowCornerRadius) controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverViewArrowHeight) controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, kPopoverViewArrowHeight)];
    }
    
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(currentW - cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskTop + cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(270)
                      endAngle:PopoverViewDegreesToRadians(0)
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(currentW, maskBottom - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(0)
                      endAngle:PopoverViewDegreesToRadians(90)
                     clockwise:YES];
    
    if (!_isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, currentH - kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, currentH - arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, currentH - arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, currentH - kPopoverViewArrowHeight)
                         controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
        
    }
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(90)
                      endAngle:PopoverViewDegreesToRadians(180)
                     clockwise:YES];
    [maskPath closePath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    if (!_showShade) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = self.bounds;
        borderLayer.path = maskPath.CGPath;
        borderLayer.lineWidth = 1;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [PZPopOverTableCell bottomLineColorForStyle:_pz_viewStyle].CGColor;
        [self.layer addSublayer:borderLayer];
        _borderLayer = borderLayer;
    }
    
    [_currentWindow addSubview:self];
    
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/currentW, _isUpward?0:1);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.maskView.alpha = 1;
    }];
}

-(CGFloat) calculateMaxWidth {
    CGFloat maxWidth = 0.f, titleLeftEdge = 0.f, imageWidth = 0.f, imageMaxHeight = kPopoverViewCellHeight - PopoverViewCellVerticalMargin*2, titleWidth = 0, contentWidth = 0;
    CGSize imageSize;
    for (PZPopOverAction *action in _actions) {
        imageWidth = 0; titleLeftEdge = 0; titleWidth = 0;
        if (action.image) {
            titleLeftEdge = PopoverViewCellTitleLeftEdge;
            imageSize = action.image.size;
            
            if (imageSize.height > imageMaxHeight) {
                imageWidth = imageSize.width * imageMaxHeight/imageSize.height;
            } else {
                imageWidth = imageSize.width;
            }
        }
//        if (@available(iOS 7.0, *)) {
//        }
        titleWidth = [action.title sizeWithAttributes:@{NSFontAttributeName:POPOVERTITLEFONT}].width;
        contentWidth = PopoverViewCellHorizontalMargin * 2 + imageWidth + titleLeftEdge + titleWidth;
        maxWidth = MAX(maxWidth, ceil(contentWidth));
    }
    
    if (maxWidth > CGRectGetWidth(_currentWindow.bounds) - kPopoverViewMargin*2) {
        maxWidth = CGRectGetWidth(_currentWindow.bounds) - kPopoverViewMargin*2;
    }
    
    return maxWidth;
}

#pragma mark - public
- (void)showMenuFromView:(UIView *)view withActions:(NSArray<PZPopOverAction *> *)actionArr {
    CGRect viewRect = [view convertRect:view.bounds toView:_currentWindow];
    CGFloat viewAboveHeight = CGRectGetMinY(viewRect);
    CGFloat viewUnderHeight = _windowHeight - CGRectGetMaxY(viewRect);
    
    CGPoint point = CGPointMake(CGRectGetMidX(viewRect), 0);
    if (viewAboveHeight > viewUnderHeight) {
        point.y = viewAboveHeight - 5;
    } else {
        point.y = CGRectGetMaxY(viewRect) + 5;
    }
    
    _isUpward = viewAboveHeight <= viewUnderHeight;
    
    _actions = actionArr? actionArr.copy: @[];
    [self showMenuFromPoint:point];
}

- (void)showMenuFromPoint:(CGPoint)point withActions:(NSArray<PZPopOverAction *> *)actionArr {
    _actions = actionArr? actionArr.copy: @[];
    _isUpward = point.y <= _windowHeight - point.y;
    [self showMenuFromPoint:point];
}

@end
