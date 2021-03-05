local LrApplication = import 'LrApplication'
local LrFunctionContext = import 'LrFunctionContext'
local LrSystemInfo = import 'LrSystemInfo'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrColor = import 'LrColor'
local LrTasks = import 'LrTasks'

local log = require 'Logger' ("override")

require 'Use'

local ExportDialogSection = use 'leaf500.ExportDialogSection'
local MetadataOverride = use 'leaf500.MetadataOverride'
local DefaultMetadataMap = use 'leaf500.DefaultMetadataMap'
local LightroomMetadata = use 'leaf500.LightroomMetadata'


local function showOverrideDialog (photos)  
    log ("showOverrideOverrideDialog")
    
    local f = LrView.osFactory()

    local width, height = LrSystemInfo.appWindowSize()
    log ("Window size ", width, "x", height)

    local name_list = ""
    for _, photo in ipairs (photos) do
        name_list = name_list .. ", " .. LightroomMetadata.make (photo):fileName ()
    end

    local content = f:column {
        spacing = f:dialog_spacing(),
        f:static_text {
            title = "ATTENTION! This operation is DESTRUCTIVE and cannot be undone.",
            text_color = LrColor ("red"),
            font = "<system/bold>",
        },            
        f:static_text {
            title = name_list,
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

    local catalog = LrApplication.activeCatalog ()
    local photos = catalog:getTargetPhotos ()

    local result = showOverrideDialog (photos)
    if result == 'ok' then
        MetadataOverride.apply (photos, DefaultMetadataMap, LrTasks)
    end
    log ("DONE")
end

LrFunctionContext.postAsyncTaskWithContext ("showOverrideDialog", function (context)
    main (context)
end)

