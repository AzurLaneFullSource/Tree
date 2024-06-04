local var0 = class("NetFleetUpdate", import("....BaseEntity"))

var0.Fields = {
	id = "number",
	buffs = "table"
}

function var0.Setup(arg0, arg1)
	arg0.id = arg1.id
	arg0.buffs = WorldConst.ParsingBuffs(arg1.buff_list)
end

function var0.Dispose(arg0)
	arg0:Clear()
end

function var0.GetBuffsByTrap(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.buffs) do
		if iter1:GetFloor() > 0 and iter1:GetTrapType() == arg1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

return var0
