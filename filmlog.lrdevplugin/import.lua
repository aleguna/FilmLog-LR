local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrColor = import 'LrColor'
local LrApplication = import 'LrApplication'
local LrPathUtils = import 'LrPathUtils'
local LrSystemInfo = import 'LrSystemInfo'
local LrHttp = import 'LrHttp'
local LrBinding = import 'LrBinding'

local FilmShotsMetadata = require 'FilmShotsMetadata'
local FilmRoll = require 'FilmRoll'
local FilmFramesImportDialog = require 'FilmFramesImportDialog'
local UpdateChecker = require 'UpdateChecker'
local MetadataBindingTable = require 'MetadataBindingTable'

print = function (...)
end

local function getCurrentFolder (catalog) 
    local sources = catalog:getActiveSources()
    for _, s in ipairs (sources) do
        if s:type() == 'LrFolder' then
            return s
        end
    end
    return nil
end

local function showFilmShotsImportDialog (roll, bindings, updateInfo)    
    local f = LrView.osFactory()
    local width, height = LrSystemInfo.appWindowSize()

    local content = FilmFramesImportDialog.build {
        LrView = LrView,
        LrHttp = LrHttp,
        LrColor = LrColor,

        size = {width = width, height=height},
        updateInfo = updateInfo,
        
        roll = roll,
        bindings = bindings
    }

    return LrDialogs.presentModalDialog {
        title = "Import Film Shots Data",
        contents = content,
        resizable = false
    }
end

local function main (context)
    local catalog = LrApplication.activeCatalog ()
    local updateInfo = UpdateChecker.check (LrHttp, nil)

    local folder = getCurrentFolder (catalog)
    if folder == nil then 
        LrDialogs.message ("Please select a folder first")
        return
    end

    
--    local logFile = io.open (LrPathUtils.child (folder:getPath(), "import.log"), "w")
    --print = function (...)
        --logFile:write (string.format (...).."\n")
--    end

    local jsonPath = LrPathUtils.child (folder:getPath(), folder:getName()..".json")    
    local roll = FilmRoll.fromFile (jsonPath)
    if roll == nil then
        LrDialogs.message ("Couldn't load Film Shots JSON file\n"  .. jsonPath)
        return
    end

    local bindings = MetadataBindingTable.make (context, LrBinding, folder)    
    local result = showFilmShotsImportDialog (roll, bindings, updateInfo)
    if result == "ok" then
        catalog:withPrivateWriteAccessDo (function (context)            
            MetadataBindingTable.apply (roll, bindings)
        end)
    end

    --logFile:close ()

end

LrFunctionContext.postAsyncTaskWithContext ("showFilmShotsImportDialog", function (context)
    main (context)
end)