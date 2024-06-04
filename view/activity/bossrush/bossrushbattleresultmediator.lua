local var0 = class("BossRushBattleResultMediator", import("view.base.ContextMediator"))

var0.ON_SETTLE = "BossRushBattleResultMediator:ON_SETTLE"
var0.BEGIN_STAGE = "BossRushBattleResultMediator:BEGIN_STAGE"

function var0.register(arg0)
	arg0:bind(var0.ON_SETTLE, function()
		if not arg0.contextData.win or arg0.contextData.system == SYSTEM_BOSS_RUSH_EX then
			arg0:sendNotification(GAME.GO_BACK)

			return
		end

		seriesAsync({
			function(arg0)
				arg0:ShowTotalAward(arg0.contextData.awards)
			end
		})
	end)
	arg0:bind(var0.BEGIN_STAGE, function(arg0)
		local var0, var1 = getProxy(ActivityProxy):GetContinuousTime()

		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = arg0.contextData.system,
			actId = arg0.contextData.actId,
			continuousBattleTimes = var0,
			totalBattleTimes = var1
		})
	end)
	arg0:sendNotification(NewBattleResultMediator.ON_ENTER_BATTLE_RESULT)
end

function var0.listNotificationInterests(arg0)
	return {
		NewBattleResultMediator.SET_SKIP_FLAG,
		GAME.BOSSRUSH_TRACE_DONE,
		GAME.BOSSRUSH_TRACE_ERROR,
		GAME.BEGIN_STAGE_DONE,
		GAME.BEGIN_STAGE_ERRO,
		ContinuousOperationMediator.ON_REENTER
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == GAME.BEGIN_STAGE_ERRO then
		if var1 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0 == GAME.BOSSRUSH_TRACE_DONE then
		arg0.viewComponent:emit(var0.BEGIN_STAGE)
	elseif var0 == GAME.BOSSRUSH_TRACE_ERROR then
		arg0:sendNotification(GAME.GO_BACK)
	elseif var0 == NewBattleResultMediator.SET_SKIP_FLAG then
		if var1 then
			getProxy(ActivityProxy):UseContinuousTime()
			existCall(arg0.viewComponent.HideConfirmPanel, arg0.viewComponent)

			if not (function()
				local var0 = getProxy(ActivityProxy):GetContinuousTime()

				if not var0 or var0 <= 0 then
					return
				end

				if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
					return
				end

				local var1 = arg0.contextData.seriesData
				local var2 = arg0.contextData.system
				local var3 = arg0.contextData.seriesData.mode
				local var4 = var1:GetFleets()
				local var5 = var4[#var4]
				local var6 = _.slice(var4, 1, #var4 - 1)

				if (function()
					local var0 = 0
					local var1 = pg.battle_cost_template[var2]
					local var2 = var1:GetOilLimit()
					local var3 = var1.oil_cost > 0

					local function var4(arg0, arg1)
						local var0 = 0

						if var3 then
							var0 = arg0:GetCostSum().oil

							if arg1 > 0 then
								var0 = math.min(arg1, var0)
							end
						end

						return var0
					end

					local var5 = #var1:GetExpeditionIds()

					if var3 == BossRushSeriesData.MODE.SINGLE then
						var0 = var0 + var4(var6[1], var2[1])
						var0 = var0 + var4(var5, var2[2])
						var0 = var0 * var5
					else
						var0 = var4(var5, var2[2]) * var5

						_.each(var6, function(arg0)
							var0 = var0 + var4(arg0, var2[1])
						end)
					end

					return var0
				end)() > getProxy(PlayerProxy):getRawData().oil then
					return
				end

				if var3 == BossRushSeriesData.MODE.SINGLE and _.any(var4, function(arg0)
					return _.any(arg0:GetRawShipIds(), function(arg0)
						return getProxy(BayProxy):RawGetShipById(arg0):getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value
					end)
				end) then
					return
				end

				return true
			end)() then
				getProxy(ActivityProxy):AddBossRushAwards(arg0.contextData.awards)

				local var2 = getProxy(ActivityProxy):PopBossRushAwards()

				arg0:ShowTotalAward(var2)

				return
			end

			arg0:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
		end
	elseif var0 == ContinuousOperationMediator.ON_REENTER then
		getProxy(ActivityProxy):AddBossRushAwards(arg0.contextData.awards)

		if not var1.autoFlag or not arg0.contextData.win then
			local var3 = getProxy(ActivityProxy):PopBossRushAwards()

			arg0:ShowTotalAward(var3)

			return
		end

		local var4 = getProxy(ActivityProxy):GetContinuousTime()

		if var4 and var4 > 0 then
			arg0:sendNotification(GAME.BOSSRUSH_TRACE, {
				actId = arg0.contextData.actId,
				seriesId = arg0.contextData.seriesData.id,
				mode = arg0.contextData.seriesData.mode
			})

			return
		end

		local var5 = getProxy(ActivityProxy):PopBossRushAwards()

		arg0:ShowTotalAward(var5)
	end
end

function var0.ShowTotalAward(arg0, arg1)
	getProxy(ContextProxy):GetPrevContext(1):addChild(Context.New({
		mediator = BossRushTotalRewardPanelMediator,
		viewComponent = BossRushTotalRewardPanel,
		data = {
			isLayer = true,
			rewards = arg1
		}
	}))
	arg0:sendNotification(GAME.GO_BACK)
end

function var0.remove(arg0)
	return
end

return var0
