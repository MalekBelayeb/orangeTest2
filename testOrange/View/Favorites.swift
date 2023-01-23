//
//  Favorites.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import Foundation
import UIKit
import CoreData
class Favorites : UIViewController,UITableViewDelegate,UITableViewDataSource{
    var tabPlaces = [Place] ()
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return tabPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFav")
              let cv = cell?.contentView
              let nom = cv?.viewWithTag(4) as! UILabel
              let desc = cv?.viewWithTag(5) as! UILabel
              let distance = cv?.viewWithTag(6) as! UILabel
        let fav = cv?.viewWithTag(7) as! UIButton
              
        desc.text = self.tabPlaces[indexPath.row].kinds
        nom.text = self.tabPlaces[indexPath.row].name
        distance.text = String(format: "%.2f", self.tabPlaces[indexPath.row].dist) + "m"

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         performSegue(withIdentifier: "detail", sender: indexPath)
     }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let index = sender as! IndexPath
            let destination = segue.destination as! DetailPlace
            UserDefaults.standard.setValue(tabPlaces[index.row].xid, forKey: "xid")
        }
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabPlaces.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity3")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
        {
            print(data.value(forKey: "name") as! String)
                tabPlaces.append(Place(xid: data.value(forKey: "xib") as! String, name: data.value(forKey: "name") as! String, dist: data.value(forKey: "dist") as! Double, rate: 0, osm: "", wikidata: "", kinds: data.value(forKey: "kinds") as! String, point: Point(lon: 0, lat: 0)))
          }
        } catch {
            print("Failed")
        }
        tableView.reloadData()
        print(tabPlaces.count)
    }
    
}

