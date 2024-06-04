ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig
local var4 = var0.Battle.BattleAttr
local var5 = var0.Battle.BattleFormulas

var0.Battle.BattleUnitAimBiasComponent = class("BattleUnitAimBiasComponent")
var0.Battle.BattleUnitAimBiasComponent.__name = "BattleUnitAimBiasComponent"

local var6 = var0.Battle.BattleUnitAimBiasComponent

var6.NORMAL = 1
var6.DIVING = 2
var6.STATE_SUMMON_SICKNESS = "STATE_SUMMON_SICKNESS"
var6.STATE_ACTIVITING = "STATE_ACTIVITING"
var6.STATE_SKILL_EXPOSE = "STATE_SKILL_EXPOSE"
var6.STATE_TOTAL_EXPOSE = "STATE_TOTAL_EXPOSE"
var6.STATE_EXPIRE = "STATE_EXPIRE"

function var6.Ctor(arg0)
	return
end

function var6.Dispose(arg0)
	arg0:clear()
end

function var6.init(arg0)
	arg0._crewList = {}
	arg0._maxBiasRange = 0
	arg0._minBiasRange = 0
	arg0._currentBiasRange = 0
	arg0._biasAttr = 0
	arg0._decaySpeed = 0
	arg0._ratioSpeed = 0
	arg0._combinedSpeed = 0
	arg0._pos = Vector3.zero
end

function var6.ConfigRangeFormula(arg0, arg1, arg2)
	arg0._rangeFormulaFunc = arg1
	arg0._decayFormulaFunc = arg2

	arg0:init()
end

function var6.ConfigMinRange(arg0, arg1)
	arg0._minBiasRange = arg1
end

function var6.Active(arg0, arg1)
	arg0._state = arg1
	arg0._currentBiasRange = arg0._maxBiasRange
	arg0._activeTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0._lastUpdateTimeStamp = arg0._activeTimeStamp
end

function var6.GetHost(arg0)
	return arg0._host
end

function var6.Update(arg0, arg1)
	arg0._pos = arg0._host:GetPosition()

	local var0 = var4.GetCurrent(arg0._host, "aimBiasDecaySpeed")
	local var1 = var4.GetCurrent(arg0._host, "aimBiasDecaySpeedRatio") * arg0._maxBiasRange

	arg0._ratioSpeed = var1
	arg0._combinedSpeed = arg0._decaySpeed + var0 + var1

	if arg0._state == var6.STATE_SUMMON_SICKNESS then
		if arg1 - arg0._activeTimeStamp > var3.AIM_BIAS_ENEMY_INIT_TIME then
			arg0:ChangeState(var6.STATE_ACTIVITING)
		end
	elseif arg0._state == var6.STATE_SKILL_EXPOSE then
		arg0._biasAttr = 0
	else
		local var2 = arg0._combinedSpeed * (arg1 - arg0._lastUpdateTimeStamp)

		arg0._currentBiasRange = Mathf.Clamp(arg0._currentBiasRange - var2, arg0._minBiasRange, arg0._maxBiasRange)
		arg0._biasAttr = arg0._currentBiasRange

		if arg0._currentBiasRange <= arg0._minBiasRange then
			arg0:ChangeState(var6.STATE_TOTAL_EXPOSE)
		else
			arg0:ChangeState(var6.STATE_ACTIVITING)
		end
	end

	arg0._lastUpdateTimeStamp = arg1

	arg0:biasEffect()
end

function var6.GetCurrentRate(arg0)
	return (arg0._currentBiasRange - arg0._minBiasRange) / arg0._progressLength
end

function var6.GetDecayRatioSpeed(arg0)
	return arg0._ratioSpeed
end

function var6.GetCurrentState(arg0)
	return arg0._state
end

function var6.IsFaint(arg0)
	return arg0._state == var6.STATE_TOTAL_EXPOSE or arg0._state == var6.STATE_SKILL_EXPOSE
end

function var6.GetPosition(arg0)
	return arg0._pos
end

function var6.GetCrewCount(arg0)
	return #arg0._crewList
end

function var6.GetRange(arg0)
	local var0

	if arg0._state == var6.STATE_SKILL_EXPOSE then
		var0 = arg0._minBiasRange
	else
		var0 = arg0._currentBiasRange
	end

	return var0
end

function var6.GetDecayFactorType(arg0)
	if arg0._host:GetCurrentOxyState() == var2.OXY_STATE.DIVE then
		return var6.DIVING
	else
		return var6.NORMAL
	end
end

function var6.IsHostile(arg0)
	return arg0._hostile
end

function var6.SetDecayFactor(arg0, arg1, arg2)
	if arg1 == 0 then
		arg0._decaySpeed = 0

		return
	end

	if arg0._cacheFactor == arg1 and arg0._cacheType == arg0:GetDecayFactorType() then
		return
	end

	if arg0:GetDecayFactorType() == var6.DIVING then
		arg0._decaySpeed = var5.CalculateBiasDecayDiving(arg1)
	else
		arg0._decaySpeed = arg0._decayFormulaFunc(arg1)
	end

	arg0._decaySpeed = arg0._decaySpeed + arg2
end

function var6.AppendCrew(arg0, arg1)
	if table.contains(arg0._crewList, arg1) then
		return
	end

	table.insert(arg0._crewList, arg1)
	arg0:switchHost()
	arg0:flush()
	arg1:AttachAimBias(arg0)

	arg0._currentBiasRange = arg0._maxBiasRange
end

function var6.RemoveCrew(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg0._crewList) do
		if iter1 == arg1 then
			table.remove(arg0._crewList, iter0)

			break
		end
	end

	if #arg0._crewList == 0 then
		arg0:clear()
	else
		arg0:switchHost()
		arg0:flush()
	end
end

function var6.UpdateSkillLock(arg0)
	if var4.IsLockAimBias(arg0._host) then
		arg0:ChangeState(var6.STATE_SKILL_EXPOSE)
	elseif arg0._currentBiasRange <= arg0._minBiasRange then
		arg0:ChangeState(var6.STATE_TOTAL_EXPOSE)
	else
		arg0:ChangeState(var6.STATE_ACTIVITING)
	end

	arg0._host:DispatchEvent(var0.Event.New(var1.UPDATE_AIMBIAS_LOCK))
end

function var6.SmokeExitPause(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0._pauseStartTimeStamp = var0

	var4.SetCurrent(arg0._host, "lockAimBias", 1)
	arg0:UpdateSkillLock()
	arg0:Update(var0)

	local function var1()
		arg0:removeRestoreTimer()
		arg0._host:DetachAimBias()
	end

	arg0._smokeRestoreTimer = pg.TimeMgr.GetInstance():AddBattleTimer("smokeRestoreTimer", 0, var3.AIM_BIAS_SMOKE_RESTORE_DURATION, var1, true)
end

function var6.SomkeExitResume(arg0)
	arg0:removeRestoreTimer()

	local var0 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._pauseStartTimeStamp

	arg0._lastUpdateTimeStamp = arg0._lastUpdateTimeStamp + var0

	arg0:UpdateSkillLock()
end

function var6.SmokeRecover(arg0)
	arg0._currentBiasRange = math.min(arg0._maxBiasRange, arg0._currentBiasRange + arg0._maxBiasRange * var3.AIM_BIAS_SMOKE_RECOVERY_RATE)
end

function var6.ChangeState(arg0, arg1)
	arg0._state = arg1
end

function var6.SetHostile(arg0)
	arg0._hostile = true
end

function var6.switchHost(arg0)
	arg0._host = arg0._crewList[1]

	arg0._host:HostAimBias()
end

function var6.flush(arg0)
	arg0._maxBiasRange = math.max(arg0._rangeFormulaFunc(arg0._crewList), arg0._minBiasRange)

	local var0 = arg0._host:GetTemplate().cld_box

	arg0._progressLength = arg0._maxBiasRange - arg0._minBiasRange
end

function var6.biasEffect(arg0)
	for iter0, iter1 in ipairs(arg0._crewList) do
		var4.SetCurrent(iter1, "aimBias", arg0._biasAttr)
	end
end

function var6.removeRestoreTimer(arg0)
	var4.SetCurrent(arg0._host, "lockAimBias", 0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._smokeRestoreTimer)

	arg0._smokeRestoreTimer = nil
end

function var6.clear(arg0)
	if arg0._smokeRestoreTimer then
		arg0:removeRestoreTimer()
	end

	arg0._crewList = {}
	arg0._pos = nil
	arg0._state = var6.STATE_EXPIRE
end
