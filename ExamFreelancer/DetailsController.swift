//
//  DetailsController.swift
//  ExamFreelancer
//
//  Created by Cyan Villarin on 01/08/2018.
//  Copyright © 2018 Cyan Villarin. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var scheduleLabel: UILabel!
    @IBOutlet var channelImage: UIImageView!
    @IBOutlet var ratingImage: UIImageView!
    
    var name: String = ""
    var schedule: String = ""
    var channel: String = ""
    var rating: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = self.name
        nameLabel.text = self.name
        scheduleLabel.text = self.schedule
        channelImage.image = UIImage(named: self.channel)
        ratingImage.image = UIImage(named: self.rating)
        
        if (self.rating == ""){
            ratingImage.image = UIImage(named: "NR")
        }
        else {
            ratingImage.image = UIImage(named: self.rating)
        }
        
        let scaledWidth = (ratingImage.image?.size.width)! * 0.5
        let scaledHeight = (ratingImage.image?.size.height)! * 0.5
        
        ratingImage.frame = CGRect(x: 9, y: 9, width: scaledWidth, height: scaledHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func returnToHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
