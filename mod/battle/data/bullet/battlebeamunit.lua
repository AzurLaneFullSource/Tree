ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleVariable
local var3_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleBeamUnit = class("BattleBeamUnit")
var0_0.Battle.BattleBeamUnit.__name = "BattleBeamUnit"

local var4_0 = var0_0.Battle.BattleBeamUnit

var4_0.BEAM_STATE_READY = "ready"
var4_0.BEAM_STATE_ATTACK = "attack"
var4_0.BEAM_STATE_FINISH = "finish"

function var4_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._bulletID = arg1_1
	arg0_1._beamInfoID = arg2_1
	arg0_1._cldList = {}
	arg0_1._beamState = var4_0.BEAM_STATE_READY
end

function var4_0.IsBeamActive(arg0_2)
	return arg0_2._aoe:GetActiveFlag()
end

function var4_0.ClearBeam(arg0_3)
	arg0_3._beamState = var4_0.BEAM_STATE_FINISH
	arg0_3._aoe = nil
	arg0_3._cldList = {}
	arg0_3._nextDamageTime = nil
end

function var4_0.SetAoeData(arg0_4, arg1_4)
	arg0_4._aoe = arg1_4
	arg0_4._beamTemp = var1_0.GetBarrageTmpDataFromID(arg0_4._beamInfoID)
	arg0_4._bulletTemp = var1_0.GetBulletTmpDataFromID(arg0_4._bulletID)
	arg0_4._angle = arg0_4._beamTemp.angle

	arg0_4._aoe:SetAngle(arg0_4._angle + arg0_4._aimAngle)

	local var0_4 = arg0_4._bulletTemp.extra_param.diveFilter

	if var0_4 then
		arg0_4._aoe:SetDiveFilter(var0_4)
	end
end

function var4_0.SetAimAngle(arg0_5, arg1_5)
	arg0_5._aimAngle = arg1_5 or 0
end

function var4_0.SetAimPosition(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg3_6 == var3_0.FOE_CODE then
		arg0_6._aimAngle = math.rad2Deg * math.atan2(arg2_6.z - arg1_6.z, arg2_6.x - arg1_6.x)
	elseif arg3_6 == var3_0.FRIENDLY_CODE then
		arg0_6._aimAngle = math.rad2Deg * math.atan2(arg1_6.z - arg2_6.z, arg1_6.x - arg2_6.x)
	end
end

function var4_0.getAngleRatio(arg0_7)
	return var2_0.GetSpeedRatio(arg0_7._aoe:GetTimeRationExemptKey(), arg0_7._aoe:GetIFF())
end

function var4_0.GetAoeData(arg0_8)
	return arg0_8._aoe
end

function var4_0.UpdateBeamPos(arg0_9, arg1_9)
	arg0_9._aoe:SetPosition(Vector3(arg1_9.x + arg0_9._beamTemp.offset_x, 0, arg1_9.z + arg0_9._beamTemp.offset_z))
end

function var4_0.UpdateBeamAngle(arg0_10)
	arg0_10._angle = arg0_10._angle + arg0_10._beamTemp.delta_angle * arg0_10:getAngleRatio()

	arg0_10._aoe:SetAngle(arg0_10._angle + arg0_10._aimAngle)
end

function var4_0.AddCldUnit(arg0_11, arg1_11)
	local var0_11 = arg1_11:GetUniqueID()

	arg0_11._cldList[var0_11] = arg1_11
end

function var4_0.RemoveCldUnit(arg0_12, arg1_12)
	local var0_12 = arg1_12:GetUniqueID()

	arg0_12._cldList[var0_12] = nil
end

function var4_0.ChangeBeamState(arg0_13, arg1_13)
	arg0_13._beamState = arg1_13
end

function var4_0.GetBeamState(arg0_14)
	return arg0_14._beamState
end

function var4_0.GetCldUnitList(arg0_15)
	return arg0_15._cldList
end

function var4_0.BeginFocus(arg0_16)
	arg0_16._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_16._beamTemp.senior_delay
end

function var4_0.DealDamage(arg0_17)
	arg0_17._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_17._beamTemp.delta_delay
end

function var4_0.CanDealDamage(arg0_18)
	return arg0_18._nextDamageTime < pg.TimeMgr.GetInstance():GetCombatTime()
end

function var4_0.GetFXID(arg0_19)
	return arg0_19._bulletTemp.hit_fx
end

function var4_0.GetSFXID(arg0_20)
	return arg0_20._bulletTemp.hit_sfx
end

function var4_0.GetBulletID(arg0_21)
	return arg0_21._bulletID
end

function var4_0.GetBeamInfoID(arg0_22)
	return arg0_22._beamInfoID
end

function var4_0.GetBeamExtraParam(arg0_23)
	return arg0_23._bulletTemp.extra_param
end
