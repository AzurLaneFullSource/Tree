ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEnvironmentBehaviour")

var0.Battle.BattleEnvironmentBehaviour = var3
var3.__name = "BattleEnvironmentBehaviour"
var3.STATE_DELAY = "STATE_DELAY"
var3.STATE_READY = "STATE_READY"
var3.STATE_OVERHEAT = "STATE_OVERHEAT"
var3.STATE_EXPIRE = "STATE_EXPIRE"

function var3.Ctor(arg0, arg1, arg2)
	arg0._cldUnitList = {}
end

function var3.SetUnitRef(arg0, arg1)
	assert(arg1, "Shounld Bind A Unit")

	arg0._unit = arg1
end

function var3.SetTemplate(arg0, arg1)
	arg0._tmpData = arg1

	if arg0._tmpData.delay then
		arg0._delayStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0._state = var3.STATE_DELAY
	else
		arg0._state = var3.STATE_READY
	end

	if arg0._tmpData.life_time then
		arg0._liftStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end

	arg0._diveFilter = arg0._tmpData.diveFilter or {}
end

function var3.UpdateCollideUnitList(arg0, arg1)
	if #arg0._diveFilter ~= 0 then
		local var0 = #arg1

		while var0 > 0 do
			local var1 = arg1[var0]:GetCurrentOxyState()

			for iter0, iter1 in ipairs(arg0._diveFilter) do
				if var1 == iter1 then
					table.remove(arg1, var0)

					break
				end
			end

			var0 = var0 - 1
		end
	end

	arg0._cldUnitList = arg1
end

function var3.OnUpdate(arg0)
	arg0:updateDelay()
	arg0:updateReload()
	arg0:updateLifeTime()

	if arg0._state == var3.STATE_READY then
		arg0:doBehaviour()
	end
end

function var3.Dispose(arg0)
	arg0._cldUnitList = nil
	arg0._tmpData = nil
	arg0._CDstartTime = nil
end

function var3.OnCollide(arg0, arg1)
	return
end

function var3.GetCurrentState(arg0)
	return arg0._state
end

function var3.updateDelay(arg0)
	if arg0._delayStartTime and arg0._tmpData.delay + arg0._delayStartTime <= pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0._delayStartTime = nil

		arg0:handleCoolDown()
	end
end

function var3.updateReload(arg0)
	if arg0._CDstartTime then
		if arg0:getReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime() then
			arg0:handleCoolDown()
		else
			return
		end
	end
end

function var3.updateLifeTime(arg0)
	if arg0._liftStartTime and arg0._liftStartTime + arg0._tmpData.life_time <= pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0._state = var3.STATE_EXPIRE

		arg0:doExpire()
	end
end

function var3.getReloadFinishTimeStamp(arg0)
	return arg0._tmpData.reload_time + arg0._CDstartTime
end

function var3.handleCoolDown(arg0)
	arg0._state = var3.STATE_READY
	arg0._CDstartTime = nil
end

function var3.doBehaviour(arg0)
	if arg0._tmpData.reload_time then
		arg0._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0._state = var3.STATE_OVERHEAT
	end
end

function var3.doExpire(arg0)
	arg0._state = var3.STATE_EXPIRE
end

var3.BehaviourClassEnum = {
	[var1.EnviroumentBehaviour.PLAY_FX] = "BattleEnvironmentBehaviourPlayFX",
	[var1.EnviroumentBehaviour.DAMAGE] = "BattleEnvironmentBehaviourDamage",
	[var1.EnviroumentBehaviour.BUFF] = "BattleEnvironmentBehaviourBuff",
	[var1.EnviroumentBehaviour.MOVEMENT] = "BattleEnvironmentBehaviourMovement",
	[var1.EnviroumentBehaviour.FORCE] = "BattleEnvironmentBehaviourForce",
	[var1.EnviroumentBehaviour.SPAWN] = "BattleEnvironmentBehaviourSpawn",
	[var1.EnviroumentBehaviour.PLAY_SFX] = "BattleEnvironmentBehaviourPlaySFX",
	[var1.EnviroumentBehaviour.SHAKE_SCREEN] = "BattleEnvironmentBehaviourShakeScreen"
}

function var3.CreateBehaviour(arg0)
	return var0.Battle[var3.BehaviourClassEnum[arg0.type]].New()
end
