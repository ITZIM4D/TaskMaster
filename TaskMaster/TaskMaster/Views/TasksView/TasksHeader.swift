//
//  TasksHeader.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/5/24.
//

import SwiftUI

// Welcoming header
struct TasksHeader: View {
    var body: some View {
        ZStack{
            Color(red: 204 / 255, green: 229 / 255, blue: 255 / 255)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 80)
            
            Text("Tasks")
                .font(.system(size: 70))
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
    }
}

struct TasksHeader_Preview: PreviewProvider {
    static var previews: some View {
        TasksHeader()
    }
}
