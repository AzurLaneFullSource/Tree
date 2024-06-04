local var0 = class("Trophy", import(".BaseVO"))

var0.INTAMACT_TYPE = 1043
var0.COMPLEX_TROPHY_TYPE = 160
var0.ALWAYS_SHOW = 0
var0.ALWAYS_HIDE = 1
var0.HIDE_BEFORE_UNLOCK = 2
var0.COMING_SOON = 3

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.subTrophyList = {}

	arg0:update(arg1)
end

function var0.generateDummyTrophy(arg0)
	return (Trophy.New({
		progress = 0,
		timestamp = -1,
		id = arg0
	}))
end

function var0.bindConfigTable(arg0)
	return pg.medal_template
end

function var0.update(arg0, arg1)
	arg0.progress = arg1.progress
	arg0.timestamp = arg1.timestamp
	arg0.new = arg1.new
end

function var0.isNew(arg0)
	return arg0.isNew == true
end

function var0.clearNew(arg0)
	arg0.isNew = nil
end

function var0.updateTimeStamp(arg0, arg1)
	if arg1 > 0 then
		arg0.isNew = true
	end

	arg0.timestamp = arg1
end

function var0.isComplexTrophy(arg0)
	return arg0:getConfig("target_type") == arg0.COMPLEX_TROPHY_TYPE
end

function var0.bindTrophys(arg0, arg1)
	arg0.subTrophyList[arg1.id] = arg1
end

function var0.getSubTrophy(arg0)
	return arg0.subTrophyList
end

function var0.getTargetID(arg0)
	return arg0:getConfig("target_id")
end

function var0.canClaimed(arg0)
	return arg0:getProgressRate() >= 1
end

function var0.isClaimed(arg0)
	return arg0.timestamp > 0
end

function var0.isDummy(arg0)
	return arg0.timestamp == -1
end

function var0.getProgressRate(arg0)
	local var0, var1 = arg0:getProgress()

	return var0 / var1
end

function var0.getProgress(arg0)
	if arg0:isComplexTrophy() then
		local var0 = 0

		for iter0, iter1 in pairs(arg0.subTrophyList) do
			if iter1:isClaimed() then
				var0 = var0 + 1
			end
		end

		return var0, arg0:getConfig("target_num")
	else
		return arg0.progress, arg0:getConfig("target_num")
	end
end

function var0.getHideType(arg0)
	return arg0:getConfig("hide")
end

function var0.isHide(arg0)
	local var0 = arg0:getConfig("hide")

	if var0 == var0.ALWAYS_HIDE then
		return true
	elseif var0 == var0.HIDE_BEFORE_UNLOCK and arg0.timestamp <= 0 then
		return true
	else
		return false
	end
end

function var0.isMaxLevel(arg0)
	local var0 = arg0:getConfig("next")
	local var1 = arg0:bindConfigTable()

	return var0 == 0 or var1[var0] == nil
end

function var0.getTargetType(arg0)
	return arg0:getConfig("target_type")
end

return var0
