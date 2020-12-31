import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab_3/bloc/day_forecast_bloc/bloc.dart';
import 'package:lab_3/core/utils/city_search.dart';
import 'package:lab_3/ui/resources/colors.dart';

class CitySearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: [
            _colors(),
            _body(context),
          ],
        ),
      ),
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

  Widget _body(BuildContext context) {
    return Column(
      children: [
        _searchBar(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        _decoration(context),
      ],
    );
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.cloud),
            fillColor: Colors.white,
            focusColor: Colors.white,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
        noItemsFoundBuilder: (context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text("No cities found"),
            ),
          );
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(
              Icons.cloud,
              color: AppColor.lightBlue,
            ),
            title: Text(suggestion["display_name"]),
          );
        },
        suggestionsCallback: (query) {
          if (query.length >= 1) {
            return getCities(query);
          } else {
           return [];
          }
        },
        onSuggestionSelected: (suggestion) {
          context.bloc<DayForecastBloc>().add(
                GetWeekForecast(
                  double.parse(suggestion["lat"]),
                  double.parse(suggestion["lon"]),
                  suggestion["display_name"].length > 10
                      ? "${suggestion["display_name"].substring(0, 8)}.."
                      : suggestion["display_name"],
                ),
              );

          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _decoration(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.5,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200),
        ),
        child: Column(
          children: [
            Image.network(
              "https://static.thenounproject.com/png/50457-200.png",
              scale: 0.5,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
