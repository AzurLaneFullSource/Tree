local var0_0 = class("CourtYardStoreyComposeChecker")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.storey = arg1_1
	arg0_1.config = pg.furniture_compose_template
	arg0_1.list = {}
end

function var0_0.Check(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.config.all) do
		if arg0_2:IsMatch(arg0_2.config[iter1_2].furniture_ids) then
			arg0_2:Add(iter1_2)
		else
			arg0_2:Remove(iter1_2)
		end
	end
end

function var0_0.Add(arg0_3, arg1_3)
	if not table.contains(arg0_3.list, arg1_3) then
		table.insert(arg0_3.list, arg1_3)
		arg0_3.storey:DispatchEvent(CourtYardEvent.ON_ADD_EFFECT, arg0_3.config[arg1_3].effect_name)
	end
end

function var0_0.Remove(arg0_4, arg1_4)
	if table.contains(arg0_4.list, arg1_4) then
		table.removebyvalue(arg0_4.list, arg1_4)
		arg0_4.storey:DispatchEvent(CourtYardEvent.ON_REMOVE_EFFECT, arg0_4.config[arg1_4].effect_name)
	end
end

function var0_0.IsMatch(arg0_5, arg1_5)
	local function var0_5(arg0_6)
		return arg0_5.storey.furnitures[arg0_6] ~= nil or arg0_5.storey.wallPaper and arg0_5.storey.wallPaper.configId == arg0_6 or arg0_5.storey.floorPaper and arg0_5.storey.floorPaper.configId == arg0_6
	end

	return _.all(arg1_5, var0_5)
end

function var0_0.Dispose(arg0_7)
	arg0_7.config = nil
	arg0_7.list = nil
	arg0_7.storey = nil
end

return var0_0
