//
//  documentsVC.swift
//  voiceText
//
//  Created by Eminko on 24.06.2023.
//

import UIKit
import CoreData

class documentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var nameArray = [String]()
    var idArray = [UUID]()

    
    var selectedProject : String = ""
    var selectedID : UUID?

    @IBOutlet weak var documentsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        // Do any additional setup after loading the view.
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
   @objc func getData() {
       
       //iki kere çekme işlemi yapılırsa duplicate olmasın diye
       nameArray.removeAll(keepingCapacity: false)
       idArray.removeAll()
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Documents")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            //bu result aslında bir dizi
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                if let name = result.value(forKey: "name") as? String {
                    
                    nameArray.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID {
                                                   self.idArray.append(id)
                                               }
                
                self.documentsTableView.reloadData()
            }
            
            
        }catch{
            print("veri çekme error")
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsTableView.dequeueReusableCell(withIdentifier: "documentsCell") as! documentsTableViewCell
        cell.titleLabel.text = nameArray[indexPath.row]
        cell.dateLabel.text = "17 Mart 2023"
        
        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "documentsToDetails" {
            let destinationVC = segue.destination as! detailsVC
            destinationVC.selectedProject = selectedProject
            destinationVC.selectedID = selectedID
            
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        selectedProject = nameArray[indexPath.row]
        selectedID = idArray[indexPath.row]
        
        
        self.performSegue(withIdentifier: "documentsToDetails", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Documents")
        let idString = idArray[indexPath.row].uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let id = result.value(forKey: "id") as? UUID{
                        
                        if id == idArray[indexPath.row]{
                            context.delete(result)
                            nameArray.remove(at: indexPath.row)
                            idArray.remove(at: indexPath.row)
                            self.documentsTableView.reloadData()
                            
                            do{
                                try context.save()
                            }catch{
                                print("error 2")
                            }
                            //bulduktan sonra tekrar aramaya devam etmesin loop
                            break
                            
                        }
                        
                    }
                        
                }
            }
        }catch{
            print("error1")
        }
        
        
        
      
        
    }
    

}
