ys = ys or {}

local var0 = ys

var0.Battle.BattleAntiAirBulletFactory = singletonClass("BattleAntiAirBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleAntiAirBulletFactory.__name = "BattleAntiAirBulletFactory"

local var1 = var0.Battle.BattleAntiAirBulletFactory

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0._tmpTimerList = {}
end

function var1.NeutralizeBullet(arg0)
	for iter0, iter1 in pairs(arg0._tmpTimerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter1)

		arg0._tmpTimerList[iter1] = nil
	end
end

function var1.CreateBullet(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg2:GetTemplate().hit_type
	local var1 = arg0:GetDataProxy()
	local var2 = arg2:GetDirectHitUnit()

	if not var2 then
		var1:RemoveBulletUnit(arg2:GetUniqueID())

		return
	end

	local var3 = var2:GetUniqueID()
	local var4 = arg0:GetSceneMediator():GetAircraft(var3)

	if var4 == nil then
		var1:RemoveBulletUnit(arg2:GetUniqueID())

		return
	end

	local var5 = var4:GetPosition():Clone()
	local var6 = var0.range

	local function var7(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var1 = arg0:GetSceneMediator():GetAircraft(iter1.UID)

				if var1 then
					local var2 = var1:GetUnitData()

					if var2:IsVisitable() then
						var0[#var0 + 1] = var2
					end
				end
			end
		end

		var1:HandleMeteoDamage(arg2, var0)
	end

	local function var8()
		var1:SpawnColumnArea(arg2:GetEffectField(), arg2:GetIFF(), var5, var6, var0.time, var7)
		var1:RemoveBulletUnit(arg2:GetUniqueID())
	end

	local function var9()
		local var0

		if var2:IsAlive() and var4 then
			var0 = var4:GetPosition():Clone():Add(Vector3(math.random(var6) - var6 * 0.5, 0, math.random(var6) - var6 * 0.5))
			var5 = var0
		else
			var0 = var5
		end

		local var1, var2 = arg0:GetFXPool():GetFX(arg2:GetTemplate().hit_fx)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var1, var2:Add(var0), true)
	end

	local var10
	local var11

	local function var12()
		if arg4 == nil then
			var8()
		else
			arg0:PlayFireFX(arg1, arg2, arg3, arg4, arg5, var11)
		end
	end

	function var11()
		if arg0._tmpTimerList[var10] ~= nil then
			var12()
			var9()
		else
			var8()
		end
	end

	local function var13()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var10)

		arg0._tmpTimerList[var10] = nil
		var10 = nil
	end

	var10 = pg.TimeMgr.GetInstance():AddBattleTimer("antiAirTimer", -1, 0.5, var13, true)
	arg0._tmpTimerList[var10] = var10

	var12()
end
