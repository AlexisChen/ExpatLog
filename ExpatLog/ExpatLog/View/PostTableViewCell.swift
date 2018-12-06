//
//  PostTableViewCell.swift
//  ExpatLog
//
//  Created by Alexis Chen on 12/4/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    
    private let kScrollContentOffset: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(title: String, month: String, day: Int, detail: String, images: [UIImage]) {
        monthLabel.text = month
        dayLabel.text = String(day)
        detailTextView.text = detail
        //pop the imagescroll view
        let imageWidth = self.imagesScrollView.frame.height //show images as a square
        imagesScrollView.contentSize.width = (imageWidth + kScrollContentOffset) * CGFloat(images.count)
        for i in 0 ..< images.count {
            
            let xPosition = (imageWidth + kScrollContentOffset) * CGFloat(i)
            let yPosition = CGFloat(0)
            let newImageView = UIImageView(image: images[i])
            newImageView.contentMode = .scaleAspectFill
            newImageView.frame = CGRect(x: xPosition, y: yPosition, width: imageWidth, height: imageWidth)
            
            newImageView.clipsToBounds = true
            imagesScrollView.addSubview(newImageView)
            
        }
        
    }
    
}
