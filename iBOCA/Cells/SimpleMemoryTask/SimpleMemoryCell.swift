//
//  SimpleMemoryCell.swift
//  iBOCA
//
//  Created by Macintosh HD on 7/1/19.
//  Copyright © 2019 sunspot. All rights reserved.
//

import UIKit

class SimpleMemoryCell: UICollectionViewCell {

    @IBOutlet weak var vContents: UIView!
    @IBOutlet weak var tfObjectName: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupView()
    }

    fileprivate func setupView() {
        self.backgroundColor = UIColor.clear
        self.vContents.backgroundColor = UIColor.clear
        
        self.lblTitle.font = Font.font(name: Font.Montserrat.medium, size: 16.0)
        self.lblTitle.textColor = Color.color(hexString: "#8A9199")
        self.lblTitle.addTextSpacing(-0.36)
        
        self.tfObjectName.backgroundColor = Color.color(hexString: "#F7F7F7")
        self.tfObjectName.layer.cornerRadius = 5.0
        self.tfObjectName.layer.borderWidth = 1.0
        self.tfObjectName.layer.borderColor = Color.color(hexString: "#EAEAEA").cgColor
        self.tfObjectName.tintColor = UIColor.black
        self.tfObjectName.font = Font.font(name: Font.Montserrat.medium, size: 18.0)
        self.tfObjectName.textColor = UIColor.black
        self.tfObjectName.addLeftTextPadding(11.0)
    }
    
}