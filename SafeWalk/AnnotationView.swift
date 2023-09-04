//
//  AnnotationView.swift
//  SafeWalk
//
//  Created by Rahqi Sarsour on 9/2/23.
//

import SwiftUI
import CoreLocation
import _MapKit_SwiftUI

struct ReportAnnotation: Identifiable {
    let id = UUID()
    let reportType: String
    let reportId: String
    let coordinate: CLLocationCoordinate2D
    let report: Report
}


struct AnnotationView: View {
    let reportType: String
    let reportId: String
    let coordinates: CLLocationCoordinate2D
    let report: Report

    @State private var showUpdateReport = false
    var body: some View {
        VStack {
            Button {
                showUpdateReport.toggle()
            }
        label:
            {
                Image(getReportImage(reportType: reportType))
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 30, height: 30, alignment: .center)
            }
            .popover(isPresented: $showUpdateReport, content: {
                UpdateReportView(reportType: reportType, reportId: reportId, coordinates: coordinates, report: report)
            })
            .buttonStyle(.automatic)
            .buttonBorderShape(.automatic)
            
          
                
//          Image(systemName: "arrowtriangle.down.fill")
//            .font(.caption)
//            .foregroundColor(.red)
//            .offset(x: 0, y: -5)
        }
//        .onTapGesture(perform: {
//            withAnimation(.default, {
//
//            })
//        })
      }
}

private func getReportImage(reportType: String) -> String {
    var ret: String = ""
    
    switch reportType {
    case "Police":
        ret = "ReportView_Police"
        break;
    case "FootTraffic":
        ret = "ReportView_Crowded"
        break;
    case "Construction":
        ret = "ReportView_Construction"
        break;
    case "SuspiciousActivity":
        ret = "ReportView_Suspicious"
        break;
    case "NoLights":
        ret = "ReportView_NoLights"
        break;
        
    default: break;
    }
    
    return ret
}

//struct AnnotationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnnotationView(place: <#IdentifiablePlace#>, region: <#MKCoordinateRegion#>)
//    }
//}
