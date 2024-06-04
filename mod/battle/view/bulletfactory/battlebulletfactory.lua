ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst

var0.Battle.BattleBulletFactory = singletonClass("BattleBulletFactory")
var0.Battle.BattleBulletFactory.__name = "BattleBulletFactory"

local var2 = var0.Battle.BattleBulletFactory

function var2.Ctor(arg0)
	return
end

function var2.RecyleTempModel(arg0, arg1)
	arg0._tempGOPool:Recycle(arg1)
end

function var2.Clear(arg0)
	if arg0._tempGOPool then
		arg0._tempGOPool:Dispose()

		arg0._tempGOPool = nil
	end
end

function var2.CreateBullet(arg0, arg1, arg2, arg3, arg4, arg5)
	arg2:SetOutRangeCallback(arg0.OutRangeFunc)

	local var0 = arg0:MakeBullet()

	var0:SetFactory(arg0)
	var0:SetBulletData(arg2)
	arg0:MakeModel(var0, arg3, arg4, arg5)

	if arg4 and arg4 ~= "" then
		arg0:PlayFireFX(arg1, arg2, arg3, arg4, arg5, nil)
	end

	return var0
end

function var2.GetSceneMediator(arg0)
	return var0.Battle.BattleState.GetInstance():GetSceneMediator()
end

function var2.GetDataProxy(arg0)
	return var0.Battle.BattleDataProxy.GetInstance()
end

function var2.GetFXPool(arg0)
	return var0.Battle.BattleFXPool.GetInstance()
end

function var2.GetBulletPool(arg0)
	return var0.Battle.BattleResourceManager.GetInstance()
end

function var2.OutRangeFunc(arg0)
	var2.GetDataProxy():RemoveBulletUnit(arg0:GetUniqueID())
end

function var2.GetTempGOPool(arg0)
	if arg0._tempGOPool == nil then
		local var0 = GameObject("temp_bullet_OBJ")

		SetActive(var0, false)

		local var1 = arg0:GetSceneMediator():GetBulletRoot().transform

		LuaHelper.SetGOParentTF(var0, var1, false)

		arg0._tempGOPool = pg.Pool.New(var1, var0, 1, 15, false, false):InitSize()
	end

	return arg0._tempGOPool
end

function var2.PlayFireFX(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = arg2:GetWeaponTempData().effect_move == 1

	if arg4 == "" or arg4 == nil then
		if arg6 then
			arg6()
		end
	else
		local var1
		local var2

		if var0 then
			var1, var2 = arg0:GetFXPool():GetFX(arg4, arg1)
		else
			var1, var2 = arg0:GetFXPool():GetFX(arg4)
			var2 = var2:Add(arg3)
		end

		if arg5 == var1.UnitDir.LEFT then
			local var3 = var1.transform
			local var4 = var3.localEulerAngles

			var4.y = 180
			var3.localEulerAngles = var4
		end

		pg.EffectMgr.GetInstance():PlayBattleEffect(var1, var2, true, arg6, true)
	end
end

function var2.MakeBullet(arg0)
	return nil
end

function var2.MakeModel(arg0, arg1, arg2)
	return nil
end

function var2.MakeBombPreCastAlter(arg0, arg1, arg2)
	return arg0:MakeModel(arg1, arg2)
end

function var2.MakeModelAfterBombPreCastAlert(arg0, arg1)
	return nil
end

function var2.MakeTrack(arg0, arg1, arg2, arg3)
	arg1:AddTrack(arg2)
	pg.EffectMgr.GetInstance():PlayBattleEffect(arg2, arg3, true)
end

function var2.RemoveBullet(arg0, arg1)
	arg1:Dispose()
end

function var2.GetFactoryList()
	if var2._factoryList == nil then
		var2._factoryList = {
			[var1.BulletType.CANNON] = var0.Battle.BattleCannonBulletFactory.GetInstance(),
			[var1.BulletType.BOMB] = var0.Battle.BattleBombBulletFactory.GetInstance(),
			[var1.BulletType.TORPEDO] = var0.Battle.BattleTorpedoBulletFactory.GetInstance(),
			[var1.BulletType.DIRECT] = var0.Battle.BattleDirectBulletFactory.GetInstance(),
			[var1.BulletType.SHRAPNEL] = var0.Battle.BattleShrapnelBulletFactory.GetInstance(),
			[var1.BulletType.ANTI_AIR] = var0.Battle.BattleAntiAirBulletFactory.GetInstance(),
			[var1.BulletType.ANTI_SEA] = var0.Battle.BattleAntiSeaBulletFactory.GetInstance(),
			[var1.BulletType.STRAY] = var0.Battle.BattleStrayBulletFactory.GetInstance(),
			[var1.BulletType.EFFECT] = var0.Battle.BattleEffectBulletFactory.GetInstance(),
			[var1.BulletType.BEAM] = var0.Battle.BattleBeamBulletFactory.GetInstance(),
			[var1.BulletType.G_BULLET] = var0.Battle.BattleGravitationBulletFactory.GetInstance(),
			[var1.BulletType.ELECTRIC_ARC] = var0.Battle.BattleElectricArcBulletFactory.GetInstance(),
			[var1.BulletType.SPACE_LASER] = var0.Battle.BattleSpaceLaserFactory.GetInstance(),
			[var1.BulletType.MISSILE] = var0.Battle.BattleMissileFactory.GetInstance(),
			[var1.BulletType.SCALE] = var0.Battle.BattleScaleBulletFactory.GetInstance(),
			[var1.BulletType.TRIGGER_BOMB] = var0.Battle.BattleTriggerBulletFactory.GetInstance(),
			[var1.BulletType.AAMissile] = var0.Battle.BattleAAMissileFactory.GetInstance()
		}
	end

	return var2._factoryList
end

function var2.DestroyFactory()
	var2._factoryList = nil
end

function var2.NeutralizeBullet()
	var0.Battle.BattleAntiAirBulletFactory.GetInstance():NeutralizeBullet()
	var0.Battle.BattleAntiSeaBulletFactory.GetInstance():NeutralizeBullet()
end

function var2.GetRandomBone(arg0)
	return arg0[math.floor(math.Random(0, #arg0)) + 1]
end
