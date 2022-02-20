//
//  ViewController.m
//  PZPopOverMenu
//
//  Created by lipzh7 on 2022/2/16.
//

#import "ViewController.h"
#import "PZPopOver/PZPopOverView.h"
#import "Masonry.h"

@interface ViewController ()
@property(nonatomic) UILabel *noticeLabel;
@property(nonatomic) UIButton *qqButton;
@property(nonatomic) UIButton *wechatButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [qqButton setTitle:@"click me" forState:UIControlStateNormal];
    [qqButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqButton];
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(100);
            make.bottom.offset(-100);
    }];
    _qqButton = qqButton;
    
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [wechatButton setTitle:@"click me" forState:UIControlStateNormal];
    [wechatButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatButton];
    [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.offset(100);
    }];
    _wechatButton = wechatButton;
    
    _noticeLabel = [[UILabel alloc] init];
    _noticeLabel.text = @"to be decided";
    _noticeLabel.textColor = UIColor.labelColor;
    [self.view addSubview:_noticeLabel];
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.offset(300);
    }];
}

-(void) buttonClicked:(UIButton *) sender {
    PZPopOverView *qqPopView = [[PZPopOverView alloc] init];
    if (sender == _qqButton) {
        qqPopView.hidesAfterTouchOutside = YES;
        qqPopView.showShade = YES;
        qqPopView.pz_viewStyle = PZPopOverViewStyleDefault;
    } else {
        qqPopView.hidesAfterTouchOutside = NO;
        qqPopView.showShade = NO;
        qqPopView.pz_viewStyle = PZPopOverViewStyleDark;
    }
    
    // 发起多人聊天 action
    PZPopOverAction *multichatAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_multichat"] title:@"发起多人聊天" handler:^(PZPopOverAction *action) {
#pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
        _noticeLabel.text = action.title;
    }];
    // 加好友 action
    PZPopOverAction *addFriAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_addFri"] title:@"加好友" handler:^(PZPopOverAction *action) {
        _noticeLabel.text = action.title;
    }];
    // 扫一扫 action
    PZPopOverAction *QRAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_QR"] title:@"扫一扫" handler:^(PZPopOverAction *action) {
        _noticeLabel.text = action.title;
    }];
    // 面对面快传 action
    PZPopOverAction *facetofaceAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_facetoface"] title:@"面对面快传" handler:^(PZPopOverAction *action) {
        _noticeLabel.text = action.title;
    }];
    // 付款 action
    PZPopOverAction *payMoneyAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_payMoney"] title:@"付款" handler:^(PZPopOverAction *action) {
        _noticeLabel.text = action.title;
    }];
    [qqPopView showMenuFromView:sender withActions:@[multichatAction, addFriAction, QRAction, facetofaceAction, payMoneyAction]];
}

@end
