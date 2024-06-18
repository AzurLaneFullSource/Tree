local var0_0 = class("WorldActivateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33101, var0_1, 33102, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(WorldProxy)

			var0_2:NetUpdateWorld(arg0_2.world, arg0_2.global_flag_list or {}, var0_1.camp)
			var0_2:NetUpdateWorldCountInfo(arg0_2.count_info)
			var0_2:NetUpdateWorldMapPressing({})
			var0_2:NetUpdateWorldPressingAward(arg0_2.chapter_award)
			var0_2:NetUpdateWorldPortShopMark(arg0_2.port_list, arg0_2.new_flag_port_list)
			nowWorld():GetBossProxy():GenFleet()
			arg0_1:sendNotification(GAME.WORLD_ACTIVATE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_activate_error_", arg0_2.result))
		end
	end)
end

return var0_0
