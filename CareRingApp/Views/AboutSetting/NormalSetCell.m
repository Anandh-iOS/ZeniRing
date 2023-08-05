//
//  DeviceSetCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/28.
//

#import "NormalSetCell.h"

@implementation NormalSetCell

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
        self.rightLabel = [UILabel new];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self layoutBase];
    }
    
    return self;
}

-(void)layoutBase {
    
    [self.contentView addSubview:self.rightLabel];
    
    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).inset(8);
        make.centerY.equalTo(self.contentView);
    }];
    
}

-(void)addArrow {
    
    _arrowImageView = [UIImageView new];
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).inset(8);
        make.centerY.equalTo(self.contentView);
        
    }];
    _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    _arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
    
    
    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_arrowImageView.mas_leading).inset(3);
        make.centerY.equalTo(self.contentView);
    }];
    
}

@end
