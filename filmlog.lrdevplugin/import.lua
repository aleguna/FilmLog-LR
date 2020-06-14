local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'

function showFilmShotsImportDialog () 
    LrFunctionContext.postAsyncTaskWithContext ("showFilmShotsImportDialog", function (context)
        local f = LrView.osFactory()

        local catalog = LrApplication.activeCatalog ()
        local selection = catalog:getMultipleSelectedOrAllPhotos ()

        local content_array = {
            spacing = f:dialog_spacing()
        }

        for i, pic in ipairs (selection) do
            table.insert (content_array, f:row {
                fill_horizontal  = 1,
                f:catalog_photo {
                    photo = pic,
                    width = 64,
                    height = 64,
				},
                f:static_text {
                    fill_vertical = 1,
					title = pic:getFormattedMetadata ('fileName')
				},
            })
        end

        local content = f:scrolled_view {
            f:column (content_array)
        }
    
        LrDialogs.presentModalDialog {
            title = "Import Film Shots Data",
            contents = content,
            resizable = true
        }

    end)
end

showFilmShotsImportDialog ()