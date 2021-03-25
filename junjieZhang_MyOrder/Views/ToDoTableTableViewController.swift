//
//  ToDoTableTableViewController.swift
//  junjieZhang_MyOrder
//
//  Created by Junjie Zhang on 2021-02-14.
//

import UIKit

class ToDoTableTableViewController: UITableViewController {
    
    //var taskList:[Task]! = []
    
    private var taskList : [ToDo] = [ToDo]()
    
    private let dbHelper = DatabaseHelper.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100;
        
        self.fetchAllToDos()
        self.setUpLongPressGesture()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.taskList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath) as! ToDoTableViewCell
        if indexPath.row<taskList.count{
            let task = taskList[indexPath.row]
            cell.lblType.text = task.coffeeType
            cell.lblSize.text = task.coffeeSize
            cell.lblQTY.text = task.coffeeType
        }
        
        return cell

    }
    
    private func fetchAllToDos(){
        if(self.dbHelper.getAllTodos() != nil){
            self.taskList = self.dbHelper.getAllTodos()!
            self.tableView.reloadData()
        }else{
            print(#function, "No data received from dbHelper")
        }
    }
    
    private func setUpLongPressGesture(){
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended{
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint){
                self.displayCustomAlert(isNewTask: false, indexPath: indexPath, title: "Edit order", message: "please input the new order info")
            }
        }
        
    }
    
    private func displayCustomAlert(isNewTask: Bool, indexPath: IndexPath?, title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if(isNewTask){
            
        }else if(indexPath != nil){
            alert.addTextField{(textField: UITextField) in
                textField.text = self.taskList[indexPath!.row].coffeeType
            }
            alert.addTextField{(textField: UITextField) in
                textField.text = self.taskList[indexPath!.row].coffeeQuantity
            }
            alert.addTextField{(textField: UITextField) in
                textField.text = self.taskList[indexPath!.row].coffeeSize
            }
         
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            if let coffeeT = alert.textFields?[0].text, let coffeeQ = alert.textFields?[1].text, let coffeeS = alert.textFields?[2].text{
                if(isNewTask){
                    
                }else if(indexPath != nil){
                    self.updateTaskInList(indexPath: indexPath!, coffeeQ: coffeeQ, coffeeS: coffeeS, coffeeT: coffeeT)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    private func updateTaskInList(indexPath: IndexPath, coffeeQ: String, coffeeS: String, coffeeT: String){
        self.taskList[indexPath.row].coffeeQuantity = coffeeQ
        self.taskList[indexPath.row].coffeeSize = coffeeS
        self.taskList[indexPath.row].coffeeType = coffeeT

        
        self.dbHelper.updateTask(updatedTask: self.taskList[indexPath.row])
        
        self.fetchAllToDos()
    }
    
    
    private func deleteTaskFromList(indexPath: IndexPath){
        self.dbHelper.deleteTask(taskID: self.taskList[indexPath.row].orderID!)
        self.fetchAllToDos()
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
     //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            //tableView.deleteRows(at: [indexPath], with: .fade)
            print("delete command comfirm")
            self.deleteTaskFromList(indexPath: indexPath)
        } else if editingStyle == .insert {

        }
    }
    

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
