//
//  Alerm.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/06.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit

class Alerm {
    
    //MARK: Properties
    
    var time: Date
    var weather: String
    var isOn: Bool
    
    
    //MARK: Initialization
    
    init?(time: Date, weather: String) {
        //TODO: エラー処理ちゃんと書く
        if weather.isEmpty  {
            return nil
        }
        
        // Initialize stored properties.
        self.time = time
        self.weather = weather
        //アラーム生成したらデフォルトON
        self.isOn = true
    }
    
    //MARK: - Public methods
    func getDateAsString() -> String {
        // 日付のフォーマッタ
        let dateFormatter = DateFormatter()
        // 日付の出力形式を決める
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        // TODO: localeはあとで変更
        dateFormatter.locale = Locale(identifier: "ja_JP")
        
        return dateFormatter.string(from: time)
    }
    
}
