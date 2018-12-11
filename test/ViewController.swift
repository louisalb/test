//
//  ViewController.swift
//  test
//
//  Created by ALBERT Louis on 11/12/2018.
//  Copyright © 2018 ALBERT Louis. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {

    
   
    @IBOutlet weak var texteCount: UITextField!
    @IBOutlet weak var boutonTest: UIButton!
    @IBOutlet weak var btn: UIButton!
    
    var database: Connection!
    
    let users_table = Table("users")
    let users_id = Expression<Int>("id")
    let users_name = Expression<String>("name")
    let users_email = Expression<String>("email")
    
    var pk = 1000;
    var tableExist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--> viewDidload debut")
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let base = try Connection(fileUrl.path)
            self.database = base;
        }
        catch {
            print(error)
        }
        print("--> viewDidLoad fin")
    }
    
    func createTableUsers(){
        print("--> createTableUsers debut")
        if !self.tableExist {
            self.tableExist = true
            
            let dropTable = self.users_table.drop(ifExists: true)
            // Instruction pour faire un create de la table USERS
            let createTable = self.users_table.create { table in
                table.column( self.users_id, primaryKey: true)
                table.column(self.users_name)
                table.column(self.users_email)
            }
                do {
                    // Exécution du drop et du create
                    try self.database.run(dropTable)
                    try self.database.run(createTable)
                    print ("Table users est créée")
                }
                catch
                {
                    print (error)
                }
            }
            print ("--> createTableUsers fin")
    }
    // ====
    //Création d'un générateur de clé primaire
    
    func getPK() -> Int {
        self.pk += 1
        return self.pk
    }
    
    func insertTableUsers() {
        print ("--> insertTableUsers debut")
        // Insertion de 2 tuples exemples (sera réalisé à chaque click sur le bouton)
        let insert1 = self.users_table.insert(self.users_id <- getPK(),
                self.users_name <- "marc", self.users_email <- "marc@if26.fr")
        let insert2 = self.users_table.insert(self.users_id <- getPK(),
                self.users_name <- "sophie", self.users_email <- "sophie@if26.fr")
        do {
            try self.database.run(insert1)
            print("Insert1 ok")
            try self.database.run(insert2)
            print("Insert2 ok")
        }
        catch {
            print (error)
        }
        print ("--> insertTableUsers fin")
    }
    
    // Solution 1 : Combien de tuples dans la table USERS ?
    func CountTableUsers1() -> Int{
        print ("--> CountTableUsers1 debut")
        var resultat = 0
        do {
            resultat = try self.database.scalar(users_table.count)
            print ("count1 = ", resultat)
        }
        catch {
            print (error)
            resultat = -1
        }
        print ("--> CountTableUsers1 fin")
        return resultat
    }
    
    func selectUSers() {
        print ("--> selectUSers debut")
        do {
            let users = try self.database.prepare(self.users_table)
            for user in users {
                print ("id =", user[self.users_id],", name =",user[self.users_name],", email= ", user[self.users_email])
            }
        }
        catch {
            print("--> selectUSers est en erreur")
        }
        print ("--> selectUSers fin")
    }
    
    @IBAction func action() {
        print ("-")
        print ("======================================")
        print ("--> Début des traces ")
        createTableUsers()
        insertTableUsers()
        let resultat1 = CountTableUsers1()
        texteCount.text = String (resultat1)
        //let resultat2 = CountTableUsers2()
        //texteCount.text = String (resultat2)
        //selectUSersSophie()
        //selectUsersMarc()
        selectUSers()
        //updateUserName()
        //deleteUser(numero:1004)
        print ("--> boutonAction fin")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

