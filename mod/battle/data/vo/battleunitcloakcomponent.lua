ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig
local var4 = var0.Battle.BattleAttr

var0.Battle.BattleUnitCloakComponent = class("BattleUnitCloakComponent")
var0.Battle.BattleUnitCloakComponent.__name = "BattleUnitCloakComponent"

local var5 = var0.Battle.BattleUnitCloakComponent

var5.STATE_CLOAK = "STATE_CLOAK"
var5.STATE_UNCLOAK = "STATE_UNCLOAK"

function var5.Ctor(arg0, arg1)
	arg0._client = arg1

	arg0:initCloak()
end

function var5.Update(arg0, arg1)
	arg0._lastCloakUpdateStamp = arg0._lastCloakUpdateStamp or arg1

	arg0:updateCloakValue(arg1)
	arg0:UpdateCloakState()

	arg0._lastCloakUpdateStamp = arg1

	var0.Battle.BattleBuffDOT.UpdateCloakLock(arg0._client)
end

function var5.UpdateCloakConfig(arg0)
	arg0._exposeBase = var4.GetCurrent(arg0._client, "cloakExposeBase")
	arg0._exposeExtra = var4.GetCurrent(arg0._client, "cloakExposeExtra")
	arg0._restoreValue = var4.GetCurrent(arg0._client, "cloakRestore")
	arg0._recovery = var4.GetCurrent(arg0._client, "cloakRecovery")

	arg0:adjustCloakAttr()
	arg0._client:DispatchEvent(var0.Event.New(var1.UPDATE_CLOAK_CONFIG))
end

function var5.SetRecoverySpeed(arg0, arg1)
	arg0._fieldRecoveryOverride = arg1
end

function var5.AppendExpose(arg0, arg1)
	local var0 = arg0._cloakValue + arg1
	local var1 = arg0:GetCloakBottom()

	arg0._cloakValue = Mathf.Clamp(var0, var1, arg0._exposeValue)

	arg0:UpdateCloakState()
end

function var5.AppendStrikeExpose(arg0)
	local var0 = math.min(arg0._strikeExposeAdditive * arg0._strikeCount, arg0._strikeExposeAdditiveLimit)

	arg0._strikeCount = arg0._strikeCount + 1

	arg0:AppendExpose(var0)
end

function var5.AppendBombardExpose(arg0)
	local var0 = math.min(arg0._bombardExposeAdditive * arg0._bombardCount, arg0._bombardExposeAdditiveLimit)

	arg0._bombardCount = arg0._bombardCount + 1

	arg0:AppendExpose(var0)
end

function var5.AppendExposeSpeed(arg0, arg1)
	arg0._exposeSpeed = arg1
end

function var5.ForceToMax(arg0)
	arg0:ForceToRate(1)
end

function var5.ForceToRate(arg0, arg1)
	arg0._cloakValue = math.floor(arg1 * arg0._exposeValue)

	arg0:UpdateCloakState()
end

function var5.UpdateDotExpose(arg0, arg1)
	if arg1 ~= arg0._cloakBottom then
		arg0._cloakBottom = arg1

		arg0._client:DispatchEvent(var0.Event.New(var1.UPDATE_CLOAK_LOCK))
	end
end

function var5.UpdateTauntExpose(arg0, arg1)
	if arg1 then
		arg0._tauntCloakBottom = arg0._restoreValue
	else
		arg0._tauntCloakBottom = nil
	end
end

function var5.UpdateCloakState(arg0)
	local var0

	if arg0._cloakValue >= arg0._exposeValue then
		var0 = var5.STATE_UNCLOAK
	elseif arg0._cloakValue < arg0._restoreValue then
		var0 = var5.STATE_CLOAK
	end

	if var0 and var0 ~= arg0._currentState then
		arg0._currentState = var0

		if arg0._currentState == var5.STATE_UNCLOAK then
			var4.Uncloak(arg0._client)
			arg0:triggerBuff()
		elseif arg0._currentState == var5.STATE_CLOAK then
			var4.Cloak(arg0._client)
			arg0:triggerBuff()
		end
	end
end

function var5.GetCloakValue(arg0)
	return arg0._cloakValue
end

function var5.GetCloakMax(arg0)
	return arg0._exposeValue
end

function var5.GetCloakLockMin(arg0)
	return arg0._fireLockValue
end

function var5.GetCloakRestoreValue(arg0)
	return arg0._restoreValue
end

function var5.GetCloakBottom(arg0)
	if arg0._tauntCloakBottom then
		return math.max(arg0._tauntCloakBottom, arg0._cloakBottom)
	else
		return arg0._cloakBottom
	end
end

function var5.GetCurrentState(arg0)
	return arg0._currentState
end

function var5.GetExposeSpeed(arg0)
	return arg0._exposeSpeed
end

function var5.updateCloakValue(arg0, arg1)
	local var0 = arg1 - arg0._lastCloakUpdateStamp
	local var1 = arg0._fieldRecoveryOverride or arg0._recovery
	local var2 = (arg0._exposeSpeed - var1) * var0

	arg0:AppendExpose(var2)
end

function var5.initCloak(arg0)
	arg0._exposeBase = var4.GetCurrent(arg0._client, "cloakExposeBase")
	arg0._exposeExtra = var4.GetCurrent(arg0._client, "cloakExposeExtra")
	arg0._restoreValue = var4.GetCurrent(arg0._client, "cloakRestore")
	arg0._fireLockValue = var4.GetCurrent(arg0._client, "cloakFireLock")
	arg0._cloakValue = 0
	arg0._exposeSpeed = 0
	arg0._cloakBottom = 0

	arg0:adjustCloakAttr()

	arg0._recovery = var4.GetCurrent(arg0._client, "cloakRecovery")
	arg0._strikeExposeAdditive = var4.GetCurrent(arg0._client, "cloakStrikeAdditive")
	arg0._bombardExposeAdditive = var4.GetCurrent(arg0._client, "cloakBombardAdditive")
	arg0._strikeCount = 0
	arg0._bombardCount = 0
	arg0._strikeExposeAdditiveLimit = var3.CLOAK_STRIKE_ADDITIVE_LIMIT
	arg0._bombardExposeAdditiveLimit = var3.CLOAK_STRIKE_ADDITIVE_LIMIT
	arg0._exposeDotList = {}
	arg0._currentState = var5.STATE_CLOAK

	var4.Cloak(arg0._client)
	arg0:triggerBuff()
end

function var5.triggerBuff(arg0)
	local var0 = var4.GetCurrent(arg0._client, "isCloak")

	arg0._client:DispatchCloakStateUpdate()
end

function var5.adjustCloakAttr(arg0)
	arg0._exposeBase = math.max(arg0._exposeBase, var3.CLOAK_EXPOSE_BASE_MIN)
	arg0._exposeValue = math.max(arg0._exposeBase + arg0._exposeExtra, var3.CLOAK_EXPOSE_SKILL_MIN)
	arg0._restoreValue = math.max(arg0._exposeValue + var3.CLOAK_BASE_RESTORE_DELTA, 0)
	arg0._exposeValue = math.max(arg0._exposeBase + arg0._exposeExtra, var3.CLOAK_EXPOSE_SKILL_MIN)
	arg0._cloakValue = Mathf.Clamp(arg0._cloakValue, 0, arg0._exposeValue)

	var4.SetCurrent(arg0._client, "cloakExposeBase", arg0._exposeBase)
	var4.SetCurrent(arg0._client, "cloakRestore", arg0._restoreValue)
	arg0:UpdateCloakState()
end
