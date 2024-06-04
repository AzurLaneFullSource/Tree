local var0 = class("SculptureActivity", import("model.vo.Activity"))

var0.STATE_NIL = 0
var0.STATE_UNLOCK = 1
var0.STATE_DRAW = 2
var0.STATE_JOINT = 3
var0.STATE_FINSIH = 4

function var0.UpdateState(arg0, arg1, arg2)
	if not arg0.data1KeyValueList[1] then
		arg0.data1KeyValueList[1] = {}
	end

	arg0.data1KeyValueList[1][arg1] = arg2
end

function var0.GetSculptureState(arg0, arg1)
	return (arg0.data1KeyValueList[1] or {})[arg1] or var0.STATE_NIL
end

function var0.getDataConfigTable(arg0)
	return pg.activity_giftmake_template
end

function var0.getDataConfig(arg0, arg1, arg2)
	local var0 = arg0:getDataConfigTable()

	return var0[arg1] and var0[arg1][arg2]
end

function var0.GetComsume(arg0, arg1)
	return arg0:getDataConfig(arg1, "consume")[3]
end

function var0._GetComsume(arg0, arg1)
	local var0 = arg0:getDataConfig(arg1, "consume")

	return var0[2], var0[3]
end

function var0.GetResorceName(arg0, arg1)
	return arg0:getDataConfig(arg1, "resources")
end

function var0.GetScale(arg0, arg1)
	local var0 = arg0:getDataConfig(arg1, "scaling")

	return Vector3(var0[1], var0[2], 1)
end

function var0.CanEnterState(arg0, arg1, arg2)
	return arg0:GetSculptureState(arg1) + 1 == arg2
end

function var0.GetAwardProgress(arg0)
	local var0 = arg0:getConfig("config_data")
	local var1 = #var0
	local var2 = 0

	for iter0, iter1 in ipairs(var0) do
		if arg0:GetSculptureState(iter1) == var0.STATE_FINSIH then
			var2 = var2 + 1
		end
	end

	return var2, var1
end

function var0.GetAwards(arg0, arg1)
	return arg0:getDataConfig(arg1, "reward_display")
end

function var0.GetAwardDesc(arg0, arg1)
	return arg0:getDataConfig(arg1, "reward_describe") or ""
end

function var0.EnoughResToOpen(arg0, arg1, arg2)
	local var0, var1 = arg0:_GetComsume(arg1)

	return var1 < arg2:getVitemNumber(var0)
end

function var0.readyToAchieve(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if not var0 or var0:isEnd() then
		return false
	end

	local var1 = arg0:getConfig("config_data")

	for iter0, iter1 in ipairs(var1) do
		if arg0:GetSculptureState(iter1) == var0.STATE_NIL and arg0:EnoughResToOpen(iter1, var0) then
			return true
		end
	end

	return false
end

return var0
