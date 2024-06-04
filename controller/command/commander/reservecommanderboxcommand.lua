local var0 = class("ReserveCommanderBoxCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().count
	local var1 = getProxy(CommanderProxy)
	local var2 = var1:getBoxUseCnt()

	if var2 == CommanderConst.MAX_GETBOX_CNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reserve_count_is_max"))

		return
	end

	local var3 = getProxy(PlayerProxy)
	local var4 = var3:getData()
	local var5 = 0

	for iter0 = var2, var2 + var0 - 1 do
		var5 = var5 + CommanderConst.getBoxComsume(iter0)
	end

	if var5 > var4.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25018, {
		type = var0
	}, 25019, function(arg0)
		if arg0.result == 0 then
			var4:consume({
				gold = var5
			})
			var3:updatePlayer(var4)

			local var0 = PlayerConst.addTranDrop(arg0.awards)

			var1:updateBoxUseCnt(var0)
			arg0:sendNotification(GAME.COMMANDER_RESERVE_BOX_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_lock_erro", arg0.result))
		end
	end)
end

return var0
