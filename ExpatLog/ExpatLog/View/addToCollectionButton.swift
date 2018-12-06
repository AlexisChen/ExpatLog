//
//  addToCollectionButton.swift
//  ExpatLog
//
//  Created by Alexis Chen on 12/5/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//

import UIKit

class addToCollectionButton: UIButton {
    var dropView = DropdownView()
    var height = NSLayoutConstraint()
    var isOpen = false
    private let kDropViewCellWidth: CGFloat = 180
    private let kMaxDropdownViewHeight: CGFloat = 150
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        dropView = DropdownView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalToConstant: kDropViewCellWidth).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    // MARK: - Pulbic API
    func popDropView(collections: [String]) {
        dropView.dropDownOptions = collections
        dropView.tableView.reloadData()
    }
    
    func presentDropView() {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            let dropViewHeight = min(dropView.tableView.contentSize.height, kMaxDropdownViewHeight)
            self.height.constant = dropViewHeight
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        } else {
            dismissDropDown()
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }

}

protocol DropdownViewDelegate: AnyObject {
    func collectionSelected(atIndex index: Int)->Void
}

class DropdownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    var tableView = UITableView()
    var dropdownViewDelegate: DropdownViewDelegate!
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dropdownViewDelegate.collectionSelected(atIndex: indexPath.row)
    }
}
