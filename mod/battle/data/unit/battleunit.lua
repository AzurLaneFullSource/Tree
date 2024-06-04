ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleBuffEvent
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleVariable
local var5 = var0.Battle.BattleConfig
local var6 = var0.Battle.BattleAttr
local var7 = var0.Battle.BattleDataFunction
local var8 = var0.Battle.UnitState
local var9 = class("BattleUnit")

var0.Battle.BattleUnit = var9
var9.__name = "BattleUnit"

function var9.Ctor(arg0, arg1, arg2)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._uniqueID = arg1
	arg0._speedExemptKey = "unit_" .. arg1
	arg0._unitState = var0.Battle.UnitState.New(arg0)
	arg0._move = var0.Battle.MoveComponent.New()
	arg0._weaponQueue = var0.Battle.WeaponQueue.New()

	arg0:Init()
	arg0:SetIFF(arg2)

	arg0._distanceBackup = {}
	arg0._battleProxy = var0.Battle.BattleDataProxy.GetInstance()
	arg0._frame = 0
end

function var9.Retreat(arg0)
	arg0:TriggerBuff(var3.BuffEffectType.ON_RETREAT, {})
end

function var9.SetMotion(arg0, arg1)
	arg0._move:SetMotionVO(arg1)
end

function var9.SetBound(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0._move:SetCorpsArea(arg5, arg6)
	arg0._move:SetBorder(arg3, arg4, arg1, arg2)
end

function var9.ActiveCldBox(arg0)
	arg0._cldComponent:SetActive(true)
end

function var9.DeactiveCldBox(arg0)
	arg0._cldComponent:SetActive(false)
end

function var9.SetCldBoxImmune(arg0, arg1)
	arg0._cldComponent:SetImmuneCLD(arg1)
end

function var9.Init(arg0)
	arg0._hostileCldList = {}
	arg0._currentHPRate = 1
	arg0._currentDMGRate = 0
	arg0._tagCount = 0
	arg0._tagIndex = 0
	arg0._tagList = {}
	arg0._aliveState = true
	arg0._isMainFleetUnit = false
	arg0._bulletCache = {}
	arg0._speed = Vector3.zero
	arg0._dir = var3.UnitDir.RIGHT
	arg0._extraInfo = {}
	arg0._GCDTimerList = {}
	arg0._buffList = {}
	arg0._buffStockList = {}
	arg0._labelTagList = {}
	arg0._exposedToSnoar = false
	arg0._moveCast = true
	arg0._remoteBoundBone = {}
end

function var9.Update(arg0, arg1)
	if arg0:IsAlive() and not arg0._isSickness then
		arg0._move:Update()
		arg0._move:FixSpeed(arg0._cldComponent)
		arg0._move:Move(arg0:GetSpeedRatio())
	end

	arg0:UpdateAction()
end

function var9.UpdateWeapon(arg0, arg1)
	if not arg0:IsAlive() or arg0._isSickness then
		return
	end

	if not arg0._antiSubVigilanceState or arg0._antiSubVigilanceState:IsWeaponUseable() then
		local var0 = arg0._move:GetPos()
		local var1 = arg0._weaponRightBound
		local var2 = arg0._weaponLowerBound

		if (var1 == nil or var1 > var0.x) and (var2 == nil or var2 < var0.z) then
			arg0._weaponQueue:Update(arg1)
		end
	end

	if not arg0:IsAlive() then
		return
	end

	arg0:UpdateBuff(arg1)
end

function var9.UpdateAirAssist(arg0)
	if arg0._airAssistList then
		for iter0, iter1 in ipairs(arg0._airAssistList) do
			iter1:Update()
		end
	end
end

function var9.UpdatePhaseSwitcher(arg0)
	if arg0._phaseSwitcher then
		arg0._phaseSwitcher:Update()
	end
end

function var9.SetInterruptSickness(arg0, arg1)
	arg0._isSickness = arg1
end

function var9.SummonSickness(arg0, arg1)
	if arg0._isSickness == true then
		return
	end

	local function var0()
		arg0:RemoveSummonSickness()
	end

	arg0._isSickness = true
	arg0._sicknessTimer = pg.TimeMgr.GetInstance():AddBattleTimer("summonSickness", 0, arg1, var0, true)
end

function var9.RemoveSummonSickness(arg0)
	arg0._isSickness = false

	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._sicknessTimer)

	arg0._sicknessTimer = nil
end

function var9.GetTargetedPriority(arg0)
	local var0

	if arg0._aimBias then
		local var1 = arg0._aimBias:GetCurrentState()

		if var1 == arg0._aimBias.STATE_SKILL_EXPOSE or var1 == arg0._aimBias.STATE_TOTAL_EXPOSE then
			var0 = arg0:GetTemplate().battle_unit_type
		else
			var0 = -200
		end
	else
		var0 = arg0:GetTemplate().battle_unit_type
	end

	return var0
end

function var9.PlayFX(arg0, arg1, arg2)
	arg0:DispatchEvent(var0.Event.New(var1.PLAY_FX, {
		fxName = arg1,
		notAttach = not arg2
	}))
end

function var9.SwitchShader(arg0, arg1, arg2, arg3)
	arg0:DispatchEvent(var0.Event.New(var1.SWITCH_SHADER, {
		shader = arg1,
		color = arg2,
		args = arg3
	}))
end

function var9.SendAttackTrigger(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.SPAWN_CACHE_BULLET, {}))
end

function var9.HandleDamageToDeath(arg0)
	local var0 = {
		isMiss = false,
		isCri = true,
		isHeal = false,
		damageReason = var3.UnitDeathReason.DESTRUCT
	}

	arg0:UpdateHP(math.floor(-arg0._currentHP), var0)
end

function var9.UpdateHP(arg0, arg1, arg2)
	if not arg0:IsAlive() then
		return 0
	end

	local var0 = arg0:IsAlive()

	if not var0 then
		return 0
	end

	local var1 = arg2.isMiss
	local var2 = arg2.isCri
	local var3 = arg2.isHeal
	local var4 = arg2.isShare
	local var5 = arg2.attr
	local var6 = arg2.damageReason
	local var7 = arg2.font
	local var8 = arg2.cldPos
	local var9 = arg2.incorrupt
	local var10

	if not var3 then
		local var11 = {
			damage = -arg1,
			isShare = var4,
			miss = var1,
			cri = var2,
			damageSrc = arg2.srcID,
			damageAttr = var5,
			damageReason = var6
		}

		if not var4 then
			arg0:TriggerBuff(var3.BuffEffectType.ON_BEFORE_TAKE_DAMAGE, var11)

			if var11.capFlag then
				arg0:TriggerBuff(var3.BuffEffectType.ON_DAMAGE_FIX, var11)
			end
		end

		var10 = -var11.damage

		arg0:TriggerBuff(var3.BuffEffectType.ON_TAKE_DAMAGE, var11)

		if arg0._currentHP <= var11.damage then
			arg0:TriggerBuff(var3.BuffEffectType.ON_BEFORE_FATAL_DAMAGE, {})
		end

		arg1 = -var11.damage

		if var10 ~= arg1 then
			({}).absorb = var10 - arg1

			arg0:TriggerBuff(var3.BuffEffectType.ON_SHIELD_ABSORB, var11)
		end

		if var6.IsInvincible(arg0) then
			return 0
		end
	else
		var10 = arg1

		local var12 = {
			damage = arg1,
			isHeal = var3,
			incorrupt = var9
		}

		arg0:TriggerBuff(var3.BuffEffectType.ON_TAKE_HEALING, var12)

		var3 = var12.isHeal
		arg1 = var12.damage

		local var13 = math.max(0, arg0._currentHP + arg1 - arg0:GetMaxHP())

		if var13 > 0 then
			arg0:TriggerBuff(var3.BuffEffectType.ON_OVER_HEALING, {
				overHealing = var13
			})
		end
	end

	local var14 = math.min(arg0:GetMaxHP(), math.max(0, arg0._currentHP + arg1))
	local var15 = var14 - arg0._currentHP

	arg0:SetCurrentHP(var14)

	local var16 = {
		preShieldHP = var10,
		dHP = arg1,
		validDHP = var15,
		isMiss = var1,
		isCri = var2,
		isHeal = var3,
		font = var7
	}

	if var8 and not var8:EqualZero() then
		local var17 = arg0:GetPosition()
		local var18 = arg0:GetBoxSize().x
		local var19 = var17.x - var18
		local var20 = var17.x + var18
		local var21 = var8:Clone()

		var21.x = Mathf.Clamp(var21.x, var19, var20)
		var16.posOffset = var17 - var21
	end

	arg0:UpdateHPAction(var16)

	if not arg0:IsAlive() and var0 then
		arg0:SetDeathReason(arg2.damageReason)
		arg0:DeadAction()
	end

	if arg0:IsAlive() then
		arg0:TriggerBuff(var3.BuffEffectType.ON_HP_RATIO_UPDATE, {
			dHP = arg1,
			unit = arg0,
			validDHP = var15
		})
	end

	return arg1
end

function var9.UpdateHPAction(arg0, arg1)
	arg0:DispatchEvent(var0.Event.New(var1.UPDATE_HP, arg1))
end

function var9.DeadAction(arg0)
	arg0:TriggerBuff(var3.BuffEffectType.ON_SINK, {})
	arg0:DeacActionClear()
end

function var9.DeacActionClear(arg0)
	arg0._aliveState = false

	var6.Spirit(arg0)
	var6.AppendInvincible(arg0)
	arg0:DeadActionEvent()
end

function var9.DeadActionEvent(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.WILL_DIE, {}))
	arg0:DispatchEvent(var0.Event.New(var1.DYING, {}))
end

function var9.SendDeadEvent(arg0)
	arg0:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.DYING, {}))
end

function var9.SetDeathReason(arg0, arg1)
	arg0._deathReason = arg1
end

function var9.GetDeathReason(arg0)
	return arg0._deathReason or var3.UnitDeathReason.KILLED
end

function var9.DispatchScorePoint(arg0, arg1)
	arg0:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.UPDATE_SCORE, {
		score = arg1
	}))
end

function var9.SetTemplate(arg0, arg1, arg2)
	arg0._tmpID = arg1
end

function var9.GetTemplateID(arg0)
	return arg0._tmpID
end

function var9.SetOverrideLevel(arg0, arg1)
	arg0._overrideLevel = arg1
end

function var9.SetSkinId(arg0)
	return
end

function var9.SetGearScore(arg0, arg1)
	arg0._GS = arg1
end

function var9.GetGearScore(arg0)
	return arg0._GS or 0
end

function var9.GetSkinID(arg0)
	return arg0._tmpID
end

function var9.GetDefaultSkinID(arg0)
	return arg0._tmpID
end

function var9.GetSkinAttachmentInfo(arg0)
	return arg0._orbitSkinIDList
end

function var9.GetWeaponBoundBone(arg0)
	return arg0._tmpData.bound_bone
end

function var9.ActionKeyOffsetUseable(arg0)
	return true
end

function var9.RemoveRemoteBoundBone(arg0, arg1)
	arg0._remoteBoundBone[arg1] = nil
end

function var9.SetRemoteBoundBone(arg0, arg1, arg2, arg3)
	local var0 = arg0._remoteBoundBone[arg1] or {}

	var0[arg2] = arg3
	arg0._remoteBoundBone[arg1] = var0
end

function var9.GetRemoteBoundBone(arg0, arg1)
	for iter0, iter1 in pairs(arg0._remoteBoundBone) do
		local var0 = iter1[arg1]

		if var0 then
			local var1 = var0.Battle.BattleTargetChoise.TargetFleetIndex(arg0, {
				fleetPos = var0
			})[1]

			if var1 and var1:IsAlive() then
				local var2 = Clone(var1:GetPosition())

				var2:Set(var2.x, 1.5, var2.z)

				return var2
			end
		end
	end
end

function var9.GetLabelTag(arg0)
	return arg0._labelTagList
end

function var9.ContainsLabelTag(arg0, arg1)
	if arg0._labelTagList == nil then
		return false
	end

	for iter0, iter1 in ipairs(arg1) do
		if table.contains(arg0._labelTagList, iter1) then
			return true
		end
	end

	return false
end

function var9.AddLabelTag(arg0, arg1)
	table.insert(arg0._labelTagList, arg1)

	local var0 = var6.GetCurrent(arg0, "labelTag")

	var0[arg1] = (var0[arg1] or 0) + 1
end

function var9.RemoveLabelTag(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._labelTagList) do
		if iter1 == arg1 then
			table.remove(arg0._labelTagList, iter0)

			local var0 = var6.GetCurrent(arg0, "labelTag")

			var0[arg1] = var0[arg1] - 1

			break
		end
	end
end

function var9.setStandardLabelTag(arg0)
	local var0 = "N_" .. arg0._tmpData.nationality
	local var1 = "T_" .. arg0._tmpData.type

	arg0:AddLabelTag(var0)
	arg0:AddLabelTag(var1)
end

function var9.GetRarity(arg0)
	return
end

function var9.GetIntimacy(arg0)
	return 0
end

function var9.IsBoss(arg0)
	return false
end

function var9.GetSpeedRatio(arg0)
	return var4.GetSpeedRatio(arg0:GetSpeedExemptKey(), arg0._IFF)
end

function var9.GetSpeedExemptKey(arg0)
	return arg0._speedExemptKey
end

function var9.SetMoveCast(arg0, arg1)
	arg0._moveCast = arg1
end

function var9.IsMoveCast(arg0)
	return arg0._moveCast
end

function var9.SetCrash(arg0, arg1)
	arg0._isCrash = arg1

	if arg1 then
		local var0 = var0.Battle.BattleBuffUnit.New(var5.SHIP_CLD_BUFF)

		arg0:AddBuff(var0)
	else
		arg0:RemoveBuff(var5.SHIP_CLD_BUFF)
	end
end

function var9.IsCrash(arg0)
	return arg0._isCrash
end

function var9.OverrideDeadFX(arg0, arg1)
	arg0._deadFX = arg1
end

function var9.GetDeadFX(arg0)
	return arg0._deadFX
end

function var9.SetEquipment(arg0, arg1)
	arg0._equipmentList = arg1
	arg0._autoWeaponList = {}
	arg0._manualTorpedoList = {}
	arg0._chargeList = {}
	arg0._AAList = {}
	arg0._fleetAAList = {}
	arg0._fleetRangeAAList = {}
	arg0._hiveList = {}
	arg0._totalWeapon = {}

	arg0:setWeapon(arg1)
end

function var9.GetEquipment(arg0)
	return arg0._equipmentList
end

function var9.SetProficiencyList(arg0, arg1)
	arg0._proficiencyList = arg1
end

function var9.SetSpWeapon(arg0, arg1)
	arg0._spWeapon = arg1
end

function var9.GetSpWeapon(arg0)
	return arg0._spWeapon
end

function var9.setWeapon(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1.equipment.weapon_id

		for iter2, iter3 in ipairs(var0) do
			if iter3 ~= -1 then
				local var1 = var0.Battle.BattleDataFunction.CreateWeaponUnit(iter3, arg0, nil, iter0)

				arg0._totalWeapon[#arg0._totalWeapon + 1] = var1

				local var2 = var1:GetTemplateData().type

				if var2 == var3.EquipmentType.MANUAL_TORPEDO then
					arg0._manualTorpedoList[#arg0._manualTorpedoList + 1] = var1

					arg0._weaponQueue:AppendWeapon(var1)
				elseif var2 == var3.EquipmentType.STRIKE_AIRCRAFT then
					-- block empty
				else
					assert(#var0 < 2, "自动武器一组不允许配置多个")
					arg0:AddAutoWeapon(var1)
				end

				if var2 == var3.EquipmentType.INTERCEPT_AIRCRAFT or var2 == var3.EquipmentType.STRIKE_AIRCRAFT then
					arg0._hiveList[#arg0._hiveList + 1] = var1
				end

				if var2 == var3.EquipmentType.ANTI_AIR then
					arg0._AAList[#arg0._AAList + 1] = var1
				end
			end
		end
	end
end

function var9.CheckWeaponInitial(arg0)
	arg0._weaponQueue:CheckWeaponInitalCD()

	if arg0._airAssistQueue then
		arg0._airAssistQueue:CheckWeaponInitalCD()
	end

	arg0:DispatchEvent(var0.Event.New(var1.INIT_COOL_DOWN, {}))
end

function var9.FlushReloadingWeapon(arg0)
	arg0._weaponQueue:FlushWeaponReloadRequire()

	if arg0._airAssistQueue then
		arg0._airAssistQueue:FlushWeaponReloadRequire()
	end
end

function var9.AddNewAutoWeapon(arg0, arg1)
	local var0 = var7.CreateWeaponUnit(arg1, arg0)

	arg0:AddAutoWeapon(var0)
	arg0:DispatchEvent(var0.Event.New(var0.Battle.BattleBuffEvent.BUFF_EFFECT_NEW_WEAPON, {
		weapon = var0
	}))

	return var0
end

function var9.AddAutoWeapon(arg0, arg1)
	arg0._autoWeaponList[#arg0._autoWeaponList + 1] = arg1

	arg0._weaponQueue:AppendWeapon(arg1)
end

function var9.RemoveAutoWeapon(arg0, arg1)
	arg0._weaponQueue:RemoveWeapon(arg1)

	local var0 = 1
	local var1 = #arg0._autoWeaponList

	while var0 <= var1 do
		if arg0._autoWeaponList[var0] == arg1 then
			arg0:DispatchEvent(var0.Event.New(var1.REMOVE_WEAPON, {
				weapon = arg1
			}))
			table.remove(arg0._autoWeaponList, var0)

			break
		end

		var0 = var0 + 1
	end
end

function var9.RemoveAutoWeaponByWeaponID(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._autoWeaponList) do
		if iter1:GetWeaponId() == arg1 then
			iter1:Clear()
			arg0:RemoveAutoWeapon(iter1)

			break
		end
	end
end

function var9.RemoveAllAutoWeapon(arg0)
	local var0 = #arg0._autoWeaponList

	while var0 > 0 do
		local var1 = arg0._autoWeaponList[var0]

		var1:Clear()
		arg0:RemoveAutoWeapon(var1)

		var0 = var0 - 1
	end
end

function var9.AddFleetAntiAirWeapon(arg0, arg1)
	return
end

function var9.RemoveFleetAntiAirWeapon(arg0, arg1)
	return
end

function var9.AttachFleetRangeAAWeapon(arg0, arg1)
	arg0._fleetRangeAA = arg1

	arg0:DispatchEvent(var0.Event.New(var1.CREATE_TEMPORARY_WEAPON, {
		weapon = arg1
	}))
end

function var9.DetachFleetRangeAAWeapon(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.REMOVE_WEAPON, {
		weapon = arg0._fleetRangeAA
	}))

	arg0._fleetRangeAA = nil
end

function var9.GetFleetRangeAAWeapon(arg0)
	return arg0._fleetRangeAA
end

function var9.ShiftWeapon(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg1) do
		arg0:RemoveAutoWeaponByWeaponID(iter1)
	end

	for iter2, iter3 in ipairs(arg2) do
		arg0:AddNewAutoWeapon(iter3):InitialCD()
	end
end

function var9.ExpandWeaponMount(arg0, arg1)
	if arg1 == "airAssist" then
		var7.ExpandAllinStrike(arg0)
	end
end

function var9.ReduceWeaponMount(arg0, arg1)
	return
end

function var9.CeaseAllWeapon(arg0, arg1)
	arg0._ceaseFire = arg1
end

function var9.IsCease(arg0)
	return arg0._ceaseFire
end

function var9.GetAllWeapon(arg0)
	return arg0._totalWeapon
end

function var9.GetTotalWeapon(arg0)
	return arg0._weaponQueue:GetTotalWeaponUnit()
end

function var9.GetAutoWeapons(arg0)
	return arg0._autoWeaponList
end

function var9.GetChargeList(arg0)
	return arg0._chargeList
end

function var9.GetChargeQueue(arg0)
	return arg0._weaponQueue:GetChargeWeaponQueue()
end

function var9.GetAntiAirWeapon(arg0)
	return arg0._AAList
end

function var9.GetFleetAntiAirList(arg0)
	return arg0._fleetAAList
end

function var9.GetFleetRangeAntiAirList(arg0)
	return arg0._fleetRangeAAList
end

function var9.GetTorpedoList(arg0)
	return arg0._manualTorpedoList
end

function var9.GetTorpedoQueue(arg0)
	return arg0._weaponQueue:GetManualTorpedoQueue()
end

function var9.GetWeaponByIndex(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._totalWeapon) do
		if iter1:GetEquipmentIndex() == arg1 then
			return iter1
		end
	end
end

function var9.GetHiveList(arg0)
	return arg0._hiveList
end

function var9.SetAirAssistList(arg0, arg1)
	arg0._airAssistList = arg1
	arg0._airAssistQueue = var0.Battle.ManualWeaponQueue.New(arg0:GetManualWeaponParallel()[var3.ManualWeaponIndex.AIR_ASSIST])

	for iter0, iter1 in ipairs(arg0._airAssistList) do
		arg0._airAssistQueue:AppendWeapon(iter1)
	end
end

function var9.GetAirAssistList(arg0)
	return arg0._airAssistList
end

function var9.GetAirAssistQueue(arg0)
	return arg0._airAssistQueue
end

function var9.GetManualWeaponParallel(arg0)
	return {
		1,
		1,
		1
	}
end

function var9.configWeaponQueueParallel(arg0)
	local var0 = arg0:GetManualWeaponParallel()

	arg0._weaponQueue:ConfigParallel(var0[var3.ManualWeaponIndex.CALIBRATION], var0[var3.ManualWeaponIndex.TORPEDO])
end

function var9.ClearWeapon(arg0)
	arg0._weaponQueue:ClearAllWeapon()

	local var0 = arg0._airAssistList

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			iter1:Clear()
		end
	end
end

function var9.GetSpeed(arg0)
	return arg0._move:GetSpeed()
end

function var9.GetPosition(arg0)
	return arg0._move:GetPos()
end

function var9.GetBornPosition(arg0)
	return arg0._bornPos
end

function var9.GetCLDZCenterPosition(arg0)
	local var0 = arg0._battleProxy.FrameIndex

	if arg0._zCenterFrame ~= var0 then
		arg0._zCenterFrame = var0

		local var1 = arg0:GetCldBox()

		arg0._cldZCenterCache = (var1.min + var1.max) * 0.5
	end

	return arg0._cldZCenterCache
end

function var9.GetBeenAimedPosition(arg0)
	local var0 = arg0:GetCLDZCenterPosition()

	if not var0 then
		return var0
	end

	local var1 = arg0:GetTemplate() and arg0:GetTemplate().aim_offset

	if not var1 then
		return var0
	end

	local var2 = Vector3(var0.x + var1[1], var0.y + var1[2], var0.z + var1[3])

	arg0:biasAimPosition(var2)

	return var2
end

function var9.biasAimPosition(arg0, arg1)
	local var0 = var6.GetCurrent(arg0, "aimBias")

	if var0 > 0 then
		local var1 = var0 * 2
		local var2 = math.random() * var1 - var0
		local var3 = math.random() * var1 - var0

		arg1:Set(arg1.x + var2, arg1.y, arg1.z + var3)
	end

	return arg1
end

function var9.CancelFollowTeam(arg0)
	arg0._move:CancelFormationCtrl()
end

function var9.UpdateFormationOffset(arg0, arg1)
	arg0._move:SetFormationCtrlInfo(Vector3(arg1.x, arg1.y, arg1.z))
end

function var9.GetDistance(arg0, arg1)
	local var0 = arg0._battleProxy.FrameIndex

	if arg0._frame ~= var0 then
		arg0._distanceBackup = {}
		arg0._frame = var0
	end

	local var1 = arg0._distanceBackup[arg1]

	if var1 == nil then
		var1 = Vector3.Distance(arg0:GetPosition(), arg1:GetPosition())
		arg0._distanceBackup[arg1] = var1

		arg1:backupDistance(arg0, var1)
	end

	return var1
end

function var9.backupDistance(arg0, arg1, arg2)
	local var0 = arg0._battleProxy.FrameIndex

	if arg0._frame ~= var0 then
		arg0._distanceBackup = {}
		arg0._frame = var0
	end

	arg0._distanceBackup[arg1] = arg2
end

function var9.GetDirection(arg0)
	return arg0._dir
end

function var9.SetBornPosition(arg0, arg1)
	arg0._bornPos = arg1
end

function var9.SetPosition(arg0, arg1)
	arg0._move:SetPos(arg1)
end

function var9.IsMoving(arg0)
	local var0 = arg0._move:GetSpeed()

	return var0.x ~= 0 or var0.z ~= 0
end

function var9.SetUncontrollableSpeedWithYAngle(arg0, arg1, arg2, arg3)
	local var0 = math.deg2Rad * arg1
	local var1 = Vector3(math.cos(var0), 0, math.sin(var0))

	arg0:SetUncontrollableSpeed(var1, arg2, arg3)
end

function var9.SetUncontrollableSpeedWithDir(arg0, arg1, arg2, arg3)
	local var0 = math.sqrt(arg1.x * arg1.x + arg1.z * arg1.z)

	arg0:SetUncontrollableSpeed(arg1 / var0, arg2, arg3)
end

function var9.SetUncontrollableSpeed(arg0, arg1, arg2, arg3)
	if not arg2 or not arg3 then
		return
	end

	arg0._move:SetForceMove(arg1, arg2, arg3, arg2 / arg3)
end

function var9.ClearUncontrollableSpeed(arg0)
	arg0._move:ClearForceMove()
end

function var9.SetAdditiveSpeed(arg0, arg1)
	arg0._move:UpdateAdditiveSpeed(arg1)
end

function var9.RemoveAdditiveSpeed(arg0)
	arg0._move:RemoveAdditiveSpeed()
end

function var9.Boost(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._move:SetForceMove(arg1, arg2, arg3, arg4, arg5)
end

function var9.ActiveUnstoppable(arg0, arg1)
	arg0._move:ActiveUnstoppable(arg1)
end

function var9.SetImmuneCommonBulletCLD(arg0)
	arg0._immuneCommonBulletCLD = true
end

function var9.IsImmuneCommonBulletCLD(arg0)
	return arg0._immuneCommonBulletCLD
end

function var9.SetWeaponPreCastBound(arg0, arg1)
	arg0._preCastBound = arg1

	arg0:UpdatePrecastMoveLimit()
end

function var9.EnterGCD(arg0, arg1, arg2)
	if arg0._GCDTimerList[arg2] ~= nil then
		return
	end

	local function var0()
		arg0:RemoveGCDTimer(arg2)
	end

	arg0._weaponQueue:QueueEnterGCD(arg2, arg1)

	arg0._GCDTimerList[arg2] = pg.TimeMgr.GetInstance():AddBattleTimer("weaponGCD", 0, arg1, var0, true)

	arg0:UpdatePrecastMoveLimit()
end

function var9.RemoveGCDTimer(arg0, arg1)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._GCDTimerList[arg1])

	arg0._GCDTimerList[arg1] = nil

	arg0:UpdatePrecastMoveLimit()
end

function var9.UpdatePrecastMoveLimit(arg0)
	arg0:UpdateMoveLimit()
end

function var9.UpdateMoveLimit(arg0)
	local var0 = arg0:IsMoveAble()

	arg0._move:SetStaticState(not var0)
end

function var9.AddBuff(arg0, arg1, arg2)
	local var0 = arg1:GetID()
	local var1 = {
		unit_id = arg0._uniqueID,
		buff_id = var0
	}
	local var2 = arg0:GetBuff(var0)

	if var2 then
		local var3 = var2:GetLv()
		local var4 = arg1:GetLv()

		if arg2 then
			local var5 = arg0._buffStockList[var0] or {}

			table.insert(var5, arg1)

			arg0._buffStockList[var0] = var5
		else
			var1.buff_level = math.max(var3, var4)

			if var4 <= var3 then
				var2:Stack(arg0)

				var1.stack_count = var2:GetStack()

				arg0:DispatchEvent(var0.Event.New(var2.BUFF_STACK, var1))
			else
				arg0:DispatchEvent(var0.Event.New(var2.BUFF_CAST, var1))
				arg0:RemoveBuff(var0)

				arg0._buffList[var0] = arg1

				arg1:Attach(arg0)
				arg0:DispatchEvent(var0.Event.New(var2.BUFF_ATTACH, var1))
			end
		end
	else
		arg0:DispatchEvent(var0.Event.New(var2.BUFF_CAST, var1))

		arg0._buffList[var0] = arg1

		arg1:Attach(arg0)

		var1.buff_level = arg1:GetLv()

		arg0:DispatchEvent(var0.Event.New(var2.BUFF_ATTACH, var1))
	end

	arg0:TriggerBuff(var3.BuffEffectType.ON_BUFF_ADDED, {
		buffID = var0
	})
end

function var9.SetBuffStack(arg0, arg1, arg2, arg3)
	if arg3 <= 0 then
		arg0:RemoveBuff(arg1)
	else
		local var0 = arg0:GetBuff(arg1)

		if var0 then
			var0:UpdateStack(arg0, arg3)

			return var0
		else
			local var1 = var0.Battle.BattleBuffUnit.New(arg1, arg2)

			arg0:AddBuff(var1)
			var1:UpdateStack(arg0, arg3)

			return var1
		end
	end
end

function var9.UpdateBuff(arg0, arg1)
	local var0 = arg0._buffList

	for iter0, iter1 in pairs(var0) do
		iter1:Update(arg0, arg1)

		if not arg0:IsAlive() then
			break
		end
	end
end

function var9.ConsumeBuffStack(arg0, arg1, arg2)
	local var0 = arg0:GetBuff(arg1)

	if var0 then
		if not arg2 then
			arg0:RemoveBuff(arg1)
		else
			local var1 = var0:GetStack()
			local var2 = math.max(0, var1 - arg2)

			if var2 == 0 then
				arg0:RemoveBuff(arg1)
			else
				var0:UpdateStack(arg0, var2)
			end
		end
	end
end

function var9.RemoveBuff(arg0, arg1, arg2)
	if arg2 and arg0._buffStockList[arg1] then
		local var0 = table.remove(arg0._buffStockList[arg1])

		if var0 then
			var0:Clear()

			return
		end
	end

	local var1 = arg0:GetBuff(arg1)

	if var1 then
		var1:Remove()
	end

	arg0:TriggerBuff(var3.BuffEffectType.ON_BUFF_REMOVED, {
		buffID = arg1
	})
end

function var9.ClearBuff(arg0)
	local var0 = arg0._buffList

	for iter0, iter1 in pairs(var0) do
		iter1:Clear()
	end

	local var1 = arg0._buffStockList

	for iter2, iter3 in pairs(var1) do
		for iter4, iter5 in pairs(iter3) do
			iter5:Clear()
		end
	end
end

function var9.TriggerBuff(arg0, arg1, arg2)
	var0.Battle.BattleBuffUnit.Trigger(arg0, arg1, arg2)
end

function var9.GetBuffList(arg0)
	return arg0._buffList
end

function var9.GetBuff(arg0, arg1)
	arg0._buffList = arg0._buffList

	return arg0._buffList[arg1]
end

function var9.DispatchSkillFloat(arg0, arg1, arg2, arg3)
	local var0 = {
		coverHrzIcon = arg3,
		commander = arg2,
		skillName = arg1
	}

	arg0:DispatchEvent(var0.Event.New(var1.SKILL_FLOAT, var0))
end

function var9.DispatchCutIn(arg0, arg1, arg2)
	local var0 = {
		caster = arg0,
		skill = arg1
	}

	arg0:DispatchEvent(var0.Event.New(var1.CUT_INT, var0))
end

function var9.DispatchCastClock(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = {
		isActive = arg1,
		buffEffect = arg2,
		iconType = arg3,
		interrupt = arg4,
		reverse = arg5
	}

	arg0:DispatchEvent(var0.Event.New(var1.ADD_BUFF_CLOCK, var0))
end

function var9.SetAI(arg0, arg1)
	local var0 = var7.GetAITmpDataFromID(arg1)

	arg0._autoPilotAI = var0.Battle.AutoPilot.New(arg0, var0), arg0._move:CancelFormationCtrl()
end

function var9.AddPhaseSwitcher(arg0, arg1)
	arg0._phaseSwitcher = arg1
end

function var9.GetPhaseSwitcher(arg0)
	return arg0._phaseSwitcher
end

function var9.StateChange(arg0, arg1, arg2)
	arg0._unitState:ChangeState(arg1, arg2)
end

function var9.UpdateAction(arg0)
	local var0 = arg0:GetSpeed().x * arg0._IFF

	if arg0._oxyState and arg0._oxyState:GetCurrentDiveState() == var3.OXY_STATE.DIVE then
		if var0 >= 0 then
			arg0._unitState:ChangeState(var8.STATE_DIVE)
		else
			arg0._unitState:ChangeState(var8.STATE_DIVELEFT)
		end
	elseif var0 >= 0 then
		arg0._unitState:ChangeState(var8.STATE_MOVE)
	else
		arg0._unitState:ChangeState(var8.STATE_MOVELEFT)
	end
end

function var9.SetActionKeyOffset(arg0, arg1)
	arg0._actionKeyOffset = arg1

	arg0._unitState:FreshActionKeyOffset()
end

function var9.GetActionKeyOffset(arg0)
	return arg0._actionKeyOffset
end

function var9.GetCurrentState(arg0)
	return arg0._unitState:GetCurrentStateName()
end

function var9.NeedWeaponCache(arg0)
	return arg0._unitState:NeedWeaponCache()
end

function var9.CharacterActionTriggerCallback(arg0)
	arg0._unitState:OnActionTrigger()
end

function var9.CharacterActionEndCallback(arg0)
	arg0._unitState:OnActionEnd()
end

function var9.CharacterActionStartCallback(arg0)
	return
end

function var9.DispatchChat(arg0, arg1, arg2, arg3)
	if not arg1 or #arg1 == 0 then
		return
	end

	local var0 = {
		content = HXSet.hxLan(arg1),
		duration = arg2,
		key = arg3
	}

	arg0:DispatchEvent(var0.Event.New(var1.POP_UP, var0))
end

function var9.DispatchVoice(arg0, arg1)
	local var0 = arg0:GetIntimacy()
	local var1, var2, var3 = ShipWordHelper.GetWordAndCV(arg0:GetSkinID(), arg1, 1, true, var0)

	if var2 then
		local var4 = {
			content = var2,
			key = arg1
		}

		arg0:DispatchEvent(var0.Event.New(var1.VOICE, var4))
	end
end

function var9.GetHostileCldList(arg0)
	return arg0._hostileCldList
end

function var9.AppendHostileCld(arg0, arg1, arg2)
	arg0._hostileCldList[arg1] = arg2
end

function var9.RemoveHostileCld(arg0, arg1)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._hostileCldList[arg1])

	arg0._hostileCldList[arg1] = nil
end

function var9.GetExtraInfo(arg0)
	return arg0._extraInfo
end

function var9.GetTemplate(arg0)
	return nil
end

function var9.GetTemplateValue(arg0, arg1)
	return arg0:GetTemplate()[arg1]
end

function var9.GetUniqueID(arg0)
	return arg0._uniqueID
end

function var9.SetIFF(arg0, arg1)
	arg0._IFF = arg1

	if arg1 == var5.FRIENDLY_CODE then
		arg0._dir = var3.UnitDir.RIGHT
	elseif arg1 == var5.FOE_CODE then
		arg0._dir = var3.UnitDir.LEFT
	end
end

function var9.GetIFF(arg0)
	return arg0._IFF
end

function var9.GetUnitType(arg0)
	return arg0._type
end

function var9.GetHPRate(arg0)
	return arg0._currentHPRate
end

function var9.GetHP(arg0)
	return arg0._currentHP, arg0:GetMaxHP()
end

function var9.GetCurrentHP(arg0)
	return arg0._currentHP
end

function var9.SetCurrentHP(arg0, arg1)
	arg0._currentHP = arg1
	arg0._currentHPRate = arg0._currentHP / arg0:GetMaxHP()
	arg0._currentDMGRate = 1 - arg0._currentHPRate

	var6.SetCurrent(arg0, "HPRate", arg0._currentHPRate)
	var6.SetCurrent(arg0, "DMGRate", arg0._currentDMGRate)
end

function var9.GetAttr(arg0)
	return var6.GetAttr(arg0)
end

function var9.GetAttrByName(arg0, arg1)
	return var6.GetCurrent(arg0, arg1)
end

function var9.GetMaxHP(arg0)
	return arg0:GetAttrByName("maxHP")
end

function var9.GetReload(arg0)
	return arg0:GetAttrByName("loadSpeed")
end

function var9.GetTorpedoPower(arg0)
	return arg0:GetAttrByName("torpedoPower")
end

function var9.CanDoAntiSub(arg0)
	return arg0:GetAttrByName("antiSubPower") > 0
end

function var9.IsShowHPBar(arg0)
	return false
end

function var9.IsAlive(arg0)
	local var0 = arg0:GetCurrentHP()

	return arg0._aliveState and var0 > 0
end

function var9.SetMainFleetUnit(arg0)
	arg0._isMainFleetUnit = true

	arg0:SetMainUnitStatic(true)
end

function var9.IsMainFleetUnit(arg0)
	return arg0._isMainFleetUnit
end

function var9.SetMainUnitStatic(arg0, arg1)
	arg0._isMainStatic = arg1

	arg0._move:SetStaticState(arg1)
end

function var9.SetMainUnitIndex(arg0, arg1)
	arg0._mainUnitIndex = arg1
end

function var9.GetMainUnitIndex(arg0)
	return arg0._mainUnitIndex or 1
end

function var9.IsMoveAble(arg0)
	local var0 = table.getCount(arg0._GCDTimerList) > 0 or arg0._preCastBound
	local var1 = var6.IsStun(arg0)
	local var2 = arg0:IsMoveCast()

	return not arg0._isMainStatic and (var2 or not var0) and not var1
end

function var9.Reinforce(arg0)
	arg0._isReinforcement = true
end

function var9.IsReinforcement(arg0)
	return arg0._isReinforcement
end

function var9.SetReinforceCastTime(arg0, arg1)
	arg0._reinforceCastTime = arg1
end

function var9.GetReinforceCastTime(arg0)
	return arg0._reinforceCastTime
end

function var9.GetFleetVO(arg0)
	return
end

function var9.SetFormationIndex(arg0, arg1)
	return
end

function var9.SetMaster(arg0)
	return
end

function var9.GetMaster(arg0)
	return nil
end

function var9.IsSpectre(arg0)
	return
end

function var9.Clear(arg0)
	arg0._aliveState = false

	for iter0, iter1 in pairs(arg0._hostileCldList) do
		arg0:RemoveHostileCld(iter0)
	end

	arg0:ClearWeapon()
	arg0:ClearBuff()

	arg0._distanceBackup = {}
end

function var9.Dispose(arg0)
	arg0._exposedList = nil
	arg0._phaseSwitcher = nil

	arg0._weaponQueue:Dispose()

	if arg0._airAssistQueue then
		arg0._airAssistQueue:Clear()

		arg0._airAssistQueue = nil
	end

	arg0._equipmentList = nil
	arg0._totalWeapon = nil

	local var0 = arg0._airAssistList

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			iter1:Dispose()
		end
	end

	for iter2, iter3 in ipairs(arg0._fleetAAList) do
		iter3:Dispose()
	end

	for iter4, iter5 in ipairs(arg0._fleetRangeAAList) do
		iter5:Dispose()
	end

	local var1 = arg0._buffList

	for iter6, iter7 in pairs(var1) do
		iter7:Dispose()
	end

	local var2 = arg0._buffStockList

	for iter8, iter9 in pairs(var2) do
		for iter10, iter11 in pairs(iter9) do
			iter11:Clear()
		end
	end

	arg0._fleetRangeAA = nil
	arg0._aimBias = nil
	arg0._buffList = nil
	arg0._buffStockList = nil
	arg0._cldZCenterCache = nil
	arg0._remoteBoundBone = nil

	arg0:RemoveSummonSickness()
	var0.EventDispatcher.DetachEventDispatcher(arg0)
end

function var9.InitCldComponent(arg0)
	local var0 = arg0:GetTemplate().cld_box
	local var1 = arg0:GetTemplate().cld_offset
	local var2 = var1[1]

	if arg0:GetDirection() == var3.UnitDir.LEFT then
		var2 = var2 * -1
	end

	arg0._cldComponent = var0.Battle.BattleCubeCldComponent.New(var0[1], var0[2], var0[3], var2, var1[3] + var0[3] / 2)
end

function var9.GetBoxSize(arg0)
	return arg0._cldComponent:GetCldBoxSize()
end

function var9.GetCldBox(arg0)
	return arg0._cldComponent:GetCldBox(arg0:GetPosition())
end

function var9.GetCldData(arg0)
	return arg0._cldComponent:GetCldData()
end

function var9.InitOxygen(arg0)
	arg0._maxOxy = arg0:GetAttrByName("oxyMax")
	arg0._currentOxy = arg0:GetAttrByName("oxyMax")
	arg0._oxyRecovery = arg0:GetAttrByName("oxyRecovery")
	arg0._oxyRecoveryBench = arg0:GetAttrByName("oxyRecoveryBench")
	arg0._oxyRecoverySurface = arg0:GetAttrByName("oxyRecoverySurface")
	arg0._oxyConsume = arg0:GetAttrByName("oxyCost")
	arg0._oxyState = var0.Battle.OxyState.New(arg0)

	arg0._oxyState:OnDiveState()
	arg0:ConfigBubbleFX()

	return arg0._oxyState
end

function var9.UpdateOxygen(arg0, arg1)
	if arg0._oxyState then
		arg0._lastOxyUpdateStamp = arg0._lastOxyUpdateStamp or arg1

		arg0._oxyState:UpdateOxygen()

		if arg0._oxyState:GetNextBubbleStamp() and arg1 > arg0._oxyState:GetNextBubbleStamp() then
			arg0._oxyState:FlashBubbleStamp(arg1)
			arg0:PlayFX(arg0._bubbleFX, true)
		end

		arg0._lastOxyUpdateStamp = arg1

		arg0:updateSonarExposeTag()
	end
end

function var9.OxyRecover(arg0, arg1)
	local var0

	if arg1 == var0.Battle.OxyState.STATE_FREE_BENCH then
		var0 = arg0._oxyRecoveryBench
	elseif arg1 == var0.Battle.OxyState.STATE_FREE_FLOAT then
		var0 = arg0._oxyRecovery
	else
		var0 = arg0._oxyRecoverySurface
	end

	local var1 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._lastOxyUpdateStamp

	arg0._currentOxy = math.min(arg0._maxOxy, arg0._currentOxy + var0 * var1)
end

function var9.OxyConsume(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._lastOxyUpdateStamp

	arg0._currentOxy = math.max(0, arg0._currentOxy - arg0._oxyConsume * var0)
end

function var9.ChangeOxygenState(arg0, arg1)
	arg0._oxyState:ChangeState(arg1)
end

function var9.ChangeWeaponDiveState(arg0)
	for iter0, iter1 in ipairs(arg0._autoWeaponList) do
		iter1:ChangeDiveState()
	end
end

function var9.GetOxygenProgress(arg0)
	return arg0._currentOxy / arg0._maxOxy
end

function var9.GetCuurentOxygen(arg0)
	return arg0._currentOxy or 0
end

function var9.ConfigBubbleFX(arg0)
	return
end

function var9.SetDiveInvisible(arg0, arg1)
	arg0._diveInvisible = arg1

	arg0:DispatchEvent(var0.Event.New(var1.SUBMARINE_VISIBLE))
	arg0:DispatchEvent(var0.Event.New(var1.SUBMARINE_DETECTED))
	arg0:dispatchDetectedTrigger()
end

function var9.GetDiveInvisible(arg0)
	return arg0._diveInvisible
end

function var9.GetOxygenVisible(arg0)
	return arg0._oxyState and arg0._oxyState:GetBarVisible()
end

function var9.SetForceVisible(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.SUBMARINE_FORCE_DETECTED))
end

function var9.Detected(arg0, arg1)
	local var0

	if arg0._exposedToSnoar == false and not arg0._exposedOverTimeStamp then
		var0 = true
	end

	if arg1 then
		arg0:updateExposeTimeStamp(arg1)
	else
		arg0._exposedToSnoar = true
	end

	if var0 then
		arg0:DispatchEvent(var0.Event.New(var1.SUBMARINE_DETECTED, {}))
		arg0:dispatchDetectedTrigger()
	end
end

function var9.Undetected(arg0)
	arg0._exposedToSnoar = false

	arg0:updateExposeTimeStamp(var5.SUB_EXPOSE_LASTING_DURATION)
end

function var9.RemoveSonarExpose(arg0)
	arg0._exposedToSnoar = false
	arg0._exposedOverTimeStamp = nil
end

function var9.updateSonarExposeTag(arg0)
	if arg0._exposedOverTimeStamp and not arg0._exposedToSnoar and pg.TimeMgr.GetInstance():GetCombatTime() > arg0._exposedOverTimeStamp then
		arg0._exposedOverTimeStamp = nil

		arg0:DispatchEvent(var0.Event.New(var1.SUBMARINE_DETECTED, {
			detected = false
		}))
		arg0:dispatchDetectedTrigger()
	end
end

function var9.updateExposeTimeStamp(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime() + arg1

	arg0._exposedOverTimeStamp = arg0._exposedOverTimeStamp or 0
	arg0._exposedOverTimeStamp = var0 < arg0._exposedOverTimeStamp and arg0._exposedOverTimeStamp or var0
end

function var9.IsRunMode(arg0)
	return arg0._oxyState and arg0._oxyState:GetRundMode()
end

function var9.GetDiveDetected(arg0)
	return arg0:GetDiveInvisible() and (arg0._exposedOverTimeStamp or arg0._exposedToSnoar)
end

function var9.GetForceExpose(arg0)
	return arg0._oxyState and arg0._oxyState:GetForceExpose()
end

function var9.dispatchDetectedTrigger(arg0)
	if arg0:GetDiveDetected() then
		arg0:TriggerBuff(var3.BuffEffectType.ON_SUB_DETECTED, {})
	else
		arg0:TriggerBuff(var3.BuffEffectType.ON_SUB_UNDETECTED, {})
	end
end

function var9.GetRaidDuration(arg0)
	return arg0:GetAttrByName("oxyMax") / arg0:GetAttrByName("oxyCost")
end

function var9.EnterRaidRange(arg0)
	if arg0:GetPosition().x > arg0._subRaidLine then
		return true
	else
		return false
	end
end

function var9.EnterRetreatRange(arg0)
	if arg0:GetPosition().x < arg0._subRetreatLine then
		return true
	else
		return false
	end
end

function var9.GetOxyState(arg0)
	return arg0._oxyState
end

function var9.GetCurrentOxyState(arg0)
	if not arg0._oxyState then
		return var3.OXY_STATE.FLOAT
	else
		return arg0._oxyState:GetCurrentDiveState()
	end
end

function var9.InitAntiSubState(arg0, arg1, arg2)
	arg0._antiSubVigilanceState = var0.Battle.AntiSubState.New(arg0)

	arg0:DispatchEvent(var0.Event.New(var1.INIT_ANIT_SUB_VIGILANCE, {
		sonarRange = arg1
	}))

	return arg0._antiSubVigilanceState
end

function var9.GetAntiSubState(arg0)
	return arg0._antiSubVigilanceState
end

function var9.UpdateBlindInvisibleBySpectre(arg0)
	local var0, var1 = arg0:IsSpectre()

	if var1 <= var5.SPECTRE_UNIT_TYPE and var1 ~= var5.VISIBLE_SPECTRE_UNIT_TYPE then
		arg0:SetBlindInvisible(true)
	else
		arg0:SetBlindInvisible(false)
	end
end

function var9.SetBlindInvisible(arg0, arg1)
	arg0._exposedList = arg1 and {} or nil
	arg0._blindInvisible = arg1

	arg0:DispatchEvent(var0.Event.New(var1.BLIND_VISIBLE))
end

function var9.GetBlindInvisible(arg0)
	return arg0._blindInvisible
end

function var9.GetExposed(arg0)
	if not arg0._blindInvisible then
		return true
	end

	for iter0, iter1 in pairs(arg0._exposedList) do
		return true
	end
end

function var9.AppendExposed(arg0, arg1)
	if not arg0._blindInvisible then
		return
	end

	local var0 = arg0._exposedList[arg1]

	arg0._exposedList[arg1] = true

	if not var0 then
		arg0:DispatchEvent(var0.Event.New(var1.BLIND_EXPOSE))
	end
end

function var9.RemoveExposed(arg0, arg1)
	if not arg0._blindInvisible then
		return
	end

	arg0._exposedList[arg1] = nil

	arg0:DispatchEvent(var0.Event.New(var1.BLIND_EXPOSE))
end

function var9.SetWorldDeathMark(arg0)
	arg0._worldDeathMark = true
end

function var9.GetWorldDeathMark(arg0)
	return arg0._worldDeathMark
end

function var9.InitCloak(arg0)
	arg0._cloak = var0.Battle.BattleUnitCloakComponent.New(arg0)

	arg0:DispatchEvent(var0.Event.New(var1.INIT_CLOAK))

	return arg0._cloak
end

function var9.CloakOnFire(arg0, arg1)
	if arg0._cloak then
		arg0._cloak:UpdateDotExpose(arg1)
	end
end

function var9.CloakExpose(arg0, arg1)
	if arg0._cloak then
		arg0._cloak:AppendExpose(arg1)
	end
end

function var9.StrikeExpose(arg0)
	if arg0._cloak then
		arg0._cloak:AppendStrikeExpose()
	end
end

function var9.BombardExpose(arg0)
	if arg0._cloak then
		arg0._cloak:AppendBombardExpose()
	end
end

function var9.UpdateCloak(arg0, arg1)
	arg0._cloak:Update(arg1)
end

function var9.UpdateCloakConfig(arg0)
	if arg0._cloak then
		arg0._cloak:UpdateCloakConfig()
		arg0:DispatchEvent(var0.Event.New(var1.UPDATE_CLOAK_CONFIG))
	end
end

function var9.DispatchCloakStateUpdate(arg0)
	if arg0._cloak then
		arg0:DispatchEvent(var0.Event.New(var1.UPDATE_CLOAK_STATE))
	end
end

function var9.GetCloak(arg0)
	return arg0._cloak
end

function var9.AttachAimBias(arg0, arg1)
	arg0._aimBias = arg1

	arg0:DispatchEvent(var0.Event.New(var1.INIT_AIMBIAS))
end

function var9.DetachAimBias(arg0)
	arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIMBIAS))
	arg0._aimBias:RemoveCrew(arg0)

	arg0._aimBias = nil
end

function var9.ExitSmokeArea(arg0)
	arg0._aimBias:SmokeExitPause()
end

function var9.UpdateAimBiasSkillState(arg0)
	if arg0._aimBias and arg0._aimBias:GetHost() == arg0 then
		arg0._aimBias:UpdateSkillLock()
	end
end

function var9.HostAimBias(arg0)
	if arg0._aimBias then
		arg0:DispatchEvent(var0.Event.New(var1.HOST_AIMBIAS))
	end
end

function var9.GetAimBias(arg0)
	return arg0._aimBias
end

function var9.SwitchSpine(arg0, arg1, arg2)
	arg0:DispatchEvent(var0.Event.New(var1.SWITCH_SPINE, {
		skin = arg1,
		HPBarOffset = arg2
	}))
end

function var9.Freeze(arg0)
	for iter0, iter1 in ipairs(arg0._totalWeapon) do
		iter1:StartJamming()
	end

	if arg0._airAssistList then
		for iter2, iter3 in ipairs(arg0._airAssistList) do
			iter3:StartJamming()
		end
	end
end

function var9.ActiveFreeze(arg0)
	for iter0, iter1 in ipairs(arg0._totalWeapon) do
		iter1:JammingEliminate()
	end

	if arg0._airAssistList then
		for iter2, iter3 in ipairs(arg0._airAssistList) do
			iter3:JammingEliminate()
		end
	end
end

function var9.ActiveWeaponSectorView(arg0, arg1, arg2)
	local var0 = {
		weapon = arg1,
		isActive = arg2
	}

	arg0:DispatchEvent(var0.Event.New(var1.WEAPON_SECTOR, var0))
end
