DateUtil = {}
local FULL_DAY_SECONDS = 60 * 60 * 24

function DateUtil.daysInInterval(startDate, endDate)
    if not startDate or not endDate then
        error 'StartDate or endDate missing'
    end

    local intervalInSeconds = endDate - startDate
    local daysInInterval = intervalInSeconds / FULL_DAY_SECONDS

    return math.floor(daysInInterval) 
end

function DateUtil.makeStartOfDay(date)
    return DateUtil.setTimeOfDay(date, 0, 0, 0)
end

function DateUtil.makeEndOfDay(date)
    return DateUtil.setTimeOfDay(date, 23, 59, 59)
end

function DateUtil.setTimeOfDay(date, hour, minute, second)
    local dateAsTable = os.date('*t', date)
    local dateAtTime = os.time({
        year=dateAsTable.year,
        month=dateAsTable.month,
        day=dateAsTable.day,
        hour=hour,
        min=minute,
        sec=second
    })

    return dateAtTime
end

return DateUtil
