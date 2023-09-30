//
//   MainHomeController.swift
//  
//
//  Created by Anandh Selvam on 21/09/23.
//


import UIKit
import SnapKit



class  MainHomeController: UIViewController
{
   
    
    lazy var topCalendarButton: QMUIButton = {
        let button = QMUIButton()
        button.tintColor = constants.mainWhite()
        button.setTitleColor(constants.mainWhite(), for: .normal)
        button.adjustsImageTintColorAutomatically = true
        button.imagePosition = .right
        button.titleLabel?.font = UIFont(name: constants.fontPopinsregular(), size: constants.fontNavTitleSize())
        button.setTitle((utils.L(constants.today()+" ").capitalized), for: .normal)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "btn_calander"), for: .normal)
//        button.addTarget(self, action: #selector(calendaClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var yersterdayButton: QMUIButton = {
        let button = QMUIButton()
        button.setTitleColor(constants.navTitleGray(), for: .normal)
        button.titleLabel?.font = UIFont(name: constants.fontPopinsregular(), size: constants.fontNavSubTitleSize())
        button.setTitle((utils.L(constants.titleDateYesterday()).capitalized), for: .normal)
        button.backgroundColor = UIColor.clear
//        button.addTarget(self, action: #selector(calendaClick(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let healthList = UITableView()
    var scoreCardData : [scoreCardCellData] = [
        scoreCardCellData(titleString: "Today's Readiness", subTitleString: "You’ve  recovered well enough", scoreString: "75", scoreCommentString: "Good", iconImage: UIImage(named: "readiness_icon")!, bgImage: UIImage(named: "cellBGImage3")!),
        scoreCardCellData(titleString: "Sleep score", subTitleString: "You’re in good state", scoreString: "90", scoreCommentString: "Optimal", iconImage: UIImage(named: "sleep_Icon")!, bgImage: UIImage(named: "cellBGImage1")!),
        scoreCardCellData(titleString: "Trends", subTitleString: "You're on track", scoreString: "9.1", scoreCommentString: "Optimal", iconImage: UIImage(named: "trend_icon")!, bgImage: UIImage(named: "cellBGImage2")!)]
    
    
    override func viewDidLoad() {
        
       super.viewDidLoad()
       healthList.separatorStyle = .none
        
       if let navigationBar = self.navigationController?.navigationBar {
           
           navigationBar.shadowImage = UIImage()
           navigationBar.addSubview(topCalendarButton)
           navigationBar.addSubview(yersterdayButton)
           
           // For example, using Auto Layout:
           topCalendarButton.snp.makeConstraints { make in
               make.top.bottom.equalTo(navigationBar)
               make.width.equalTo(100)
               make.centerX.equalTo(navigationBar)
           }
           
           yersterdayButton.snp.makeConstraints { make in
               
               make.top.equalTo(navigationBar).offset(15)
               make.left.equalTo(navigationBar).offset(15)
               make.width.equalTo(100)
               
           }
           
       }
        
        healthList.register(healthInfoCell.self, forCellReuseIdentifier: "healthCell")
        healthList.register(scoreCardCell.self, forCellReuseIdentifier: "scoreCardCell")
        healthList.register(SleepDrawLineCell.self, forCellReuseIdentifier: String(describing: SleepDrawLineCell.self))
        // Set the data source and delegate of your table view
        healthList.dataSource = self
        healthList.delegate = self
        view.addSubview(healthList)
        
        
        healthList.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
        

        







        
        
    }
    

}


extension MainHomeController: UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
        if indexPath.row<3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "healthCell", for: indexPath) as! healthInfoCell
            cell.configure(with: healthCellData(titleString: "Sleep SpO2", subTitleString: "94.3% Avg"), indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row>2 && indexPath.row<6
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCardCell", for: indexPath) as! scoreCardCell
            cell.configure(with: scoreCardData[indexPath.row-3])
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = SleepDrawLineCell(style: .default, reuseIdentifier: String(describing: SleepDrawLineCell.self))
            if indexPath.row == 6 {
                cell.drawObj = DeviceCenter.instance().heartRateObj
            } else if indexPath.row == 7 {
                cell.drawObj = DeviceCenter.instance().hrvObj
            }
            else
            {cell.drawObj = DeviceCenter.instance().hrvObj   
            }
            cell.selectionStyle = .none
            return cell

        }
        
        
        
            
         
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row<3{return 60}
        else if indexPath.row>2 && indexPath.row<6{return 210}
        else {return 450}
            
    }
    
}
