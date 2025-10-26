import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String estimatedCost = '0.00', outputMessage = '';
  String fuelType =
      'RON95(subsidized)'; // RON95(subsidized) as default for dropdown button
  bool isError = false;

  TextEditingController distanceController = TextEditingController();
  TextEditingController efficiencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_gas_station,
                  size: 30,
                  color: Colors.redAccent,
                ),
                SizedBox(width: 10),
                Text(
                  'Trip Fuel Cost Estimator',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 100, child: Text('Distance \n(km):')),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: distanceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Distance',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 100, child: Text('Fuel Efficiency \n(km/L):')),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: efficiencyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Fuel Efficiency',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 100, child: Text('Fuel Type:')),
                Container(
                  width: 250,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_downward),
                    underline: SizedBox(),
                    value: fuelType,
                    items:
                        <String>[
                          'RON95(subsidized)',
                          'RON95',
                          'RON97',
                          'Diesel',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        fuelType = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 100, child: Text('Fuel Price \n(RM/L):')),
                SizedBox(
                  width: 250,
                  child: Text(
                    'RM $fuelPrice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: calculateCost,
                  style: ElevatedButton.styleFrom(elevation: 2),
                  child: Text('Calculate Cost'),
                ),
                ElevatedButton(
                  onPressed: clearInputs,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    elevation: 2,
                  ),
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                border: Border.all(
                  color: isError ? Colors.redAccent : Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                outputMessage,
                style: TextStyle(
                  fontSize: 20,
                  color: isError ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // getter to assign fuel price
  double get fuelPrice {
    switch (fuelType) {
      case 'RON95(subsidized)':
        return 1.99;
      case 'RON95':
        return 2.05;
      case 'RON97':
        return 3.14;
      case 'Diesel':
        return 2.89;
      default:
        return 1.99;
    }
  }

  void clearInputs() {
    distanceController.clear();
    efficiencyController.clear();
    fuelType = 'RON95(subsidized)';
    outputMessage = '';
    setState(() {});
  }

  // method to calculate estimated fuel cost
  void calculateCost() {
    estimatedCost = '0.00';
    isError = false;
    double distance = double.tryParse(distanceController.text) ?? 0.0;
    double efficiency = double.tryParse(efficiencyController.text) ?? 0.0;

    if (distance < 0 || efficiency < 0) {
      outputMessage = 'Error: Distance and Fuel Efficiency cannot be negative.';
      isError = true;
    } else if (efficiency == 0) {
      outputMessage = 'Error: Fuel Efficiency cannot be zero.';
      isError = true;
    } else if (distance == 0) {
      outputMessage =
          'Trip distance is zero. \n\nEstimated Fuel Cost: \nRM $estimatedCost';
    } else {
      double calculatedCost = (distance / efficiency) * fuelPrice;
      estimatedCost = calculatedCost.toStringAsFixed(
        2,
      ); // Round to 2 decimal places
      outputMessage = 'Estimated Fuel Cost: \nRM $estimatedCost';
    }

    setState(() {});
  }
}
