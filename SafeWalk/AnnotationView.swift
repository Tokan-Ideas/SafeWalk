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

struct GenericMapAnnotation: Identifiable {
    let id = UUID()
    let annotationType: String
    let reportType: String?
    let reportId: String?
    let coordinate: CLLocationCoordinate2D?
    let report: Report?
    let mapItem: MKMapItem?
}


struct AnnotationView: View {
    let reportType: String
    let reportId: String
    let coordinates: CLLocationCoordinate2D
    let report: Report
    @Binding var showSelected: Bool
    @State var showUpdateReport = false
    @Binding var showSearch: Bool
    
    var body: some View {
        
        if #available(iOS 17.0, *) {
            Button {
                showUpdateReport.toggle()
                showSearch = false
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
                    .onAppear {
                        showSelected = false
                    }
//                    .onDisappear {
//                        showSearch = true
//                    }

            })
            .buttonStyle(.automatic)
            .buttonBorderShape(.automatic)
           
        } else {
            // Older Versions Options of Somethin
            
            
            
            Button {
                showUpdateReport.toggle()
                showSearch = false
            }
        label:
            {
                Image(getReportImage(reportType: reportType))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .sheet(isPresented: $showUpdateReport, content: {
                UpdateReportView(reportType: reportType, reportId: reportId, coordinates: coordinates, report: report)
                    .presentationDetents([ .large])
                    .onAppear {
                        showSelected = false
                    }
                //                    .onDisappear {
                //                        showSearch = true
                //                    }
                
            })
            .buttonStyle(.automatic)
            .buttonBorderShape(.automatic)
        }
          
                
//          Image(systemName: "arrowtriangle.down.fill")
//            .font(.caption)
//            .foregroundColor(.red)
//            .offset(x: 0, y: -5)
        
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
