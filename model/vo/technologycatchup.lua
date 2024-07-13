local var0_0 = class("TechnologyCatchup", import(".BaseVO"))

var0_0.STATE_UNSELECT = 1
var0_0.STATE_CATCHUPING = 2
var0_0.STATE_FINISHED_ALL = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.version
	arg0_1.configId = arg0_1.id
	arg0_1.ssrNum = arg1_1.number or 0
	arg0_1.urNums = arg1_1.dr_numbers or {}

	arg0_1:bulidTargetNums()

	arg0_1.state = var0_0.STATE_UNSELECT

	arg0_1:updateState()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.technology_catchup_template
end

function var0_0.isUr(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3:getConfig("ur_char")) do
		if arg1_3 == iter1_3 then
			return true
		end
	end

	return false
end

function var0_0.bulidTargetNums(arg0_4)
	arg0_4.targetNums = {}

	for iter0_4, iter1_4 in ipairs(arg0_4:getConfig("char_choice")) do
		if arg0_4:isUr(iter1_4) then
			for iter2_4, iter3_4 in pairs(arg0_4.urNums) do
				if iter3_4.id == iter1_4 then
					arg0_4.targetNums[iter1_4] = iter3_4.number or 0
				end
			end
		else
			arg0_4.targetNums[iter1_4] = arg0_4.ssrNum
		end

		if not arg0_4.targetNums[iter1_4] then
			arg0_4.targetNums[iter1_4] = 0
		end
	end
end

function var0_0.getTargetNum(arg0_5, arg1_5)
	return arg0_5.targetNums[arg1_5]
end

function var0_0.addTargetNum(arg0_6, arg1_6, arg2_6)
	if arg0_6:isUr(arg1_6) then
		arg0_6.targetNums[arg1_6] = arg0_6.targetNums[arg1_6] + arg2_6
	else
		for iter0_6, iter1_6 in ipairs(arg0_6:getConfig("char_choice")) do
			if not arg0_6:isUr(iter1_6) then
				arg0_6.targetNums[iter1_6] = arg0_6.targetNums[iter1_6] + arg2_6
			end
		end
	end

	arg0_6:updateState()
end

function var0_0.isFinish(arg0_7, arg1_7)
	if arg0_7:isUr(arg1_7) then
		return arg0_7.targetNums[arg1_7] >= arg0_7:getConfig("obtain_max_per_ur")
	else
		return arg0_7.targetNums[arg1_7] >= arg0_7:getConfig("obtain_max")
	end
end

function var0_0.isFinishSSR(arg0_8)
	local var0_8 = true

	for iter0_8, iter1_8 in ipairs(arg0_8:getConfig("char_choice")) do
		if not arg0_8:isUr(iter1_8) and not arg0_8:isFinish(iter1_8) then
			var0_8 = false
		end
	end

	return var0_8
end

function var0_0.isFinishAll(arg0_9)
	local var0_9 = true

	for iter0_9, iter1_9 in ipairs(arg0_9:getConfig("char_choice")) do
		if not arg0_9:isFinish(iter1_9) then
			var0_9 = false
		end
	end

	return var0_9
end

function var0_0.updateState(arg0_10)
	local var0_10 = getProxy(TechnologyProxy).curCatchupGroupID

	if arg0_10:isFinishAll() then
		arg0_10.state = var0_0.STATE_FINISHED_ALL
	elseif arg0_10.targetNums[var0_10] then
		arg0_10.state = var0_0.STATE_CATCHUPING
	else
		arg0_10.state = var0_0.STATE_UNSELECT
	end
end

function var0_0.getState(arg0_11)
	return arg0_11.state
end

return var0_0
