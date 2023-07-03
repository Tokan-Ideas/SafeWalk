//
//  NotificationView.swift
//  SafeWalk
//
//  Created by Rahqi T. Sarsour on 7/1/23.
//

import SwiftUI

struct NotificationView: View {
    @State private var PoliceNotification = false
    @State private var LightNotification = false
    @State private var SidewalkNotification = false
    @State private var ConstructionNotification = false
    @State private var BusyNotification = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
       // navigationTitle("Notifications")
       // navigationBarTitle("Notifications")
        HStack(alignment: .center) {
            Text("Alerts").font(.title).fontWeight(.heavy)
            
        }
        Text("Choose the activities for which you wish to receive alerts.").font(.caption).fontWeight(.light)
        List {
                Toggle(isOn: $PoliceNotification) {
                        Text("Police")
                    }
            

                Toggle(isOn: $LightNotification) {
                        Text("No Light")
                }
          
          
                Toggle(isOn: $SidewalkNotification) {
                        Text("Closed Sidewalk")
                }
            
           
                Toggle(isOn: $ConstructionNotification) {
                        Text("Construction")
                }
            
            
                Toggle(isOn: $BusyNotification) {
                        Text("High Foot Traffic")
                }
          
        }
        Spacer()
        HStack(alignment: .bottom, content: {
            Button("Close") {
                dismiss()
            }
        })
        
    }
}

//
//#Preview {
//    NotificationView()
//}
