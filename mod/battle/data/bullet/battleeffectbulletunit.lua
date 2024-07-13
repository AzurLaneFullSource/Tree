ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleEffectBulletUnit", var0_0.Battle.BattleBulletUnit)

var0_0.Battle.BattleEffectBulletUnit = var1_0
var1_0.__name = "BattleEffectBulletUnit"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var1_0.Update(arg0_2, arg1_2)
	var1_0.super.Update(arg0_2, arg1_2)

	if arg0_2._flare then
		arg0_2._flare:SetPosition(pg.Tool.FilterY(arg0_2:GetPosition():Clone()))
	end
end

function var1_0.IsFlare(arg0_3)
	return arg0_3:GetTemplate().attach_buff[1].flare
end

function var1_0.OutRange(arg0_4)
	var1_0.super.OutRange(arg0_4)

	if arg0_4._flare then
		arg0_4._flare:SetActiveFlag(false)

		arg0_4._flare = nil
	end
end

function var1_0.spawnArea(arg0_5, arg1_5)
	local var0_5 = arg0_5:GetTemplate()
	local var1_5 = var0_5.hit_type
	local var2_5 = var0_5.attach_buff[1]
	local var3_5 = var2_5.buff_id
	local var4_5 = var2_5.buff_level or 1

	local function var5_5(arg0_6)
		for iter0_6, iter1_6 in ipairs(arg0_6) do
			if iter1_6.Active then
				local var0_6 = arg0_5._battleProxy:GetUnitList()[iter1_6.UID]
				local var1_6 = var0_0.Battle.BattleBuffUnit.New(var3_5, var4_5)

				var0_6:AddBuff(var1_6, true)
			end
		end
	end

	local function var6_5(arg0_7)
		if arg0_7.Active then
			arg0_5._battleProxy:GetUnitList()[arg0_7.UID]:RemoveBuff(var3_5, true)
		end
	end

	time = var1_5.time

	local var7_5 = arg0_5._battleProxy:SpawnLastingColumnArea(arg0_5:GetEffectField(), arg0_5:GetIFF(), pg.Tool.FilterY(arg0_5:GetPosition():Clone()), var1_5.range, time, var5_5, var6_5, var2_5.friendly, var2_5.effect_id)

	if arg1_5 then
		arg0_5._flare = var7_5
	end

	return var7_5
end

function var1_0.GetExplodePostion(arg0_8)
	return arg0_8._explodePos
end

function var1_0.SetExplodePosition(arg0_9, arg1_9)
	arg0_9._explodePos = arg1_9
end
