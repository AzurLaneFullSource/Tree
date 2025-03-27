local var0_0 = class("BossSingleBattleFleetSelectViewComponent")

var0_0.FUNC_NAME_GET_FLEET_EDIT_PANEL = "GetFleetEditPanel"
var0_0.FUNC_NAME_DESTROY_FLEET_EDIT_PANEL = "DestroyFleetEditPanel"
var0_0.FUNC_NAME_SHOW_NORMAL_FLEET = "ShowNormalFleet"
var0_0.FUNC_NAME_COMMIT_EDIT = "commitEdit"
var0_0.FUNC_NAME_COMMIT_COMBAT = "commitCombat"
var0_0.FUNC_NAME_UPDATE_EDIT_PANEL = "updateEditPanel"
var0_0.FUNC_NAME_HIDE_FLEET_EDIT = "hideFleetEdit"
var0_0.FUNC_NAME_OPEN_SHIP_INFO = "openShipInfo"
var0_0.FUNC_NAME_SET_COMMANDER_PREFABS = "setCommanderPrefabs"
var0_0.FUNC_NAME_OPEN_COMMANDER_PANEL = "openCommanderPanel"
var0_0.FUNC_NAME_UPDATE_COMMANDER_FLEET = "updateCommanderFleet"
var0_0.FUNC_NAME_UPDATE_COMMANDER_PREFAB = "updateCommanderPrefab"
var0_0.FUNC_NAME_CLOSE_COMMANDER_PANEL = "closeCommanderPanel"
var0_0.FUNC_NAME_BUILD_COMMANDER_PANEL = "buildCommanderPanel"
var0_0.FUNC_NAME_DESTROY_COMMANDER_PANEL = "DestroyCommanderPanel"
var0_0.FUNC_NAME_CREATE_NEW_FLEET = "CreateNewFleet"

function var0_0.AttachFleetSelect(arg0_1, arg1_1)
	var0_0.New(arg0_1, arg1_1)
end

function var0_0.DetachFleetSelect(arg0_2)
	if arg0_2._IFleetSelect == nil then
		return
	end

	arg0_2._IFleetSelect:_Destory_()

	arg0_2._IFleetSelect = nil
end

function var0_0.Ctor(arg0_3, arg1_3, arg2_3)
	arg0_3._target_ = arg1_3
	arg0_3._mediatorClass_ = arg2_3

	arg0_3:_Init_()
end

function var0_0._Init_(arg0_4)
	arg0_4._target_[var0_0.FUNC_NAME_GET_FLEET_EDIT_PANEL] = var0_0._GetFleetEditPanel_
	arg0_4._target_[var0_0.FUNC_NAME_DESTROY_FLEET_EDIT_PANEL] = var0_0._DestroyFleetEditPanel_
	arg0_4._target_[var0_0.FUNC_NAME_SHOW_NORMAL_FLEET] = var0_0._ShowNormalFleet_
	arg0_4._target_[var0_0.FUNC_NAME_COMMIT_EDIT] = var0_0._commitEdit_
	arg0_4._target_[var0_0.FUNC_NAME_COMMIT_COMBAT] = var0_0._commitCombat_
	arg0_4._target_[var0_0.FUNC_NAME_UPDATE_EDIT_PANEL] = var0_0._updateEditPanel_
	arg0_4._target_[var0_0.FUNC_NAME_HIDE_FLEET_EDIT] = var0_0._hideFleetEdit_
	arg0_4._target_[var0_0.FUNC_NAME_OPEN_SHIP_INFO] = var0_0._openShipInfo_
	arg0_4._target_[var0_0.FUNC_NAME_SET_COMMANDER_PREFABS] = var0_0._setCommanderPrefabs_
	arg0_4._target_[var0_0.FUNC_NAME_OPEN_COMMANDER_PANEL] = var0_0._openCommanderPanel_
	arg0_4._target_[var0_0.FUNC_NAME_UPDATE_COMMANDER_FLEET] = var0_0._updateCommanderFleet_
	arg0_4._target_[var0_0.FUNC_NAME_UPDATE_COMMANDER_PREFAB] = var0_0._updateCommanderPrefab_
	arg0_4._target_[var0_0.FUNC_NAME_CLOSE_COMMANDER_PANEL] = var0_0._closeCommanderPanel_
	arg0_4._target_[var0_0.FUNC_NAME_BUILD_COMMANDER_PANEL] = var0_0._buildCommanderPanel_
	arg0_4._target_[var0_0.FUNC_NAME_DESTROY_COMMANDER_PANEL] = var0_0._DestroyCommanderPanel_
	arg0_4._target_[var0_0.FUNC_NAME_CREATE_NEW_FLEET] = var0_0._CreateNewFleet_
	arg0_4._target_._IFleetSelect = arg0_4
	arg0_4._originalFunc = {}
	arg0_4._originalFunc.willExit = arg0_4._target_.willExit

	function arg0_4._target_.willExit()
		arg0_4._target_:DestroyFleetEditPanel()
		arg0_4._target_:DestroyCommanderPanel()
		arg0_4._originalFunc.willExit(arg0_4._target_)
	end

	arg0_4.contextData = arg0_4._target_.contextData
	arg0_4.emit = arg0_4._target_.emit
	arg0_4._tf = arg0_4._target_._tf
	arg0_4.event = arg0_4._target_.event

	arg0_4:_buildCommanderPanel_()
end

function var0_0._Destory_(arg0_6)
	arg0_6._target_ = nil
end

function var0_0._buildCommanderPanel_(arg0_7)
	arg0_7.levelCMDFormationView = LevelCMDFormationView.New(arg0_7._target_._tf, arg0_7._target_.event, arg0_7._target_.contextData)
end

function var0_0._GetFleetEditPanel_(arg0_8)
	if not arg0_8._IFleetSelect.fleetEditPanel then
		arg0_8._IFleetSelect.fleetEditPanel = BossSingleBattleFleetSelectSubPanel.New(arg0_8)

		arg0_8._IFleetSelect.fleetEditPanel:Load()
	end

	return arg0_8._IFleetSelect.fleetEditPanel
end

function var0_0._DestroyFleetEditPanel_(arg0_9)
	if arg0_9._IFleetSelect.fleetEditPanel then
		arg0_9._IFleetSelect.fleetEditPanel:Destroy()

		arg0_9._IFleetSelect.fleetEditPanel = nil
	end
end

function var0_0._DestroyCommanderPanel_(arg0_10)
	if arg0_10._IFleetSelect.levelCMDFormationView then
		arg0_10._IFleetSelect.levelCMDFormationView:Destroy()

		arg0_10._IFleetSelect.levelCMDFormationView = nil
	end
end

function var0_0._ShowNormalFleet_(arg0_11, arg1_11)
	local var0_11 = pg.activity_single_enemy[arg1_11]
	local var1_11 = getProxy(FleetProxy):getActivityFleets()[ActivityConst.Valleyhospital_ACT_ID]
	local var2_11 = arg1_11 - 2000

	if not var1_11[var2_11] then
		var1_11[var2_11] = arg0_11.CreateNewFleet(var2_11)
	end

	if not var1_11[var2_11 + Fleet.MEGA_SUBMARINE_FLEET_OFFSET] then
		var1_11[var2_11 + Fleet.MEGA_SUBMARINE_FLEET_OFFSET] = arg0_11.CreateNewFleet(var2_11 + Fleet.MEGA_SUBMARINE_FLEET_OFFSET)
	end

	local var3_11 = var1_11[var2_11]
	local var4_11 = arg0_11:GetFleetEditPanel()

	var4_11.buffer:SetSettings(1, 1, false, var0_11.property_limitation, var2_11)
	var4_11.buffer:SetFleets({
		var1_11[var2_11],
		var1_11[var2_11 + Fleet.MEGA_SUBMARINE_FLEET_OFFSET]
	})
	var4_11.buffer:SetOilLimit(var0_11.use_oil_limit)

	arg0_11.contextData.editFleet = var2_11

	var4_11.buffer:UpdateView()
	var4_11.buffer:Show()
end

function var0_0._commitEdit_(arg0_12)
	arg0_12:emit(arg0_12._IFleetSelect._mediatorClass_.ON_COMMIT_FLEET)
end

function var0_0._commitCombat_(arg0_13)
	arg0_13:emit(arg0_13._IFleetSelect._mediatorClass_.ON_PRECOMBAT, arg0_13.contextData.editFleet)
end

function var0_0._updateEditPanel_(arg0_14)
	if arg0_14._IFleetSelect.fleetEditPanel then
		arg0_14._IFleetSelect.fleetEditPanel.buffer:UpdateView()
	end
end

function var0_0._hideFleetEdit_(arg0_15)
	if arg0_15._IFleetSelect.fleetEditPanel then
		arg0_15._IFleetSelect.fleetEditPanel.buffer:Hide()
		arg0_15:show()
	end

	arg0_15.contextData.editFleet = nil
end

function var0_0._openShipInfo_(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.contextData.actFleets[arg2_16]
	local var1_16 = {}
	local var2_16 = getProxy(BayProxy)

	for iter0_16, iter1_16 in ipairs(var0_16 and var0_16.ships or {}) do
		table.insert(var1_16, var2_16:getShipById(iter1_16))
	end

	arg0_16:emit(arg0_16._IFleetSelect._mediatorClass_.ON_FLEET_SHIPINFO, {
		shipId = arg1_16,
		shipVOs = var1_16
	})
end

function var0_0._setCommanderPrefabs_(arg0_17, arg1_17)
	arg0_17._IFleetSelect.commanderPrefabs = arg1_17
end

function var0_0._openCommanderPanel_(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.contextData.activityID

	arg0_18._IFleetSelect.levelCMDFormationView:setCallback(function(arg0_19)
		if arg0_19.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_18:emit(arg0_18._IFleetSelect._mediatorClass_.ON_COMMANDER_SKILL, arg0_19.skill)
		elseif arg0_19.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_18.contextData.eliteCommanderSelected = {
				fleetIndex = arg2_18,
				cmdPos = arg0_19.pos,
				mode = arg0_18.curMode
			}

			arg0_18:emit(arg0_18._IFleetSelect._mediatorClass_.ON_SELECT_COMMANDER, arg2_18, arg0_19.pos)
		else
			arg0_18:emit(arg0_18._IFleetSelect._mediatorClass_.COMMANDER_FORMATION_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_ACTIVITY,
				data = arg0_19,
				fleetId = arg1_18.id,
				actId = var0_18
			})
		end
	end)
	arg0_18._IFleetSelect.levelCMDFormationView:Load()
	arg0_18._IFleetSelect.levelCMDFormationView:ActionInvoke("update", arg1_18, arg0_18._IFleetSelect.commanderPrefabs)
	arg0_18._IFleetSelect.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0._updateCommanderFleet_(arg0_20, arg1_20)
	if arg0_20._IFleetSelect.levelCMDFormationView:isShowing() then
		arg0_20._IFleetSelect.levelCMDFormationView:ActionInvoke("updateFleet", arg1_20)
	end
end

function var0_0._updateCommanderPrefab_(arg0_21)
	if arg0_21._IFleetSelect.levelCMDFormationView:isShowing() then
		arg0_21._IFleetSelect.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_21._IFleetSelect.commanderPrefabs)
	end
end

function var0_0._closeCommanderPanel_(arg0_22)
	if arg0_22._IFleetSelect.levelCMDFormationView:isShowing() then
		arg0_22._IFleetSelect.levelCMDFormationView:ActionInvoke("Hide")
	end
end

function var0_0._CreateNewFleet_(arg0_23)
	return TypedFleet.New({
		id = arg0_23,
		ship_list = {},
		commanders = {},
		fleetType = arg0_23 > Fleet.MEGA_SUBMARINE_FLEET_OFFSET and FleetType.Submarine or FleetType.Normal
	})
end

return var0_0
