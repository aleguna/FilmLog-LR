local UpdateChecker = require 'UpdateChecker'

local lu = require 'luaunit'
local inspect = require 'inspect'

function LrHttpMock (info)
    return {
        get = function (url, headers, timeout)
            return "return " .. inspect (info)
        end
    }
end

function LrHttpMockRaw (string)
    return {
        get = function (url, headers, timeout)
            return string
        end
    }
end

function testEmpty()
    lu.assertTrue(true)
end

function testNoUpdate_SameVersion ()
    local info = {
        VERSION = {
            major = 1,
            minor = 0,
            revision = 1,
        }
    }

    local updateInfo = UpdateChecker.check (LrHttpMock (info), info)
    lu.assertNil (updateInfo)
end

function testNoUpdate_ReturnError ()
    local info = {
        VERSION = {
            major = 1,
            minor = 0,
            revision = 1,
        }
    }

    local updateInfo = UpdateChecker.check (LrHttpMockRaw ([[
<Error>
    <Code>AccessDenied</Code>
    <Message>Access denied.</Message>
    <Details>Anonymous caller does not have storage.objects.get access to the Google Cloud Storage object.</Details>
</Error>
    ]]), info)
    lu.assertNil (updateInfo)
end

function testNoUpdate_ReturnNull ()
    local info = {
        VERSION = {
            major = 1,
            minor = 0,
            revision = 1,
        }
    }

    local updateInfo = UpdateChecker.check (LrHttpMockRaw ("retrun {{major=1"), info)
    lu.assertNil (updateInfo)
end

function testNoUpdate_ReturnMalformed ()
    local updateInfo = UpdateChecker.check (LrHttpMockRaw (""), info)
    lu.assertNil (updateInfo)
end

--  shouldn't happen IRL
function testNoUpdate_OlderVersion ()
    local old = {
        VERSION = {
            major = 1,
            minor = 0,
            revision = 1,
        }
    }

    local new = {
        VERSION = {
            major = 1,
            minor = 3,
            revision = 1,
        }
    }

    local updateInfo = UpdateChecker.check (LrHttpMock (old), new)
    lu.assertNil (updateInfo)
end

function testUpdate_Available ()
    local old = {
        VERSION = {
            major = 1,
            minor = 0,
            revision = 1,
        }
    }

    local new = {
        VERSION = {
            major = 1,
            minor = 3,
            revision = 1,
        }
    }

    local updateInfo = UpdateChecker.check (LrHttpMock (new), old)
    lu.assertNotNil (updateInfo)
    lu.assertEquals (updateInfo.newVersion, "1.3.1")
end

os.exit( lu.LuaUnit.run() )
