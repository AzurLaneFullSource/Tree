local var0_0 = class("SculptureActivity", import("model.vo.Activity"))

var0_0.STATE_NIL = 0
var0_0.STATE_UNLOCK = 1
var0_0.STATE_DRAW = 2
var0_0.STATE_JOINT = 3
var0_0.STATE_FINSIH = 4

function var0_0.UpdateState(arg0_1, arg1_1, arg2_1)
	if not arg0_1.data1KeyValueList[1] then
		arg0_1.data1KeyValueList[1] = {}
	end

	arg0_1.data1KeyValueList[1][arg1_1] = arg2_1
end

function var0_0.GetSculptureState(arg0_2, arg1_2)
	return (arg0_2.data1KeyValueList[1] or {})[arg1_2] or var0_0.STATE_NIL
end

function var0_0.getDataConfigTable(arg0_3)
	return pg.activity_giftmake_template
end

function var0_0.getDataConfig(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4:getDataConfigTable()

	return var0_4[arg1_4] and var0_4[arg1_4][arg2_4]
end

function var0_0.GetComsume(arg0_5, arg1_5)
	return arg0_5:getDataConfig(arg1_5, "consume")[3]
end

function var0_0._GetComsume(arg0_6, arg1_6)
	local var0_6 = arg0_6:getDataConfig(arg1_6, "consume")

	return var0_6[2], var0_6[3]
end

function var0_0.GetResorceName(arg0_7, arg1_7)
	return arg0_7:getDataConfig(arg1_7, "resources")
end

function var0_0.GetScale(arg0_8, arg1_8)
	local var0_8 = arg0_8:getDataConfig(arg1_8, "scaling")

	return Vector3(var0_8[1], var0_8[2], 1)
end

function var0_0.CanEnterState(arg0_9, arg1_9, arg2_9)
	return arg0_9:GetSculptureState(arg1_9) + 1 == arg2_9
end

function var0_0.GetAwardProgress(arg0_10)
	local var0_10 = arg0_10:getConfig("config_data")
	local var1_10 = #var0_10
	local var2_10 = 0

	for iter0_10, iter1_10 in ipairs(var0_10) do
		if arg0_10:GetSculptureState(iter1_10) == var0_0.STATE_FINSIH then
			var2_10 = var2_10 + 1
		end
	end

	return var2_10, var1_10
end

function var0_0.GetAwards(arg0_11, arg1_11)
	return arg0_11:getDataConfig(arg1_11, "reward_display")
end

function var0_0.GetAwardDesc(arg0_12, arg1_12)
	return arg0_12:getDataConfig(arg1_12, "reward_describe") or ""
end

function var0_0.EnoughResToOpen(arg0_13, arg1_13, arg2_13)
	local var0_13, var1_13 = arg0_13:_GetComsume(arg1_13)

	return var1_13 < arg2_13:getVitemNumber(var0_13)
end

function var0_0.readyToAchieve(arg0_14)
	local var0_14 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if not var0_14 or var0_14:isEnd() then
		return false
	end

	local var1_14 = arg0_14:getConfig("config_data")

	for iter0_14, iter1_14 in ipairs(var1_14) do
		if arg0_14:GetSculptureState(iter1_14) == var0_0.STATE_NIL and arg0_14:EnoughResToOpen(iter1_14, var0_14) then
			return true
		end
	end

	return false
end

return var0_0
