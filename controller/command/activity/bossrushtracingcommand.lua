local var0_0 = class("BossRushTracingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg1_1.body
	local var1_1 = var0_1.seriesId
	local var2_1 = var0_1.actId
	local var3_1 = getProxy(ActivityProxy):getActivityById(var2_1)

	if not var3_1 then
		return
	end

	local var4_1 = var0_1.mode
	local var5_1

	if var3_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
		var5_1 = var3_1:GetCollabSeriesData(var1_1)
		var5_1.mode = var4_1
		var1_1 = var5_1:GetActivitySeriesID()
	else
		var5_1 = BossRushSeriesData.New({
			id = var1_1,
			actId = var2_1,
			mode = var4_1
		})
	end

	local var6_1 = var5_1:GetFleetIds()
	local var7_1 = var0_1.mode
	local var8_1, var9_1 = var5_1:GetModeFleetIDs(var7_1)
	local var10_1 = var5_1:GetFleets(var8_1)
	local var11_1 = var5_1:GetFleets(var9_1)[1]

	if var11_1:isEmpty() then
		table.remove(var9_1)
	end

	local var12_1 = (function()
		local var0_2 = 0
		local var1_2

		if var5_1.__cname == "CollabrateBossRushSeriesData" then
			var1_2 = SYSTEM_BOSS_RUSH_COLLABRATE
		elseif var5_1:GetType() == BossRushSeriesData.TYPE.EXTRA then
			var1_2 = SYSTEM_BOSS_RUSH_EX
		else
			var1_2 = SYSTEM_BOSS_RUSH
		end

		local var2_2 = pg.battle_cost_template[var1_2]
		local var3_2 = var5_1:GetOilLimit()
		local var4_2 = var2_2.oil_cost > 0

		local function var5_2(arg0_3, arg1_3)
			local var0_3 = 0

			if var4_2 then
				var0_3 = arg0_3:GetCostSum().oil

				if arg1_3 > 0 then
					var0_3 = math.min(arg1_3, var0_3)
				end
			end

			return var0_3
		end

		local var6_2 = #var5_1:GetExpeditionIds()
		local var7_2 = var5_2(var11_1, var3_2[2]) * var6_2

		for iter0_2 = 1, var6_2 do
			var7_2 = var7_2 + var5_2(var10_1[iter0_2] or var10_1[1], var3_2[1])
		end

		return var7_2
	end)()
	local var13_1 = var5_1:GetOilCost()
	local var14_1 = var12_1 + var13_1

	if var14_1 > getProxy(PlayerProxy):getRawData().oil then
		if not ItemTipPanel.ShowOilBuyTip(var14_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
		end

		return
	end

	local var15_1 = var0_1.remasterTicketCost or BossRushChapterRemasterHelper.GetPermanentActivityTicketCost(var2_1, var0_1.seriesId)
	local var16_1 = getProxy(ChapterProxy)

	if var15_1 > 0 and var15_1 > var16_1.remasterTickets then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_tickets_not_enough"))
		arg0_1:sendNotification(GAME.BOSSRUSH_TRACE_ERROR)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var2_1,
		arg1 = var1_1,
		arg2 = var7_1,
		arg_list = var8_1,
		arg_list2 = var9_1
	}, 11203, function(arg0_4)
		if arg0_4.result == 0 then
			getProxy(ActivityProxy):getActivityById(var2_1):SetSeriesData(var5_1)

			if var13_1 > 0 then
				local var0_4 = getProxy(PlayerProxy):getRawData()

				var0_4:consume({
					oil = var13_1
				})
				getProxy(PlayerProxy):updatePlayer(var0_4)
			end

			if var15_1 > 0 then
				var16_1:updateRemasterTicketsNum(var16_1.remasterTickets - var15_1)
			end

			;(function()
				local var0_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK)

				if not var0_5 then
					return
				end

				var0_5:ResetLast()
				getProxy(ActivityProxy):updateActivity(var0_5)
			end)()
			arg0_1:sendNotification(GAME.BOSSRUSH_TRACE_DONE, var5_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_4.result))
			arg0_1:sendNotification(GAME.BOSSRUSH_TRACE_ERROR, arg0_4.result)
		end
	end)
end

return var0_0
