local var0 = class("BossRushPreCombatMediator", import("view.base.ContextMediator"))

var0.ON_UPDATE_CUSTOM_FLEET = "BossRushPreCombatMediator:ON_UPDATE_CUSTOM_FLEET"
var0.ON_START = "BossRushPreCombatMediator:ON_START"
var0.BEGIN_STAGE = "BossRushPreCombatMediator:BEGIN_STAGE"
var0.SHOW_CONTINUOUS_OPERATION_WINDOW = "BossRushPreCombatMediator:SHOW_CONTINUOUS_OPERATION_WINDOW"
var0.CONTINUOUS_OPERATION = "BossRushPreCombatMediator:CONTINUOUS_OPERATION"
var0.OPEN_SHIP_INFO = "BossRushPreCombatMediator:OPEN_SHIP_INFO"
var0.CHANGE_FLEET_SHIP = "BossRushPreCombatMediator:CHANGE_FLEET_SHIP"
var0.CHANGE_FLEET_SHIPS_ORDER = "BossRushPreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
var0.REMOVE_SHIP = "BossRushPreCombatMediator:REMOVE_SHIP"
var0.ON_AUTO = "BossRushPreCombatMediator:ON_AUTO"
var0.ON_SUB_AUTO = "BossRushPreCombatMediator:ON_SUB_AUTO"
var0.ON_FLEET_REFRESHED = "BossRushPreCombatMediator:ON_FLEET_REFRESHED"
var0.ON_CHANGE_FLEET = "BossRushPreCombatMediator:ON_CHANGE_FLEET"

function var0.register(arg0)
	arg0:bindEvent()

	arg0.ships = getProxy(BayProxy):getRawData()

	arg0.viewComponent:SetShips(arg0.ships)

	local var0 = arg0.contextData.fleets

	arg0.fleets = var0

	arg0.viewComponent:SetFleets(var0)

	local var1 = var0[arg0.contextData.fleetIndex]

	arg0.viewComponent:SetCurrentFleet(var1.id)

	local var2 = arg0.contextData.fleets

	arg0.viewComponent:SetSubFlag(var2[#var2]:isLegalToFight() == true)
end

function var0.bindEvent(arg0)
	arg0:bind(var0.ON_CHANGE_FLEET, function(arg0, arg1)
		arg0:changeFleet(arg1)
	end)
	arg0:bind(var0.ON_AUTO, function(arg0, arg1)
		arg0:onAutoBtn(arg1)
	end)
	arg0:bind(var0.ON_SUB_AUTO, function(arg0, arg1)
		arg0:onAutoSubBtn(arg1)
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIPS_ORDER, function(arg0, arg1)
		arg0:refreshEdit(arg1)
	end)
	arg0:bind(var0.REMOVE_SHIP, function(arg0, arg1, arg2)
		(function(arg0, arg1)
			if not arg0:canRemove(arg1) then
				local var0, var1 = arg0:getShipPos(arg1)

				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg1:getConfigTable().name, arg0.name, Fleet.C_TEAM_NAME[var1]))

				return false
			end

			arg0:removeShip(arg1)

			return true
		end)(arg2, arg1)
		arg0:refreshEdit(arg2)
	end)
	arg0:bind(var0.OPEN_SHIP_INFO, function(arg0, arg1, arg2)
		local var0 = {}

		for iter0, iter1 in ipairs(arg2:getShipIds()) do
			table.insert(var0, arg0.ships[iter1])
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1,
			shipVOs = var0
		})
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIP, function(arg0, arg1, arg2, arg3)
		local var0
		local var1 = _.flatten(_.map(arg0.contextData.fleets, function(arg0)
			return arg0:GetRawShipIds()
		end))
		local var2, var3, var4 = BossRushFleetSelectMediator.getDockCallbackFuncs(arg1, arg2, arg3, var1, arg0.contextData.actId)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			leastLimitMsg = i18n("battle_preCombatMediator_leastLimit"),
			quitTeam = arg1 ~= nil,
			teamFilter = arg3,
			onShip = var2,
			confirmSelect = var3,
			onSelected = var4,
			hideTagFlags = setmetatable({
				inActivity = arg0.contextData.actId
			}, {
				__index = ShipStatus.TAG_HIDE_ACTIVITY_BOSS
			}),
			blockTagFlags = var0,
			otherSelectedIds = var1,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	arg0:bind(var0.ON_UPDATE_CUSTOM_FLEET, function(arg0)
		_.each(arg0.contextData.fleets, function(arg0)
			getProxy(FleetProxy):updateActivityFleet(arg0.contextData.actId, arg0.id, arg0)
		end)

		local var0 = {}

		_.each(arg0.contextData.fleets, function(arg0)
			var0[arg0.id] = arg0
		end)
		arg0:sendNotification(GAME.EDIT_ACTIVITY_FLEET, {
			actID = arg0.contextData.actId,
			fleets = var0
		})
	end)
	arg0:bind(var0.ON_START, function(arg0, arg1)
		arg0.viewComponent:emit(var0.ON_UPDATE_CUSTOM_FLEET)
		seriesAsync({
			function(arg0)
				for iter0 = 1, #arg0.contextData.fleets - 1 do
					if arg0.contextData.fleets[iter0]:isLegalToFight() ~= true then
						pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_team_notenough"))

						return
					end
				end

				local var0 = {}

				if _.any(arg0.contextData.fleets, function(arg0)
					return _.any(arg0:GetRawShipIds(), function(arg0)
						local var0 = getProxy(BayProxy):RawGetShipById(arg0)

						if var0[var0:getGroupId()] then
							return true
						end

						var0[var0:getGroupId()] = true
					end)
				end) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_exist_same_kind_ship"))

					return
				end

				arg0()
			end,
			function(arg0)
				table.SerialIpairsAsync(arg0.contextData.fleets, function(arg0, arg1, arg2)
					local var0, var1 = arg1:HaveShipsInEvent()

					if var0 then
						pg.TipsMgr.GetInstance():ShowTips(var1)

						return
					end

					local var2 = arg0.contextData.actId

					if _.any(arg1:getShipIds(), function(arg0)
						local var0 = getProxy(BayProxy):RawGetShipById(arg0)

						if not var0 then
							return
						end

						local var1, var2 = ShipStatus.ShipStatusCheck("inActivity", var0, nil, {
							inActivity = var2
						})

						if not var1 then
							pg.TipsMgr.GetInstance():ShowTips(var2)

							return true
						end
					end) then
						return
					end

					arg2()
				end, arg0)
			end,
			function(arg0)
				if arg0.contextData.mode == BossRushSeriesData.MODE.SINGLE then
					if _.any(arg0.contextData.fleets, function(arg0)
						return _.any(arg0:GetRawShipIds(), function(arg0)
							return getProxy(BayProxy):RawGetShipById(arg0):getEnergy() <= pg.gameset.series_enemy_mood_limit.key_value
						end)
					end) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_mood_error"))

						return
					else
						arg0()
					end
				else
					table.SerialIpairsAsync(arg0.contextData.fleets, function(arg0, arg1, arg2)
						Fleet.EnergyCheck(_.map(_.values(arg1.ships), function(arg0)
							return getProxy(BayProxy):getShipById(arg0)
						end), Fleet.DEFAULT_NAME[arg0], function(arg0)
							if arg0 then
								arg2()
							end
						end)
					end, arg0)
				end
			end,
			function(arg0)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					local var0 = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle")

					getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.GOLD_MAX)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var0,
						onYes = arg0,
						weight = LayerWeightConst.SECOND_LAYER
					})
				else
					arg0()
				end
			end,
			function(arg0)
				getProxy(ActivityProxy):InitContinuousTime(arg1)
				arg0:sendNotification(GAME.BOSSRUSH_TRACE, {
					actId = arg0.contextData.actId,
					seriesId = arg0.contextData.seriesData.id,
					mode = arg0.contextData.mode
				})
			end
		})
	end)
	arg0:bind(var0.SHOW_CONTINUOUS_OPERATION_WINDOW, function(arg0)
		local var0 = arg0.contextData.fleets
		local var1 = var0[#var0]
		local var2 = _.slice(var0, 1, #var0 - 1)
		local var3 = arg0.contextData.seriesData
		local var4 = arg0.contextData.mode

		local function var5()
			local var0 = 0
			local var1 = var3:GetType() == BossRushSeriesData.TYPE.EXTRA and SYSTEM_BOSS_RUSH_EX or SYSTEM_BOSS_RUSH
			local var2 = pg.battle_cost_template[var1]
			local var3 = var3:GetOilLimit()
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

			local var6 = #var3:GetExpeditionIds()

			if var4 == BossRushSeriesData.MODE.SINGLE then
				var0 = var0 + var5(var2[1], var3[1])
				var0 = var0 + var5(var1, var3[2])
				var0 = var0 * var6
			else
				var0 = var5(var1, var3[2]) * var6

				_.each(var2, function(arg0)
					var0 = var0 + var5(arg0, var3[1])
				end)
			end

			return var0
		end

		arg0:addSubLayers(Context.New({
			mediator = BossRushContinuousOperationWindowMediator,
			viewComponent = BossRushContinuousOperationWindow,
			data = {
				system = arg0.contextData.system,
				maxCount = pg.gameset.series_enemy_multiple_limit.key_value,
				oilCost = var5()
			}
		}))
	end)
	arg0:bind(var0.BEGIN_STAGE, function(arg0)
		local var0 = getProxy(ActivityProxy):GetContinuousTime()

		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = arg0.contextData.system,
			actId = arg0.contextData.actId,
			continuousBattleTimes = var0,
			totalBattleTimes = var0
		})
	end)
end

function var0.onAutoBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0,
		toggle = var1,
		system = arg0.contextData.system
	})
end

function var0.onAutoSubBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0,
		toggle = var1,
		system = arg0.contextData.system
	})
end

function var0.changeFleet(arg0, arg1)
	arg0.viewComponent:SetCurrentFleet(arg1)
	arg0.viewComponent:UpdateFleetView(true)
	arg0.viewComponent:SetFleetStepper()
end

function var0.refreshEdit(arg0, arg1)
	local var0 = getProxy(FleetProxy)
	local var1 = arg0.contextData.actId

	var0:updateActivityFleet(var1, arg1.id, arg1)
	arg0.viewComponent:UpdateFleetView(false)
	arg0:sendNotification(var0.ON_FLEET_REFRESHED)
end

function var0.commitEdit(arg0)
	_.each(arg0.contextData.fleets, function(arg0)
		getProxy(FleetProxy):updateActivityFleet(arg0.contextData.actId, arg0.id, arg0)
	end)

	local var0 = {}

	_.each(arg0.contextData.fleets, function(arg0)
		var0[arg0.id] = arg0
	end)
	arg0:sendNotification(GAME.EDIT_ACTIVITY_FLEET, {
		actID = arg0.contextData.actId,
		fleets = var0
	})
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BOSSRUSH_TRACE_DONE,
		GAME.BEGIN_STAGE_DONE,
		GAME.BEGIN_STAGE_ERRO,
		var0.CONTINUOUS_OPERATION
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
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
	elseif var0 == var0.CONTINUOUS_OPERATION then
		arg0.viewComponent:emit(BossRushPreCombatMediator.ON_START, var1.battleTimes)
	elseif var0 == GAME.BOSSRUSH_TRACE_DONE then
		arg0.viewComponent:emit(var0.BEGIN_STAGE)
	end
end

return var0
