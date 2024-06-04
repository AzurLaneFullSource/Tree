ys = ys or {}

local var0 = ys
local var1 = class("BattleEffectBulletUnit", var0.Battle.BattleBulletUnit)

var0.Battle.BattleEffectBulletUnit = var1
var1.__name = "BattleEffectBulletUnit"

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)
end

function var1.Update(arg0, arg1)
	var1.super.Update(arg0, arg1)

	if arg0._flare then
		arg0._flare:SetPosition(pg.Tool.FilterY(arg0:GetPosition():Clone()))
	end
end

function var1.IsFlare(arg0)
	return arg0:GetTemplate().attach_buff[1].flare
end

function var1.OutRange(arg0)
	var1.super.OutRange(arg0)

	if arg0._flare then
		arg0._flare:SetActiveFlag(false)

		arg0._flare = nil
	end
end

function var1.spawnArea(arg0, arg1)
	local var0 = arg0:GetTemplate()
	local var1 = var0.hit_type
	local var2 = var0.attach_buff[1]
	local var3 = var2.buff_id
	local var4 = var2.buff_level or 1

	local function var5(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var0 = arg0._battleProxy:GetUnitList()[iter1.UID]
				local var1 = var0.Battle.BattleBuffUnit.New(var3, var4)

				var0:AddBuff(var1, true)
			end
		end
	end

	local function var6(arg0)
		if arg0.Active then
			arg0._battleProxy:GetUnitList()[arg0.UID]:RemoveBuff(var3, true)
		end
	end

	time = var1.time

	local var7 = arg0._battleProxy:SpawnLastingColumnArea(arg0:GetEffectField(), arg0:GetIFF(), pg.Tool.FilterY(arg0:GetPosition():Clone()), var1.range, time, var5, var6, var2.friendly, var2.effect_id)

	if arg1 then
		arg0._flare = var7
	end

	return var7
end

function var1.GetExplodePostion(arg0)
	return arg0._explodePos
end

function var1.SetExplodePosition(arg0, arg1)
	arg0._explodePos = arg1
end
