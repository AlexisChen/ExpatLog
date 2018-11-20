//
//  MapCalloutView.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/18/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import UIKit
import Mapbox

class MapCalloutView: UIView, MGLCalloutView {
    var representedObject: MGLAnnotation
    
    // Allow the callout to remain open during panning.
    let dismissesAutomatically: Bool = false
    let isAnchoredToAnnotation: Bool = true
    
    // https://github.com/mapbox/mapbox-gl-native/issues/9228
    override var center: CGPoint {
        set {
            var newCenter = newValue
            newCenter.y -= bounds.midY
            super.center = newCenter
        }
        get {
            return super.center
        }
    }
    
    lazy var leftAccessoryView = UIView() /* unused */
    lazy var rightAccessoryView = UIView() /* unused */
    
    weak var delegate: MGLCalloutViewDelegate?
    
    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0
    let frameHeight: CGFloat = 240.0
    let frameWidth: CGFloat = 170.0
    
    let cellImageView: UIImageView
    let cellTitle: UILabel
    var cellButton: UIButton!
    
//    let cellContent: CalloutCellView
//    let mainBody: UIButton
    
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
//        self.mainBody = UIButton(type: .system)
//        self.cellContent = CalloutCellView()
//        self.cellContent.initCell()
        cellImageView = UIImageView(image: UIImage(named: "World")!)
        cellTitle = UILabel(frame: CGRect(x:10, y:160, width:150, height:50))
        cellTitle.textColor = .white
        cellTitle.font = UIFont.systemFont(ofSize: 15)
        cellButton = UIButton(frame: CGRect(x:10, y:210, width:150, height:20))
        cellButton.frame = CGRect(x:10, y:210, width:150, height:20)
        
        cellButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        cellButton.titleLabel?.textColor = .gray
        super.init(frame: .zero)
        
        backgroundColor = .darkGray
        cellImageView.frame = CGRect(x:10, y:10, width:150, height:150)
        cellTitle.text = "New location marked!"
        cellButton.setTitle("Click to add more details", for: .normal)
        addSubview(cellImageView)
        addSubview(cellTitle)
        addSubview(cellButton)
//        addSubview(cellContent)
//        mainBody.backgroundColor = .darkGray
//        mainBody.tintColor = .white
//        mainBody.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
//        mainBody.layer.cornerRadius = 4.0
//        addSubview(mainBody)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MGLCalloutView API
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        view.addSubview(self)
        
        // Prepare title label.
//        mainBody.setTitle(representedObject.title!, for: .normal)
//        mainBody.sizeToFit()
        // Prepare our frame, adding extra space at the bottom for the tip.
//        let frameWidth = mainBody.bounds.size.width
//        let frameHeight = mainBody.bounds.size.height + tipHeight
//        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
//        let frameOriginY = rect.origin.y - frameHeight
//        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)

        //prepare frame
//        let frameWidth = cellContent.bounds.size.width
//        let frameHeight = cellContent.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        if animated {
            alpha = 0
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }
    
    // MARK: - Callout interaction handlers
    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    
    @objc func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
    
    // MARK: - Custom view styling
    override func draw(_ rect: CGRect) {
        // Draw the pointed tip at the bottom.
        let fillColor: UIColor = .darkGray
        
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight - 1
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        tipPath.closeSubpath()
        
        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
    }
}
