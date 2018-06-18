//
//  ViewController.swift
//  GoogleMapSample
//
//  Created by Dreamguys on 27/02/18.
//  Copyright © 2018 Dreamguys. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

let cellIdentifier = "LocationDetailsTableViewCell"

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    var myAryInfo = [[String : Any]]()

    @IBOutlet var myMapView: GMSMapView!
    var centerMapCoordinate:CLLocationCoordinate2D!
    var marker:GMSMarker!
    var locationManager = CLLocationManager()

    @IBOutlet var myViewBottomLoading: UIView!
    @IBOutlet var myConstraintBottomView: NSLayoutConstraint!
    @IBOutlet var myViewIndicator: UIView!
    @IBOutlet var myViewLoadingNoRecords: UIView!
    @IBOutlet var myTblView: UITableView!
    @IBOutlet var myConstraintTableViewHeight: NSLayoutConstraint!
    
    var isAlreadyPresentTableview = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myMapView.delegate = self
        self.myMapView?.isMyLocationEnabled = true
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        myConstraintBottomView.constant = 0
        
        setUpUI()
        setUpModel()
        loadModel()
    }

    func setUpUI() {
        
        myTblView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        myTblView.delegate = self
        myTblView.dataSource = self
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    // MARK: - TableView delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LocationDetailsTableViewCell
        
        aCell.myLblTitle.text = myAryInfo[indexPath.row]["merchant"] as? String
        aCell.myLblDescription.text = myAryInfo[indexPath.row]["description"] as? String
        aCell.myLblPrice.text = (myAryInfo[indexPath.row]["price_currency"] as? String)! + " " + (myAryInfo[indexPath.row]["oil_price"] as? String)!
        
        let aStrDistance = myAryInfo[indexPath.row]["distance"] as! String
        let aFltDistance = Double(aStrDistance)
        
        let rounded = round(aFltDistance! * 2) / 2
        
        aCell.myLblDistance.text = String(rounded) + " KM"

        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        centerMapCoordinate = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)

        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10)
        self.myMapView?.animate(to: camera)
        
        myMapView.clear()
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

       // self.placeMarkerOnCenter(centerMapCoordinate:centerMapCoordinate)
    }
    
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        
        if marker == nil {
            marker = GMSMarker()
        }
        
        marker.position = centerMapCoordinate
        marker.map = self.myMapView
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.myMapView.clear()

        showMapLoadingAnimation()
        geLocationDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func geLocationDetails() {
        
        let aStrLat = String(centerMapCoordinate.latitude)
        let aStrLong = String(centerMapCoordinate.longitude)
        
        let dictParameters = ["latitude": aStrLat,"longitude":aStrLong,"radius":"0"] as [String : Any]
        
        Alamofire.request("http://hargasawit.com/development/app/api/near_by_location", method: .post, parameters: dictParameters).responseJSON
            {(response) in
                
                print(response)
                
                if response.result.isSuccess {
                    
                    let jsonDict = response.result.value as? [String:Any]
                    let locationResponse = jsonDict! as NSDictionary
                    
                    let aIntResponseCode = locationResponse["meta"] as! Int
                    //let aMessageResponse = locationResponse["message"] as! String
                    
                    if aIntResponseCode == 200 {
                        
                        self.hideMapLoadingAnimation()
                        
                        self.myAryInfo = []
                        self.myAryInfo = locationResponse["data"] as! [[String : Any]]
                        
                        for dictLocationInfo in self.myAryInfo {
                            
                            let locMarker = GMSMarker()
                            locMarker.appearAnimation = GMSMarkerAnimation.pop
                            
                            let aStrLat = dictLocationInfo["latitude"] as! String
                            let aStrLong = dictLocationInfo["longitude"] as! String
                            
                            let aFltLat = Double(aStrLat)
                            let aFltLong = Double(aStrLong)
                            
                            locMarker.position = CLLocationCoordinate2D(latitude: aFltLat!, longitude: aFltLong!)
                            locMarker.title = dictLocationInfo["merchant"] as? String
                            locMarker.snippet = dictLocationInfo["description"] as? String
                            locMarker.map = self.myMapView
                        }
                        
                        self.showTableView()
                    }
                        
                    else {
                        
                        self.myAryInfo = []
                        self.showMapRoRecordsView()
                        self.hideTableView()
                    }
                }
                else if response.result.isFailure {
                    
                    self.hideTableView()
                    self.hideMapLoadingAnimation()
                }
        }
    }
    
    func showMapLoadingAnimation()  {
        
        UIView.animate(withDuration: Double(0.5), animations: {
            self.myConstraintBottomView.constant = 40
            self.myViewLoadingNoRecords.isHidden = true
            self.myViewIndicator.isHidden = false

            self.view.layoutIfNeeded()
        })
    }
    
    func hideMapLoadingAnimation()  {
        
        UIView.animate(withDuration: Double(0.5), animations: {
            self.myConstraintBottomView.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func showMapRoRecordsView () {
        
        self.view.layoutIfNeeded()
        self.myViewIndicator.isHidden = true
        self.myViewLoadingNoRecords.isHidden = false
    }
    
    func showTableView()  {
        
        if isAlreadyPresentTableview {
            
            if self.myAryInfo.count * 90 >= 270 {
                
                self.myConstraintTableViewHeight.constant = 270
            }
                
            else {
                
                self.myConstraintTableViewHeight.constant = CGFloat(self.myAryInfo.count * 90)
            }
            
            self.myTblView.reloadData()
        }
        
        else {
            
            isAlreadyPresentTableview = true
            
            UIView.animate(withDuration: Double(0.5), animations: {
                
                if self.myAryInfo.count * 90 >= 270 {
                    
                    self.myConstraintTableViewHeight.constant = 270
                }
                
                else {
                    
                    self.myConstraintTableViewHeight.constant = CGFloat(self.myAryInfo.count * 90)
                }
                
                self.myTblView.reloadData()
            })
        }
    }
    
    func hideTableView()  {
        
        isAlreadyPresentTableview = false

        UIView.animate(withDuration: Double(0.5), animations: {
            
            self.myConstraintTableViewHeight.constant = 0
        })
    }
}

