local var0 = class("WorldActivateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33101, var0, 33102, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(WorldProxy)

			var0:NetUpdateWorld(arg0.world, arg0.global_flag_list or {}, var0.camp)
			var0:NetUpdateWorldCountInfo(arg0.count_info)
			var0:NetUpdateWorldMapPressing({})
			var0:NetUpdateWorldPressingAward(arg0.chapter_award)
			var0:NetUpdateWorldPortShopMark(arg0.port_list, arg0.new_flag_port_list)
			nowWorld():GetBossProxy():GenFleet()
			arg0:sendNotification(GAME.WORLD_ACTIVATE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_activate_error_", arg0.result))
		end
	end)
end

return var0
