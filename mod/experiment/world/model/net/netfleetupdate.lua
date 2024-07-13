local var0_0 = class("NetFleetUpdate", import("....BaseEntity"))

var0_0.Fields = {
	id = "number",
	buffs = "table"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.buffs = WorldConst.ParsingBuffs(arg1_1.buff_list)
end

function var0_0.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.GetBuffsByTrap(arg0_3, arg1_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in pairs(arg0_3.buffs) do
		if iter1_3:GetFloor() > 0 and iter1_3:GetTrapType() == arg1_3 then
			table.insert(var0_3, iter1_3)
		end
	end

	return var0_3
end

return var0_0
