ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffOrb", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffOrb = var1
var1.__name = "BattleBuffOrb"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._buffID = var0.buff_id
	arg0._rant = var0.rant or 10000
	arg0._level = var0.level or 1
	arg0._type = var0.type
end

function var1.onTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg3._bullet

	if arg0._type and var0:GetTemplate().type ~= arg0._type then
		return
	end

	arg0:attachOrb(var0)
	var1.super.onTrigger(arg0, arg1, arg2, arg3)
end

function var1.attachOrb(arg0, arg1)
	local var0 = {
		buff_id = arg0._buffID,
		rant = arg0._rant,
		level = arg0._level
	}

	arg1:AppendAttachBuff(var0)
end
