//
//  Alerm.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/06.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit
import os.log

class Alerm: NSObject, NSCoding {
    
    //MARK: - Properties
    
    var time: Date
    var weather: String
    var isOn: Bool

    
    //MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("alerms")
    
    
    //MARK: - Types
    
    struct PropertyKey {
        static let time = "time"
        static let weather = "weather"
        static let isOn = "isOn"
    }
    
    
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
    
    init?(time: Date, weather: String, isOn: Bool) {
        //TODO: エラー処理ちゃんと書く
        if weather.isEmpty  {
            return nil
        }
        
        // Initialize stored properties.
        self.time = time
        self.weather = weather
        self.isOn = isOn
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
    
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(weather, forKey: PropertyKey.weather)
        aCoder.encode(isOn, forKey: PropertyKey.isOn)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? Date else {
            os_log("Unable to decode the time for a Alerm object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let weather = aDecoder.decodeObject(forKey: PropertyKey.weather) as? String else {
            os_log("Unable to decode the weather for a Alerm object.", log: OSLog.default, type: .debug)
            return nil
        }
        let isOn = aDecoder.decodeBool(forKey: PropertyKey.isOn)
        
        // Must call designated initializer.
        self.init(time: time, weather: weather, isOn: isOn)
    }
    
}
