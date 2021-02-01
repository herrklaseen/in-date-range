--[[----------------------------------------------------------------------------
Info.lua
A plug in to set creation date on multiple images at once.

------------------------------------------------------------------------------]]

return {
  LrSdkVersion = 3.0,
  LrSdkMinimumVersion = 1.3, -- minimum SDK version required by this plug-in

  LrToolkitIdentifier = 'se.klsn.lightroom.in-date-range',

  LrPluginName = LOC "$$$/InDateRange/PluginName=InDateRange",

  -- Add the menu item to the Library menu.

  LrLibraryMenuItems = {
    {
      title = LOC "$$$/HelloWorld/CustomDialog=Set created date in range",
      file = "Main.lua",
    },
  },
  VERSION = { major=0, minor=1, revision=0, build=0, },
}

