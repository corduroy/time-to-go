//
//  ContentView.swift
//  Time To Go
//
//  Created by Joshua McKinnon on 2/7/2022.
//

import SwiftUI
import CoreData
import MapKit
import CoreLocationUI


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var locationManager = LocationManager()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $locationManager.regionForMap,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow),
                annotationItems: locationManager.geofences) {item in
                MapAnnotation(coordinate: item.coordinate) {
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 4.0)
                        .background(Circle().foregroundColor(Color(red: 0.0, green: 0, blue: 1.0, opacity: 0.25)))
                        .frame(width: 60, height: 60)
                        .offset(x:0, y:0)
                 }}
                .edgesIgnoringSafeArea(.all)
            VStack {
                if let locationJJM = locationManager.locationForMap {
                    Text("**Current location:** \(locationJJM.latitude), \(locationJJM.longitude)")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
                Button("Remind Me To Go", action:remindMe)
            }
            .padding()
            .buttonStyle(.bordered)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                if (locationManager.authorizationStatus() != .authorizedAlways ) {
                    locationManager.requestAlwaysAuthorization()
                }
            }
        }
    }
    
    
    
    private func remindMe() {
        locationManager.setGeofenceFor(location: locationManager.locationForMap!)
        print("Set Geofence")
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
