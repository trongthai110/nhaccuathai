//
//  ListViewController.swift
//  Nhaccuathai
//
//  Created by Nguyen Dang Trong Thai on 1/11/23.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableList: UITableView!
    
    var playlists = [PlaylistModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = "///Users/ndtthai/Library/Developer/CoreSimulator/Devices/77A8D940-F48B-4E5F-9C03-689B0AEA123A/data/Containers/Data/Application/DC35CDAF-08B3-45E3-AADA-1167BFE8893C/Documents"
         
        do {
            let itemsInDirectory = try FileManager.default.contentsOfDirectory(atPath: path)
            print(itemsInDirectory)
        } catch {
            print(error)
        }
        
        tableList.delegate = self
        tableList.dataSource = self
    }
    
    func configurePlaylst(playlistName: String) {
        playlists.append(PlaylistModel(name: playlistName))
    }
    
    //---------------------table-----------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellList = tableView.dequeueReusableCell(withIdentifier: "cellList", for: indexPath)
        
        let playlist = playlists[indexPath.row]
        
        cellList.textLabel?.text = playlist.name
        return cellList
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        
        guard let vc = storyboard?.instantiateViewController(identifier: "playlist") as? PlaylistViewController else {
            return
        }
        
        vc.playlists = playlists
        vc.position = position
        
        present(vc, animated: true)
    }
    
    //------------------Add playlist---------------------
    @IBAction func btnAddPlaylist(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Hey bro", message: "Please enter your playlist name", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (txtName) in
            txtName.placeholder = "Playlist Name"
        }
        
        let btnAdd: UIAlertAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.destructive) { (btnAdd) in
        
            let name = alert.textFields![0].text!
            
            if (self.checkFileExist(fileName: name) == false)
            {
                self.Toast(mess: "Added playlist successfully")
                self.createPlaylist(playListName: name)
                self.configurePlaylst(playlistName: name)
            } else {
                self.Toast(mess: "Added playlist failed")
            }
            
            self.tableList.reloadData()
        }
        
        let btnCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (btnCancel) in
            
        }
        
        alert.addAction(btnAdd)
        alert.addAction(btnCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //-------------Lam viec thu muc/file-----------------
    func createPlaylist(playListName: String) {
        let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let DirPath = DocumentDirectory.appendingPathComponent(playListName)
        do
        {
            try FileManager.default.createDirectory(atPath: DirPath!.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory \(error.debugDescription)")
        }
        print("Tao thanh cong: ", playListName)
    }

    //lay duong dan toi thu muc
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    //noi thanh phan duong dan
    func getDocumentFilePath(fileName: String) -> URL {
        let documentPath = getDocumentsDirectory()
        let filePath = documentPath.appendingPathComponent(fileName)

        return filePath
    }

    func checkFileExist(fileName: String) -> Bool {
        let filePath = getDocumentFilePath(fileName: fileName)
        let fileManger = FileManager.default

        if fileManger.fileExists(atPath: filePath.path) {
            print("FILE: \(fileName) is AVAILABLE")
            return true
        } else {
            print("FILE: \(fileName) NOT AVAILABLE")
            return false
        }
    }
    
    func Toast(mess: String) {
        let alert: UIAlertController = UIAlertController(title: "Hey", message: mess, preferredStyle: UIAlertController.Style.alert)
        
        let btnClose: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(btnClose)
        
        present(alert, animated: true, completion: nil)
    }
    
}
