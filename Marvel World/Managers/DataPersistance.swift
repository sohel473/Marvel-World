//
//  DataPersistence.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/16/22.
//

import UIKit
import CoreData

enum DatabaseError: Error {
    case failedToSaveData
    case failedToFecthData
    case failedToDeleteData
}

class DataPersistence {
    
    static let shared = DataPersistence()
    
    //MARK: - save data
    func downloadCharacter(model: Character, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard !checkIfItemExist(id: model.id) else { return }
        
        let character = CharacterItem(context: context)
        character.id = Int64(model.id)
        character.name = model.name
        character.resultDescription = model.description
        
        let thumbnail = ThumbnailItem(context: context)
        thumbnail.path = model.thumbnail.path
        thumbnail.character = character
        
        let urls = URLItem(context: context)
        guard let data = try? JSONEncoder().encode(model.urls) else {return}
        urls.url = data
        urls.character = character
        
        do {
            try context.save()
            completion(.success(()))
            NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func checkIfItemExist(id: Int) -> Bool {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CharacterItem> = CharacterItem.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" , id)

        do {
            let count = try context.count(for: fetchRequest)
//            print(count)
//            if count > 0 {
//                return true
//            } else {
//                return false
//            }
            return count > 0 ? true : false
        }catch {
            print(error)
            return false
        }
    }
    
    //MARK: - fetch data
    func fetchingTitles(completion: @escaping(Result<[CharacterItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<CharacterItem> = CharacterItem.fetchRequest()
        
        do {
            let characters = try context.fetch(request)
            completion(.success(characters))
        } catch {
            completion(.failure(DatabaseError.failedToFecthData))
        }
    }
    
    //MARK: - delete data
    func deleteTitle(model: CharacterItem, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
}
