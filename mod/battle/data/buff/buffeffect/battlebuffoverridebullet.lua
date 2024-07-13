ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffOverrideBullet = class("BattleBuffOverrideBullet", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffOverrideBullet.__name = "BattleBuffOverrideBullet"

local var1_0 = var0_0.Battle.BattleBuffOverrideBullet

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._bulletType = arg0_2._tempData.arg_list.bullet_type
	arg0_2._override = arg0_2._tempData.arg_list.override
end

function var1_0.onBulletCreate(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3:equipIndexRequire(arg3_3.equipIndex) then
		return
	end

	local var0_3 = arg3_3._bullet

	if var0_3:GetType() == arg0_3._bulletType then
		arg0_3:overrideBullet(var0_3)
	end
end

function var1_0.overrideBullet(arg0_4, arg1_4)
	for iter0_4, iter1_4 in pairs(arg0_4._override) do
		if iter0_4 == "diverFilter" then
			arg1_4:SetDiverFilter(iter1_4)
			arg1_4:ResetCldSurface()
		elseif iter0_4 == "ignoreShield" then
			arg1_4:SetIgnoreShield(iter1_4)
		end
	end
end
