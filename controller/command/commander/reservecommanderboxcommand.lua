local var0_0 = class("ReserveCommanderBoxCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().count
	local var1_1 = getProxy(CommanderProxy)
	local var2_1 = var1_1:getBoxUseCnt()

	if var2_1 == CommanderConst.MAX_GETBOX_CNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reserve_count_is_max"))

		return
	end

	local var3_1 = getProxy(PlayerProxy)
	local var4_1 = var3_1:getData()
	local var5_1 = 0

	for iter0_1 = var2_1, var2_1 + var0_1 - 1 do
		var5_1 = var5_1 + CommanderConst.getBoxComsume(iter0_1)
	end

	if var5_1 > var4_1.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25018, {
		type = var0_1
	}, 25019, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:consume({
				gold = var5_1
			})
			var3_1:updatePlayer(var4_1)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.awards)

			var1_1:updateBoxUseCnt(var0_1)
			arg0_1:sendNotification(GAME.COMMANDER_RESERVE_BOX_DONE, {
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_lock_erro", arg0_2.result))
		end
	end)
end

return var0_0
