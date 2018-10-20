//
//  WeatherViewController.swift
//  WeatherAlerm
//
//  Created by Ryo Fujimoto on 2018/10/20.
//  Copyright © 2018 金子宏樹. All rights reserved.
//

import UIKit

protocol WeatherViewDelegate: class {
    // 天気を設定するメソッド
    func setWeather(weather: String)
}

class WeatherViewController: UIViewController {
    
    var delegate: WeatherViewDelegate?
    
    @IBAction func setWeatherSunny(_ sender: UIButton) {
        //天気をsunnyに設定
        delegate?.setWeather(weather: "Sunny")
        print("Sunny")
        //前の画面に戻る
        
    }
    @IBAction func setWeatherRainy(_ sender: UIButton) {
        //天気をrainyに設定
        delegate?.setWeather(weather: "Rainy")
        print("Rainy")
        //前に画面に戻る
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
