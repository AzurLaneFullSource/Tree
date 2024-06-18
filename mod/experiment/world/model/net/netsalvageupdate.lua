local var0_0 = class("NetSalvageUpdate", import("....BaseEntity"))

var0_0.Fields = {
	id = "number",
	list = "table",
	mapId = "number",
	step = "number"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.id = arg1_1.group_id
	arg0_1.step = arg1_1.cmd_collection.progress
	arg0_1.list = underscore.rest(arg1_1.cmd_collection.progress_list, 1)
	arg0_1.mapId = arg1_1.cmd_collection.random_id
end

function var0_0.Dispose(arg0_2)
	arg0_2:Clear()
end

return var0_0
