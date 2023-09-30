//
//  HealthDataCell.swift
//
//
//  Created by Anandh Selvam on 22/09/23.
//

import UIKit
import SnapKit


struct scoreCardCellData
{
    var titleString: String
    var subTitleString: String
    var scoreString: String
    var scoreCommentString: String
    var iconImage: UIImage
    var bgImage: UIImage
}

class scoreCardCell: UITableViewCell
{
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let scoreLabel = UILabel()
    let scoreComment = UILabel()
    let arrowImage = UIImageView()
    let iconImage = UIImageView()
    let bgImage = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Configure your labels
        titleLabel.textColor = constants.mainWhite()
        titleLabel.font = UIFont(name: constants.fontPopinsregular(), size: constants.fontNavTitleSize())

        subTitleLabel.textColor = constants.mainWhite()
        subTitleLabel.font = UIFont(name: constants.fontPopinsregular(), size: constants.fontNavSubTitleSize())
        
        scoreLabel.textColor = constants.mainWhite()
        scoreLabel.font = UIFont(name: constants.fontPopinsregular(), size: constants.fontHealthCellScore())
        scoreLabel.sizeToFit()
        
        
        scoreComment.textColor = constants.mainWhite()
        scoreComment.textAlignment = .center
        scoreComment.font = UIFont(name: constants.fontPopinsregular(), size: constants.fontNavTitleSize())

        arrowImage.image = UIImage(named: "filled_Image")

        contentView.addSubview(bgImage)
        contentView.addSubview(iconImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(scoreComment)
        contentView.addSubview(arrowImage)
        
       
        bgImage.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.right.equalTo(contentView).offset(-20)
            
        }
        
        iconImage.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.left.equalTo(contentView).offset(30)
            make.top.equalTo(contentView).offset(30)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(18)
            make.right.equalTo(contentView).offset(-40)
            make.bottom.equalTo(contentView).offset(-40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(25)
            make.height.equalTo(30)
            make.left.equalTo(iconImage.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(70)
            make.centerX.equalTo(contentView)
        }
        
        scoreComment.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(scoreLabel.snp.bottom).offset(5)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(30)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(scoreComment.snp.bottom).offset(8)
        }
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func configure(with data: scoreCardCellData) {
        
        titleLabel.text = data.titleString
        subTitleLabel.text = data.subTitleString
        scoreLabel.text = data.scoreString
        scoreComment.text = data.scoreCommentString
        bgImage.image = data.bgImage
        iconImage.image = data.iconImage
        
        
    }

    
    
}
