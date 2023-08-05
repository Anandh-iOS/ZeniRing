//
//  OtherSettingVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/27.
//

#import "OtherSettingVc.h"
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import "ConfigModel.h"
#import "NormalSetCell.h"
#import "HMUserdefaultUtil.h"
#import "UIViewController+Custom.h"

#import "DeviceCenter.h"
#import "AppDelegate.h"

#import "HMShowPrivacyVc.h"
#import "NotificationNameHeader.h"

typedef NS_ENUM(NSInteger, OTHER_SET) {
//    OTHER_SET_UNIT,     // 单位
//    OTHER_SET_NOTIFY,   // 通知
//    OTHER_SET_PRIVACY,  //隐私
//    OTHER_SET_USE_AGREEMNET, // 使用条款
    OTHER_SET_APP_SOFT, // app版本
//    OTHER_SET_LOGOUT,   // 登出
   
};

@interface OtherSettingVc ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)NSArray <NSArray<NSNumber *> *> *dataArray;
@end

@implementation OtherSettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self arrowback:nil];

}

-(void)initUI {
    self.navigationItem.title = _L(L_SET_ITEM_TITLE_MYSET);
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.leading.equalTo(self.view).offset(VC_ITEM_MARGIN_HOR);
        make.trailing.equalTo(self.view).inset(VC_ITEM_MARGIN_HOR);

        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
}
-(void)initData {
    

    
    NSArray *secction_three = @[ @(OTHER_SET_APP_SOFT),
                                 ];

    
    self.dataArray = @[ secction_three];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray[section].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NormalSetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalSetCell class]) forIndexPath:indexPath];
    switch (self.dataArray[indexPath.section][indexPath.row].integerValue) {
       
        case   OTHER_SET_APP_SOFT: // app版本
        {
            cell.textLabel.text = _L(L_TITLE_APP_SOFT_VER);
            cell.rightLabel.text = [NSString stringWithFormat:@"V%@", [ConfigModel appVersion]];
            cell.textLabel.textColor = UIColor.whiteColor;

        }
            break;
      
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:20];
    label.textColor = UIColor.whiteColor;
    
    if (section == 0) {
        label.text = _L(L_SECTION_TIL_GEN_SET);// 一般设置
    }
    
    if ( section == 1 ) {
        label.text = _L(L_SECTION_TIL_PRIVACY); //
    }
    
    if (section == 2) {
        label.text = _L(L_SECTION_TIL_SOFT_INFO);
    }
    
    return label;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


-(void)noticeSwitch {
    
    UIAlertController *sheetControl  = [UIAlertController alertControllerWithTitle:_L(L_TIPS_NOTICE_SWITCH) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:_L(L_CANCEL) style:UIAlertActionStyleCancel handler:nil];
    [sheetControl addAction:cancel];
    WEAK_SELF
    UIAlertAction *metricAction = [UIAlertAction actionWithTitle:_L(L_TXT_ON) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        
        [HMUserdefaultUtil setNoticeOn:YES];
        [strongSelf.tableView reloadData];
    }];
    
    [sheetControl addAction:metricAction];
    UIAlertAction *imperialAction = [UIAlertAction actionWithTitle:_L(L_TXT_OFF) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [HMUserdefaultUtil setNoticeOn:NO];

        [strongSelf.tableView reloadData];
    }];
    [sheetControl addAction:imperialAction];
    
    [self presentViewController:sheetControl animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = ITEM_CORNOR_RADIUS;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //        CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds,0, 0);
    
    if (indexPath.row == 0
        && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 仅有一条
        UIBezierPath *backBezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius];
        
        layer.path = backBezierPath.CGPath;
        cell.layer.mask = layer;
    } else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        CGPathCloseSubpath(pathRef);
        layer.path = pathRef;
        cell.layer.mask = layer;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        layer.path = pathRef;
        cell.layer.mask = layer;
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    //           layer.path = pathRef;
    //        backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    //           CFRelease(pathRef);
    //       if (indexPath.row == 0 || indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
    //           cell.layer.mask = layer;
    //
    //       }
    cell.backgroundColor = ITEM_BG_COLOR;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
//        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[NormalSetCell class] forCellReuseIdentifier:NSStringFromClass([NormalSetCell class])];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0f;
        }
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

@end
