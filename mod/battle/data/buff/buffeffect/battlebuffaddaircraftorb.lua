ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffAddAircraftOrb = class("BattleBuffAddAircraftOrb", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffAddAircraftOrb.__name = "BattleBuffAddAircraftOrb"

local var1_0 = var0_0.Battle.BattleBuffAddAircraftOrb

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._buffID = var0_2.buff_id
	arg0_2._rant = var0_2.rant or 10000
	arg0_2._level = var0_2.level or 1
	arg0_2._buffLevel = var0_2.buff_level or 1
end

function var1_0.onAircraftCreate(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3:equipIndexRequire(arg3_3.equipIndex) then
		return
	end

	local var0_3 = {
		buffID = arg0_3._buffID,
		rant = arg0_3._rant,
		level = arg0_3._level,
		buff_level = arg0_3._buffLevel
	}
	local var1_3 = arg3_3.aircraft:GetWeapon()

	for iter0_3, iter1_3 in ipairs(var1_3) do
		iter1_3:SetBulletOrbData(var0_3)
	end
end
