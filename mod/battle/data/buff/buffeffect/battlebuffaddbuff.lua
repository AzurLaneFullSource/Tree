ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = class("BattleBuffAddBuff", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAddBuff = var3_0
var3_0.__name = "BattleBuffAddBuff"

function var3_0.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffAddBuff.super.Ctor(arg0_1, arg1_1)
end

function var3_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._level = arg2_2:GetLv()

	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._buff_id = var0_2.buff_id
	arg0_2._target = var0_2.target or "TargetSelf"
	arg0_2._time = var0_2.time or 0
	arg0_2._rant = var0_2.rant or 10000
	arg0_2._nextEffectTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_2._time
	arg0_2._check_target = var0_2.check_target
	arg0_2._minTargetNumber = var0_2.minTargetNumber or 0
	arg0_2._maxTargetNumber = var0_2.maxTargetNumber or 10000
	arg0_2._isBuffStackByCheckTarget = var0_2.isBuffStackByCheckTarget
	arg0_2._countType = var0_2.countType
	arg0_2._weaponType = arg0_2._tempData.arg_list.weaponType
end

function var3_0.onUpdate(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg3_3.timeStamp

	if var0_3 >= arg0_3._nextEffectTime then
		arg0_3:attachBuff(arg0_3._buff_id, arg0_3._level, arg1_3)

		arg0_3._nextEffectTime = var0_3 + arg0_3._time
	end
end

function var3_0.onBulletHit(arg0_4, arg1_4, arg2_4, arg3_4)
	if not arg0_4:equipIndexRequire(arg3_4.equipIndex) then
		return
	end

	local var0_4 = arg3_4.target

	if (not arg0_4._weaponType or arg3_4.weaponType == arg0_4._weaponType) and var0_4:IsAlive() then
		arg0_4:attachBuff(arg0_4._buff_id, arg0_4._level, var0_4)
	end
end

function var3_0.onBulletCreate(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg0_5:equipIndexRequire(arg3_5.equipIndex) then
		return
	end

	local var0_5 = arg3_5._bullet
	local var1_5 = arg0_5._buff_id
	local var2_5 = arg0_5._level
	local var3_5 = arg0_5._tempData.arg_list.bulletTrigger

	local function var4_5(arg0_6, arg1_6)
		arg0_5:attachBuff(var1_5, var2_5, arg0_6)
	end

	var0_5:SetBuffFun(var3_5, var4_5)
end

function var3_0.onTrigger(arg0_7, arg1_7, arg2_7, arg3_7)
	var3_0.super.onTrigger(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7:AddBuff(arg1_7, arg3_7)
end

function var3_0.AddBuff(arg0_8, arg1_8, arg2_8)
	if not arg0_8:commanderRequire(arg1_8, arg0_8._tempData.arg_list) then
		return
	end

	if not arg0_8:ammoRequire(arg1_8) then
		return
	end

	if arg0_8._check_target then
		local var0_8 = #arg0_8:getTargetList(arg1_8, arg0_8._check_target, arg0_8._tempData.arg_list, arg2_8)

		if var0_8 >= arg0_8._minTargetNumber and var0_8 <= arg0_8._maxTargetNumber then
			local var1_8 = arg0_8:getTargetList(arg1_8, arg0_8._target, arg0_8._tempData.arg_list, arg2_8)

			for iter0_8, iter1_8 in ipairs(var1_8) do
				if arg0_8._isBuffStackByCheckTarget then
					iter1_8:SetBuffStack(arg0_8._buff_id, arg0_8._level, var0_8)
				else
					arg0_8:attachBuff(arg0_8._buff_id, arg0_8._level, iter1_8)
				end
			end
		end
	else
		local var2_8 = arg0_8:getTargetList(arg1_8, arg0_8._target, arg0_8._tempData.arg_list, arg2_8)

		for iter2_8, iter3_8 in ipairs(var2_8) do
			arg0_8:attachBuff(arg0_8._buff_id, arg0_8._level, iter3_8)
		end
	end
end

function var3_0.attachBuff(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = var1_0.GetBuffTemplate(arg1_9).effect_list
	local var1_9

	if #var0_9 == 1 and var0_9[1].type == "BattleBuffDOT" then
		if var2_0.CaclulateDOTPlace(arg0_9._rant, var0_9[1], arg0_9._caster, arg3_9) then
			var1_9 = var0_0.Battle.BattleBuffUnit.New(arg1_9, nil, arg0_9._caster)

			var1_9:SetOrb(arg0_9._caster, 1)
		end
	elseif var2_0.IsHappen(arg0_9._rant) then
		var1_9 = var0_0.Battle.BattleBuffUnit.New(arg1_9, arg2_9, arg0_9._caster)
	end

	if var1_9 then
		var1_9:SetCommander(arg0_9._commander)
		arg3_9:AddBuff(var1_9)
	end
end

function var3_0.Dispose(arg0_10)
	var0_0.Battle.BattleBuffAddBuff.super:Dispose()
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_10._timer)

	arg0_10._timer = nil
end
