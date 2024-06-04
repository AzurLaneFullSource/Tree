ys = ys or {}

local var0 = ys

var0.Battle.BattleTriggerBulletFactory = singletonClass("BattleTriggerBulletFactory", var0.Battle.BattleBombBulletFactory)
var0.Battle.BattleTriggerBulletFactory.__name = "BattleTriggerBulletFactory"

local var1 = var0.Battle.BattleTriggerBulletFactory

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.OutRangeFunc(arg0)
	local var0 = arg0:GetTemplate()
	local var1 = var0.hit_type
	local var2 = var0.extra_param.multy or 1
	local var3 = var1.GetDataProxy()
	local var4 = arg0:GetDiveFilter()
	local var5

	local function var6(arg0)
		local var0 = var1.decay

		if var0 then
			var5:UpdateDistanceInfo()
		end

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var1 = iter1.UID
				local var2 = 0

				if var0 then
					var2 = var5:GetDistance(var1) / (var1.range * 0.5) * var0
				end

				local var3 = var1.GetSceneMediator():GetCharacter(var1):GetUnitData()
				local var4 = 0

				while var3:IsAlive() and var4 < var2 do
					var3:HandleDamage(arg0, var3, var2)

					var4 = var4 + 1
				end
			end
		end

		var0.Battle.PlayBattleSFX(arg0:GetHitSFX())
		var3:SpawnEffect(var0.hit_fx, arg0:GetExplodePostion())
	end

	var5 = var3:SpawnTriggerColumnArea(arg0:GetEffectField(), arg0:GetIFF(), arg0:GetExplodePostion(), var1.range, var1.time, false, var0.miss_fx, var6)

	var5:SetDiveFilter(var4)
	var3:RemoveBulletUnit(arg0:GetUniqueID())
end

function var1.onBulletHitFunc(arg0, arg1, arg2)
	return
end

function var1.CreateBulletAlert(arg0)
	return
end
