//
//  FireBaseHelper.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 21.08.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//
import FirebaseFirestore
import FirebaseAuth

class FireBaseHelper {
    
    let db: Firestore
    var userName:String?
    static let shared = FireBaseHelper()
    
    private init() {
        self.db = Firestore.firestore()
        Auth.auth().signInAnonymously { (result, error) in
            self.userName = result?.user.uid
        }
    }
}
