//
//  ViewController.swift
//  DreamsTemplate
//
//  Created by Leo Chelliah on 02/06/18.
//  Copyright © 2018 Leo Chelliah. All rights reserved.
//

import UIKit
import Charts
import FSLineChart


/*
"response": {
    "response_code": "1",
    "response_message": "Records found"
},
"data": {
    "user_details": {
        "username": "sivamani",
        "token": "2rdQDjYRJj4kU3R",
        "subscribed_user": "2",
        "subscribed_msg": "Silver",
        "user_id": "2",
        "email": "sivamani@dreamguys.co.in",
        "mobile_no": "09988776655",
        "profile_img": "uploads/profile_img/1527064019user.jpg"
    }
}
}
*/

struct GHSearchResult:Decodable {
    var incomplete_results = false
    var total_count:Int
    var items:[item]
}

struct item:Decodable {
    var full_name:String
    var description:String
}
struct result:Decodable {
    let response:response
    let data:data
}

struct response:Decodable {
    var response_message:String
}
struct data:Decodable {
    var user_details:user_details
}
struct user_details:Decodable {
    
    var username:String
    var email:String
}
class ViewController: UIViewController {

    @IBOutlet weak var lineChartView: FSLineChart?
    
    @IBOutlet weak var lineChartView1: LineChartView?

    var numbersArr = [1,3,5,6,8,9,100,50,14,0]
    var linechartEntry = [ChartDataEntry]()
    var data: [Int] = []
    //    var countries = [Country]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self .doApiCall()
        self .updategraph()
    }
    
    // MARK:- Chart
    
    func updategraph()  {
        
//        for number in 0..<(numbersArr.count-1) {
//
//            let value = ChartDataEntry(x: Double(number), y: Double(numbersArr[number]))
//            linechartEntry.append(value)
//        }
//        let line1 = LineChartDataSet(values: linechartEntry, label: "Number")
//        line1.colors = [NSUIColor.blue]
//        let data = LineChartData()
//        data.addDataSet(line1)
//        lineChartView?.data = data
//        lineChartView?.chartDescription?.text = "My awesome chart"

        for _ in 0...10 {
            data.append(Int(20 + (arc4random() % 100)))
        }
        
        lineChartView?.verticalGridStep = 5
        lineChartView?.horizontalGridStep = 9
        lineChartView?.labelForIndex = { "\($0)" }
        lineChartView?.labelForValue = { "$\($0)" }
        lineChartView?.setChartData(data)
    }

    // MARK:- API call
    
    func doApiCall()  {
        
        var paramDict = [String:String]()
        paramDict["username"] = "sivamani"
        paramDict["password"] = "Dreams@99"
        paramDict["login_through"] = "1"
        paramDict["device_type"] = kDEVICE_TYPE_IOS
        paramDict[K_DEVICE_ID] = "2323"
        
        HTTPMANAGER.callGetApi(strUrl: "https://api.github.com/search/repositories?q=tetris+language:Assembly&sort=stars&order=desc", sucessBlock: { (data) in
            print(data)
            //
            do{
                let loginresult = try JSONDecoder().decode(GHSearchResult.self, from: data)
                //                print(loginresult.response.response_message)
                //                print(loginresult.data.user_details.username)
                print(loginresult)
            }
            catch{
                print("error")
            }
            //
            
            
        })
        { (error) in
            
        }
//        HTTPMANAGER.callPostApi(strUrl: "https://api.github.com/search/repositories?q=tetris+language:Assembly&sort=stars&order=desc", dictParameters: paramDict, sucessBlock: { (data) in
//            print(data)
//            //
//            do{
//                let loginresult = try JSONDecoder().decode(GHSearchResult.self, from: data)
////                print(loginresult.response.response_message)
////                print(loginresult.data.user_details.username)
//                print(loginresult)
//            }
//            catch{
//                print("error")
//            }
            //
            
            
//        }) { (error) in
//
//        }
//        //        HTTPMANAGER.callGetApi(strUrl: "https://dreamguys.co.in/servrep/api/login", sucessBlock: { (data) in
        //
        //            //
        //            do{
        //                self.countries = try JSONDecoder().decode([Country].self, from: data)
        //                print(self.countries)
        //
        //            }
        //            catch{
        //                print("error")
        //            }
        //            //
        //
        //
        //        }) { (error) in
        //
        //        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

