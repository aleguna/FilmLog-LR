local lu = require ('luaunit')

function testEmpty()
    lu.assertTrue(true)
end

os.exit( lu.LuaUnit.run() )