ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleVariable
local var3 = var0.Battle.BattleConfig

var0.Battle.BattleBeamUnit = class("BattleBeamUnit")
var0.Battle.BattleBeamUnit.__name = "BattleBeamUnit"

local var4 = var0.Battle.BattleBeamUnit

var4.BEAM_STATE_READY = "ready"
var4.BEAM_STATE_ATTACK = "attack"
var4.BEAM_STATE_FINISH = "finish"

function var4.Ctor(arg0, arg1, arg2)
	arg0._bulletID = arg1
	arg0._beamInfoID = arg2
	arg0._cldList = {}
	arg0._beamState = var4.BEAM_STATE_READY
end

function var4.IsBeamActive(arg0)
	return arg0._aoe:GetActiveFlag()
end

function var4.ClearBeam(arg0)
	arg0._beamState = var4.BEAM_STATE_FINISH
	arg0._aoe = nil
	arg0._cldList = {}
	arg0._nextDamageTime = nil
end

function var4.SetAoeData(arg0, arg1)
	arg0._aoe = arg1
	arg0._beamTemp = var1.GetBarrageTmpDataFromID(arg0._beamInfoID)
	arg0._bulletTemp = var1.GetBulletTmpDataFromID(arg0._bulletID)
	arg0._angle = arg0._beamTemp.angle

	arg0._aoe:SetAngle(arg0._angle + arg0._aimAngle)

	local var0 = arg0._bulletTemp.extra_param.diveFilter

	if var0 then
		arg0._aoe:SetDiveFilter(var0)
	end
end

function var4.SetAimAngle(arg0, arg1)
	arg0._aimAngle = arg1 or 0
end

function var4.SetAimPosition(arg0, arg1, arg2, arg3)
	if arg3 == var3.FOE_CODE then
		arg0._aimAngle = math.rad2Deg * math.atan2(arg2.z - arg1.z, arg2.x - arg1.x)
	elseif arg3 == var3.FRIENDLY_CODE then
		arg0._aimAngle = math.rad2Deg * math.atan2(arg1.z - arg2.z, arg1.x - arg2.x)
	end
end

function var4.getAngleRatio(arg0)
	return var2.GetSpeedRatio(arg0._aoe:GetTimeRationExemptKey(), arg0._aoe:GetIFF())
end

function var4.GetAoeData(arg0)
	return arg0._aoe
end

function var4.UpdateBeamPos(arg0, arg1)
	arg0._aoe:SetPosition(Vector3(arg1.x + arg0._beamTemp.offset_x, 0, arg1.z + arg0._beamTemp.offset_z))
end

function var4.UpdateBeamAngle(arg0)
	arg0._angle = arg0._angle + arg0._beamTemp.delta_angle * arg0:getAngleRatio()

	arg0._aoe:SetAngle(arg0._angle + arg0._aimAngle)
end

function var4.AddCldUnit(arg0, arg1)
	local var0 = arg1:GetUniqueID()

	arg0._cldList[var0] = arg1
end

function var4.RemoveCldUnit(arg0, arg1)
	local var0 = arg1:GetUniqueID()

	arg0._cldList[var0] = nil
end

function var4.ChangeBeamState(arg0, arg1)
	arg0._beamState = arg1
end

function var4.GetBeamState(arg0)
	return arg0._beamState
end

function var4.GetCldUnitList(arg0)
	return arg0._cldList
end

function var4.BeginFocus(arg0)
	arg0._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._beamTemp.senior_delay
end

function var4.DealDamage(arg0)
	arg0._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._beamTemp.delta_delay
end

function var4.CanDealDamage(arg0)
	return arg0._nextDamageTime < pg.TimeMgr.GetInstance():GetCombatTime()
end

function var4.GetFXID(arg0)
	return arg0._bulletTemp.hit_fx
end

function var4.GetSFXID(arg0)
	return arg0._bulletTemp.hit_sfx
end

function var4.GetBulletID(arg0)
	return arg0._bulletID
end

function var4.GetBeamInfoID(arg0)
	return arg0._beamInfoID
end

function var4.GetBeamExtraParam(arg0)
	return arg0._bulletTemp.extra_param
end
