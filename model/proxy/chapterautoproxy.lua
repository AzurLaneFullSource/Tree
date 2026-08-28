local var0_0 = class("ChapterAutoProxy", import("model.proxy.NetProxy"))

var0_0.FINISH_UPDATE = "ChapterAutoProxy.FINISH_UPDATE"
var0_0.TYPE = {
	SLG = 1
}

function var0_0.register(arg0_1)
	arg0_1:on(13001, function(arg0_2)
		arg0_1.recordData = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.chapter_auto_record_list) do
			local var0_2 = iter1_2.type

			if not arg0_1.recordData[var0_2] then
				arg0_1.recordData[var0_2] = {}
			end

			arg0_1.recordData[var0_2][iter1_2.id] = var0_0.GetFixTime(var0_2, iter1_2.id, iter1_2.seconds)
		end

		arg0_1.ticketData = {}

		for iter2_2, iter3_2 in ipairs(arg0_2.chapter_auto_ticket_list) do
			local var1_2 = iter3_2.type

			if not arg0_1.ticketData[var1_2] then
				arg0_1.ticketData[var1_2] = {}
			end

			arg0_1.ticketData[var1_2][iter3_2.time] = ChapterAutoTicket.New(iter3_2)
		end

		arg0_1:SetCommissionList(arg0_2.chapter_auto_battle_list)

		arg0_1.oil = arg0_2.oil
		arg0_1.dailyCostTime = arg0_2.time_acc
		arg0_1.dailyExtraTime = arg0_2.extra_time_max
	end)
	arg0_1:ClearEventIds()
end

function var0_0.UpdateRecord(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3.recordData[arg1_3] then
		arg0_3.recordData[arg1_3] = {}
	end

	local var0_3 = arg0_3.recordData[arg1_3][arg2_3] or 0
	local var1_3 = var0_0.GetFixTime(arg1_3, arg2_3, arg3_3)

	arg0_3.recordData[arg1_3][arg2_3] = var0_3 == 0 and var1_3 or math.min(var0_3, var1_3)
end

function var0_0.GetRecord(arg0_4, arg1_4, arg2_4)
	if not arg0_4.recordData[arg1_4] then
		return 0
	end

	return arg0_4.recordData[arg1_4][arg2_4] or 0
end

function var0_0.GetOil(arg0_5)
	return arg0_5.oil
end

function var0_0.ReduceOil(arg0_6, arg1_6)
	arg0_6.oil = math.max(0, arg0_6.oil - arg1_6)
end

function var0_0.IncreaseOil(arg0_7, arg1_7)
	arg0_7.oil = arg0_7.oil + arg1_7
end

function var0_0.GetMaxTime(arg0_8)
	return pg.gameset.auto_battle_time_limit.key_value + arg0_8.dailyExtraTime
end

function var0_0.GetRemainTime(arg0_9)
	return arg0_9:GetMaxTime() - arg0_9.dailyCostTime
end

function var0_0.AddCostTime(arg0_10, arg1_10)
	arg0_10.dailyCostTime = arg0_10.dailyCostTime + arg1_10
end

function var0_0.ReduceCostTime(arg0_11, arg1_11)
	arg0_11.dailyCostTime = math.max(0, arg0_11.dailyCostTime - arg1_11)
end

function var0_0.AddDailyExtraTime(arg0_12, arg1_12)
	arg0_12.dailyExtraTime = arg0_12.dailyExtraTime + arg1_12
end

function var0_0.ResetDailyData(arg0_13)
	arg0_13.dailyCostTime = 0
	arg0_13.dailyExtraTime = 0
end

function var0_0.GetTicketListByType(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14.ticketData[arg1_14] or {}) do
		if not iter1_14:IsExpired() then
			table.insert(var0_14, iter1_14)
		end
	end

	return var0_14
end

function var0_0.GetValidTicketCntByType(arg0_15, arg1_15)
	local var0_15 = 0

	for iter0_15, iter1_15 in pairs(arg0_15.ticketData[arg1_15] or {}) do
		if not iter1_15:IsExpired() then
			var0_15 = var0_15 + iter1_15:GetCount()
		end
	end

	return var0_15
end

function var0_0.ReduceTicketByType(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg2_16
	local var1_16 = {}

	for iter0_16, iter1_16 in pairs(arg0_16.ticketData[arg1_16] or {}) do
		if not iter1_16:IsExpired() then
			table.insert(var1_16, iter1_16.expireTime)
		end
	end

	table.sort(var1_16)

	for iter2_16, iter3_16 in ipairs(var1_16) do
		local var2_16 = arg0_16.ticketData[arg1_16][iter3_16]

		if not var2_16:IsExpired() then
			local var3_16 = var2_16:GetCount()

			if var0_16 <= var3_16 then
				var2_16:ReduceCount(var0_16)

				if var3_16 == var0_16 then
					arg0_16.ticketData[arg1_16][iter3_16] = nil
				end

				break
			else
				arg0_16.ticketData[arg1_16][iter3_16] = nil
				var0_16 = var0_16 - var3_16
			end
		end
	end
end

function var0_0.AddTickets(arg0_17, arg1_17)
	for iter0_17, iter1_17 in ipairs(arg1_17) do
		local var0_17 = iter1_17.type

		if not arg0_17.ticketData[var0_17] then
			arg0_17.ticketData[var0_17] = {}
		end

		if arg0_17.ticketData[var0_17][iter1_17.time] then
			arg0_17.ticketData[var0_17][iter1_17.time]:IncreaseCount(iter1_17.num)
		else
			arg0_17.ticketData[var0_17][iter1_17.time] = ChapterAutoTicket.New(iter1_17)
		end
	end
end

function var0_0.AddTicketByItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = ChapterAutoTicket.CreateByItem(arg1_18, arg2_18)

	if not arg0_18.ticketData[arg1_18] then
		arg0_18.ticketData[arg1_18] = {}
	end

	if arg0_18.ticketData[arg1_18][var0_18.id] then
		arg0_18.ticketData[arg1_18][var0_18.id]:IncreaseCount(var0_18:GetCount())
	else
		arg0_18.ticketData[arg1_18][var0_18.id] = var0_18
	end
end

function var0_0.GetWillExpireTicketCnt(arg0_19)
	local var0_19 = 0

	for iter0_19, iter1_19 in pairs(arg0_19.ticketData) do
		for iter2_19, iter3_19 in pairs(iter1_19) do
			if iter3_19:WillExpire() then
				var0_19 = var0_19 + iter3_19:GetCount()
			end
		end
	end

	return var0_19
end

function var0_0.SortCommissionList(arg0_20)
	table.sort(arg0_20.commissionList, CompareFuncs({
		function(arg0_21)
			return arg0_21:GetFinishTime()
		end,
		function(arg0_22)
			return -arg0_22.id
		end
	}))
end

function var0_0.GetFinishedCnt(arg0_23)
	local var0_23 = 0
	local var1_23 = 0

	for iter0_23, iter1_23 in ipairs(arg0_23.commissionList) do
		if iter1_23:IsFinished() then
			var0_23 = var0_23 + 1

			if iter1_23:UsedTicket() then
				var1_23 = var1_23 + 1
			end
		end
	end

	return var0_23, var1_23
end

function var0_0.GetCntInfo(arg0_24)
	return arg0_24.finishedCnt, #arg0_24.commissionList
end

function var0_0.ClearCommissionList(arg0_25)
	arg0_25.commissionList = {}
end

function var0_0.SetCommissionList(arg0_26, arg1_26)
	arg0_26.commissionList = {}

	for iter0_26, iter1_26 in ipairs(arg1_26) do
		table.insert(arg0_26.commissionList, ChapterAutoCommission.New(iter1_26))
	end

	arg0_26:SortCommissionList()

	arg0_26.finishedCnt = arg0_26:GetFinishedCnt()
end

function var0_0.GetCommissionList(arg0_27)
	return arg0_27.commissionList
end

function var0_0.GetFinishAllCommissionTime(arg0_28)
	if #arg0_28.commissionList == 0 then
		return 0
	end

	return arg0_28.commissionList[#arg0_28.commissionList]:GetFinishTime()
end

function var0_0.IsShowTip(arg0_29)
	if arg0_29.finishedCnt > 0 then
		return true
	end

	if arg0_29:GetWillExpireTicketCnt() > 0 then
		return true
	end

	return false
end

function var0_0.timeCall(arg0_30)
	return {
		[ProxyRegister.SecondCall] = function(arg0_31)
			arg0_30:UpdatePerSecond()
		end,
		[ProxyRegister.DayCall] = function(arg0_32)
			arg0_30:UpdatePerDay()
		end
	}
end

function var0_0.UpdatePerSecond(arg0_33)
	local var0_33 = arg0_33:GetFinishedCnt()

	if var0_33 ~= arg0_33.finishedCnt then
		arg0_33.finishedCnt = var0_33

		arg0_33:sendNotification(var0_0.FINISH_UPDATE)
	end
end

function var0_0.UpdatePerDay(arg0_34)
	for iter0_34, iter1_34 in pairs(arg0_34.ticketData) do
		for iter2_34, iter3_34 in ipairs(iter1_34) do
			if iter3_34:IsExpired() then
				arg0_34.ticketData[iter3_34.id] = nil
			end
		end
	end

	arg0_34:ResetDailyData()
end

function var0_0.GetSkipBatchBuildFlag(arg0_35)
	return arg0_35.skipBatchFlag or false
end

function var0_0.SetSkipBatchBuildFlag(arg0_36, arg1_36)
	arg0_36.skipBatchFlag = arg1_36
end

function var0_0.SetRecordEventFlag(arg0_37, arg1_37)
	arg0_37.recordEventFlag = arg1_37
end

function var0_0.RecordNewEventIds(arg0_38, arg1_38)
	if arg0_38.recordEventFlag then
		arg0_38.newEventIds = table.mergeArray(arg0_38.newEventIds, arg1_38)
	end
end

function var0_0.GetNewEventIds(arg0_39)
	return arg0_39.newEventIds
end

function var0_0.ClearEventIds(arg0_40, arg1_40)
	arg0_40.newEventIds = {}
end

function var0_0.remove(arg0_41)
	return
end

function var0_0.GetFixTime(arg0_42, arg1_42, arg2_42)
	return switch(arg0_42, {
		[var0_0.TYPE.SLG] = function()
			local var0_43 = pg.chapter_auto_statistics[arg1_42]

			if not var0_43 then
				return arg2_42
			end

			return math.floor(arg2_42 * var0_43.time_rate) + var0_43.time_correction
		end
	}, function()
		return arg2_42
	end)
end

function var0_0.IsSystemOpen()
	return AutoBotCommand.autoBotSatisfied()
end

return var0_0
