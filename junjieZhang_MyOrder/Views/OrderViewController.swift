//
//  OrderViewController.swift
//  junjieZhang_MyOrder
//
//  Created by Junjie Zhang on 2021-02-13.
//

import UIKit

class OrderViewController: UIViewController {
    
    private var taskList : [ToDo] = [ToDo]()
    
    private let dbHelper = DatabaseHelper.getInstance()
    
    @IBOutlet var coffeePicker: UIPickerView!
    @IBOutlet var sizeController: UISegmentedControl!
    @IBOutlet var coffeeQuantity: UITextField!
    @IBOutlet var errorNotification: UILabel!
    
    
    
    //var orderList:Array = [[String:String]]()
    var selectedCoffee:String?
    var nameText:String?
    
    //this variable will store list data and will pass it to tableview
    //var taskList: [Task] = []
    
    let coffeeList = ["dark roast","original blend","vanilla","etc"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "Coffee Order"
        
        self.coffeePicker.dataSource = self
        self.coffeePicker.delegate = self
        
        //create the button object
        let ViewOrders = UIBarButtonItem(title: "View Orders", style: .plain, target: self, action: #selector(viewOrderList))
        //let btnAddTask = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(orderButton))

        
        //put the button to the screen window
        self.navigationItem.setRightBarButton(ViewOrders, animated: true)
        // Do any additional setup after loading the view.
    }
    
    
    
    //this is the button detail, and it can be used without a button object
    @IBAction func orderButton(){
        selectedCoffee = coffeeList[0]
        if(selectedCoffee != nil && sizeController.titleForSegment(at: sizeController.selectedSegmentIndex) != nil && coffeeQuantity.text != ""){
            let data1 : String?  = selectedCoffee //orderList.append(data1);
            let data2 : String? = sizeController.titleForSegment(at: sizeController.selectedSegmentIndex)
            let data3 : String? = coffeeQuantity.text
            
            //let buffer = Task(coffeeT: data1!, coffeeS: data2!, coffeeQ: data3!)
            
            self.addTaskToList(orderSize: data2!, orderQuantity: data3!, orderType: data1!)
            //self.taskList.append(buffer)
            //print("this is the test"+self.taskList[0].coffeeQTY)

    
            errorNotification.text = ""
            self.viewOrderList()

        }else{
            print("selectedCoffee is empty")
            print(sizeController.titleForSegment(at: sizeController.selectedSegmentIndex)!)
            print("."+coffeeQuantity.text!+".")
            print("it is empty")
            if(selectedCoffee == nil){
                errorNotification.text = "missing coffee type"
            }else if(sizeController.titleForSegment(at: sizeController.selectedSegmentIndex) == nil){
                errorNotification.text = "missing coffee size"
            }else if(coffeeQuantity.text == ""){
                errorNotification.text = "missing coffee quantity"
            }
            
        }
        
    }
    
    //the function will help us to go to the target page
    //and pass the data
    @objc public func viewOrderList(){
    
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let tableViewID = storyboard.instantiateViewController(identifier: "tableViewID") as! ToDoTableTableViewController
        
        
        //this code will pass the taskList data with the
        //tableViewID.taskList = self.taskList
        self.navigationController?.pushViewController(tableViewID, animated: true)
        
//        self.nameText = "test value"
//        performSegue(withIdentifier: "name", sender: self)
    }
    
    
    private func addTaskToList(orderSize: String, orderQuantity: String, orderType: String){
        let newTask = Task(coffeeT: orderType, coffeeS: orderSize, coffeeQ: orderQuantity)
        self.dbHelper.insertTask(newToDo: newTask)
        
    }
    
    private func deleteTaskFromList(indexPath: IndexPath){
        self.dbHelper.deleteTask(taskID: self.taskList[indexPath.row].orderID!)
    }
    
    
    private func updateTaskInList(indexPath: IndexPath, coffeeQ: String, coffeeS: String, coffeeT: String){
        self.taskList[indexPath.row].coffeeQuantity = coffeeQ
        self.taskList[indexPath.row].coffeeSize = coffeeS
        self.taskList[indexPath.row].coffeeType = coffeeT
        
        self.dbHelper.updateTask(updatedTask: self.taskList[indexPath.row])
    }
    

    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
//        var vc = segue.destination as! ToDoTableTableViewController
//        vc.text = self.nameText!
//    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}


extension OrderViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.coffeeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coffeeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(#function, "selected country \(self.coffeeList[row])")
        self.selectedCoffee = self.coffeeList[row]
    }
}
