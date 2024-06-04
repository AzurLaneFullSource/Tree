ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffAddAircraftOrb = class("BattleBuffAddAircraftOrb", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffAddAircraftOrb.__name = "BattleBuffAddAircraftOrb"

local var1 = var0.Battle.BattleBuffAddAircraftOrb

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._buffID = arg0._tempData.arg_list.buff_id
	arg0._rant = arg0._tempData.arg_list.rant or 10000
	arg0._level = arg0._tempData.arg_list.level or 1
end

function var1.onAircraftCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	local var0 = {
		buffID = arg0._buffID,
		rant = arg0._rant,
		level = arg0._level
	}
	local var1 = arg3.aircraft:GetWeapon()

	for iter0, iter1 in ipairs(var1) do
		iter1:SetBulletOrbData(var0)
	end
end
