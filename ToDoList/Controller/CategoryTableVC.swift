//
//  CategoryTableVC.swift
//  ToDoList
//
//  Created by Aleksandr Khalupa on 02.04.2021.
//

import UIKit
import CoreData

class CategoryTableVC: UITableViewController {

    
    var categoriesArray = [AHCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request:NSFetchRequest<AHCategory> = AHCategory.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func pressedEditCategory(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
        } else{
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
        }
    }
    
    
    
    @IBAction func pressedAddCategory(_ sender: UIBarButtonItem) {
        
        var textFied = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            let category = AHCategory(context: self.context)
            category.name = textFied.text!
            self.saveData()
            self.readData()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (textF) in
            textF.placeholder = "input text"
            textFied = textF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else{return}
        if segue.identifier == "goToItem"{
            let itemTableVC = segue.destination as! TableVC
            itemTableVC.selectedCategory = categoriesArray[selectedRow]
        }
    }
    
    //    MARK: - CORE DATA
    
    func saveData(){
        do{
            try context.save()
        }catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func readData(request:NSFetchRequest<AHCategory> = AHCategory.fetchRequest()){
        do{
            categoriesArray = try context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(categoriesArray[indexPath.row])
        categoriesArray.remove(at: indexPath.row)
        saveData()
        tableView.reloadData()
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
