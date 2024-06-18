local var0_0 = class("BossSingleSceneTemplate", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	error("Need Complete")
end

function var0_0.init(arg0_2)
	arg0_2:buildCommanderPanel()
end

function var0_0.GetFleetEditPanel(arg0_3)
	if not arg0_3.fleetEditPanel then
		arg0_3.fleetEditPanel = BossSingleBattleFleetSelectSubPanel.New(arg0_3)

		arg0_3.fleetEditPanel:Load()
	end

	return arg0_3.fleetEditPanel
end

function var0_0.DestroyFleetEditPanel(arg0_4)
	if arg0_4.fleetEditPanel then
		arg0_4.fleetEditPanel:Destroy()

		arg0_4.fleetEditPanel = nil
	end
end

function var0_0.didEnter(arg0_5)
	if arg0_5.contextData.editFleet then
		arg0_5:ShowNormalFleet(arg0_5.contextData.editFleet)
	end
end

function var0_0.ShowNormalFleet(arg0_6, arg1_6)
	if not arg0_6.contextData.actFleets[arg1_6] then
		arg0_6.contextData.actFleets[arg1_6] = arg0_6:CreateNewFleet(arg1_6)
	end

	if not arg0_6.contextData.actFleets[arg1_6 + 10] then
		arg0_6.contextData.actFleets[arg1_6 + 10] = arg0_6:CreateNewFleet(arg1_6 + 10)
	end

	local var0_6 = arg0_6.contextData.actFleets[arg1_6]
	local var1_6 = arg0_6:GetFleetEditPanel()
	local var2_6 = arg0_6.contextData.bossActivity:GetEnemyDataByFleetIdx(arg1_6)

	var1_6.buffer:SetSettings(1, 1, false, var2_6:GetPropertyLimitation(), arg1_6)
	var1_6.buffer:SetFleets({
		arg0_6.contextData.actFleets[arg1_6],
		arg0_6.contextData.actFleets[arg1_6 + 10]
	})

	local var3_6 = arg0_6.contextData.useOilLimit[arg1_6]
	local var4_6 = arg0_6.contextData.stageIDs[arg1_6]

	var1_6.buffer:SetOilLimit(var3_6)

	arg0_6.contextData.editFleet = arg1_6

	var1_6.buffer:UpdateView()
	var1_6.buffer:Show()
end

function var0_0.commitEdit(arg0_7)
	arg0_7:emit(BossSingleMediatorTemplate.ON_COMMIT_FLEET)
end

function var0_0.commitCombat(arg0_8)
	arg0_8:emit(BossSingleMediatorTemplate.ON_PRECOMBAT, arg0_8.contextData.editFleet)
end

function var0_0.updateEditPanel(arg0_9)
	if arg0_9.fleetEditPanel then
		arg0_9.fleetEditPanel.buffer:UpdateView()
	end
end

function var0_0.hideFleetEdit(arg0_10)
	if arg0_10.fleetEditPanel then
		arg0_10.fleetEditPanel.buffer:Hide()
	end

	arg0_10.contextData.editFleet = nil
end

function var0_0.openShipInfo(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.contextData.actFleets[arg2_11]
	local var1_11 = {}
	local var2_11 = getProxy(BayProxy)

	for iter0_11, iter1_11 in ipairs(var0_11 and var0_11.ships or {}) do
		table.insert(var1_11, var2_11:getShipById(iter1_11))
	end

	arg0_11:emit(BossSingleMediatorTemplate.ON_FLEET_SHIPINFO, {
		shipId = arg1_11,
		shipVOs = var1_11
	})
end

function var0_0.setCommanderPrefabs(arg0_12, arg1_12)
	arg0_12.commanderPrefabs = arg1_12
end

function var0_0.openCommanderPanel(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.contextData.activityID

	arg0_13.levelCMDFormationView:setCallback(function(arg0_14)
		if arg0_14.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_13:emit(BossSingleMediatorTemplate.ON_COMMANDER_SKILL, arg0_14.skill)
		elseif arg0_14.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_13.contextData.eliteCommanderSelected = {
				fleetIndex = arg2_13,
				cmdPos = arg0_14.pos,
				mode = arg0_13.curMode
			}

			arg0_13:emit(BossSingleMediatorTemplate.ON_SELECT_COMMANDER, arg2_13, arg0_14.pos)
		else
			arg0_13:emit(BossSingleMediatorTemplate.COMMANDER_FORMATION_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_ACTIVITY,
				data = arg0_14,
				fleetId = arg1_13.id,
				actId = var0_13
			})
		end
	end)
	arg0_13.levelCMDFormationView:Load()
	arg0_13.levelCMDFormationView:ActionInvoke("update", arg1_13, arg0_13.commanderPrefabs)
	arg0_13.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderFleet(arg0_15, arg1_15)
	if arg0_15.levelCMDFormationView:isShowing() then
		arg0_15.levelCMDFormationView:ActionInvoke("updateFleet", arg1_15)
	end
end

function var0_0.updateCommanderPrefab(arg0_16)
	if arg0_16.levelCMDFormationView:isShowing() then
		arg0_16.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_16.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_17)
	if arg0_17.levelCMDFormationView:isShowing() then
		arg0_17.levelCMDFormationView:ActionInvoke("Hide")
	end
end

function var0_0.buildCommanderPanel(arg0_18)
	arg0_18.levelCMDFormationView = LevelCMDFormationView.New(arg0_18._tf, arg0_18.event, arg0_18.contextData)
end

function var0_0.destroyCommanderPanel(arg0_19)
	arg0_19.levelCMDFormationView:Destroy()

	arg0_19.levelCMDFormationView = nil
end

function var0_0.CreateNewFleet(arg0_20, arg1_20)
	return TypedFleet.New({
		id = arg1_20,
		ship_list = {},
		commanders = {},
		fleetType = arg1_20 > 10 and FleetType.Submarine or FleetType.Normal
	})
end

function var0_0.willExit(arg0_21)
	arg0_21:DestroyFleetEditPanel()
	arg0_21:destroyCommanderPanel()
end

return var0_0
