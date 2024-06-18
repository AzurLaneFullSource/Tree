ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffDeath = class("BattleBuffDeath", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffDeath.__name = "BattleBuffDeath"

local var1_0 = var0_0.Battle.BattleBuffDeath

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	if var0_2.time then
		arg0_2._time = var0_2.time + pg.TimeMgr.GetInstance():GetCombatTime()
	end

	arg0_2._maxX = var0_2.maxX
	arg0_2._minX = var0_2.minX
	arg0_2._maxY = var0_2.maxY
	arg0_2._minY = var0_2.minY
	arg0_2._countType = var0_2.countType
	arg0_2._instantkill = arg0_2._tempData.arg_list.instant_kill
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg0_3._instantkill then
		arg0_3:DoDead(arg1_3)
	end
end

function var1_0.onUpdate(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg3_4.timeStamp

	if arg0_4._time and var0_4 > arg0_4._time then
		arg1_4:SetDeathReason(var0_0.Battle.BattleConst.UnitDeathReason.DESTRUCT)
		arg0_4:DoDead(arg1_4)
	else
		local var1_4 = arg1_4:GetPosition()

		if arg0_4._maxX and var1_4.x >= arg0_4._maxX then
			arg1_4:SetDeathReason(var0_0.Battle.BattleConst.UnitDeathReason.LEAVE)
			arg0_4:DoDead(arg1_4)
		elseif arg0_4._minX and var1_4.x <= arg0_4._minX then
			arg1_4:SetDeathReason(var0_0.Battle.BattleConst.UnitDeathReason.LEAVE)
			arg0_4:DoDead(arg1_4)
		elseif arg0_4._maxY and var1_4.z >= arg0_4._maxY then
			arg1_4:SetDeathReason(var0_0.Battle.BattleConst.UnitDeathReason.LEAVE)
			arg0_4:DoDead(arg1_4)
		elseif arg0_4._minY and var1_4.z <= arg0_4._minY then
			arg1_4:SetDeathReason(var0_0.Battle.BattleConst.UnitDeathReason.LEAVE)
			arg0_4:DoDead(arg1_4)
		end
	end
end

function var1_0.onBattleBuffCount(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg3_5.countType == arg0_5._countType then
		arg0_5:DoDead(arg1_5)
	end
end

function var1_0.DoDead(arg0_6, arg1_6)
	arg1_6:SetCurrentHP(0)
	arg1_6:DeadAction()
end
