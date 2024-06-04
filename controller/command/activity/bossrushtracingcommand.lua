local var0 = class("BossRushTracingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	if BeginStageCommand.DockOverload() then
		return
	end

	local var0 = arg1.body
	local var1 = var0.seriesId
	local var2 = var0.actId

	if not getProxy(ActivityProxy):getActivityById(var2) then
		return
	end

	local var3 = var0.mode
	local var4 = BossRushSeriesData.New({
		id = var1,
		actId = var2,
		mode = var3
	})
	local var5 = var4:GetFleetIds()
	local var6 = var0.mode
	local var7 = Clone(var5)
	local var8 = {
		table.remove(var7)
	}

	if var6 == BossRushSeriesData.MODE.SINGLE then
		var7 = {
			table.remove(var7, 1)
		}
	end

	local var9 = getProxy(FleetProxy):getActivityFleets()[var2]
	local var10 = _.map(var7, function(arg0)
		return var9[arg0]
	end)
	local var11 = var9[var8[1]]

	if var11:isEmpty() then
		table.remove(var8)
	end

	local var12 = (function()
		local var0 = 0
		local var1 = var4:GetType() == BossRushSeriesData.TYPE.EXTRA and SYSTEM_BOSS_RUSH_EX or SYSTEM_BOSS_RUSH
		local var2 = pg.battle_cost_template[var1]
		local var3 = var4:GetOilLimit()
		local var4 = var2.oil_cost > 0

		local function var5(arg0, arg1)
			local var0 = 0

			if var4 then
				var0 = arg0:GetCostSum().oil

				if arg1 > 0 then
					var0 = math.min(arg1, var0)
				end
			end

			return var0
		end

		local var6 = #var4:GetExpeditionIds()

		if var6 == BossRushSeriesData.MODE.SINGLE then
			var0 = var0 + var5(var10[1], var3[1])
			var0 = var0 + var5(var11, var3[2])
			var0 = var0 * var6
		else
			var0 = var5(var11, var3[2]) * var6

			_.each(var10, function(arg0)
				var0 = var0 + var5(arg0, var3[1])
			end)
		end

		return var0
	end)()
	local var13 = var4:GetOilCost()
	local var14 = var12 + var13

	if var14 > getProxy(PlayerProxy):getRawData().oil then
		if not ItemTipPanel.ShowOilBuyTip(var14) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var2,
		arg1 = var1,
		arg2 = var6,
		arg_list = var7,
		arg_list2 = var8
	}, 11203, function(arg0)
		if arg0.result == 0 then
			getProxy(ActivityProxy):getActivityById(var2):SetSeriesData(var4)

			if var13 > 0 then
				local var0 = getProxy(PlayerProxy):getRawData()

				var0:consume({
					oil = var13
				})
				getProxy(PlayerProxy):updatePlayer(var0)
			end

			;(function()
				local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK)

				if not var0 then
					return
				end

				var0:ResetLast()
				getProxy(ActivityProxy):updateActivity(var0)
			end)()
			arg0:sendNotification(GAME.BOSSRUSH_TRACE_DONE, var4)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
			arg0:sendNotification(GAME.BOSSRUSH_TRACE_ERROR, arg0.result)
		end
	end)
end

return var0
