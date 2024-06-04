local var0 = class("ChapterTransportFleet", import(".ChapterFleet"))

function var0.Ctor(arg0, arg1, arg2)
	arg0.line = {
		row = arg1.pos.row,
		column = arg1.pos.column
	}
	arg0.id = arg2
	arg0.configId = arg1.item_id
	arg0.restHp = arg1.item_data
	arg0.rotation = Quaternion.identity

	arg0:updateShips({})
end

function var0.bindConfigTable(arg0)
	return pg.friendly_data_template
end

function var0.getFleetType(arg0)
	return FleetType.Transport
end

function var0.getPrefab(arg0)
	local var0 = {
		{
			20,
			16
		},
		{
			15,
			11
		},
		{
			10,
			1
		},
		{
			0,
			0
		}
	}
	local var1 = {
		"merchant",
		"merchant_1",
		"merchant_2",
		"merchant_d"
	}
	local var2 = var1[1]

	for iter0, iter1 in ipairs(var0) do
		if arg0:getRestHp() >= iter1[2] and arg0:getRestHp() <= iter1[1] then
			var2 = var1[iter0]

			break
		end
	end

	return var2
end

function var0.getRestHp(arg0)
	return arg0.restHp
end

function var0.setRestHp(arg0, arg1)
	arg0.restHp = arg1
end

function var0.getTotalHp(arg0)
	return arg0:getConfig("hp")
end

function var0.isValid(arg0)
	return arg0.restHp > 0
end

return var0
