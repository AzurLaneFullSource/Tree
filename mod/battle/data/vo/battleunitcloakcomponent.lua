ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = var0_0.Battle.BattleAttr

var0_0.Battle.BattleUnitCloakComponent = class("BattleUnitCloakComponent")
var0_0.Battle.BattleUnitCloakComponent.__name = "BattleUnitCloakComponent"

local var5_0 = var0_0.Battle.BattleUnitCloakComponent

var5_0.STATE_CLOAK = "STATE_CLOAK"
var5_0.STATE_UNCLOAK = "STATE_UNCLOAK"

function var5_0.Ctor(arg0_1, arg1_1)
	arg0_1._client = arg1_1

	arg0_1:initCloak()
end

function var5_0.Update(arg0_2, arg1_2)
	arg0_2._lastCloakUpdateStamp = arg0_2._lastCloakUpdateStamp or arg1_2

	arg0_2:updateCloakValue(arg1_2)
	arg0_2:UpdateCloakState()

	arg0_2._lastCloakUpdateStamp = arg1_2

	var0_0.Battle.BattleBuffDOT.UpdateCloakLock(arg0_2._client)
end

function var5_0.UpdateCloakConfig(arg0_3)
	arg0_3._exposeBase = var4_0.GetCurrent(arg0_3._client, "cloakExposeBase")
	arg0_3._exposeExtra = var4_0.GetCurrent(arg0_3._client, "cloakExposeExtra")
	arg0_3._restoreValue = var4_0.GetCurrent(arg0_3._client, "cloakRestore")
	arg0_3._recovery = var4_0.GetCurrent(arg0_3._client, "cloakRecovery")

	arg0_3:adjustCloakAttr()
	arg0_3._client:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_CLOAK_CONFIG))
end

function var5_0.SetRecoverySpeed(arg0_4, arg1_4)
	arg0_4._fieldRecoveryOverride = arg1_4
end

function var5_0.AppendExpose(arg0_5, arg1_5)
	local var0_5 = arg0_5._cloakValue + arg1_5
	local var1_5 = arg0_5:GetCloakBottom()

	arg0_5._cloakValue = Mathf.Clamp(var0_5, var1_5, arg0_5._exposeValue)

	arg0_5:UpdateCloakState()
end

function var5_0.AppendStrikeExpose(arg0_6)
	local var0_6 = math.min(arg0_6._strikeExposeAdditive * arg0_6._strikeCount, arg0_6._strikeExposeAdditiveLimit)

	arg0_6._strikeCount = arg0_6._strikeCount + 1

	arg0_6:AppendExpose(var0_6)
end

function var5_0.AppendBombardExpose(arg0_7)
	local var0_7 = math.min(arg0_7._bombardExposeAdditive * arg0_7._bombardCount, arg0_7._bombardExposeAdditiveLimit)

	arg0_7._bombardCount = arg0_7._bombardCount + 1

	arg0_7:AppendExpose(var0_7)
end

function var5_0.AppendExposeSpeed(arg0_8, arg1_8)
	arg0_8._exposeSpeed = arg1_8
end

function var5_0.ForceToMax(arg0_9)
	arg0_9:ForceToRate(1)
end

function var5_0.ForceToRate(arg0_10, arg1_10)
	arg0_10._cloakValue = math.floor(arg1_10 * arg0_10._exposeValue)

	arg0_10:UpdateCloakState()
end

function var5_0.UpdateDotExpose(arg0_11, arg1_11)
	if arg1_11 ~= arg0_11._cloakBottom then
		arg0_11._cloakBottom = arg1_11

		arg0_11._client:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_CLOAK_LOCK))
	end
end

function var5_0.UpdateTauntExpose(arg0_12, arg1_12)
	if arg1_12 then
		arg0_12._tauntCloakBottom = arg0_12._restoreValue
	else
		arg0_12._tauntCloakBottom = nil
	end
end

function var5_0.UpdateCloakState(arg0_13)
	local var0_13

	if arg0_13._cloakValue >= arg0_13._exposeValue then
		var0_13 = var5_0.STATE_UNCLOAK
	elseif arg0_13._cloakValue < arg0_13._restoreValue then
		var0_13 = var5_0.STATE_CLOAK
	end

	if var0_13 and var0_13 ~= arg0_13._currentState then
		arg0_13._currentState = var0_13

		if arg0_13._currentState == var5_0.STATE_UNCLOAK then
			var4_0.Uncloak(arg0_13._client)
			arg0_13:triggerBuff()
		elseif arg0_13._currentState == var5_0.STATE_CLOAK then
			var4_0.Cloak(arg0_13._client)
			arg0_13:triggerBuff()
		end
	end
end

function var5_0.GetCloakValue(arg0_14)
	return arg0_14._cloakValue
end

function var5_0.GetCloakMax(arg0_15)
	return arg0_15._exposeValue
end

function var5_0.GetCloakLockMin(arg0_16)
	return arg0_16._fireLockValue
end

function var5_0.GetCloakRestoreValue(arg0_17)
	return arg0_17._restoreValue
end

function var5_0.GetCloakBottom(arg0_18)
	if arg0_18._tauntCloakBottom then
		return math.max(arg0_18._tauntCloakBottom, arg0_18._cloakBottom)
	else
		return arg0_18._cloakBottom
	end
end

function var5_0.GetCurrentState(arg0_19)
	return arg0_19._currentState
end

function var5_0.GetExposeSpeed(arg0_20)
	return arg0_20._exposeSpeed
end

function var5_0.updateCloakValue(arg0_21, arg1_21)
	local var0_21 = arg1_21 - arg0_21._lastCloakUpdateStamp
	local var1_21 = arg0_21._fieldRecoveryOverride or arg0_21._recovery
	local var2_21 = (arg0_21._exposeSpeed - var1_21) * var0_21

	arg0_21:AppendExpose(var2_21)
end

function var5_0.initCloak(arg0_22)
	arg0_22._exposeBase = var4_0.GetCurrent(arg0_22._client, "cloakExposeBase")
	arg0_22._exposeExtra = var4_0.GetCurrent(arg0_22._client, "cloakExposeExtra")
	arg0_22._restoreValue = var4_0.GetCurrent(arg0_22._client, "cloakRestore")
	arg0_22._fireLockValue = var4_0.GetCurrent(arg0_22._client, "cloakFireLock")
	arg0_22._cloakValue = 0
	arg0_22._exposeSpeed = 0
	arg0_22._cloakBottom = 0

	arg0_22:adjustCloakAttr()

	arg0_22._recovery = var4_0.GetCurrent(arg0_22._client, "cloakRecovery")
	arg0_22._strikeExposeAdditive = var4_0.GetCurrent(arg0_22._client, "cloakStrikeAdditive")
	arg0_22._bombardExposeAdditive = var4_0.GetCurrent(arg0_22._client, "cloakBombardAdditive")
	arg0_22._strikeCount = 0
	arg0_22._bombardCount = 0
	arg0_22._strikeExposeAdditiveLimit = var3_0.CLOAK_STRIKE_ADDITIVE_LIMIT
	arg0_22._bombardExposeAdditiveLimit = var3_0.CLOAK_STRIKE_ADDITIVE_LIMIT
	arg0_22._exposeDotList = {}
	arg0_22._currentState = var5_0.STATE_CLOAK

	var4_0.Cloak(arg0_22._client)
	arg0_22:triggerBuff()
end

function var5_0.triggerBuff(arg0_23)
	local var0_23 = var4_0.GetCurrent(arg0_23._client, "isCloak")

	arg0_23._client:DispatchCloakStateUpdate()
end

function var5_0.adjustCloakAttr(arg0_24)
	arg0_24._exposeBase = math.max(arg0_24._exposeBase, var3_0.CLOAK_EXPOSE_BASE_MIN)
	arg0_24._exposeValue = math.max(arg0_24._exposeBase + arg0_24._exposeExtra, var3_0.CLOAK_EXPOSE_SKILL_MIN)
	arg0_24._restoreValue = math.max(arg0_24._exposeValue + var3_0.CLOAK_BASE_RESTORE_DELTA, 0)
	arg0_24._exposeValue = math.max(arg0_24._exposeBase + arg0_24._exposeExtra, var3_0.CLOAK_EXPOSE_SKILL_MIN)
	arg0_24._cloakValue = Mathf.Clamp(arg0_24._cloakValue, 0, arg0_24._exposeValue)

	var4_0.SetCurrent(arg0_24._client, "cloakExposeBase", arg0_24._exposeBase)
	var4_0.SetCurrent(arg0_24._client, "cloakRestore", arg0_24._restoreValue)
	arg0_24:UpdateCloakState()
end
