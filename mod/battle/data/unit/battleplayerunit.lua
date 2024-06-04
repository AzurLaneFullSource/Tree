ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleAttr
local var4 = var0.Battle.BattleConst
local var5 = var4.EquipmentType
local var6 = var0.Battle.BattleConfig

var0.Battle.BattlePlayerUnit = class("BattlePlayerUnit", var0.Battle.BattleUnit)
var0.Battle.BattlePlayerUnit.__name = "BattlePlayerUnit"

local var7 = var0.Battle.BattlePlayerUnit

function var7.Ctor(arg0, arg1, arg2)
	var7.super.Ctor(arg0, arg1, arg2)

	arg0._type = var4.UnitType.PLAYER_UNIT
end

function var7.Retreat(arg0)
	var7.super.Retreat(arg0)
	arg0:SetDeathReason(var4.UnitDeathReason.LEAVE)
	arg0:DeacActionClear()
	arg0._battleProxy:ShutdownPlayerUnit(arg0:GetUniqueID())
	arg0._battleProxy:KillUnit(arg0:GetUniqueID())
end

function var7.DeadActionEvent(arg0)
	arg0:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.WILL_DIE, {}))
	arg0:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.SHUT_DOWN_PLAYER, {}))
	arg0._unitState:ChangeState(var0.Battle.UnitState.STATE_DEAD)
end

function var7.IsSpectre(arg0)
	local var0
	local var1 = var0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY

	if arg0:GetAttr()[var1] ~= nil then
		var0 = arg0:GetAttrByName(var1)
	else
		var0 = var6.PLAYER_DEFAULT
	end

	return var0 <= var6.SPECTRE_UNIT_TYPE, var0
end

function var7.InitCurrentHP(arg0, arg1)
	arg0:SetCurrentHP(math.ceil(arg0:GetMaxHP() * arg1))
	arg0:TriggerBuff(var4.BuffEffectType.ON_HP_RATIO_UPDATE, {})
end

function var7.SetSkinId(arg0, arg1)
	arg0._skinId = arg1
end

function var7.GetSkinID(arg0)
	return arg0._skinId
end

function var7.GetDefaultSkinID(arg0)
	return arg0._tmpData.skin_id
end

function var7.ActionKeyOffsetUseable(arg0)
	return arg0._skinData.spine_action_offset
end

function var7.GetShipName(arg0)
	return arg0._shipName or arg0._tmpData.name
end

function var7.SetShipName(arg0, arg1)
	arg0._shipName = arg1
end

function var7.SetTemplate(arg0, arg1, arg2, arg3)
	var7.super.SetTemplate(arg0, arg1)

	arg0._tmpData = var1.GetPlayerShipTmpDataFromID(arg0._tmpID)

	arg0:configWeaponQueueParallel()
	arg0:overrideWeaponInfo()
	arg0:overrideSkin(arg0._skinId, true)
	arg0:InitCldComponent()

	arg2.armorType = arg0._tmpData.armor_type

	arg0:setAttrFromOutBattle(arg2, arg3)
	var3.InitDOTAttr(arg0._attr, arg0._tmpData)

	arg0._personality = var1.GetShipPersonality(2)

	for iter0, iter1 in ipairs(arg0._tmpData.tag_list) do
		arg0:AddLabelTag(iter1)
	end

	arg0:setStandardLabelTag()
end

function var7.overrideSkin(arg0, arg1, arg2)
	arg0._skinData = var1.GetPlayerShipSkinDataFromID(arg1)

	local var0 = {
		"prefab",
		"fx_container",
		"bound_bone",
		"smoke"
	}

	if arg2 then
		var0[#var0 + 1] = "painting"
	end

	_.each(var0, function(arg0)
		arg0._tmpData[arg0] = arg0._skinData[arg0]
	end)
end

function var7.overrideWeaponInfo(arg0, arg1, arg2)
	if arg0._overrideBaseInfo then
		arg0._tmpData.base_list = arg0._overrideBaseInfo
	end

	if arg0._overridePreloadInfo then
		arg0._tmpData.preload_count = arg0._overridePreloadInfo
	end
end

function var7.SetWeaponInfo(arg0, arg1, arg2)
	arg0._overrideBaseInfo = arg1
	arg0._overridePreloadInfo = arg2
end

function var7.SetRarity(arg0, arg1)
	arg0._rarity = arg1
end

function var7.SetIntimacy(arg0, arg1)
	arg0._intimacy = arg1
end

function var7.setWeapon(arg0, arg1)
	local var0 = arg0._tmpData.default_equip_list
	local var1 = arg0._tmpData.base_list
	local var2 = arg0._proficiencyList
	local var3 = arg0._tmpData.preload_count

	for iter0, iter1 in ipairs(arg1) do
		if iter1 and iter1.skin and iter1.skin ~= 0 and Equipment.IsOrbitSkin(iter1.skin) then
			arg0._orbitSkinIDList = arg0._orbitSkinIDList or {}

			table.insert(arg0._orbitSkinIDList, iter1.skin)
		end

		if iter0 <= Ship.WEAPON_COUNT then
			local var4 = var2[iter0]
			local var5 = var3[iter0]

			local function var6(arg0, arg1, arg2)
				local var0 = var1[iter0]

				for iter0 = 1, var0 do
					local var1 = arg0:AddWeapon(arg0, arg1, arg2, var4, iter0)
					local var2 = var1:GetTemplateData().type

					if iter0 <= var5 and (var2 == var5.POINT_HIT_AND_LOCK or var2 == var5.MANUAL_MISSILE or var2 == var5.MANUAL_METEOR or var2 == var5.MANUAL_TORPEDO or var2 == var5.DISPOSABLE_TORPEDO) then
						var1:SetModifyInitialCD()
					end

					if iter1.equipment then
						var1:SetSrcEquipmentID(iter1.equipment.id)
					end
				end
			end

			if iter1.equipment and #iter1.equipment.weapon_id > 0 then
				local var7 = iter1.equipment.weapon_id

				for iter2, iter3 in ipairs(var7) do
					local var8 = var1.GetWeaponPropertyDataFromID(iter3).type
					local var9 = var6.EQUIPMENT_ACTIVE_LIMITED_BY_TYPE[var8]

					if (not var9 or table.contains(var9, arg0._tmpData.type)) and iter3 and iter3 ~= -1 then
						var6(iter3, iter1.equipment.label, iter1.skin)
					end
				end
			else
				local var10 = var0[iter0]
				local var11 = var1.GetWeaponDataFromID(var10)

				var6(var10, var11.label)
			end
		end
	end

	local var12 = #var0
	local var13 = arg0._tmpData.fix_equip_list

	for iter4, iter5 in ipairs(var13) do
		if iter5 and iter5 ~= -1 then
			local var14 = var2[iter4 + var12] or 1

			arg0:AddWeapon(iter5, nil, nil, var14, iter4 + var12):SetFixedFlag()
		end
	end

	if arg0:CanDoAntiSub() then
		local var15 = {}

		for iter6 = Ship.WEAPON_COUNT + 1, #arg1 do
			local var16 = arg1[iter6]

			if var16 and var16.equipment and #var16.equipment.weapon_id > 0 then
				var15[#var15 + 1] = var16.equipment.weapon_id[1]
			end
		end

		for iter7, iter8 in ipairs(arg0._tmpData.depth_charge_list) do
			var15[#var15 + 1] = iter8
		end

		local var17 = 20
		local var18 = 1

		for iter9, iter10 in ipairs(var15) do
			local var19 = var1.CreateWeaponUnit(iter10, arg0, var18, var17)

			arg0:AddAutoWeapon(var19)
		end
	end
end

function var7.SetPriorityWeaponSkin(arg0, arg1)
	if not arg0._priorityWeaponSkinID then
		arg0._priorityWeaponSkinID = arg1
	end
end

function var7.GetPriorityWeaponSkin(arg0)
	return arg0._priorityWeaponSkinID
end

function var7.AddWeapon(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = var1.CreateWeaponUnit(arg1, arg0, arg4, arg5)

	arg0._totalWeapon[#arg0._totalWeapon + 1] = var0

	if arg2 then
		var0:SetEquipmentLabel(arg2)
	end

	local var1 = var0:GetTemplateData().type

	if var1 == var5.POINT_HIT_AND_LOCK or var1 == var5.MANUAL_METEOR or var1 == var5.MANUAL_MISSILE then
		arg0._chargeList[#arg0._chargeList + 1] = var0

		arg0._weaponQueue:AppendChargeWeapon(var0)
	elseif var1 == var5.MANUAL_TORPEDO or var1 == var5.DISPOSABLE_TORPEDO or var1 == var5.MANUAL_AAMISSILE then
		arg0._manualTorpedoList[#arg0._manualTorpedoList + 1] = var0

		arg0._weaponQueue:AppendManualTorpedo(var0)
	elseif var1 == var5.STRIKE_AIRCRAFT then
		-- block empty
	elseif var1 == var5.FLEET_ANTI_AIR then
		arg0:AddFleetAntiAirWeapon(var0)
	elseif var1 == var5.FLEET_RANGE_ANTI_AIR then
		arg0:AddFleetRangeAntiAirWeapon(var0)
	else
		arg0:AddAutoWeapon(var0)
	end

	if var1 == var5.STRIKE_AIRCRAFT then
		arg0._hiveList[#arg0._hiveList + 1] = var0
	end

	if var1 == var5.ANTI_AIR then
		arg0._AAList[#arg0._AAList + 1] = var0
	end

	if arg3 and arg3 ~= 0 then
		var0:SetSkinData(arg3)
		arg0:SetPriorityWeaponSkin(arg3)
	end

	return var0
end

function var7.RemoveWeapon(arg0, arg1)
	local var0 = var1.GetWeaponPropertyDataFromID(arg1).type
	local var1

	if var0 == var5.STRIKE_AIRCRAFT then
		for iter0, iter1 in ipairs(arg0._hiveList) do
			if iter1:GetWeaponId() == arg1 then
				var1 = iter1

				table.remove(arg0._hiveList, iter0)

				break
			end
		end
	elseif var0 == var5.POINT_HIT_AND_LOCK or var0 == var5.MANUAL_METEOR or var0 == var5.MANUAL_MISSILE then
		-- block empty
	elseif var0 == var5.MANUAL_TORPEDO then
		for iter2, iter3 in ipairs(arg0._manualTorpedoList) do
			if iter3:GetWeaponId() == arg1 then
				var1 = iter3

				table.remove(arg0._manualTorpedoList, iter2)
				arg0._weaponQueue:RemoveManualTorpedo(iter3)

				break
			end
		end
	elseif var0 == var5.FLEET_ANTI_AIR then
		for iter4, iter5 in ipairs(arg0._fleetAAList) do
			if iter5:GetWeaponId() == arg1 then
				arg0:RemoveFleetAntiAirWeapon(iter5)

				break
			end
		end
	else
		for iter6, iter7 in ipairs(arg0._autoWeaponList) do
			if iter7:GetWeaponId() == arg1 then
				var1 = iter7

				var1:Clear()
				arg0:RemoveAutoWeapon(var1)

				break
			end
		end
	end

	if var1 then
		for iter8, iter9 in ipairs(arg0._totalWeapon) do
			if iter9 == var1 then
				table.remove(arg0._totalWeapon, iter8)

				break
			end
		end
	end

	return var1
end

function var7.RemoveWeaponByLabel(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg0._totalWeapon) do
		local var1 = true

		for iter2, iter3 in ipairs(arg1) do
			local var2 = iter1:GetEquipmentLabel()

			var1 = var1 and table.contains(var2, iter3)
		end

		if var1 then
			var0 = iter1

			table.remove(arg0._totalWeapon, iter0)
		end
	end

	if not var0 then
		return
	end

	local var3 = var0:GetType()

	if var3 == var5.STRIKE_AIRCRAFT then
		for iter4, iter5 in ipairs(arg0._hiveList) do
			if var0 == iter5 then
				table.remove(arg0._hiveList, iter4)

				break
			end
		end
	elseif var3 == var5.POINT_HIT_AND_LOCK or var3 == var5.MANUAL_METEOR or var3 == var5.MANUAL_MISSILE then
		-- block empty
	elseif var3 == var5.MANUAL_TORPEDO then
		for iter6, iter7 in ipairs(arg0._manualTorpedoList) do
			if var0 == iter7 then
				table.remove(arg0._manualTorpedoList, iter6)
				arg0._weaponQueue:RemoveManualTorpedo(iter7)

				break
			end
		end
	elseif var3 == var5.FLEET_ANTI_AIR then
		for iter8, iter9 in ipairs(arg0._fleetAAList) do
			if var0 == iter9 then
				arg0:RemoveFleetAntiAirWeapon(iter9)

				break
			end
		end
	elseif var3 == var5.INTERCEPT_AIRCRAFT then
		for iter10, iter11 in ipairs(arg0._autoWeaponList) do
			if var0 == iter11 then
				arg0:RemoveAutoWeapon(var0)

				break
			end
		end
	else
		for iter12, iter13 in ipairs(arg0._autoWeaponList) do
			if var0 == iter13 then
				arg0:RemoveAutoWeapon(var0)

				break
			end
		end
	end

	return var0
end

function var7.AddFleetAntiAirWeapon(arg0, arg1)
	arg0._fleetAAList[#arg0._fleetAAList + 1] = arg1
end

function var7.RemoveFleetAntiAirWeapon(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._fleetAAList) do
		if iter1 == arg1 then
			table.remove(arg0._fleetAAList, iter0)

			return
		end
	end
end

function var7.AddFleetRangeAntiAirWeapon(arg0, arg1)
	arg0._fleetRangeAAList[#arg0._fleetRangeAAList + 1] = arg1
end

function var7.RemoveFleetRangeAntiAirWeapon(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._fleetRangeAAList) do
		if iter1 == arg1 then
			table.remove(arg0._fleetRangeAAList, iter0)

			return
		end
	end
end

function var7.ShiftWeapon(arg0, arg1)
	return
end

function var7.GetManualWeaponParallel(arg0)
	return arg0._tmpData.parallel_max
end

function var7.CeaseAllWeapon(arg0, arg1)
	if arg1 then
		for iter0, iter1 in ipairs(arg0._totalWeapon) do
			iter1:Cease()
		end

		local var0 = arg0._buffList

		for iter2, iter3 in pairs(var0) do
			iter3:Interrupt()
		end
	end

	var7.super.CeaseAllWeapon(arg0, arg1)
end

function var7.LeaderSetting(arg0)
	local var0 = arg0:GetIntimacy()
	local var1 = var1.GetWords(arg0:GetSkinID(), "hp_warning", var0)

	if var1 and var1 ~= "" then
		arg0._warningValue = var6.WARNING_HP_RATE * arg0:GetMaxHP()
	end
end

function var7.UpdateHP(arg0, arg1, arg2, arg3, arg4)
	local var0 = var7.super.UpdateHP(arg0, arg1, arg2, arg3, arg4)

	if arg0._warningValue and arg0._currentHP < arg0._warningValue and not isHeal then
		arg0._warningValue = nil

		local var1 = arg0:GetIntimacy()
		local var2 = "hp_warning"
		local var3 = var1.GetWords(arg0:GetSkinID(), var2, var1)

		arg0:DispatchVoice(var2)
		arg0:DispatchChat(var3, 2.5, var2)
	end

	if arg0._mainUnitWarningValue and arg0._currentHP < arg0._mainUnitWarningValue and arg0._currentHP > 0 and not isHeal then
		arg0._mainUnitWarningValue = nil

		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_main_emergent", arg0:GetShipName()))
	end

	return var0
end

function var7.SetMainFleetUnit(arg0)
	var7.super.SetMainFleetUnit(arg0)

	if arg0._IFF == var6.FRIENDLY_CODE then
		arg0._mainUnitWarningValue = var6.WARNING_HP_RATE_MAIN * arg0:GetMaxHP()
	end
end

function var7.UpdatePrecastMoveLimit(arg0)
	return
end

function var7.setStandardLabelTag(arg0)
	var7.super.setStandardLabelTag(arg0)

	local var0 = arg0:GetManualWeaponParallel()
	local var1 = #var0

	while var1 > 0 do
		if var0[var1] > 1 then
			print(var4.PARALLEL_LABEL_TAG[var1])
			arg0:AddLabelTag(var4.PARALLEL_LABEL_TAG[var1])
		end

		var1 = var1 - 1
	end
end

function var7.ConfigBubbleFX(arg0)
	arg0._bubbleFX = var6.PLAYER_SUB_BUBBLE_FX

	arg0._oxyState:SetBubbleTemplate(var6.PLAYER_SUB_BUBBLE_INIT, var6.PLAYER_SUB_BUBBLE_INTERVAL)
end

function var7.OxyConsume(arg0)
	var7.super.OxyConsume(arg0)

	if arg0._currentOxy <= 0 then
		arg0._fleet:ChangeSubmarineState(var0.Battle.OxyState.STATE_FREE_FLOAT, true)
	end
end

function var7.SetFormationIndex(arg0, arg1)
	arg0._formationIndex = arg1
end

function var7.setAttrFromOutBattle(arg0, arg1, arg2)
	var3.SetPlayerAttrFromOutBattle(arg0, arg1, arg2)
end

function var7.SetFleetVO(arg0, arg1)
	arg0._fleet = arg1
	arg0._subRaidLine, arg0._subRetreatLine = arg0._fleet:GetSubmarineBaseLine()
end

function var7.GetTemplate(arg0)
	return arg0._tmpData
end

function var7.GetRarity(arg0)
	return arg0._rarity or arg0._tmpData.rarity
end

function var7.GetIntimacy(arg0)
	return arg0._intimacy or 0
end

function var7.GetAutoPilotPreference(arg0)
	return arg0._personality
end

function var7.GetFleetVO(arg0)
	return arg0._fleet
end

function var7.InitCldComponent(arg0)
	var7.super.InitCldComponent(arg0)

	local var0 = {
		type = var4.CldType.SHIP,
		IFF = arg0:GetIFF(),
		UID = arg0:GetUniqueID(),
		Mass = var4.CldMass.L2
	}

	arg0._cldComponent:SetCldData(var0)
end
