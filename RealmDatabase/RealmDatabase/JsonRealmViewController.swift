//
//  JsonRealmViewController.swift
//  RealmDatabase
//
//  Created by Guru Prasad chelliah on 9/12/17.
//  Copyright © 2017 Dreamguys. All rights reserved.
//

import UIKit

import RealmSwift
import SwiftyJSON

//class Number: Object {
//    dynamic var number = ""
//    dynamic var name = ""
//}
//
//class Hotline: Object {
//    dynamic var id = ""
//    dynamic var department_name = ""
//    dynamic var flag = ""
//    let numbers = List<Number>()
//}
//
//class Text: Object {
//    let hotlines = List<Hotline>()
//    dynamic var change_set = ""
//}
//
//class MyModel: Object {
//    dynamic var error = false
//    dynamic var text: Text?
//}


class JsonRealmViewController: UIViewController {
    @IBOutlet var btnTest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.isTranslucent = false
       // btnTest.titleLabel?.text = "hi this "
    
        // Do any additional setup after loading the view.
        
//        let json = "{\"error\":false,\"text\":{\"hotlines\":[{\"id\":\"1\",\"department_name\":\"New Car Sales\",\"flag\":\"1\",\"numbers\":[{\"number\":\"09480825000\",\"name\":\"Showroom 1\"},{\"number\":\"342342423423\",\"name\":\"second\"}]},{\"id\":\"2\",\"department_name\":\"Used Car Enquiry\",\"flag\":\"1\",\"numbers\":[{\"number\":\"08884412075\",\"name\":\"Dharmendra Kulkarni\"}]}],\"change_set\":\"59\"}}"
//
//        let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: [])
//
////        print(MyModel(value: jsonObject))
////
////        var listModel = MyModel()
////        listModel = MyModel(value: jsonObject)
//
//
//        let realm = try! Realm()
//
//        //let realmAdd = try! Realm()
//        let languageInfo = languageModel()
//
//       languageInfo.name = "தமிழ்"
//
//        let languageInfo1 = languageModel()
//
//        languageInfo1.name = "தமிழ்"
//
//        try! realm.write {
//
//            realm.add(languageInfo)
//            realm.add(languageInfo1)
//
//            let realmGet = try! Realm()
//            let listData = realmGet.objects(languageModel.self)
//
//            print(listData)
//        }
//
//        let realmGet = try! Realm()
//        let listData = realmGet.objects(languageModel.self)
//
//        print(listData)
        

//        Helper.sharedInstance.showNoDataAlert(viewController: self)
//
////        Helper.sharedInstance.showNetworkRetryAlert(viewController: self, retryBlock: {
////
////        })
////
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

        Helper.sharedInstance.showLoadingViewAnimation(viewController: self)

        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {

            Helper.sharedInstance.hideLoadingAnimation(viewController: self)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAction(_ sender: Any) {
        
        print("hi i m clicked")
        
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        get {
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                
                return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.landscapeLeft.rawValue) | Int(UIInterfaceOrientationMask.landscapeRight.rawValue)))
            }
                
            else {
                
                 return .portrait
            }
        }
    }
}


