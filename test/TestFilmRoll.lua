local lu = require 'luaunit'
local FilmRoll = require 'leaf500.FilmRoll'


function testEmpty()
    lu.assertTrue(true)
end

function testBasic ()
    local roll = FilmRoll.fromJson ([[
        [
            {
                "name": "Roll Name",
                "frames": [
                    {
                        "frameIndex": 1,
                        "locality": "Frame1"
                    },
                    {
                        "frameIndex": 2,
                        "locality": "Frame2"
                    }
                ]
            }
        ]
    ]])

    lu.assertEquals (roll.name, "Roll Name")

    lu.assertEquals (roll.frameCount, 2)

    lu.assertEquals (roll.frames[1].frameIndex, 1)
    lu.assertEquals (roll.frames[1].locality, "Frame1")

    lu.assertEquals (roll.frames[2].frameIndex, 2)
    lu.assertEquals (roll.frames[2].locality, "Frame2")
end

function testMissingFrames ()
    local roll = FilmRoll.fromJson ([[
        [
            {
                "name": "Roll Name",
                "frames": [
                    {
                        "frameIndex": 1,
                        "locality": "Frame1"
                    },
                    {
                        "frameIndex": 3,
                        "locality": "Frame2"
                    }
                ]
            }
        ]
    ]])

    lu.assertEquals (roll.name, "Roll Name")

    lu.assertEquals (roll.frameCount, 3)

    lu.assertEquals (roll.frames[1].frameIndex, 1)
    lu.assertEquals (roll.frames[1].locality, "Frame1")

    lu.assertEquals (roll.frames[2], nil)

    lu.assertEquals (roll.frames[3].frameIndex, 3)
    lu.assertEquals (roll.frames[3].locality, "Frame2")
end

function testReadFile ()
    local roll = FilmRoll.fromFile ("test/data/test-1.json")
    lu.assertEquals (roll.frameCount, 4)  
end

os.exit( lu.LuaUnit.run() )