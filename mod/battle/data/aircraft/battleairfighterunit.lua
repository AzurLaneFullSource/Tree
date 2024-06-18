ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleAirFighterUnit = class("BattleAirFighterUnit", var0_0.Battle.BattleAircraftUnit)
var0_0.Battle.BattleAirFighterUnit.__name = "BattleAirFighterUnit"

local var3_0 = var0_0.Battle.BattleAirFighterUnit

var3_0.AIRFIGHTER_ENTER_POINT = Vector3(Screen.width * -0.5, Screen.height * 0.5, 15)
var3_0.SPEED_FLY = Vector3(3, 0, 0)
var3_0.BACK_X = 100
var3_0.DOWN_X = 30
var3_0.ATTACK_X = -23
var3_0.UP_X = -70
var3_0.FREE_X = -75
var3_0.HEIGHT = var0_0.Battle.BattleConfig.AirFighterHeight
var3_0.STRIKE_STATE_FLY = 0
var3_0.STRIKE_STATE_BACK = 1
var3_0.STRIKE_STATE_DOWN = 2
var3_0.STRIKE_STATE_ATTACK = 3
var3_0.STRIKE_STATE_UP = 4
var3_0.STRIKE_STATE_FREE = 5
var3_0.STRIKE_STATE_BACKWARD = 6
var3_0.STRIKE_STATE_RECYCLE = 7

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._dir = var0_0.Battle.BattleConst.UnitDir.LEFT
	arg0_1._type = var0_0.Battle.BattleConst.UnitType.AIRFIGHTER_UNIT

	arg0_1:changeState(var3_0.STRIKE_STATE_FLY)
	arg0_1:calcYShakeMin()
	arg0_1:calcYShakeMax()

	arg0_1._speedDir = Vector3(1, 0, 0)
	arg0_1._backwardWeaponID = {}
end

function var3_0.Update(arg0_2, arg1_2)
	arg0_2:UpdateSpeed()
	arg0_2:updateStrike()
end

function var3_0.UpdateWeapon(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3:GetWeapon()) do
		local var0_3 = iter1_3:GetWeaponId()
		local var1_3 = table.contains(arg0_3._backwardWeaponID, var0_3)
		local var2_3 = iter1_3:GetCurrentState()

		iter1_3:Update()

		local var3_3 = iter1_3:GetCurrentState()

		if var1_3 and var2_3 == iter1_3.STATE_READY and (var3_3 == iter1_3.STATE_ATTACK or var3_3 == iter1_3.STATE_OVER_HEAT) then
			arg0_3:changeState(var3_0.STRIKE_STATE_BACKWARD)
		end
	end
end

function var3_0.CreateWeapon(arg0_4)
	local var0_4 = {}

	if type(arg0_4._weaponTemplateID) == "table" then
		for iter0_4, iter1_4 in ipairs(arg0_4._weaponTemplateID) do
			var0_4[iter0_4] = var0_0.Battle.BattleDataFunction.CreateAirFighterWeaponUnit(iter1_4, arg0_4, iter0_4)
		end
	else
		var0_4[1] = var0_0.Battle.BattleDataFunction.CreateAirFighterWeaponUnit(arg0_4._weaponTemplateID, arg0_4, 1)
	end

	if arg0_4._backwardWeaponID then
		for iter2_4, iter3_4 in ipairs(arg0_4._backwardWeaponID) do
			var0_4[iter2_4] = var0_0.Battle.BattleDataFunction.CreateAirFighterWeaponUnit(iter3_4, arg0_4, iter2_4)
		end
	end

	return var0_4
end

function var3_0.SetWeaponTemplateID(arg0_5, arg1_5)
	arg0_5._weaponTemplateID = arg1_5
end

function var3_0.SetBackwardWeaponID(arg0_6, arg1_6)
	arg0_6._backwardWeaponID = arg1_6
end

function var3_0.SetTemplate(arg0_7, arg1_7)
	arg0_7:SetAttr(arg1_7)
	var3_0.super.SetTemplate(arg0_7, arg1_7)
end

function var3_0.SetAttr(arg0_8, arg1_8)
	var0_0.Battle.BattleAttr.SetAirFighterAttr(arg0_8, arg1_8)
	arg0_8:SetIFF(-1)
end

function var3_0.UpdateSpeed(arg0_9)
	arg0_9._speed:Copy(arg0_9._speedDir)
	arg0_9._speed:Mul(arg0_9._velocity * arg0_9:GetSpeedRatio())
end

function var3_0.Free(arg0_10)
	arg0_10._undefeated = true

	arg0_10:LiveCallBack()

	arg0_10._aliveState = false
end

function var3_0.recycle(arg0_11)
	arg0_11:LiveCallBack()

	arg0_11._aliveState = false
end

function var3_0.onDead(arg0_12)
	arg0_12._currentState = arg0_12.STATE_DESTORY

	arg0_12:DeadCallBack()

	arg0_12._aliveState = false
end

function var3_0.GetPosition(arg0_13)
	return arg0_13._viewPos
end

function var3_0.SetFormationIndex(arg0_14, arg1_14)
	arg0_14._formationIndex = arg1_14
	arg0_14._flyStateScale = 12 / (arg1_14 + 3) + 1

	arg0_14:DispatchStrikeStateChange()
end

function var3_0.GetFormationIndex(arg0_15)
	return arg0_15._formationIndex
end

function var3_0.SetFormationOffset(arg0_16, arg1_16)
	arg0_16._formationOffset = Vector3(arg1_16.x, arg1_16.y, arg1_16.z)
	arg0_16._formationOffsetOppo = Vector3(arg1_16.x * -1, arg1_16.y, arg1_16.z)
end

function var3_0.SetDeadCallBack(arg0_17, arg1_17)
	arg0_17._deadCallBack = arg1_17
end

function var3_0.DeadCallBack(arg0_18)
	arg0_18._deadCallBack()
end

function var3_0.SetLiveCallBack(arg0_19, arg1_19)
	arg0_19._liveCallBack = arg1_19
end

function var3_0.LiveCallBack(arg0_20)
	arg0_20._liveCallBack()
end

function var3_0.getYShake(arg0_21)
	local var0_21 = arg0_21._YShakeCurrent or 0

	arg0_21._YShakeDir = arg0_21._YShakeDir or 1

	local var1_21 = var0_21 + (0.04 * math.random() + 0.01) * arg0_21._YShakeDir

	if var1_21 > arg0_21._YShakeMax then
		arg0_21._YShakeDir = -1

		arg0_21:calcYShakeMin()
	elseif var1_21 < arg0_21._YShakeMin then
		arg0_21._YShakeDir = 1

		arg0_21:calcYShakeMax()
	end

	arg0_21._YShakeCurrent = var1_21

	return var1_21
end

function var3_0.calcYShakeMin(arg0_22)
	arg0_22._YShakeMin = -0.5 - math.random()
end

function var3_0.calcYShakeMax(arg0_23)
	arg0_23._YShakeMax = 0.5 + math.random()
end

function var3_0.DispatchStrikeStateChange(arg0_24)
	arg0_24:DispatchEvent(var0_0.Event.New(var2_0.AIR_STRIKE_STATE_CHANGE, {}))
end

function var3_0.GetStrikeState(arg0_25)
	return arg0_25._strikeState
end

function var3_0.GetSize(arg0_26)
	return arg0_26._scale
end

function var3_0.changeState(arg0_27, arg1_27)
	if arg0_27._strikeState == arg1_27 then
		return
	end

	arg0_27._strikeState = arg1_27

	if arg1_27 == var3_0.STRIKE_STATE_FLY then
		arg0_27:changeToFlyState()

		arg0_27.updateStrike = var3_0._updatePosFly
	elseif arg1_27 == var3_0.STRIKE_STATE_BACK then
		arg0_27.updateStrike = var3_0._updatePosBack

		arg0_27:changeToBackState()
	elseif arg1_27 == var3_0.STRIKE_STATE_DOWN then
		arg0_27.updateStrike = var3_0._updatePosDown

		arg0_27:changeToDownState()
	elseif arg1_27 == var3_0.STRIKE_STATE_ATTACK then
		arg0_27.updateStrike = var3_0._updatePosAttack

		arg0_27:changeToAttackState()
	elseif arg1_27 == var3_0.STRIKE_STATE_UP then
		arg0_27.updateStrike = var3_0._updatePosUp

		arg0_27:changeToUpState()
	elseif arg1_27 == var3_0.STRIKE_STATE_BACKWARD then
		arg0_27.updateStrike = var3_0._updateBackward

		arg0_27:changeToBackwardState()
	elseif arg1_27 == var3_0.STRIKE_STATE_FREE then
		arg0_27.updateStrike = var3_0._updateFree
	elseif arg1_27 == var3_0.STRIKE_STATE_RECYCLE then
		arg0_27.updateStrike = var3_0._updateRecycle
	end

	arg0_27:DispatchStrikeStateChange()
end

function var3_0.changeToFlyState(arg0_28)
	arg0_28._pos = var0_0.Battle.BattleCameraUtil.GetInstance():GetS2WPoint(var3_0.AIRFIGHTER_ENTER_POINT)
	arg0_28._viewPos = arg0_28._pos

	var0_0.Battle.PlayBattleSFX("battle/plane")
end

function var3_0._updatePosFly(arg0_29)
	arg0_29._pos:Add(var3_0.SPEED_FLY)

	arg0_29._viewPos = Vector3(arg0_29._formationOffset.x * arg0_29._flyStateScale, (arg0_29._formationOffset.z / 1.7 + arg0_29:getYShake()) * arg0_29._flyStateScale, 0):Add(arg0_29._pos)

	if arg0_29._pos.x > var3_0.BACK_X then
		arg0_29:changeState(var3_0.STRIKE_STATE_BACK)
	end
end

function var3_0.changeToBackState(arg0_30)
	local var0_30
	local var1_30 = var0_0.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var1_0.FRIENDLY_CODE):GetMotion()

	if var1_30 then
		var0_30 = var1_30:GetPos().z
	else
		var0_30 = 45
	end

	arg0_30._pos = Vector3(arg0_30._pos.x, 15, var0_30)
end

function var3_0._updatePosBack(arg0_31)
	arg0_31._pos:Sub(arg0_31._speed)
	arg0_31._viewPos:Copy(arg0_31._pos)
	arg0_31._viewPos:Sub(arg0_31._formationOffset)

	if arg0_31._pos.x < var3_0.DOWN_X then
		arg0_31:changeState(var3_0.STRIKE_STATE_DOWN)
	end
end

function var3_0.changeToDownState(arg0_32)
	arg0_32._ySpeed = 0.5

	arg0_32:SetVisitable()
end

function var3_0._updatePosDown(arg0_33)
	arg0_33._pos:Sub(arg0_33._speed)

	arg0_33._pos.y = math.max(var3_0.HEIGHT, arg0_33._pos.y - arg0_33._ySpeed)
	arg0_33._viewPos = arg0_33._pos + arg0_33._formationOffsetOppo
	arg0_33._ySpeed = math.max(0.02, arg0_33._ySpeed - 0.005)

	if arg0_33._pos.x < var3_0.ATTACK_X then
		arg0_33:changeState(var3_0.STRIKE_STATE_ATTACK)
	end
end

function var3_0.changeToAttackState(arg0_34)
	var0_0.Battle.PlayBattleSFX("battle/air-atk")
end

function var3_0._updatePosAttack(arg0_35)
	arg0_35._pos:Sub(arg0_35._speed)

	arg0_35._pos.y = math.max(var3_0.HEIGHT, arg0_35._pos.y - 0.04)

	local var0_35 = arg0_35._formationOffsetOppo

	var0_35.y = arg0_35:getYShake()
	arg0_35._viewPos = arg0_35._pos + var0_35

	arg0_35:UpdateWeapon()

	if arg0_35._pos.x < var3_0.UP_X then
		arg0_35:changeState(var3_0.STRIKE_STATE_UP)
	end
end

function var3_0.changeToUpState(arg0_36)
	arg0_36._ySpeed = 0.1
end

function var3_0._updatePosUp(arg0_37)
	arg0_37._pos:Sub(arg0_37._speed)

	arg0_37._pos.y = arg0_37._pos.y + arg0_37._ySpeed
	arg0_37._ySpeed = math.min(0.7, arg0_37._ySpeed + 0.02)
	arg0_37._viewPos = arg0_37._pos + arg0_37._formationOffsetOppo

	if arg0_37._pos.x < var3_0.FREE_X then
		arg0_37:changeState(var3_0.STRIKE_STATE_FREE)
	end
end

function var3_0._updateFree(arg0_38)
	arg0_38:Free()
end

function var3_0.changeToBackwardState(arg0_39)
	return
end

function var3_0._updateBackward(arg0_40)
	arg0_40._pos:Add(arg0_40._speed)

	arg0_40._pos.y = math.max(var3_0.HEIGHT, arg0_40._pos.y - 0.04)
	arg0_40._viewPos = arg0_40._pos + arg0_40._formationOffsetOppo

	if arg0_40._pos.x > var3_0.DOWN_X then
		arg0_40:changeState(var3_0.STRIKE_STATE_RECYCLE)
	end
end

function var3_0._updateRecycle(arg0_41)
	arg0_41:recycle()
end
