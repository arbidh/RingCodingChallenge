//
//  RCImageViewController.swift
//  RingCodingChallenge
//
//  Created by Rinie Ghazali on 8/21/17.
//  Copyright © 2017 arbiapps. All rights reserved.
//

import UIKit

class RCImageViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var imageURL:String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.clipsToBounds = true
        fetchImages()
    }
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Do any additional setup after loading the view.
    }
    
    func fetchImages(){
        
            
            let viewModel = RCViewModel()
        
        DispatchQueue.global().async {
            
        
            
            viewModel.fetchPicturesWithURL(urlString: self.imageURL, success: { image in
              
                DispatchQueue.main.async {
                    self.imageView.image = image
                    
                }
                
            }, fail: { error in
                
            })
        
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
