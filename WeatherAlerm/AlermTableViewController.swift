//
//  TableViewController.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/10/06.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit

class AlermTableViewController: UITableViewController, AlermTableViewDelegate {
    
    //スイッチの状態を記憶(Cell側から読んでもらうプロトコルメソッド)
    func saveSwitchOnOff(index: Int) {
        alerms[index].isOn = !alerms[index].isOn
        print("Cell:\(index) = \(alerms[index].isOn)")
    }
    
    //MARK: Properties
    
    var alerms = [Alerm]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleAlerm()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //TODO: あとで変えるかも？
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return alerms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlermTableViewCell", for: indexPath) as? AlermTableViewCell else {
            fatalError("AlermTableViewCell型じゃないよ！")
        }

        // Fetches the appropriate alerm for the data source layout.
        let alerm = alerms[indexPath.row]
        
        // Configure the cell...
        cell.timeLabel.text = alerm.getDateAsString()
        cell.isOnSwitch.isOn = alerm.isOn
        
        cell.delegate = self
        
        //自分のRowが何番目かCell側に記憶しておく
        cell.setRow(row: indexPath.row)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
