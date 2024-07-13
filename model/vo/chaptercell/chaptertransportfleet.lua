local var0_0 = class("ChapterTransportFleet", import(".ChapterFleet"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.line = {
		row = arg1_1.pos.row,
		column = arg1_1.pos.column
	}
	arg0_1.id = arg2_1
	arg0_1.configId = arg1_1.item_id
	arg0_1.restHp = arg1_1.item_data
	arg0_1.rotation = Quaternion.identity

	arg0_1:updateShips({})
end

function var0_0.bindConfigTable(arg0_2)
	return pg.friendly_data_template
end

function var0_0.getFleetType(arg0_3)
	return FleetType.Transport
end

function var0_0.getPrefab(arg0_4)
	local var0_4 = {
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
	local var1_4 = {
		"merchant",
		"merchant_1",
		"merchant_2",
		"merchant_d"
	}
	local var2_4 = var1_4[1]

	for iter0_4, iter1_4 in ipairs(var0_4) do
		if arg0_4:getRestHp() >= iter1_4[2] and arg0_4:getRestHp() <= iter1_4[1] then
			var2_4 = var1_4[iter0_4]

			break
		end
	end

	return var2_4
end

function var0_0.getRestHp(arg0_5)
	return arg0_5.restHp
end

function var0_0.setRestHp(arg0_6, arg1_6)
	arg0_6.restHp = arg1_6
end

function var0_0.getTotalHp(arg0_7)
	return arg0_7:getConfig("hp")
end

function var0_0.isValid(arg0_8)
	return arg0_8.restHp > 0
end

return var0_0
