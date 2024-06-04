ys = ys or {}

local var0 = ys

var0.Battle.BattleAntiSeaBulletFactory = singletonClass("BattleAntiSeaBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleAntiSeaBulletFactory.__name = "BattleAntiSeaBulletFactory"

local var1 = var0.Battle.BattleAntiSeaBulletFactory

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
	local var4 = arg0:GetSceneMediator():GetCharacter(var3)

	if not var4 then
		var1:RemoveBulletUnit(arg2:GetUniqueID())

		return
	end

	local var5 = var0.range
	local var6
	local var7
	local var8

	local function var9()
		if var6 then
			local var0
			local var1 = var4:GetPosition():Clone()

			if var2:IsAlive() and var4 then
				var0 = var1:Add(Vector3(math.random(var5) - var5 * 0.5, 0, math.random(var5) - var5 * 0.5))
			else
				var0 = var1
			end

			local var2, var3 = arg0:GetFXPool():GetFX(arg2:GetTemplate().hit_fx)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var2, var3:Add(var0), true)
		end
	end

	local function var10()
		if var2:IsAlive() then
			var1:HandleDamage(arg2, var2)
			var1:RemoveBulletUnit(arg2:GetUniqueID())
		end

		pg.TimeMgr.GetInstance():RemoveBattleTimer(var6)

		arg0._tmpTimerList[var6] = nil
		var6 = nil
	end

	var6 = pg.TimeMgr.GetInstance():AddBattleTimer("antiAirTimer", 0, 0.5, var10, true)
	arg0._tmpTimerList[var6] = var6

	if arg4 ~= nil then
		arg0:PlayFireFX(arg1, arg2, arg3, arg4, arg5, nil)

		local var11 = pg.TimeMgr.GetInstance():AddBattleTimer("showHitFXTimer", -1, 0.1, var9, true)

		arg0._tmpTimerList[var11] = var11

		var9()
	else
		var1:HandleDamage(arg2, var2)
		var1:RemoveBulletUnit(arg2:GetUniqueID())
	end
end
