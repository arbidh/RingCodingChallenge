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
    
    var imageURL:String? = nil
    var listOfData:[RCModel] = []
    weak var vc:ViewController?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setupGestureRecognizer()
    }
    @IBAction func showImage(_ sender: UITapGestureRecognizer) {
        
            
         
                
                let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
               if let vc =  storyBoard.instantiateViewController(withIdentifier: "RCImageViewController") as? RCImageViewController
               {
                    let index = imgView.tag
                
                    vc.imageURL = listOfData[index].fullImageURL
                
                    let navController = UINavigationController(rootViewController: vc)
                    self.vc?.present(navController, animated: true, completion: nil)
                    
                }
        
    }
   
    func setupGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImage(_:)))
        imgView.addGestureRecognizer(tapGesture)
        
    }
    
    
    func setupCell(rcList:[RCModel], indexPath:IndexPath, vc:ViewController){
        
        if indexPath.row == 0{
            
           
            self.vc = vc
        }
        
        if let title = rcList[indexPath.row].title,
           let author = rcList[indexPath.row].author,
           let numComments = rcList[indexPath.row].numberOfComments,
            let created = rcList[indexPath.row].created{
            

            titleLbl.sizeThatFits(CGSize(width: title.width(withConstraintedHeight: 50, font: UIFont.systemFont(ofSize: 13)), height: title.height(withConstrainedWidth: 50, font: UIFont.systemFont(ofSize: 13))))
            titleLbl.text = title
            commentLbl.text = "\(numComments) comments"
            let time = calculateTime(utcTime:created)
            updatedLbl.textColor = UIColor.gray
            updatedLbl.text = "submitted \(time) ago by"
            authorLbl.text = author
            
            if let url = rcList[indexPath.row].fullImageURL{
                imgView.tag = indexPath.row
                imageURL = url
            }
            
            
        
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
