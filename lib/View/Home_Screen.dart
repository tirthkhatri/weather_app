// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:weather_app/Provider/Theme_Provider.dart';
// import 'package:weather_app/Services/Api_Services.dart';
//
// class HomeScreen extends ConsumerStatefulWidget{
//   const HomeScreen({super.key});
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final _weatherServices = WeatherApiServices();
//   String city = "Ahmedabad";
//   String country = "";
//   Map<String, dynamic> currentValue = {};
//   List<dynamic> hourly = [];
//   List<dynamic> pastWeek = [];
//   List<dynamic> next7days = [];
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWeather();
//   }
//   Future<void> _fetchWeather() async{
//     setState(() {
//       isLoading = true;
//     });
//     try{
//       final forecast = await _weatherServices.getHourlyForecast(city);
//       final past = await _weatherServices.getPastSevenDaysWeather(city);
//
//       setState(() {
//         currentValue = forecast['current']??{};
//         hourly = forecast['forecast']?['forecastday']?[0]?['hour']??[];
//
//         next7days = forecast['forecast']?['forecastday']??[];
//         pastWeek = past;
//         city = forecast['location']?['name']??city;
//         country = forecast['location']?['country']??'';
//         isLoading = false;
//       });
//     }catch(e){
//       setState(() {
//         currentValue = {};
//         hourly = [];
//         pastWeek = [];
//         next7days = [];
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//        SnackBar(content: Text('City not found or invalid. Please enter a valid city name.'),)
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final themeMode = ref.watch(themeNotifierProvider);
//     final notifier = ref.read(themeNotifierProvider.notifier);
//     final isDark = themeMode == ThemeMode.dark;
//
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         actions: [
//           SizedBox(width: 20,),
//           SizedBox(width: 320, height: 50,
//               child: TextField(
//                 onSubmitted: (value){
//                   if(value.trim().isEmpty){
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Please enter a city name'),)
//                     );
//                     return;
//                   }
//                   city = value.trim();
//                   _fetchWeather();
//                 },
//             decoration: InputDecoration(
//               labelText: "Search City",
//               prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.surface),
//               labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                   borderSide: BorderSide(color: Theme.of(context).colorScheme.surface,
//               )
//               ),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: BorderSide(color: Theme.of(context).colorScheme.surface,
//                   )
//               ),
//             ),
//           )), Spacer(),
//           GestureDetector(
//             onTap: notifier.toggleTheme,
//             child: Icon(
//                 isDark? Icons.light_mode: Icons.dark_mode,
//               color: isDark? Colors.black: Colors.white, size: 30,
//             ),
//           ),
//           SizedBox(width: 15,),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 20,),
//           if(isLoading)
//             const Center(
//               child: CircularProgressIndicator(),
//             )
//           else...[
//             if(currentValue.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text("$city${country.isNotEmpty ? ',$country': ''}",maxLines: 1, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
//                     style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w400),),
//                   Text("${currentValue['temp_c']}°C", style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),),
//                   Text("${currentValue['condition']['text']}",  style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onPrimary),)
//                 ],
//               )
//           ]
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/Provider/Theme_Provider.dart';
import 'package:weather_app/Services/Api_Services.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _weatherServices = WeatherApiServices();
  String city = "Ahmedabad";
  String country = "";
  Map<String, dynamic> currentValue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7days = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      final current = await _weatherServices.getCurrentWeather(city);
      final forecast = await _weatherServices.getHourlyForecast(city);
      final past = await _weatherServices.getPastSevenDaysWeather(city);

      setState(() {
        currentValue = current['current'] ?? {};
        hourly = forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];
        next7days = forecast['forecast']?['forecastday'] ?? [];
        pastWeek = past;
        city = current['location']?['name'] ?? city;
        country = current['location']?['country'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        currentValue = {};
        hourly = [];
        pastWeek = [];
        next7days = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City not found or invalid. Please enter a valid city name.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final notifier = ref.read(themeNotifierProvider.notifier);
    final isDark = themeMode == ThemeMode.dark;

    String iconPath = currentValue['condition']?['icon']?? '';
    String imageUrl = iconPath.isNotEmpty? "https:$iconPath":"";
    Widget imageWidgets = imageUrl.isNotEmpty?Image.network(imageUrl, height: 200, width: 200, fit: BoxFit.cover,): SizedBox();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          SizedBox(width: 20),
          SizedBox(
            width: 320,
            height: 50,
            child: TextField(
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a city name')),
                  );
                  return;
                }
                city = value.trim();
                _fetchWeather();
              },
              decoration: InputDecoration(
                labelText: "Search City",
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.surface),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                ),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: notifier.toggleTheme,
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.black : Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (currentValue.isNotEmpty)
              Column(
                children: [
                  Text(
                    "$city${country.isNotEmpty ? ',$country' : ''}",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "${currentValue['temp_c']}°C",
                    style: TextStyle(
                      fontSize: 50,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${currentValue['condition']['text']}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  imageWidgets,
                  Padding(padding: EdgeInsets.all(15),
                  child: Container(
                    height: 100, width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network("https://cdn-icons-png.flaticon.com/512/4148/4148460.png", width: 30, height: 30,),
                            Text("${currentValue['humidity']}%", style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),),
                            Text("Humidity", style: TextStyle(color: Theme.of(context).colorScheme.secondary,),),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network("https://cdn-icons-png.flaticon.com/512/2321/2321487.png", width: 30, height: 30,),
                            Text("${currentValue['wind_kph']} kph ", style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),),
                            Text("Wind", style: TextStyle(color: Theme.of(context).colorScheme.secondary,),),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network("https://cdn-icons-png.flaticon.com/512/6281/6281340.png", width: 30, height: 30,),
                            Text("${hourly.isNotEmpty ? hourly.map((h)=> h['temp_c']).reduce((a,b)=>a>b?a:b): "N/A"}", style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),),
                            Text("Max Temp", style: TextStyle(color: Theme.of(context).colorScheme.secondary,),),
                          ],
                        )

                      ],
                    ),
                  ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    height: 250, width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Theme.of(context).colorScheme.secondary),
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(40),),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Today Forecast", style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),),
                              GestureDetector(
                                onTap: (){

                                },
                                child:  Text("Weekly Forecast", style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),),
                              )
                            ],
                          ),
                        ),
                        Divider(color: Theme.of(context).colorScheme.secondary,),
                        SizedBox(height: 20,),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                              itemCount: hourly.length,
                              itemBuilder: (context, index){
                              final hour= hourly[index];
                              final now = DateTime.now();
                              final hourTime = DateTime.parse(hour['time']);
                              final isCurrentHour = now.hour == hourTime.hour && now.day == hourTime.day;
                              return Padding(padding: EdgeInsets.all(8),
                              child: Container(
                                height: 70,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isCurrentHour? Colors.orangeAccent : Colors.black38,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Column(
                                  children: [
                                    
                                  ],
                                ),
                              ),
                              );
                              }
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            // const SizedBox(height: 30),

            // Add more widgets here to show hourly, next 7 days, or past weather if needed
          ],
        ),
      ),
    );
  }
}
