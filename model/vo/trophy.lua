local var0_0 = class("Trophy", import(".BaseVO"))

var0_0.INTAMACT_TYPE = 1043
var0_0.COMPLEX_TROPHY_TYPE = 160
var0_0.ALWAYS_SHOW = 0
var0_0.ALWAYS_HIDE = 1
var0_0.HIDE_BEFORE_UNLOCK = 2
var0_0.COMING_SOON = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.subTrophyList = {}

	arg0_1:update(arg1_1)
end

function var0_0.generateDummyTrophy(arg0_2)
	return (Trophy.New({
		progress = 0,
		timestamp = -1,
		id = arg0_2
	}))
end

function var0_0.bindConfigTable(arg0_3)
	return pg.medal_template
end

function var0_0.update(arg0_4, arg1_4)
	arg0_4.progress = arg1_4.progress
	arg0_4.timestamp = arg1_4.timestamp
	arg0_4.new = arg1_4.new
end

function var0_0.isNew(arg0_5)
	return arg0_5.isNew == true
end

function var0_0.clearNew(arg0_6)
	arg0_6.isNew = nil
end

function var0_0.updateTimeStamp(arg0_7, arg1_7)
	if arg1_7 > 0 then
		arg0_7.isNew = true
	end

	arg0_7.timestamp = arg1_7
end

function var0_0.isComplexTrophy(arg0_8)
	return arg0_8:getConfig("target_type") == arg0_8.COMPLEX_TROPHY_TYPE
end

function var0_0.bindTrophys(arg0_9, arg1_9)
	arg0_9.subTrophyList[arg1_9.id] = arg1_9
end

function var0_0.getSubTrophy(arg0_10)
	return arg0_10.subTrophyList
end

function var0_0.getTargetID(arg0_11)
	return arg0_11:getConfig("target_id")
end

function var0_0.canClaimed(arg0_12)
	return arg0_12:getProgressRate() >= 1
end

function var0_0.isClaimed(arg0_13)
	return arg0_13.timestamp > 0
end

function var0_0.isDummy(arg0_14)
	return arg0_14.timestamp == -1
end

function var0_0.getProgressRate(arg0_15)
	local var0_15, var1_15 = arg0_15:getProgress()

	return var0_15 / var1_15
end

function var0_0.getProgress(arg0_16)
	if arg0_16:isComplexTrophy() then
		local var0_16 = 0

		for iter0_16, iter1_16 in pairs(arg0_16.subTrophyList) do
			if iter1_16:isClaimed() then
				var0_16 = var0_16 + 1
			end
		end

		return var0_16, arg0_16:getConfig("target_num")
	else
		return arg0_16.progress, arg0_16:getConfig("target_num")
	end
end

function var0_0.getHideType(arg0_17)
	return arg0_17:getConfig("hide")
end

function var0_0.isHide(arg0_18)
	local var0_18 = arg0_18:getConfig("hide")

	if var0_18 == var0_0.ALWAYS_HIDE then
		return true
	elseif var0_18 == var0_0.HIDE_BEFORE_UNLOCK and arg0_18.timestamp <= 0 then
		return true
	else
		return false
	end
end

function var0_0.isMaxLevel(arg0_19)
	local var0_19 = arg0_19:getConfig("next")
	local var1_19 = arg0_19:bindConfigTable()

	return var0_19 == 0 or var1_19[var0_19] == nil
end

function var0_0.getTargetType(arg0_20)
	return arg0_20:getConfig("target_type")
end

return var0_0
