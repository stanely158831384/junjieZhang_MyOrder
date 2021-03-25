//
//  ToDoTableViewCell.swift
//  junjieZhang_MyOrder
//
//  Created by Junjie Zhang on 2021-02-15.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblSize : UILabel!
    @IBOutlet var lblQTY : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
