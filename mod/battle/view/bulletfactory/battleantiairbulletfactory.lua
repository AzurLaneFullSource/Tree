ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleAntiAirBulletFactory = singletonClass("BattleAntiAirBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleAntiAirBulletFactory.__name = "BattleAntiAirBulletFactory"

local var1_0 = var0_0.Battle.BattleAntiAirBulletFactory

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
	local var4_3 = arg0_3:GetSceneMediator():GetAircraft(var3_3)

	if var4_3 == nil then
		var1_3:RemoveBulletUnit(arg2_3:GetUniqueID())

		return
	end

	local var5_3 = var4_3:GetPosition():Clone()
	local var6_3 = var0_3.range

	local function var7_3(arg0_4)
		local var0_4 = {}

		for iter0_4, iter1_4 in ipairs(arg0_4) do
			if iter1_4.Active then
				local var1_4 = arg0_3:GetSceneMediator():GetAircraft(iter1_4.UID)

				if var1_4 then
					local var2_4 = var1_4:GetUnitData()

					if var2_4:IsVisitable() then
						var0_4[#var0_4 + 1] = var2_4
					end
				end
			end
		end

		var1_3:HandleMeteoDamage(arg2_3, var0_4)
	end

	local function var8_3()
		var1_3:SpawnColumnArea(arg2_3:GetEffectField(), arg2_3:GetIFF(), var5_3, var6_3, var0_3.time, var7_3)
		var1_3:RemoveBulletUnit(arg2_3:GetUniqueID())
	end

	local function var9_3()
		local var0_6

		if var2_3:IsAlive() and var4_3 then
			var0_6 = var4_3:GetPosition():Clone():Add(Vector3(math.random(var6_3) - var6_3 * 0.5, 0, math.random(var6_3) - var6_3 * 0.5))
			var5_3 = var0_6
		else
			var0_6 = var5_3
		end

		local var1_6, var2_6 = arg0_3:GetFXPool():GetFX(arg2_3:GetTemplate().hit_fx)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var1_6, var2_6:Add(var0_6), true)
	end

	local var10_3
	local var11_3

	local function var12_3()
		if arg4_3 == nil then
			var8_3()
		else
			arg0_3:PlayFireFX(arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, var11_3)
		end
	end

	function var11_3()
		if arg0_3._tmpTimerList[var10_3] ~= nil then
			var12_3()
			var9_3()
		else
			var8_3()
		end
	end

	local function var13_3()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var10_3)

		arg0_3._tmpTimerList[var10_3] = nil
		var10_3 = nil
	end

	var10_3 = pg.TimeMgr.GetInstance():AddBattleTimer("antiAirTimer", -1, 0.5, var13_3, true)
	arg0_3._tmpTimerList[var10_3] = var10_3

	var12_3()
end
