//
//  ViewController.swift
//  ExamFreelancer
//
//  Created by Cyan Villarin on 30/07/2018.
//  Copyright © 2018 Cyan Villarin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shows: Array<Show> = []
    var batch: String = "0"
    
    @IBOutlet weak var tableView: UITableView!
    
    // structs for JSONDecoder
    struct Response: Decodable {
        let count: NSInteger
        let shows: [Show]
        
        enum CodingKeys: String, CodingKey {
            case count
            case shows = "results"
        }
    }
    
    struct Show: Decodable {
        let name: String
        let start_time: String
        let end_time: String
        let rating: String
        let channel: String
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case start_time = "start_time"
            case end_time = "end_time"
            case rating = "rating"
            case channel = "channel"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getJSONData()
    }
    
    // api
    func getJSONData() {
        print("getJSONData")
        
        if ReachabilityTest.isConnectedToNetwork() {
            print("Internet connection available")

            let urlstring = "https://www.whatsbeef.net/wabz/guide.php?start=" + self.batch
            guard let url = URL(string: urlstring) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    print(error ?? "Unknown error")
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let json = try decoder.decode(Response.self, from: data)
                    
                    // print(json.shows)
                    // print(json.count)
                    
                    self.shows.append(contentsOf: json.shows)
                } catch {
                    print(error)
                }
 
                // reload tableview when the app finishes getting data from the API
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
        else{
            print("No internet connection available")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tonight"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            
            self.batch = String(Int(self.batch)! + 1)
            print("Batch: " + self.batch)
            getJSONData()
        }
    }
    
    func tableView(_ collectionView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "homeToDetails", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToDetails"{
            let selectedIndexPath = sender as! NSIndexPath
            
            let dvc = segue.destination as! DetailsController
            let show = self.shows[selectedIndexPath.row]
            
            dvc.name = show.name
            dvc.schedule = show.start_time + " - " + show.end_time
            dvc.channel = show.channel
            dvc.rating = show.rating
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! ViewControllerCell
        
        let show = self.shows[indexPath.row]
        cell.Name.text = show.name
        cell.Schedule.text = show.start_time + " - " + show.end_time
        cell.Channel.image = UIImage(named: show.channel)
        
        let newY = cell.frame.size.height * 0.387096774193548
        var newX: CGFloat
        
        if (show.rating == ""){
            cell.Rating.image = UIImage(named: "NR")
            newX = cell.frame.size.width * 0.717333333333333
        }
        else {
            cell.Rating.image = UIImage(named: show.rating)
            newX = cell.frame.size.width * 0.872
        }
        
        let scaledWidth = (cell.Rating.image?.size.width)! * 0.5
        let scaledHeight = (cell.Rating.image?.size.height)! * 0.5
        
        cell.Rating.frame = CGRect(x: newX, y: newY, width: scaledWidth, height: scaledHeight)
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
