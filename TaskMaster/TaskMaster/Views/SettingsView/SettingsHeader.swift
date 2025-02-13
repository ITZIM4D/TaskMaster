//
//  SettingsHeader.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/8/25.
//

import SwiftUI

struct SettingsHeader: View {
    var body: some View {
        ZStack{
            Color(red: 204 / 255, green: 229 / 255, blue: 255 / 255)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 80)
            
            Text("Settings")
                .font(.system(size: 70))
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .multilineTextAlignment(.center)
        }
    }
}

struct SettingsHeader_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHeader()
    }
}
