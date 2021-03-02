local LrFolderMock = {
}

function LrFolderMock:type()
    return 'LrFolder'
end

function LrFolderMock:getPath ()
    return self.path
end

function LrFolderMock:getName ()
    return self.name
end

function LrFolderMock:getPhotos (recursive)
    return self.photos
end

function LrFolderMock:make (name, path, photos) 
    local folder = {}
    setmetatable (folder, self)
    self.__index = self

    folder.path = path
    folder.photos = photos
    folder.name = name
    
    return folder
end

return {
    make = function (name, path, photos)
        return LrFolderMock:make (name, path, photos)
    end
}