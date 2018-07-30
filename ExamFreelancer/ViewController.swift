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
    @IBOutlet weak var tableView: UITableView!
    
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
            
            let batchNumber = "0"
            
            let urlstring = "https://www.whatsbeef.net/wabz/guide.php?start=" + batchNumber
            guard let url = URL(string: urlstring) else { return }
            
            /*
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                guard let data = data else {
                    print("Error: No data to decode")
                    return
                }
                
                let decoder = JSONDecoder()
                let json = try decoder.decode(Response.self, from: data)
                print(json.shows)
                print(json.count)
                
                /*
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json!)
                // print(json!["count"]!)
                */
                
                }.resume()
            */
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    print(error ?? "Unknown error")
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let json = try decoder.decode(Response.self, from: data)
                    print(json.shows)
                    print(json.count)
                    self.shows = json.shows
                    
                } catch {
                    print(error)
                }
                
                /*
                let decoder = JSONDecoder()
                let json = try decoder.decode(Response.self, from: data)
                print(json.shows)
                print(json.count)
                */
 
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! ViewControllerCell
        
        let show = self.shows[indexPath.row]
        cell.cellTitle.text = show.name
        cell.cellSchedule.text = show.start_time + " - " + show.end_time
        cell.cellStation.image = UIImage(named: show.channel)
        cell.cellRating.image = UIImage(named: show.rating)        
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

