local var0_0 = class("ManualSignActivity", import("model.vo.Activity"))

var0_0.OP_SIGN = 1
var0_0.OP_GET_AWARD = 2
var0_0.STATE_EMPTY = 0
var0_0.STATE_CAN_GET = 1
var0_0.STATE_GOT = 2

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.dataConfig = pg.activity_event_sign[arg0_1.id]
end

function var0_0.GetSignedList(arg0_2)
	return arg0_2.data1_list
end

function var0_0.GetIndexByToday(arg0_3)
	return arg0_3:getDayIndex()
end

function var0_0.GetTotalDayCnt(arg0_4)
	return #arg0_4:GetDropList()
end

function var0_0.GetDropList(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.dataConfig.drop_display) do
		table.insert(var0_5, {
			type = iter1_5[1],
			id = iter1_5[2],
			count = iter1_5[3]
		})
	end

	return var0_5
end

function var0_0.TodayIsSigned(arg0_6)
	local var0_6 = arg0_6:GetSignedList()
	local var1_6 = arg0_6:GetIndexByToday()

	return table.contains(var0_6, var1_6)
end

function var0_0.Signed(arg0_7)
	local var0_7 = arg0_7:GetIndexByToday()

	if not table.contains(arg0_7.data1_list, var0_7) then
		arg0_7.data1 = arg0_7.data1 + 1

		table.insert(arg0_7.data1_list, var0_7)
	end
end

function var0_0.GetSignedDayCnt(arg0_8)
	return #arg0_8.data1_list
end

function var0_0.CanGetAward(arg0_9)
	return arg0_9:GetGetAwardCnt() < arg0_9:GetSignedDayCnt()
end

function var0_0.AnyAwardCanGet(arg0_10)
	return #arg0_10:GetCanGetAwardIndexList() > 0
end

function var0_0.GetCanGetAwardIndexList(arg0_11)
	if not arg0_11:CanGetAward() then
		return {}
	end

	local var0_11 = arg0_11:GetGetAwardCnt()
	local var1_11 = math.max(arg0_11:GetSignedDayCnt() - var0_11, 0)

	if var1_11 <= 0 then
		return {}
	end

	table.sort(arg0_11.data2_list, function(arg0_12, arg1_12)
		return arg0_12 < arg1_12
	end)

	local var2_11 = var0_11 == 0 and 0 or arg0_11.data2_list[var0_11]
	local var3_11 = arg0_11:GetTotalDayCnt()
	local var4_11 = math.min(var2_11 + var1_11, var3_11)
	local var5_11 = {}

	for iter0_11 = var2_11 + 1, var4_11 do
		table.insert(var5_11, iter0_11)
	end

	return var5_11
end

function var0_0.GetAwardState(arg0_13, arg1_13)
	local var0_13 = arg0_13:GetCanGetAwardIndexList()

	if table.contains(var0_13, arg1_13) then
		return var0_0.STATE_CAN_GET
	elseif table.contains(arg0_13.data2_list, arg1_13) then
		return var0_0.STATE_GOT
	else
		return var0_0.STATE_EMPTY
	end
end

function var0_0.GetGetAwardCnt(arg0_14)
	return #arg0_14.data2_list
end

function var0_0.GetAllAwards(arg0_15)
	local var0_15 = arg0_15:GetCanGetAwardIndexList()

	for iter0_15, iter1_15 in ipairs(var0_15) do
		arg0_15:GetIndexAward(iter1_15)
	end
end

function var0_0.GetIndexAward(arg0_16, arg1_16)
	if not table.contains(arg0_16.data2_list, arg1_16) then
		arg0_16.data2 = arg0_16.data2 + 1

		table.insert(arg0_16.data2_list, arg1_16)
	end
end

function var0_0.IsManualSignActAndAnyAwardCanGet(arg0_17)
	local var0_17 = getProxy(ActivityProxy):getActivityById(arg0_17)

	if not var0_17 or var0_17:isEnd() then
		return false
	end

	if not isa(var0_17, ManualSignActivity) then
		return false
	end

	return var0_17:AnyAwardCanGet()
end

return var0_0
