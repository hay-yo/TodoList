//
//  ViewController.swift
//  TodoList
//
//  Created by t2023-m0023 on 2023/12/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    //creating a table view
    private var table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    //creating an array for the items in the table
    //setting it as a global variable
    var items = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? [] //to add and save the items in the table
        
        //title
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self // this causes the error -> fixing it by adding xcode's suggestion!
        
        //adding a plus bar button for adding new todo items
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd)) //here im gonna call "didTapAdd" func -> which means i need to creat it now -> do i understand it? "NO"
    }
    
    //creating the func "didTapAdd" for the plus bar button
    //also setting up an alert as well
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "새로운 할 일", message: "새로운 할 일을 입력하세요!", preferredStyle: .alert)
        
        //adding a text field to the alert
        //and a placeholder
        alert.addTextField { field in
            field.placeholder = "할 일을 입력하세요..."
        }
        
        //cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //done button
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            
            //getting the input from the text field
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    //->if the text field is not empty, then add the text to the array
                    
                    //enter new doto item
                    //also making sure that it is on the main thread -> DispatchQueue
                    DispatchQueue.main.async {
                        
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? [] //else, return an empty array
                        currentItems.append(text)
                        
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text) //these two lines of code threw an error -> apparently i have to add [weak self] in one of the buttons... -> but why is still a mystery...
                        self?.table.reloadData()
                    }
                }
            }
            
        }))
        //presenting the alert with an animation
        present(alert, animated: true)
    }
    
    
    //giving the table a frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
        //table's x, y, width, height == view's bounds; x, y, width, height
    }
    
    
    
    //funcs are needed to conform to the UITableViewDataSource
    //this is recommended by xcode
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of rows we wanna have in the table
        return items.count //-> this will show the number of todo items we have
    }
    
    //this func creats and returns a cell -> should i make an array first??
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        
        return cell
    }
    
    
//deleting a cell!!!!!!!!!
//trials and errors and errors until copliot kick in
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
      if editingStyle == .delete {
    
          items.remove(at: indexPath.row) //범위를 지정해주지 않아서 에러가 난듯? -> nah it was something else...
          UserDefaults.standard.setValue(items, forKey: "items")
          tableView.deleteRows(at: [indexPath], with: .fade) // -> copilot suggested this... and it works...???? how and why?
       }
  }
    
}

//lots of time spending in googlgling, watching tutorials on youtube,
//and a help of copilot made this possible...
//my contribution in this assignment is next to nil..🥹
