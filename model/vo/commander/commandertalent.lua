local var0 = class("CommanderTalent", import("..BaseVO"))
local var1 = pg.commander_ability_group

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.groupId = arg0:getConfig("group_id")

	assert(var1[arg0.groupId])

	arg0.list = var1[arg0.groupId].ability_list
end

function var0.reset(arg0)
	arg0.id = arg0.list[1]
	arg0.configId = arg0.id
end

function var0.setOrigin(arg0, arg1)
	arg0.origin = arg1
end

function var0.isOrigin(arg0)
	return arg0.origin
end

function var0.getTalentList(arg0)
	return arg0.list
end

function var0.bindConfigTable(arg0)
	return pg.commander_ability_template
end

function var0.getConsume(arg0)
	local var0 = 0
	local var1 = table.indexof(arg0.list, arg0.id)

	if arg0.origin then
		var0 = var1 - table.indexof(arg0.list, arg0.origin.id)
	else
		var0 = var1
	end

	return var0
end

function var0.getAttrsAddition(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(CommanderConst.PROPERTIES) do
		for iter2, iter3 in ipairs(arg0:getConfig("add")) do
			if CommanderConst.TALENT_ADDITION_NUMBER == iter3[1] then
				if iter3[4] == iter0 then
					var0[iter1] = {
						value = iter3[5],
						nation = iter3[2],
						shiptype = iter3[3]
					}
				end
			elseif CommanderConst.TALENT_ADDITION_RATIO == iter3[1] and iter3[4] == iter0 then
				var1[iter1] = {
					value = iter3[5],
					nation = iter3[2],
					shiptype = iter3[3]
				}
			end
		end
	end

	return var0, var1
end

function var0.getBuffsAddition(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:getConfig("add")) do
		if CommanderConst.TALENT_ADDITION_BUFF == iter1[1] then
			table.insert(var0, iter1[4])
		end
	end

	return var0
end

function var0.getDestoryExpValue(arg0)
	local var0 = 0
	local var1 = arg0:getConfig("add")

	for iter0, iter1 in ipairs(var1) do
		if iter1[1] == CommanderConst.TALENT_ADDITION_NUMBER and iter1[4] == CommanderConst.DESTROY_ATTR_ID then
			var0 = var0 + iter1[5]
		end
	end

	return var0
end

function var0.getDestoryExpRetio(arg0)
	local var0 = 0
	local var1 = arg0:getConfig("add")

	for iter0, iter1 in ipairs(var1) do
		if iter1[1] == CommanderConst.TALENT_ADDITION_RATIO and iter1[4] == CommanderConst.DESTROY_ATTR_ID then
			var0 = var0 + iter1[5]
		end
	end

	return var0
end

function var0.getDesc(arg0)
	local var0 = {}
	local var1 = arg0:getConfig("add_desc")

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1[1]

		if var0[var2] then
			var0[var2].value = var0[var2].value + iter1[2]
		else
			var0[var2] = {
				value = iter1[2],
				type = iter1[3] and CommanderConst.TALENT_ADDITION_RATIO or CommanderConst.TALENT_ADDITION_NUMBER
			}
		end
	end

	return var0
end

return var0
