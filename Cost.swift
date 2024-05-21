//
//  ContentView.swift
//  Industrial_APP
//
//  Created by User on 2023/5/17.
//

import SwiftUI

struct Cost: View {
    @State private var directLabor = DirectLabor()
    @State private var rawMaterial = RawMaterial()
    @State private var totalCost = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Direct Labor")) {
                        LaborTextField(title: "Radial Cut", value: $directLabor.radialCut)
                        LaborTextField(title: "Planing", value: $directLabor.planing)
                        LaborTextField(title: "Treatment", value: $directLabor.treatment)
                        LaborTextField(title: "Four Sides Planing", value: $directLabor.fourSidesPlaning)
                        LaborTextField(title: "Carving Glue", value: $directLabor.carvingGlue)
                        LaborTextField(title: "Sanding", value: $directLabor.sanding)
                    }
                    
                    Section(header: Text("Raw Material")) {
                        MaterialTextField(title: "Bamboo", value: $rawMaterial.bamboo)
                        MaterialTextField(title: "Caustic Soda", value: $rawMaterial.causticSoda)
                        MaterialTextField(title: "Borax", value: $rawMaterial.borax)
                        MaterialTextField(title: "Boric Acid", value: $rawMaterial.boricAcid)
                        MaterialTextField(title: "Gas Consumption", value: $rawMaterial.gasConsumption)
                        MaterialTextField(title: "Hydrogen Peroxide", value: $rawMaterial.hydrogenPeroxide)
                        MaterialTextField(title: "Sodium Salt", value: $rawMaterial.sodiumSalt)
                        MaterialTextField(title: "QR 500", value: $rawMaterial.qr500)
                        MaterialTextField(title: "QR 1000", value: $rawMaterial.qr1000)
                        MaterialTextField(title: "Glue", value: $rawMaterial.glue)
                        MaterialTextField(title: "Oil", value: $rawMaterial.oil)
                        MaterialTextField(title: "Sandpaper 36", value: $rawMaterial.sandpaper36)
                        MaterialTextField(title: "Sandpaper 40", value: $rawMaterial.sandpaper40)
                    }
                }
                
                Button(action: calculateTotalCost) {
                    Text("Calculate Total Cost")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                Text("Total Cost: $\(totalCost, specifier: "%.2f")")
                    .padding()
            }
            .navigationBarTitle("Cost Calculator", displayMode: .inline)
        }
    }
    
    func calculateTotalCost() {
        let directLaborCost = calculateDirectLaborCost()
        let rawMaterialCost = calculateRawMaterialCost()
        totalCost = directLaborCost + rawMaterialCost
    }

    func calculateDirectLaborCost() -> Double {
        let radialCutCost = calculateCost(for: directLabor.radialCut, with: 26.98)
        let planingCost = calculateCost(for: directLabor.planing, with: 17.58)
        let treatmentCost = calculateCost(for: directLabor.treatment, with: 33.60)
        let fourSidesPlaningCost = calculateCost(for: directLabor.fourSidesPlaning, with: 23.17)
        let carvingGlueCost = calculateCost(for: directLabor.carvingGlue, with: 42.69)
        let sandingCost = calculateCost(for: directLabor.sanding, with: 0.0)
        return radialCutCost + planingCost + treatmentCost + fourSidesPlaningCost + carvingGlueCost + sandingCost
    }

    func calculateRawMaterialCost() -> Double {
        let bambooCost = calculateCost(for: rawMaterial.bamboo, with: 15.0)
        let causticSodaCost = calculateCost(for: rawMaterial.causticSoda, with: 16.0)
        let boraxCost = calculateCost(for: rawMaterial.borax, with: 24.0)
        let boricAcidCost = calculateCost(for: rawMaterial.boricAcid, with: 24.0)
        let gasConsumptionCost = calculateCost(for: rawMaterial.gasConsumption, with: 24.0)
        let hydrogenPeroxideCost = calculateCost(for: rawMaterial.hydrogenPeroxide, with: 100.0)
        let sodiumSaltCost = calculateCost(for: rawMaterial.sodiumSalt, with: 12.5)
        let qr500Cost = calculateCost(for: rawMaterial.qr500, with: 145.0)
        let qr1000Cost = calculateCost(for: rawMaterial.qr1000, with: 145.0)
        let glueCost = calculateCost(for: rawMaterial.glue, with: 35.8)
        let oilCost = calculateCost(for: rawMaterial.oil, with: 78.2)
        let sandpaper36Cost = calculateCost(for: rawMaterial.sandpaper36, with: 0.0)
        let sandpaper40Cost = calculateCost(for: rawMaterial.sandpaper40, with: 0.0)
        return bambooCost + causticSodaCost + boraxCost + boricAcidCost + gasConsumptionCost + hydrogenPeroxideCost + sodiumSaltCost + qr500Cost + qr1000Cost + glueCost + oilCost + sandpaper36Cost + sandpaper40Cost
    }

    func calculateCost(for value: String, with unitCost: Double) -> Double {
        let cost = Double(value) ?? 0
        return cost * unitCost
    }
}

struct LaborTextField: View {
    var title: String
    @Binding var value: String
    
    var body: some View {
        TextField(title, text: $value)
            .keyboardType(.decimalPad)
    }
}

struct MaterialTextField: View {
    var title: String
    @Binding var value: String
    
    var body: some View {
        TextField(title, text: $value)
            .keyboardType(.decimalPad)
    }
}

struct DirectLabor {
    var radialCut = ""
    var planing = ""
    var treatment = ""
    var fourSidesPlaning = ""
    var carvingGlue = ""
    var sanding = ""
}

struct RawMaterial {
    var bamboo = ""
    var causticSoda = ""
    var borax = ""
    var boricAcid = ""
    var gasConsumption = ""
    var hydrogenPeroxide = ""
    var sodiumSalt = ""
    var qr500 = ""
    var qr1000 = ""
    var glue = ""
    var oil = ""
    var sandpaper36 = ""
    var sandpaper40 = ""
}

struct Cost_Previews: PreviewProvider {
    static var previews: some View {
        Cost()
    }
}
