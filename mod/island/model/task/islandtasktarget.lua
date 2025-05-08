local var0_0 = class("IslandTaskTarget", import("model.vo.BaseVO"))

var0_0.INTERACTION = 1
var0_0.APPROACH = 2
var0_0.ORDER = 3
var0_0.RECYCLE = 4
var0_0.OBTAIN = 5
var0_0.GATHER = 6
var0_0.PRODUCTION = 7
var0_0.TECHNOLOGY = 8
var0_0.LEVEL = 9

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.target_id
	arg0_1.configId = arg0_1.id
	arg0_1.progress = arg1_1.target_count or 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_task_target
end

function var0_0.GetType(arg0_3)
	return arg0_3:getConfig("type")
end

function var0_0.GetTargetId(arg0_4)
	return arg0_4:getConfig("target_id")
end

function var0_0.GetTargetNum(arg0_5)
	return arg0_5:getConfig("target_num")
end

function var0_0.GetTrackParma(arg0_6)
	return arg0_6:getConfig("tips")
end

function var0_0.GetProgress(arg0_7)
	local var0_7 = arg0_7.progress
	local var1_7 = arg0_7:GetType()

	if var1_7 == var0_0.RECYCLE then
		var0_7 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(arg0_7:GetTargetId())
	elseif var1_7 == var0_0.LEVEL then
		var0_7 = getProxy(IslandProxy):GetIsland():GetLevel()
	end

	return var0_7
end

function var0_0.UpdateProgress(arg0_8, arg1_8)
	arg0_8.progress = arg1_8
end

function var0_0.IsFinish(arg0_9)
	return arg0_9:GetProgress() / arg0_9:GetTargetNum() >= 1
end

function var0_0.IsInteractionObject(arg0_10, arg1_10)
	return arg0_10:GetType() == var0_0.INTERACTION and arg0_10:GetTargetId() == arg1_10
end

function var0_0.IsApproachObject(arg0_11, arg1_11)
	return arg0_11:GetType() == var0_0.APPROACH and arg0_11:GetTargetId() == arg1_11
end

return var0_0
