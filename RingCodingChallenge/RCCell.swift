//
//  RCCell.swift
//  RingCodingChallenge
//
//  Created by Arbi Derhartunian on 8/20/17.
//  Copyright © 2017 arbiapps. All rights reserved.
//

import UIKit

class RCCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var updatedLbl: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(rcList:[RCModel], indexPath:IndexPath){
        
        if let title = rcList[indexPath.row].title,
           let author = rcList[indexPath.row].author,
           let numComments = rcList[indexPath.row].numberOfComments,
            let created = rcList[indexPath.row].created{
            
            titleLbl.text = title
            authorLbl.text = author
            commentLbl.text = "\(numComments)"
            updatedLbl.text = "\(created)"
            
        }
    

    }
    
}
