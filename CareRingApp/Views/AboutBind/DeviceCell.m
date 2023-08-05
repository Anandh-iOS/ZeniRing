//
//  DeviceCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/14.
//

#import "DeviceCell.h"
#import "ConfigModel.h"

@implementation DeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = ITEM_BG_COLOR;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
