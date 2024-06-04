ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleFormulas
local var3 = class("BattleBuffAddBuff", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAddBuff = var3
var3.__name = "BattleBuffAddBuff"

function var3.Ctor(arg0, arg1)
	var0.Battle.BattleBuffAddBuff.super.Ctor(arg0, arg1)
end

function var3.SetArgs(arg0, arg1, arg2)
	arg0._level = arg2:GetLv()

	local var0 = arg0._tempData.arg_list

	arg0._buff_id = var0.buff_id
	arg0._target = var0.target or "TargetSelf"
	arg0._time = var0.time or 0
	arg0._rant = var0.rant or 10000
	arg0._nextEffectTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._time
	arg0._check_target = var0.check_target
	arg0._minTargetNumber = var0.minTargetNumber or 0
	arg0._maxTargetNumber = var0.maxTargetNumber or 10000
	arg0._isBuffStackByCheckTarget = var0.isBuffStackByCheckTarget
	arg0._countType = var0.countType
	arg0._weaponType = arg0._tempData.arg_list.weaponType
end

function var3.onUpdate(arg0, arg1, arg2, arg3)
	local var0 = arg3.timeStamp

	if var0 >= arg0._nextEffectTime then
		arg0:attachBuff(arg0._buff_id, arg0._level, arg1)

		arg0._nextEffectTime = var0 + arg0._time
	end
end

function var3.onBulletHit(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	local var0 = arg3.target

	if (not arg0._weaponType or arg3.weaponType == arg0._weaponType) and var0:IsAlive() then
		arg0:attachBuff(arg0._buff_id, arg0._level, var0)
	end
end

function var3.onBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	local var0 = arg3._bullet
	local var1 = arg0._buff_id
	local var2 = arg0._level
	local var3 = arg0._tempData.arg_list.bulletTrigger

	local function var4(arg0, arg1)
		arg0:attachBuff(var1, var2, arg0)
	end

	var0:SetBuffFun(var3, var4)
end

function var3.onTrigger(arg0, arg1, arg2, arg3)
	var3.super.onTrigger(arg0, arg1, arg2, arg3)
	arg0:AddBuff(arg1, arg3)
end

function var3.AddBuff(arg0, arg1, arg2)
	if not arg0:commanderRequire(arg1, arg0._tempData.arg_list) then
		return
	end

	if not arg0:ammoRequire(arg1) then
		return
	end

	if arg0._check_target then
		local var0 = #arg0:getTargetList(arg1, arg0._check_target, arg0._tempData.arg_list, arg2)

		if var0 >= arg0._minTargetNumber and var0 <= arg0._maxTargetNumber then
			local var1 = arg0:getTargetList(arg1, arg0._target, arg0._tempData.arg_list, arg2)

			for iter0, iter1 in ipairs(var1) do
				if arg0._isBuffStackByCheckTarget then
					iter1:SetBuffStack(arg0._buff_id, arg0._level, var0)
				else
					arg0:attachBuff(arg0._buff_id, arg0._level, iter1)
				end
			end
		end
	else
		local var2 = arg0:getTargetList(arg1, arg0._target, arg0._tempData.arg_list, arg2)

		for iter2, iter3 in ipairs(var2) do
			arg0:attachBuff(arg0._buff_id, arg0._level, iter3)
		end
	end
end

function var3.attachBuff(arg0, arg1, arg2, arg3)
	local var0 = var1.GetBuffTemplate(arg1).effect_list
	local var1

	if #var0 == 1 and var0[1].type == "BattleBuffDOT" then
		if var2.CaclulateDOTPlace(arg0._rant, var0[1], arg0._caster, arg3) then
			var1 = var0.Battle.BattleBuffUnit.New(arg1, nil, arg0._caster)

			var1:SetOrb(arg0._caster, 1)
		end
	elseif var2.IsHappen(arg0._rant) then
		var1 = var0.Battle.BattleBuffUnit.New(arg1, arg2, arg0._caster)
	end

	if var1 then
		var1:SetCommander(arg0._commander)
		arg3:AddBuff(var1)
	end
end

function var3.Dispose(arg0)
	var0.Battle.BattleBuffAddBuff.super:Dispose()
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._timer)

	arg0._timer = nil
end
