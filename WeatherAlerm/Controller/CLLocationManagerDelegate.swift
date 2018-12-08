//
//  CLLocationManagerDelegate.swift
//  WeatherAlerm
//
//  Created by Ryo Fujimoto on 2018/11/28.
//  Copyright © 2018 金子宏樹. All rights reserved.
//

import CoreLocation

extension AlermListViewController: CLLocationManagerDelegate {
    
    //MARK: - 位置情報取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 最新の位置情報だけ取得
        let location = locations[locations.count - 1]
        
        // horizontalAccuracy（水平方向の位置の精度）がマイナスの場合は有効な値でないので切り捨てる
        if location.horizontalAccuracy > 0 {
            // 位置情報が取得できたら取得をやめる、電池消耗防止
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            
            // 緯度・経度を文字列に変換してセット
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            // Dictionary型を定義して、緯度・経度・APIKeyをセット
            let geoCoordinatesInfo: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, geoCoordinatesInfo: geoCoordinatesInfo)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
