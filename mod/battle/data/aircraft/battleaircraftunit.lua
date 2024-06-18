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

	if arg0_2._tmpData.spawn_brownian then
		arg0_2._speedZ = (math.random() - 0.5) * 0.5
	else
		arg0_2._speedZ = 0
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

function var6_0.GetWeapon(arg0_15)
	return arg0_15._weapon
end

function var6_0.GetCurrentHP(arg0_16)
	return arg0_16._currentHP
end

function var6_0.GetMaxHP(arg0_17)
	return var0_0.Battle.BattleAttr.GetCurrent(arg0_17, "maxHP")
end

function var6_0.IsUndefeated(arg0_18)
	return arg0_18._undefeated
end

function var6_0.IsAlive(arg0_19)
	return arg0_19._aliveState
end

function var6_0.IsCease(arg0_20)
	return false
end

function var6_0.GetOxyState(arg0_21)
	return nil
end

function var6_0.IsBoss(arg0_22)
	return nil
end

function var6_0.HandleDamageToDeath(arg0_23)
	arg0_23:UpdateHP(-arg0_23._currentHP, {
		isMiss = false,
		isCri = false,
		isHeal = false
	})
end

function var6_0.UpdateHP(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg2_24.isMiss
	local var1_24 = arg2_24.isCri
	local var2_24 = arg2_24.isHeal

	arg0_24._currentHP = arg0_24._currentHP + arg1_24

	local var3_24 = arg0_24:GetMaxHP()

	if var3_24 < arg0_24._currentHP then
		arg0_24._currentHP = var3_24
	end

	if arg0_24._currentHP < 0 then
		arg0_24._currentHP = 0
	end

	local var4_24 = {
		dHP = arg1_24,
		isMiss = var0_24,
		isCri = var1_24,
		isHeal = var2_24
	}

	arg0_24:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_AIR_CRAFT_HP, var4_24))

	if arg0_24._currentHP <= 0 and arg0_24:IsAlive() then
		arg0_24:onDead()
	end

	return arg1_24
end

function var6_0.onDead(arg0_25)
	arg0_25._currentState = arg0_25.STATE_DESTORY
	arg0_25._aliveState = false
end

function var6_0.UpdateSpeed(arg0_26)
	local var0_26 = arg0_26._speedDir
	local var1_26 = arg0_26._velocity * arg0_26:GetSpeedRatio()

	arg0_26._speed:Copy(var0_26)
	arg0_26._speed:Mul(var1_26)

	local var2_26 = arg0_26:GetPosition()

	if var2_26.y < var6_0.HEIGHT then
		arg0_26._speed.y = math.max(0.4, 1 - var2_26.y / var3_0.AircraftHeight)
	end

	arg0_26._speed.z = var1_26 * arg0_26._speedZ

	if arg0_26._tmpData.spawn_brownian == 1 then
		local var3_26 = arg0_26._targetZ - var2_26.z

		if var1_26 < var3_26 then
			arg0_26._speed.z = var1_26 * 0.5
		elseif var3_26 < -var1_26 then
			arg0_26._speed.z = -var1_26 * 0.5
		else
			arg0_26:SetTargetZ()
		end
	end
end

function var6_0.OutBound(arg0_27)
	arg0_27._undefeated = true

	arg0_27:onDead()
end

function var6_0.GetSize(arg0_28)
	if arg0_28._currentState == arg0_28.STATE_CREATE then
		return Mathf.Clamp(arg0_28:GetPosition().y / var6_0.HEIGHT, 0.1, arg0_28._scale)
	else
		return arg0_28._scale
	end
end

function var6_0.SetTemplate(arg0_29, arg1_29)
	arg0_29._tmpData = arg1_29

	arg0_29:InitCldComponent()
	var0_0.Battle.BattleAttr.SetAircraftAttFromTemp(arg0_29)

	arg0_29._currentHP = arg0_29:GetMaxHP()
	arg0_29._weapon = arg0_29:CreateWeapon()
	arg0_29._modelID = arg1_29.model_ID

	local var0_29 = arg1_29.speed + arg0_29:GetAttrByName("aircraftBooster")

	arg0_29._velocity = var0_0.Battle.BattleFormulas.ConvertAircraftSpeed(var0_29)
	arg0_29._scale = arg1_29.scale or 1
end

function var6_0.SetWeanponPotential(arg0_30, arg1_30)
	arg0_30._weaponPotential = arg1_30
end

function var6_0.SetTargetZ(arg0_31)
	local var0_31 = arg0_31._bottom
	local var1_31 = arg0_31._top

	arg0_31._targetZ = (var0_31 + var1_31) * 0.5 + (var1_31 - var0_31) * (math.random() - 0.5) * 0.6
end

function var6_0.SetMotherUnit(arg0_32, arg1_32)
	arg0_32._motherUnit = arg1_32

	local var0_32 = arg0_32._motherUnit:GetIFF()

	arg0_32:SetIFF(var0_32)
	arg0_32:SetAttr(arg1_32)

	local var1_32 = arg0_32._motherUnit:GetWeaponBoundBone()

	if var1_32.remote then
		local var2_32 = var1_32.remote
		local var3_32 = Vector3(var2_32[1], var2_32[2], var2_32[3])

		var3_32.x = var3_32.x * var0_32

		local var4_32 = arg0_32._battleProxy:GetStageInfo().mainUnitPosition
		local var5_32

		if var4_32 and var4_32[var0_32] then
			var5_32 = var4_32[var0_32][1]
		else
			var5_32 = var3_0.MAIN_UNIT_POS[var0_32][1]
		end

		local var6_32 = var5_32 + var3_32

		arg0_32:SetPosition(var6_32)
	else
		arg0_32:SetPosition(arg0_32._motherUnit:GetPosition())
	end

	if arg1_32:GetIFF() == var3_0.FRIENDLY_CODE then
		arg0_32._dir = var2_0.UnitDir.RIGHT
		arg0_32._isPlayerAircraft = true
	else
		arg0_32._dir = var2_0.UnitDir.LEFT
	end
end

function var6_0.GetLabelTag(arg0_33)
	return arg0_33._labelTagList
end

function var6_0.AddLabelTag(arg0_34, arg1_34)
	table.insert(arg0_34._labelTagList, arg1_34)

	local var0_34 = arg0_34:GetAttrByName("labelTag")

	var0_34[arg1_34] = (var0_34[arg1_34] or 0) + 1
end

function var6_0.ContainsLabelTag(arg0_35, arg1_35)
	if arg0_35._labelTagList == nil then
		return false
	end

	for iter0_35, iter1_35 in ipairs(arg1_35) do
		if table.contains(arg0_35._labelTagList, iter1_35) then
			return true
		end
	end

	return false
end

function var6_0.SetIFF(arg0_36, arg1_36)
	arg0_36._IFF = arg1_36
end

function var6_0.SetPosition(arg0_37, arg1_37)
	arg0_37._pos:Set(arg1_37.x, arg1_37.y, arg1_37.z)
end

function var6_0.IsOutViewBound(arg0_38)
	local var0_38 = arg0_38:GetPosition()
	local var1_38 = var0_38.x
	local var2_38 = var0_38.z

	if var1_38 > arg0_38._cameraRight or var2_38 > arg0_38._cameraTop or var2_38 < arg0_38._cameraBottom then
		return true
	end
end

function var6_0.GetDistance(arg0_39, arg1_39)
	local var0_39 = arg0_39._battleProxy.FrameIndex

	if arg0_39._frame ~= var0_39 then
		arg0_39._distanceBackup = {}
		arg0_39._frame = var0_39
	end

	local var1_39 = arg0_39._distanceBackup[arg1_39]

	if var1_39 == nil then
		var1_39 = Vector3.Distance(pg.Tool.FilterY(arg0_39:GetPosition()), pg.Tool.FilterY(arg1_39:GetPosition()))
		arg0_39._distanceBackup[arg1_39] = var1_39

		arg1_39:backupDistance(arg0_39, var1_39)
	end

	return var1_39
end

function var6_0.backupDistance(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40._battleProxy.FrameIndex

	if arg0_40._frame ~= var0_40 then
		arg0_40._distanceBackup = {}
		arg0_40._frame = var0_40
	end

	arg0_40._distanceBackup[arg1_40] = arg2_40
end

function var6_0.GetSkinID(arg0_41)
	return arg0_41._modelID
end

function var6_0.SetSkinID(arg0_42, arg1_42)
	arg0_42._skinID = arg1_42
	arg0_42._modelID = var5_0.GetEquipSkin(arg0_42._skinID)

	for iter0_42, iter1_42 in ipairs(arg0_42._weapon) do
		iter1_42:SetDerivateSkin(arg1_42)
	end
end

function var6_0.SetSkinData(arg0_43, arg1_43)
	return
end

function var6_0.SetAttr(arg0_44, arg1_44)
	var0_0.Battle.BattleAttr.SetAircraftAttFromMother(arg0_44, arg1_44)
end

function var6_0.GetAttr(arg0_45)
	return var0_0.Battle.BattleAttr.GetAttr(arg0_45)
end

function var6_0.GetAttrByName(arg0_46, arg1_46)
	return var0_0.Battle.BattleAttr.GetCurrent(arg0_46, arg1_46)
end

function var6_0.GetMotherUnit(arg0_47)
	return arg0_47._motherUnit
end

function var6_0.GetUniqueID(arg0_48)
	return arg0_48._uniqueID
end

function var6_0.GetIFF(arg0_49)
	return arg0_49._IFF
end

function var6_0.GetCurrentState(arg0_50)
	return arg0_50._currentState
end

function var6_0.GetVelocity(arg0_51)
	return arg0_51._velocity
end

function var6_0.GetSpeed(arg0_52)
	return arg0_52._speed
end

function var6_0.GetPosition(arg0_53)
	return arg0_53._pos
end

function var6_0.GetBornPosition(arg0_54)
	return nil
end

function var6_0.GetCLDZCenterPosition(arg0_55)
	local var0_55 = arg0_55:GetBoxSize()

	return Vector3(arg0_55._pos.x, arg0_55._pos.y, arg0_55._pos.z + var0_55.z)
end

function var6_0.GetBeenAimedPosition(arg0_56)
	local var0_56 = arg0_56:GetTemplate().aim_offset
	local var1_56 = arg0_56:GetCLDZCenterPosition()

	if not var0_56 then
		return var1_56
	end

	return Vector3(var1_56.x + var0_56[1], var1_56.y + var0_56[2], var1_56.z + var0_56[3])
end

function var6_0.GetDirection(arg0_57)
	return arg0_57._dir
end

function var6_0.GetTemplate(arg0_58)
	return arg0_58._tmpData
end

function var6_0.GetTemplateID(arg0_59)
	return arg0_59._tmpData.id
end

function var6_0.GetUnitType(arg0_60)
	return arg0_60._type
end

function var6_0.GetHPRate(arg0_61)
	return arg0_61._currentHP / arg0_61:GetMaxHP()
end

function var6_0.GetBoxSize(arg0_62)
	return arg0_62._cldComponent:GetCldBoxSize()
end

function var6_0.GetSpeedRatio(arg0_63)
	return var4_0.GetSpeedRatio(arg0_63:GetSpeedExemptKey(), arg0_63._IFF)
end

function var6_0.GetSpeedExemptKey(arg0_64)
	return arg0_64._speedExemptKey
end

function var6_0.IsPlayerAircraft(arg0_65)
	return arg0_65._isPlayerAircraft
end

function var6_0.IsShowHPBar(arg0_66)
	return false
end

function var6_0.SetUnVisitable(arg0_67)
	var0_0.Battle.BattleAttr.UnVisitable(arg0_67)
end

function var6_0.SetVisitable(arg0_68)
	var0_0.Battle.BattleAttr.Visitable(arg0_68)
end

function var6_0.IsVisitable(arg0_69)
	return var0_0.Battle.BattleAttr.IsVisitable(arg0_69)
end

function var6_0.OverrideDeadFX(arg0_70, arg1_70)
	arg0_70._deadFX = arg1_70
end

function var6_0.GetDeadFX(arg0_71)
	return arg0_71._deadFX
end

function var6_0.TriggerBuff(arg0_72, arg1_72, arg2_72)
	return
end

function var6_0.AddCreateTimer(arg0_73, arg1_73, arg2_73)
	arg0_73._currentState = arg0_73.STATE_CREATE
	arg0_73._speedDir = arg1_73
	arg2_73 = arg2_73 or 1.5

	local function var0_73()
		arg0_73._currentState = arg0_73.STATE_ATTACK
		arg0_73._speedDir = Vector3(arg0_73._dir, 0, 0)

		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_73._createTimer)

		arg0_73._createTimer = nil
	end

	arg0_73._createTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AddCreateTimer", 0, arg2_73, var0_73)
end

function var6_0.Dispose(arg0_75)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_75)
end

function var6_0.InitCldComponent(arg0_76)
	local var0_76 = arg0_76:GetTemplate().cld_box
	local var1_76 = arg0_76:GetTemplate().cld_offset
	local var2_76 = var1_76[1]

	if arg0_76:GetDirection() == var0_0.Battle.BattleConst.UnitDir.LEFT then
		var2_76 = var2_76 * -1
	end

	arg0_76._cldComponent = var0_0.Battle.BattleCubeCldComponent.New(var0_76[1], var0_76[2], var0_76[3], var2_76, var1_76[3])

	local var3_76 = {
		type = var2_0.CldType.AIRCRAFT,
		IFF = arg0_76:GetIFF(),
		UID = arg0_76:GetUniqueID()
	}

	arg0_76._cldComponent:SetCldData(var3_76)
end

function var6_0.GetCldBox(arg0_77)
	return arg0_77._cldComponent:GetCldBox(arg0_77:GetPosition())
end

function var6_0.GetCldData(arg0_78)
	return arg0_78._cldComponent:GetCldData()
end

function var6_0.AddBuff(arg0_79)
	return
end

function var6_0.SetBuffStack(arg0_80)
	return
end

function var6_0.RemoveBuff(arg0_81)
	return
end

function var6_0.TriggerBuff(arg0_82)
	return
end

function var6_0.CloakExpose(arg0_83)
	return
end

function var6_0.GetCurrentOxyState(arg0_84)
	return nil
end

function var6_0.RemoveRemoteBoundBone(arg0_85)
	return
end

function var6_0.SetRemoteBoundBone(arg0_86)
	return
end

function var6_0.GetRemoteBoundBone(arg0_87)
	return
end
