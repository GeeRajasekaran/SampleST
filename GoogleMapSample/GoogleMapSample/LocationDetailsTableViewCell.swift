//
//  LocationDetailsTableViewCell.swift
//  GoogleMapSample
//
//  Created by Dreamguys on 27/02/18.
//  Copyright © 2018 Dreamguys. All rights reserved.
//

import UIKit

class LocationDetailsTableViewCell: UITableViewCell {

    @IBOutlet var myContainerView: UIView!
    @IBOutlet var myImgViewProfile: UIImageView!
    @IBOutlet var myLblPrice: UILabel!
    @IBOutlet var myLblDistance: UILabel!
    @IBOutlet var myLblTitle: UILabel!
    @IBOutlet var myLblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
