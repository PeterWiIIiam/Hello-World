//
//  ViewController.swift
//  From Space
//
//  Created by 何幸宇 on 10/22/17.
//  Copyright © 2017 X. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DescriptionView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        Image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextPicture))
        Image.addGestureRecognizer(tapGesture)
        
    }
   
    @objc func nextPicture() -> Void {
        query.updateValue("2011-07-15", forKey: "date")
        print(query["date"]!)
        updateUI()
    }
    func fetchImage(url: URL, completion: @escaping (UIImage)->Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data{
                let image = UIImage(data: data)
                completion(image!)
            }
        }
        dataTask.resume()
    }
    
    func updateUI() -> Void {
        fetchNASAPicture { (pictureInfo)  in
            
            self.fetchImage(url: URL(string: pictureInfo.url)! , completion: { (image) in
                DispatchQueue.main.async {
                    self.Image.image = image
                }
            })
            
            DispatchQueue.main.async {
                self.DescriptionView.text = pictureInfo.description
                self.TitleLbl.text = pictureInfo.title
                
            }
        }
    }
}


