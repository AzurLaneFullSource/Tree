ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = pg.bullet_template
local var3_0 = pg.barrage_template

var0_0.Battle.BattleDataFunction = var0_0.Battle.BattleDataFunction or {}

local var4_0 = var0_0.Battle.BattleDataFunction
local var5_0 = var1_0.UnitDir.LEFT
local var6_0 = var1_0.UnitDir.RIGHT

function var4_0.CreateBattleBulletData(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	local var0_1 = var4_0.GetBulletTmpDataFromID(arg1_1)
	local var1_1 = var0_1.type
	local var2_1, var3_1 = var4_0.generateBulletFuncs[var1_1](arg0_1, var0_1, arg2_1, arg3_1, arg4_1)

	var2_1:SetTemplateData(var0_1)
	var2_1:SetAttr(arg2_1._attr)
	var2_1:SetBuffTrigger(arg2_1)
	var2_1:SetWeapon(arg3_1)

	if arg3_1 and arg3_1:GetStandHost() then
		local var4_1 = arg3_1:GetStandHost():GetAttr()

		var2_1:SetStandHostAttr(var4_1)
	end

	local var5_1 = var2_1:IsIngoreCld()

	if var5_1 ~= nil then
		local var6_1 = not var5_1

		var2_1:SetIsCld(var6_1)

		var3_1 = var6_1
	end

	return var2_1, var3_1
end

function var4_0.GetBulletTmpDataFromID(arg0_2)
	assert(var2_0[arg0_2] ~= nil, "找不到子弹配置：id = " .. arg0_2)

	return var2_0[arg0_2]
end

function var4_0.GetBarrageTmpDataFromID(arg0_3)
	assert(var3_0[arg0_3] ~= nil, "找不到弹幕配置：id = " .. arg0_3)

	return var3_0[arg0_3]
end

function var4_0.GetConvertedBarrageTableFromID(arg0_4, arg1_4)
	assert(var3_0[arg0_4] ~= nil, "获取转换弹幕数据失败，找不到弹幕原型配置：id = " .. arg0_4)

	if var4_0.ConvertedBarrageTableList[arg0_4] == nil or var4_0.ConvertedBarrageTableList[arg0_4][arg1_4] == nil then
		var4_0.ConvertSpecificBarrage(arg0_4, arg1_4)
	end

	return var4_0.ConvertedBarrageTableList[arg0_4]
end

function var4_0.GenerateTransBarrage(arg0_5, arg1_5, arg2_5)
	local var0_5 = {}
	local var1_5 = var4_0.GetBarrageTmpDataFromID(arg0_5)

	while var1_5.trans_ID ~= -1 do
		local var2_5 = var1_5.trans_ID

		var1_5 = var4_0.GetBarrageTmpDataFromID(var2_5)

		local var3_5 = {
			transStartDelay = var1_5.first_delay + var1_5.delay * arg2_5 + var1_5.delta_delay * arg2_5
		}

		if var1_5.offset_prioritise then
			var3_5.transAimPosX = var1_5.offset_x + var1_5.delta_offset_x * arg2_5
			var3_5.transAimPosZ = var1_5.offset_z + var1_5.delta_offset_z * arg2_5
		else
			var3_5.transAimAngle = var1_5.angle + var1_5.delta_angle * arg2_5

			if arg1_5 == -1 then
				var3_5.transAimAngle = var3_5.transAimAngle + 180
			end
		end

		var0_5[#var0_5 + 1] = var3_5
	end

	return var0_5
end

function var4_0._createCannonBullet(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6 = var0_0.Battle.BattleCannonBulletUnit.New(arg0_6, arg2_6:GetIFF())

	var0_6:SetIsCld(true)

	return var0_6, true
end

function var4_0._createBombBullet(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = var0_0.Battle.BattleBombBulletUnit.New(arg0_7, arg2_7:GetIFF())

	var0_7:SetAttr(arg2_7._attr)
	var0_7:SetTemplateData(arg1_7)

	if arg4_7:EqualZero() then
		arg4_7 = arg2_7:GetPosition():Clone()

		local var1_7 = arg3_7:GetTemplateData().range

		if arg2_7:GetDirection() == var1_0.UnitDir.RIGHT then
			arg4_7.x = arg4_7.x + var1_7
		else
			arg4_7.x = arg4_7.x - var1_7
		end
	end

	var0_7:SetExplodePosition(arg4_7)
	var0_7:SetIsCld(false)

	return var0_7, false
end

function var4_0._createStrayBullet(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	local var0_8 = var0_0.Battle.BattleStrayBulletUnit.New(arg0_8, arg2_8:GetIFF())

	var0_8:SetIsCld(true)

	return var0_8, true
end

function var4_0._createTorpedoBullet(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = var0_0.Battle.BattleTorpedoBulletUnit.New(arg0_9, arg2_9:GetIFF())

	var0_9:SetExplodePosition(arg4_9)
	var0_9:SetIsCld(true)

	return var0_9, true
end

function var4_0._createDirectBullet(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	local var0_10 = var0_0.Battle.BattleAntiAirBulletUnit.New(arg0_10, arg2_10:GetIFF())

	var0_10:SetIsCld(false)

	return var0_10, false
end

function var4_0._createAntiAirBullet(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = var0_0.Battle.BattleAntiAirBulletUnit.New(arg0_11, arg2_11:GetIFF())

	var0_11:SetIsCld(false)

	return var0_11, false
end

function var4_0._createAntiSeaBullet(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	local var0_12 = var0_0.Battle.BattleAntiSeaBulletUnit.New(arg0_12, arg2_12:GetIFF())

	var0_12:SetIsCld(false)

	return var0_12, false
end

function var4_0._createSharpnelBullet(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = var0_0.Battle.BattleShrapnelBulletUnit.New(arg0_13, arg2_13:GetIFF())

	var0_13:SetExplodePosition(arg4_13)
	var0_13:SetSrcHost(arg2_13)
	var0_13:SetIsCld(true)

	return var0_13, true
end

function var4_0._createEffectBullet(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	local var0_14 = var0_0.Battle.BattleEffectBulletUnit.New(arg0_14, arg2_14:GetIFF())

	var0_14:SetTemplateData(arg1_14)
	var0_14:SetIsCld(false)
	var0_14:SetImmuneCLS(true)

	if arg1_14.attach_buff[1].flare then
		var0_14:spawnArea(true)
	end

	return var0_14, false
end

function var4_0._createBeamBullet(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = var0_0.Battle.BattleAntiAirBulletUnit.New(arg0_15, arg2_15:GetIFF())

	var0_15:SetIsCld(false)

	return var0_15, false
end

function var4_0._createGravitationBullet(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	local var0_16 = var0_0.Battle.BattleGravitationBulletUnit.New(arg0_16, arg2_16:GetIFF())

	var0_16:SetExplodePosition(arg4_16)
	var0_16:SetIsCld(true)
	var0_16:SetImmuneCLS(true)

	return var0_16, true
end

function var4_0._createMissile(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	local var0_17 = var0_0.Battle.BattleMissileUnit.New(arg0_17, arg2_17:GetIFF())

	var0_17:SetAttr(arg2_17._attr)
	var0_17:SetTemplateData(arg1_17)
	var0_17:SetImmuneCLS(true)
	var0_17:SetIsCld(false)

	return var0_17, false
end

function var4_0._createSpaceLaser(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	local var0_18 = var0_0.Battle.BattleSpaceLaserUnit.New(arg0_18, arg2_18:GetIFF())

	var0_18:SetIsCld(true)
	var0_18:SetImmuneCLS(true)

	return var0_18, true
end

function var4_0._createScaleBullet(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19 = var0_0.Battle.BattleScaleBulletUnit.New(arg0_19, arg2_19:GetIFF())

	var0_19:SetIsCld(true)

	return var0_19, true
end

function var4_0._createAAMissile(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	local var0_20 = var0_0.Battle.BattleTrackingAAMissileUnit.New(arg0_20, arg2_20:GetIFF())

	var0_20:SetIsCld(true)

	return var0_20, true
end

var4_0.generateBulletFuncs = {}
var4_0.generateBulletFuncs[var1_0.BulletType.CANNON] = var4_0._createCannonBullet
var4_0.generateBulletFuncs[var1_0.BulletType.BOMB] = var4_0._createBombBullet
var4_0.generateBulletFuncs[var1_0.BulletType.TORPEDO] = var4_0._createTorpedoBullet
var4_0.generateBulletFuncs[var1_0.BulletType.DIRECT] = var4_0._createDirectBullet
var4_0.generateBulletFuncs[var1_0.BulletType.ANTI_AIR] = var4_0._createAntiAirBullet
var4_0.generateBulletFuncs[var1_0.BulletType.ANTI_SEA] = var4_0._createAntiSeaBullet
var4_0.generateBulletFuncs[var1_0.BulletType.SHRAPNEL] = var4_0._createSharpnelBullet
var4_0.generateBulletFuncs[var1_0.BulletType.STRAY] = var4_0._createStrayBullet
var4_0.generateBulletFuncs[var1_0.BulletType.EFFECT] = var4_0._createEffectBullet
var4_0.generateBulletFuncs[var1_0.BulletType.BEAM] = var4_0._createBeamBullet
var4_0.generateBulletFuncs[var1_0.BulletType.G_BULLET] = var4_0._createGravitationBullet
var4_0.generateBulletFuncs[var1_0.BulletType.ELECTRIC_ARC] = var4_0._createDirectBullet
var4_0.generateBulletFuncs[var1_0.BulletType.MISSILE] = var4_0._createMissile
var4_0.generateBulletFuncs[var1_0.BulletType.SPACE_LASER] = var4_0._createSpaceLaser
var4_0.generateBulletFuncs[var1_0.BulletType.SCALE] = var4_0._createScaleBullet
var4_0.generateBulletFuncs[var1_0.BulletType.TRIGGER_BOMB] = var4_0._createBombBullet
var4_0.generateBulletFuncs[var1_0.BulletType.AAMissile] = var4_0._createAAMissile

function var4_0.ConvertSpecificBarrage(arg0_21, arg1_21)
	local var0_21

	var0_21[arg1_21], var0_21 = var4_0.barrageInteration(pg.barrage_template[arg0_21], arg1_21), var4_0.ConvertedBarrageTableList[arg0_21] or {}
	var4_0.ConvertedBarrageTableList[arg0_21] = var0_21
end

function var4_0.ClearConvertedBarrage()
	var4_0.ConvertedBarrageTableList = {}
end

function var4_0.barrageInteration(arg0_23, arg1_23)
	local var0_23 = 1
	local var1_23 = arg0_23.primal_repeat
	local var2_23 = {}
	local var3_23 = arg0_23.offset_x
	local var4_23 = arg0_23.offset_z
	local var5_23 = arg0_23.angle
	local var6_23 = arg0_23.delay
	local var7_23 = arg0_23.delta_offset_x
	local var8_23 = arg0_23.delta_offset_z
	local var9_23 = arg0_23.delta_angle
	local var10_23 = arg0_23.delta_delay

	for iter0_23 = 0, var1_23 do
		local var11_23 = {
			OffsetX = var3_23 * arg1_23,
			OffsetZ = var4_23,
			Angle = var5_23,
			Delay = var6_23
		}

		table.insert(var2_23, var11_23)

		var3_23 = var3_23 + var7_23
		var4_23 = var4_23 + var8_23
		var5_23 = var5_23 + var9_23
		var6_23 = var6_23 + var10_23
	end

	return var2_23
end

var4_0.ClearConvertedBarrage()
