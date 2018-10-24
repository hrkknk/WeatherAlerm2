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
    var alerm: Alerm?

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

