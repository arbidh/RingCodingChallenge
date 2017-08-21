//
//  RCModel.swift
//  RingCodingChallenge
//
//  Created by Arbi Derhartunian on 8/20/17.
//  Copyright © 2017 arbiapps. All rights reserved.
//

import Foundation


struct ThumbnailData{
    
    var thumnailURL:String?
    var thumnail_height:Int?
    var thumnail_width:Int?
    var thumnail_title:String?
    
}


struct RCModel{
    
    var title:String?
    var author:String?
    var created:Int?
    var thumbnailURL:String?
    var numberOfComments:Int?
    var listOfThumbnails:ThumbnailData?
    
}

