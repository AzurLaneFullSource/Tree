ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEnvironmentBehaviour")

var0_0.Battle.BattleEnvironmentBehaviour = var3_0
var3_0.__name = "BattleEnvironmentBehaviour"
var3_0.STATE_DELAY = "STATE_DELAY"
var3_0.STATE_READY = "STATE_READY"
var3_0.STATE_OVERHEAT = "STATE_OVERHEAT"
var3_0.STATE_EXPIRE = "STATE_EXPIRE"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._cldUnitList = {}
end

function var3_0.SetUnitRef(arg0_2, arg1_2)
	assert(arg1_2, "Shounld Bind A Unit")

	arg0_2._unit = arg1_2
end

function var3_0.SetTemplate(arg0_3, arg1_3)
	arg0_3._tmpData = arg1_3

	if arg0_3._tmpData.delay then
		arg0_3._delayStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0_3._state = var3_0.STATE_DELAY
	else
		arg0_3._state = var3_0.STATE_READY
	end

	if arg0_3._tmpData.life_time then
		arg0_3._liftStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end

	arg0_3._diveFilter = arg0_3._tmpData.diveFilter or {}
end

function var3_0.UpdateCollideUnitList(arg0_4, arg1_4)
	if #arg0_4._diveFilter ~= 0 then
		local var0_4 = #arg1_4

		while var0_4 > 0 do
			local var1_4 = arg1_4[var0_4]:GetCurrentOxyState()

			for iter0_4, iter1_4 in ipairs(arg0_4._diveFilter) do
				if var1_4 == iter1_4 then
					table.remove(arg1_4, var0_4)

					break
				end
			end

			var0_4 = var0_4 - 1
		end
	end

	arg0_4._cldUnitList = arg1_4
end

function var3_0.OnUpdate(arg0_5)
	arg0_5:updateDelay()
	arg0_5:updateReload()
	arg0_5:updateLifeTime()

	if arg0_5._state == var3_0.STATE_READY then
		arg0_5:doBehaviour()
	end
end

function var3_0.Dispose(arg0_6)
	arg0_6._cldUnitList = nil
	arg0_6._tmpData = nil
	arg0_6._CDstartTime = nil
end

function var3_0.OnCollide(arg0_7, arg1_7)
	return
end

function var3_0.GetCurrentState(arg0_8)
	return arg0_8._state
end

function var3_0.updateDelay(arg0_9)
	if arg0_9._delayStartTime and arg0_9._tmpData.delay + arg0_9._delayStartTime <= pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0_9._delayStartTime = nil

		arg0_9:handleCoolDown()
	end
end

function var3_0.updateReload(arg0_10)
	if arg0_10._CDstartTime then
		if arg0_10:getReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime() then
			arg0_10:handleCoolDown()
		else
			return
		end
	end
end

function var3_0.updateLifeTime(arg0_11)
	if arg0_11._liftStartTime and arg0_11._liftStartTime + arg0_11._tmpData.life_time <= pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0_11._state = var3_0.STATE_EXPIRE

		arg0_11:doExpire()
	end
end

function var3_0.getReloadFinishTimeStamp(arg0_12)
	return arg0_12._tmpData.reload_time + arg0_12._CDstartTime
end

function var3_0.handleCoolDown(arg0_13)
	arg0_13._state = var3_0.STATE_READY
	arg0_13._CDstartTime = nil
end

function var3_0.doBehaviour(arg0_14)
	if arg0_14._tmpData.reload_time then
		arg0_14._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0_14._state = var3_0.STATE_OVERHEAT
	end
end

function var3_0.doExpire(arg0_15)
	arg0_15._state = var3_0.STATE_EXPIRE
end

var3_0.BehaviourClassEnum = {
	[var1_0.EnviroumentBehaviour.PLAY_FX] = "BattleEnvironmentBehaviourPlayFX",
	[var1_0.EnviroumentBehaviour.DAMAGE] = "BattleEnvironmentBehaviourDamage",
	[var1_0.EnviroumentBehaviour.BUFF] = "BattleEnvironmentBehaviourBuff",
	[var1_0.EnviroumentBehaviour.MOVEMENT] = "BattleEnvironmentBehaviourMovement",
	[var1_0.EnviroumentBehaviour.FORCE] = "BattleEnvironmentBehaviourForce",
	[var1_0.EnviroumentBehaviour.SPAWN] = "BattleEnvironmentBehaviourSpawn",
	[var1_0.EnviroumentBehaviour.PLAY_SFX] = "BattleEnvironmentBehaviourPlaySFX",
	[var1_0.EnviroumentBehaviour.SHAKE_SCREEN] = "BattleEnvironmentBehaviourShakeScreen"
}

function var3_0.CreateBehaviour(arg0_16)
	return var0_0.Battle[var3_0.BehaviourClassEnum[arg0_16.type]].New()
end
