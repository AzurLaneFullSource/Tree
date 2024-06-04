ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig
local var4 = var0.Battle.BattleVariable
local var5 = var0.Battle.BattleDataFunction
local var6 = class("BattleAircraftUnit")

var0.Battle.BattleAircraftUnit = var6
var6.__name = "BattleAircraftUnit"
var6.STATE_CREATE = "Create"
var6.STATE_ATTACK = "Attack"
var6.STATE_DESTORY = "Destory"
var6.HEIGHT = var3.AircraftHeight + 5

function var6.Ctor(arg0, arg1)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._uniqueID = arg1
	arg0._speedExemptKey = "air_" .. arg1
	arg0._dir = var0.Battle.BattleConst.UnitDir.RIGHT
	arg0._type = var2.UnitType.AIRCRAFT_UNIT
	arg0._currentState = arg0.STATE_CREATE
	arg0._distanceBackup = {}
	arg0._battleProxy = var0.Battle.BattleDataProxy.GetInstance()
	arg0._frame = 0
	arg0._weaponPotential = 1

	arg0:Init()
end

function var6.SetBound(arg0, arg1, arg2)
	arg0._top = arg1
	arg0._bottom = arg2

	if arg0._tmpData.spawn_brownian then
		arg0._speedZ = (math.random() - 0.5) * 0.5
	else
		arg0._speedZ = 0
	end

	arg0:SetTargetZ()
end

function var6.SetViewBoundData(arg0, arg1, arg2, arg3, arg4)
	arg0._cameraTop = arg1 + 3
	arg0._cameraBottom = arg2 - 23
	arg0._cameraLeft = arg3 - 3
	arg0._cameraRight = arg4 + 10
end

function var6.Update(arg0, arg1)
	arg0._pos:Add(arg0._speed)
	arg0:UpdateSpeed()
	arg0:UpdateWeapon()
end

function var6.ActiveCldBox(arg0)
	arg0._cldComponent:SetActive(true)
end

function var6.DeactiveCldBox(arg0)
	arg0._cldComponent:SetActive(false)
end

function var6.SetCldBoxImmune(arg0, arg1)
	arg0._cldComponent:SetImmuneCLD(arg1)
end

function var6.Init(arg0)
	arg0._aliveState = true
	arg0._speed = Vector3.zero
	arg0._pos = Vector3.zero
	arg0._undefeated = false
	arg0._labelTagList = {}
end

function var6.Clear(arg0)
	if arg0._createTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._createTimer)

		arg0._createTimer = nil
	end

	arg0:ShutdownWeapon()

	arg0._distanceBackup = {}
end

function var6.SetWeaponPreCastBound(arg0)
	return
end

function var6.EnterGCD(arg0)
	return
end

function var6.CreateWeapon(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0._tmpData.weapon_ID) do
		var0[iter0] = var0.Battle.BattleDataFunction.CreateAirFighterWeaponUnit(iter1, arg0, iter0, arg0._weaponPotential)
	end

	return var0
end

function var6.ShutdownWeapon(arg0)
	for iter0, iter1 in ipairs(arg0:GetWeapon()) do
		iter1:Clear()
	end
end

function var6.UpdateWeapon(arg0)
	if arg0._currentState == arg0.STATE_ATTACK then
		for iter0, iter1 in ipairs(arg0:GetWeapon()) do
			iter1:Update()
		end
	end
end

function var6.GetWeapon(arg0)
	return arg0._weapon
end

function var6.GetCurrentHP(arg0)
	return arg0._currentHP
end

function var6.GetMaxHP(arg0)
	return var0.Battle.BattleAttr.GetCurrent(arg0, "maxHP")
end

function var6.IsUndefeated(arg0)
	return arg0._undefeated
end

function var6.IsAlive(arg0)
	return arg0._aliveState
end

function var6.IsCease(arg0)
	return false
end

function var6.GetOxyState(arg0)
	return nil
end

function var6.IsBoss(arg0)
	return nil
end

function var6.HandleDamageToDeath(arg0)
	arg0:UpdateHP(-arg0._currentHP, {
		isMiss = false,
		isCri = false,
		isHeal = false
	})
end

function var6.UpdateHP(arg0, arg1, arg2)
	local var0 = arg2.isMiss
	local var1 = arg2.isCri
	local var2 = arg2.isHeal

	arg0._currentHP = arg0._currentHP + arg1

	local var3 = arg0:GetMaxHP()

	if var3 < arg0._currentHP then
		arg0._currentHP = var3
	end

	if arg0._currentHP < 0 then
		arg0._currentHP = 0
	end

	local var4 = {
		dHP = arg1,
		isMiss = var0,
		isCri = var1,
		isHeal = var2
	}

	arg0:DispatchEvent(var0.Event.New(var1.UPDATE_AIR_CRAFT_HP, var4))

	if arg0._currentHP <= 0 and arg0:IsAlive() then
		arg0:onDead()
	end

	return arg1
end

function var6.onDead(arg0)
	arg0._currentState = arg0.STATE_DESTORY
	arg0._aliveState = false
end

function var6.UpdateSpeed(arg0)
	local var0 = arg0._speedDir
	local var1 = arg0._velocity * arg0:GetSpeedRatio()

	arg0._speed:Copy(var0)
	arg0._speed:Mul(var1)

	local var2 = arg0:GetPosition()

	if var2.y < var6.HEIGHT then
		arg0._speed.y = math.max(0.4, 1 - var2.y / var3.AircraftHeight)
	end

	arg0._speed.z = var1 * arg0._speedZ

	if arg0._tmpData.spawn_brownian == 1 then
		local var3 = arg0._targetZ - var2.z

		if var1 < var3 then
			arg0._speed.z = var1 * 0.5
		elseif var3 < -var1 then
			arg0._speed.z = -var1 * 0.5
		else
			arg0:SetTargetZ()
		end
	end
end

function var6.OutBound(arg0)
	arg0._undefeated = true

	arg0:onDead()
end

function var6.GetSize(arg0)
	if arg0._currentState == arg0.STATE_CREATE then
		return Mathf.Clamp(arg0:GetPosition().y / var6.HEIGHT, 0.1, arg0._scale)
	else
		return arg0._scale
	end
end

function var6.SetTemplate(arg0, arg1)
	arg0._tmpData = arg1

	arg0:InitCldComponent()
	var0.Battle.BattleAttr.SetAircraftAttFromTemp(arg0)

	arg0._currentHP = arg0:GetMaxHP()
	arg0._weapon = arg0:CreateWeapon()
	arg0._modelID = arg1.model_ID

	local var0 = arg1.speed + arg0:GetAttrByName("aircraftBooster")

	arg0._velocity = var0.Battle.BattleFormulas.ConvertAircraftSpeed(var0)
	arg0._scale = arg1.scale or 1
end

function var6.SetWeanponPotential(arg0, arg1)
	arg0._weaponPotential = arg1
end

function var6.SetTargetZ(arg0)
	local var0 = arg0._bottom
	local var1 = arg0._top

	arg0._targetZ = (var0 + var1) * 0.5 + (var1 - var0) * (math.random() - 0.5) * 0.6
end

function var6.SetMotherUnit(arg0, arg1)
	arg0._motherUnit = arg1

	local var0 = arg0._motherUnit:GetIFF()

	arg0:SetIFF(var0)
	arg0:SetAttr(arg1)

	local var1 = arg0._motherUnit:GetWeaponBoundBone()

	if var1.remote then
		local var2 = var1.remote
		local var3 = Vector3(var2[1], var2[2], var2[3])

		var3.x = var3.x * var0

		local var4 = arg0._battleProxy:GetStageInfo().mainUnitPosition
		local var5

		if var4 and var4[var0] then
			var5 = var4[var0][1]
		else
			var5 = var3.MAIN_UNIT_POS[var0][1]
		end

		local var6 = var5 + var3

		arg0:SetPosition(var6)
	else
		arg0:SetPosition(arg0._motherUnit:GetPosition())
	end

	if arg1:GetIFF() == var3.FRIENDLY_CODE then
		arg0._dir = var2.UnitDir.RIGHT
		arg0._isPlayerAircraft = true
	else
		arg0._dir = var2.UnitDir.LEFT
	end
end

function var6.GetLabelTag(arg0)
	return arg0._labelTagList
end

function var6.AddLabelTag(arg0, arg1)
	table.insert(arg0._labelTagList, arg1)

	local var0 = arg0:GetAttrByName("labelTag")

	var0[arg1] = (var0[arg1] or 0) + 1
end

function var6.ContainsLabelTag(arg0, arg1)
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

function var6.SetIFF(arg0, arg1)
	arg0._IFF = arg1
end

function var6.SetPosition(arg0, arg1)
	arg0._pos:Set(arg1.x, arg1.y, arg1.z)
end

function var6.IsOutViewBound(arg0)
	local var0 = arg0:GetPosition()
	local var1 = var0.x
	local var2 = var0.z

	if var1 > arg0._cameraRight or var2 > arg0._cameraTop or var2 < arg0._cameraBottom then
		return true
	end
end

function var6.GetDistance(arg0, arg1)
	local var0 = arg0._battleProxy.FrameIndex

	if arg0._frame ~= var0 then
		arg0._distanceBackup = {}
		arg0._frame = var0
	end

	local var1 = arg0._distanceBackup[arg1]

	if var1 == nil then
		var1 = Vector3.Distance(pg.Tool.FilterY(arg0:GetPosition()), pg.Tool.FilterY(arg1:GetPosition()))
		arg0._distanceBackup[arg1] = var1

		arg1:backupDistance(arg0, var1)
	end

	return var1
end

function var6.backupDistance(arg0, arg1, arg2)
	local var0 = arg0._battleProxy.FrameIndex

	if arg0._frame ~= var0 then
		arg0._distanceBackup = {}
		arg0._frame = var0
	end

	arg0._distanceBackup[arg1] = arg2
end

function var6.GetSkinID(arg0)
	return arg0._modelID
end

function var6.SetSkinID(arg0, arg1)
	arg0._skinID = arg1
	arg0._modelID = var5.GetEquipSkin(arg0._skinID)

	for iter0, iter1 in ipairs(arg0._weapon) do
		iter1:SetDerivateSkin(arg1)
	end
end

function var6.SetSkinData(arg0, arg1)
	return
end

function var6.SetAttr(arg0, arg1)
	var0.Battle.BattleAttr.SetAircraftAttFromMother(arg0, arg1)
end

function var6.GetAttr(arg0)
	return var0.Battle.BattleAttr.GetAttr(arg0)
end

function var6.GetAttrByName(arg0, arg1)
	return var0.Battle.BattleAttr.GetCurrent(arg0, arg1)
end

function var6.GetMotherUnit(arg0)
	return arg0._motherUnit
end

function var6.GetUniqueID(arg0)
	return arg0._uniqueID
end

function var6.GetIFF(arg0)
	return arg0._IFF
end

function var6.GetCurrentState(arg0)
	return arg0._currentState
end

function var6.GetVelocity(arg0)
	return arg0._velocity
end

function var6.GetSpeed(arg0)
	return arg0._speed
end

function var6.GetPosition(arg0)
	return arg0._pos
end

function var6.GetBornPosition(arg0)
	return nil
end

function var6.GetCLDZCenterPosition(arg0)
	local var0 = arg0:GetBoxSize()

	return Vector3(arg0._pos.x, arg0._pos.y, arg0._pos.z + var0.z)
end

function var6.GetBeenAimedPosition(arg0)
	local var0 = arg0:GetTemplate().aim_offset
	local var1 = arg0:GetCLDZCenterPosition()

	if not var0 then
		return var1
	end

	return Vector3(var1.x + var0[1], var1.y + var0[2], var1.z + var0[3])
end

function var6.GetDirection(arg0)
	return arg0._dir
end

function var6.GetTemplate(arg0)
	return arg0._tmpData
end

function var6.GetTemplateID(arg0)
	return arg0._tmpData.id
end

function var6.GetUnitType(arg0)
	return arg0._type
end

function var6.GetHPRate(arg0)
	return arg0._currentHP / arg0:GetMaxHP()
end

function var6.GetBoxSize(arg0)
	return arg0._cldComponent:GetCldBoxSize()
end

function var6.GetSpeedRatio(arg0)
	return var4.GetSpeedRatio(arg0:GetSpeedExemptKey(), arg0._IFF)
end

function var6.GetSpeedExemptKey(arg0)
	return arg0._speedExemptKey
end

function var6.IsPlayerAircraft(arg0)
	return arg0._isPlayerAircraft
end

function var6.IsShowHPBar(arg0)
	return false
end

function var6.SetUnVisitable(arg0)
	var0.Battle.BattleAttr.UnVisitable(arg0)
end

function var6.SetVisitable(arg0)
	var0.Battle.BattleAttr.Visitable(arg0)
end

function var6.IsVisitable(arg0)
	return var0.Battle.BattleAttr.IsVisitable(arg0)
end

function var6.OverrideDeadFX(arg0, arg1)
	arg0._deadFX = arg1
end

function var6.GetDeadFX(arg0)
	return arg0._deadFX
end

function var6.TriggerBuff(arg0, arg1, arg2)
	return
end

function var6.AddCreateTimer(arg0, arg1, arg2)
	arg0._currentState = arg0.STATE_CREATE
	arg0._speedDir = arg1
	arg2 = arg2 or 1.5

	local function var0()
		arg0._currentState = arg0.STATE_ATTACK
		arg0._speedDir = Vector3(arg0._dir, 0, 0)

		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._createTimer)

		arg0._createTimer = nil
	end

	arg0._createTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AddCreateTimer", 0, arg2, var0)
end

function var6.Dispose(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
end

function var6.InitCldComponent(arg0)
	local var0 = arg0:GetTemplate().cld_box
	local var1 = arg0:GetTemplate().cld_offset
	local var2 = var1[1]

	if arg0:GetDirection() == var0.Battle.BattleConst.UnitDir.LEFT then
		var2 = var2 * -1
	end

	arg0._cldComponent = var0.Battle.BattleCubeCldComponent.New(var0[1], var0[2], var0[3], var2, var1[3])

	local var3 = {
		type = var2.CldType.AIRCRAFT,
		IFF = arg0:GetIFF(),
		UID = arg0:GetUniqueID()
	}

	arg0._cldComponent:SetCldData(var3)
end

function var6.GetCldBox(arg0)
	return arg0._cldComponent:GetCldBox(arg0:GetPosition())
end

function var6.GetCldData(arg0)
	return arg0._cldComponent:GetCldData()
end

function var6.AddBuff(arg0)
	return
end

function var6.SetBuffStack(arg0)
	return
end

function var6.RemoveBuff(arg0)
	return
end

function var6.TriggerBuff(arg0)
	return
end

function var6.CloakExpose(arg0)
	return
end

function var6.GetCurrentOxyState(arg0)
	return nil
end

function var6.RemoveRemoteBoundBone(arg0)
	return
end

function var6.SetRemoteBoundBone(arg0)
	return
end

function var6.GetRemoteBoundBone(arg0)
	return
end
