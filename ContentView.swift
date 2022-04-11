//
//  ContentView.swift
//  ColumbiaUniversity
//
//  Created by jamar Bevel on 4/10/22.
//

import SwiftUI


struct meal : Identifiable {
    var idd : String {
        self.name
    }
    var name : String
    var thumbNail : String
    var id : String
}

struct ContentView: View {
   @State private var meals : [meal] = []
    var body: some View {
       
        ScrollView(showsIndicators:false){
            VStack{
                Text("Student Menu").bold().font(.system(size: 25))
                
                ForEach(meals){ m in
                    HStack{
                        
                        AsyncImage(url: URL(string: m.thumbNail), content: { image in
                            image.resizable()
                           
                        }, placeholder: {
                            ProgressView()
                        })
                            .frame(width: 100, height: 100)
                            .cornerRadius(30)
                        Text(m.name)
                        Spacer()
                       
                            
                    }
                }
            }.onAppear {
                getMeals()
            }
        }
        
    }
    func getMeals(){
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                       (200...299).contains(httpResponse.statusCode) else {
               
                       return
                   }
            let go = data
            let json = try? JSONSerialization.jsonObject(with: go!,options: []) as? [String:Any]
            guard let json2 = json!["meals"] as? [[String:Any]] else {return}
            for n in 0..<(json2.count - 1) {
                meals.append(meal(name: json2[n]["strMeal"] as? String ?? "there is no meal", thumbNail: json2[n]["strMealThumb"] as? String ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Blank_square.svg/2048px-Blank_square.svg.png", id: json2[n]["idMeal"] as? String ?? "nil"))
            }
           
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
