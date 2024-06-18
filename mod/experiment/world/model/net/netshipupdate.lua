local var0_0 = class("NetShipUpdate", import("....BaseEntity"))

var0_0.Fields = {
	id = "number",
	hpRant = "number"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.hpRant = arg1_1.hp_rant
end

return var0_0
