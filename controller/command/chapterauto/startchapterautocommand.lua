local var0_0 = class("StartChapterAutoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.id
	local var3_1 = var0_1.num
	local var4_1 = var0_1.ticketNum
	local var5_1 = getProxy(ChapterProxy):getRemasterTicketCost()

	if BeginStageCommand.DockOverload() then
		return
	end

	local var6_1 = getProxy(ChapterAutoProxy)
	local var7_1 = var6_1:GetRemainTime()

	if var7_1 <= 0 or var7_1 <= var6_1:GetRecord(var1_1, var2_1) * (var3_1 - 1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_not_enough_time"))

		return
	end

	if var4_1 > var6_1:GetValidTicketCntByType(ChapterAutoTicket.TYPE.MAIN) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_not_enough_resource"))

		return
	end

	local var8_1 = ChapterAutoCommission.GetOnceOil(var1_1, var2_1) * var4_1
	local var9_1 = math.max(0, var8_1 - var6_1:GetOil())

	if var9_1 > getProxy(PlayerProxy):getRawData().oil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_not_enough_resource"))

		return
	end

	local var10_1 = false
	local var11_1 = getProxy(ChapterProxy)

	if var1_1 == ChapterAutoProxy.TYPE.SLG then
		local var12_1 = var11_1:getChapterById(var2_1, true)

		if var11_1:getMapById(var12_1:getConfig("map")):isRemaster() then
			var10_1 = true
		end
	end

	if var10_1 and var11_1.remasterTickets < var4_1 * var5_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_tickets_not_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(13012, {
		type = var1_1,
		id = var2_1,
		num = var3_1,
		ticket_num = var4_1
	}, 13013, function(arg0_2)
		if arg0_2.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_start_tips"))

			local var0_2 = getProxy(ChapterAutoProxy)

			var0_2:SetCommissionList(arg0_2.chapter_auto_battle_list)

			local var1_2 = underscore.reduce(arg0_2.chapter_auto_battle_list, 0, function(arg0_3, arg1_3)
				return arg0_3 + arg1_3.seconds
			end)

			var0_2:AddCostTime(var1_2)
			var0_2:ReduceTicketByType(ChapterAutoTicket.TYPE.MAIN, var4_1)

			if var9_1 > 0 then
				local var2_2 = getProxy(PlayerProxy)
				local var3_2 = var2_2:getData()

				var3_2:consume({
					oil = var9_1
				})
				var2_2:updatePlayer(var3_2)
			end

			var0_2:ReduceOil(var8_1 - var9_1)

			if var10_1 then
				local var4_2 = getProxy(ChapterProxy)

				var4_2.remasterTickets = var4_2.remasterTickets - var4_1 * var5_1
			end

			arg0_1:sendNotification(GAME.START_CHAPTER_AUTO_DONE, {
				isRemaster = var10_1,
				type = var1_1,
				id = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("chapter_auto_start_fail", arg0_2.result))
		end
	end)
end

function var0_0.CheckOccupied()
	if #getProxy(ChapterAutoProxy):GetCommissionList() > 0 then
		local var0_4 = getProxy(ChapterProxy)
		local var1_4 = var0_4:GetAutoChapterId()

		if var1_4 then
			local var2_4 = var0_4:getChapterById(var1_4)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("auto_drop_is_activation", var2_4:getConfig("name")),
				onYes = function()
					local var0_5 = var0_4:getActiveChapter()

					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
						chapterId = var0_5 and var0_5.id,
						mapIdx = var0_5 and var0_5:getConfig("map")
					})
				end,
				yesText = i18n("auto_drop_is_activation_go"),
				noText = i18n("auto_drop_is_activation_cancle")
			})
		end

		return true
	end

	return false
end

return var0_0
