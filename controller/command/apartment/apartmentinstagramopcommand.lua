local var0_0 = class("ApartmentInstagramOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.op
	local var2_1 = getProxy(Dorm3dInsProxy):GetInstagramList(var0_1.shipId)
	local var3_1 = _.detect(var2_1, function(arg0_2)
		return arg0_2.id == var0_1.id
	end)

	if not var3_1 then
		return
	end

	if var1_1 == Instagram3Dorm.OP_DISCUSS then
		arg0_1:HandleDiscuss(var3_1, var0_1)
	elseif var1_1 == Instagram3Dorm.OP_READ then
		arg0_1:HandleRead(var3_1, var0_1)
	elseif var1_1 == Instagram3Dorm.OP_LIKE then
		arg0_1:HandleLike(var3_1, var0_1)
	elseif var1_1 == Instagram3Dorm.OP_SHARE then
		arg0_1:HandleShare(var3_1, var0_1)
	elseif var1_1 == Instagram3Dorm.OP_EXIT then
		arg0_1:HandleExit(var3_1, var0_1)
	end
end

function var0_0.HandleDiscuss(arg0_3, arg1_3, arg2_3)
	pg.ConnectionMgr.GetInstance():Send(28028, {
		ship_id = arg2_3.shipId,
		type = arg2_3.op,
		id = arg2_3.id,
		chat_id = arg2_3.commentId,
		value = arg2_3.index
	}, 28029, function(arg0_4)
		if arg0_4.result == 0 then
			arg1_3:MarkReply(arg2_3.commentId, arg2_3.index)
			arg0_3:sendNotification(GAME.APARTMENT_INS_OP_DONE, {
				op = arg2_3.op
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
		end
	end)
end

function var0_0.HandleRead(arg0_5, arg1_5, arg2_5)
	pg.ConnectionMgr.GetInstance():Send(28026, {
		ship_id = arg2_5.shipId,
		type = arg2_5.op,
		id_list = {
			arg2_5.id
		}
	}, 28027, function(arg0_6)
		if arg0_6.result == 0 then
			arg1_5:MarkRead()
			arg0_5:sendNotification(GAME.APARTMENT_INS_OP_DONE, {
				op = arg2_5.op
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_6.result] .. arg0_6.result)
		end
	end)
end

function var0_0.HandleLike(arg0_7, arg1_7, arg2_7)
	pg.ConnectionMgr.GetInstance():Send(28026, {
		ship_id = arg2_7.shipId,
		type = arg2_7.op,
		id_list = {
			arg2_7.id
		}
	}, 28027, function(arg0_8)
		if arg0_8.result == 0 then
			arg1_7:MarkLike()
			arg0_7:sendNotification(GAME.APARTMENT_INS_OP_DONE, {
				op = arg2_7.op
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_8.result] .. arg0_8.result)
		end
	end)
end

function var0_0.HandleShare(arg0_9, arg1_9, arg2_9)
	pg.ConnectionMgr.GetInstance():Send(28026, {
		ship_id = arg2_9.shipId,
		type = arg2_9.op,
		id_list = {
			arg2_9.id
		}
	}, 28027, function(arg0_10)
		if arg0_10.result == 0 then
			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeInstagram)
			arg0_9:sendNotification(GAME.APARTMENT_INS_OP_DONE, {
				op = arg2_9.op
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_10.result] .. arg0_10.result)
		end
	end)
end

function var0_0.HandleExit(arg0_11, arg1_11, arg2_11)
	pg.ConnectionMgr.GetInstance():Send(28026, {
		ship_id = arg2_11.shipId,
		type = arg2_11.op,
		id_list = {
			arg2_11.id
		}
	}, 28027, function(arg0_12)
		if arg0_12.result == 0 then
			arg1_11:SetExitTime(pg.TimeMgr.GetInstance():GetServerTime())
			arg0_11:sendNotification(GAME.APARTMENT_INS_OP_DONE, {
				op = arg2_11.op
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_12.result] .. arg0_12.result)
		end
	end)
end

return var0_0
