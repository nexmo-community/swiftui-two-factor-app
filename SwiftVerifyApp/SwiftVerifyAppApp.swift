//
//  SwiftVerifyAppApp.swift
//  SwiftVerifyApp
//
//  Created by Abdulhakim Ajetunmobi on 06/11/2020.
//

import SwiftUI

@main
struct SwiftVerifyAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(VerifyModel())
        }
    }
}
