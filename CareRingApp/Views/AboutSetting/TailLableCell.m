//
//  TailLableCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/27.
//

#import "TailLableCell.h"



@implementation TailLableCell

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
        _tailLbl = [UILabel new];
        _tailLbl.textAlignment = NSTextAlignmentRight;
        [self layoutBase];
    }
    return self;
}

-(void)layoutBase {
    [self.contentView addSubview:self.tailLbl];
    [self.tailLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).inset(15);
    }];
    
}



@end
