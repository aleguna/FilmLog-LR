package.path = package.path .. ";./filmlog.lrdevplugin/?.lua"

local lu = require ('luaunit')
local exiftool = require 'ExiftoolInterface'
local FilmShotsMetadata = require 'FilmShotsMetadata'

function testEmpty()
    lu.assertTrue(true)
end

function testNegativeLongitude ()
    command = exiftool.buildCommand ('exiftool', '1.jpg', FilmShotsMetadata.make ({
        Frame_Latitude = 50.211,
        Frame_Longitude = -91.3333,
    }))

    lu.assertEquals (command, "exiftool")
end

os.exit( lu.LuaUnit.run() )