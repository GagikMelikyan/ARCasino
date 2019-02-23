//
//  HistoryTableViewCell.swift
//  Casino
//
//  Created by Admin on 1/16/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import UIKit

protocol HistoryTableViewCellDelegate {
    func toggleSection(header: HistoryTableViewCell, section: Int, image: UIImageView)
}

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var balanceChanging: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
  
    var delegate: HistoryTableViewCellDelegate?
    var section: Int!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! HistoryTableViewCell
        delegate?.toggleSection(header: self, section: cell.section, image: arrow)
    }
    
}
