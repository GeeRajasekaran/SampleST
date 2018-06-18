//
//  TestViewController.swift
//  RealmDatabase
//
//  Created by Guru Prasad chelliah on 9/12/17.
//  Copyright © 2017 Dreamguys. All rights reserved.
//

import UIKit

import RealmSwift

//class lanugage: Object {
//    dynamic var name = ""
//    dynamic var Info = [String]()
//    
//    let InfoArray = List<lanugageList>()
//}
//
//// Person model
//class lanugageList: Object {
//    
//    let dogs = List<lanugage>()
//}

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        
//        let realm = try! Realm()
//
//        let myLang = lanugage()
//        let myLang1 = lanugage()
//
//        myLang.name = "xxxxx"
//        myLang1.name = "yyyyy"
//
//        myLang.Info = ["subArray", "subArray", "subArray"]
//        myLang1.Info = ["subArray1", "subArray1", "subArray1"]
//
//        try! realm.write {
//            realm.add(myLang)
//            realm.add(myLang1)
//        }
//        
//        let realm1 = try! Realm()
//        let fetchdata = realm1.objects(lanugage.self)
//        
//        print(fetchdata)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
