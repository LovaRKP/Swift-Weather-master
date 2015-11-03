//
//  CitysViewController.swift
//  WeatherApp
//
//  Created by Techno on 11/3/15.
//  Copyright © 2015 Techno. All rights reserved.
//

import UIKit
import Alamofire



class CitysViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    var places: NSString!
    @IBOutlet weak var myTableviewStates: UITableView!
    var myTableData  = []
    var actInd : UIActivityIndicatorView?
    
    var urlId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title="Select the City for Weather"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
       
        
        actInd  = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd!.center = self.view.center
        actInd!.hidesWhenStopped = true
        actInd!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
         actInd!.color = UIColor.redColor()
        view.addSubview(actInd!)
        actInd!.startAnimating()
        
        myTableviewStates.delegate = self
        myTableviewStates.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        urlId = places as String;
        
        
        let urlValue = "https://www.WhizAPI.com/api/v2/util/ui/in/indian-city-by-state?project-app-key=pz6utk2ypq8vxktwkczxnuxc&stateid=\(urlId)"
        
        print("",urlValue)
        
        
        Alamofire.request(.GET, urlValue).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                if let dataAray = JSON["Data"] as? NSArray {
                    
                    self.myTableData = dataAray;
                    
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.myTableviewStates.reloadData()
                        self.actInd!.stopAnimating()
                    }
                    
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                
                }
                
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let textCellIdentifier = "Cell"
        
        let cell = myTableviewStates.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let city : String = self.myTableData.objectAtIndex(indexPath.row).objectForKey("city") as! String ;
        
        cell.textLabel?.text = city;
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "myRoot", let destination = segue.destinationViewController as? ViewController {
            
            
            if let cell = sender as? UITableViewCell, let indexPath = myTableviewStates.indexPathForCell(cell) {
                
                
                let affiliation = self.myTableData.objectAtIndex(indexPath.row).objectForKey("city") as! String ;
                destination.climite = affiliation
                
                print("destina ====",destination.climite)
            }
        }
        
        
    }
    
}
