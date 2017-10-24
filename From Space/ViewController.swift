//
//  ViewController.swift
//  From Space
//
//  Created by 何幸宇 on 10/22/17.
//  Copyright © 2017 X. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
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
    func randomDate()->String{
        let year = arc4random_uniform(10)+2011
        let month = arc4random_uniform(11)+1
        let day = arc4random_uniform(30)+1
        return "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
    }
   
    @objc func nextPicture() -> Void {
        let date = randomDate()
        query.updateValue(date, forKey: "date")
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
        self.spinner.startAnimating()
        fetchNASAPicture { (pictureInfo)  in
            if let pictureInfo = pictureInfo{
            
            self.fetchImage(url: URL(string: pictureInfo.url)! , completion: { (image) in
                DispatchQueue.main.async {
                    self.Image.image = image
                    self.spinner.stopAnimating()

                }
            })
            
            DispatchQueue.main.async {
                self.DescriptionView.text = pictureInfo.description
                self.TitleLbl.text = pictureInfo.title
                }
            }else{
                let date = self.randomDate()
                query.updateValue(date, forKey: "date")
                print(query["date"]!)
                self.updateUI()
            }
        }
    }
}


