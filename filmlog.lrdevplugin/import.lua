local LrDialogs = import 'LrDialogs'

MyHWExportItem = {}
function MyHWExportItem.showModalDialog()
    LrDialogs.message( "ExportMenuItem Selected", "Hello World!", "info" )
end

MyHWExportItem.showModalDialog()