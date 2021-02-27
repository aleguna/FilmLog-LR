local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrColor = import 'LrColor'
local LrApplication = import 'LrApplication'
local LrPathUtils = import 'LrPathUtils'
local LrSystemInfo = import 'LrSystemInfo'
local LrHttp = import 'LrHttp'
local LrBinding = import 'LrBinding'

require 'Use'

local FilmShotsMetadata = use 'leaf500.FilmShotsMetadata'
local FilmRoll = use 'leaf500.FilmRoll'
local FilmFramesImportDialog = use 'leaf500.FilmFramesImportDialog'
local UpdateChecker = use 'leaf500.UpdateChecker'
local MetadataBindingTable = use 'leaf500.MetadataBindingTable'

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

    local jsonPath = LrPathUtils.addExtension (LrPathUtils.child (folder:getPath(), folder:getName()), "json")
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
end

LrFunctionContext.postAsyncTaskWithContext ("showFilmShotsImportDialog", function (context)
    main (context)
end)