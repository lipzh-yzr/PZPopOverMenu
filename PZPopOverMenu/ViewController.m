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
    
    // ?????????????????? action
    PZPopOverAction *multichatAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_multichat"] title:@"??????????????????" handler:^(PZPopOverAction *action) {
#pragma mark - ???Block????????????????????????, Block???????????????????????????????????????.
        _noticeLabel.text = action.title;
    }];
    // ????????? action
    PZPopOverAction *addFriAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_addFri"] title:@"?????????" handler:^(PZPopOverAction *action) {
        _noticeLabel.text = action.title;
    }];
    // ????????? action
    PZPopOverAction *QRAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_QR"] title:@"?????????" handler:^(PZPopOverAction *action) {
        _noticeLabel.text = action.title;
    }];
    // ??????????????? action
    PZPopOverAction *facetofaceAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_facetoface"] title:@"???????????????" handler:^(PZPopOverAction *action) {
        _noticeLabel.text = action.title;
    }];
    // ?????? action
    PZPopOverAction *payMoneyAction = [PZPopOverAction actionWithImage:[UIImage imageNamed:@"right_menu_payMoney"] title:@"??????" handler:^(PZPopOverAction *action) {
        _noticeLabel.text = action.title;
    }];
    [qqPopView showMenuFromView:sender withActions:@[multichatAction, addFriAction, QRAction, facetofaceAction, payMoneyAction]];
}

@end
