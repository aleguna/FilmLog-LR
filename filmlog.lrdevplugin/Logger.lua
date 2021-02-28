_G.log = function (...)  --  by default does nothing
end

local function getLogSuffix ()
    local pu = import 'LrPathUtils'
    local configPath = pu.child (_PLUGIN.path, 'Config.txt')

    local config = {}
    local configChunk = loadfile (configPath)
    if configChunk then
        config = configChunk ()
    end
    return config.LogFile
end

local function writeLog (logPath, ...)    
    if logPath then
        local f = io.open (logPath, 'a')
        if f then
            f:write ('\n', ...)
            f:close ()
        end        
    end
end

local function getLogger (prefix)
    if _G.print and not _PLUGIN then
        if os and os.getenv and os.getenv ('ENABLE_LOGGING') then        
            return print
        end            
    elseif prefix and _PLUGIN and _PLUGIN.path then
        local suffix = getLogSuffix ()
        if suffix then
            local pu = import 'LrPathUtils'
            local fu = import 'LrFileUtils'        

            local logDir = pu.child (_PLUGIN.path, "log")
            if not fu.exists (logDir) then
                fu.createDirectory (logDir)
            end

            local logPath = pu.addExtension (pu.child (logDir, prefix.."_"..suffix), "txt")            
            return function (...) 
                writeLog (logPath, ...)
                --messageLog (...)
            end
        end        
    end

    return function (...) end
end

local function startLog (prefix)
    _G.log = getLogger (prefix)
    log ("================== BEGIN: ", prefix , " ==================")
end

return startLog
