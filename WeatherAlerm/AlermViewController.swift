//
//  ViewController.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/08/12.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit

class AlermViewController: UIViewController, WeatherViewDelegate {

    // MARK: - Properties
    var alerm: Alerm? = Alerm(time: Date(), weather: "Sunny")

    //MARK: - Outlets
    @IBOutlet weak var selectedWeather: UILabel!
    
    //MARK: - Actions
    //キャンセルボタン
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setAlermDate(_ sender: UIDatePicker) {
       alerm!.time = sender.date
    }
    
    //MARK: - Methods
    func setWeather(weather: String) {
        alerm!.weather = weather
        print("\(alerm!.weather)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //前画面(アラーム一覧画面)がSunny/RainyどちらだったかによってselectedWeatherを切り替え
        self.selectedWeather.text = "\(self.alerm!.weather) >"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //画面再表示の度にselectedWeatherを更新
        self.selectedWeather.text = "\(self.alerm!.weather) >"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "SelectWeather":
                //UINavigationControllerを取得
                guard let navigationController = segue.destination as? UINavigationController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                //UINavigationControllerの次の画面(WeatherViewController)を取得
                guard let weatherViewController = navigationController.topViewController as? WeatherViewController else {
                    fatalError("Unexpected topViewController: \(String(describing: navigationController.topViewController))")
                }
                
                //次の画面(WeatherViewController)のデリゲートにselfをセット
                weatherViewController.delegate = self
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}

