//
//  CollectionImageTableViewCell.swift
//  ExpatLog
//
//  Created by Alexis Chen on 12/6/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//

import UIKit

class CollectionImageTableViewCell: UITableViewCell {

    @IBOutlet weak var previewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
        previewImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        previewImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
