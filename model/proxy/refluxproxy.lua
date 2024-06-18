local var0_0 = class("RefluxProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1:initData()
	arg0_1:addListener()
end

function var0_0.initData(arg0_2)
	arg0_2.active = false
	arg0_2.returnLV = 0
	arg0_2.returnTimestamp = 0
	arg0_2.returnShipNum = 0
	arg0_2.returnLastTimestamp = 0
	arg0_2.ptNum = 0
	arg0_2.ptStage = 0
	arg0_2.signCount = 0
	arg0_2.signLastTimestamp = 0
	arg0_2.autoActionForbidden = false
end

function var0_0.setData(arg0_3, arg1_3)
	arg0_3.active = arg1_3.active == 1
	arg0_3.returnLV = arg1_3.return_lv
	arg0_3.returnTimestamp = arg1_3.return_time
	arg0_3.returnShipNum = arg1_3.ship_number
	arg0_3.returnLastTimestamp = arg1_3.last_offline_time
	arg0_3.ptNum = arg1_3.pt
	arg0_3.ptStage = arg1_3.pt_stage
	arg0_3.signCount = arg1_3.sign_cnt
	arg0_3.signLastTimestamp = arg1_3.sign_last_time
end

function var0_0.addListener(arg0_4)
	arg0_4:on(11752, function(arg0_5)
		arg0_4:setData(arg0_5)
	end)
end

function var0_0.setSignLastTimestamp(arg0_6, arg1_6)
	arg0_6.signLastTimestamp = arg1_6 or pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.addSignCount(arg0_7)
	arg0_7.signCount = arg0_7.signCount + 1
end

function var0_0.addPtAfterSubTasks(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var0_8 = iter1_8.id
		local var1_8 = pg.return_task_template[var0_8].pt_award

		arg0_8.ptNum = arg0_8.ptNum + var1_8
	end
end

function var0_0.addPTStage(arg0_9)
	arg0_9.ptStage = arg0_9.ptStage + 1
end

function var0_0.isActive(arg0_10)
	return arg0_10.active
end

function var0_0.isCanSign(arg0_11)
	if arg0_11:isActive() and not arg0_11.autoActionForbidden then
		local var0_11 = pg.TimeMgr.GetInstance()
		local var1_11 = arg0_11.signCount
		local var2_11 = #pg.return_sign_template.all
		local var3_11 = arg0_11.signLastTimestamp
		local var4_11 = var0_11:GetServerTime()
		local var5_11 = var0_11:IsSameDay(var4_11, var3_11)

		if var1_11 < var2_11 and not var5_11 then
			return true
		end
	end
end

function var0_0.isInRefluxTime(arg0_12)
	if arg0_12:isActive() then
		local var0_12 = pg.TimeMgr.GetInstance()
		local var1_12 = #pg.return_sign_template.all

		if arg0_12.returnTimestamp + var1_12 * 86400 <= var0_12:GetServerTime() then
			return false
		else
			return true
		end
	else
		return false
	end
end

function var0_0.setAutoActionForbidden(arg0_13, arg1_13)
	arg0_13.autoActionForbidden = arg1_13
end

return var0_0
