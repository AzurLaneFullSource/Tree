ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffOverrideBullet = class("BattleBuffOverrideBullet", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffOverrideBullet.__name = "BattleBuffOverrideBullet"

local var1 = var0.Battle.BattleBuffOverrideBullet

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._bulletType = arg0._tempData.arg_list.bullet_type
	arg0._override = arg0._tempData.arg_list.override
end

function var1.onBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	local var0 = arg3._bullet

	if var0:GetType() == arg0._bulletType then
		arg0:overrideBullet(var0)
	end
end

function var1.overrideBullet(arg0, arg1)
	for iter0, iter1 in pairs(arg0._override) do
		if iter0 == "diverFilter" then
			arg1:SetDiverFilter(iter1)
			arg1:ResetCldSurface()
		elseif iter0 == "ignoreShield" then
			arg1:SetIgnoreShield(iter1)
		end
	end
end
