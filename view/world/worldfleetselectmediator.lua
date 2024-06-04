local var0 = class("WorldFleetSelectMediator", import("..base.ContextMediator"))

var0.OnSelectShip = "WorldFleetSelectMediator.OnSelectShip"
var0.OnGO = "WorldFleetSelectMediator.OnGO"
var0.OnShipDetail = "WorldFleetSelectMediator.OnShipDetail"
var0.OnSelectEliteCommander = "WorldFleetSelectMediator.OnSelectEliteCommander"
var0.OnCommanderFormationOp = "WorldFleetSelectMediator.OnCommanderFormationOp"
var0.OnCommanderSkill = "WorldFleetSelectMediator.OnCommanderSkill"

function var0.register(arg0)
	arg0:bind(var0.OnSelectShip, function(arg0, arg1, arg2, arg3)
		local var0 = tobool(arg2[arg3])
		local var1 = {}

		for iter0, iter1 in pairs(arg0.contextData.fleets) do
			for iter2, iter3 in ipairs(iter1) do
				for iter4 = 1, 3 do
					if iter3[arg1][iter4] then
						table.insert(var1, iter3[arg1][iter4])
					end
				end
			end
		end

		local var2, var3, var4 = arg0:GetDockCallbackFuncs(arg2, arg3, var1)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var0,
			teamFilter = arg1,
			leftTopInfo = i18n("word_formation"),
			onShip = var2,
			confirmSelect = var3,
			onSelected = var4,
			hideTagFlags = ShipStatus.TAG_HIDE_WORLD,
			otherSelectedIds = var1
		})
	end)
	arg0:bind(var0.OnGO, function(arg0)
		local var0 = nowWorld()
		local var1 = arg0.contextData.fleets

		if arg0.contextData.mapId then
			arg0:sendNotification(GAME.WORLD_ACTIVATE, {
				id = arg0.contextData.mapId,
				enter_map_id = arg0.contextData.entranceId,
				elite_fleet_list = var0:FormationIds2NetIds(var1),
				camp = var0:GetRealm()
			})
		else
			local var2 = {}

			if not var0:CompareRedeploy(var1) then
				table.insert(var2, function(arg0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("world_redeploy_not_change"),
						onYes = arg0
					})
				end)
			end

			table.insert(var2, function(arg0)
				local var0 = var0:CalcOrderCost(WorldConst.OpReqRedeploy)
				local var1 = var0.staminaMgr:GetTotalStamina()

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_redeploy_cost_tip", setColorStr(var0, COLOR_GREEN), setColorStr(var1, var0 <= var1 and COLOR_GREEN or COLOR_RED)),
					onYes = function()
						if var0.staminaMgr:GetTotalStamina() < var0 then
							var0.staminaMgr:Show()
						else
							arg0()
						end
					end
				})
			end)
			seriesAsync(var2, function()
				arg0:sendNotification(GAME.WORLD_FLEET_REDEPLOY, {
					elite_fleet_list = var0:FormationIds2NetIds(var1)
				})
			end)
		end
	end)
	arg0:bind(var0.OnShipDetail, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.shipId,
			shipVOs = arg1.shipVOs
		})
	end)
	arg0:bind(var0.OnCommanderFormationOp, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = arg1
		})
	end)
	arg0:bind(var0.OnCommanderSkill, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = arg1
			}
		}))
	end)
	arg0:bind(var0.OnSelectEliteCommander, function(arg0, arg1, arg2, arg3)
		local var0 = arg0.contextData.fleets[arg1][arg2]
		local var1 = Fleet.New({
			ship_list = {},
			commanders = var0.commanders
		})
		local var2 = var1:getCommanders()

		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
			maxCount = 1,
			mode = CommanderCatScene.MODE_SELECT,
			fleetType = CommanderCatScene.FLEET_TYPE_WORLD,
			fleets = arg0.contextData.fleets,
			activeCommander = var2[arg3],
			ignoredIds = {},
			onCommander = function(arg0)
				return true
			end,
			onSelected = function(arg0, arg1)
				local var0 = arg0[1]
				local var1 = getProxy(CommanderProxy):getCommanderById(var0)

				for iter0, iter1 in pairs(arg0.contextData.fleets) do
					for iter2, iter3 in ipairs(iter1) do
						if iter0 == arg1 and iter2 == arg2 then
							for iter4, iter5 in pairs(var2) do
								if iter5.groupId == var1.groupId and iter4 ~= arg3 then
									pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

									return
								end
							end
						else
							for iter6, iter7 in pairs(iter3.commanders) do
								if var0 == iter7.id then
									pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

									return
								end
							end
						end
					end
				end

				var1:updateCommanderByPos(arg3, var1)

				var0.commanders = var1:outputCommanders()

				arg1()
			end,
			onQuit = function(arg0)
				var1:updateCommanderByPos(arg3, nil)

				var0.commanders = var1:outputCommanders()

				arg0()
			end
		})

		arg0.contextData.editFleet = true
	end)

	local var0 = getProxy(CommanderProxy):getPrefabFleet()

	arg0.viewComponent:setCommanderPrefabs(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.WORLD_ACTIVATE_DONE,
		GAME.WORLD_FLEET_REDEPLOY_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COMMANDER_WORLD_FORMATION_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.WORLD_ACTIVATE_DONE then
		local var2 = nowWorld()
		local var3 = {}

		if var2:IsSystemOpen(WorldConst.SystemDailyTask) then
			table.insert(var3, function(arg0)
				var2:GetTaskProxy():checkDailyTask(arg0)
			end)
		end

		seriesAsync(var3, function()
			arg0:SetFleetSuccess()
		end)
	elseif var0 == GAME.WORLD_FLEET_REDEPLOY_DONE then
		arg0:SetFleetSuccess()
	elseif var0 == CommanderProxy.PREFAB_FLEET_UPDATE then
		local var4 = getProxy(CommanderProxy):getPrefabFleet()

		arg0.viewComponent:setCommanderPrefabs(var4)
		arg0.viewComponent:updateCommanderPrefab()
	elseif var0 == GAME.COMMANDER_WORLD_FORMATION_OP_DONE then
		arg0.viewComponent:UpdateFleets()
		arg0.viewComponent:updateCommanderFleet(var1.fleet)
	end
end

function var0.GetDockCallbackFuncs(arg0, arg1, arg2, arg3)
	local var0 = getProxy(BayProxy)

	local function var1(arg0, arg1)
		local var0, var1 = ShipStatus.ShipStatusCheck("inWorld", arg0, arg1)

		if not var0 then
			return var0, var1
		end

		for iter0, iter1 in ipairs(arg3) do
			if arg0.id ~= iter1 and arg0:isSameKind(var0:getShipById(iter1)) then
				return false, i18n("event_same_type_not_allowed")
			end
		end

		return true
	end

	local function var2(arg0, arg1, arg2)
		arg1()
	end

	local function var3(arg0)
		for iter0, iter1 in pairs(arg0.contextData.fleets) do
			for iter2, iter3 in ipairs(iter1) do
				for iter4, iter5 in pairs(iter3) do
					for iter6 = 3, 1, -1 do
						if arg1 == iter5 and iter6 == arg2 then
							iter5[iter6] = arg0[1]
						elseif iter5[iter6] == arg0[1] then
							iter5[iter6] = nil
						end
					end
				end
			end
		end
	end

	return var1, var2, var3
end

function var0.SetFleetSuccess(arg0)
	local var0 = {
		inPort = true
	}

	if arg0.contextData.mapId and nowWorld():IsReseted() then
		var0 = {
			inShop = true
		}
	end

	local var1 = getProxy(ContextProxy):getContextByMediator(WorldMediator)

	if var1 then
		var1:extendData(var0)
		arg0.viewComponent:closeView()
	else
		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.WORLD, var0)
	end
end

return var0
