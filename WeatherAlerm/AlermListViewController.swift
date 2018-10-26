//
//  AlermListViewController.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/26.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit

class AlermListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AlermTableViewDelegate {

    //MARK: - Properties
    //アラームモデル
    var alerms = [Alerm]()
    
    //Sunny/Rainyどっちのアラームリストを表示するか
    var selectedWeather: String?
    
    @IBOutlet weak var alermList: UITableView!
    //MARK: - Actions
    
    @IBAction func selectSunny(_ sender: UIButton) {
        self.selectedWeather = "Sunny"
    }
    
    @IBAction func selectRainy(_ sender: UIButton) {
        self.selectedWeather = "Rainy"
    }
    
    //MARK: - Methods
    //スイッチの状態を記憶(Cell側から読んでもらうプロトコルメソッド)
    func saveSwitchOnOff(index: Int) {
        alerms[index].isOn = !alerms[index].isOn
        print("Cell:\(index) = \(alerms[index].isOn)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: 前回アプリを閉じた時にSunny/Rainyどっちを選択していたか記憶しておく
        self.selectedWeather = "Sunny"
        
        //selectedWeatherと一致するアラームだけモデルに追加
        addAlermsOfSelectedWeather(loadSampleAlerm())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        //TODO: あとで変えるかも？
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlermTableViewCell", for: indexPath) as? AlermTableViewCell else {
            fatalError("AlermTableViewCell型じゃないよ！")
        }
        
        let alerm = alerms[indexPath.row]
        
        cell.timeLabel.text = alerm.getDateAsString()
        cell.isOnSwitch.isOn = alerm.isOn
        cell.delegate = self
        
        //自分のRowが何番目かCell側に記憶しておく
        cell.setRow(row: indexPath.row)
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddAlerm":
            //UINavigationControllerを取得
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            //UINavigationControllerの次の画面(WeatherViewController)を取得
            guard let alermViewController = navigationController.topViewController as? AlermViewController else {
                fatalError("Unexpected topViewController: \(String(describing: navigationController.topViewController))")
            }
            
            //次の画面(AlermViewController)のデフォルトWeatherにSunny/Rainyをセット
            alermViewController.alerm?.weather = self.selectedWeather!
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Private Methods
    
    fileprivate func addAlermsOfSelectedWeather(_ alerms: [Alerm]) {
        for alerm in alerms {
            if alerm.weather == self.selectedWeather {
                self.alerms += [alerm]
            }
        }
    }
    
    //TODO: テスト用。あとで消すこと
    private func loadSampleAlerm() -> [Alerm] {
        
        guard let sampleAlerm1 = Alerm(time: Date(), weather: "Sunny") else {
            fatalError("Unable to instantiate alerm2")
        }
        
        guard let sampleAlerm2 = Alerm(time: Date(), weather: "Rainy") else {
            fatalError("Unable to instantiate alerm2")
        }
        
        guard let sampleAlerm3 = Alerm(time: Date(), weather: "Rainy") else {
            fatalError("Unable to instantiate alerm3")
        }
        
        return [sampleAlerm1, sampleAlerm2, sampleAlerm3]
    }
}
