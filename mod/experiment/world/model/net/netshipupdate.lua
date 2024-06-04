local var0 = class("NetShipUpdate", import("....BaseEntity"))

var0.Fields = {
	id = "number",
	hpRant = "number"
}

function var0.Setup(arg0, arg1)
	arg0.id = arg1.id
	arg0.hpRant = arg1.hp_rant
end

return var0
