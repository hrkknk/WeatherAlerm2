//
//  TableViewController.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/06.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit

/*
 アラーム一覧画面のコントローラ
 ・登録済みアラームを一覧表示
 ・登録済みアラームのON/OFF切り替え
 ・アラーム新規登録画面/アラーム編集画面の呼び出し
 ・Sunny/Rainyの切り替え(未実装)
 */
class AlermTableViewController: UITableViewController, AlermTableViewDelegate {
    
    //MARK: - Properties
    //アラームモデル
    var alerms = [Alerm]()
    
    //Sunny/Rainyどっちのアラームリストを表示するか
    var selectedWeather: String?
    
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
        
        loadSampleAlerm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //TODO: あとで変えるかも？
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    //TODO: テスト用。あとで消すこと
    private func loadSampleAlerm() {
        guard let sampleAlerm1 = Alerm(time: Date(), weather: "Sunny") else {
            fatalError("Unable to instantiate alerm2")
        }
        guard let sampleAlerm2 = Alerm(time: Date(), weather: "Rainy") else {
            fatalError("Unable to instantiate alerm2")
        }
        
        alerms += [sampleAlerm1, sampleAlerm2]
    }
    
}
