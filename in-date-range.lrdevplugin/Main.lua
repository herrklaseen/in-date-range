local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrDate = import 'LrDate'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'

require 'Dialogs'
-- local DateSplitter = require('src.DateSplitter')

local logger = LrLogger('InDateRange')
logger:enable('print')

local catalog = LrApplication.activeCatalog()

local function getDateRange(input)

  return LrFunctionContext.callWithContext( "showCustomDialog", function( context, input )
    local path = _PLUGIN.path
    local debugInfo = {
      message = path
    }

    local props = LrBinding.makePropertyTable( context )
    props.photos = input.photos
    props.startDate = input.startDate
    props.endDate = input.endDate

    local debugUI = Dialogs.debug(context, debugInfo)

    LrDialogs.presentModalDialog {
      title = "Debug",
      contents = debugUI,
    }

    local c = Dialogs.selectDate(context, input)

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

local function setCreatedDate(photos, startDate, endDate)
  local props = {}
  local fileNames = ''

  for i,photo in ipairs(photos) do
    local result = photo:getFormattedMetadata('fileName')
  end

  return LrFunctionContext.callWithContext( "setCreatedDate", function(context, input)
    local ui = Dialogs.debug(context, input)
    local result = LrDialogs.presentModalDialog {
      title = "Set created date",
      contents = ui,
    }
  end, fileNames)
end

local function main()
  local defaultDate = LrDate.currentTime();

  local input = {
    startDate = LrDate.timeToUserFormat(defaultDate, "%Y%m%d"),
    endDate = LrDate.timeToUserFormat(defaultDate, "%Y%m%d"),
    photos = catalog:getTargetPhotos()
  }

  local result = getDateRange(input)

  logger:trace('selected start date: ' .. result.startDate)
  setCreatedDate(catalog:getTargetPhotos(), result.startDate, result.endDate)
end

LrTasks.startAsyncTask(main)
