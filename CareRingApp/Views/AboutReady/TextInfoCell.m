//
//  TextInfoCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/13.
//

#import "TextInfoCell.h"
#import "constants.h"
#import "ConfigModel.h"

@implementation TextInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
  
    UIView *bgview = [UIView new];
    bgview.backgroundColor = ITEM_BG_COLOR;
    bgview.layer.masksToBounds = YES;
    bgview.layer.cornerRadius = ITEM_CORNOR_RADIUS;
    
    [self.contentView addSubview:bgview];
    [self.contentView addSubview:self.infoView];

    
    CGFloat margin = 15.f;
    
    [bgview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(bgview.superview);
        make.bottom.equalTo(self.infoView.mas_bottom).offset(5);
    }];
    
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(margin);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.trailing.equalTo(self.contentView.mas_trailing).inset(margin);
        make.bottom.equalTo(self.contentView.mas_bottom).inset(margin);
//        make.height.greaterThanOrEqualTo(@100);
    }];
    
}

-(TextInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[TextInfoView alloc]init];
        
    }
    return _infoView;
}

@end

