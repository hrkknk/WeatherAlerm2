//
//  AlermListViewController.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/26.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit
import os.log
import CoreLocation

class AlermListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AlermTableViewDelegate {

    //MARK: - Properties
    //アラームモデル
    var alerms = [Alerm]()
    
    //Sunny/Rainyどっちのアラームリストを表示するか
    var selectedWeather: String?
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var alermList: UITableView!
    
    //MARK: - Actions
    
    @IBAction func selectSunny(_ sender: UIButton) {
        self.selectedWeather = "Sunny"
    }
    
    @IBAction func selectRainy(_ sender: UIButton) {
        self.selectedWeather = "Rainy"
    }
    
    //AlermViewController画面のsaveButtonを押して戻ってきた時の処理
    @IBAction func unwindToAlermList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AlermViewController, let alerm = sourceViewController.alerm {
            if let selectedIndexPath = alermList.indexPathForSelectedRow {
                // Update an existing alerm.
                alerms[selectedIndexPath.row] = alerm
                alermList.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new alerm.
                let newIndexPath = IndexPath(row: alerms.count, section: 0)
                
                alerms.append(alerm)
                alermList.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveAlerms()
            //画面遷移する前に編集モード解除
            setEditing(false, animated: false)
        }
    }
    
    //MARK: - Methods
    //スイッチの状態を記憶(Cell側から読んでもらうプロトコルメソッド)
    func saveSwitchOnOff(index: Int) {
        alerms[index].isOn = !alerms[index].isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: 前回アプリを閉じた時にSunny/Rainyどっちを選択していたか記憶しておく
        self.selectedWeather = "Sunny"
        
        // 位置情報取得のためのデリゲート
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //selectedWeatherと一致するアラームだけモデルに追加
        addAlermsOfSelectedWeather(alerms)
        
        //ナビゲーションバーの左上にeditボタンを表示
        navigationItem.leftBarButtonItem = editButtonItem
        
        //保存データがある場合、それを読み込む
        if let savedAlerms = loadAlerms() {
            alerms += savedAlerms
        } else {
            // Load the sample data.
            alerms += loadSampleAlerms()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //アラーム未登録の場合、Editボタンは無効化
        if alerms.count <= 0 {
            editButtonItem.isEnabled = false
        } else {
            editButtonItem.isEnabled = true
        }
        
        //アラーム再表示
        for cell in getAllCells() {
            cell.timeLabel.text = alerms[cell.getRow()].getDateAsString()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
     
        //Edit中はAddボタンを無効化(その逆は逆)
        addButton.isEnabled = !editing
        
        //Edit中はON/OFFスイッチを無効化(その逆は逆)
//        if (editing) {
            for cell in getAllCells() {
                cell.isOnSwitch.isHidden = editing
            }
//        }
        alermList.isEditing = editing
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //TODO: あとで変えるかも？
        return 1
    }
    
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
    
    //編集モード
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //アラームを削除
            alerms.remove(at: indexPath.row)
            saveAlerms()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {

        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //編集モードでない時はEditAlermのsegueをOFFにする
        if !alermList.isEditing && identifier == "EditAlerm" {
            return false
        }
        
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddAlerm": //"Add"ボタンによる画面遷移の場合
            //UINavigationControllerを取得
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            //UINavigationControllerの次の画面(WeatherViewController)を取得
            guard let alermViewController = navigationController.topViewController as? AlermViewController else {
                fatalError("Unexpected topViewController: \(String(describing: navigationController.topViewController))")
            }
            
            //次の画面(AlermViewController)のデフォルトWeatherにSunny/Rainyをセット
            alermViewController.weatherOfPreviousView = self.selectedWeather!
            
        case "EditAlerm": //編集モードでアラームセルをタップして画面遷移する場合
            guard let alermViewController = segue.destination as? AlermViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            //タップしたアラームセルを取得
            guard let selectedAlermCell = sender as? AlermTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            //アラームセルのindexPathを取得
            guard let indexPath = alermList.indexPath(for: selectedAlermCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            //indexPathを元に、対象のモデルを取得してセット
            alermViewController.alerm = alerms[indexPath.row]
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    //MARK: - Private Methods
    
    fileprivate func addAlermsOfSelectedWeather(_ alerms: [Alerm]) {
        for alerm in alerms {
            if alerm.weather == self.selectedWeather {
                self.alerms += [alerm]
            }
        }
    }
    
    //全てのセルを取得する
    private func getAllCells() -> [AlermTableViewCell] {
        var cells = [AlermTableViewCell]()

        //TODO: 煩雑だからなんとかする
        for i in 0...alermList.numberOfSections - 1 {
            for j in 0...alermList.numberOfRows(inSection: i) {
                if let cell = alermList.cellForRow(at: NSIndexPath(row: j, section: i) as IndexPath) {
                    cells.append(cell as! AlermTableViewCell)
                }
            }
        }
        return cells
    }
    
    
    private func saveAlerms() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(alerms, toFile: Alerm.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Alerms successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save alerms...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadAlerms() -> [Alerm]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Alerm.ArchiveURL.path) as? [Alerm]
    }

    //TODO: テスト用。あとで消すこと
    private func loadSampleAlerms() -> [Alerm] {
        
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

