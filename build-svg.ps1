#$key = $env:WEATHER_API_KEY
#$locationKey = "273891";

$emojis = @{
    0  = "☀️"   # Clear sky
    1  = "🌤️"   # Mainly clear
    2  = "⛅"   # Partly cloudy
    3  = "☁️"   # Overcast
    45 = "🌫️"   # Fog
    48 = "🌁"   # Depositing rime fog
    51 = "🌦️"   # Drizzle: light
    53 = "🌦️"   # Drizzle: moderate
    55 = "🌧️"   # Drizzle: dense intensity
    56 = "🌧️❄️" # Freezing drizzle: light
    57 = "🌧️❄️" # Freezing drizzle: dense
    61 = "🌦️"   # Rain: slight
    63 = "🌧️"   # Rain: moderate
    65 = "🌧️🌧️" # Rain: heavy
    66 = "🌧️❄️" # Freezing rain: light
    67 = "🌧️❄️" # Freezing rain: heavy
    71 = "🌨️"   # Snow fall: slight
    73 = "🌨️"   # Snow fall: moderate
    75 = "❄️"   # Snow fall: heavy
    77 = "🌨️"   # Snow grains
    80 = "🌦️"   # Rain showers: slight
    81 = "🌧️"   # Rain showers: moderate
    82 = "🌧️🌩️" # Rain showers: violent
    85 = "🌨️"   # Snow showers: slight
    86 = "❄️"   # Snow showers: heavy
    95 = "⛈️"   # Thunderstorm: slight or moderate
    96 = "⛈️❄️" # Thunderstorm with slight hail
    99 = "⛈️🌨️" # Thunderstorm with heavy hail
}

#$url = "http://dataservice.accuweather.com/forecasts/v1/daily/1day/$($locationKey)?apikey=$($key)"
$url = "https://api.open-meteo.com/v1/forecast?latitude=39.7436&longitude=-8.8071&hourly=temperature_2m,weather_code&timezone=GMT&forecast_days=1&temperature_unit=fahrenheit"
$r = Invoke-RestMethod $url

#$target = $r.DailyForecasts[0]
#$degF = $r.Temperature.Maximum.Value
$degF = $r.hourly.temperature_2m[12]
$degC = [math]::Round((($degF - 32) / 1.8))
#$icon = $emojis[[int]$target.Day.Icon]
$icon = $emojis[[int]$r.hourly.weather_code[12]]
$psTime = (get-date).year - (get-date "7/1/2008").year 
$todayDay = (get-date).DayOfWeek

$data = Get-Content -Raw ./template.svg

$data = $data.replace("{degF}", $degF)
$data = $data.replace("{degC}", $degC)
$data = $data.replace("{weatherEmoji}", $icon)
$data = $data.replace("{psTime}", $psTime)
$data = $data.replace("{todayDay}", $todayDay)

$data | Set-Content -Encoding utf8 ./chat.svg
