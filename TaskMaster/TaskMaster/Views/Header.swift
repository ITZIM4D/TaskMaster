//
//  Header.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/5/24.
//

import SwiftUI

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

#Preview {
    Header()
}
