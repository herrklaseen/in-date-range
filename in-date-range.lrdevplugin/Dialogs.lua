local LrView = import 'LrView'
local LrBinding = import 'LrBinding'

local f = LrView.osFactory()

local spacer16 = f:spacer {
  height = 16
}

Dialogs = {}

function Dialogs.selectDate(props) 
  local c = f:column {

    -- Bind the table to the view.  This enables controls to be bound
    -- to the named field of the 'props' table.

    bind_to_object = props,

    f:row {
      f:static_text {
        title = "This plug-in will set the “created at” date for the currently selected images to a date within the specified range. Please note, there is no undo. If you are unsure, please make a backup of your images before using this plug-in.",
        height_in_lines = -1,
        width_in_chars = 32
      }
    },

    spacer16,

    f:row {
      f:static_text {
        title = "Number of currently selected photos: " .. #props.photos,
        height_in_lines = -1,
        width_in_chars = 32
      }
    },

    spacer16,

    f:row {
      f:column {
        f:static_text {
          title = "Start date"
        },
        f:edit_field {
          value = LrView.bind( "startDate" )
        }
      },

      f:column {
        f:static_text {
          title = "End date"
        },
        f:edit_field {
          value = LrView.bind( "endDate" )
        }
      }
    },

    f:row {
      f:column {
        f:static_text {
          title = "Start hour (0–23)"
        },
        f:edit_field {
          value = LrView.bind( "startHour" )
        }
      },

      f:column {
        f:static_text {
          title = "End hour (0–23)"
        },
        f:edit_field {
          value = LrView.bind( "endHour" )
        }
      }
    }
  }

  return c
end


function Dialogs.debug(context, input) 
  local props = LrBinding.makePropertyTable( context )
  props.message = input.message

  local c = f:column {
    -- Bind the table to the view.  This enables controls to be bound
    -- to the named field of the 'props' table.

    bind_to_object = props,

    f:row {
      f:static_text {
        title = props.message,
        height_in_lines = -1,
        width_in_chars = 32
      }
    },

    spacer16,
  }

  return c
end
