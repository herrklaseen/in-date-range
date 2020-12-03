local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrDate = import 'LrDate'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'

require 'Dialogs'
local DateSplitter = require('DateSplitter')
DateUtil = require('DateUtil')

local logger = LrLogger('InDateRange')
logger:enable('print')

local catalog = LrApplication.activeCatalog()

local function createLuaDateFromString(dateString)
  local year, month, day
  year = tonumber(string.sub(dateString, 1, 4))
  month = tonumber(string.sub(dateString, 5, 6))
  day = tonumber(string.sub(dateString, 7))
  local date = os.time({
    year = year,
    month = month,
    day = day
  })

  return date
end

local function showDebugDialog(text)
  return LrFunctionContext.callWithContext( "setCreatedDate", function(context, input)
    local ui = Dialogs.debug(context, input)
    local result = LrDialogs.presentModalDialog {
      title = "Set created date",
      contents = ui,
    }

    return result
  end, { message = text } )
end

local function getDateRange(input)

  return LrFunctionContext.callWithContext( "showCustomDialog", function( context, input )
    local props = LrBinding.makePropertyTable( context )
    props.photos = input.photos
    props.startDate = input.startDate
    props.endDate = input.endDate

    local c = Dialogs.selectDate(props)

    local result = LrDialogs.presentModalDialog {
      title = "Set created date",
      contents = c,
    }

    if ( result == 'ok' ) then
      local out = {
        startDate = props.startDate,
        endDate = props.endDate
      }
      return out
    else
      return nil
    end
  end, input) -- end main function

end

local function setDatesOnPhotos(photos, dates) 
  local dateString
  for i,photo in ipairs(photos) do
    dateString = os.date('%FT%H:%M:%S', dates[i])
    photo:setRawMetadata('dateCreated', dateString)
  end
end

local function setCreatedDate(photos, startDate, endDate)
  local luaDateStart = createLuaDateFromString(startDate)
  local luaDateEnd = createLuaDateFromString(endDate) 

  local ds = DateSplitter:new(luaDateStart, luaDateEnd)
  local dates = ds:split(#photos)


  local fileNames = {}
  for i,photo in ipairs(photos) do
    fileNames[i] = photo:getFormattedMetadata('fileName')
  end

  local debug = 'Setting the following dates on files: \n\n'
  for i,file in ipairs(fileNames) do
    debug = debug .. file .. ': ' .. os.date('%FT%H:%M:%S', dates[i]) .. '\n'
  end

  debug = debug .. '\nPress OK to go ahead.'

  local result = showDebugDialog(debug)
  if result == 'ok' then
    setDatesOnPhotos(photos, dates)
  end
end


local function main()
  local defaultDate = LrDate.currentTime();

  local input = {
    startDate = LrDate.timeToUserFormat(defaultDate, "%Y%m%d"),
    endDate = LrDate.timeToUserFormat(defaultDate, "%Y%m%d"),
    photos = catalog:getTargetPhotos()
  }

  local result = getDateRange(input)

  if result == nil then 
    return 
  end

  catalog:withWriteAccessDo("Set dateCreated on multiple photos", function()
    setCreatedDate(catalog:getTargetPhotos(), result.startDate, result.endDate)
  end)
end

LrTasks.startAsyncTask(main)
