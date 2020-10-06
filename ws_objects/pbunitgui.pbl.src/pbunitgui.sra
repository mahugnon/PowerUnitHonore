$PBExportHeader$pbunitgui.sra
$PBExportComments$Generated Application Object
forward
global type pbunitgui from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type pbunitgui from application
string appname = "pbunitgui"
end type
global pbunitgui pbunitgui

on pbunitgui.create
appname = "pbunitgui"
message = create message
sqlca = create transaction
sqlda = create dynamicdescriptionarea
sqlsa = create dynamicstagingarea
error = create error
end on

on pbunitgui.destroy
destroy( sqlca )
destroy( sqlda )
destroy( sqlsa )
destroy( error )
destroy( message )
end on

