local var0 = class("NetFleetAttachUpdate", import("....BaseEntity"))

var0.Fields = {
	row = "number",
	column = "number",
	id = "number"
}

function var0.Setup(arg0, arg1)
	arg0.id = arg1.item_id
	arg0.row = arg1.pos.row
	arg0.column = arg1.pos.column
end

return var0
