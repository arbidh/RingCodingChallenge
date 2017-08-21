//
//  ViewController.swift
//  RingCodingChallenge
//
//  Created by Arbi Derhartunian on 8/20/17.
//  Copyright © 2017 arbiapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let reuseID = "cell"
    let rcViewModel = RCViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    func setupView(){
        
        rcViewModel.viewModelDelegate = self
        
    }

    func registerNib(){
        
        let nib = UINib(nibName: "RCCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rcViewModel.fetchTopReddits()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupView()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rcViewModel.listOfRCData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       guard  let rcCell = collectionView.dequeueReusableCell(withReuseIdentifier:reuseID, for: indexPath) as?
        RCCell else{
            return UICollectionViewCell()
        }
    
       
        rcCell.setupCell(rcList: rcViewModel.listOfRCData, indexPath: indexPath, vc: self)
        
        DispatchQueue.global().async {
            
    
        if let imageurl = self.rcViewModel.listOfRCData[indexPath.row].thumbnailURL{
            
            self.rcViewModel.fetchPicturesWithURL(urlString: imageurl, success: { image in
                
                DispatchQueue.main.async {
                    if let image = image {
                    
                        rcCell.imgView.image = image
                        rcCell.contentMode = .scaleAspectFill
                        rcCell.imgView.clipsToBounds = true
               
                    }
                    rcCell.listOfData = self.rcViewModel.listOfRCData
                }
                
                
            }, fail: { error in
                
            })
            }
        }
        return rcCell
    }
    
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //calculation for aspect ratio
        let height = (view.frame.width - 16 - 16) * 9 / 16 
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation){
            
                 return CGSize(width: view.frame.size.width , height: height)
        }
        if UIDevice.current.userInterfaceIdiom ==  UIUserInterfaceIdiom.pad{
             return CGSize(width: view.frame.width, height: height)
        }
        else{
                 return CGSize(width: view.frame.width, height: height )
        }
    
        
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        collectionView.reloadData()
        
    }
    
    
}



extension ViewController:RCViewModelProtocol{
    
    
    func dataFailed(error: RCErrorType) {
      
         print(error)
        
    }
    
    func dataReceivedSuccessFully(data: [RCModel]?) {
        
        guard let data = data else{
            return
        }
        if data.count > 0{
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }

        }
        
    }
    
}
