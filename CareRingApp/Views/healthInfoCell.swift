//
//  HealthDataCell.swift
//  
//
//  Created by Anandh Selvam on 22/09/23.
//

import UIKit
import SnapKit

struct healthCellData {
    var titleString: String
    var subTitleString: String
}


class healthInfoCell: UITableViewCell
{
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let arrowImage = UIImageView()
    let lineView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure your labels
        titleLabel.textColor = constants.mainWhite()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: constants.fontPopinsregular(), size: constants.fontNavHealthCell())

        subTitleLabel.textColor = constants.mainWhite()
        subTitleLabel.numberOfLines = 0
        subTitleLabel.font = UIFont(name: constants.fontPopinsregular(), size: constants.fontNavHealthCellSub())

        arrowImage.image = UIImage(named: "arrow_right_white")
      
        
        let imageContainer = UIView()
        // Create a UIStackView for labels
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        labelStackView.axis = .vertical // Vertical stack view
        labelStackView.alignment = .leading // Align items to the leading edge
        labelStackView.spacing = 4 // Adjust spacing between labels

        // Create a UIStackView for labels and arrow image
        let stackView = UIStackView(arrangedSubviews: [labelStackView, imageContainer])
        stackView.axis = .horizontal // Horizontal stack view
        stackView.spacing = 8 // Adjust spacing between items

        lineView.backgroundColor = constants.navTitleGray()
        // Add the stack view to the cell's content view
        contentView.addSubview(stackView)
        contentView.addSubview(lineView)
        imageContainer.addSubview(arrowImage)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.left.equalTo(contentView).offset(25)
            make.right.equalTo(contentView).offset(-30)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(contentView)
            make.height.equalTo(1)
        }
        arrowImage.snp.makeConstraints { make in
            make.width.equalTo(6)
            make.height.equalTo(12)
            make.top.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-40)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func configure(with data: healthCellData, indexPath: IndexPath) {
        
        titleLabel.text = data.titleString
        subTitleLabel.text = data.subTitleString
        if indexPath.row == 0
        {
            arrowImage.isHidden = true
            subTitleLabel.isHidden = true
            lineView.isHidden = false
        }
        else if indexPath.row == 2
        {
            subTitleLabel.isHidden = false
            arrowImage.isHidden = false
            lineView.isHidden = true
        }
        else
        {
            subTitleLabel.isHidden = false
            arrowImage.isHidden = false
            lineView.isHidden = false
            
        }

    }

    
    
}
