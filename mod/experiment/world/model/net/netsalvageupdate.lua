local var0 = class("NetSalvageUpdate", import("....BaseEntity"))

var0.Fields = {
	id = "number",
	list = "table",
	mapId = "number",
	step = "number"
}

function var0.Setup(arg0, arg1)
	arg0.id = arg1.group_id
	arg0.step = arg1.cmd_collection.progress
	arg0.list = underscore.rest(arg1.cmd_collection.progress_list, 1)
	arg0.mapId = arg1.cmd_collection.random_id
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
