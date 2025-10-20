#$key = $env:WEATHER_API_KEY
#$locationKey = "273891";

$emojis = @{
    1  = "☀️"
    2  = "☀️"
    3  = "🌤"
    4  = "🌤"
    5  = "🌤"
    6  = "🌥"
    7  = "☁️"
    8  = "☁️"
    11 = "🌫"
    12 = "🌧"
    13 = "🌦"
    14 = "🌦"
    15 = "⛈"
    16 = "⛈"
    17 = "🌦"
    18 = "🌧"
    19 = "🌨"
    20 = "🌨"
    21 = "🌨"
    22 = "❄️"
    23 = "❄️"
    24 = "🌧"
    25 = "🌧"
    26 = "🌧"
    29 = "🌧"
    30 = "🌫"
    31 = "🥵"
    32 = "🥶"
}

#$url = "http://dataservice.accuweather.com/forecasts/v1/daily/1day/$($locationKey)?apikey=$($key)"
$url = "https://api.open-meteo.com/v1/forecast?latitude=39.7436&longitude=-8.8071&hourly=temperature_2m&timezone=GMT&forecast_days=1&temperature_unit=fahrenheit"
$r = Invoke-RestMethod $url

#$target = $r.DailyForecasts[0]
$degF = $r.Temperature.Maximum.Value
$degC = [math]::Round((($degF - 32) / 1.8))
#$icon = $emojis[[int]$target.Day.Icon]
$icon = ""
$psTime = (get-date).year - (get-date "7/1/2008").year 
$todayDay = (get-date).DayOfWeek

$data = Get-Content -Raw ./template.svg

$data = $data.replace("{degF}", $degF)
$data = $data.replace("{degC}", $degC)
$data = $data.replace("{weatherEmoji}", $icon)
$data = $data.replace("{psTime}", $psTime)
$data = $data.replace("{todayDay}", $todayDay)

$data | Set-Content -Encoding utf8 ./chat.svg
