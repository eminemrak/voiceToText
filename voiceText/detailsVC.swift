//
//  detailsVC.swift
//  voiceText
//
//  Created by Eminko on 25.06.2023.
//

import UIKit
import CoreData

class detailsVC: UIViewController {
    
    var selectedProject : String = ""
    var selectedID : UUID?


    
    
    @IBOutlet weak var projectName: UILabel!
    
    @IBOutlet weak var mediaName: UILabel!
    
    @IBOutlet weak var documentContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    @objc func getData() {
        
        
        
        
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Documents")
        
        let idString = selectedID?.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
        
         fetchRequest.returnsObjectsAsFaults = false
         
        do {
                 let results = try context.fetch(fetchRequest)
                  
                  if results.count > 0 {
                      
                      for result in results as! [NSManagedObject] {
                          
                          if let name = result.value(forKey: "name") as? String {
                              projectName.text = name
                          }

                          if let mediaName = result.value(forKey: "mediaName") as? String {
                              self.mediaName.text = mediaName
                          }
                          
                          if let documentContent = result.value(forKey: "documentContent") as? String {
                              self.documentContent.text = documentContent
                          }
                          
                        
                      }
                  }

              }catch{
             print("veri çekme error")
         }
     }
    

  
}
