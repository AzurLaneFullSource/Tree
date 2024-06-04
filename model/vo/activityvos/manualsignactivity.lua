local var0 = class("ManualSignActivity", import("model.vo.Activity"))

var0.OP_SIGN = 1
var0.OP_GET_AWARD = 2
var0.STATE_EMPTY = 0
var0.STATE_CAN_GET = 1
var0.STATE_GOT = 2

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.dataConfig = pg.activity_event_sign[arg0.id]
end

function var0.GetSignedList(arg0)
	return arg0.data1_list
end

function var0.GetIndexByToday(arg0)
	return arg0:getDayIndex()
end

function var0.GetTotalDayCnt(arg0)
	return #arg0:GetDropList()
end

function var0.GetDropList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.dataConfig.drop_display) do
		table.insert(var0, {
			type = iter1[1],
			id = iter1[2],
			count = iter1[3]
		})
	end

	return var0
end

function var0.TodayIsSigned(arg0)
	local var0 = arg0:GetSignedList()
	local var1 = arg0:GetIndexByToday()

	return table.contains(var0, var1)
end

function var0.Signed(arg0)
	local var0 = arg0:GetIndexByToday()

	if not table.contains(arg0.data1_list, var0) then
		arg0.data1 = arg0.data1 + 1

		table.insert(arg0.data1_list, var0)
	end
end

function var0.GetSignedDayCnt(arg0)
	return #arg0.data1_list
end

function var0.CanGetAward(arg0)
	return arg0:GetGetAwardCnt() < arg0:GetSignedDayCnt()
end

function var0.AnyAwardCanGet(arg0)
	return #arg0:GetCanGetAwardIndexList() > 0
end

function var0.GetCanGetAwardIndexList(arg0)
	if not arg0:CanGetAward() then
		return {}
	end

	local var0 = arg0:GetGetAwardCnt()
	local var1 = math.max(arg0:GetSignedDayCnt() - var0, 0)

	if var1 <= 0 then
		return {}
	end

	table.sort(arg0.data2_list, function(arg0, arg1)
		return arg0 < arg1
	end)

	local var2 = var0 == 0 and 0 or arg0.data2_list[var0]
	local var3 = arg0:GetTotalDayCnt()
	local var4 = math.min(var2 + var1, var3)
	local var5 = {}

	for iter0 = var2 + 1, var4 do
		table.insert(var5, iter0)
	end

	return var5
end

function var0.GetAwardState(arg0, arg1)
	local var0 = arg0:GetCanGetAwardIndexList()

	if table.contains(var0, arg1) then
		return var0.STATE_CAN_GET
	elseif table.contains(arg0.data2_list, arg1) then
		return var0.STATE_GOT
	else
		return var0.STATE_EMPTY
	end
end

function var0.GetGetAwardCnt(arg0)
	return #arg0.data2_list
end

function var0.GetAllAwards(arg0)
	local var0 = arg0:GetCanGetAwardIndexList()

	for iter0, iter1 in ipairs(var0) do
		arg0:GetIndexAward(iter1)
	end
end

function var0.GetIndexAward(arg0, arg1)
	if not table.contains(arg0.data2_list, arg1) then
		arg0.data2 = arg0.data2 + 1

		table.insert(arg0.data2_list, arg1)
	end
end

function var0.IsManualSignActAndAnyAwardCanGet(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0)

	if not var0 or var0:isEnd() then
		return false
	end

	if not isa(var0, ManualSignActivity) then
		return false
	end

	return var0:AnyAwardCanGet()
end

return var0
