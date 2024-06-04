ys = ys or {}

local var0 = ys
local var1 = singletonClass("BattleSpaceLaserFactory", var0.Battle.BattleBulletFactory)

var1.__name = "BattleSpaceLaserFactory"
var0.Battle.BattleSpaceLaserFactory = var1

function var1.MakeBullet(arg0)
	return var0.Battle.BattleLaserArea.New()
end

function var1.MakeModel(arg0, arg1, arg2)
	local var0 = arg1:GetBulletData()
	local var1 = var0:GetTemplate()
	local var2 = arg0:GetDataProxy()
	local var3 = arg0:GetBulletPool():InstFX(arg1:GetModleID())

	if var3 then
		arg1:AddModel(var3)
	else
		arg1:AddTempModel(arg0:GetTempGOPool():GetObject())
	end

	var0.Battle.PlayBattleSFX(var0:GetHitSFX())

	local function var4(arg0, arg1, arg2)
		local var0 = arg0:GetBulletData()
		local var1 = var0:GetTemplate()
		local var2 = var0:GetDiveFilter()
		local var3, var4 = var0:GetCollidedList()

		if var0:IsAlert() then
			return
		end

		local var5 = var4[arg1] or 0

		if pg.TimeMgr.GetInstance():GetCombatTime() < var5 + var0:GetHitInterval() then
			return
		end

		local var6 = var1:GetSceneMediator():GetCharacter(arg1):GetUnitData()

		if var6:GetCldData().Active then
			local var7 = false
			local var8 = var6:GetCurrentOxyState()

			for iter0, iter1 in ipairs(var2) do
				if var8 == iter1 then
					var7 = true
				end
			end

			if not var7 then
				var2:HandleDamage(var0, var6)
			end
		end

		var4[arg1] = pg.TimeMgr.GetInstance():GetCombatTime()
	end

	local function var5(arg0)
		return
	end

	arg1:SetSpawn(arg2)
	arg1:SetFXFunc(var4, var5)
	arg0:GetSceneMediator():AddBullet(arg1)
end

function var1.OutRangeFunc(arg0)
	arg0:ExecuteLifeEndCallback()
	var1.GetDataProxy():RemoveBulletUnit(arg0:GetUniqueID())
end
