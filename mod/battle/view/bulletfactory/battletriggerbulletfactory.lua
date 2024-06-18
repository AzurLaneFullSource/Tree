ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleTriggerBulletFactory = singletonClass("BattleTriggerBulletFactory", var0_0.Battle.BattleBombBulletFactory)
var0_0.Battle.BattleTriggerBulletFactory.__name = "BattleTriggerBulletFactory"

local var1_0 = var0_0.Battle.BattleTriggerBulletFactory

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.OutRangeFunc(arg0_2)
	local var0_2 = arg0_2:GetTemplate()
	local var1_2 = var0_2.hit_type
	local var2_2 = var0_2.extra_param.multy or 1
	local var3_2 = var1_0.GetDataProxy()
	local var4_2 = arg0_2:GetDiveFilter()
	local var5_2

	local function var6_2(arg0_3)
		local var0_3 = var1_2.decay

		if var0_3 then
			var5_2:UpdateDistanceInfo()
		end

		for iter0_3, iter1_3 in ipairs(arg0_3) do
			if iter1_3.Active then
				local var1_3 = iter1_3.UID
				local var2_3 = 0

				if var0_3 then
					var2_3 = var5_2:GetDistance(var1_3) / (var1_2.range * 0.5) * var0_3
				end

				local var3_3 = var1_0.GetSceneMediator():GetCharacter(var1_3):GetUnitData()
				local var4_3 = 0

				while var3_3:IsAlive() and var4_3 < var2_2 do
					var3_2:HandleDamage(arg0_2, var3_3, var2_3)

					var4_3 = var4_3 + 1
				end
			end
		end

		var0_0.Battle.PlayBattleSFX(arg0_2:GetHitSFX())
		var3_2:SpawnEffect(var0_2.hit_fx, arg0_2:GetExplodePostion())
	end

	var5_2 = var3_2:SpawnTriggerColumnArea(arg0_2:GetEffectField(), arg0_2:GetIFF(), arg0_2:GetExplodePostion(), var1_2.range, var1_2.time, false, var0_2.miss_fx, var6_2)

	var5_2:SetDiveFilter(var4_2)
	var3_2:RemoveBulletUnit(arg0_2:GetUniqueID())
end

function var1_0.onBulletHitFunc(arg0_4, arg1_4, arg2_4)
	return
end

function var1_0.CreateBulletAlert(arg0_5)
	return
end
