part of '../home_view.dart';

class _DailyWeather extends StatelessWidget {
  const _DailyWeather({required this.weatherViewModel});

  final WeatherViewModel weatherViewModel;

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
              text: LocalizationKeys.homeDailyWeather.localKey.tr(context: context),
              size: 20,
              weatherTextWeight: WeatherTextWeight.bold,
              color: ColorConstant.primaryTextColor,
            ),
            if (weatherViewModel.dailyWeatherState.weatherFetchStatus == WeatherFetchStatus.loading || weatherViewModel.dailyWeatherState.weatherModel == null) ...{
              const WeatherLoadingIndicator(),
            } else ...{
              SizedBox(
                height: SizeHelper.blockSizeVertical * 20,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: SizeHelper.mediumPadding),
                    itemBuilder: (context, index) {
                      final days = weatherViewModel.dailyWeatherState.weatherModel!.daily!.time!;
                      final wmos = weatherViewModel.dailyWeatherState.weatherModel!.daily!.weatherCode!;

                      return WeatherCard(
                        child: Column(
                          children: [
                            const EmptyBox(height: 8),
                            WeatherText(text: days[index].weekdayName(todayTextInclude: true)?.localKey.tr(context: context) ?? "", size: 12),
                            Image.asset(
                              weatherViewModel.getWeatherIconFromWMO(
                                weatherViewModel.dailyWeatherState.getWMOCurrent(),
                              ),
                              height: SizeHelper.blockSizeHorizontal * 15,
                              fit: BoxFit.cover,
                            ),
                            const EmptyBox(height: 8),
                            WeatherText(text: weatherViewModel.getWMOLocalKeys(WMOWeather.getWMOFromCode(wmos[index])).localKey.tr(context: context), size: 12),
                            const EmptyBox(height: 8),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => EmptyBox(width: SizeHelper.defaultPadding),
                    itemCount: weatherViewModel.dailyWeatherState.weatherModel!.daily!.time!.length),
              ),
            }
          ],
        ),
      ),
    );
  }
}
