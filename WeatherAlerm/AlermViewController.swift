//
//  ViewController.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/08/12.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit

class AlermViewController: UIViewController, WeatherViewDelegate {
    
    func setWeather(weather: String) {
        alerm!.weather = weather
        print("\(alerm!.weather)")
    }

    // MARK: - Properties
    var alerm: Alerm?
//    var weatherViewController = WeatherViewController()

    @IBOutlet weak var selectedWeather: UILabel!
    @IBAction func setAlermDate(_ sender: UIDatePicker) {
       alerm!.time = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //モデル作成(デフォルト値をセット)
        alerm = Alerm(time: Date(), weather: "Sunny")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "SelectWeather":
                guard let weatherViewController = segue.destination as? WeatherViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                weatherViewController.delegate = self
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
}

