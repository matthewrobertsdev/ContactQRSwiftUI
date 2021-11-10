//
//  Persistence.swift
//  Shared
//
//  Created by Matt Roberts on 11/5/21.
//
import CoreData
//persistent controller singleton
struct PersistenceController {
	//the static object
    static let shared = PersistenceController()
	//the container
    let container: NSPersistentCloudKitContainer
	//load the store on init
    init() {
        container = loadPersistentCloudKitContainer()
    }
	//for preview
	static var preview: PersistenceController = {
		let result = PersistenceController()
		let viewContext = result.container.viewContext
		for _ in 0..<10 {
			let newContactCard = ContactCardMO(context: viewContext)
		}
		do {
			try viewContext.save()
		} catch {
			let nsError = error as NSError
			print(error)
		}
		return result
	}()
}
