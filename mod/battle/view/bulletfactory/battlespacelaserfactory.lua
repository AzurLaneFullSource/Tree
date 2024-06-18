ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattleSpaceLaserFactory", var0_0.Battle.BattleBulletFactory)

var1_0.__name = "BattleSpaceLaserFactory"
var0_0.Battle.BattleSpaceLaserFactory = var1_0

function var1_0.MakeBullet(arg0_1)
	return var0_0.Battle.BattleLaserArea.New()
end

function var1_0.MakeModel(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2:GetBulletData()
	local var1_2 = var0_2:GetTemplate()
	local var2_2 = arg0_2:GetDataProxy()
	local var3_2 = arg0_2:GetBulletPool():InstFX(arg1_2:GetModleID())

	if var3_2 then
		arg1_2:AddModel(var3_2)
	else
		arg1_2:AddTempModel(arg0_2:GetTempGOPool():GetObject())
	end

	var0_0.Battle.PlayBattleSFX(var0_2:GetHitSFX())

	local function var4_2(arg0_3, arg1_3, arg2_3)
		local var0_3 = arg0_3:GetBulletData()
		local var1_3 = var0_3:GetTemplate()
		local var2_3 = var0_3:GetDiveFilter()
		local var3_3, var4_3 = var0_3:GetCollidedList()

		if var0_3:IsAlert() then
			return
		end

		local var5_3 = var4_3[arg1_3] or 0

		if pg.TimeMgr.GetInstance():GetCombatTime() < var5_3 + var0_3:GetHitInterval() then
			return
		end

		local var6_3 = var1_0:GetSceneMediator():GetCharacter(arg1_3):GetUnitData()

		if var6_3:GetCldData().Active then
			local var7_3 = false
			local var8_3 = var6_3:GetCurrentOxyState()

			for iter0_3, iter1_3 in ipairs(var2_3) do
				if var8_3 == iter1_3 then
					var7_3 = true
				end
			end

			if not var7_3 then
				var2_2:HandleDamage(var0_3, var6_3)
			end
		end

		var4_3[arg1_3] = pg.TimeMgr.GetInstance():GetCombatTime()
	end

	local function var5_2(arg0_4)
		return
	end

	arg1_2:SetSpawn(arg2_2)
	arg1_2:SetFXFunc(var4_2, var5_2)
	arg0_2:GetSceneMediator():AddBullet(arg1_2)
end

function var1_0.OutRangeFunc(arg0_5)
	arg0_5:ExecuteLifeEndCallback()
	var1_0.GetDataProxy():RemoveBulletUnit(arg0_5:GetUniqueID())
end
