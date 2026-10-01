local var0_0 = class("StartWorldChapterAutoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.list
	local var2_1 = var0_1.needTicket
	local var3_1 = nowWorld()

	assert(var3_1.type == World.TypeFull)

	local var4_1 = getProxy(ChapterAutoProxy)

	if var2_1 and var4_1:GetValidTicketCntByType(ChapterAutoTicket.TYPE.WORLD) < #var1_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_not_enough_resource"))

		return
	end

	local var5_1 = 0

	for iter0_1, iter1_1 in ipairs(var1_1) do
		var5_1 = var5_1 + ChapterAutoCommission.GetOnceOil(ChapterAutoProxy.TYPE.WORLD, iter1_1)
	end

	if var5_1 > var3_1.staminaMgr:GetTotalStamina() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_not_enough_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(13018, {
		map_id_list = var1_1
	}, 13019, function(arg0_2)
		if arg0_2.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_start_tips"))

			local var0_2 = getProxy(ChapterAutoProxy)

			var0_2:SetCommissionList(arg0_2.chapter_auto_battle_list)

			if var2_1 then
				var0_2:ReduceTicketByType(ChapterAutoTicket.TYPE.WORLD, #var1_1)
			end

			var3_1 = nowWorld()

			var3_1.staminaMgr:ConsumeStamina(var5_1)
			arg0_1:sendNotification(GAME.START_WORLD_CHAPTER_AUTO_DONE, {})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("chapter_auto_start_fail", arg0_2.result))
		end
	end)
end

return var0_0
