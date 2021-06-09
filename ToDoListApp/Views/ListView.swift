//
//  ListView.swift
//  ToDoListApp
//
//  Created by admin on 5/6/21.
//

import SwiftUI

struct searchView: View {
    @State var searchQuery = ""
    var body: some View{
        HStack{
            Image(systemName: "magnifyingglass")
                .font(.system(size: 23,weight: .bold))
                .foregroundColor(.gray)
            TextField("Search",text: $searchQuery)
        }
        .padding(.vertical,10)
        .padding(.horizontal)
        .background(Color.primary.opacity(0.05))
        .cornerRadius(8)
        .padding(.horizontal)
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 200, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        ZStack{
            if listViewModel.items.isEmpty{
                NoItemsView()
            }else{
                List{
                    ForEach(listViewModel.items) { item in
                        ListRowView(item: item)
                            .onTapGesture {
                                withAnimation(.linear){
                                    listViewModel.updateItem(item: item)
                                }
                            }
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    .onMove(perform: listViewModel.moveItem)
                    
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Todo list ✏️")
        .navigationBarItems(
            leading:
                HStack{
                    EditButton()
                    searchView()
                },
            trailing:
                NavigationLink("Add", destination: addView())
            )
    }
}

struct tabBarView: View {
    var body: some View{
        TabView{
            NavigationView{
                ListView()
            }
            .environmentObject(ListViewModel())                .tabItem {
                    Text("todo")
                    Image(systemName: "pencil")
                }
            ContentView()
                .tabItem {
                    Text("stopWatch")
                    Image(systemName: "clock")
                }
        }
    }
}

struct ContentView: View {
    
   @State private var isShowingRed = false
   @ObservedObject var stopWatchManager = StopWatchManager()
   @State private var timerIndex = 0
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    isShowingRed = false
                }) {
                    TimerButton(label: "Timer", buttonColor: .black, textColor: .red)
                }
                Button(action: {
                    self.isShowingRed.toggle()
                }) {
                    TimerButton(label: "StopWatch", buttonColor: .red, textColor: .black)
                }
            }
            Text(String(format: "%.1f:%.1f:%.1f",stopWatchManager.hoursElapsed,stopWatchManager.minutesElapsed, stopWatchManager.secondsElapsed))
                .font(.custom("Avenir", size: 50))
                .padding(.top , 50)
                .padding(.bottom, 50)
                .padding(.trailing, 5)
                .padding(.leading, 5)
            if isShowingRed{
            HStack{
                Picker(selection: $timerIndex , label: Text("Picker")) {
                    ForEach(0..<60){index in
                        Text(String(index)+" sec").tag(index)
                    }
                }
            }.transition(.scale)
            }
            HStack{
                Button(action: {
                    self.stopWatchManager.stop()
                }){
                    TimerButton(label: "[]", buttonColor: .yellow, textColor: .black)
                }
                Button(action: {
                    self.stopWatchManager.pause()
                }){
                    TimerButton(label: "||", buttonColor: .yellow, textColor: .black)
                }
                Button(action: {
                    print(timerIndex)
                    self.stopWatchManager.start()
                }){
                    TimerButton(label: ">", buttonColor: .yellow, textColor: .black)
                }
                
            }
            Spacer()
        }
        
    }
}
struct TimerButton: View {
    
    let label: String
    let buttonColor: Color
    let textColor: Color
    
    
    var body: some View {
        
        Text(label)
            .foregroundColor(textColor)
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .background(buttonColor)
            .cornerRadius(50)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        tabBarView()
    }
}
