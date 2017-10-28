//
//  ViewController.swift
//  From Space
//  Copyright © 2017 X. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var Scroll: UIScrollView!{
        didSet{
            Scroll.maximumZoomScale = 2
            Scroll.minimumZoomScale = 0.5
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DescriptionView: UITextView!
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return Image
    }
    
    var Image = UIImageView(){
        didSet{
        Scroll.addSubview(Image)
        Scroll.contentSize = Image.frame.size
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Scroll.delegate = self
        updateUI()
        Image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextPicture))
        Image.addGestureRecognizer(tapGesture)
        Scroll.addSubview(Image)
        Scroll.contentSize = Image.frame.size
    }
    func randomDate()->String{
        let year = arc4random_uniform(6)+2011
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
                if let image = UIImage(data: data){
                completion(image)
                }else{
                    return 
                }
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
                    self.Image.frame.size = self.Scroll.frame.size
                    self.Image.contentMode = .scaleAspectFill
                    self.spinner.stopAnimating()
                }
            })
            
            DispatchQueue.main.async {
                self.DescriptionView.text = pictureInfo.description
                self.TitleLbl.text = pictureInfo.title
                }
            }
            
        }
    }
}


