//
//  ContentView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 8/17/24.
//

import SwiftUI

// Main view
struct ContentView: View {
    var body: some View {
        VStack {
            Header()
            Spacer()
        }
    }
}

// Welcoming header
struct Header: View {
    var body: some View {
        Text("Welcome To TaskMaster")
            .font(.largeTitle)
            .background(Color.orange)
            .padding()
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
