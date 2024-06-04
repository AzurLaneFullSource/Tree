local var0 = class("BossSingleSceneTemplate", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	error("Need Complete")
end

function var0.init(arg0)
	arg0:buildCommanderPanel()
end

function var0.GetFleetEditPanel(arg0)
	if not arg0.fleetEditPanel then
		arg0.fleetEditPanel = BossSingleBattleFleetSelectSubPanel.New(arg0)

		arg0.fleetEditPanel:Load()
	end

	return arg0.fleetEditPanel
end

function var0.DestroyFleetEditPanel(arg0)
	if arg0.fleetEditPanel then
		arg0.fleetEditPanel:Destroy()

		arg0.fleetEditPanel = nil
	end
end

function var0.didEnter(arg0)
	if arg0.contextData.editFleet then
		arg0:ShowNormalFleet(arg0.contextData.editFleet)
	end
end

function var0.ShowNormalFleet(arg0, arg1)
	if not arg0.contextData.actFleets[arg1] then
		arg0.contextData.actFleets[arg1] = arg0:CreateNewFleet(arg1)
	end

	if not arg0.contextData.actFleets[arg1 + 10] then
		arg0.contextData.actFleets[arg1 + 10] = arg0:CreateNewFleet(arg1 + 10)
	end

	local var0 = arg0.contextData.actFleets[arg1]
	local var1 = arg0:GetFleetEditPanel()
	local var2 = arg0.contextData.bossActivity:GetEnemyDataByFleetIdx(arg1)

	var1.buffer:SetSettings(1, 1, false, var2:GetPropertyLimitation(), arg1)
	var1.buffer:SetFleets({
		arg0.contextData.actFleets[arg1],
		arg0.contextData.actFleets[arg1 + 10]
	})

	local var3 = arg0.contextData.useOilLimit[arg1]
	local var4 = arg0.contextData.stageIDs[arg1]

	var1.buffer:SetOilLimit(var3)

	arg0.contextData.editFleet = arg1

	var1.buffer:UpdateView()
	var1.buffer:Show()
end

function var0.commitEdit(arg0)
	arg0:emit(BossSingleMediatorTemplate.ON_COMMIT_FLEET)
end

function var0.commitCombat(arg0)
	arg0:emit(BossSingleMediatorTemplate.ON_PRECOMBAT, arg0.contextData.editFleet)
end

function var0.updateEditPanel(arg0)
	if arg0.fleetEditPanel then
		arg0.fleetEditPanel.buffer:UpdateView()
	end
end

function var0.hideFleetEdit(arg0)
	if arg0.fleetEditPanel then
		arg0.fleetEditPanel.buffer:Hide()
	end

	arg0.contextData.editFleet = nil
end

function var0.openShipInfo(arg0, arg1, arg2)
	local var0 = arg0.contextData.actFleets[arg2]
	local var1 = {}
	local var2 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(var0 and var0.ships or {}) do
		table.insert(var1, var2:getShipById(iter1))
	end

	arg0:emit(BossSingleMediatorTemplate.ON_FLEET_SHIPINFO, {
		shipId = arg1,
		shipVOs = var1
	})
end

function var0.setCommanderPrefabs(arg0, arg1)
	arg0.commanderPrefabs = arg1
end

function var0.openCommanderPanel(arg0, arg1, arg2)
	local var0 = arg0.contextData.activityID

	arg0.levelCMDFormationView:setCallback(function(arg0)
		if arg0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0:emit(BossSingleMediatorTemplate.ON_COMMANDER_SKILL, arg0.skill)
		elseif arg0.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0.contextData.eliteCommanderSelected = {
				fleetIndex = arg2,
				cmdPos = arg0.pos,
				mode = arg0.curMode
			}

			arg0:emit(BossSingleMediatorTemplate.ON_SELECT_COMMANDER, arg2, arg0.pos)
		else
			arg0:emit(BossSingleMediatorTemplate.COMMANDER_FORMATION_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_ACTIVITY,
				data = arg0,
				fleetId = arg1.id,
				actId = var0
			})
		end
	end)
	arg0.levelCMDFormationView:Load()
	arg0.levelCMDFormationView:ActionInvoke("update", arg1, arg0.commanderPrefabs)
	arg0.levelCMDFormationView:ActionInvoke("Show")
end

function var0.updateCommanderFleet(arg0, arg1)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("updateFleet", arg1)
	end
end

function var0.updateCommanderPrefab(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0.commanderPrefabs)
	end
end

function var0.closeCommanderPanel(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("Hide")
	end
end

function var0.buildCommanderPanel(arg0)
	arg0.levelCMDFormationView = LevelCMDFormationView.New(arg0._tf, arg0.event, arg0.contextData)
end

function var0.destroyCommanderPanel(arg0)
	arg0.levelCMDFormationView:Destroy()

	arg0.levelCMDFormationView = nil
end

function var0.CreateNewFleet(arg0, arg1)
	return TypedFleet.New({
		id = arg1,
		ship_list = {},
		commanders = {},
		fleetType = arg1 > 10 and FleetType.Submarine or FleetType.Normal
	})
end

function var0.willExit(arg0)
	arg0:DestroyFleetEditPanel()
	arg0:destroyCommanderPanel()
end

return var0
