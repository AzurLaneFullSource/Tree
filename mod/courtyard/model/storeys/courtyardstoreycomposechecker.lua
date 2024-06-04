local var0 = class("CourtYardStoreyComposeChecker")

function var0.Ctor(arg0, arg1)
	arg0.storey = arg1
	arg0.config = pg.furniture_compose_template
	arg0.list = {}
end

function var0.Check(arg0)
	for iter0, iter1 in ipairs(arg0.config.all) do
		if arg0:IsMatch(arg0.config[iter1].furniture_ids) then
			arg0:Add(iter1)
		else
			arg0:Remove(iter1)
		end
	end
end

function var0.Add(arg0, arg1)
	if not table.contains(arg0.list, arg1) then
		table.insert(arg0.list, arg1)
		arg0.storey:DispatchEvent(CourtYardEvent.ON_ADD_EFFECT, arg0.config[arg1].effect_name)
	end
end

function var0.Remove(arg0, arg1)
	if table.contains(arg0.list, arg1) then
		table.removebyvalue(arg0.list, arg1)
		arg0.storey:DispatchEvent(CourtYardEvent.ON_REMOVE_EFFECT, arg0.config[arg1].effect_name)
	end
end

function var0.IsMatch(arg0, arg1)
	local function var0(arg0)
		return arg0.storey.furnitures[arg0] ~= nil or arg0.storey.wallPaper and arg0.storey.wallPaper.configId == arg0 or arg0.storey.floorPaper and arg0.storey.floorPaper.configId == arg0
	end

	return _.all(arg1, var0)
end

function var0.Dispose(arg0)
	arg0.config = nil
	arg0.list = nil
	arg0.storey = nil
end

return var0
