local var0_0 = class("NetFleetAttachUpdate", import("....BaseEntity"))

var0_0.Fields = {
	row = "number",
	column = "number",
	id = "number"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.id = arg1_1.item_id
	arg0_1.row = arg1_1.pos.row
	arg0_1.column = arg1_1.pos.column
end

return var0_0
