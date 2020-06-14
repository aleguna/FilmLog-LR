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

        for i, photo in ipairs (selection) do
            table.insert (content_array, f:row {
                fill_horizontal  = 1,
                f:static_text {
					alignment = "right",
					width = LrView.share "label_width",
					title = "File Name"
				},
                f:static_text {
					title = photo:getFormattedMetadata ('fileName')
				},
            })
        end

        local content = f:scrolled_view {
            f:column (content_array)
        }
    
        LrDialogs.presentModalDialog {
            title = "Custom Dialog Observer",
            contents = content
        }

    end)
end

showFilmShotsImportDialog ()