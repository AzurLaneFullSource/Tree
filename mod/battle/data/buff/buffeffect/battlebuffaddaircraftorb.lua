ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffAddAircraftOrb = class("BattleBuffAddAircraftOrb", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffAddAircraftOrb.__name = "BattleBuffAddAircraftOrb"

local var1_0 = var0_0.Battle.BattleBuffAddAircraftOrb

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._buffID = arg0_2._tempData.arg_list.buff_id
	arg0_2._rant = arg0_2._tempData.arg_list.rant or 10000
	arg0_2._level = arg0_2._tempData.arg_list.level or 1
end

function var1_0.onAircraftCreate(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3:equipIndexRequire(arg3_3.equipIndex) then
		return
	end

	local var0_3 = {
		buffID = arg0_3._buffID,
		rant = arg0_3._rant,
		level = arg0_3._level
	}
	local var1_3 = arg3_3.aircraft:GetWeapon()

	for iter0_3, iter1_3 in ipairs(var1_3) do
		iter1_3:SetBulletOrbData(var0_3)
	end
end
