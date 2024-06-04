local var0 = class("TechnologyCatchup", import(".BaseVO"))

var0.STATE_UNSELECT = 1
var0.STATE_CATCHUPING = 2
var0.STATE_FINISHED_ALL = 3

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.version
	arg0.configId = arg0.id
	arg0.ssrNum = arg1.number or 0
	arg0.urNums = arg1.dr_numbers or {}

	arg0:bulidTargetNums()

	arg0.state = var0.STATE_UNSELECT

	arg0:updateState()
end

function var0.bindConfigTable(arg0)
	return pg.technology_catchup_template
end

function var0.isUr(arg0, arg1)
	for iter0, iter1 in ipairs(arg0:getConfig("ur_char")) do
		if arg1 == iter1 then
			return true
		end
	end

	return false
end

function var0.bulidTargetNums(arg0)
	arg0.targetNums = {}

	for iter0, iter1 in ipairs(arg0:getConfig("char_choice")) do
		if arg0:isUr(iter1) then
			for iter2, iter3 in pairs(arg0.urNums) do
				if iter3.id == iter1 then
					arg0.targetNums[iter1] = iter3.number or 0
				end
			end
		else
			arg0.targetNums[iter1] = arg0.ssrNum
		end

		if not arg0.targetNums[iter1] then
			arg0.targetNums[iter1] = 0
		end
	end
end

function var0.getTargetNum(arg0, arg1)
	return arg0.targetNums[arg1]
end

function var0.addTargetNum(arg0, arg1, arg2)
	if arg0:isUr(arg1) then
		arg0.targetNums[arg1] = arg0.targetNums[arg1] + arg2
	else
		for iter0, iter1 in ipairs(arg0:getConfig("char_choice")) do
			if not arg0:isUr(iter1) then
				arg0.targetNums[iter1] = arg0.targetNums[iter1] + arg2
			end
		end
	end

	arg0:updateState()
end

function var0.isFinish(arg0, arg1)
	if arg0:isUr(arg1) then
		return arg0.targetNums[arg1] >= arg0:getConfig("obtain_max_per_ur")
	else
		return arg0.targetNums[arg1] >= arg0:getConfig("obtain_max")
	end
end

function var0.isFinishSSR(arg0)
	local var0 = true

	for iter0, iter1 in ipairs(arg0:getConfig("char_choice")) do
		if not arg0:isUr(iter1) and not arg0:isFinish(iter1) then
			var0 = false
		end
	end

	return var0
end

function var0.isFinishAll(arg0)
	local var0 = true

	for iter0, iter1 in ipairs(arg0:getConfig("char_choice")) do
		if not arg0:isFinish(iter1) then
			var0 = false
		end
	end

	return var0
end

function var0.updateState(arg0)
	local var0 = getProxy(TechnologyProxy).curCatchupGroupID

	if arg0:isFinishAll() then
		arg0.state = var0.STATE_FINISHED_ALL
	elseif arg0.targetNums[var0] then
		arg0.state = var0.STATE_CATCHUPING
	else
		arg0.state = var0.STATE_UNSELECT
	end
end

function var0.getState(arg0)
	return arg0.state
end

return var0
