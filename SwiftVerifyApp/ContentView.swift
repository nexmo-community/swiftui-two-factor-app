//
//  ContentView.swift
//  SwiftVerifyApp
//
//  Created by Abdulhakim Ajetunmobi on 06/11/2020.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var verifyModel: VerifyModel
    
    var body: some View {
        Text("Phone number verification").padding()
        
        switch verifyModel.verificationStatus {
        case .notRequested, .requested:
            TextField(verifyModel.placeholderText(), text: $verifyModel.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .disabled(verifyModel.isLoading)
                .padding(20)
            ButtonView()
        case .verified:
            Text("You have verified that number!").padding()
            ButtonView()
        }
    }
}

struct ButtonView: View {
    @EnvironmentObject var verifyModel: VerifyModel
    
    var body: some View {
        switch verifyModel.verificationStatus {
        case .notRequested:
            Button(action: { verifyModel.requestCode() }) {
                HStack(spacing: 10) {
                    Image(systemName: "text.bubble")
                    Text("Request Code")
                }
            }.disabled(verifyModel.isLoading)
        case .requested:
            Button(action: { verifyModel.verifyCode() }) {
                HStack(spacing: 5) {
                    Image(systemName: "lock.circle")
                    Text("Verify Code")
                }
            }.disabled(verifyModel.isLoading)
        case .verified:
            Button(action: { verifyModel.verificationStatus = .notRequested }) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.clockwise.circle")
                    Text("Try again")
                }
            }
        }
    }
}
