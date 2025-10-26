// ignore_for_file: must_be_immutable

part of '../home_view.dart';

class _HourlyWeather extends StatelessWidget {
  _HourlyWeather({required this.weatherViewModel}) {
    if (weatherViewModel.hourlyWeatherState.weatherModel != null) {
      int nowIndex = weatherViewModel.hourlyWeatherState.weatherModel!.hourly!.time!.indexWhere((element) => element.hour == DateTime.now().hour);
      hours = weatherViewModel.hourlyWeatherState.weatherModel!.hourly!.time!.sublist(nowIndex);
      wmos = weatherViewModel.hourlyWeatherState.weatherModel!.hourly!.weatherCode!.sublist(nowIndex);
    }
  }

  final WeatherViewModel weatherViewModel;
  late List<DateTime> hours;
  late List<int> wmos;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConstant.primaryColor,
      margin: EdgeInsets.all(SizeHelper.defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeHelper.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherText(
              text: LocalizationKeys.homeHourlyWeather.localKey.tr(context: context),
              size: 20,
              weatherTextWeight: WeatherTextWeight.bold,
              color: ColorConstant.primaryTextColor,
            ),
            if (weatherViewModel.hourlyWeatherState.weatherFetchStatus == WeatherFetchStatus.loading || weatherViewModel.hourlyWeatherState.weatherModel == null) ...{
              const WeatherLoadingIndicator(),
            } else ...{
              SizedBox(
                height: SizeHelper.blockSizeVertical * 20,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: SizeHelper.mediumPadding),
                    itemBuilder: (context, index) {
                      return WeatherCard(
                        child: Column(
                          children: [
                            const EmptyBox(height: 8),
                            WeatherText(text: index == 0 ? LocalizationKeys.homeNow.localKey.tr(context: context) : hours[index].formatTime(), size: 12),
                            Flexible(
                              child: Image.asset(
                                weatherViewModel.getWeatherIconFromWMO(
                                  weatherViewModel.hourlyWeatherState.getWMOCurrent(),
                                ),
                                height: SizeHelper.blockSizeHorizontal * 15,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const EmptyBox(height: 8),
                            Consumer<SettingsViewModel>(
                              builder: (context, settingsViewModel, _) =>
                                  WeatherText(text: weatherViewModel.hourlyWeatherState.getHourlyTemp(unit: settingsViewModel.temperatureUnit)[index], size: 12),
                            ),
                            const EmptyBox(height: 8),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const EmptyBox(width: 16),
                    itemCount: hours.length),
              ),
            }
          ],
        ),
      ),
    );
  }
}
