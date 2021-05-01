//
//  TableVC.swift
//  ToDoList
//
//  Created by Aleksandr Khalupa on 16.03.2021.
//

import UIKit
import CoreData


class TableVC: UITableViewController, UISearchBarDelegate{


    @IBOutlet weak var searchField: UISearchBar!
    
    var listArray = [List]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request:NSFetchRequest<List> = List.fetchRequest()
    var selectedCategory: AHCategory?{
        didSet{
            readData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
//        readData()
        
//        let array1:[Int] = [1,2,3,4,5]
//        let array2:Array<Int> = [1,2,3,4,5]
//        let array3:Dictionary = [1,2,3,4,5]
//        let array4:Set = [1,2,3,4,5]
        
//        var array1:Array<Int> = []
//        var array2 = [Int]()
//        var array3:[Int] = []
//        var array4 = Array<Int>()
        
        
    }
    
    
    
    
//    @IBAction func pressedEdit(_ sender: UIBarButtonItem) {
//
//
//        if tableView.isEditing{
//            tableView.setEditing(false, animated: true)
//            sender.title = "Edit"
//        } else{
//            tableView.setEditing(true, animated: true)
//            sender.title = "Done"
//        }
//    }
    
    
    @IBAction func pessedAdd(_ sender: UIBarButtonItem) {
        var textFied = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "For your list", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            let item = List(context: self.context)
            item.item = textFied.text!
            item.isCheck = false
            item.catRelationship = self.selectedCategory
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
    
    //    MARK: - CORE DATA
    
    func saveData(){
        do{
            try context.save()
        }catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func readData(request:NSFetchRequest<List> = List.fetchRequest(), listPredicate:NSPredicate? = nil){
        
        guard let nameCategory = selectedCategory?.name else { return }
        
        let predicate = NSPredicate(format: "catRelationship.name MATCHES %@", nameCategory)
        if let listPredicate = listPredicate{
            print(predicate.description)
            request.predicate = listPredicate
        } else{
            request.predicate = predicate
            print(predicate.description)
        }
        
        do{
           listArray = try context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    //    MARK: - TableVC

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)

        cell.textLabel?.text = listArray[indexPath.row].item
        
        cell.accessoryType = listArray[indexPath.row].isCheck ? .checkmark : .none
        
        return cell
    }
    
//    (user, messege | alex, Hello | Nik, Hi)
//    SQL - Язык для работы с реалицыонными базами даными
//    MySQL(субд) - Система управления базами данными - Движок. SQLite, Realm.
//    CRUD
//    CRUD-L
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        listArray[indexPath.row].isCheck = !listArray[indexPath.row].isCheck
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(listArray[indexPath.row])
        listArray.remove(at: indexPath.row)
        saveData()
        tableView.reloadData()
        
    }

    //    MARK: - Search

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInDB(text: searchText, searchBar: searchBar)
    }
    
    func searchInDB(text:String, searchBar: UISearchBar){
        let localRequest:NSFetchRequest<List> = List.fetchRequest()
        if text != ""{
            let predicate = NSPredicate(format: "item CONTAINS[cd] %@", text)
            localRequest.predicate = predicate
            readData(request: localRequest, listPredicate: predicate)
            print(predicate.description)
//            let sort = NSSortDescriptor(key: "item", ascending: true)
            localRequest.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]
        } else{
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.readData()
            }
            
            
        }
        

        
        tableView.reloadData()
        
    }

}
