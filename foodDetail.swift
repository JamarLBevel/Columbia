//
//  foodDetail.swift
//  ColumbiaUniversity
//
//  Created by jamar Bevel on 4/10/22.
//

import SwiftUI
struct mealDetails: Identifiable {
    var id : String {
        self.strMeal
    }
    var strInstructions: String
    var strMeal : String
    var  strMealThumb : String
    var strIngredient : [String]
    var strMeasure1 : [String]
}
struct foodDetail: View {
    @State private var meal1 = meal(name: "we got this", thumbNail: "nope", id: "52970")
    @State private var mealDetail : [mealDetails] = []
    @State private var testx = "f"
    var body: some View {
       
        VStack{
            ForEach(mealDetail) { m in
                Text(m.strMeal)
            }
         
          
            
        }.onAppear {
            getMealDetails()
        }
        
        
    }
    func getMealDetails(){
        print("get called")
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52989")!
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
            guard let jsonw = json!["meals"] as? [[String:String]] else {return}
            print(jsonw.first!["strIngredient9"]!)
            let mealData = jsonw.first!
            var i = 1
            var arrayI : [String] = []
            var arrayM : [String] = []
            while jsonw.first!["strIngredient\(i)"] != nil {
                arrayI.append(jsonw.first!["strIngredient\(i)"]!)
                i += 1
            }
            var mI = 1
            while jsonw.first!["strMeasure\(mI)"] != nil {
                arrayM.append(jsonw.first!["strMeasure"]!)
                mI += 1
            }
            mealDetail.append(mealDetails(strInstructions: jsonw.first!["strInstructions"]!, strMeal: jsonw.first!["strMeal"]!, strMealThumb: jsonw.first!["strMealThumb"]!, strIngredient: arrayI, strMeasure1: arrayM))
            
    }
        task.resume()
        
       
    }
}

struct foodDetail_Previews: PreviewProvider {
    static var previews: some View {
        foodDetail()
    }
}
