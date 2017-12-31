//
//  TransactionsTableViewCell.swift
//  
//
//  Created by Vyshak Athreya B K on 12/23/17.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var amtLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var acLabel: UILabel!
    @IBOutlet weak var icmLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
