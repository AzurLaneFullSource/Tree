local var0_0 = class("CommanderTalent", import("..BaseVO"))
local var1_0 = pg.commander_ability_group

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.groupId = arg0_1:getConfig("group_id")

	assert(var1_0[arg0_1.groupId])

	arg0_1.list = var1_0[arg0_1.groupId].ability_list
end

function var0_0.reset(arg0_2)
	arg0_2.id = arg0_2.list[1]
	arg0_2.configId = arg0_2.id
end

function var0_0.setOrigin(arg0_3, arg1_3)
	arg0_3.origin = arg1_3
end

function var0_0.isOrigin(arg0_4)
	return arg0_4.origin
end

function var0_0.getTalentList(arg0_5)
	return arg0_5.list
end

function var0_0.bindConfigTable(arg0_6)
	return pg.commander_ability_template
end

function var0_0.getConsume(arg0_7)
	local var0_7 = 0
	local var1_7 = table.indexof(arg0_7.list, arg0_7.id)

	if arg0_7.origin then
		var0_7 = var1_7 - table.indexof(arg0_7.list, arg0_7.origin.id)
	else
		var0_7 = var1_7
	end

	return var0_7
end

function var0_0.getAttrsAddition(arg0_8)
	local var0_8 = {}
	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(CommanderConst.PROPERTIES) do
		for iter2_8, iter3_8 in ipairs(arg0_8:getConfig("add")) do
			if CommanderConst.TALENT_ADDITION_NUMBER == iter3_8[1] then
				if iter3_8[4] == iter0_8 then
					var0_8[iter1_8] = {
						value = iter3_8[5],
						nation = iter3_8[2],
						shiptype = iter3_8[3]
					}
				end
			elseif CommanderConst.TALENT_ADDITION_RATIO == iter3_8[1] and iter3_8[4] == iter0_8 then
				var1_8[iter1_8] = {
					value = iter3_8[5],
					nation = iter3_8[2],
					shiptype = iter3_8[3]
				}
			end
		end
	end

	return var0_8, var1_8
end

function var0_0.getBuffsAddition(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9:getConfig("add")) do
		if CommanderConst.TALENT_ADDITION_BUFF == iter1_9[1] then
			table.insert(var0_9, iter1_9[4])
		end
	end

	return var0_9
end

function var0_0.getDestoryExpValue(arg0_10)
	local var0_10 = 0
	local var1_10 = arg0_10:getConfig("add")

	for iter0_10, iter1_10 in ipairs(var1_10) do
		if iter1_10[1] == CommanderConst.TALENT_ADDITION_NUMBER and iter1_10[4] == CommanderConst.DESTROY_ATTR_ID then
			var0_10 = var0_10 + iter1_10[5]
		end
	end

	return var0_10
end

function var0_0.getDestoryExpRetio(arg0_11)
	local var0_11 = 0
	local var1_11 = arg0_11:getConfig("add")

	for iter0_11, iter1_11 in ipairs(var1_11) do
		if iter1_11[1] == CommanderConst.TALENT_ADDITION_RATIO and iter1_11[4] == CommanderConst.DESTROY_ATTR_ID then
			var0_11 = var0_11 + iter1_11[5]
		end
	end

	return var0_11
end

function var0_0.getDesc(arg0_12)
	local var0_12 = {}
	local var1_12 = arg0_12:getConfig("add_desc")

	for iter0_12, iter1_12 in ipairs(var1_12) do
		local var2_12 = iter1_12[1]

		if var0_12[var2_12] then
			var0_12[var2_12].value = var0_12[var2_12].value + iter1_12[2]
		else
			var0_12[var2_12] = {
				value = iter1_12[2],
				type = iter1_12[3] and CommanderConst.TALENT_ADDITION_RATIO or CommanderConst.TALENT_ADDITION_NUMBER
			}
		end
	end

	return var0_12
end

return var0_0
