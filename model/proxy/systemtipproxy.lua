local var0_0 = class("SystemTipProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:on(21536, function(arg0_2)
		arg0_1:SetIslandTipData(arg0_2.get_num, arg0_2.empty_num, arg0_2.get_times, arg0_2.mange_flag)
	end)

	arg0_1.islandAwardCnt = 0
	arg0_1.islandEmptyCnt = 0
	arg0_1.islandTimestamps = {}
	arg0_1.islandPostFlag = 0
end

function var0_0.SetIslandTipData(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.islandAwardCnt = arg1_3
	arg0_3.islandEmptyCnt = arg2_3
	arg0_3.islandTimestamps = arg3_3

	table.sort(arg0_3.islandTimestamps)

	arg0_3.islandPostFlag = arg4_3
end

function var0_0.GetIslandTipInfos(arg0_4)
	if arg0_4.islandPostFlag == 0 then
		return 0, 0
	end

	local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()

	return underscore.reduce(arg0_4.islandTimestamps, arg0_4.islandAwardCnt, function(arg0_5, arg1_5)
		return arg0_5 + (arg1_5 <= var0_4 and 1 or 0)
	end), arg0_4.islandEmptyCnt
end

function var0_0.IsIslandRedDotTip(arg0_6)
	if arg0_6.islandClickRecord then
		return false
	end

	local var0_6, var1_6 = arg0_6:GetIslandTipInfos()

	return var0_6 > 0 or var1_6 > 0
end

function var0_0.SetIslandClickRecord(arg0_7)
	arg0_7.islandClickRecord = true
end

return var0_0
