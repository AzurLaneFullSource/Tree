ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleAttr
local var4_0 = var0_0.Battle.BattleConst
local var5_0 = var4_0.EquipmentType
local var6_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattlePlayerUnit = class("BattlePlayerUnit", var0_0.Battle.BattleUnit)
var0_0.Battle.BattlePlayerUnit.__name = "BattlePlayerUnit"

local var7_0 = var0_0.Battle.BattlePlayerUnit

function var7_0.Ctor(arg0_1, arg1_1, arg2_1)
	var7_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._type = var4_0.UnitType.PLAYER_UNIT
end

function var7_0.Retreat(arg0_2)
	var7_0.super.Retreat(arg0_2)
	arg0_2:SetDeathReason(var4_0.UnitDeathReason.LEAVE)
	arg0_2:DeacActionClear()
	arg0_2._battleProxy:ShutdownPlayerUnit(arg0_2:GetUniqueID())
	arg0_2._battleProxy:KillUnit(arg0_2:GetUniqueID())
end

function var7_0.DeadActionEvent(arg0_3)
	arg0_3:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.WILL_DIE, {}))
	arg0_3:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.SHUT_DOWN_PLAYER, {}))
	arg0_3._unitState:ChangeState(var0_0.Battle.UnitState.STATE_DEAD)
end

function var7_0.IsSpectre(arg0_4)
	local var0_4
	local var1_4 = var0_0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY

	if arg0_4:GetAttr()[var1_4] ~= nil then
		var0_4 = arg0_4:GetAttrByName(var1_4)
	else
		var0_4 = var6_0.PLAYER_DEFAULT
	end

	return var0_4 <= var6_0.SPECTRE_UNIT_TYPE, var0_4
end

function var7_0.InitCurrentHP(arg0_5, arg1_5)
	arg0_5:SetCurrentHP(math.ceil(arg0_5:GetMaxHP() * arg1_5))
	arg0_5:TriggerBuff(var4_0.BuffEffectType.ON_HP_RATIO_UPDATE, {})
end

function var7_0.SetSkinId(arg0_6, arg1_6)
	arg0_6._skinId = arg1_6
end

function var7_0.GetSkinID(arg0_7)
	return arg0_7._skinId
end

function var7_0.GetDefaultSkinID(arg0_8)
	return arg0_8._tmpData.skin_id
end

function var7_0.ActionKeyOffsetUseable(arg0_9)
	return arg0_9._skinData.spine_action_offset
end

function var7_0.GetShipName(arg0_10)
	return arg0_10._shipName or arg0_10._tmpData.name
end

function var7_0.SetShipName(arg0_11, arg1_11)
	arg0_11._shipName = arg1_11
end

function var7_0.SetTemplate(arg0_12, arg1_12, arg2_12, arg3_12)
	var7_0.super.SetTemplate(arg0_12, arg1_12)

	arg0_12._tmpData = var1_0.GetPlayerShipTmpDataFromID(arg0_12._tmpID)

	arg0_12:configWeaponQueueParallel()
	arg0_12:overrideWeaponInfo()
	arg0_12:overrideSkin(arg0_12._skinId, true)
	arg0_12:InitCldComponent()

	arg2_12.armorType = arg0_12._tmpData.armor_type

	arg0_12:setAttrFromOutBattle(arg2_12, arg3_12)
	var3_0.InitDOTAttr(arg0_12._attr, arg0_12._tmpData)

	arg0_12._personality = var1_0.GetShipPersonality(2)

	for iter0_12, iter1_12 in ipairs(arg0_12._tmpData.tag_list) do
		arg0_12:AddLabelTag(iter1_12)
	end

	arg0_12:setStandardLabelTag()
end

function var7_0.overrideSkin(arg0_13, arg1_13, arg2_13)
	arg0_13._skinData = var1_0.GetPlayerShipSkinDataFromID(arg1_13)

	local var0_13 = {
		"prefab",
		"fx_container",
		"bound_bone",
		"smoke"
	}

	if arg2_13 then
		var0_13[#var0_13 + 1] = "painting"
	end

	_.each(var0_13, function(arg0_14)
		arg0_13._tmpData[arg0_14] = arg0_13._skinData[arg0_14]
	end)
end

function var7_0.overrideWeaponInfo(arg0_15, arg1_15, arg2_15)
	if arg0_15._overrideBaseInfo then
		arg0_15._tmpData.base_list = arg0_15._overrideBaseInfo
	end

	if arg0_15._overridePreloadInfo then
		arg0_15._tmpData.preload_count = arg0_15._overridePreloadInfo
	end
end

function var7_0.SetWeaponInfo(arg0_16, arg1_16, arg2_16)
	arg0_16._overrideBaseInfo = arg1_16
	arg0_16._overridePreloadInfo = arg2_16
end

function var7_0.SetRarity(arg0_17, arg1_17)
	arg0_17._rarity = arg1_17
end

function var7_0.SetIntimacy(arg0_18, arg1_18)
	arg0_18._intimacy = arg1_18
end

function var7_0.setWeapon(arg0_19, arg1_19)
	local var0_19 = arg0_19._tmpData.default_equip_list
	local var1_19 = arg0_19._tmpData.base_list
	local var2_19 = arg0_19._proficiencyList
	local var3_19 = arg0_19._tmpData.preload_count

	for iter0_19, iter1_19 in ipairs(arg1_19) do
		if iter1_19 and iter1_19.skin and iter1_19.skin ~= 0 and Equipment.IsOrbitSkin(iter1_19.skin) then
			arg0_19._orbitSkinIDList = arg0_19._orbitSkinIDList or {}

			table.insert(arg0_19._orbitSkinIDList, iter1_19.skin)
		end

		if iter0_19 <= Ship.WEAPON_COUNT then
			local var4_19 = var2_19[iter0_19]
			local var5_19 = var3_19[iter0_19]

			local function var6_19(arg0_20, arg1_20, arg2_20)
				local var0_20 = var1_19[iter0_19]

				for iter0_20 = 1, var0_20 do
					local var1_20 = arg0_19:AddWeapon(arg0_20, arg1_20, arg2_20, var4_19, iter0_19)
					local var2_20 = var1_20:GetTemplateData().type

					if iter0_20 <= var5_19 and (var2_20 == var5_0.POINT_HIT_AND_LOCK or var2_20 == var5_0.MANUAL_MISSILE or var2_20 == var5_0.MANUAL_METEOR or var2_20 == var5_0.MANUAL_TORPEDO or var2_20 == var5_0.DISPOSABLE_TORPEDO) then
						var1_20:SetModifyInitialCD()
					end

					if iter1_19.equipment then
						var1_20:SetSrcEquipmentID(iter1_19.equipment.id)
					end
				end
			end

			if iter1_19.equipment and #iter1_19.equipment.weapon_id > 0 then
				local var7_19 = iter1_19.equipment.weapon_id

				for iter2_19, iter3_19 in ipairs(var7_19) do
					local var8_19 = var1_0.GetWeaponPropertyDataFromID(iter3_19).type
					local var9_19 = var6_0.EQUIPMENT_ACTIVE_LIMITED_BY_TYPE[var8_19]

					if (not var9_19 or table.contains(var9_19, arg0_19._tmpData.type)) and iter3_19 and iter3_19 ~= -1 then
						var6_19(iter3_19, iter1_19.equipment.label, iter1_19.skin)
					end
				end
			else
				local var10_19 = var0_19[iter0_19]
				local var11_19 = var1_0.GetWeaponDataFromID(var10_19)

				var6_19(var10_19, var11_19.label)
			end
		end
	end

	local var12_19 = #var0_19
	local var13_19 = arg0_19._tmpData.fix_equip_list

	for iter4_19, iter5_19 in ipairs(var13_19) do
		if iter5_19 and iter5_19 ~= -1 then
			local var14_19 = var2_19[iter4_19 + var12_19] or 1

			arg0_19:AddWeapon(iter5_19, nil, nil, var14_19, iter4_19 + var12_19):SetFixedFlag()
		end
	end

	if arg0_19:CanDoAntiSub() then
		local var15_19 = {}

		for iter6_19 = Ship.WEAPON_COUNT + 1, #arg1_19 do
			local var16_19 = arg1_19[iter6_19]

			if var16_19 and var16_19.equipment and #var16_19.equipment.weapon_id > 0 then
				var15_19[#var15_19 + 1] = var16_19.equipment.weapon_id[1]
			end
		end

		for iter7_19, iter8_19 in ipairs(arg0_19._tmpData.depth_charge_list) do
			var15_19[#var15_19 + 1] = iter8_19
		end

		local var17_19 = 20
		local var18_19 = 1

		for iter9_19, iter10_19 in ipairs(var15_19) do
			local var19_19 = var1_0.CreateWeaponUnit(iter10_19, arg0_19, var18_19, var17_19)

			arg0_19:AddAutoWeapon(var19_19)
		end
	end
end

function var7_0.SetPriorityWeaponSkin(arg0_21, arg1_21)
	if not arg0_21._priorityWeaponSkinID then
		arg0_21._priorityWeaponSkinID = arg1_21
	end
end

function var7_0.GetPriorityWeaponSkin(arg0_22)
	return arg0_22._priorityWeaponSkinID
end

function var7_0.AddWeapon(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23, arg5_23, arg6_23)
	local var0_23 = var1_0.CreateWeaponUnit(arg1_23, arg0_23, arg4_23, arg5_23)

	arg0_23._totalWeapon[#arg0_23._totalWeapon + 1] = var0_23

	if arg2_23 then
		var0_23:SetEquipmentLabel(arg2_23)
	end

	local var1_23 = var0_23:GetTemplateData().type

	if var1_23 == var5_0.POINT_HIT_AND_LOCK or var1_23 == var5_0.MANUAL_METEOR or var1_23 == var5_0.MANUAL_MISSILE then
		arg0_23._chargeList[#arg0_23._chargeList + 1] = var0_23

		arg0_23._weaponQueue:AppendChargeWeapon(var0_23)
	elseif var1_23 == var5_0.MANUAL_TORPEDO or var1_23 == var5_0.DISPOSABLE_TORPEDO or var1_23 == var5_0.MANUAL_AAMISSILE then
		arg0_23._manualTorpedoList[#arg0_23._manualTorpedoList + 1] = var0_23

		arg0_23._weaponQueue:AppendManualTorpedo(var0_23)
	elseif var1_23 == var5_0.STRIKE_AIRCRAFT then
		-- block empty
	elseif var1_23 == var5_0.FLEET_ANTI_AIR then
		arg0_23:AddFleetAntiAirWeapon(var0_23)
	elseif var1_23 == var5_0.FLEET_RANGE_ANTI_AIR then
		arg0_23:AddFleetRangeAntiAirWeapon(var0_23)
	else
		arg0_23:AddAutoWeapon(var0_23)
	end

	if var1_23 == var5_0.STRIKE_AIRCRAFT then
		arg0_23._hiveList[#arg0_23._hiveList + 1] = var0_23
	end

	if var1_23 == var5_0.ANTI_AIR then
		arg0_23._AAList[#arg0_23._AAList + 1] = var0_23
	end

	if arg3_23 and arg3_23 ~= 0 then
		var0_23:SetSkinData(arg3_23)
		arg0_23:SetPriorityWeaponSkin(arg3_23)
	end

	return var0_23
end

function var7_0.RemoveWeapon(arg0_24, arg1_24)
	local var0_24 = var1_0.GetWeaponPropertyDataFromID(arg1_24).type
	local var1_24

	if var0_24 == var5_0.STRIKE_AIRCRAFT then
		for iter0_24, iter1_24 in ipairs(arg0_24._hiveList) do
			if iter1_24:GetWeaponId() == arg1_24 then
				var1_24 = iter1_24

				table.remove(arg0_24._hiveList, iter0_24)

				break
			end
		end
	elseif var0_24 == var5_0.POINT_HIT_AND_LOCK or var0_24 == var5_0.MANUAL_METEOR or var0_24 == var5_0.MANUAL_MISSILE then
		-- block empty
	elseif var0_24 == var5_0.MANUAL_TORPEDO then
		for iter2_24, iter3_24 in ipairs(arg0_24._manualTorpedoList) do
			if iter3_24:GetWeaponId() == arg1_24 then
				var1_24 = iter3_24

				table.remove(arg0_24._manualTorpedoList, iter2_24)
				arg0_24._weaponQueue:RemoveManualTorpedo(iter3_24)

				break
			end
		end
	elseif var0_24 == var5_0.FLEET_ANTI_AIR then
		for iter4_24, iter5_24 in ipairs(arg0_24._fleetAAList) do
			if iter5_24:GetWeaponId() == arg1_24 then
				arg0_24:RemoveFleetAntiAirWeapon(iter5_24)

				break
			end
		end
	else
		for iter6_24, iter7_24 in ipairs(arg0_24._autoWeaponList) do
			if iter7_24:GetWeaponId() == arg1_24 then
				var1_24 = iter7_24

				var1_24:Clear()
				arg0_24:RemoveAutoWeapon(var1_24)

				break
			end
		end
	end

	if var1_24 then
		for iter8_24, iter9_24 in ipairs(arg0_24._totalWeapon) do
			if iter9_24 == var1_24 then
				table.remove(arg0_24._totalWeapon, iter8_24)

				break
			end
		end
	end

	return var1_24
end

function var7_0.RemoveWeaponByLabel(arg0_25, arg1_25)
	local var0_25

	for iter0_25, iter1_25 in ipairs(arg0_25._totalWeapon) do
		local var1_25 = true

		for iter2_25, iter3_25 in ipairs(arg1_25) do
			local var2_25 = iter1_25:GetEquipmentLabel()

			var1_25 = var1_25 and table.contains(var2_25, iter3_25)
		end

		if var1_25 then
			var0_25 = iter1_25

			table.remove(arg0_25._totalWeapon, iter0_25)
		end
	end

	if not var0_25 then
		return
	end

	local var3_25 = var0_25:GetType()

	if var3_25 == var5_0.STRIKE_AIRCRAFT then
		for iter4_25, iter5_25 in ipairs(arg0_25._hiveList) do
			if var0_25 == iter5_25 then
				table.remove(arg0_25._hiveList, iter4_25)

				break
			end
		end
	elseif var3_25 == var5_0.POINT_HIT_AND_LOCK or var3_25 == var5_0.MANUAL_METEOR or var3_25 == var5_0.MANUAL_MISSILE then
		-- block empty
	elseif var3_25 == var5_0.MANUAL_TORPEDO then
		for iter6_25, iter7_25 in ipairs(arg0_25._manualTorpedoList) do
			if var0_25 == iter7_25 then
				table.remove(arg0_25._manualTorpedoList, iter6_25)
				arg0_25._weaponQueue:RemoveManualTorpedo(iter7_25)

				break
			end
		end
	elseif var3_25 == var5_0.FLEET_ANTI_AIR then
		for iter8_25, iter9_25 in ipairs(arg0_25._fleetAAList) do
			if var0_25 == iter9_25 then
				arg0_25:RemoveFleetAntiAirWeapon(iter9_25)

				break
			end
		end
	elseif var3_25 == var5_0.INTERCEPT_AIRCRAFT then
		for iter10_25, iter11_25 in ipairs(arg0_25._autoWeaponList) do
			if var0_25 == iter11_25 then
				arg0_25:RemoveAutoWeapon(var0_25)

				break
			end
		end
	else
		for iter12_25, iter13_25 in ipairs(arg0_25._autoWeaponList) do
			if var0_25 == iter13_25 then
				arg0_25:RemoveAutoWeapon(var0_25)

				break
			end
		end
	end

	return var0_25
end

function var7_0.AddFleetAntiAirWeapon(arg0_26, arg1_26)
	arg0_26._fleetAAList[#arg0_26._fleetAAList + 1] = arg1_26
end

function var7_0.RemoveFleetAntiAirWeapon(arg0_27, arg1_27)
	for iter0_27, iter1_27 in ipairs(arg0_27._fleetAAList) do
		if iter1_27 == arg1_27 then
			table.remove(arg0_27._fleetAAList, iter0_27)

			return
		end
	end
end

function var7_0.AddFleetRangeAntiAirWeapon(arg0_28, arg1_28)
	arg0_28._fleetRangeAAList[#arg0_28._fleetRangeAAList + 1] = arg1_28
end

function var7_0.RemoveFleetRangeAntiAirWeapon(arg0_29, arg1_29)
	for iter0_29, iter1_29 in ipairs(arg0_29._fleetRangeAAList) do
		if iter1_29 == arg1_29 then
			table.remove(arg0_29._fleetRangeAAList, iter0_29)

			return
		end
	end
end

function var7_0.ShiftWeapon(arg0_30, arg1_30)
	return
end

function var7_0.GetManualWeaponParallel(arg0_31)
	return arg0_31._tmpData.parallel_max
end

function var7_0.CeaseAllWeapon(arg0_32, arg1_32)
	if arg1_32 then
		for iter0_32, iter1_32 in ipairs(arg0_32._totalWeapon) do
			iter1_32:Cease()
		end

		local var0_32 = arg0_32._buffList

		for iter2_32, iter3_32 in pairs(var0_32) do
			iter3_32:Interrupt()
		end
	end

	var7_0.super.CeaseAllWeapon(arg0_32, arg1_32)
end

function var7_0.LeaderSetting(arg0_33)
	local var0_33 = arg0_33:GetIntimacy()
	local var1_33 = var1_0.GetWords(arg0_33:GetSkinID(), "hp_warning", var0_33)

	if var1_33 and var1_33 ~= "" then
		arg0_33._warningValue = var6_0.WARNING_HP_RATE * arg0_33:GetMaxHP()
	end
end

function var7_0.UpdateHP(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	local var0_34 = var7_0.super.UpdateHP(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)

	if arg0_34._warningValue and arg0_34._currentHP < arg0_34._warningValue and not isHeal then
		arg0_34._warningValue = nil

		local var1_34 = arg0_34:GetIntimacy()
		local var2_34 = "hp_warning"
		local var3_34 = var1_0.GetWords(arg0_34:GetSkinID(), var2_34, var1_34)

		arg0_34:DispatchVoice(var2_34)
		arg0_34:DispatchChat(var3_34, 2.5, var2_34)
	end

	if arg0_34._mainUnitWarningValue and arg0_34._currentHP < arg0_34._mainUnitWarningValue and arg0_34._currentHP > 0 and not isHeal then
		arg0_34._mainUnitWarningValue = nil

		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_main_emergent", arg0_34:GetShipName()))
	end

	return var0_34
end

function var7_0.SetMainFleetUnit(arg0_35)
	var7_0.super.SetMainFleetUnit(arg0_35)

	if arg0_35._IFF == var6_0.FRIENDLY_CODE then
		arg0_35._mainUnitWarningValue = var6_0.WARNING_HP_RATE_MAIN * arg0_35:GetMaxHP()
	end
end

function var7_0.UpdatePrecastMoveLimit(arg0_36)
	return
end

function var7_0.setStandardLabelTag(arg0_37)
	var7_0.super.setStandardLabelTag(arg0_37)

	local var0_37 = arg0_37:GetManualWeaponParallel()
	local var1_37 = #var0_37

	while var1_37 > 0 do
		if var0_37[var1_37] > 1 then
			print(var4_0.PARALLEL_LABEL_TAG[var1_37])
			arg0_37:AddLabelTag(var4_0.PARALLEL_LABEL_TAG[var1_37])
		end

		var1_37 = var1_37 - 1
	end
end

function var7_0.ConfigBubbleFX(arg0_38)
	arg0_38._bubbleFX = var6_0.PLAYER_SUB_BUBBLE_FX

	arg0_38._oxyState:SetBubbleTemplate(var6_0.PLAYER_SUB_BUBBLE_INIT, var6_0.PLAYER_SUB_BUBBLE_INTERVAL)
end

function var7_0.OxyConsume(arg0_39)
	var7_0.super.OxyConsume(arg0_39)

	if arg0_39._currentOxy <= 0 then
		arg0_39._fleet:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_FLOAT, true)
	end
end

function var7_0.SetFormationIndex(arg0_40, arg1_40)
	arg0_40._formationIndex = arg1_40
end

function var7_0.setAttrFromOutBattle(arg0_41, arg1_41, arg2_41)
	var3_0.SetPlayerAttrFromOutBattle(arg0_41, arg1_41, arg2_41)
end

function var7_0.SetFleetVO(arg0_42, arg1_42)
	arg0_42._fleet = arg1_42
	arg0_42._subRaidLine, arg0_42._subRetreatLine = arg0_42._fleet:GetSubmarineBaseLine()
end

function var7_0.GetTemplate(arg0_43)
	return arg0_43._tmpData
end

function var7_0.GetRarity(arg0_44)
	return arg0_44._rarity or arg0_44._tmpData.rarity
end

function var7_0.GetIntimacy(arg0_45)
	return arg0_45._intimacy or 0
end

function var7_0.GetAutoPilotPreference(arg0_46)
	return arg0_46._personality
end

function var7_0.GetFleetVO(arg0_47)
	return arg0_47._fleet
end

function var7_0.InitCldComponent(arg0_48)
	var7_0.super.InitCldComponent(arg0_48)

	local var0_48 = {
		type = var4_0.CldType.SHIP,
		IFF = arg0_48:GetIFF(),
		UID = arg0_48:GetUniqueID(),
		Mass = var4_0.CldMass.L2
	}

	arg0_48._cldComponent:SetCldData(var0_48)
end
