local var0 = class("RefluxProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0:initData()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.active = false
	arg0.returnLV = 0
	arg0.returnTimestamp = 0
	arg0.returnShipNum = 0
	arg0.returnLastTimestamp = 0
	arg0.ptNum = 0
	arg0.ptStage = 0
	arg0.signCount = 0
	arg0.signLastTimestamp = 0
	arg0.autoActionForbidden = false
end

function var0.setData(arg0, arg1)
	arg0.active = arg1.active == 1
	arg0.returnLV = arg1.return_lv
	arg0.returnTimestamp = arg1.return_time
	arg0.returnShipNum = arg1.ship_number
	arg0.returnLastTimestamp = arg1.last_offline_time
	arg0.ptNum = arg1.pt
	arg0.ptStage = arg1.pt_stage
	arg0.signCount = arg1.sign_cnt
	arg0.signLastTimestamp = arg1.sign_last_time
end

function var0.addListener(arg0)
	arg0:on(11752, function(arg0)
		arg0:setData(arg0)
	end)
end

function var0.setSignLastTimestamp(arg0, arg1)
	arg0.signLastTimestamp = arg1 or pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.addSignCount(arg0)
	arg0.signCount = arg0.signCount + 1
end

function var0.addPtAfterSubTasks(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1.id
		local var1 = pg.return_task_template[var0].pt_award

		arg0.ptNum = arg0.ptNum + var1
	end
end

function var0.addPTStage(arg0)
	arg0.ptStage = arg0.ptStage + 1
end

function var0.isActive(arg0)
	return arg0.active
end

function var0.isCanSign(arg0)
	if arg0:isActive() and not arg0.autoActionForbidden then
		local var0 = pg.TimeMgr.GetInstance()
		local var1 = arg0.signCount
		local var2 = #pg.return_sign_template.all
		local var3 = arg0.signLastTimestamp
		local var4 = var0:GetServerTime()
		local var5 = var0:IsSameDay(var4, var3)

		if var1 < var2 and not var5 then
			return true
		end
	end
end

function var0.isInRefluxTime(arg0)
	if arg0:isActive() then
		local var0 = pg.TimeMgr.GetInstance()
		local var1 = #pg.return_sign_template.all

		if arg0.returnTimestamp + var1 * 86400 <= var0:GetServerTime() then
			return false
		else
			return true
		end
	else
		return false
	end
end

function var0.setAutoActionForbidden(arg0, arg1)
	arg0.autoActionForbidden = arg1
end

return var0
