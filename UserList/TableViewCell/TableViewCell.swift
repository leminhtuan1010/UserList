//
//  TableViewCell.swift
//  UserList
//
//  Created by Minh Tuan on 11/3/17.
//  Copyright © 2017 Minh Tuan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var img_Cell: UIImageView!
    @IBOutlet weak var name_Cell: UILabel!
    @IBOutlet weak var address_Cell: UILabel!
    var user: User? {
        didSet{
            guard let user = user else { return }
            name_Cell.text = user.name
            address_Cell.text = user.address
            img_Cell.image = UIImage(named: user.image)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellUI()
    }
    fileprivate func configureCellUI() {
        img_Cell.layer.cornerRadius = img_Cell.bounds.width / 2.0
        img_Cell.clipsToBounds = true
    }
}
