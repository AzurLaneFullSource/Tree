local var0_0 = class("ChapterAutoCommission", import("model.vo.BaseVO"))

var0_0.EXP_BOOK_ID = 16501

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.type = arg1_1.type
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.finishTime = arg1_1.time
	arg0_1.ticketTime = arg1_1.ticket_time
	arg0_1.costTime = arg1_1.seconds
end

function var0_0.bindConfigTable(arg0_2)
	return pg.chapter_auto_statistics
end

function var0_0.GetType(arg0_3)
	return arg0_3.type
end

function var0_0.GetFinishTime(arg0_4)
	return arg0_4.finishTime
end

function var0_0.GetStartTime(arg0_5)
	return arg0_5.finishTime - arg0_5.costTime
end

function var0_0.IsFinished(arg0_6)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_6:GetFinishTime()
end

function var0_0.GetTicketTime(arg0_7)
	return arg0_7.ticketTime
end

function var0_0.UsedTicket(arg0_8)
	return arg0_8:GetTicketTime() > 0
end

function var0_0.GetCostTime(arg0_9)
	return arg0_9.costTime
end

function var0_0.GetClassExpAward(arg0_10)
	return arg0_10:getConfig("base_class_exp") or 0
end

function var0_0.GetExpBookAward(arg0_11)
	return arg0_11:getConfig("drop_expbook") or 0
end

function var0_0.GetOnceOil(arg0_12, arg1_12)
	return switch(arg0_12, {
		[ChapterAutoProxy.TYPE.SLG] = function()
			return pg.chapter_auto_statistics[arg1_12].oil_limit
		end,
		[ChapterAutoProxy.TYPE.WORLD] = function()
			return pg.world_auto_statistics[arg1_12].oil_limit
		end
	}, function()
		assert(false, "invalid chapter auto type: " .. tostring(arg0_12))
	end)
end

return var0_0
