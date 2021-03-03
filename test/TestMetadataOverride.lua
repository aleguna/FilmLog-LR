local lu = require "luaunit"

require 'Logger' ("TestMetadataOverride")

local MetadataOverride = require "leaf500.MetadataOverride"
local DefaultMetadataMap = use 'leaf500.DefaultMetadataMap'

function makeLrTasksMock ()
    local LrTasksMock = {
        commands = {}
    }

    LrTasksMock.execute = function (command)
        table.insert (LrTasksMock.commands, command)
        return 0
    end

    return LrTasksMock
end

function testNilArray ()
    local result = MetadataOverride.apply (nil)    
    lu.assertEquals (result, {-1})
end

function testEmptyArray ()
    local result = MetadataOverride.apply ({})
    lu.assertEquals (result, {-1})
end

function testBasic_1Photo_BadMapping ()
    local photo = {
        path = 'photo/1.arw'
    }
    
    local LrTasksMock = makeLrTasksMock ()
    local results = MetadataOverride.apply ({photo}, {}, LrTasksMock)
    lu.assertEquals (results, {-1})

    lu.assertEquals (LrTasksMock.commands, {})
end

function testBasic_1Photo_Bad ()
    local photo = {
        path = 'photo/1.arw'
    }
    
    local LrTasksMock = makeLrTasksMock ()
    local results = MetadataOverride.apply ({photo}, DefaultMetadataMap, LrTasksMock)
    
    lu.assertEquals (results, {-1})
    lu.assertEquals (LrTasksMock.commands, {})
    
end

function testBasic_1Photo ()
    local photo = {
        path = 'photo/1.arw',
        Roll_Name = "Roll 1",
        Frame_Locality = "Seaside",
        Frame_Comment = "Comment comment comment",
        Frame_EmulsionName = "Kodak Gold",
        Roll_CameraName = "Olympus XA",
        Frame_LocalTime = "2020-05-09T13:21:35",
        Frame_Latitude = "51.2322",
        Frame_LatitudeRef = "N",
        Frame_Longitude = "2.033",
        Frame_LongitudeRef = "E",
        Frame_BoxISO = "200",
        Frame_RatedISO = "200",
        Frame_LensName = "Zuyko 35mm F2.8",
        Frame_FocalLength = "35",
        Frame_FStop = "5.6",
        Frame_Shutter = "1/250"
    }
    
    local LrTasksMock = makeLrTasksMock ()
    local results = MetadataOverride.apply ({photo}, DefaultMetadataMap, LrTasksMock)
    lu.assertEquals (results, {0})

    lu.assertEquals (LrTasksMock.commands, 
                    {
                        'exiftool -Title="Roll 1" ' ..
                        '-Caption="Seaside" ' ..
                        '-UserComment="Comment comment comment" ' ..
                        '-Make="Kodak Gold" ' ..
                        '-Model="Olympus XA" ' ..
                        '-GPSLatitude="51.2322" ' ..
                        '-GPSLatitudeRef="N" ' .. 
                        '-GPSLongitude="2.033" ' .. 
                        '-GPSLongitudeRef="E" ' ..
                        '-ISO="200" ' ..
                        '-LensModel="Zuyko 35mm F2.8" ' ..
                        '-Lens="Zuyko 35mm F2.8" ' .. 
                        '-FocalLength="35" ' ..
                        '-FNumber="5.6" ' ..
                        '-ApertureValue="5.6" ' ..
                        '-ExposureTime="1/250" ' ..
                        '-ShutterSpeedValue="1/250" ' ..
                        '-overwrite_original "photo/1.arw"'
                    }
            )
end

function testBasic_3Photo ()
    local photos = {
        {
            path = 'photo/1.arw',
            Roll_Name = "Roll 1",
            Frame_Locality = "Seaside",
            Frame_Comment = "Comment comment comment",
            Frame_EmulsionName = "Kodak Gold",
            Roll_CameraName = "Olympus XA",
            Frame_LocalTime = "2020-05-09T13:21:35",
            Frame_Latitude = "51.2322",
            Frame_LatitudeRef = "N",
            Frame_Longitude = "2.033",
            Frame_LongitudeRef = "E",
            Frame_BoxISO = "200",
            Frame_RatedISO = "200",
            Frame_LensName = "Zuyko 35mm F2.8",
            Frame_FocalLength = "35",
            Frame_FStop = "5.6",
            Frame_Shutter = "1/250"
        },

        {
            path = 'photo/2.arw',
            Roll_Name = "Roll 1",
            Frame_Locality = "Seaside 2",
            Frame_Comment = "Comment comment comment 2",
            Frame_EmulsionName = "Kodak Gold",
            Roll_CameraName = "Olympus XA",
            Frame_LocalTime = "2020-05-10T12:00:00",
            Frame_Latitude = "52.23333",
            Frame_LatitudeRef = "N",
            Frame_Longitude = "1.44444",
            Frame_LongitudeRef = "E",
            Frame_BoxISO = "200",
            Frame_RatedISO = "200",
            Frame_LensName = "Zuyko 35mm F2.8",
            Frame_FocalLength = "35",
            Frame_FStop = "2.8",
            Frame_Shutter = "1/250"
        },

        {
            path = 'photo/3.arw',
            Roll_Name = "Roll 1",
            Frame_Locality = "Seaside 3",
            Frame_Comment = "Comment comment comment 3",
            Frame_EmulsionName = "Kodak Gold",
            Roll_CameraName = "Olympus XA",
            Frame_LocalTime = "2020-05-11T13:00:00",
            Frame_Latitude = "53.2222",
            Frame_LatitudeRef = "N",
            Frame_Longitude = "1.8888",
            Frame_LongitudeRef = "E",
            Frame_BoxISO = "200",
            Frame_RatedISO = "200",
            Frame_LensName = "Zuyko 35mm F2.8",
            Frame_FocalLength = "35",
            Frame_FStop = "5.6",
            Frame_Shutter = "1/50"
        }

    }
    
    local LrTasksMock = makeLrTasksMock ()
    local results = MetadataOverride.apply (photos, DefaultMetadataMap, LrTasksMock)
    lu.assertEquals (results, {0, 0, 0})

    lu.assertEquals (LrTasksMock.commands, {
                        'exiftool -Title="Roll 1" ' ..
                        '-Caption="Seaside" ' ..
                        '-UserComment="Comment comment comment" ' ..
                        '-Make="Kodak Gold" ' ..
                        '-Model="Olympus XA" ' ..
                        '-GPSLatitude="51.2322" ' ..
                        '-GPSLatitudeRef="N" ' .. 
                        '-GPSLongitude="2.033" ' .. 
                        '-GPSLongitudeRef="E" ' ..
                        '-ISO="200" ' ..
                        '-LensModel="Zuyko 35mm F2.8" ' ..
                        '-Lens="Zuyko 35mm F2.8" ' .. 
                        '-FocalLength="35" ' ..
                        '-FNumber="5.6" ' ..
                        '-ApertureValue="5.6" ' ..
                        '-ExposureTime="1/250" ' ..
                        '-ShutterSpeedValue="1/250" ' ..
                        '-overwrite_original "photo/1.arw"'
                    ,
                        'exiftool -Title="Roll 1" ' ..
                        '-Caption="Seaside 2" ' ..
                        '-UserComment="Comment comment comment 2" ' ..
                        '-Make="Kodak Gold" ' ..
                        '-Model="Olympus XA" ' ..
                        '-GPSLatitude="52.23333" ' ..
                        '-GPSLatitudeRef="N" ' .. 
                        '-GPSLongitude="1.44444" ' .. 
                        '-GPSLongitudeRef="E" ' ..
                        '-ISO="200" ' ..
                        '-LensModel="Zuyko 35mm F2.8" ' ..
                        '-Lens="Zuyko 35mm F2.8" ' .. 
                        '-FocalLength="35" ' ..
                        '-FNumber="2.8" ' ..
                        '-ApertureValue="2.8" ' ..
                        '-ExposureTime="1/250" ' ..
                        '-ShutterSpeedValue="1/250" ' ..
                        '-overwrite_original "photo/2.arw"'
                    ,
                        'exiftool -Title="Roll 1" ' ..
                        '-Caption="Seaside 3" ' ..
                        '-UserComment="Comment comment comment 3" ' ..
                        '-Make="Kodak Gold" ' ..
                        '-Model="Olympus XA" ' ..
                        '-GPSLatitude="53.2222" ' ..
                        '-GPSLatitudeRef="N" ' .. 
                        '-GPSLongitude="1.8888" ' .. 
                        '-GPSLongitudeRef="E" ' ..
                        '-ISO="200" ' ..
                        '-LensModel="Zuyko 35mm F2.8" ' ..
                        '-Lens="Zuyko 35mm F2.8" ' .. 
                        '-FocalLength="35" ' ..
                        '-FNumber="5.6" ' ..
                        '-ApertureValue="5.6" ' ..
                        '-ExposureTime="1/50" ' ..
                        '-ShutterSpeedValue="1/50" ' ..
                        '-overwrite_original "photo/3.arw"'
        
            })
end

os.exit(lu.LuaUnit.run())