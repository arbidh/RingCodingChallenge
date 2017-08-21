//
//  RCViewModel.swift
//  RingCodingChallenge
//
//  Created by Arbi Derhartunian on 8/20/17.
//  Copyright © 2017 arbiapps. All rights reserved.
//

import Foundation
import UIKit


enum RCErrorType{
    
    case APIError(desc:String)
    case OtherError(desc:String)
    
}



protocol RCViewModelProtocol:class{
    
    func dataReceivedSuccessFully(data:[RCModel]?)
    func dataFailed(error:RCErrorType)
    
}



class RCViewModel{
    
    
    weak var viewModelDelegate: RCViewModelProtocol?
    
    var listOfRCData:[RCModel] = []
    
    let endpoint = "https://api.reddit.com/top"
    
    
    func fetchPicturesWithURL(urlString:String? , success:@escaping (_ image:UIImage?)->Void, fail:@escaping (_ error:RCErrorType)->Void){
        
        guard let urlString = urlString else{
            return
        }
        
        guard let url = URL(string:urlString) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, resp, error in
            
            guard let data = data else{
                return
            }
            let image = UIImage(data: data)
            if let image = image{
                success(image)
            }
            else{
                fail(RCErrorType.APIError(desc: error.debugDescription))
            }
            
        }.resume()
        
        
    }
    
    func fetchTopReddits(){
        
        guard let url = URL(string:endpoint) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) {[weak self] data , resp, error in
            
            guard let data = data else{
                return
            }
            
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary else{
                    return
                }
                
                self?.populateRedditData(datadict: jsonData)
            
                    
                    if error != nil{
                        self?.viewModelDelegate?.dataFailed(error: RCErrorType.APIError(desc: error.debugDescription))
                    
                    }
                    else{
                        self?.viewModelDelegate?.dataReceivedSuccessFully(data: self?.listOfRCData)
                    }
                
                
              }catch{
                
           }
            
        }.resume()
        
    }
    
    func populateRedditData(datadict:NSDictionary?){
        
        if listOfRCData.count > 1{
            listOfRCData.removeAll()
        }
        
        guard let datadict = datadict else{
            return
        }
        
        let dataValue = datadict["data"] as? NSDictionary
        
        let children = dataValue?["children"] as? NSArray
        
        let listOfData = children?.map({ val -> NSDictionary? in
            let dict = val as? NSDictionary
            let data = dict?["data"] as? NSDictionary
            return data
        })
        var rcData = RCModel()
        
        guard let listOfReturnData = listOfData else{
            return
        }
        
      _ =   listOfReturnData.map({ milo in   milo?.allKeys.forEach({ key in
            
            if let keys = key as? String {
      
                switch(keys){
                case "num_comments":
                    
                    if let numComments = milo?.value(forKey: keys) as? Int{
                        rcData.numberOfComments = numComments
                    }
                
                case "thumbnail":
                
                    if let thumbnail = milo?.value(forKey: keys) as? String{
                        rcData.thumbnailURL = thumbnail
                    }
                case "author":
                
                    if let author = milo?.value(forKey: keys) as? String{
                        rcData.author = author
                    }
                case "title":
                
                    if let title = milo?.value(forKey: keys) as? String{
                        rcData.title = title
                    }
                case "created_utc":
                
                    if let createdUtc = milo?.value(forKey: keys) as? Int{
                        rcData.created = createdUtc
                    }
                    
                case "url" :
                    if let images = milo?.value(forKey: keys) as? String{
                       rcData.fullImageURL = images
                    }
                    
                    
                default:
                    break
                }
            }
        })
         listOfRCData.append(rcData)
    })
  }
}

