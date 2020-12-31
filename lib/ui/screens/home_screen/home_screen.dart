import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_3/bloc/day_forecast_bloc/bloc.dart';
import 'package:lab_3/models/day_forecast.dart';
import 'package:lab_3/ui/resources/colors.dart';
import 'package:lab_3/ui/screens/city_search_screen/city_search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation _snowyOpacityAnimation;
  Animation _snowyFallBigOneAnimation;
  Animation _snowyFallBigTwoAnimation;
  Animation _snowyFallBigThreeAnimation;
  Animation _snowyFallSmallOneAnimation;
  Animation _snowyFallSmallTwoAnimation;
  Animation _snowyFallSmallThreeAnimation;

  AnimationController _sunnyRotatingAnimation;
  AnimationController _sunnySizeAnimation;

  AnimationController controller;
  Animation _cloudyWindAnimation;
  CurveTween _scaleCurve;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
    );

    _sunnyRotatingAnimation = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _sunnySizeAnimation = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _sunnySizeAnimation.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _sunnySizeAnimation.forward();
        }
      })
      ..forward();

    _cloudyWindAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    _snowyOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    _snowyFallBigOneAnimation = Tween<double>(begin: 18.0, end: 66.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    _snowyFallBigTwoAnimation = Tween<double>(begin: 25.0, end: 85.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    _snowyFallBigThreeAnimation = Tween<double>(begin: 0.0, end: 55.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

    _snowyFallSmallOneAnimation = Tween<double>(begin: 6.0, end: 22.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    _snowyFallSmallTwoAnimation = Tween<double>(begin: 10.0, end: 27.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    _snowyFallSmallThreeAnimation = Tween<double>(begin: 0.0, end: 18.0).animate(CurvedAnimation(parent: controller, curve: Curves.linear));



    _scaleCurve = CurveTween(curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.repeat();

    context.read<DayForecastBloc>().add(GetWeekForecast(49.842957, 24.031111, "Lviv"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _colors(),
            _body(),
          ],
        ),
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _body() {
    return BlocBuilder<DayForecastBloc, DayForecastState>(
      builder: (context, state) {
        if (state is WeekForecastLoaded) {
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: _todayForecast(state.weekForecast[0]),
              ),
              Expanded(
                flex: 3,
                child: _weekForecast(context, state.weekForecast),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _colors() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: AppColor.primaryBlue,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: AppColor.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _todayForecast(DayForecast dayForecast) {
    return Padding(
      padding: const EdgeInsets.all(55),
      child: FittedBox(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${dayForecast.city}, ${dayForecast.dayName}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 46,
                    color: Colors.white,
                  ),
                ),
                Text(
                  dayForecast.date,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 38,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "${dayForecast.temperature}°С",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 85,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(width: 70),
            _createWeatherIcon(dayForecast, 140),
          ],
        ),
      ),
    );
  }

  Widget _weekForecast(BuildContext context, List<DayForecast> weekForecast) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        childAspectRatio: 0.35,
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                weekForecast[index].dayName.substring(0, 3),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryBlue,
                ),
              ),
              SizedBox(height: 50),
              _cardWeather(weekForecast[index]),
              SizedBox(height: 20),
              Spacer(),
            ],
          ),
        );
      },
    );
  }

  Widget _cardWeather(DayForecast dayForecast) {
    return Column(
      children: [
        _createWeatherIcon(dayForecast, 45),
        SizedBox(height: 20),
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                  color: AppColor.lightGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "${dayForecast.temperature}°С",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _createWeatherIcon(DayForecast dayForecast, double size) {
    final temp = dayForecast.temperature;
    if (temp > 10) {
      return _createSunny(size);
    } else if (temp > 0 && temp <= 10) {
      return _createCloudy(size);
    } else {
      return _createSnowy(size);
    }
  }

  Widget _createSunny(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * 1.5,
          height: size * 1.4,
        ),
        ScaleTransition(
          scale: _sunnySizeAnimation.drive(_scaleCurve),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: size * 1.3,
              height: size * 1.3,
              decoration: BoxDecoration(
                color: Colors.yellowAccent.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: RotationTransition(
            turns: _sunnyRotatingAnimation,
            child: Icon(
              Icons.wb_sunny,
              color: Colors.amber,
              size: size,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createCloudy(double size) {
    return Stack(
      children: [
        Container(
          width: size * 1.5,
          height: size * 1.4,
        ),
        Positioned(
          top: 10,
          left: 10 - _cloudyWindAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: size * 0.45,
                height: size * 0.1,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: size * 0.07),
              Container(
                width: size * 0.65,
                height: size * 0.1,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: size * 0.07),
              Container(
                width: size * 0.40,
                height: size * 0.1,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: _cloudyWindAnimation.value + 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: size,
                height: size,
                child: Icon(
                  Icons.cloud,
                  color: Colors.indigo,
                  size: size,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createSnowy(double size) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size * 1.4,
        ),
        Positioned(
          top: size * 0.6 + (size > 80 ? _snowyFallBigThreeAnimation.value : _snowyFallSmallThreeAnimation.value),
          left: size * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: size / 4,
                width: size / 4,
                child: Opacity(
                  opacity: _snowyOpacityAnimation.value,
                  child: Icon(
                    Icons.ac_unit,
                    color: Colors.blue,
                    size: size / 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: size * 0.6 + (size > 80 ? _snowyFallBigTwoAnimation.value : _snowyFallSmallTwoAnimation.value),
          left: size * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: size / 4,
                width: size / 4,
                child: Opacity(
                  opacity: _snowyOpacityAnimation.value,
                  child: Icon(
                    Icons.ac_unit,
                    color: Colors.blue,
                    size: size / 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: size * 0.6 + (size > 80 ? _snowyFallBigOneAnimation.value : _snowyFallSmallOneAnimation.value),
          left: size * 0.05,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: size / 4,
                width: size / 4,
                child: Opacity(
                  opacity: _snowyOpacityAnimation.value,
                  child: Icon(
                    Icons.ac_unit,
                    color: Colors.blue,
                    size: size / 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Icon(
            Icons.cloud,
            color: Color.fromRGBO(86, 114, 214, 1),
            size: size,
          ),
        ),
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CitySearchScreen(),
          ),
        );
      },
      backgroundColor: AppColor.primaryBlue,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.wb_cloudy_rounded,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Icon(
              Icons.add,
              color: AppColor.lightBlue,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}



