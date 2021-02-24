
local function newer (v1, v2)
    if v2.major > v1.major then
        return true
    end

    if v2.major == v1.major and v2.minor > v1.minor then
        return true
    end

    if v2.major == v1.major and v2.minor == v1.minor and v2.revision > v1.revision then
        return true
    end

    return false
end

return {
    newer = newer
}