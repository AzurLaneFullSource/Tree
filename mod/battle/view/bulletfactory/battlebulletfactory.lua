ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleBulletFactory = singletonClass("BattleBulletFactory")
var0_0.Battle.BattleBulletFactory.__name = "BattleBulletFactory"

local var2_0 = var0_0.Battle.BattleBulletFactory

function var2_0.Ctor(arg0_1)
	return
end

function var2_0.RecyleTempModel(arg0_2, arg1_2)
	arg0_2._tempGOPool:Recycle(arg1_2)
end

function var2_0.Clear(arg0_3)
	if arg0_3._tempGOPool then
		arg0_3._tempGOPool:Dispose()

		arg0_3._tempGOPool = nil
	end
end

function var2_0.CreateBullet(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	arg2_4:SetOutRangeCallback(arg0_4.OutRangeFunc)

	local var0_4 = arg0_4:MakeBullet()

	var0_4:SetFactory(arg0_4)
	var0_4:SetBulletData(arg2_4)
	arg0_4:MakeModel(var0_4, arg3_4, arg4_4, arg5_4)

	if arg4_4 and arg4_4 ~= "" then
		arg0_4:PlayFireFX(arg1_4, arg2_4, arg3_4, arg4_4, arg5_4, nil)
	end

	return var0_4
end

function var2_0.GetSceneMediator(arg0_5)
	return var0_0.Battle.BattleState.GetInstance():GetSceneMediator()
end

function var2_0.GetDataProxy(arg0_6)
	return var0_0.Battle.BattleDataProxy.GetInstance()
end

function var2_0.GetFXPool(arg0_7)
	return var0_0.Battle.BattleFXPool.GetInstance()
end

function var2_0.GetBulletPool(arg0_8)
	return var0_0.Battle.BattleResourceManager.GetInstance()
end

function var2_0.OutRangeFunc(arg0_9)
	var2_0.GetDataProxy():RemoveBulletUnit(arg0_9:GetUniqueID())
end

function var2_0.GetTempGOPool(arg0_10)
	if arg0_10._tempGOPool == nil then
		local var0_10 = GameObject("temp_bullet_OBJ")

		SetActive(var0_10, false)

		local var1_10 = arg0_10:GetSceneMediator():GetBulletRoot().transform

		LuaHelper.SetGOParentTF(var0_10, var1_10, false)

		arg0_10._tempGOPool = pg.Pool.New(var1_10, var0_10, 1, 15, false, false):InitSize()
	end

	return arg0_10._tempGOPool
end

function var2_0.PlayFireFX(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11, arg6_11)
	local var0_11 = arg2_11:GetWeaponTempData().effect_move == 1

	if arg4_11 == "" or arg4_11 == nil then
		if arg6_11 then
			arg6_11()
		end
	else
		local var1_11
		local var2_11

		if var0_11 then
			var1_11, var2_11 = arg0_11:GetFXPool():GetFX(arg4_11, arg1_11)
		else
			var1_11, var2_11 = arg0_11:GetFXPool():GetFX(arg4_11)
			var2_11 = var2_11:Add(arg3_11)
		end

		if arg5_11 == var1_0.UnitDir.LEFT then
			local var3_11 = var1_11.transform
			local var4_11 = var3_11.localEulerAngles

			var4_11.y = 180
			var3_11.localEulerAngles = var4_11
		end

		pg.EffectMgr.GetInstance():PlayBattleEffect(var1_11, var2_11, true, arg6_11, true)
	end
end

function var2_0.MakeBullet(arg0_12)
	return nil
end

function var2_0.MakeModel(arg0_13, arg1_13, arg2_13)
	return nil
end

function var2_0.MakeBombPreCastAlter(arg0_14, arg1_14, arg2_14)
	return arg0_14:MakeModel(arg1_14, arg2_14)
end

function var2_0.MakeModelAfterBombPreCastAlert(arg0_15, arg1_15)
	return nil
end

function var2_0.MakeTrack(arg0_16, arg1_16, arg2_16, arg3_16)
	arg1_16:AddTrack(arg2_16)
	pg.EffectMgr.GetInstance():PlayBattleEffect(arg2_16, arg3_16, true)
end

function var2_0.RemoveBullet(arg0_17, arg1_17)
	arg1_17:Dispose()
end

function var2_0.GetFactoryList()
	if var2_0._factoryList == nil then
		var2_0._factoryList = {
			[var1_0.BulletType.CANNON] = var0_0.Battle.BattleCannonBulletFactory.GetInstance(),
			[var1_0.BulletType.BOMB] = var0_0.Battle.BattleBombBulletFactory.GetInstance(),
			[var1_0.BulletType.TORPEDO] = var0_0.Battle.BattleTorpedoBulletFactory.GetInstance(),
			[var1_0.BulletType.DIRECT] = var0_0.Battle.BattleDirectBulletFactory.GetInstance(),
			[var1_0.BulletType.SHRAPNEL] = var0_0.Battle.BattleShrapnelBulletFactory.GetInstance(),
			[var1_0.BulletType.ANTI_AIR] = var0_0.Battle.BattleAntiAirBulletFactory.GetInstance(),
			[var1_0.BulletType.ANTI_SEA] = var0_0.Battle.BattleAntiSeaBulletFactory.GetInstance(),
			[var1_0.BulletType.STRAY] = var0_0.Battle.BattleStrayBulletFactory.GetInstance(),
			[var1_0.BulletType.EFFECT] = var0_0.Battle.BattleEffectBulletFactory.GetInstance(),
			[var1_0.BulletType.BEAM] = var0_0.Battle.BattleBeamBulletFactory.GetInstance(),
			[var1_0.BulletType.G_BULLET] = var0_0.Battle.BattleGravitationBulletFactory.GetInstance(),
			[var1_0.BulletType.ELECTRIC_ARC] = var0_0.Battle.BattleElectricArcBulletFactory.GetInstance(),
			[var1_0.BulletType.SPACE_LASER] = var0_0.Battle.BattleSpaceLaserFactory.GetInstance(),
			[var1_0.BulletType.MISSILE] = var0_0.Battle.BattleMissileFactory.GetInstance(),
			[var1_0.BulletType.SCALE] = var0_0.Battle.BattleScaleBulletFactory.GetInstance(),
			[var1_0.BulletType.TRIGGER_BOMB] = var0_0.Battle.BattleTriggerBulletFactory.GetInstance(),
			[var1_0.BulletType.AAMissile] = var0_0.Battle.BattleAAMissileFactory.GetInstance()
		}
	end

	return var2_0._factoryList
end

function var2_0.DestroyFactory()
	var2_0._factoryList = nil
end

function var2_0.NeutralizeBullet()
	var0_0.Battle.BattleAntiAirBulletFactory.GetInstance():NeutralizeBullet()
	var0_0.Battle.BattleAntiSeaBulletFactory.GetInstance():NeutralizeBullet()
end

function var2_0.GetRandomBone(arg0_21)
	return arg0_21[math.floor(math.Random(0, #arg0_21)) + 1]
end
