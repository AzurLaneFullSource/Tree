local var0_0 = class("BossRushPreCombatMediator", import("view.base.ContextMediator"))

var0_0.ON_UPDATE_CUSTOM_FLEET = "BossRushPreCombatMediator:ON_UPDATE_CUSTOM_FLEET"
var0_0.ON_START = "BossRushPreCombatMediator:ON_START"
var0_0.BEGIN_STAGE = "BossRushPreCombatMediator:BEGIN_STAGE"
var0_0.SHOW_CONTINUOUS_OPERATION_WINDOW = "BossRushPreCombatMediator:SHOW_CONTINUOUS_OPERATION_WINDOW"
var0_0.CONTINUOUS_OPERATION = "BossRushPreCombatMediator:CONTINUOUS_OPERATION"
var0_0.OPEN_SHIP_INFO = "BossRushPreCombatMediator:OPEN_SHIP_INFO"
var0_0.CHANGE_FLEET_SHIP = "BossRushPreCombatMediator:CHANGE_FLEET_SHIP"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "BossRushPreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0_0.REMOVE_SHIP = "BossRushPreCombatMediator:REMOVE_SHIP"
var0_0.ON_AUTO = "BossRushPreCombatMediator:ON_AUTO"
var0_0.ON_SUB_AUTO = "BossRushPreCombatMediator:ON_SUB_AUTO"
var0_0.ON_FLEET_REFRESHED = "BossRushPreCombatMediator:ON_FLEET_REFRESHED"
var0_0.ON_CHANGE_FLEET = "BossRushPreCombatMediator:ON_CHANGE_FLEET"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()

	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:SetShips(arg0_1.ships)

	local var0_1 = arg0_1.contextData.fleets

	arg0_1.fleets = var0_1

	arg0_1.viewComponent:SetFleets(var0_1)

	local var1_1 = var0_1[arg0_1.contextData.fleetIndex]

	arg0_1.viewComponent:SetCurrentFleet(var1_1.id)

	local var2_1 = arg0_1.contextData.fleets

	arg0_1.viewComponent:SetSubFlag(var2_1[#var2_1]:isLegalToFight() == true)
end

function var0_0.bindEvent(arg0_2)
	arg0_2:bind(var0_0.ON_CHANGE_FLEET, function(arg0_3, arg1_3)
		arg0_2:changeFleet(arg1_3)
	end)
	arg0_2:bind(var0_0.ON_AUTO, function(arg0_4, arg1_4)
		arg0_2:onAutoBtn(arg1_4)
	end)
	arg0_2:bind(var0_0.ON_SUB_AUTO, function(arg0_5, arg1_5)
		arg0_2:onAutoSubBtn(arg1_5)
	end)
	arg0_2:bind(var0_0.CHANGE_FLEET_SHIPS_ORDER, function(arg0_6, arg1_6)
		arg0_2:refreshEdit(arg1_6)
	end)
	arg0_2:bind(var0_0.REMOVE_SHIP, function(arg0_7, arg1_7, arg2_7)
		(function(arg0_8, arg1_8)
			if not arg0_8:canRemove(arg1_8) then
				local var0_8, var1_8 = arg0_8:getShipPos(arg1_8)

				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg1_8:getConfigTable().name, arg0_8.name, Fleet.C_TEAM_NAME[var1_8]))

				return false
			end

			arg0_8:removeShip(arg1_8)

			return true
		end)(arg2_7, arg1_7)
		arg0_2:refreshEdit(arg2_7)
	end)
	arg0_2:bind(var0_0.OPEN_SHIP_INFO, function(arg0_9, arg1_9, arg2_9)
		local var0_9 = {}

		for iter0_9, iter1_9 in ipairs(arg2_9:getShipIds()) do
			table.insert(var0_9, arg0_2.ships[iter1_9])
		end

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_9,
			shipVOs = var0_9
		})
	end)
	arg0_2:bind(var0_0.CHANGE_FLEET_SHIP, function(arg0_10, arg1_10, arg2_10, arg3_10)
		local var0_10
		local var1_10 = _.flatten(_.map(arg0_2.contextData.fleets, function(arg0_11)
			return arg0_11:GetRawShipIds()
		end))
		local var2_10, var3_10, var4_10 = BossRushFleetSelectMediator.getDockCallbackFuncs(arg1_10, arg2_10, arg3_10, var1_10, arg0_2.contextData.actId)

		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			leastLimitMsg = i18n("battle_preCombatMediator_leastLimit"),
			quitTeam = arg1_10 ~= nil,
			teamFilter = arg3_10,
			onShip = var2_10,
			confirmSelect = var3_10,
			onSelected = var4_10,
			hideTagFlags = setmetatable({
				inActivity = arg0_2.contextData.actId
			}, {
				__index = ShipStatus.TAG_HIDE_ACTIVITY_BOSS
			}),
			blockTagFlags = var0_10,
			otherSelectedIds = var1_10,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0_2:bind(var0_0.ON_UPDATE_CUSTOM_FLEET, function(arg0_12)
		_.each(arg0_2.contextData.fleets, function(arg0_13)
			getProxy(FleetProxy):updateActivityFleet(arg0_2.contextData.actId, arg0_13.id, arg0_13)
		end)

		local var0_12 = {}

		_.each(arg0_2.contextData.fleets, function(arg0_14)
			var0_12[arg0_14.id] = arg0_14
		end)
		arg0_2:sendNotification(GAME.EDIT_ACTIVITY_FLEET, {
			actID = arg0_2.contextData.actId,
			fleets = var0_12
		})
	end)
	arg0_2:bind(var0_0.ON_START, function(arg0_15, arg1_15)
		arg0_2.viewComponent:emit(var0_0.ON_UPDATE_CUSTOM_FLEET)
		seriesAsync({
			function(arg0_16)
				for iter0_16 = 1, #arg0_2.contextData.fleets - 1 do
					if arg0_2.contextData.fleets[iter0_16]:isLegalToFight() ~= true then
						pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_team_notenough"))

						return
					end
				end

				local var0_16 = {}

				if _.any(arg0_2.contextData.fleets, function(arg0_17)
					return _.any(arg0_17:GetRawShipIds(), function(arg0_18)
						local var0_18 = getProxy(BayProxy):RawGetShipById(arg0_18)

						if var0_16[var0_18:getGroupId()] then
							return true
						end

						var0_16[var0_18:getGroupId()] = true
					end)
				end) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_exist_same_kind_ship"))

					return
				end

				arg0_16()
			end,
			function(arg0_19)
				table.SerialIpairsAsync(arg0_2.contextData.fleets, function(arg0_20, arg1_20, arg2_20)
					local var0_20, var1_20 = arg1_20:HaveShipsInEvent()

					if var0_20 then
						pg.TipsMgr.GetInstance():ShowTips(var1_20)

						return
					end

					local var2_20 = arg0_2.contextData.actId

					if _.any(arg1_20:getShipIds(), function(arg0_21)
						local var0_21 = getProxy(BayProxy):RawGetShipById(arg0_21)

						if not var0_21 then
							return
						end

						local var1_21, var2_21 = ShipStatus.ShipStatusCheck("inActivity", var0_21, nil, {
							inActivity = var2_20
						})

						if not var1_21 then
							pg.TipsMgr.GetInstance():ShowTips(var2_21)

							return true
						end
					end) then
						return
					end

					arg2_20()
				end, arg0_19)
			end,
			function(arg0_22)
				if arg0_2.contextData.mode == BossRushSeriesData.MODE.SINGLE then
					if _.any(arg0_2.contextData.fleets, function(arg0_23)
						return _.any(arg0_23:GetRawShipIds(), function(arg0_24)
							return getProxy(BayProxy):RawGetShipById(arg0_24):getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value
						end)
					end) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_mood_error"))

						return
					else
						arg0_22()
					end
				else
					table.SerialIpairsAsync(arg0_2.contextData.fleets, function(arg0_25, arg1_25, arg2_25)
						Fleet.EnergyCheck(_.map(_.values(arg1_25.ships), function(arg0_26)
							return getProxy(BayProxy):getShipById(arg0_26)
						end), Fleet.DEFAULT_NAME[arg0_25], function(arg0_27)
							if arg0_27 then
								arg2_25()
							end
						end)
					end, arg0_22)
				end
			end,
			function(arg0_28)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					local var0_28 = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle")

					getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.GOLD_MAX)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var0_28,
						onYes = arg0_28,
						weight = LayerWeightConst.SECOND_LAYER
					})
				else
					arg0_28()
				end
			end,
			function(arg0_29)
				getProxy(ActivityProxy):InitContinuousTime(arg1_15)
				arg0_2:sendNotification(GAME.BOSSRUSH_TRACE, {
					actId = arg0_2.contextData.actId,
					seriesId = arg0_2.contextData.seriesData.id,
					mode = arg0_2.contextData.mode
				})
			end
		})
	end)
	arg0_2:bind(var0_0.SHOW_CONTINUOUS_OPERATION_WINDOW, function(arg0_30)
		local var0_30 = arg0_2.contextData.fleets
		local var1_30 = var0_30[#var0_30]
		local var2_30 = _.slice(var0_30, 1, #var0_30 - 1)
		local var3_30 = arg0_2.contextData.seriesData
		local var4_30 = arg0_2.contextData.mode

		local function var5_30()
			local var0_31 = 0
			local var1_31 = var3_30:GetType() == BossRushSeriesData.TYPE.EXTRA and SYSTEM_BOSS_RUSH_EX or SYSTEM_BOSS_RUSH
			local var2_31 = pg.battle_cost_template[var1_31]
			local var3_31 = var3_30:GetOilLimit()
			local var4_31 = var2_31.oil_cost > 0

			local function var5_31(arg0_32, arg1_32)
				local var0_32 = 0

				if var4_31 then
					var0_32 = arg0_32:GetCostSum().oil

					if arg1_32 > 0 then
						var0_32 = math.min(arg1_32, var0_32)
					end
				end

				return var0_32
			end

			local var6_31 = #var3_30:GetExpeditionIds()

			if var4_30 == BossRushSeriesData.MODE.SINGLE then
				var0_31 = var0_31 + var5_31(var2_30[1], var3_31[1])
				var0_31 = var0_31 + var5_31(var1_30, var3_31[2])
				var0_31 = var0_31 * var6_31
			else
				var0_31 = var5_31(var1_30, var3_31[2]) * var6_31

				_.each(var2_30, function(arg0_33)
					var0_31 = var0_31 + var5_31(arg0_33, var3_31[1])
				end)
			end

			return var0_31
		end

		arg0_2:addSubLayers(Context.New({
			mediator = BossRushContinuousOperationWindowMediator,
			viewComponent = BossRushContinuousOperationWindow,
			data = {
				system = arg0_2.contextData.system,
				maxCount = pg.gameset.series_enemy_multiple_limit.key_value,
				oilCost = var5_30()
			}
		}))
	end)
	arg0_2:bind(var0_0.BEGIN_STAGE, function(arg0_34)
		local var0_34 = getProxy(ActivityProxy):GetContinuousTime()

		arg0_2:sendNotification(GAME.BEGIN_STAGE, {
			system = arg0_2.contextData.system,
			actId = arg0_2.contextData.actId,
			continuousBattleTimes = var0_34,
			totalBattleTimes = var0_34
		})
	end)
end

function var0_0.onAutoBtn(arg0_35, arg1_35)
	local var0_35 = arg1_35.isOn
	local var1_35 = arg1_35.toggle

	arg0_35:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_35,
		toggle = var1_35,
		system = arg0_35.contextData.system
	})
end

function var0_0.onAutoSubBtn(arg0_36, arg1_36)
	local var0_36 = arg1_36.isOn
	local var1_36 = arg1_36.toggle

	arg0_36:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_36,
		toggle = var1_36,
		system = arg0_36.contextData.system
	})
end

function var0_0.changeFleet(arg0_37, arg1_37)
	arg0_37.viewComponent:SetCurrentFleet(arg1_37)
	arg0_37.viewComponent:UpdateFleetView(true)
	arg0_37.viewComponent:SetFleetStepper()
end

function var0_0.refreshEdit(arg0_38, arg1_38)
	local var0_38 = getProxy(FleetProxy)
	local var1_38 = arg0_38.contextData.actId

	var0_38:updateActivityFleet(var1_38, arg1_38.id, arg1_38)
	arg0_38.viewComponent:UpdateFleetView(false)
	arg0_38:sendNotification(var0_0.ON_FLEET_REFRESHED)
end

function var0_0.commitEdit(arg0_39)
	_.each(arg0_39.contextData.fleets, function(arg0_40)
		getProxy(FleetProxy):updateActivityFleet(arg0_39.contextData.actId, arg0_40.id, arg0_40)
	end)

	local var0_39 = {}

	_.each(arg0_39.contextData.fleets, function(arg0_41)
		var0_39[arg0_41.id] = arg0_41
	end)
	arg0_39:sendNotification(GAME.EDIT_ACTIVITY_FLEET, {
		actID = arg0_39.contextData.actId,
		fleets = var0_39
	})
end

function var0_0.listNotificationInterests(arg0_42)
	return {
		GAME.BOSSRUSH_TRACE_DONE,
		GAME.BEGIN_STAGE_DONE,
		GAME.BEGIN_STAGE_ERRO,
		var0_0.CONTINUOUS_OPERATION
	}
end

function var0_0.handleNotification(arg0_43, arg1_43)
	local var0_43 = arg1_43:getName()
	local var1_43 = arg1_43:getBody()

	if var0_43 == GAME.BEGIN_STAGE_DONE then
		arg0_43:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_43)
	elseif var0_43 == GAME.BEGIN_STAGE_ERRO then
		if var1_43 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0_43.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0_43 == var0_0.CONTINUOUS_OPERATION then
		arg0_43.viewComponent:emit(BossRushPreCombatMediator.ON_START, var1_43.battleTimes)
	elseif var0_43 == GAME.BOSSRUSH_TRACE_DONE then
		arg0_43.viewComponent:emit(var0_0.BEGIN_STAGE)
	end
end

return var0_0
