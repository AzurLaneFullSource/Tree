local var0_0 = class("EndChapterAutoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ChapterAutoProxy)
	local var2_1 = var1_1:GetCommissionList()
	local var3_1 = #var2_1
	local var4_1 = underscore.reduce(var2_1, 0, function(arg0_2, arg1_2)
		return arg0_2 + (arg1_2:UsedTicket() and 1 or 0)
	end)
	local var5_1, var6_1 = var1_1:GetFinishedCnt()
	local var7_1 = var3_1 - var5_1
	local var8_1 = var4_1 - var6_1
	local var9_1 = var2_1[1].type
	local var10_1 = var2_1[1].id
	local var11_1 = {}

	if var7_1 > 0 then
		table.insert(var11_1, function(arg0_3)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("auto_battle_ing_stop_tips"),
				onYes = arg0_3
			})
		end)
	end

	if underscore.any(var2_1, function(arg0_4)
		return not arg0_4:IsFinished() and arg0_4:UsedTicket() and pg.TimeMgr.GetInstance():GetServerTime() > arg0_4:GetTicketTime()
	end) then
		table.insert(var11_1, function(arg0_5)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("auto_battle_drop_book_expired"),
				onYes = arg0_5
			})
		end)
	end

	local var12_1 = var2_1[1]:GetClassExpAward() * var5_1
	local var13_1 = getProxy(NavalAcademyProxy)
	local var14_1 = var13_1:getCourse():GetProficiency()
	local var15_1 = var13_1:GetClassVO():GetMaxProficiency()
	local var16_1 = var14_1 + var12_1

	if var15_1 < var16_1 then
		table.insert(var11_1, function(arg0_6)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("auto_battle_drop_classEXP_overflow", var16_1 - var15_1),
				onYes = arg0_6
			})
		end)
	end

	local var17_1 = underscore.reduce(var2_1, 0, function(arg0_7, arg1_7)
		return arg0_7 + (arg1_7:IsFinished() and arg1_7:UsedTicket() and arg1_7:GetExpBookAward() or 0)
	end)
	local var18_1 = getProxy(BagProxy):getItemCountById(ChapterAutoCommission.EXP_BOOK_ID) + var17_1
	local var19_1 = Item.getConfigData(ChapterAutoCommission.EXP_BOOK_ID).max_num

	if var19_1 < var18_1 then
		table.insert(var11_1, function(arg0_8)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("auto_battle_drop_bookEXP_overflow", var18_1 - var19_1),
				onYes = arg0_8
			})
		end)
	end

	seriesAsync(var11_1, function()
		arg0_1:Send(var9_1, var10_1, var5_1, var6_1, var7_1, var8_1)
	end)
end

function var0_0.Send(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10, arg6_10)
	pg.ConnectionMgr.GetInstance():Send(13014, {
		num = arg3_10
	}, 13015, function(arg0_11)
		if arg0_11.result == 0 then
			local var0_11 = getProxy(ChapterAutoProxy)

			var0_11:ClearCommissionList()
			var0_11:ReduceCostTime(arg0_11.seconds)
			var0_11:AddTickets(arg0_11.chapter_auto_ticket_list)
			var0_11:IncreaseOil(arg0_11.oil)

			local var1_11 = false

			switch(arg1_10, {
				[ChapterAutoProxy.TYPE.SLG] = function()
					local var0_12 = getProxy(ChapterProxy)

					var0_12:addRemasterPassCount(arg2_10, nil, arg4_10)

					local var1_12 = var0_12:getChapterById(arg2_10, true)

					var1_12:writeDrops(arg0_11.drop_list)

					if arg6_10 > 0 and var0_12:getMapById(var1_12:getConfig("map")):isRemaster() then
						var1_11 = true

						local var2_12 = arg6_10 * var0_12:getRemasterTicketCost()

						var0_12:updateRemasterTicketsNum(math.min(var0_12.remasterTickets + var2_12, pg.gameset.reactivity_ticket_max.key_value))
					end
				end
			})
			getProxy(NavalAcademyProxy):AddProficiency(arg0_11.class_exp)

			local var2_11 = PlayerConst.addTranDrop(arg0_11.drop_list)

			arg0_10:sendNotification(GAME.END_CHAPTER_AUTO_DONE, {
				isRemaster = var1_11,
				type = arg1_10,
				id = arg2_10,
				awards = var2_11,
				proficiency = arg0_11.class_exp,
				finishCnt = arg3_10,
				allCnt = arg3_10 + arg5_10
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("chapter_auto_end_fail", arg0_11.result))
		end
	end)
end

return var0_0
