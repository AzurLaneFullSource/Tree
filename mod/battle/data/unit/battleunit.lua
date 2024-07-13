ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleBuffEvent
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleVariable
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleDataFunction
local var8_0 = var0_0.Battle.UnitState
local var9_0 = class("BattleUnit")

var0_0.Battle.BattleUnit = var9_0
var9_0.__name = "BattleUnit"

function var9_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._uniqueID = arg1_1
	arg0_1._speedExemptKey = "unit_" .. arg1_1
	arg0_1._unitState = var0_0.Battle.UnitState.New(arg0_1)
	arg0_1._move = var0_0.Battle.MoveComponent.New()
	arg0_1._weaponQueue = var0_0.Battle.WeaponQueue.New()

	arg0_1:Init()
	arg0_1:SetIFF(arg2_1)

	arg0_1._distanceBackup = {}
	arg0_1._battleProxy = var0_0.Battle.BattleDataProxy.GetInstance()
	arg0_1._frame = 0
end

function var9_0.Retreat(arg0_2)
	arg0_2:TriggerBuff(var3_0.BuffEffectType.ON_RETREAT, {})
end

function var9_0.SetMotion(arg0_3, arg1_3)
	arg0_3._move:SetMotionVO(arg1_3)
end

function var9_0.SetBound(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4, arg6_4)
	arg0_4._move:SetCorpsArea(arg5_4, arg6_4)
	arg0_4._move:SetBorder(arg3_4, arg4_4, arg1_4, arg2_4)
end

function var9_0.ActiveCldBox(arg0_5)
	arg0_5._cldComponent:SetActive(true)
end

function var9_0.DeactiveCldBox(arg0_6)
	arg0_6._cldComponent:SetActive(false)
end

function var9_0.SetCldBoxImmune(arg0_7, arg1_7)
	arg0_7._cldComponent:SetImmuneCLD(arg1_7)
end

function var9_0.Init(arg0_8)
	arg0_8._hostileCldList = {}
	arg0_8._currentHPRate = 1
	arg0_8._currentDMGRate = 0
	arg0_8._tagCount = 0
	arg0_8._tagIndex = 0
	arg0_8._tagList = {}
	arg0_8._aliveState = true
	arg0_8._isMainFleetUnit = false
	arg0_8._bulletCache = {}
	arg0_8._speed = Vector3.zero
	arg0_8._dir = var3_0.UnitDir.RIGHT
	arg0_8._extraInfo = {}
	arg0_8._GCDTimerList = {}
	arg0_8._buffList = {}
	arg0_8._buffStockList = {}
	arg0_8._labelTagList = {}
	arg0_8._exposedToSnoar = false
	arg0_8._moveCast = true
	arg0_8._remoteBoundBone = {}
end

function var9_0.Update(arg0_9, arg1_9)
	if arg0_9:IsAlive() and not arg0_9._isSickness then
		arg0_9._move:Update()
		arg0_9._move:FixSpeed(arg0_9._cldComponent)
		arg0_9._move:Move(arg0_9:GetSpeedRatio())
	end

	arg0_9:UpdateAction()
end

function var9_0.UpdateWeapon(arg0_10, arg1_10)
	if not arg0_10:IsAlive() or arg0_10._isSickness then
		return
	end

	if not arg0_10._antiSubVigilanceState or arg0_10._antiSubVigilanceState:IsWeaponUseable() then
		local var0_10 = arg0_10._move:GetPos()
		local var1_10 = arg0_10._weaponRightBound
		local var2_10 = arg0_10._weaponLowerBound

		if (var1_10 == nil or var1_10 > var0_10.x) and (var2_10 == nil or var2_10 < var0_10.z) then
			arg0_10._weaponQueue:Update(arg1_10)
		end
	end

	if not arg0_10:IsAlive() then
		return
	end

	arg0_10:UpdateBuff(arg1_10)
end

function var9_0.UpdateAirAssist(arg0_11)
	if arg0_11._airAssistList then
		for iter0_11, iter1_11 in ipairs(arg0_11._airAssistList) do
			iter1_11:Update()
		end
	end
end

function var9_0.UpdatePhaseSwitcher(arg0_12)
	if arg0_12._phaseSwitcher then
		arg0_12._phaseSwitcher:Update()
	end
end

function var9_0.SetInterruptSickness(arg0_13, arg1_13)
	arg0_13._isSickness = arg1_13
end

function var9_0.SummonSickness(arg0_14, arg1_14)
	if arg0_14._isSickness == true then
		return
	end

	local function var0_14()
		arg0_14:RemoveSummonSickness()
	end

	arg0_14._isSickness = true
	arg0_14._sicknessTimer = pg.TimeMgr.GetInstance():AddBattleTimer("summonSickness", 0, arg1_14, var0_14, true)
end

function var9_0.RemoveSummonSickness(arg0_16)
	arg0_16._isSickness = false

	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_16._sicknessTimer)

	arg0_16._sicknessTimer = nil
end

function var9_0.GetTargetedPriority(arg0_17)
	local var0_17

	if arg0_17._aimBias then
		local var1_17 = arg0_17._aimBias:GetCurrentState()

		if var1_17 == arg0_17._aimBias.STATE_SKILL_EXPOSE or var1_17 == arg0_17._aimBias.STATE_TOTAL_EXPOSE then
			var0_17 = arg0_17:GetTemplate().battle_unit_type
		else
			var0_17 = -200
		end
	else
		var0_17 = arg0_17:GetTemplate().battle_unit_type
	end

	return var0_17
end

function var9_0.PlayFX(arg0_18, arg1_18, arg2_18)
	arg0_18:DispatchEvent(var0_0.Event.New(var1_0.PLAY_FX, {
		fxName = arg1_18,
		notAttach = not arg2_18
	}))
end

function var9_0.SwitchShader(arg0_19, arg1_19, arg2_19, arg3_19)
	arg0_19:DispatchEvent(var0_0.Event.New(var1_0.SWITCH_SHADER, {
		shader = arg1_19,
		color = arg2_19,
		args = arg3_19
	}))
end

function var9_0.SendAttackTrigger(arg0_20)
	arg0_20:DispatchEvent(var0_0.Event.New(var1_0.SPAWN_CACHE_BULLET, {}))
end

function var9_0.HandleDamageToDeath(arg0_21)
	local var0_21 = {
		isMiss = false,
		isCri = true,
		isHeal = false,
		damageReason = var3_0.UnitDeathReason.DESTRUCT
	}

	arg0_21:UpdateHP(math.floor(-arg0_21._currentHP), var0_21)
end

function var9_0.UpdateHP(arg0_22, arg1_22, arg2_22)
	if not arg0_22:IsAlive() then
		return 0
	end

	local var0_22 = arg0_22:IsAlive()

	if not var0_22 then
		return 0
	end

	local var1_22 = arg2_22.isMiss
	local var2_22 = arg2_22.isCri
	local var3_22 = arg2_22.isHeal
	local var4_22 = arg2_22.isShare
	local var5_22 = arg2_22.attr
	local var6_22 = arg2_22.damageReason
	local var7_22 = arg2_22.font
	local var8_22 = arg2_22.cldPos
	local var9_22 = arg2_22.incorrupt
	local var10_22

	if not var3_22 then
		local var11_22 = {
			damage = -arg1_22,
			isShare = var4_22,
			miss = var1_22,
			cri = var2_22,
			damageSrc = arg2_22.srcID,
			damageAttr = var5_22,
			damageReason = var6_22
		}

		if not var4_22 then
			arg0_22:TriggerBuff(var3_0.BuffEffectType.ON_BEFORE_TAKE_DAMAGE, var11_22)

			if var11_22.capFlag then
				arg0_22:TriggerBuff(var3_0.BuffEffectType.ON_DAMAGE_FIX, var11_22)
			end
		end

		var10_22 = -var11_22.damage

		arg0_22:TriggerBuff(var3_0.BuffEffectType.ON_TAKE_DAMAGE, var11_22)

		if arg0_22._currentHP <= var11_22.damage then
			arg0_22:TriggerBuff(var3_0.BuffEffectType.ON_BEFORE_FATAL_DAMAGE, {})
		end

		arg1_22 = -var11_22.damage

		if var10_22 ~= arg1_22 then
			({}).absorb = var10_22 - arg1_22

			arg0_22:TriggerBuff(var3_0.BuffEffectType.ON_SHIELD_ABSORB, var11_22)
		end

		if var6_0.IsInvincible(arg0_22) then
			return 0
		end
	else
		var10_22 = arg1_22

		local var12_22 = {
			damage = arg1_22,
			isHeal = var3_22,
			incorrupt = var9_22
		}

		arg0_22:TriggerBuff(var3_0.BuffEffectType.ON_TAKE_HEALING, var12_22)

		var3_22 = var12_22.isHeal
		arg1_22 = var12_22.damage

		local var13_22 = math.max(0, arg0_22._currentHP + arg1_22 - arg0_22:GetMaxHP())

		if var13_22 > 0 then
			arg0_22:TriggerBuff(var3_0.BuffEffectType.ON_OVER_HEALING, {
				overHealing = var13_22
			})
		end
	end

	local var14_22 = math.min(arg0_22:GetMaxHP(), math.max(0, arg0_22._currentHP + arg1_22))
	local var15_22 = var14_22 - arg0_22._currentHP

	arg0_22:SetCurrentHP(var14_22)

	local var16_22 = {
		preShieldHP = var10_22,
		dHP = arg1_22,
		validDHP = var15_22,
		isMiss = var1_22,
		isCri = var2_22,
		isHeal = var3_22,
		font = var7_22
	}

	if var8_22 and not var8_22:EqualZero() then
		local var17_22 = arg0_22:GetPosition()
		local var18_22 = arg0_22:GetBoxSize().x
		local var19_22 = var17_22.x - var18_22
		local var20_22 = var17_22.x + var18_22
		local var21_22 = var8_22:Clone()

		var21_22.x = Mathf.Clamp(var21_22.x, var19_22, var20_22)
		var16_22.posOffset = var17_22 - var21_22
	end

	arg0_22:UpdateHPAction(var16_22)

	if not arg0_22:IsAlive() and var0_22 then
		arg0_22:SetDeathReason(arg2_22.damageReason)
		arg0_22:DeadAction()
	end

	if arg0_22:IsAlive() then
		arg0_22:TriggerBuff(var3_0.BuffEffectType.ON_HP_RATIO_UPDATE, {
			dHP = arg1_22,
			unit = arg0_22,
			validDHP = var15_22
		})
	end

	return arg1_22
end

function var9_0.UpdateHPAction(arg0_23, arg1_23)
	arg0_23:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_HP, arg1_23))
end

function var9_0.DeadAction(arg0_24)
	arg0_24:TriggerBuff(var3_0.BuffEffectType.ON_SINK, {})
	arg0_24:DeacActionClear()
end

function var9_0.DeacActionClear(arg0_25)
	arg0_25._aliveState = false

	var6_0.Spirit(arg0_25)
	var6_0.AppendInvincible(arg0_25)
	arg0_25:DeadActionEvent()
end

function var9_0.DeadActionEvent(arg0_26)
	arg0_26:DispatchEvent(var0_0.Event.New(var1_0.WILL_DIE, {}))
	arg0_26:DispatchEvent(var0_0.Event.New(var1_0.DYING, {}))
end

function var9_0.SendDeadEvent(arg0_27)
	arg0_27:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.DYING, {}))
end

function var9_0.SetDeathReason(arg0_28, arg1_28)
	arg0_28._deathReason = arg1_28
end

function var9_0.GetDeathReason(arg0_29)
	return arg0_29._deathReason or var3_0.UnitDeathReason.KILLED
end

function var9_0.DispatchScorePoint(arg0_30, arg1_30)
	arg0_30:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.UPDATE_SCORE, {
		score = arg1_30
	}))
end

function var9_0.SetTemplate(arg0_31, arg1_31, arg2_31)
	arg0_31._tmpID = arg1_31
end

function var9_0.GetTemplateID(arg0_32)
	return arg0_32._tmpID
end

function var9_0.SetOverrideLevel(arg0_33, arg1_33)
	arg0_33._overrideLevel = arg1_33
end

function var9_0.SetSkinId(arg0_34)
	return
end

function var9_0.SetGearScore(arg0_35, arg1_35)
	arg0_35._GS = arg1_35
end

function var9_0.GetGearScore(arg0_36)
	return arg0_36._GS or 0
end

function var9_0.GetSkinID(arg0_37)
	return arg0_37._tmpID
end

function var9_0.GetDefaultSkinID(arg0_38)
	return arg0_38._tmpID
end

function var9_0.GetSkinAttachmentInfo(arg0_39)
	return arg0_39._orbitSkinIDList
end

function var9_0.GetWeaponBoundBone(arg0_40)
	return arg0_40._tmpData.bound_bone
end

function var9_0.ActionKeyOffsetUseable(arg0_41)
	return true
end

function var9_0.RemoveRemoteBoundBone(arg0_42, arg1_42)
	arg0_42._remoteBoundBone[arg1_42] = nil
end

function var9_0.SetRemoteBoundBone(arg0_43, arg1_43, arg2_43, arg3_43)
	local var0_43 = arg0_43._remoteBoundBone[arg1_43] or {}

	var0_43[arg2_43] = arg3_43
	arg0_43._remoteBoundBone[arg1_43] = var0_43
end

function var9_0.GetRemoteBoundBone(arg0_44, arg1_44)
	for iter0_44, iter1_44 in pairs(arg0_44._remoteBoundBone) do
		local var0_44 = iter1_44[arg1_44]

		if var0_44 then
			local var1_44 = var0_0.Battle.BattleTargetChoise.TargetFleetIndex(arg0_44, {
				fleetPos = var0_44
			})[1]

			if var1_44 and var1_44:IsAlive() then
				local var2_44 = Clone(var1_44:GetPosition())

				var2_44:Set(var2_44.x, 1.5, var2_44.z)

				return var2_44
			end
		end
	end
end

function var9_0.GetLabelTag(arg0_45)
	return arg0_45._labelTagList
end

function var9_0.ContainsLabelTag(arg0_46, arg1_46)
	if arg0_46._labelTagList == nil then
		return false
	end

	for iter0_46, iter1_46 in ipairs(arg1_46) do
		if table.contains(arg0_46._labelTagList, iter1_46) then
			return true
		end
	end

	return false
end

function var9_0.AddLabelTag(arg0_47, arg1_47)
	table.insert(arg0_47._labelTagList, arg1_47)

	local var0_47 = var6_0.GetCurrent(arg0_47, "labelTag")

	var0_47[arg1_47] = (var0_47[arg1_47] or 0) + 1
end

function var9_0.RemoveLabelTag(arg0_48, arg1_48)
	for iter0_48, iter1_48 in ipairs(arg0_48._labelTagList) do
		if iter1_48 == arg1_48 then
			table.remove(arg0_48._labelTagList, iter0_48)

			local var0_48 = var6_0.GetCurrent(arg0_48, "labelTag")

			var0_48[arg1_48] = var0_48[arg1_48] - 1

			break
		end
	end
end

function var9_0.setStandardLabelTag(arg0_49)
	local var0_49 = "N_" .. arg0_49._tmpData.nationality
	local var1_49 = "T_" .. arg0_49._tmpData.type

	arg0_49:AddLabelTag(var0_49)
	arg0_49:AddLabelTag(var1_49)
end

function var9_0.GetRarity(arg0_50)
	return
end

function var9_0.GetIntimacy(arg0_51)
	return 0
end

function var9_0.IsBoss(arg0_52)
	return false
end

function var9_0.GetSpeedRatio(arg0_53)
	return var4_0.GetSpeedRatio(arg0_53:GetSpeedExemptKey(), arg0_53._IFF)
end

function var9_0.GetSpeedExemptKey(arg0_54)
	return arg0_54._speedExemptKey
end

function var9_0.SetMoveCast(arg0_55, arg1_55)
	arg0_55._moveCast = arg1_55
end

function var9_0.IsMoveCast(arg0_56)
	return arg0_56._moveCast
end

function var9_0.SetCrash(arg0_57, arg1_57)
	arg0_57._isCrash = arg1_57

	if arg1_57 then
		local var0_57 = var0_0.Battle.BattleBuffUnit.New(var5_0.SHIP_CLD_BUFF)

		arg0_57:AddBuff(var0_57)
	else
		arg0_57:RemoveBuff(var5_0.SHIP_CLD_BUFF)
	end
end

function var9_0.IsCrash(arg0_58)
	return arg0_58._isCrash
end

function var9_0.OverrideDeadFX(arg0_59, arg1_59)
	arg0_59._deadFX = arg1_59
end

function var9_0.GetDeadFX(arg0_60)
	return arg0_60._deadFX
end

function var9_0.SetEquipment(arg0_61, arg1_61)
	arg0_61._equipmentList = arg1_61
	arg0_61._autoWeaponList = {}
	arg0_61._manualTorpedoList = {}
	arg0_61._chargeList = {}
	arg0_61._AAList = {}
	arg0_61._fleetAAList = {}
	arg0_61._fleetRangeAAList = {}
	arg0_61._hiveList = {}
	arg0_61._totalWeapon = {}

	arg0_61:setWeapon(arg1_61)
end

function var9_0.GetEquipment(arg0_62)
	return arg0_62._equipmentList
end

function var9_0.SetProficiencyList(arg0_63, arg1_63)
	arg0_63._proficiencyList = arg1_63
end

function var9_0.SetSpWeapon(arg0_64, arg1_64)
	arg0_64._spWeapon = arg1_64
end

function var9_0.GetSpWeapon(arg0_65)
	return arg0_65._spWeapon
end

function var9_0.setWeapon(arg0_66, arg1_66)
	for iter0_66, iter1_66 in ipairs(arg1_66) do
		local var0_66 = iter1_66.equipment.weapon_id

		for iter2_66, iter3_66 in ipairs(var0_66) do
			if iter3_66 ~= -1 then
				local var1_66 = var0_0.Battle.BattleDataFunction.CreateWeaponUnit(iter3_66, arg0_66, nil, iter0_66)

				arg0_66._totalWeapon[#arg0_66._totalWeapon + 1] = var1_66

				local var2_66 = var1_66:GetTemplateData().type

				if var2_66 == var3_0.EquipmentType.MANUAL_TORPEDO then
					arg0_66._manualTorpedoList[#arg0_66._manualTorpedoList + 1] = var1_66

					arg0_66._weaponQueue:AppendWeapon(var1_66)
				elseif var2_66 == var3_0.EquipmentType.STRIKE_AIRCRAFT then
					-- block empty
				else
					assert(#var0_66 < 2, "自动武器一组不允许配置多个")
					arg0_66:AddAutoWeapon(var1_66)
				end

				if var2_66 == var3_0.EquipmentType.INTERCEPT_AIRCRAFT or var2_66 == var3_0.EquipmentType.STRIKE_AIRCRAFT then
					arg0_66._hiveList[#arg0_66._hiveList + 1] = var1_66
				end

				if var2_66 == var3_0.EquipmentType.ANTI_AIR then
					arg0_66._AAList[#arg0_66._AAList + 1] = var1_66
				end
			end
		end
	end
end

function var9_0.CheckWeaponInitial(arg0_67)
	arg0_67._weaponQueue:CheckWeaponInitalCD()

	if arg0_67._airAssistQueue then
		arg0_67._airAssistQueue:CheckWeaponInitalCD()
	end

	arg0_67:DispatchEvent(var0_0.Event.New(var1_0.INIT_COOL_DOWN, {}))
end

function var9_0.FlushReloadingWeapon(arg0_68)
	arg0_68._weaponQueue:FlushWeaponReloadRequire()

	if arg0_68._airAssistQueue then
		arg0_68._airAssistQueue:FlushWeaponReloadRequire()
	end
end

function var9_0.AddNewAutoWeapon(arg0_69, arg1_69)
	local var0_69 = var7_0.CreateWeaponUnit(arg1_69, arg0_69)

	arg0_69:AddAutoWeapon(var0_69)
	arg0_69:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_NEW_WEAPON, {
		weapon = var0_69
	}))

	return var0_69
end

function var9_0.AddAutoWeapon(arg0_70, arg1_70)
	arg0_70._autoWeaponList[#arg0_70._autoWeaponList + 1] = arg1_70

	arg0_70._weaponQueue:AppendWeapon(arg1_70)
end

function var9_0.RemoveAutoWeapon(arg0_71, arg1_71)
	arg0_71._weaponQueue:RemoveWeapon(arg1_71)

	local var0_71 = 1
	local var1_71 = #arg0_71._autoWeaponList

	while var0_71 <= var1_71 do
		if arg0_71._autoWeaponList[var0_71] == arg1_71 then
			arg0_71:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_WEAPON, {
				weapon = arg1_71
			}))
			table.remove(arg0_71._autoWeaponList, var0_71)

			break
		end

		var0_71 = var0_71 + 1
	end
end

function var9_0.RemoveAutoWeaponByWeaponID(arg0_72, arg1_72)
	for iter0_72, iter1_72 in ipairs(arg0_72._autoWeaponList) do
		if iter1_72:GetWeaponId() == arg1_72 then
			iter1_72:Clear()
			arg0_72:RemoveAutoWeapon(iter1_72)

			break
		end
	end
end

function var9_0.RemoveAllAutoWeapon(arg0_73)
	local var0_73 = #arg0_73._autoWeaponList

	while var0_73 > 0 do
		local var1_73 = arg0_73._autoWeaponList[var0_73]

		var1_73:Clear()
		arg0_73:RemoveAutoWeapon(var1_73)

		var0_73 = var0_73 - 1
	end
end

function var9_0.AddFleetAntiAirWeapon(arg0_74, arg1_74)
	return
end

function var9_0.RemoveFleetAntiAirWeapon(arg0_75, arg1_75)
	return
end

function var9_0.AttachFleetRangeAAWeapon(arg0_76, arg1_76)
	arg0_76._fleetRangeAA = arg1_76

	arg0_76:DispatchEvent(var0_0.Event.New(var1_0.CREATE_TEMPORARY_WEAPON, {
		weapon = arg1_76
	}))
end

function var9_0.DetachFleetRangeAAWeapon(arg0_77)
	arg0_77:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_WEAPON, {
		weapon = arg0_77._fleetRangeAA
	}))

	arg0_77._fleetRangeAA = nil
end

function var9_0.GetFleetRangeAAWeapon(arg0_78)
	return arg0_78._fleetRangeAA
end

function var9_0.ShiftWeapon(arg0_79, arg1_79, arg2_79)
	for iter0_79, iter1_79 in ipairs(arg1_79) do
		arg0_79:RemoveAutoWeaponByWeaponID(iter1_79)
	end

	for iter2_79, iter3_79 in ipairs(arg2_79) do
		arg0_79:AddNewAutoWeapon(iter3_79):InitialCD()
	end
end

function var9_0.ExpandWeaponMount(arg0_80, arg1_80)
	if arg1_80 == "airAssist" then
		var7_0.ExpandAllinStrike(arg0_80)
	end
end

function var9_0.ReduceWeaponMount(arg0_81, arg1_81)
	return
end

function var9_0.CeaseAllWeapon(arg0_82, arg1_82)
	arg0_82._ceaseFire = arg1_82
end

function var9_0.IsCease(arg0_83)
	return arg0_83._ceaseFire
end

function var9_0.GetAllWeapon(arg0_84)
	return arg0_84._totalWeapon
end

function var9_0.GetTotalWeapon(arg0_85)
	return arg0_85._weaponQueue:GetTotalWeaponUnit()
end

function var9_0.GetAutoWeapons(arg0_86)
	return arg0_86._autoWeaponList
end

function var9_0.GetChargeList(arg0_87)
	return arg0_87._chargeList
end

function var9_0.GetChargeQueue(arg0_88)
	return arg0_88._weaponQueue:GetChargeWeaponQueue()
end

function var9_0.GetAntiAirWeapon(arg0_89)
	return arg0_89._AAList
end

function var9_0.GetFleetAntiAirList(arg0_90)
	return arg0_90._fleetAAList
end

function var9_0.GetFleetRangeAntiAirList(arg0_91)
	return arg0_91._fleetRangeAAList
end

function var9_0.GetTorpedoList(arg0_92)
	return arg0_92._manualTorpedoList
end

function var9_0.GetTorpedoQueue(arg0_93)
	return arg0_93._weaponQueue:GetManualTorpedoQueue()
end

function var9_0.GetWeaponByIndex(arg0_94, arg1_94)
	for iter0_94, iter1_94 in ipairs(arg0_94._totalWeapon) do
		if iter1_94:GetEquipmentIndex() == arg1_94 then
			return iter1_94
		end
	end
end

function var9_0.GetHiveList(arg0_95)
	return arg0_95._hiveList
end

function var9_0.SetAirAssistList(arg0_96, arg1_96)
	arg0_96._airAssistList = arg1_96
	arg0_96._airAssistQueue = var0_0.Battle.ManualWeaponQueue.New(arg0_96:GetManualWeaponParallel()[var3_0.ManualWeaponIndex.AIR_ASSIST])

	for iter0_96, iter1_96 in ipairs(arg0_96._airAssistList) do
		arg0_96._airAssistQueue:AppendWeapon(iter1_96)
	end
end

function var9_0.GetAirAssistList(arg0_97)
	return arg0_97._airAssistList
end

function var9_0.GetAirAssistQueue(arg0_98)
	return arg0_98._airAssistQueue
end

function var9_0.GetManualWeaponParallel(arg0_99)
	return {
		1,
		1,
		1
	}
end

function var9_0.configWeaponQueueParallel(arg0_100)
	local var0_100 = arg0_100:GetManualWeaponParallel()

	arg0_100._weaponQueue:ConfigParallel(var0_100[var3_0.ManualWeaponIndex.CALIBRATION], var0_100[var3_0.ManualWeaponIndex.TORPEDO])
end

function var9_0.ClearWeapon(arg0_101)
	arg0_101._weaponQueue:ClearAllWeapon()

	local var0_101 = arg0_101._airAssistList

	if var0_101 then
		for iter0_101, iter1_101 in ipairs(var0_101) do
			iter1_101:Clear()
		end
	end
end

function var9_0.GetSpeed(arg0_102)
	return arg0_102._move:GetSpeed()
end

function var9_0.GetPosition(arg0_103)
	return arg0_103._move:GetPos()
end

function var9_0.GetBornPosition(arg0_104)
	return arg0_104._bornPos
end

function var9_0.GetCLDZCenterPosition(arg0_105)
	local var0_105 = arg0_105._battleProxy.FrameIndex

	if arg0_105._zCenterFrame ~= var0_105 then
		arg0_105._zCenterFrame = var0_105

		local var1_105 = arg0_105:GetCldBox()

		arg0_105._cldZCenterCache = (var1_105.min + var1_105.max) * 0.5
	end

	return arg0_105._cldZCenterCache
end

function var9_0.GetBeenAimedPosition(arg0_106)
	local var0_106 = arg0_106:GetCLDZCenterPosition()

	if not var0_106 then
		return var0_106
	end

	local var1_106 = arg0_106:GetTemplate() and arg0_106:GetTemplate().aim_offset

	if not var1_106 then
		return var0_106
	end

	local var2_106 = Vector3(var0_106.x + var1_106[1], var0_106.y + var1_106[2], var0_106.z + var1_106[3])

	arg0_106:biasAimPosition(var2_106)

	return var2_106
end

function var9_0.biasAimPosition(arg0_107, arg1_107)
	local var0_107 = var6_0.GetCurrent(arg0_107, "aimBias")

	if var0_107 > 0 then
		local var1_107 = var0_107 * 2
		local var2_107 = math.random() * var1_107 - var0_107
		local var3_107 = math.random() * var1_107 - var0_107

		arg1_107:Set(arg1_107.x + var2_107, arg1_107.y, arg1_107.z + var3_107)
	end

	return arg1_107
end

function var9_0.CancelFollowTeam(arg0_108)
	arg0_108._move:CancelFormationCtrl()
end

function var9_0.UpdateFormationOffset(arg0_109, arg1_109)
	arg0_109._move:SetFormationCtrlInfo(Vector3(arg1_109.x, arg1_109.y, arg1_109.z))
end

function var9_0.GetDistance(arg0_110, arg1_110)
	local var0_110 = arg0_110._battleProxy.FrameIndex

	if arg0_110._frame ~= var0_110 then
		arg0_110._distanceBackup = {}
		arg0_110._frame = var0_110
	end

	local var1_110 = arg0_110._distanceBackup[arg1_110]

	if var1_110 == nil then
		var1_110 = Vector3.Distance(arg0_110:GetPosition(), arg1_110:GetPosition())
		arg0_110._distanceBackup[arg1_110] = var1_110

		arg1_110:backupDistance(arg0_110, var1_110)
	end

	return var1_110
end

function var9_0.backupDistance(arg0_111, arg1_111, arg2_111)
	local var0_111 = arg0_111._battleProxy.FrameIndex

	if arg0_111._frame ~= var0_111 then
		arg0_111._distanceBackup = {}
		arg0_111._frame = var0_111
	end

	arg0_111._distanceBackup[arg1_111] = arg2_111
end

function var9_0.GetDirection(arg0_112)
	return arg0_112._dir
end

function var9_0.SetBornPosition(arg0_113, arg1_113)
	arg0_113._bornPos = arg1_113
end

function var9_0.SetPosition(arg0_114, arg1_114)
	arg0_114._move:SetPos(arg1_114)
end

function var9_0.IsMoving(arg0_115)
	local var0_115 = arg0_115._move:GetSpeed()

	return var0_115.x ~= 0 or var0_115.z ~= 0
end

function var9_0.SetUncontrollableSpeedWithYAngle(arg0_116, arg1_116, arg2_116, arg3_116)
	local var0_116 = math.deg2Rad * arg1_116
	local var1_116 = Vector3(math.cos(var0_116), 0, math.sin(var0_116))

	arg0_116:SetUncontrollableSpeed(var1_116, arg2_116, arg3_116)
end

function var9_0.SetUncontrollableSpeedWithDir(arg0_117, arg1_117, arg2_117, arg3_117)
	local var0_117 = math.sqrt(arg1_117.x * arg1_117.x + arg1_117.z * arg1_117.z)

	arg0_117:SetUncontrollableSpeed(arg1_117 / var0_117, arg2_117, arg3_117)
end

function var9_0.SetUncontrollableSpeed(arg0_118, arg1_118, arg2_118, arg3_118)
	if not arg2_118 or not arg3_118 then
		return
	end

	arg0_118._move:SetForceMove(arg1_118, arg2_118, arg3_118, arg2_118 / arg3_118)
end

function var9_0.ClearUncontrollableSpeed(arg0_119)
	arg0_119._move:ClearForceMove()
end

function var9_0.SetAdditiveSpeed(arg0_120, arg1_120)
	arg0_120._move:UpdateAdditiveSpeed(arg1_120)
end

function var9_0.RemoveAdditiveSpeed(arg0_121)
	arg0_121._move:RemoveAdditiveSpeed()
end

function var9_0.Boost(arg0_122, arg1_122, arg2_122, arg3_122, arg4_122, arg5_122)
	arg0_122._move:SetForceMove(arg1_122, arg2_122, arg3_122, arg4_122, arg5_122)
end

function var9_0.ActiveUnstoppable(arg0_123, arg1_123)
	arg0_123._move:ActiveUnstoppable(arg1_123)
end

function var9_0.SetImmuneCommonBulletCLD(arg0_124)
	arg0_124._immuneCommonBulletCLD = true
end

function var9_0.IsImmuneCommonBulletCLD(arg0_125)
	return arg0_125._immuneCommonBulletCLD
end

function var9_0.SetWeaponPreCastBound(arg0_126, arg1_126)
	arg0_126._preCastBound = arg1_126

	arg0_126:UpdatePrecastMoveLimit()
end

function var9_0.EnterGCD(arg0_127, arg1_127, arg2_127)
	if arg0_127._GCDTimerList[arg2_127] ~= nil then
		return
	end

	local function var0_127()
		arg0_127:RemoveGCDTimer(arg2_127)
	end

	arg0_127._weaponQueue:QueueEnterGCD(arg2_127, arg1_127)

	arg0_127._GCDTimerList[arg2_127] = pg.TimeMgr.GetInstance():AddBattleTimer("weaponGCD", 0, arg1_127, var0_127, true)

	arg0_127:UpdatePrecastMoveLimit()
end

function var9_0.RemoveGCDTimer(arg0_129, arg1_129)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_129._GCDTimerList[arg1_129])

	arg0_129._GCDTimerList[arg1_129] = nil

	arg0_129:UpdatePrecastMoveLimit()
end

function var9_0.UpdatePrecastMoveLimit(arg0_130)
	arg0_130:UpdateMoveLimit()
end

function var9_0.UpdateMoveLimit(arg0_131)
	local var0_131 = arg0_131:IsMoveAble()

	arg0_131._move:SetStaticState(not var0_131)
end

function var9_0.AddBuff(arg0_132, arg1_132, arg2_132)
	local var0_132 = arg1_132:GetID()
	local var1_132 = {
		unit_id = arg0_132._uniqueID,
		buff_id = var0_132
	}
	local var2_132 = arg0_132:GetBuff(var0_132)

	if var2_132 then
		local var3_132 = var2_132:GetLv()
		local var4_132 = arg1_132:GetLv()

		if arg2_132 then
			local var5_132 = arg0_132._buffStockList[var0_132] or {}

			table.insert(var5_132, arg1_132)

			arg0_132._buffStockList[var0_132] = var5_132
		else
			var1_132.buff_level = math.max(var3_132, var4_132)

			if var4_132 <= var3_132 then
				var2_132:Stack(arg0_132)

				var1_132.stack_count = var2_132:GetStack()

				arg0_132:DispatchEvent(var0_0.Event.New(var2_0.BUFF_STACK, var1_132))
			else
				arg0_132:DispatchEvent(var0_0.Event.New(var2_0.BUFF_CAST, var1_132))
				arg0_132:RemoveBuff(var0_132)

				arg0_132._buffList[var0_132] = arg1_132

				arg1_132:Attach(arg0_132)
				arg0_132:DispatchEvent(var0_0.Event.New(var2_0.BUFF_ATTACH, var1_132))
			end
		end
	else
		arg0_132:DispatchEvent(var0_0.Event.New(var2_0.BUFF_CAST, var1_132))

		arg0_132._buffList[var0_132] = arg1_132

		arg1_132:Attach(arg0_132)

		var1_132.buff_level = arg1_132:GetLv()

		arg0_132:DispatchEvent(var0_0.Event.New(var2_0.BUFF_ATTACH, var1_132))
	end

	arg0_132:TriggerBuff(var3_0.BuffEffectType.ON_BUFF_ADDED, {
		buffID = var0_132
	})
end

function var9_0.SetBuffStack(arg0_133, arg1_133, arg2_133, arg3_133)
	if arg3_133 <= 0 then
		arg0_133:RemoveBuff(arg1_133)
	else
		local var0_133 = arg0_133:GetBuff(arg1_133)

		if var0_133 then
			var0_133:UpdateStack(arg0_133, arg3_133)

			return var0_133
		else
			local var1_133 = var0_0.Battle.BattleBuffUnit.New(arg1_133, arg2_133)

			arg0_133:AddBuff(var1_133)
			var1_133:UpdateStack(arg0_133, arg3_133)

			return var1_133
		end
	end
end

function var9_0.UpdateBuff(arg0_134, arg1_134)
	local var0_134 = arg0_134._buffList

	for iter0_134, iter1_134 in pairs(var0_134) do
		iter1_134:Update(arg0_134, arg1_134)

		if not arg0_134:IsAlive() then
			break
		end
	end
end

function var9_0.ConsumeBuffStack(arg0_135, arg1_135, arg2_135)
	local var0_135 = arg0_135:GetBuff(arg1_135)

	if var0_135 then
		if not arg2_135 then
			arg0_135:RemoveBuff(arg1_135)
		else
			local var1_135 = var0_135:GetStack()
			local var2_135 = math.max(0, var1_135 - arg2_135)

			if var2_135 == 0 then
				arg0_135:RemoveBuff(arg1_135)
			else
				var0_135:UpdateStack(arg0_135, var2_135)
			end
		end
	end
end

function var9_0.RemoveBuff(arg0_136, arg1_136, arg2_136)
	if arg2_136 and arg0_136._buffStockList[arg1_136] then
		local var0_136 = table.remove(arg0_136._buffStockList[arg1_136])

		if var0_136 then
			var0_136:Clear()

			return
		end
	end

	local var1_136 = arg0_136:GetBuff(arg1_136)

	if var1_136 then
		var1_136:Remove()
	end

	arg0_136:TriggerBuff(var3_0.BuffEffectType.ON_BUFF_REMOVED, {
		buffID = arg1_136
	})
end

function var9_0.ClearBuff(arg0_137)
	local var0_137 = arg0_137._buffList

	for iter0_137, iter1_137 in pairs(var0_137) do
		iter1_137:Clear()
	end

	local var1_137 = arg0_137._buffStockList

	for iter2_137, iter3_137 in pairs(var1_137) do
		for iter4_137, iter5_137 in pairs(iter3_137) do
			iter5_137:Clear()
		end
	end
end

function var9_0.TriggerBuff(arg0_138, arg1_138, arg2_138)
	var0_0.Battle.BattleBuffUnit.Trigger(arg0_138, arg1_138, arg2_138)
end

function var9_0.GetBuffList(arg0_139)
	return arg0_139._buffList
end

function var9_0.GetBuff(arg0_140, arg1_140)
	arg0_140._buffList = arg0_140._buffList

	return arg0_140._buffList[arg1_140]
end

function var9_0.DispatchSkillFloat(arg0_141, arg1_141, arg2_141, arg3_141)
	local var0_141 = {
		coverHrzIcon = arg3_141,
		commander = arg2_141,
		skillName = arg1_141
	}

	arg0_141:DispatchEvent(var0_0.Event.New(var1_0.SKILL_FLOAT, var0_141))
end

function var9_0.DispatchCutIn(arg0_142, arg1_142, arg2_142)
	local var0_142 = {
		caster = arg0_142,
		skill = arg1_142
	}

	arg0_142:DispatchEvent(var0_0.Event.New(var1_0.CUT_INT, var0_142))
end

function var9_0.DispatchCastClock(arg0_143, arg1_143, arg2_143, arg3_143, arg4_143, arg5_143)
	local var0_143 = {
		isActive = arg1_143,
		buffEffect = arg2_143,
		iconType = arg3_143,
		interrupt = arg4_143,
		reverse = arg5_143
	}

	arg0_143:DispatchEvent(var0_0.Event.New(var1_0.ADD_BUFF_CLOCK, var0_143))
end

function var9_0.SetAI(arg0_144, arg1_144)
	local var0_144 = var7_0.GetAITmpDataFromID(arg1_144)

	arg0_144._autoPilotAI = var0_0.Battle.AutoPilot.New(arg0_144, var0_144), arg0_144._move:CancelFormationCtrl()
end

function var9_0.AddPhaseSwitcher(arg0_145, arg1_145)
	arg0_145._phaseSwitcher = arg1_145
end

function var9_0.GetPhaseSwitcher(arg0_146)
	return arg0_146._phaseSwitcher
end

function var9_0.StateChange(arg0_147, arg1_147, arg2_147)
	arg0_147._unitState:ChangeState(arg1_147, arg2_147)
end

function var9_0.UpdateAction(arg0_148)
	local var0_148 = arg0_148:GetSpeed().x * arg0_148._IFF

	if arg0_148._oxyState and arg0_148._oxyState:GetCurrentDiveState() == var3_0.OXY_STATE.DIVE then
		if var0_148 >= 0 then
			arg0_148._unitState:ChangeState(var8_0.STATE_DIVE)
		else
			arg0_148._unitState:ChangeState(var8_0.STATE_DIVELEFT)
		end
	elseif var0_148 >= 0 then
		arg0_148._unitState:ChangeState(var8_0.STATE_MOVE)
	else
		arg0_148._unitState:ChangeState(var8_0.STATE_MOVELEFT)
	end
end

function var9_0.SetActionKeyOffset(arg0_149, arg1_149)
	arg0_149._actionKeyOffset = arg1_149

	arg0_149._unitState:FreshActionKeyOffset()
end

function var9_0.GetActionKeyOffset(arg0_150)
	return arg0_150._actionKeyOffset
end

function var9_0.GetCurrentState(arg0_151)
	return arg0_151._unitState:GetCurrentStateName()
end

function var9_0.NeedWeaponCache(arg0_152)
	return arg0_152._unitState:NeedWeaponCache()
end

function var9_0.CharacterActionTriggerCallback(arg0_153)
	arg0_153._unitState:OnActionTrigger()
end

function var9_0.CharacterActionEndCallback(arg0_154)
	arg0_154._unitState:OnActionEnd()
end

function var9_0.CharacterActionStartCallback(arg0_155)
	return
end

function var9_0.DispatchChat(arg0_156, arg1_156, arg2_156, arg3_156)
	if not arg1_156 or #arg1_156 == 0 then
		return
	end

	local var0_156 = {
		content = HXSet.hxLan(arg1_156),
		duration = arg2_156,
		key = arg3_156
	}

	arg0_156:DispatchEvent(var0_0.Event.New(var1_0.POP_UP, var0_156))
end

function var9_0.DispatchVoice(arg0_157, arg1_157)
	local var0_157 = arg0_157:GetIntimacy()
	local var1_157, var2_157, var3_157 = ShipWordHelper.GetWordAndCV(arg0_157:GetSkinID(), arg1_157, 1, true, var0_157)

	if var2_157 then
		local var4_157 = {
			content = var2_157,
			key = arg1_157
		}

		arg0_157:DispatchEvent(var0_0.Event.New(var1_0.VOICE, var4_157))
	end
end

function var9_0.GetHostileCldList(arg0_158)
	return arg0_158._hostileCldList
end

function var9_0.AppendHostileCld(arg0_159, arg1_159, arg2_159)
	arg0_159._hostileCldList[arg1_159] = arg2_159
end

function var9_0.RemoveHostileCld(arg0_160, arg1_160)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_160._hostileCldList[arg1_160])

	arg0_160._hostileCldList[arg1_160] = nil
end

function var9_0.GetExtraInfo(arg0_161)
	return arg0_161._extraInfo
end

function var9_0.GetTemplate(arg0_162)
	return nil
end

function var9_0.GetTemplateValue(arg0_163, arg1_163)
	return arg0_163:GetTemplate()[arg1_163]
end

function var9_0.GetUniqueID(arg0_164)
	return arg0_164._uniqueID
end

function var9_0.SetIFF(arg0_165, arg1_165)
	arg0_165._IFF = arg1_165

	if arg1_165 == var5_0.FRIENDLY_CODE then
		arg0_165._dir = var3_0.UnitDir.RIGHT
	elseif arg1_165 == var5_0.FOE_CODE then
		arg0_165._dir = var3_0.UnitDir.LEFT
	end
end

function var9_0.GetIFF(arg0_166)
	return arg0_166._IFF
end

function var9_0.GetUnitType(arg0_167)
	return arg0_167._type
end

function var9_0.GetHPRate(arg0_168)
	return arg0_168._currentHPRate
end

function var9_0.GetHP(arg0_169)
	return arg0_169._currentHP, arg0_169:GetMaxHP()
end

function var9_0.GetCurrentHP(arg0_170)
	return arg0_170._currentHP
end

function var9_0.SetCurrentHP(arg0_171, arg1_171)
	arg0_171._currentHP = arg1_171
	arg0_171._currentHPRate = arg0_171._currentHP / arg0_171:GetMaxHP()
	arg0_171._currentDMGRate = 1 - arg0_171._currentHPRate

	var6_0.SetCurrent(arg0_171, "HPRate", arg0_171._currentHPRate)
	var6_0.SetCurrent(arg0_171, "DMGRate", arg0_171._currentDMGRate)
end

function var9_0.GetAttr(arg0_172)
	return var6_0.GetAttr(arg0_172)
end

function var9_0.GetAttrByName(arg0_173, arg1_173)
	return var6_0.GetCurrent(arg0_173, arg1_173)
end

function var9_0.GetMaxHP(arg0_174)
	return arg0_174:GetAttrByName("maxHP")
end

function var9_0.GetReload(arg0_175)
	return arg0_175:GetAttrByName("loadSpeed")
end

function var9_0.GetTorpedoPower(arg0_176)
	return arg0_176:GetAttrByName("torpedoPower")
end

function var9_0.CanDoAntiSub(arg0_177)
	return arg0_177:GetAttrByName("antiSubPower") > 0
end

function var9_0.IsShowHPBar(arg0_178)
	return false
end

function var9_0.IsAlive(arg0_179)
	local var0_179 = arg0_179:GetCurrentHP()

	return arg0_179._aliveState and var0_179 > 0
end

function var9_0.SetMainFleetUnit(arg0_180)
	arg0_180._isMainFleetUnit = true

	arg0_180:SetMainUnitStatic(true)
end

function var9_0.IsMainFleetUnit(arg0_181)
	return arg0_181._isMainFleetUnit
end

function var9_0.SetMainUnitStatic(arg0_182, arg1_182)
	arg0_182._isMainStatic = arg1_182

	arg0_182._move:SetStaticState(arg1_182)
end

function var9_0.SetMainUnitIndex(arg0_183, arg1_183)
	arg0_183._mainUnitIndex = arg1_183
end

function var9_0.GetMainUnitIndex(arg0_184)
	return arg0_184._mainUnitIndex or 1
end

function var9_0.IsMoveAble(arg0_185)
	local var0_185 = table.getCount(arg0_185._GCDTimerList) > 0 or arg0_185._preCastBound
	local var1_185 = var6_0.IsStun(arg0_185)
	local var2_185 = arg0_185:IsMoveCast()

	return not arg0_185._isMainStatic and (var2_185 or not var0_185) and not var1_185
end

function var9_0.Reinforce(arg0_186)
	arg0_186._isReinforcement = true
end

function var9_0.IsReinforcement(arg0_187)
	return arg0_187._isReinforcement
end

function var9_0.SetReinforceCastTime(arg0_188, arg1_188)
	arg0_188._reinforceCastTime = arg1_188
end

function var9_0.GetReinforceCastTime(arg0_189)
	return arg0_189._reinforceCastTime
end

function var9_0.GetFleetVO(arg0_190)
	return
end

function var9_0.SetFormationIndex(arg0_191, arg1_191)
	return
end

function var9_0.SetMaster(arg0_192)
	return
end

function var9_0.GetMaster(arg0_193)
	return nil
end

function var9_0.IsSpectre(arg0_194)
	return
end

function var9_0.Clear(arg0_195)
	arg0_195._aliveState = false

	for iter0_195, iter1_195 in pairs(arg0_195._hostileCldList) do
		arg0_195:RemoveHostileCld(iter0_195)
	end

	arg0_195:ClearWeapon()
	arg0_195:ClearBuff()

	arg0_195._distanceBackup = {}
end

function var9_0.Dispose(arg0_196)
	arg0_196._exposedList = nil
	arg0_196._phaseSwitcher = nil

	arg0_196._weaponQueue:Dispose()

	if arg0_196._airAssistQueue then
		arg0_196._airAssistQueue:Clear()

		arg0_196._airAssistQueue = nil
	end

	arg0_196._equipmentList = nil
	arg0_196._totalWeapon = nil

	local var0_196 = arg0_196._airAssistList

	if var0_196 then
		for iter0_196, iter1_196 in ipairs(var0_196) do
			iter1_196:Dispose()
		end
	end

	for iter2_196, iter3_196 in ipairs(arg0_196._fleetAAList) do
		iter3_196:Dispose()
	end

	for iter4_196, iter5_196 in ipairs(arg0_196._fleetRangeAAList) do
		iter5_196:Dispose()
	end

	local var1_196 = arg0_196._buffList

	for iter6_196, iter7_196 in pairs(var1_196) do
		iter7_196:Dispose()
	end

	local var2_196 = arg0_196._buffStockList

	for iter8_196, iter9_196 in pairs(var2_196) do
		for iter10_196, iter11_196 in pairs(iter9_196) do
			iter11_196:Clear()
		end
	end

	arg0_196._fleetRangeAA = nil
	arg0_196._aimBias = nil
	arg0_196._buffList = nil
	arg0_196._buffStockList = nil
	arg0_196._cldZCenterCache = nil
	arg0_196._remoteBoundBone = nil

	arg0_196:RemoveSummonSickness()
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_196)
end

function var9_0.InitCldComponent(arg0_197)
	local var0_197 = arg0_197:GetTemplate().cld_box
	local var1_197 = arg0_197:GetTemplate().cld_offset
	local var2_197 = var1_197[1]

	if arg0_197:GetDirection() == var3_0.UnitDir.LEFT then
		var2_197 = var2_197 * -1
	end

	arg0_197._cldComponent = var0_0.Battle.BattleCubeCldComponent.New(var0_197[1], var0_197[2], var0_197[3], var2_197, var1_197[3] + var0_197[3] / 2)
end

function var9_0.GetBoxSize(arg0_198)
	return arg0_198._cldComponent:GetCldBoxSize()
end

function var9_0.GetCldBox(arg0_199)
	return arg0_199._cldComponent:GetCldBox(arg0_199:GetPosition())
end

function var9_0.GetCldData(arg0_200)
	return arg0_200._cldComponent:GetCldData()
end

function var9_0.InitOxygen(arg0_201)
	arg0_201._maxOxy = arg0_201:GetAttrByName("oxyMax")
	arg0_201._currentOxy = arg0_201:GetAttrByName("oxyMax")
	arg0_201._oxyRecovery = arg0_201:GetAttrByName("oxyRecovery")
	arg0_201._oxyRecoveryBench = arg0_201:GetAttrByName("oxyRecoveryBench")
	arg0_201._oxyRecoverySurface = arg0_201:GetAttrByName("oxyRecoverySurface")
	arg0_201._oxyConsume = arg0_201:GetAttrByName("oxyCost")
	arg0_201._oxyState = var0_0.Battle.OxyState.New(arg0_201)

	arg0_201._oxyState:OnDiveState()
	arg0_201:ConfigBubbleFX()

	return arg0_201._oxyState
end

function var9_0.UpdateOxygen(arg0_202, arg1_202)
	if arg0_202._oxyState then
		arg0_202._lastOxyUpdateStamp = arg0_202._lastOxyUpdateStamp or arg1_202

		arg0_202._oxyState:UpdateOxygen()

		if arg0_202._oxyState:GetNextBubbleStamp() and arg1_202 > arg0_202._oxyState:GetNextBubbleStamp() then
			arg0_202._oxyState:FlashBubbleStamp(arg1_202)
			arg0_202:PlayFX(arg0_202._bubbleFX, true)
		end

		arg0_202._lastOxyUpdateStamp = arg1_202

		arg0_202:updateSonarExposeTag()
	end
end

function var9_0.OxyRecover(arg0_203, arg1_203)
	local var0_203

	if arg1_203 == var0_0.Battle.OxyState.STATE_FREE_BENCH then
		var0_203 = arg0_203._oxyRecoveryBench
	elseif arg1_203 == var0_0.Battle.OxyState.STATE_FREE_FLOAT then
		var0_203 = arg0_203._oxyRecovery
	else
		var0_203 = arg0_203._oxyRecoverySurface
	end

	local var1_203 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_203._lastOxyUpdateStamp

	arg0_203._currentOxy = math.min(arg0_203._maxOxy, arg0_203._currentOxy + var0_203 * var1_203)
end

function var9_0.OxyConsume(arg0_204)
	local var0_204 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_204._lastOxyUpdateStamp

	arg0_204._currentOxy = math.max(0, arg0_204._currentOxy - arg0_204._oxyConsume * var0_204)
end

function var9_0.ChangeOxygenState(arg0_205, arg1_205)
	arg0_205._oxyState:ChangeState(arg1_205)
end

function var9_0.ChangeWeaponDiveState(arg0_206)
	for iter0_206, iter1_206 in ipairs(arg0_206._autoWeaponList) do
		iter1_206:ChangeDiveState()
	end
end

function var9_0.GetOxygenProgress(arg0_207)
	return arg0_207._currentOxy / arg0_207._maxOxy
end

function var9_0.GetCuurentOxygen(arg0_208)
	return arg0_208._currentOxy or 0
end

function var9_0.ConfigBubbleFX(arg0_209)
	return
end

function var9_0.SetDiveInvisible(arg0_210, arg1_210)
	arg0_210._diveInvisible = arg1_210

	arg0_210:DispatchEvent(var0_0.Event.New(var1_0.SUBMARINE_VISIBLE))
	arg0_210:DispatchEvent(var0_0.Event.New(var1_0.SUBMARINE_DETECTED))
	arg0_210:dispatchDetectedTrigger()
end

function var9_0.GetDiveInvisible(arg0_211)
	return arg0_211._diveInvisible
end

function var9_0.GetOxygenVisible(arg0_212)
	return arg0_212._oxyState and arg0_212._oxyState:GetBarVisible()
end

function var9_0.SetForceVisible(arg0_213)
	arg0_213:DispatchEvent(var0_0.Event.New(var1_0.SUBMARINE_FORCE_DETECTED))
end

function var9_0.Detected(arg0_214, arg1_214)
	local var0_214

	if arg0_214._exposedToSnoar == false and not arg0_214._exposedOverTimeStamp then
		var0_214 = true
	end

	if arg1_214 then
		arg0_214:updateExposeTimeStamp(arg1_214)
	else
		arg0_214._exposedToSnoar = true
	end

	if var0_214 then
		arg0_214:DispatchEvent(var0_0.Event.New(var1_0.SUBMARINE_DETECTED, {}))
		arg0_214:dispatchDetectedTrigger()
	end
end

function var9_0.Undetected(arg0_215)
	arg0_215._exposedToSnoar = false

	arg0_215:updateExposeTimeStamp(var5_0.SUB_EXPOSE_LASTING_DURATION)
end

function var9_0.RemoveSonarExpose(arg0_216)
	arg0_216._exposedToSnoar = false
	arg0_216._exposedOverTimeStamp = nil
end

function var9_0.updateSonarExposeTag(arg0_217)
	if arg0_217._exposedOverTimeStamp and not arg0_217._exposedToSnoar and pg.TimeMgr.GetInstance():GetCombatTime() > arg0_217._exposedOverTimeStamp then
		arg0_217._exposedOverTimeStamp = nil

		arg0_217:DispatchEvent(var0_0.Event.New(var1_0.SUBMARINE_DETECTED, {
			detected = false
		}))
		arg0_217:dispatchDetectedTrigger()
	end
end

function var9_0.updateExposeTimeStamp(arg0_218, arg1_218)
	local var0_218 = pg.TimeMgr.GetInstance():GetCombatTime() + arg1_218

	arg0_218._exposedOverTimeStamp = arg0_218._exposedOverTimeStamp or 0
	arg0_218._exposedOverTimeStamp = var0_218 < arg0_218._exposedOverTimeStamp and arg0_218._exposedOverTimeStamp or var0_218
end

function var9_0.IsRunMode(arg0_219)
	return arg0_219._oxyState and arg0_219._oxyState:GetRundMode()
end

function var9_0.GetDiveDetected(arg0_220)
	return arg0_220:GetDiveInvisible() and (arg0_220._exposedOverTimeStamp or arg0_220._exposedToSnoar)
end

function var9_0.GetForceExpose(arg0_221)
	return arg0_221._oxyState and arg0_221._oxyState:GetForceExpose()
end

function var9_0.dispatchDetectedTrigger(arg0_222)
	if arg0_222:GetDiveDetected() then
		arg0_222:TriggerBuff(var3_0.BuffEffectType.ON_SUB_DETECTED, {})
	else
		arg0_222:TriggerBuff(var3_0.BuffEffectType.ON_SUB_UNDETECTED, {})
	end
end

function var9_0.GetRaidDuration(arg0_223)
	return arg0_223:GetAttrByName("oxyMax") / arg0_223:GetAttrByName("oxyCost")
end

function var9_0.EnterRaidRange(arg0_224)
	if arg0_224:GetPosition().x > arg0_224._subRaidLine then
		return true
	else
		return false
	end
end

function var9_0.EnterRetreatRange(arg0_225)
	if arg0_225:GetPosition().x < arg0_225._subRetreatLine then
		return true
	else
		return false
	end
end

function var9_0.GetOxyState(arg0_226)
	return arg0_226._oxyState
end

function var9_0.GetCurrentOxyState(arg0_227)
	if not arg0_227._oxyState then
		return var3_0.OXY_STATE.FLOAT
	else
		return arg0_227._oxyState:GetCurrentDiveState()
	end
end

function var9_0.InitAntiSubState(arg0_228, arg1_228, arg2_228)
	arg0_228._antiSubVigilanceState = var0_0.Battle.AntiSubState.New(arg0_228)

	arg0_228:DispatchEvent(var0_0.Event.New(var1_0.INIT_ANIT_SUB_VIGILANCE, {
		sonarRange = arg1_228
	}))

	return arg0_228._antiSubVigilanceState
end

function var9_0.GetAntiSubState(arg0_229)
	return arg0_229._antiSubVigilanceState
end

function var9_0.UpdateBlindInvisibleBySpectre(arg0_230)
	local var0_230, var1_230 = arg0_230:IsSpectre()

	if var1_230 <= var5_0.SPECTRE_UNIT_TYPE and var1_230 ~= var5_0.VISIBLE_SPECTRE_UNIT_TYPE then
		arg0_230:SetBlindInvisible(true)
	else
		arg0_230:SetBlindInvisible(false)
	end
end

function var9_0.SetBlindInvisible(arg0_231, arg1_231)
	arg0_231._exposedList = arg1_231 and {} or nil
	arg0_231._blindInvisible = arg1_231

	arg0_231:DispatchEvent(var0_0.Event.New(var1_0.BLIND_VISIBLE))
end

function var9_0.GetBlindInvisible(arg0_232)
	return arg0_232._blindInvisible
end

function var9_0.GetExposed(arg0_233)
	if not arg0_233._blindInvisible then
		return true
	end

	for iter0_233, iter1_233 in pairs(arg0_233._exposedList) do
		return true
	end
end

function var9_0.AppendExposed(arg0_234, arg1_234)
	if not arg0_234._blindInvisible then
		return
	end

	local var0_234 = arg0_234._exposedList[arg1_234]

	arg0_234._exposedList[arg1_234] = true

	if not var0_234 then
		arg0_234:DispatchEvent(var0_0.Event.New(var1_0.BLIND_EXPOSE))
	end
end

function var9_0.RemoveExposed(arg0_235, arg1_235)
	if not arg0_235._blindInvisible then
		return
	end

	arg0_235._exposedList[arg1_235] = nil

	arg0_235:DispatchEvent(var0_0.Event.New(var1_0.BLIND_EXPOSE))
end

function var9_0.SetWorldDeathMark(arg0_236)
	arg0_236._worldDeathMark = true
end

function var9_0.GetWorldDeathMark(arg0_237)
	return arg0_237._worldDeathMark
end

function var9_0.InitCloak(arg0_238)
	arg0_238._cloak = var0_0.Battle.BattleUnitCloakComponent.New(arg0_238)

	arg0_238:DispatchEvent(var0_0.Event.New(var1_0.INIT_CLOAK))

	return arg0_238._cloak
end

function var9_0.CloakOnFire(arg0_239, arg1_239)
	if arg0_239._cloak then
		arg0_239._cloak:UpdateDotExpose(arg1_239)
	end
end

function var9_0.CloakExpose(arg0_240, arg1_240)
	if arg0_240._cloak then
		arg0_240._cloak:AppendExpose(arg1_240)
	end
end

function var9_0.StrikeExpose(arg0_241)
	if arg0_241._cloak then
		arg0_241._cloak:AppendStrikeExpose()
	end
end

function var9_0.BombardExpose(arg0_242)
	if arg0_242._cloak then
		arg0_242._cloak:AppendBombardExpose()
	end
end

function var9_0.UpdateCloak(arg0_243, arg1_243)
	arg0_243._cloak:Update(arg1_243)
end

function var9_0.UpdateCloakConfig(arg0_244)
	if arg0_244._cloak then
		arg0_244._cloak:UpdateCloakConfig()
		arg0_244:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_CLOAK_CONFIG))
	end
end

function var9_0.DispatchCloakStateUpdate(arg0_245)
	if arg0_245._cloak then
		arg0_245:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_CLOAK_STATE))
	end
end

function var9_0.GetCloak(arg0_246)
	return arg0_246._cloak
end

function var9_0.AttachAimBias(arg0_247, arg1_247)
	arg0_247._aimBias = arg1_247

	arg0_247:DispatchEvent(var0_0.Event.New(var1_0.INIT_AIMBIAS))
end

function var9_0.DetachAimBias(arg0_248)
	arg0_248:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIMBIAS))
	arg0_248._aimBias:RemoveCrew(arg0_248)

	arg0_248._aimBias = nil
end

function var9_0.ExitSmokeArea(arg0_249)
	arg0_249._aimBias:SmokeExitPause()
end

function var9_0.UpdateAimBiasSkillState(arg0_250)
	if arg0_250._aimBias and arg0_250._aimBias:GetHost() == arg0_250 then
		arg0_250._aimBias:UpdateSkillLock()
	end
end

function var9_0.HostAimBias(arg0_251)
	if arg0_251._aimBias then
		arg0_251:DispatchEvent(var0_0.Event.New(var1_0.HOST_AIMBIAS))
	end
end

function var9_0.GetAimBias(arg0_252)
	return arg0_252._aimBias
end

function var9_0.SwitchSpine(arg0_253, arg1_253, arg2_253)
	arg0_253:DispatchEvent(var0_0.Event.New(var1_0.SWITCH_SPINE, {
		skin = arg1_253,
		HPBarOffset = arg2_253
	}))
end

function var9_0.Freeze(arg0_254)
	for iter0_254, iter1_254 in ipairs(arg0_254._totalWeapon) do
		iter1_254:StartJamming()
	end

	if arg0_254._airAssistList then
		for iter2_254, iter3_254 in ipairs(arg0_254._airAssistList) do
			iter3_254:StartJamming()
		end
	end
end

function var9_0.ActiveFreeze(arg0_255)
	for iter0_255, iter1_255 in ipairs(arg0_255._totalWeapon) do
		iter1_255:JammingEliminate()
	end

	if arg0_255._airAssistList then
		for iter2_255, iter3_255 in ipairs(arg0_255._airAssistList) do
			iter3_255:JammingEliminate()
		end
	end
end

function var9_0.ActiveWeaponSectorView(arg0_256, arg1_256, arg2_256)
	local var0_256 = {
		weapon = arg1_256,
		isActive = arg2_256
	}

	arg0_256:DispatchEvent(var0_0.Event.New(var1_0.WEAPON_SECTOR, var0_256))
end
