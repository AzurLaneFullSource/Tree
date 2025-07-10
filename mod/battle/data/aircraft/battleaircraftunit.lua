ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = var0_0.Battle.BattleVariable
local var5_0 = var0_0.Battle.BattleDataFunction
local var6_0 = class("BattleAircraftUnit")

var0_0.Battle.BattleAircraftUnit = var6_0
var6_0.__name = "BattleAircraftUnit"
var6_0.STATE_CREATE = "Create"
var6_0.STATE_ATTACK = "Attack"
var6_0.STATE_DESTORY = "Destory"
var6_0.HEIGHT = var3_0.AircraftHeight + 5

function var6_0.Ctor(arg0_1, arg1_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._uniqueID = arg1_1
	arg0_1._speedExemptKey = "air_" .. arg1_1
	arg0_1._dir = var0_0.Battle.BattleConst.UnitDir.RIGHT
	arg0_1._type = var2_0.UnitType.AIRCRAFT_UNIT
	arg0_1._currentState = arg0_1.STATE_CREATE
	arg0_1._distanceBackup = {}
	arg0_1._battleProxy = var0_0.Battle.BattleDataProxy.GetInstance()
	arg0_1._frame = 0
	arg0_1._weaponPotential = 1

	arg0_1:Init()
end

function var6_0.SetBound(arg0_2, arg1_2, arg2_2)
	arg0_2._top = arg1_2
	arg0_2._bottom = arg2_2

	if arg0_2._tmpData.spawn_brownian == -1 then
		arg0_2._speedZ = 0
	else
		arg0_2._speedZ = (math.random() - 0.5) * 0.5
	end

	arg0_2:SetTargetZ()
end

function var6_0.SetViewBoundData(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3._cameraTop = arg1_3 + 3
	arg0_3._cameraBottom = arg2_3 - 23
	arg0_3._cameraLeft = arg3_3 - 3
	arg0_3._cameraRight = arg4_3 + 10
end

function var6_0.Update(arg0_4, arg1_4)
	arg0_4._pos:Add(arg0_4._speed)
	arg0_4:UpdateSpeed()
	arg0_4:UpdateWeapon()
end

function var6_0.ActiveCldBox(arg0_5)
	arg0_5._cldComponent:SetActive(true)
end

function var6_0.DeactiveCldBox(arg0_6)
	arg0_6._cldComponent:SetActive(false)
end

function var6_0.SetCldBoxImmune(arg0_7, arg1_7)
	arg0_7._cldComponent:SetImmuneCLD(arg1_7)
end

function var6_0.Init(arg0_8)
	arg0_8._aliveState = true
	arg0_8._speed = Vector3.zero
	arg0_8._pos = Vector3.zero
	arg0_8._undefeated = false
	arg0_8._labelTagList = {}
end

function var6_0.Clear(arg0_9)
	if arg0_9._createTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_9._createTimer)

		arg0_9._createTimer = nil
	end

	arg0_9:ShutdownWeapon()

	arg0_9._distanceBackup = {}
end

function var6_0.SetWeaponPreCastBound(arg0_10)
	return
end

function var6_0.EnterGCD(arg0_11)
	return
end

function var6_0.CreateWeapon(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in ipairs(arg0_12._tmpData.weapon_ID) do
		var0_12[iter0_12] = var0_0.Battle.BattleDataFunction.CreateAirFighterWeaponUnit(iter1_12, arg0_12, iter0_12, arg0_12._weaponPotential)
	end

	return var0_12
end

function var6_0.ShutdownWeapon(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13:GetWeapon()) do
		iter1_13:Clear()
	end
end

function var6_0.UpdateWeapon(arg0_14)
	if arg0_14._currentState == arg0_14.STATE_ATTACK then
		for iter0_14, iter1_14 in ipairs(arg0_14:GetWeapon()) do
			iter1_14:Update()
		end
	end
end

function var6_0.SetStrikePoint(arg0_15, arg1_15)
	arg0_15._strikePoint = arg1_15

	arg0_15:SetPosition(Vector3(arg0_15._pos.x, arg0_15._pos.y, arg1_15.z))
end

function var6_0.GetStrikePoint(arg0_16)
	return arg0_16._strikePoint
end

function var6_0.GetWeapon(arg0_17)
	return arg0_17._weapon
end

function var6_0.GetCurrentHP(arg0_18)
	return arg0_18._currentHP
end

function var6_0.GetMaxHP(arg0_19)
	return var0_0.Battle.BattleAttr.GetCurrent(arg0_19, "maxHP")
end

function var6_0.IsUndefeated(arg0_20)
	return arg0_20._undefeated
end

function var6_0.IsAlive(arg0_21)
	return arg0_21._aliveState
end

function var6_0.IsCease(arg0_22)
	return false
end

function var6_0.GetOxyState(arg0_23)
	return nil
end

function var6_0.IsBoss(arg0_24)
	return nil
end

function var6_0.HandleDamageToDeath(arg0_25)
	arg0_25:UpdateHP(-arg0_25._currentHP, {
		isMiss = false,
		isCri = false,
		isHeal = false
	})
end

function var6_0.UpdateHP(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg2_26.isMiss
	local var1_26 = arg2_26.isCri
	local var2_26 = arg2_26.isHeal

	arg0_26._currentHP = arg0_26._currentHP + arg1_26

	local var3_26 = arg0_26:GetMaxHP()

	if var3_26 < arg0_26._currentHP then
		arg0_26._currentHP = var3_26
	end

	if arg0_26._currentHP < 0 then
		arg0_26._currentHP = 0
	end

	local var4_26 = {
		dHP = arg1_26,
		isMiss = var0_26,
		isCri = var1_26,
		isHeal = var2_26
	}

	arg0_26:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_AIR_CRAFT_HP, var4_26))

	if arg0_26._currentHP <= 0 and arg0_26:IsAlive() then
		arg0_26:onDead()
	end

	return arg1_26
end

function var6_0.onDead(arg0_27)
	arg0_27._currentState = arg0_27.STATE_DESTORY
	arg0_27._aliveState = false
end

function var6_0.UpdateSpeed(arg0_28)
	local var0_28 = arg0_28._speedDir
	local var1_28 = arg0_28._velocity * arg0_28:GetSpeedRatio()

	arg0_28._speed:Copy(var0_28)
	arg0_28._speed:Mul(var1_28)

	local var2_28 = arg0_28:GetPosition()

	if var2_28.y < var6_0.HEIGHT then
		arg0_28._speed.y = math.max(0.4, 1 - var2_28.y / var3_0.AircraftHeight)
	end

	arg0_28._speed.z = var1_28 * arg0_28._speedZ

	if arg0_28._tmpData.spawn_brownian == 1 then
		local var3_28 = arg0_28._targetZ - var2_28.z

		if var1_28 < var3_28 then
			arg0_28._speed.z = var1_28 * 0.5
		elseif var3_28 < -var1_28 then
			arg0_28._speed.z = -var1_28 * 0.5
		else
			arg0_28:SetTargetZ()
		end
	end
end

function var6_0.OutBound(arg0_29)
	arg0_29._undefeated = true

	arg0_29:onDead()
end

function var6_0.GetSize(arg0_30)
	if arg0_30._currentState == arg0_30.STATE_CREATE then
		return Mathf.Clamp(arg0_30:GetPosition().y / var6_0.HEIGHT, 0.1, arg0_30._scale)
	else
		return arg0_30._scale
	end
end

function var6_0.SetTemplate(arg0_31, arg1_31)
	arg0_31._tmpData = arg1_31

	arg0_31:InitCldComponent()
	var0_0.Battle.BattleAttr.SetAircraftAttFromTemp(arg0_31)

	arg0_31._currentHP = arg0_31:GetMaxHP()
	arg0_31._weapon = arg0_31:CreateWeapon()
	arg0_31._modelID = arg1_31.model_ID

	local var0_31 = arg1_31.speed + arg0_31:GetAttrByName("aircraftBooster")

	arg0_31._velocity = var0_0.Battle.BattleFormulas.ConvertAircraftSpeed(var0_31)
	arg0_31._scale = arg1_31.scale or 1
end

function var6_0.SetWeanponPotential(arg0_32, arg1_32)
	arg0_32._weaponPotential = arg1_32
end

function var6_0.SetTargetZ(arg0_33)
	local var0_33 = arg0_33._bottom
	local var1_33 = arg0_33._top

	arg0_33._targetZ = (var0_33 + var1_33) * 0.5 + (var1_33 - var0_33) * (math.random() - 0.5) * 0.6
end

function var6_0.SetMotherUnit(arg0_34, arg1_34)
	arg0_34._motherUnit = arg1_34

	local var0_34 = arg0_34._motherUnit:GetIFF()

	arg0_34:SetIFF(var0_34)
	arg0_34:SetAttr(arg1_34)

	local var1_34 = arg0_34._motherUnit:GetWeaponBoundBone()

	if var1_34.remote then
		local var2_34 = var1_34.remote
		local var3_34 = Vector3(var2_34[1], var2_34[2], var2_34[3])

		var3_34.x = var3_34.x * var0_34

		local var4_34 = arg0_34._battleProxy:GetStageInfo().mainUnitPosition
		local var5_34

		if var4_34 and var4_34[var0_34] then
			var5_34 = var4_34[var0_34][1]
		else
			var5_34 = var3_0.MAIN_UNIT_POS[var0_34][1]
		end

		local var6_34 = var5_34 + var3_34

		arg0_34:SetPosition(var6_34)
	else
		arg0_34:SetPosition(arg0_34._motherUnit:GetPosition())
	end

	if arg1_34:GetIFF() == var3_0.FRIENDLY_CODE then
		arg0_34._dir = var2_0.UnitDir.RIGHT
		arg0_34._isPlayerAircraft = true
	else
		arg0_34._dir = var2_0.UnitDir.LEFT
	end
end

function var6_0.GetLabelTag(arg0_35)
	return arg0_35._labelTagList
end

function var6_0.AddLabelTag(arg0_36, arg1_36)
	table.insert(arg0_36._labelTagList, arg1_36)

	local var0_36 = arg0_36:GetAttrByName("labelTag")

	var0_36[arg1_36] = (var0_36[arg1_36] or 0) + 1
end

function var6_0.ContainsLabelTag(arg0_37, arg1_37)
	if arg0_37._labelTagList == nil then
		return false
	end

	for iter0_37, iter1_37 in ipairs(arg1_37) do
		if table.contains(arg0_37._labelTagList, iter1_37) then
			return true
		end
	end

	return false
end

function var6_0.SetIFF(arg0_38, arg1_38)
	arg0_38._IFF = arg1_38
end

function var6_0.SetPosition(arg0_39, arg1_39)
	arg0_39._pos:Set(arg1_39.x, arg1_39.y, arg1_39.z)
end

function var6_0.IsOutViewBound(arg0_40)
	local var0_40 = arg0_40:GetPosition()
	local var1_40 = var0_40.x
	local var2_40 = var0_40.z

	if var1_40 > arg0_40._cameraRight or var2_40 > arg0_40._cameraTop or var2_40 < arg0_40._cameraBottom then
		return true
	end
end

function var6_0.GetDistance(arg0_41, arg1_41)
	local var0_41 = arg0_41._battleProxy.FrameIndex

	if arg0_41._frame ~= var0_41 then
		arg0_41._distanceBackup = {}
		arg0_41._frame = var0_41
	end

	local var1_41 = arg0_41._distanceBackup[arg1_41]

	if var1_41 == nil then
		var1_41 = Vector3.Distance(pg.Tool.FilterY(arg0_41:GetPosition()), pg.Tool.FilterY(arg1_41:GetPosition()))
		arg0_41._distanceBackup[arg1_41] = var1_41

		arg1_41:backupDistance(arg0_41, var1_41)
	end

	return var1_41
end

function var6_0.backupDistance(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg0_42._battleProxy.FrameIndex

	if arg0_42._frame ~= var0_42 then
		arg0_42._distanceBackup = {}
		arg0_42._frame = var0_42
	end

	arg0_42._distanceBackup[arg1_42] = arg2_42
end

function var6_0.GetSkinID(arg0_43)
	return arg0_43._modelID
end

function var6_0.SetSkinID(arg0_44, arg1_44)
	arg0_44._skinID = arg1_44
	arg0_44._modelID = var5_0.GetEquipSkin(arg0_44._skinID)

	for iter0_44, iter1_44 in ipairs(arg0_44._weapon) do
		iter1_44:SetDerivateSkin(arg1_44)
	end
end

function var6_0.SetSkinData(arg0_45, arg1_45)
	return
end

function var6_0.SetAttr(arg0_46, arg1_46)
	var0_0.Battle.BattleAttr.SetAircraftAttFromMother(arg0_46, arg1_46)
end

function var6_0.GetAttr(arg0_47)
	return var0_0.Battle.BattleAttr.GetAttr(arg0_47)
end

function var6_0.GetAttrByName(arg0_48, arg1_48)
	return var0_0.Battle.BattleAttr.GetCurrent(arg0_48, arg1_48)
end

function var6_0.GetMotherUnit(arg0_49)
	return arg0_49._motherUnit
end

function var6_0.GetUniqueID(arg0_50)
	return arg0_50._uniqueID
end

function var6_0.GetIFF(arg0_51)
	return arg0_51._IFF
end

function var6_0.GetCurrentState(arg0_52)
	return arg0_52._currentState
end

function var6_0.GetVelocity(arg0_53)
	return arg0_53._velocity
end

function var6_0.GetSpeed(arg0_54)
	return arg0_54._speed
end

function var6_0.GetPosition(arg0_55)
	return arg0_55._pos
end

function var6_0.GetBornPosition(arg0_56)
	return nil
end

function var6_0.GetCLDZCenterPosition(arg0_57)
	local var0_57 = arg0_57:GetBoxSize()

	return Vector3(arg0_57._pos.x, arg0_57._pos.y, arg0_57._pos.z + var0_57.z)
end

function var6_0.GetBeenAimedPosition(arg0_58)
	local var0_58 = arg0_58:GetTemplate().aim_offset
	local var1_58 = arg0_58:GetCLDZCenterPosition()

	if not var0_58 then
		return var1_58
	end

	return Vector3(var1_58.x + var0_58[1], var1_58.y + var0_58[2], var1_58.z + var0_58[3])
end

function var6_0.GetDirection(arg0_59)
	return arg0_59._dir
end

function var6_0.GetTemplate(arg0_60)
	return arg0_60._tmpData
end

function var6_0.GetTemplateID(arg0_61)
	return arg0_61._tmpData.id
end

function var6_0.GetUnitType(arg0_62)
	return arg0_62._type
end

function var6_0.GetHPRate(arg0_63)
	return arg0_63._currentHP / arg0_63:GetMaxHP()
end

function var6_0.GetBoxSize(arg0_64)
	return arg0_64._cldComponent:GetCldBoxSize()
end

function var6_0.GetSpeedRatio(arg0_65)
	return var4_0.GetSpeedRatio(arg0_65:GetSpeedExemptKey(), arg0_65._IFF)
end

function var6_0.GetSpeedExemptKey(arg0_66)
	return arg0_66._speedExemptKey
end

function var6_0.IsPlayerAircraft(arg0_67)
	return arg0_67._isPlayerAircraft
end

function var6_0.IsShowHPBar(arg0_68)
	return false
end

function var6_0.SetUnVisitable(arg0_69)
	var0_0.Battle.BattleAttr.UnVisitable(arg0_69)
end

function var6_0.SetVisitable(arg0_70)
	var0_0.Battle.BattleAttr.Visitable(arg0_70)
end

function var6_0.IsVisitable(arg0_71)
	return var0_0.Battle.BattleAttr.IsVisitable(arg0_71)
end

function var6_0.OverrideDeadFX(arg0_72, arg1_72)
	arg0_72._deadFX = arg1_72
end

function var6_0.GetDeadFX(arg0_73)
	return arg0_73._deadFX
end

var6_0.AIRCRAFT_TRIGGER = {
	var0_0.Battle.BattleConst.BuffEffectType.ON_BULLET_COLLIDE_BEFORE,
	var0_0.Battle.BattleConst.BuffEffectType.ON_BOMB_BULLET_BANG,
	var0_0.Battle.BattleConst.BuffEffectType.ON_TORPEDO_BULLET_BANG
}

function var6_0.TriggerBuff(arg0_74, arg1_74, arg2_74)
	if table.contains(var6_0.AIRCRAFT_TRIGGER, arg1_74) and arg0_74._motherUnit and arg0_74._motherUnit:IsAlive() then
		arg0_74._motherUnit:TriggerBuff(arg1_74, arg2_74)
	end
end

function var6_0.AddCreateTimer(arg0_75, arg1_75, arg2_75)
	arg0_75._currentState = arg0_75.STATE_CREATE
	arg0_75._speedDir = arg1_75
	arg2_75 = arg2_75 or 1.5

	local function var0_75()
		arg0_75._currentState = arg0_75.STATE_ATTACK
		arg0_75._speedDir = Vector3(arg0_75._dir, 0, 0)

		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_75._createTimer)

		arg0_75._createTimer = nil
	end

	arg0_75._createTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AddCreateTimer", 0, arg2_75, var0_75)
end

function var6_0.Dispose(arg0_77)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_77)
end

function var6_0.InitCldComponent(arg0_78)
	local var0_78 = arg0_78:GetTemplate().cld_box
	local var1_78 = arg0_78:GetTemplate().cld_offset
	local var2_78 = var1_78[1]

	if arg0_78:GetDirection() == var0_0.Battle.BattleConst.UnitDir.LEFT then
		var2_78 = var2_78 * -1
	end

	arg0_78._cldComponent = var0_0.Battle.BattleCubeCldComponent.New(var0_78[1], var0_78[2], var0_78[3], var2_78, var1_78[3])

	local var3_78 = {
		type = var2_0.CldType.AIRCRAFT,
		IFF = arg0_78:GetIFF(),
		UID = arg0_78:GetUniqueID()
	}

	arg0_78._cldComponent:SetCldData(var3_78)
end

function var6_0.GetCldBox(arg0_79)
	return arg0_79._cldComponent:GetCldBox(arg0_79:GetPosition())
end

function var6_0.GetCldData(arg0_80)
	return arg0_80._cldComponent:GetCldData()
end

function var6_0.AddBuff(arg0_81)
	return
end

function var6_0.SetBuffStack(arg0_82)
	return
end

function var6_0.RemoveBuff(arg0_83)
	return
end

function var6_0.CloakExpose(arg0_84)
	return
end

function var6_0.GetCurrentOxyState(arg0_85)
	return nil
end

function var6_0.RemoveRemoteBoundBone(arg0_86)
	return
end

function var6_0.SetRemoteBoundBone(arg0_87)
	return
end

function var6_0.GetRemoteBoundBone(arg0_88)
	return
end
