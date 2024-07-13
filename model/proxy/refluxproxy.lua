local var0_0 = class("RefluxProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:initData()
	arg0_1:addListener()
end

function var0_0.timeCall(arg0_2)
	return {
		[ProxyRegister.DayCall] = function(arg0_3)
			arg0_2:setAutoActionForbidden(false)
			arg0_2:sendNotification(GAME.REFLUX_REQUEST_DATA)
		end
	}
end

function var0_0.initData(arg0_4)
	arg0_4.active = false
	arg0_4.returnLV = 0
	arg0_4.returnTimestamp = 0
	arg0_4.returnShipNum = 0
	arg0_4.returnLastTimestamp = 0
	arg0_4.ptNum = 0
	arg0_4.ptStage = 0
	arg0_4.signCount = 0
	arg0_4.signLastTimestamp = 0
	arg0_4.autoActionForbidden = false
end

function var0_0.setData(arg0_5, arg1_5)
	arg0_5.active = arg1_5.active == 1
	arg0_5.returnLV = arg1_5.return_lv
	arg0_5.returnTimestamp = arg1_5.return_time
	arg0_5.returnShipNum = arg1_5.ship_number
	arg0_5.returnLastTimestamp = arg1_5.last_offline_time
	arg0_5.ptNum = arg1_5.pt
	arg0_5.ptStage = arg1_5.pt_stage
	arg0_5.signCount = arg1_5.sign_cnt
	arg0_5.signLastTimestamp = arg1_5.sign_last_time
end

function var0_0.addListener(arg0_6)
	arg0_6:on(11752, function(arg0_7)
		arg0_6:setData(arg0_7)
	end)
end

function var0_0.setSignLastTimestamp(arg0_8, arg1_8)
	arg0_8.signLastTimestamp = arg1_8 or pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.addSignCount(arg0_9)
	arg0_9.signCount = arg0_9.signCount + 1
end

function var0_0.addPtAfterSubTasks(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg1_10) do
		local var0_10 = iter1_10.id
		local var1_10 = pg.return_task_template[var0_10].pt_award

		arg0_10.ptNum = arg0_10.ptNum + var1_10
	end
end

function var0_0.addPTStage(arg0_11)
	arg0_11.ptStage = arg0_11.ptStage + 1
end

function var0_0.isActive(arg0_12)
	return arg0_12.active
end

function var0_0.isCanSign(arg0_13)
	if arg0_13:isActive() and not arg0_13.autoActionForbidden then
		local var0_13 = pg.TimeMgr.GetInstance()
		local var1_13 = arg0_13.signCount
		local var2_13 = #pg.return_sign_template.all
		local var3_13 = arg0_13.signLastTimestamp
		local var4_13 = var0_13:GetServerTime()
		local var5_13 = var0_13:IsSameDay(var4_13, var3_13)

		if var1_13 < var2_13 and not var5_13 then
			return true
		end
	end
end

function var0_0.isInRefluxTime(arg0_14)
	if arg0_14:isActive() then
		local var0_14 = pg.TimeMgr.GetInstance()
		local var1_14 = #pg.return_sign_template.all

		if arg0_14.returnTimestamp + var1_14 * 86400 <= var0_14:GetServerTime() then
			return false
		else
			return true
		end
	else
		return false
	end
end

function var0_0.setAutoActionForbidden(arg0_15, arg1_15)
	arg0_15.autoActionForbidden = arg1_15
end

return var0_0
