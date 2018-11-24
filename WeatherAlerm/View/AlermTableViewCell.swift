//
//  AlermTableViewCell.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/06.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit


/*
 アラーム一覧画面のセル
 ・AlermTableViewDelegateを保持
 */
class AlermTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    weak var delegate: AlermTableViewDelegate?
    
    //自分のrow(Controller側から設定してもらう)
    private var row: Int = 0
    public func getRow() -> Int {
        return row
    }
    public func setRow(row: Int) -> Void {
        self.row = row
        return
    }
    
    //MARK: - Outlets
    //アラーム時刻
    @IBOutlet weak var timeLabel: UILabel!
    
    //アラームON/OFF状態
    @IBOutlet weak var isOnSwitch: UISwitch!
    
    
    //MARK: - Actions
    //スイッチON/OFFを切り替える
    @IBAction func switchOnOff(_ sender: UISwitch) {
        delegate?.saveSwitchOnOff(index: self.row)
    }
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func enableEditButton(_ enabled: Bool) {
//        self.editButton.isEnabled = enabled
//    }
}

//MARK - Protocol
//コントローラ側にDelegateになってもらい、セルごとのスイッチON/OFF状態を記憶する
protocol AlermTableViewDelegate: class {
    func saveSwitchOnOff(index: Int)
}
