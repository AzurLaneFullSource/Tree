ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffOrb", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffOrb = var1_0
var1_0.__name = "BattleBuffOrb"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._buffID = var0_2.buff_id
	arg0_2._rant = var0_2.rant or 10000
	arg0_2._level = var0_2.level or 1
	arg0_2._type = var0_2.type
end

function var1_0.onTrigger(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg3_3._bullet

	if arg0_3._type and var0_3:GetTemplate().type ~= arg0_3._type then
		return
	end

	arg0_3:attachOrb(var0_3)
	var1_0.super.onTrigger(arg0_3, arg1_3, arg2_3, arg3_3)
end

function var1_0.attachOrb(arg0_4, arg1_4)
	local var0_4 = {
		buff_id = arg0_4._buffID,
		rant = arg0_4._rant,
		level = arg0_4._level
	}

	arg1_4:AppendAttachBuff(var0_4)
end
