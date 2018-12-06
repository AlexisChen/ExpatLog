//
//  JournalViewController.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MarkersTableDelegate{

    @IBOutlet weak var journalTableView: UITableView!
    var markersModel = MarkersModel.sharedInstance
    var tableRowHeight:CGFloat = 160//how to set this properly
    override func viewDidLoad() {
        super.viewDidLoad()
        markersModel.tableDelegate = self;
        //register reusable cell
        journalTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        journalTableView.rowHeight = CGFloat(tableRowHeight)
    }
    
    // MARK: - Delegates
    //tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markersModel.annotationCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = journalTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for:indexPath) as? PostTableViewCell {
            if let cellAnnotation = markersModel.annotationAtIndex(index: indexPath.row) {
                cell.setData(title: cellAnnotation.title!, month: "Nov", day: 20, detail: cellAnnotation.imgDescription ?? "", images: [cellAnnotation.image!, cellAnnotation.image!, cellAnnotation.image!])
            }
            return cell;
        }
        return UITableViewCell()
    }
    
    //MarkersTableDelegate
    func refreshTable() {
        journalTableView.reloadData()
    }
}
