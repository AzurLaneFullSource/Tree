local var0_0 = class("BossRushBattleResultMediator", import("view.base.ContextMediator"))

var0_0.ON_SETTLE = "BossRushBattleResultMediator:ON_SETTLE"
var0_0.BEGIN_STAGE = "BossRushBattleResultMediator:BEGIN_STAGE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SETTLE, function()
		if not arg0_1.contextData.win or arg0_1.contextData.system == SYSTEM_BOSS_RUSH_EX then
			arg0_1:sendNotification(GAME.GO_BACK)

			return
		end

		seriesAsync({
			function(arg0_3)
				arg0_1:ShowTotalAward(arg0_1.contextData.awards)
			end
		})
	end)
	arg0_1:bind(var0_0.BEGIN_STAGE, function(arg0_4)
		local var0_4, var1_4 = getProxy(ActivityProxy):GetContinuousTime()

		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = arg0_1.contextData.system,
			actId = arg0_1.contextData.actId,
			continuousBattleTimes = var0_4,
			totalBattleTimes = var1_4
		})
	end)
	arg0_1:sendNotification(NewBattleResultMediator.ON_ENTER_BATTLE_RESULT)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		NewBattleResultMediator.SET_SKIP_FLAG,
		GAME.BOSSRUSH_TRACE_DONE,
		GAME.BOSSRUSH_TRACE_ERROR,
		GAME.BEGIN_STAGE_DONE,
		GAME.BEGIN_STAGE_ERRO,
		ContinuousOperationMediator.ON_REENTER
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == nil then
		-- block empty
	elseif var0_6 == GAME.BEGIN_STAGE_DONE then
		arg0_6:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, var1_6)
	elseif var0_6 == GAME.BEGIN_STAGE_ERRO then
		if var1_6 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0_6.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0_6 == GAME.BOSSRUSH_TRACE_DONE then
		arg0_6.viewComponent:emit(var0_0.BEGIN_STAGE)
	elseif var0_6 == GAME.BOSSRUSH_TRACE_ERROR then
		arg0_6:sendNotification(GAME.GO_BACK)
	elseif var0_6 == NewBattleResultMediator.SET_SKIP_FLAG then
		if var1_6 then
			getProxy(ActivityProxy):UseContinuousTime()
			existCall(arg0_6.viewComponent.HideConfirmPanel, arg0_6.viewComponent)

			if not (function()
				local var0_8 = getProxy(ActivityProxy):GetContinuousTime()

				if not var0_8 or var0_8 <= 0 then
					return
				end

				if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
					return
				end

				local var1_8 = arg0_6.contextData.seriesData
				local var2_8 = arg0_6.contextData.system
				local var3_8 = arg0_6.contextData.seriesData.mode
				local var4_8 = var1_8:GetFleets()
				local var5_8 = var4_8[#var4_8]
				local var6_8 = _.slice(var4_8, 1, #var4_8 - 1)

				if (function()
					local var0_9 = 0
					local var1_9 = pg.battle_cost_template[var2_8]
					local var2_9 = var1_8:GetOilLimit()
					local var3_9 = var1_9.oil_cost > 0

					local function var4_9(arg0_10, arg1_10)
						local var0_10 = 0

						if var3_9 then
							var0_10 = arg0_10:GetCostSum().oil

							if arg1_10 > 0 then
								var0_10 = math.min(arg1_10, var0_10)
							end
						end

						return var0_10
					end

					local var5_9 = #var1_8:GetExpeditionIds()

					if var3_8 == BossRushSeriesData.MODE.SINGLE then
						var0_9 = var0_9 + var4_9(var6_8[1], var2_9[1])
						var0_9 = var0_9 + var4_9(var5_8, var2_9[2])
						var0_9 = var0_9 * var5_9
					else
						var0_9 = var4_9(var5_8, var2_9[2]) * var5_9

						_.each(var6_8, function(arg0_11)
							var0_9 = var0_9 + var4_9(arg0_11, var2_9[1])
						end)
					end

					return var0_9
				end)() > getProxy(PlayerProxy):getRawData().oil then
					return
				end

				if var3_8 == BossRushSeriesData.MODE.SINGLE and _.any(var4_8, function(arg0_12)
					return _.any(arg0_12:GetRawShipIds(), function(arg0_13)
						return getProxy(BayProxy):RawGetShipById(arg0_13):getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value
					end)
				end) then
					return
				end

				return true
			end)() then
				getProxy(ActivityProxy):AddBossRushAwards(arg0_6.contextData.awards)

				local var2_6 = getProxy(ActivityProxy):PopBossRushAwards()

				arg0_6:ShowTotalAward(var2_6)

				return
			end

			arg0_6:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
		end
	elseif var0_6 == ContinuousOperationMediator.ON_REENTER then
		getProxy(ActivityProxy):AddBossRushAwards(arg0_6.contextData.awards)

		if not var1_6.autoFlag or not arg0_6.contextData.win then
			local var3_6 = getProxy(ActivityProxy):PopBossRushAwards()

			arg0_6:ShowTotalAward(var3_6)

			return
		end

		local var4_6 = getProxy(ActivityProxy):GetContinuousTime()

		if var4_6 and var4_6 > 0 then
			arg0_6:sendNotification(GAME.BOSSRUSH_TRACE, {
				actId = arg0_6.contextData.actId,
				seriesId = arg0_6.contextData.seriesData.id,
				mode = arg0_6.contextData.seriesData.mode
			})

			return
		end

		local var5_6 = getProxy(ActivityProxy):PopBossRushAwards()

		arg0_6:ShowTotalAward(var5_6)
	end
end

function var0_0.ShowTotalAward(arg0_14, arg1_14)
	local var0_14 = getProxy(ContextProxy):GetPrevContext(1)
	local var1_14, var2_14 = getProxy(ActivityProxy):GetContinuousTime()

	var0_14:addChild(Context.New({
		mediator = BossRushTotalRewardPanelMediator,
		viewComponent = BossRushTotalRewardPanel,
		data = {
			isLayer = true,
			rewards = arg1_14,
			isAutoFight = arg0_14.contextData.isAutoFight,
			totalBattleTimes = var2_14,
			continuousBattleTimes = var1_14
		}
	}))
	arg0_14:sendNotification(GAME.GO_BACK)
end

function var0_0.remove(arg0_15)
	return
end

return var0_0
