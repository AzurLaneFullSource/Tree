ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffDeath = class("BattleBuffDeath", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffDeath.__name = "BattleBuffDeath"

local var1 = var0.Battle.BattleBuffDeath

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	if var0.time then
		arg0._time = var0.time + pg.TimeMgr.GetInstance():GetCombatTime()
	end

	arg0._maxX = var0.maxX
	arg0._minX = var0.minX
	arg0._maxY = var0.maxY
	arg0._minY = var0.minY
	arg0._countType = var0.countType
	arg0._instantkill = arg0._tempData.arg_list.instant_kill
end

function var1.onAttach(arg0, arg1, arg2, arg3)
	if arg0._instantkill then
		arg0:DoDead(arg1)
	end
end

function var1.onUpdate(arg0, arg1, arg2, arg3)
	local var0 = arg3.timeStamp

	if arg0._time and var0 > arg0._time then
		arg1:SetDeathReason(var0.Battle.BattleConst.UnitDeathReason.DESTRUCT)
		arg0:DoDead(arg1)
	else
		local var1 = arg1:GetPosition()

		if arg0._maxX and var1.x >= arg0._maxX then
			arg1:SetDeathReason(var0.Battle.BattleConst.UnitDeathReason.LEAVE)
			arg0:DoDead(arg1)
		elseif arg0._minX and var1.x <= arg0._minX then
			arg1:SetDeathReason(var0.Battle.BattleConst.UnitDeathReason.LEAVE)
			arg0:DoDead(arg1)
		elseif arg0._maxY and var1.z >= arg0._maxY then
			arg1:SetDeathReason(var0.Battle.BattleConst.UnitDeathReason.LEAVE)
			arg0:DoDead(arg1)
		elseif arg0._minY and var1.z <= arg0._minY then
			arg1:SetDeathReason(var0.Battle.BattleConst.UnitDeathReason.LEAVE)
			arg0:DoDead(arg1)
		end
	end
end

function var1.onBattleBuffCount(arg0, arg1, arg2, arg3)
	if arg3.countType == arg0._countType then
		arg0:DoDead(arg1)
	end
end

function var1.DoDead(arg0, arg1)
	arg1:SetCurrentHP(0)
	arg1:DeadAction()
end
