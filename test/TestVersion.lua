local lu = require 'luaunit'
local Version = require 'leaf500.Version'

function testEmpty()
    lu.assertTrue(true)
end

function testMajorGreater ()
    lu.assertTrue (Version.newer (
        { major=0, minor=5, revision=0},
        { major=1, minor=0, revision=0}
    ))
end

function testMajorSame_MinorGreater ()
    lu.assertTrue (Version.newer (
        { major=1, minor=5, revision=0},
        { major=1, minor=6, revision=0}
    ))
end

function testMajorSame_MinorSame_RevGreater ()
    lu.assertTrue (Version.newer (
        { major=1, minor=5, revision=1},
        { major=1, minor=5, revision=2}
    ))
end

os.exit( lu.LuaUnit.run() )