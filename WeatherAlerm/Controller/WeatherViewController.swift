//
//  WeatherViewController.swift
//  WeatherAlerm
//
//  Created by Ryo Fujimoto on 2018/10/20.
//  Copyright © 2018 金子宏樹. All rights reserved.
//

import UIKit

//MARK - Protocol
protocol WeatherViewDelegate: class {
    // 天気を設定するメソッド
    func setWeather(weather: String)
}

class WeatherViewController: UIViewController {
    
    //MARK: - Properties
    var delegate: WeatherViewDelegate?
    
    //MARK: - Actions
    //戻るボタン
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //アラームの天気をSunnyに設定する
    @IBAction func setWeatherSunny(_ sender: UIButton) {
        //天気をsunnyに設定
        delegate?.setWeather(weather: "Sunny")
        //前の画面に戻る
        dismiss(animated: true, completion: nil)

    }
    
    //アラームの天気をRainyに設定する
    @IBAction func setWeatherRainy(_ sender: UIButton) {
        //天気をrainyに設定
        delegate?.setWeather(weather: "Rainy")
        //前に画面に戻る
        dismiss(animated: true, completion: nil)

    }

    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

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
