local LrFunctionContext = import 'LrFunctionContext'
local LrSystemInfo = import 'LrSystemInfo'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrColor = import 'LrColor'

local log = require 'Logger' ("override")

require 'Use'

local ExportDialogSection = use 'leaf500.ExportDialogSection'

local function showOverrideDialog ()  
    log ("showOverrideOverrideDialog")
    
    local f = LrView.osFactory()

    local width, height = LrSystemInfo.appWindowSize()
    log ("Window size ", width, "x", height)

    local content = f:column {
        spacing = f:dialog_spacing(),
        f:static_text {
            title = "ATTENTION! This operation is DESTRUCTIVE and cannot be undone.",
            text_color = LrColor ("red"),
            font = "<system/bold>",
        },            
        ExportDialogSection.build (f, {})
    }
    log ("Content: ", content)

    return LrDialogs.presentModalDialog {
        title = "Override Lightroom metadata",
        contents = content,
        resizable = false
    }
end

local function main (context)
    log ("main")

    local result = showOverrideDialog ()
    log ("DONE")
end

LrFunctionContext.postAsyncTaskWithContext ("showOverrideDialog", function (context)
    main (context)
end)

