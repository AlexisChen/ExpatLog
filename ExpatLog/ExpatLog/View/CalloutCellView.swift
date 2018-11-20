//
//  CalloutCellView.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/18/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//

import UIKit

class CalloutCellView: UIView {
    //embed an image library, a label that shows caption, a button that leads to detail
    var cellImageView: UIImageView = UIImageView(image: UIImage(named: "World")!)
    var cellTitle: UILabel = UILabel(frame: CGRect(x:0, y:50, width:50, height:20))
    var cellButton: UIButton = UIButton(frame: CGRect(x:0, y:70, width:50, height:20))
    
    func initCell() {
        bounds = CGRect(x: 0, y: 0, width: 50, height: 100)
        cellImageView.frame = CGRect(x:0, y:0, width:50, height:50)
        cellTitle.text = "New location marked!"
        cellButton.setTitle("Click to add more details", for: .normal)
    }
   
}
