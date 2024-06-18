local var0_0 = class("WorldFleetSelectMediator", import("..base.ContextMediator"))

var0_0.OnSelectShip = "WorldFleetSelectMediator.OnSelectShip"
var0_0.OnGO = "WorldFleetSelectMediator.OnGO"
var0_0.OnShipDetail = "WorldFleetSelectMediator.OnShipDetail"
var0_0.OnSelectEliteCommander = "WorldFleetSelectMediator.OnSelectEliteCommander"
var0_0.OnCommanderFormationOp = "WorldFleetSelectMediator.OnCommanderFormationOp"
var0_0.OnCommanderSkill = "WorldFleetSelectMediator.OnCommanderSkill"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnSelectShip, function(arg0_2, arg1_2, arg2_2, arg3_2)
		local var0_2 = tobool(arg2_2[arg3_2])
		local var1_2 = {}

		for iter0_2, iter1_2 in pairs(arg0_1.contextData.fleets) do
			for iter2_2, iter3_2 in ipairs(iter1_2) do
				for iter4_2 = 1, 3 do
					if iter3_2[arg1_2][iter4_2] then
						table.insert(var1_2, iter3_2[arg1_2][iter4_2])
					end
				end
			end
		end

		local var2_2, var3_2, var4_2 = arg0_1:GetDockCallbackFuncs(arg2_2, arg3_2, var1_2)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var0_2,
			teamFilter = arg1_2,
			leftTopInfo = i18n("word_formation"),
			onShip = var2_2,
			confirmSelect = var3_2,
			onSelected = var4_2,
			hideTagFlags = ShipStatus.TAG_HIDE_WORLD,
			otherSelectedIds = var1_2
		})
	end)
	arg0_1:bind(var0_0.OnGO, function(arg0_3)
		local var0_3 = nowWorld()
		local var1_3 = arg0_1.contextData.fleets

		if arg0_1.contextData.mapId then
			arg0_1:sendNotification(GAME.WORLD_ACTIVATE, {
				id = arg0_1.contextData.mapId,
				enter_map_id = arg0_1.contextData.entranceId,
				elite_fleet_list = var0_3:FormationIds2NetIds(var1_3),
				camp = var0_3:GetRealm()
			})
		else
			local var2_3 = {}

			if not var0_3:CompareRedeploy(var1_3) then
				table.insert(var2_3, function(arg0_4)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("world_redeploy_not_change"),
						onYes = arg0_4
					})
				end)
			end

			table.insert(var2_3, function(arg0_5)
				local var0_5 = var0_3:CalcOrderCost(WorldConst.OpReqRedeploy)
				local var1_5 = var0_3.staminaMgr:GetTotalStamina()

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_redeploy_cost_tip", setColorStr(var0_5, COLOR_GREEN), setColorStr(var1_5, var0_5 <= var1_5 and COLOR_GREEN or COLOR_RED)),
					onYes = function()
						if var0_3.staminaMgr:GetTotalStamina() < var0_5 then
							var0_3.staminaMgr:Show()
						else
							arg0_5()
						end
					end
				})
			end)
			seriesAsync(var2_3, function()
				arg0_1:sendNotification(GAME.WORLD_FLEET_REDEPLOY, {
					elite_fleet_list = var0_3:FormationIds2NetIds(var1_3)
				})
			end)
		end
	end)
	arg0_1:bind(var0_0.OnShipDetail, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_8.shipId,
			shipVOs = arg1_8.shipVOs
		})
	end)
	arg0_1:bind(var0_0.OnCommanderFormationOp, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1_9
		})
	end)
	arg0_1:bind(var0_0.OnCommanderSkill, function(arg0_10, arg1_10)
		arg0_1:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = arg1_10
			}
		}))
	end)
	arg0_1:bind(var0_0.OnSelectEliteCommander, function(arg0_11, arg1_11, arg2_11, arg3_11)
		local var0_11 = arg0_1.contextData.fleets[arg1_11][arg2_11]
		local var1_11 = Fleet.New({
			ship_list = {},
			commanders = var0_11.commanders
		})
		local var2_11 = var1_11:getCommanders()

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			fleetType = CommanderCatScene.FLEET_TYPE_WORLD,
			fleets = arg0_1.contextData.fleets,
			activeCommander = var2_11[arg3_11],
			ignoredIds = {},
			onCommander = function(arg0_12)
				return true
			end,
			onSelected = function(arg0_13, arg1_13)
				local var0_13 = arg0_13[1]
				local var1_13 = getProxy(CommanderProxy):getCommanderById(var0_13)

				for iter0_13, iter1_13 in pairs(arg0_1.contextData.fleets) do
					for iter2_13, iter3_13 in ipairs(iter1_13) do
						if iter0_13 == arg1_11 and iter2_13 == arg2_11 then
							for iter4_13, iter5_13 in pairs(var2_11) do
								if iter5_13.groupId == var1_13.groupId and iter4_13 ~= arg3_11 then
									pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

									return
								end
							end
						else
							for iter6_13, iter7_13 in pairs(iter3_13.commanders) do
								if var0_13 == iter7_13.id then
									pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

									return
								end
							end
						end
					end
				end

				var1_11:updateCommanderByPos(arg3_11, var1_13)

				var0_11.commanders = var1_11:outputCommanders()

				arg1_13()
			end,
			onQuit = function(arg0_14)
				var1_11:updateCommanderByPos(arg3_11, nil)

				var0_11.commanders = var1_11:outputCommanders()

				arg0_14()
			end
		})

		arg0_1.contextData.editFleet = true
	end)

	local var0_1 = getProxy(CommanderProxy):getPrefabFleet()

	arg0_1.viewComponent:setCommanderPrefabs(var0_1)
end

function var0_0.listNotificationInterests(arg0_15)
	return {
		GAME.WORLD_ACTIVATE_DONE,
		GAME.WORLD_FLEET_REDEPLOY_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COMMANDER_WORLD_FORMATION_OP_DONE
	}
end

function var0_0.handleNotification(arg0_16, arg1_16)
	local var0_16 = arg1_16:getName()
	local var1_16 = arg1_16:getBody()

	if var0_16 == GAME.WORLD_ACTIVATE_DONE then
		local var2_16 = nowWorld()
		local var3_16 = {}

		if var2_16:IsSystemOpen(WorldConst.SystemDailyTask) then
			table.insert(var3_16, function(arg0_17)
				var2_16:GetTaskProxy():checkDailyTask(arg0_17)
			end)
		end

		seriesAsync(var3_16, function()
			arg0_16:SetFleetSuccess()
		end)
	elseif var0_16 == GAME.WORLD_FLEET_REDEPLOY_DONE then
		arg0_16:SetFleetSuccess()
	elseif var0_16 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var4_16 = getProxy(CommanderProxy):getPrefabFleet()

		arg0_16.viewComponent:setCommanderPrefabs(var4_16)
		arg0_16.viewComponent:updateCommanderPrefab()
	elseif var0_16 == GAME.COMMANDER_WORLD_FORMATION_OP_DONE then
		arg0_16.viewComponent:UpdateFleets()
		arg0_16.viewComponent:updateCommanderFleet(var1_16.fleet)
	end
end

function var0_0.GetDockCallbackFuncs(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = getProxy(BayProxy)

	local function var1_19(arg0_20, arg1_20)
		local var0_20, var1_20 = ShipStatus.ShipStatusCheck("inWorld", arg0_20, arg1_20)

		if not var0_20 then
			return var0_20, var1_20
		end

		for iter0_20, iter1_20 in ipairs(arg3_19) do
			if arg0_20.id ~= iter1_20 and arg0_20:isSameKind(var0_19:getShipById(iter1_20)) then
				return false, i18n("event_same_type_not_allowed")
			end
		end

		return true
	end

	local function var2_19(arg0_21, arg1_21, arg2_21)
		arg1_21()
	end

	local function var3_19(arg0_22)
		for iter0_22, iter1_22 in pairs(arg0_19.contextData.fleets) do
			for iter2_22, iter3_22 in ipairs(iter1_22) do
				for iter4_22, iter5_22 in pairs(iter3_22) do
					for iter6_22 = 3, 1, -1 do
						if arg1_19 == iter5_22 and iter6_22 == arg2_19 then
							iter5_22[iter6_22] = arg0_22[1]
						elseif iter5_22[iter6_22] == arg0_22[1] then
							iter5_22[iter6_22] = nil
						end
					end
				end
			end
		end
	end

	return var1_19, var2_19, var3_19
end

function var0_0.SetFleetSuccess(arg0_23)
	local var0_23 = {
		inPort = true
	}

	if arg0_23.contextData.mapId and nowWorld():IsReseted() then
		var0_23 = {
			inShop = true
		}
	end

	local var1_23 = getProxy(ContextProxy):getContextByMediator(WorldMediator)

	if var1_23 then
		var1_23:extendData(var0_23)
		arg0_23.viewComponent:closeView()
	else
		arg0_23:sendNotification(GAME.CHANGE_SCENE, SCENE.WORLD, var0_23)
	end
end

return var0_0
