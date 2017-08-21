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
            
            let title2 = title as NSString
            titleLbl.sizeThatFits(CGSize(width: title.width(withConstraintedHeight: 50, font: UIFont.systemFont(ofSize: 13)), height: title.height(withConstrainedWidth: 50, font: UIFont.systemFont(ofSize: 13))))
            titleLbl.text = title
            commentLbl.text = "\(numComments) comments"
            let time = calculateTime(utcTime:created)
            updatedLbl.textColor = UIColor.gray
            updatedLbl.text = "submitted \(time) ago by"
            authorLbl.text = author
        
        }
    

    }
    
}

extension RCCell{
    
    
    func calculateTime(utcTime:Int)->String{
  
        let date = Date(timeIntervalSince1970: TimeInterval(utcTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        
        let firstDate = dateFormatter.string(from: date)
        if  let originalDate = dateFormatter.date(from: firstDate){
        
            guard let calculatedString = getStringHoursFromDate(Fromdate: originalDate, toDate: Date()) else {
                return " "
            }
            return calculatedString
        }
        return " "
    }

    func getStringHoursFromDate(Fromdate:Date, toDate:Date) ->String?{
        
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        return dateComponentsFormatter.string(from: Fromdate   , to: toDate)
        
    }

    
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
