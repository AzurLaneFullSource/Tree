local var0_0 = class("BossRushTracingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0_1 = arg1_1.body
	local var1_1 = var0_1.seriesId
	local var2_1 = var0_1.actId

	if not getProxy(ActivityProxy):getActivityById(var2_1) then
		return
	end

	local var3_1 = var0_1.mode
	local var4_1 = BossRushSeriesData.New({
		id = var1_1,
		actId = var2_1,
		mode = var3_1
	})
	local var5_1 = var4_1:GetFleetIds()
	local var6_1 = var0_1.mode
	local var7_1 = Clone(var5_1)
	local var8_1 = {
		table.remove(var7_1)
	}

	if var6_1 == BossRushSeriesData.MODE.SINGLE then
		var7_1 = {
			table.remove(var7_1, 1)
		}
	end

	local var9_1 = getProxy(FleetProxy):getActivityFleets()[var2_1]
	local var10_1 = _.map(var7_1, function(arg0_2)
		return var9_1[arg0_2]
	end)
	local var11_1 = var9_1[var8_1[1]]

	if var11_1:isEmpty() then
		table.remove(var8_1)
	end

	local var12_1 = (function()
		local var0_3 = 0
		local var1_3 = var4_1:GetType() == BossRushSeriesData.TYPE.EXTRA and SYSTEM_BOSS_RUSH_EX or SYSTEM_BOSS_RUSH
		local var2_3 = pg.battle_cost_template[var1_3]
		local var3_3 = var4_1:GetOilLimit()
		local var4_3 = var2_3.oil_cost > 0

		local function var5_3(arg0_4, arg1_4)
			local var0_4 = 0

			if var4_3 then
				var0_4 = arg0_4:GetCostSum().oil

				if arg1_4 > 0 then
					var0_4 = math.min(arg1_4, var0_4)
				end
			end

			return var0_4
		end

		local var6_3 = #var4_1:GetExpeditionIds()

		if var6_1 == BossRushSeriesData.MODE.SINGLE then
			var0_3 = var0_3 + var5_3(var10_1[1], var3_3[1])
			var0_3 = var0_3 + var5_3(var11_1, var3_3[2])
			var0_3 = var0_3 * var6_3
		else
			var0_3 = var5_3(var11_1, var3_3[2]) * var6_3

			_.each(var10_1, function(arg0_5)
				var0_3 = var0_3 + var5_3(arg0_5, var3_3[1])
			end)
		end

		return var0_3
	end)()
	local var13_1 = var4_1:GetOilCost()
	local var14_1 = var12_1 + var13_1

	if var14_1 > getProxy(PlayerProxy):getRawData().oil then
		if not ItemTipPanel.ShowOilBuyTip(var14_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var2_1,
		arg1 = var1_1,
		arg2 = var6_1,
		arg_list = var7_1,
		arg_list2 = var8_1
	}, 11203, function(arg0_6)
		if arg0_6.result == 0 then
			getProxy(ActivityProxy):getActivityById(var2_1):SetSeriesData(var4_1)

			if var13_1 > 0 then
				local var0_6 = getProxy(PlayerProxy):getRawData()

				var0_6:consume({
					oil = var13_1
				})
				getProxy(PlayerProxy):updatePlayer(var0_6)
			end

			;(function()
				local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK)

				if not var0_7 then
					return
				end

				var0_7:ResetLast()
				getProxy(ActivityProxy):updateActivity(var0_7)
			end)()
			arg0_1:sendNotification(GAME.BOSSRUSH_TRACE_DONE, var4_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_6.result))
			arg0_1:sendNotification(GAME.BOSSRUSH_TRACE_ERROR, arg0_6.result)
		end
	end)
end

return var0_0
