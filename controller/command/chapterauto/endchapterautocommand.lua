local var0_0 = class("EndChapterAutoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.isReset
	local var3_1 = getProxy(ChapterAutoProxy)
	local var4_1 = var3_1:GetCommissionList()
	local var5_1 = #var4_1
	local var6_1 = underscore.reduce(var4_1, 0, function(arg0_2, arg1_2)
		return arg0_2 + (arg1_2:UsedTicket() and 1 or 0)
	end)
	local var7_1, var8_1 = var3_1:GetFinishedCnt()
	local var9_1 = var5_1 - var7_1
	local var10_1 = var6_1 - var8_1
	local var11_1 = var4_1[1].type
	local var12_1 = var4_1[1].id
	local var13_1 = {}

	if var9_1 > 0 then
		table.insert(var13_1, function(arg0_3)
			local var0_3 = switch(var11_1, {
				[ChapterAutoProxy.TYPE.SLG] = function()
					return "auto_battle_ing_stop_tips"
				end,
				[ChapterAutoProxy.TYPE.WORLD] = function()
					return var2_1 and "world_auto_plan_error_tip6" or "world_auto_plan_cancel_tip"
				end
			})

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n(var0_3),
				onYes = arg0_3
			})
		end)
	end

	if underscore.any(var4_1, function(arg0_6)
		return not arg0_6:IsFinished() and arg0_6:UsedTicket() and pg.TimeMgr.GetInstance():GetServerTime() > arg0_6:GetTicketTime()
	end) then
		table.insert(var13_1, function(arg0_7)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("auto_battle_drop_book_expired"),
				onYes = arg0_7
			})
		end)
	end

	if var11_1 == ChapterAutoProxy.TYPE.SLG then
		local var14_1 = var4_1[1]:GetClassExpAward() * var7_1
		local var15_1 = getProxy(NavalAcademyProxy)
		local var16_1 = var15_1:getCourse():GetProficiency()
		local var17_1 = var15_1:GetClassVO():GetMaxProficiency()
		local var18_1 = var16_1 + var14_1

		if var17_1 < var18_1 then
			table.insert(var13_1, function(arg0_8)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("auto_battle_drop_classEXP_overflow", var18_1 - var17_1),
					onYes = arg0_8
				})
			end)
		end

		local var19_1 = underscore.reduce(var4_1, 0, function(arg0_9, arg1_9)
			return arg0_9 + (arg1_9:IsFinished() and arg1_9:UsedTicket() and arg1_9:GetExpBookAward() or 0)
		end)
		local var20_1 = getProxy(BagProxy):getItemCountById(ChapterAutoCommission.EXP_BOOK_ID) + var19_1
		local var21_1 = Item.getConfigData(ChapterAutoCommission.EXP_BOOK_ID).max_num

		if var21_1 < var20_1 then
			table.insert(var13_1, function(arg0_10)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("auto_battle_drop_bookEXP_overflow", var20_1 - var21_1),
					onYes = arg0_10
				})
			end)
		end
	end

	if var11_1 == ChapterAutoProxy.TYPE.WORLD then
		table.insert(var13_1, function(arg0_11)
			WorldConst.ReqWorldCheck(arg0_11)
		end)
	end

	seriesAsync(var13_1, function()
		arg0_1:Send(var11_1, var12_1, var7_1, var8_1, var9_1, var10_1, var4_1, var2_1, var1_1)
	end)
end

function var0_0.Send(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13, arg5_13, arg6_13, arg7_13, arg8_13, arg9_13)
	getProxy(ChapterAutoProxy):SetRecordEventFlag(true)
	pg.ConnectionMgr.GetInstance():Send(13014, {
		num = arg3_13
	}, 13015, function(arg0_14)
		if arg0_14.result == 0 then
			local var0_14 = getProxy(ChapterAutoProxy)

			var0_14:SetRecordEventFlag(false)
			var0_14:ClearCommissionList()
			var0_14:ReduceCostTime(arg0_14.seconds)
			var0_14:AddTickets(arg0_14.chapter_auto_ticket_list)
			var0_14:IncreaseOil(arg0_14.oil)

			if arg1_13 == ChapterAutoProxy.TYPE.WORLD then
				local var1_14 = nowWorld().staminaMgr

				var1_14:UpdateStamina()
				var1_14:PlusStamina(arg0_14.world_ap)
			end

			local var2_14 = false

			switch(arg1_13, {
				[ChapterAutoProxy.TYPE.SLG] = function()
					local var0_15 = getProxy(ChapterProxy)

					var0_15:addRemasterPassCount(arg2_13, nil, arg4_13)

					local var1_15 = var0_15:getChapterById(arg2_13, true)

					var1_15:writeDrops(arg0_14.drop_list)

					if arg6_13 > 0 and var0_15:getMapById(var1_15:getConfig("map")):isRemaster() then
						var2_14 = true

						local var2_15 = arg6_13 * var0_15:getRemasterTicketCost()

						var0_15:updateRemasterTicketsNum(math.min(var0_15.remasterTickets + var2_15, pg.gameset.reactivity_ticket_max.key_value))
					end
				end
			})
			getProxy(NavalAcademyProxy):AddProficiency(arg0_14.class_exp)

			local var3_14 = PlayerConst.addTranDrop(arg0_14.drop_list)
			local var4_14 = {}

			if arg1_13 == ChapterAutoProxy.TYPE.WORLD then
				local var5_14 = nowWorld()
				local var6_14 = var5_14:GetAtlas()

				for iter0_14, iter1_14 in ipairs(underscore.first(arg7_13, arg3_13)) do
					table.insert(var4_14, iter1_14.id)
					var6_14:AddDelegatedMap(iter1_14.id)
				end

				getProxy(WorldProxy):RecordDelegateAward({
					var4_14,
					var3_14
				})

				if arg8_13 then
					local var7_14 = {}

					for iter2_14, iter3_14 in ipairs(var4_14) do
						local var8_14 = var5_14.pressingAwardDic[iter3_14]

						if var8_14.flag then
							var5_14:FlagMapPressingAward(iter3_14)
							var6_14:MarkMapTransport(iter3_14)

							local var9_14 = pg.world_event_complete[var8_14.id].event_reward_slgbuff

							if #var9_14 > 0 then
								var7_14[var9_14[1]] = defaultValue(var7_14[var9_14[1]], 0) + var9_14[2]
							end
						end
					end

					for iter4_14, iter5_14 in pairs(var7_14) do
						var5_14:AddGlobalBuff(iter4_14, iter5_14)
					end
				end
			end

			arg0_13:sendNotification(GAME.END_CHAPTER_AUTO_DONE, {
				isRemaster = var2_14,
				type = arg1_13,
				id = arg2_13,
				awards = var3_14,
				proficiency = arg0_14.class_exp,
				finishCnt = arg3_13,
				allCnt = arg3_13 + arg5_13,
				mapList = var4_14
			})
			existCall(arg9_13)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("chapter_auto_end_fail", arg0_14.result))
		end
	end)
end

return var0_0
