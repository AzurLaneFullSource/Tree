local var0_0 = class("EnterIslandCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.code
	local var3_1 = var0_1.reconnect

	if var2_1 and var2_1 ~= "" then
		arg0_1:Send(0, var2_1, var3_1)
	else
		arg0_1:Send(var1_1, 0, var3_1)
	end
end

function var0_0.Send(arg0_2, arg1_2, arg2_2, arg3_2)
	pg.ConnectionMgr.GetInstance():Send(21202, {
		island_id = arg1_2,
		code = tostring(arg2_2)
	}, 21203, function(arg0_3)
		if arg0_3.result == 0 then
			arg0_2:sendNotification(GAME.ISLAND_GET_DATA, {
				id = arg0_3.island_id,
				list = arg0_3.player_list,
				reconnect = arg3_2
			})
			getProxy(IslandProxy):EnterIsland(arg0_3.island_id)
		elseif arg0_3.result == 6 then
			arg0_2:sendNotification(GAME.ISLAND_QUEUE_UP, {
				pos = arg0_3.pos,
				id = arg0_3.island_id
			})
		elseif arg0_3.result == 19 then
			local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_3 = arg0_3.cd - var0_3
			local var2_3 = pg.TimeMgr.GetInstance():DescCDTime(var1_3)

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip5", var2_3))
		elseif arg0_3.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip1"))
		elseif arg0_3.result == 20 or arg0_3.result == 40 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip2"))
		elseif arg0_3.result == 9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip3"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

return var0_0
