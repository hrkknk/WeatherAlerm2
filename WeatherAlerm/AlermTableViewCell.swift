//
//  AlermTableViewCell.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/06.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit

protocol AlermTableViewDelegate: class {
    func saveSwitchOnOff(index: Int)
}

class AlermTableViewCell: UITableViewCell {
    
    weak var delegate: AlermTableViewDelegate?
    
    //自分のrow(Controller側から設定してもらう)
    private var row: Int = 0
    public func setRow(row: Int) -> Void {
        self.row = row
        return
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var isOnSwitch: UISwitch!
    @IBAction func switchOnOff(_ sender: UISwitch) {
        delegate?.saveSwitchOnOff(index: self.row)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
