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

    lu.assertEquals (command, 'exiftool -GPSLatitude="50.211" -GPSLatitudeRef="N" -GPSLongitude="-91.3333" -GPSLongitudeRef="W" -overwrite_original "1.jpg"')
end

function testNegativeLatitude ()
    command = exiftool.buildCommand ('exiftool', '1.jpg', FilmShotsMetadata.make ({
        Frame_Latitude = -50.211,
        Frame_Longitude = 91.3333,
    }))

    lu.assertEquals (command, 'exiftool -GPSLatitude="-50.211" -GPSLatitudeRef="S" -GPSLongitude="91.3333" -GPSLongitudeRef="E" -overwrite_original "1.jpg"')
end

function testNegativeLatitudeLongitude ()
    command = exiftool.buildCommand ('exiftool', '1.jpg', FilmShotsMetadata.make ({
        Frame_Latitude = -50.211,
        Frame_Longitude = -91.3333,
    }))

    lu.assertEquals (command, 'exiftool -GPSLatitude="-50.211" -GPSLatitudeRef="S" -GPSLongitude="-91.3333" -GPSLongitudeRef="W" -overwrite_original "1.jpg"')
end

os.exit( lu.LuaUnit.run() )