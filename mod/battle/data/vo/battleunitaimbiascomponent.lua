ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = var0_0.Battle.BattleAttr
local var5_0 = var0_0.Battle.BattleFormulas

var0_0.Battle.BattleUnitAimBiasComponent = class("BattleUnitAimBiasComponent")
var0_0.Battle.BattleUnitAimBiasComponent.__name = "BattleUnitAimBiasComponent"

local var6_0 = var0_0.Battle.BattleUnitAimBiasComponent

var6_0.NORMAL = 1
var6_0.DIVING = 2
var6_0.STATE_SUMMON_SICKNESS = "STATE_SUMMON_SICKNESS"
var6_0.STATE_ACTIVITING = "STATE_ACTIVITING"
var6_0.STATE_SKILL_EXPOSE = "STATE_SKILL_EXPOSE"
var6_0.STATE_TOTAL_EXPOSE = "STATE_TOTAL_EXPOSE"
var6_0.STATE_EXPIRE = "STATE_EXPIRE"

function var6_0.Ctor(arg0_1)
	return
end

function var6_0.Dispose(arg0_2)
	arg0_2:clear()
end

function var6_0.init(arg0_3)
	arg0_3._crewList = {}
	arg0_3._maxBiasRange = 0
	arg0_3._minBiasRange = 0
	arg0_3._currentBiasRange = 0
	arg0_3._biasAttr = 0
	arg0_3._decaySpeed = 0
	arg0_3._ratioSpeed = 0
	arg0_3._combinedSpeed = 0
	arg0_3._pos = Vector3.zero
end

function var6_0.ConfigRangeFormula(arg0_4, arg1_4, arg2_4)
	arg0_4._rangeFormulaFunc = arg1_4
	arg0_4._decayFormulaFunc = arg2_4

	arg0_4:init()
end

function var6_0.ConfigMinRange(arg0_5, arg1_5)
	arg0_5._minBiasRange = arg1_5
end

function var6_0.Active(arg0_6, arg1_6)
	arg0_6._state = arg1_6
	arg0_6._currentBiasRange = arg0_6._maxBiasRange
	arg0_6._activeTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_6._lastUpdateTimeStamp = arg0_6._activeTimeStamp
end

function var6_0.GetHost(arg0_7)
	return arg0_7._host
end

function var6_0.Update(arg0_8, arg1_8)
	arg0_8._pos = arg0_8._host:GetPosition()

	local var0_8 = var4_0.GetCurrent(arg0_8._host, "aimBiasDecaySpeed")
	local var1_8 = var4_0.GetCurrent(arg0_8._host, "aimBiasDecaySpeedRatio") * arg0_8._maxBiasRange

	arg0_8._ratioSpeed = var1_8
	arg0_8._combinedSpeed = arg0_8._decaySpeed + var0_8 + var1_8

	if arg0_8._state == var6_0.STATE_SUMMON_SICKNESS then
		if arg1_8 - arg0_8._activeTimeStamp > var3_0.AIM_BIAS_ENEMY_INIT_TIME then
			arg0_8:ChangeState(var6_0.STATE_ACTIVITING)
		end
	elseif arg0_8._state == var6_0.STATE_SKILL_EXPOSE then
		arg0_8._biasAttr = 0
	else
		local var2_8 = arg0_8._combinedSpeed * (arg1_8 - arg0_8._lastUpdateTimeStamp)

		arg0_8._currentBiasRange = Mathf.Clamp(arg0_8._currentBiasRange - var2_8, arg0_8._minBiasRange, arg0_8._maxBiasRange)
		arg0_8._biasAttr = arg0_8._currentBiasRange

		if arg0_8._currentBiasRange <= arg0_8._minBiasRange then
			arg0_8:ChangeState(var6_0.STATE_TOTAL_EXPOSE)
		else
			arg0_8:ChangeState(var6_0.STATE_ACTIVITING)
		end
	end

	arg0_8._lastUpdateTimeStamp = arg1_8

	arg0_8:biasEffect()
end

function var6_0.GetCurrentRate(arg0_9)
	return (arg0_9._currentBiasRange - arg0_9._minBiasRange) / arg0_9._progressLength
end

function var6_0.GetDecayRatioSpeed(arg0_10)
	return arg0_10._ratioSpeed
end

function var6_0.GetCurrentState(arg0_11)
	return arg0_11._state
end

function var6_0.IsFaint(arg0_12)
	return arg0_12._state == var6_0.STATE_TOTAL_EXPOSE or arg0_12._state == var6_0.STATE_SKILL_EXPOSE
end

function var6_0.GetPosition(arg0_13)
	return arg0_13._pos
end

function var6_0.GetCrewCount(arg0_14)
	return #arg0_14._crewList
end

function var6_0.GetRange(arg0_15)
	local var0_15

	if arg0_15._state == var6_0.STATE_SKILL_EXPOSE then
		var0_15 = arg0_15._minBiasRange
	else
		var0_15 = arg0_15._currentBiasRange
	end

	return var0_15
end

function var6_0.GetDecayFactorType(arg0_16)
	if arg0_16._host:GetCurrentOxyState() == var2_0.OXY_STATE.DIVE then
		return var6_0.DIVING
	else
		return var6_0.NORMAL
	end
end

function var6_0.IsHostile(arg0_17)
	return arg0_17._hostile
end

function var6_0.SetDecayFactor(arg0_18, arg1_18, arg2_18)
	if arg1_18 == 0 then
		arg0_18._decaySpeed = 0

		return
	end

	if arg0_18._cacheFactor == arg1_18 and arg0_18._cacheType == arg0_18:GetDecayFactorType() then
		return
	end

	if arg0_18:GetDecayFactorType() == var6_0.DIVING then
		arg0_18._decaySpeed = var5_0.CalculateBiasDecayDiving(arg1_18)
	else
		arg0_18._decaySpeed = arg0_18._decayFormulaFunc(arg1_18)
	end

	arg0_18._decaySpeed = arg0_18._decaySpeed + arg2_18
end

function var6_0.AppendCrew(arg0_19, arg1_19)
	if table.contains(arg0_19._crewList, arg1_19) then
		return
	end

	table.insert(arg0_19._crewList, arg1_19)
	arg0_19:switchHost()
	arg0_19:flush()
	arg1_19:AttachAimBias(arg0_19)

	arg0_19._currentBiasRange = arg0_19._maxBiasRange
end

function var6_0.RemoveCrew(arg0_20, arg1_20)
	local var0_20

	for iter0_20, iter1_20 in ipairs(arg0_20._crewList) do
		if iter1_20 == arg1_20 then
			table.remove(arg0_20._crewList, iter0_20)

			break
		end
	end

	if #arg0_20._crewList == 0 then
		arg0_20:clear()
	else
		arg0_20:switchHost()
		arg0_20:flush()
	end
end

function var6_0.UpdateSkillLock(arg0_21)
	if var4_0.IsLockAimBias(arg0_21._host) then
		arg0_21:ChangeState(var6_0.STATE_SKILL_EXPOSE)
	elseif arg0_21._currentBiasRange <= arg0_21._minBiasRange then
		arg0_21:ChangeState(var6_0.STATE_TOTAL_EXPOSE)
	else
		arg0_21:ChangeState(var6_0.STATE_ACTIVITING)
	end

	arg0_21._host:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_AIMBIAS_LOCK))
end

function var6_0.SmokeExitPause(arg0_22)
	local var0_22 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_22._pauseStartTimeStamp = var0_22

	var4_0.SetCurrent(arg0_22._host, "lockAimBias", 1)
	arg0_22:UpdateSkillLock()
	arg0_22:Update(var0_22)

	local function var1_22()
		arg0_22:removeRestoreTimer()
		arg0_22._host:DetachAimBias()
	end

	arg0_22._smokeRestoreTimer = pg.TimeMgr.GetInstance():AddBattleTimer("smokeRestoreTimer", 0, var3_0.AIM_BIAS_SMOKE_RESTORE_DURATION, var1_22, true)
end

function var6_0.SomkeExitResume(arg0_24)
	arg0_24:removeRestoreTimer()

	local var0_24 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_24._pauseStartTimeStamp

	arg0_24._lastUpdateTimeStamp = arg0_24._lastUpdateTimeStamp + var0_24

	arg0_24:UpdateSkillLock()
end

function var6_0.SmokeRecover(arg0_25)
	arg0_25._currentBiasRange = math.min(arg0_25._maxBiasRange, arg0_25._currentBiasRange + arg0_25._maxBiasRange * var3_0.AIM_BIAS_SMOKE_RECOVERY_RATE)
end

function var6_0.ChangeState(arg0_26, arg1_26)
	arg0_26._state = arg1_26
end

function var6_0.SetHostile(arg0_27)
	arg0_27._hostile = true
end

function var6_0.switchHost(arg0_28)
	arg0_28._host = arg0_28._crewList[1]

	arg0_28._host:HostAimBias()
end

function var6_0.flush(arg0_29)
	arg0_29._maxBiasRange = math.max(arg0_29._rangeFormulaFunc(arg0_29._crewList), arg0_29._minBiasRange)

	local var0_29 = arg0_29._host:GetTemplate().cld_box

	arg0_29._progressLength = arg0_29._maxBiasRange - arg0_29._minBiasRange
end

function var6_0.biasEffect(arg0_30)
	for iter0_30, iter1_30 in ipairs(arg0_30._crewList) do
		var4_0.SetCurrent(iter1_30, "aimBias", arg0_30._biasAttr)
	end
end

function var6_0.removeRestoreTimer(arg0_31)
	var4_0.SetCurrent(arg0_31._host, "lockAimBias", 0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_31._smokeRestoreTimer)

	arg0_31._smokeRestoreTimer = nil
end

function var6_0.clear(arg0_32)
	if arg0_32._smokeRestoreTimer then
		arg0_32:removeRestoreTimer()
	end

	arg0_32._crewList = {}
	arg0_32._pos = nil
	arg0_32._state = var6_0.STATE_EXPIRE
end
