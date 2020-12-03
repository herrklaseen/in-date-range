DateUtil = require('DateUtil')
Allotter = require('Allotter')

DateSplitter = {}
function DateSplitter:new(startDate, endDate)
    local ds = {}
    ds.startDate = startDate
    ds.endDate = endDate
    setmetatable(ds, self)
    self.__index = self
    return ds
end

function DateSplitter:split(parts)
  if parts < 1 then
    error 'Parts must be larger than zero'
  end

  local fullDays = DateUtil.daysInInterval(self.startDate, self.endDate)
  local slots = fullDays + 1
  local distribution = Allotter:allot(parts, slots)
  distribution = DateSplitter:shiftDistribution(distribution)

  local returnDates = {}

  local startDateAsTable = os.date('*t', self.startDate)

  local dateIndex = 1
  for slot,parts in ipairs(distribution) do
    local dateAtSlot = os.time({
      year=startDateAsTable.year,
      month=startDateAsTable.month,
      day=startDateAsTable.day + (slot - 1),
      hour=0,
      min=0,
      sec=0
    })
    local durationAtSlot = DateSplitter:getDurationAtDate(dateAtSlot)
    local durationInSeconds = DateSplitter:getDurationInSeconds(durationAtSlot[1], durationAtSlot[2])
    local divisor = 0

    -- Divide the duration with the number of parts at the current slot, 
    -- but remove one from the parts to eventually get dates that
    -- start and end roughly at the specified interval.
    if (parts == 1) then
      divisor = 1
    elseif (parts > 1) then
      divisor = parts - 1
    end
    local interval = durationInSeconds / divisor

    for i=1,parts do
      local aDate = os.time(
        os.date( '*t', math.floor( dateAtSlot + interval * (i - 1) ))
      )
      returnDates[dateIndex] = aDate
      dateIndex = dateIndex + 1
    end
  end

  return returnDates
end

-- If a distribution (table) has a zero value
-- in position one, this function shifts the values
-- in the table so that the first value is the first
-- non zero value and moves any preceding values to the
-- end of the table.
function DateSplitter:shiftDistribution(distribution)
  local firstPositive
  local shifted

  for slot,parts in ipairs(distribution) do
    if parts > 0 then
      firstPositive = slot
      break
    end
  end

  if firstPositive == 1 then
    return distribution
  end

  shifted = {}

  -- Cannot use table.unpack here as it
  -- is not supported equally across
  -- lua 5 versions
  local shiftIndex = 1
  for slot,parts in ipairs(distribution) do
    if slot >= firstPositive then
      shifted[shiftIndex] = parts
      shiftIndex = shiftIndex + 1
    end
  end

  for i=1,firstPositive-1 do
    table.insert(shifted, distribution[i])
  end

  return shifted
end

function DateSplitter:getDurationAtDate(date)
  local dateAsTable = os.date('*t', self.startDate)
  local duration = {}

  local intervalStart = os.time({
    year=dateAsTable.year,
    month=dateAsTable.month,
    day=dateAsTable.day,
    hour=0,
    min=0,
    sec=0
  })

  local intervalEnd = os.time({
    year=dateAsTable.year,
    month=dateAsTable.month,
    day=dateAsTable.day,
    hour=23,
    min=59,
    sec=59
  })

  duration[1] = intervalStart
  duration[2] = intervalEnd
  return duration
end

function DateSplitter:getDurationInSeconds(startDate, endDate)
  return endDate - startDate
end

return DateSplitter
