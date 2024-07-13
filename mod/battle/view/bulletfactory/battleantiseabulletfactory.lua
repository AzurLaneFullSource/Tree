ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleAntiSeaBulletFactory = singletonClass("BattleAntiSeaBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleAntiSeaBulletFactory.__name = "BattleAntiSeaBulletFactory"

local var1_0 = var0_0.Battle.BattleAntiSeaBulletFactory

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1._tmpTimerList = {}
end

function var1_0.NeutralizeBullet(arg0_2)
	for iter0_2, iter1_2 in pairs(arg0_2._tmpTimerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter1_2)

		arg0_2._tmpTimerList[iter1_2] = nil
	end
end

function var1_0.CreateBullet(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	local var0_3 = arg2_3:GetTemplate().hit_type
	local var1_3 = arg0_3:GetDataProxy()
	local var2_3 = arg2_3:GetDirectHitUnit()

	if not var2_3 then
		var1_3:RemoveBulletUnit(arg2_3:GetUniqueID())

		return
	end

	local var3_3 = var2_3:GetUniqueID()
	local var4_3 = arg0_3:GetSceneMediator():GetCharacter(var3_3)

	if not var4_3 then
		var1_3:RemoveBulletUnit(arg2_3:GetUniqueID())

		return
	end

	local var5_3 = var0_3.range
	local var6_3
	local var7_3
	local var8_3

	local function var9_3()
		if var6_3 then
			local var0_4
			local var1_4 = var4_3:GetPosition():Clone()

			if var2_3:IsAlive() and var4_3 then
				var0_4 = var1_4:Add(Vector3(math.random(var5_3) - var5_3 * 0.5, 0, math.random(var5_3) - var5_3 * 0.5))
			else
				var0_4 = var1_4
			end

			local var2_4, var3_4 = arg0_3:GetFXPool():GetFX(arg2_3:GetTemplate().hit_fx)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var2_4, var3_4:Add(var0_4), true)
		end
	end

	local function var10_3()
		if var2_3:IsAlive() then
			var1_3:HandleDamage(arg2_3, var2_3)
			var1_3:RemoveBulletUnit(arg2_3:GetUniqueID())
		end

		pg.TimeMgr.GetInstance():RemoveBattleTimer(var6_3)

		arg0_3._tmpTimerList[var6_3] = nil
		var6_3 = nil
	end

	var6_3 = pg.TimeMgr.GetInstance():AddBattleTimer("antiAirTimer", 0, 0.5, var10_3, true)
	arg0_3._tmpTimerList[var6_3] = var6_3

	if arg4_3 ~= nil then
		arg0_3:PlayFireFX(arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, nil)

		local var11_3 = pg.TimeMgr.GetInstance():AddBattleTimer("showHitFXTimer", -1, 0.1, var9_3, true)

		arg0_3._tmpTimerList[var11_3] = var11_3

		var9_3()
	else
		var1_3:HandleDamage(arg2_3, var2_3)
		var1_3:RemoveBulletUnit(arg2_3:GetUniqueID())
	end
end
