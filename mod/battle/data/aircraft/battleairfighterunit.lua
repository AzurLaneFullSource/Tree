ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleUnitEvent

var0.Battle.BattleAirFighterUnit = class("BattleAirFighterUnit", var0.Battle.BattleAircraftUnit)
var0.Battle.BattleAirFighterUnit.__name = "BattleAirFighterUnit"

local var3 = var0.Battle.BattleAirFighterUnit

var3.AIRFIGHTER_ENTER_POINT = Vector3(Screen.width * -0.5, Screen.height * 0.5, 15)
var3.SPEED_FLY = Vector3(3, 0, 0)
var3.BACK_X = 100
var3.DOWN_X = 30
var3.ATTACK_X = -23
var3.UP_X = -70
var3.FREE_X = -75
var3.HEIGHT = var0.Battle.BattleConfig.AirFighterHeight
var3.STRIKE_STATE_FLY = 0
var3.STRIKE_STATE_BACK = 1
var3.STRIKE_STATE_DOWN = 2
var3.STRIKE_STATE_ATTACK = 3
var3.STRIKE_STATE_UP = 4
var3.STRIKE_STATE_FREE = 5
var3.STRIKE_STATE_BACKWARD = 6
var3.STRIKE_STATE_RECYCLE = 7

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)

	arg0._dir = var0.Battle.BattleConst.UnitDir.LEFT
	arg0._type = var0.Battle.BattleConst.UnitType.AIRFIGHTER_UNIT

	arg0:changeState(var3.STRIKE_STATE_FLY)
	arg0:calcYShakeMin()
	arg0:calcYShakeMax()

	arg0._speedDir = Vector3(1, 0, 0)
	arg0._backwardWeaponID = {}
end

function var3.Update(arg0, arg1)
	arg0:UpdateSpeed()
	arg0:updateStrike()
end

function var3.UpdateWeapon(arg0)
	for iter0, iter1 in ipairs(arg0:GetWeapon()) do
		local var0 = iter1:GetWeaponId()
		local var1 = table.contains(arg0._backwardWeaponID, var0)
		local var2 = iter1:GetCurrentState()

		iter1:Update()

		local var3 = iter1:GetCurrentState()

		if var1 and var2 == iter1.STATE_READY and (var3 == iter1.STATE_ATTACK or var3 == iter1.STATE_OVER_HEAT) then
			arg0:changeState(var3.STRIKE_STATE_BACKWARD)
		end
	end
end

function var3.CreateWeapon(arg0)
	local var0 = {}

	if type(arg0._weaponTemplateID) == "table" then
		for iter0, iter1 in ipairs(arg0._weaponTemplateID) do
			var0[iter0] = var0.Battle.BattleDataFunction.CreateAirFighterWeaponUnit(iter1, arg0, iter0)
		end
	else
		var0[1] = var0.Battle.BattleDataFunction.CreateAirFighterWeaponUnit(arg0._weaponTemplateID, arg0, 1)
	end

	if arg0._backwardWeaponID then
		for iter2, iter3 in ipairs(arg0._backwardWeaponID) do
			var0[iter2] = var0.Battle.BattleDataFunction.CreateAirFighterWeaponUnit(iter3, arg0, iter2)
		end
	end

	return var0
end

function var3.SetWeaponTemplateID(arg0, arg1)
	arg0._weaponTemplateID = arg1
end

function var3.SetBackwardWeaponID(arg0, arg1)
	arg0._backwardWeaponID = arg1
end

function var3.SetTemplate(arg0, arg1)
	arg0:SetAttr(arg1)
	var3.super.SetTemplate(arg0, arg1)
end

function var3.SetAttr(arg0, arg1)
	var0.Battle.BattleAttr.SetAirFighterAttr(arg0, arg1)
	arg0:SetIFF(-1)
end

function var3.UpdateSpeed(arg0)
	arg0._speed:Copy(arg0._speedDir)
	arg0._speed:Mul(arg0._velocity * arg0:GetSpeedRatio())
end

function var3.Free(arg0)
	arg0._undefeated = true

	arg0:LiveCallBack()

	arg0._aliveState = false
end

function var3.recycle(arg0)
	arg0:LiveCallBack()

	arg0._aliveState = false
end

function var3.onDead(arg0)
	arg0._currentState = arg0.STATE_DESTORY

	arg0:DeadCallBack()

	arg0._aliveState = false
end

function var3.GetPosition(arg0)
	return arg0._viewPos
end

function var3.SetFormationIndex(arg0, arg1)
	arg0._formationIndex = arg1
	arg0._flyStateScale = 12 / (arg1 + 3) + 1

	arg0:DispatchStrikeStateChange()
end

function var3.GetFormationIndex(arg0)
	return arg0._formationIndex
end

function var3.SetFormationOffset(arg0, arg1)
	arg0._formationOffset = Vector3(arg1.x, arg1.y, arg1.z)
	arg0._formationOffsetOppo = Vector3(arg1.x * -1, arg1.y, arg1.z)
end

function var3.SetDeadCallBack(arg0, arg1)
	arg0._deadCallBack = arg1
end

function var3.DeadCallBack(arg0)
	arg0._deadCallBack()
end

function var3.SetLiveCallBack(arg0, arg1)
	arg0._liveCallBack = arg1
end

function var3.LiveCallBack(arg0)
	arg0._liveCallBack()
end

function var3.getYShake(arg0)
	local var0 = arg0._YShakeCurrent or 0

	arg0._YShakeDir = arg0._YShakeDir or 1

	local var1 = var0 + (0.04 * math.random() + 0.01) * arg0._YShakeDir

	if var1 > arg0._YShakeMax then
		arg0._YShakeDir = -1

		arg0:calcYShakeMin()
	elseif var1 < arg0._YShakeMin then
		arg0._YShakeDir = 1

		arg0:calcYShakeMax()
	end

	arg0._YShakeCurrent = var1

	return var1
end

function var3.calcYShakeMin(arg0)
	arg0._YShakeMin = -0.5 - math.random()
end

function var3.calcYShakeMax(arg0)
	arg0._YShakeMax = 0.5 + math.random()
end

function var3.DispatchStrikeStateChange(arg0)
	arg0:DispatchEvent(var0.Event.New(var2.AIR_STRIKE_STATE_CHANGE, {}))
end

function var3.GetStrikeState(arg0)
	return arg0._strikeState
end

function var3.GetSize(arg0)
	return arg0._scale
end

function var3.changeState(arg0, arg1)
	if arg0._strikeState == arg1 then
		return
	end

	arg0._strikeState = arg1

	if arg1 == var3.STRIKE_STATE_FLY then
		arg0:changeToFlyState()

		arg0.updateStrike = var3._updatePosFly
	elseif arg1 == var3.STRIKE_STATE_BACK then
		arg0.updateStrike = var3._updatePosBack

		arg0:changeToBackState()
	elseif arg1 == var3.STRIKE_STATE_DOWN then
		arg0.updateStrike = var3._updatePosDown

		arg0:changeToDownState()
	elseif arg1 == var3.STRIKE_STATE_ATTACK then
		arg0.updateStrike = var3._updatePosAttack

		arg0:changeToAttackState()
	elseif arg1 == var3.STRIKE_STATE_UP then
		arg0.updateStrike = var3._updatePosUp

		arg0:changeToUpState()
	elseif arg1 == var3.STRIKE_STATE_BACKWARD then
		arg0.updateStrike = var3._updateBackward

		arg0:changeToBackwardState()
	elseif arg1 == var3.STRIKE_STATE_FREE then
		arg0.updateStrike = var3._updateFree
	elseif arg1 == var3.STRIKE_STATE_RECYCLE then
		arg0.updateStrike = var3._updateRecycle
	end

	arg0:DispatchStrikeStateChange()
end

function var3.changeToFlyState(arg0)
	arg0._pos = var0.Battle.BattleCameraUtil.GetInstance():GetS2WPoint(var3.AIRFIGHTER_ENTER_POINT)
	arg0._viewPos = arg0._pos

	var0.Battle.PlayBattleSFX("battle/plane")
end

function var3._updatePosFly(arg0)
	arg0._pos:Add(var3.SPEED_FLY)

	arg0._viewPos = Vector3(arg0._formationOffset.x * arg0._flyStateScale, (arg0._formationOffset.z / 1.7 + arg0:getYShake()) * arg0._flyStateScale, 0):Add(arg0._pos)

	if arg0._pos.x > var3.BACK_X then
		arg0:changeState(var3.STRIKE_STATE_BACK)
	end
end

function var3.changeToBackState(arg0)
	local var0
	local var1 = var0.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var1.FRIENDLY_CODE):GetMotion()

	if var1 then
		var0 = var1:GetPos().z
	else
		var0 = 45
	end

	arg0._pos = Vector3(arg0._pos.x, 15, var0)
end

function var3._updatePosBack(arg0)
	arg0._pos:Sub(arg0._speed)
	arg0._viewPos:Copy(arg0._pos)
	arg0._viewPos:Sub(arg0._formationOffset)

	if arg0._pos.x < var3.DOWN_X then
		arg0:changeState(var3.STRIKE_STATE_DOWN)
	end
end

function var3.changeToDownState(arg0)
	arg0._ySpeed = 0.5

	arg0:SetVisitable()
end

function var3._updatePosDown(arg0)
	arg0._pos:Sub(arg0._speed)

	arg0._pos.y = math.max(var3.HEIGHT, arg0._pos.y - arg0._ySpeed)
	arg0._viewPos = arg0._pos + arg0._formationOffsetOppo
	arg0._ySpeed = math.max(0.02, arg0._ySpeed - 0.005)

	if arg0._pos.x < var3.ATTACK_X then
		arg0:changeState(var3.STRIKE_STATE_ATTACK)
	end
end

function var3.changeToAttackState(arg0)
	var0.Battle.PlayBattleSFX("battle/air-atk")
end

function var3._updatePosAttack(arg0)
	arg0._pos:Sub(arg0._speed)

	arg0._pos.y = math.max(var3.HEIGHT, arg0._pos.y - 0.04)

	local var0 = arg0._formationOffsetOppo

	var0.y = arg0:getYShake()
	arg0._viewPos = arg0._pos + var0

	arg0:UpdateWeapon()

	if arg0._pos.x < var3.UP_X then
		arg0:changeState(var3.STRIKE_STATE_UP)
	end
end

function var3.changeToUpState(arg0)
	arg0._ySpeed = 0.1
end

function var3._updatePosUp(arg0)
	arg0._pos:Sub(arg0._speed)

	arg0._pos.y = arg0._pos.y + arg0._ySpeed
	arg0._ySpeed = math.min(0.7, arg0._ySpeed + 0.02)
	arg0._viewPos = arg0._pos + arg0._formationOffsetOppo

	if arg0._pos.x < var3.FREE_X then
		arg0:changeState(var3.STRIKE_STATE_FREE)
	end
end

function var3._updateFree(arg0)
	arg0:Free()
end

function var3.changeToBackwardState(arg0)
	return
end

function var3._updateBackward(arg0)
	arg0._pos:Add(arg0._speed)

	arg0._pos.y = math.max(var3.HEIGHT, arg0._pos.y - 0.04)
	arg0._viewPos = arg0._pos + arg0._formationOffsetOppo

	if arg0._pos.x > var3.DOWN_X then
		arg0:changeState(var3.STRIKE_STATE_RECYCLE)
	end
end

function var3._updateRecycle(arg0)
	arg0:recycle()
end
