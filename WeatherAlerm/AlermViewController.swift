//
//  ViewController.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/08/12.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit
import os.log

class AlermViewController: UIViewController, WeatherViewDelegate {

    // MARK: - Properties
    var alerm: Alerm?
    
    var weatherOfPreviousView: String?

    //MARK: - Outlets
    @IBOutlet weak var selectedWeather: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: - Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //AddAlermで遷移したかEditAlermで遷移したかによってcancelの方法を変える
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func setAlermDate(_ sender: UIDatePicker) {
        alerm!.time = sender.date
    }
    
    //MARK: - Methods
    //
    func setWeather(weather: String) {
        alerm!.weather = weather
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //編集モードの場合、各UIの値を前画面から渡されたアラームの内容に更新
        if let alerm = alerm {
            //時刻引き継ぎ
            self.datePicker.date = alerm.time
            //前画面(アラーム一覧画面)がSunny/RainyどちらだったかによってselectedWeatherを切り替え
            self.selectedWeather.text = alerm.weather
            //TODO: 他のUIも初期化
        } else { //編集モードでない場合、新規アラーム追加用にalermを初期化
            alerm = Alerm(time: datePicker.date, weather: weatherOfPreviousView!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //画面再表示の度にselectedWeatherを更新
        self.selectedWeather.text = "\(self.alerm!.weather)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //セグエによる画面遷移ではない場合、ボタン押下処理を行う
        if(segue.identifier == nil) {
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }
            
            //AddAlermで遷移してきた場合は新規にアラームを生成
            //EditAlerm遷移してきた場合はアラームを更新
            alerm = Alerm(time: datePicker.date, weather: selectedWeather.text!)
            return
        }
        
        switch(segue.identifier ?? "") {
            //セグエがSelectWeatherだったら画面遷移の準備処理を行う
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

