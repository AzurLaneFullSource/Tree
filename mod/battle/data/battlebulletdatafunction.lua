ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = pg.bullet_template
local var3 = pg.barrage_template

var0.Battle.BattleDataFunction = var0.Battle.BattleDataFunction or {}

local var4 = var0.Battle.BattleDataFunction
local var5 = var1.UnitDir.LEFT
local var6 = var1.UnitDir.RIGHT

function var4.CreateBattleBulletData(arg0, arg1, arg2, arg3, arg4)
	local var0 = var4.GetBulletTmpDataFromID(arg1)
	local var1 = var0.type
	local var2, var3 = var4.generateBulletFuncs[var1](arg0, var0, arg2, arg3, arg4)

	var2:SetTemplateData(var0)
	var2:SetAttr(arg2._attr)
	var2:SetBuffTrigger(arg2)
	var2:SetWeapon(arg3)

	if arg3 and arg3:GetStandHost() then
		local var4 = arg3:GetStandHost():GetAttr()

		var2:SetStandHostAttr(var4)
	end

	local var5 = var2:IsIngoreCld()

	if var5 ~= nil then
		local var6 = not var5

		var2:SetIsCld(var6)

		var3 = var6
	end

	return var2, var3
end

function var4.GetBulletTmpDataFromID(arg0)
	assert(var2[arg0] ~= nil, "找不到子弹配置：id = " .. arg0)

	return var2[arg0]
end

function var4.GetBarrageTmpDataFromID(arg0)
	assert(var3[arg0] ~= nil, "找不到弹幕配置：id = " .. arg0)

	return var3[arg0]
end

function var4.GetConvertedBarrageTableFromID(arg0, arg1)
	assert(var3[arg0] ~= nil, "获取转换弹幕数据失败，找不到弹幕原型配置：id = " .. arg0)

	if var4.ConvertedBarrageTableList[arg0] == nil or var4.ConvertedBarrageTableList[arg0][arg1] == nil then
		var4.ConvertSpecificBarrage(arg0, arg1)
	end

	return var4.ConvertedBarrageTableList[arg0]
end

function var4.GenerateTransBarrage(arg0, arg1, arg2)
	local var0 = {}
	local var1 = var4.GetBarrageTmpDataFromID(arg0)

	while var1.trans_ID ~= -1 do
		local var2 = var1.trans_ID

		var1 = var4.GetBarrageTmpDataFromID(var2)

		local var3 = {
			transStartDelay = var1.first_delay + var1.delay * arg2 + var1.delta_delay * arg2
		}

		if var1.offset_prioritise then
			var3.transAimPosX = var1.offset_x + var1.delta_offset_x * arg2
			var3.transAimPosZ = var1.offset_z + var1.delta_offset_z * arg2
		else
			var3.transAimAngle = var1.angle + var1.delta_angle * arg2

			if arg1 == -1 then
				var3.transAimAngle = var3.transAimAngle + 180
			end
		end

		var0[#var0 + 1] = var3
	end

	return var0
end

function var4._createCannonBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleCannonBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(true)

	return var0, true
end

function var4._createBombBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleBombBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetAttr(arg2._attr)
	var0:SetTemplateData(arg1)

	if arg4:EqualZero() then
		arg4 = arg2:GetPosition():Clone()

		local var1 = arg3:GetTemplateData().range

		if arg2:GetDirection() == var1.UnitDir.RIGHT then
			arg4.x = arg4.x + var1
		else
			arg4.x = arg4.x - var1
		end
	end

	var0:SetExplodePosition(arg4)
	var0:SetIsCld(false)

	return var0, false
end

function var4._createStrayBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleStrayBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(true)

	return var0, true
end

function var4._createTorpedoBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleTorpedoBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetExplodePosition(arg4)
	var0:SetIsCld(true)

	return var0, true
end

function var4._createDirectBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleAntiAirBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(false)

	return var0, false
end

function var4._createAntiAirBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleAntiAirBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(false)

	return var0, false
end

function var4._createAntiSeaBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleAntiSeaBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(false)

	return var0, false
end

function var4._createSharpnelBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleShrapnelBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetExplodePosition(arg4)
	var0:SetSrcHost(arg2)
	var0:SetIsCld(true)

	return var0, true
end

function var4._createEffectBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleEffectBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetTemplateData(arg1)
	var0:SetIsCld(false)
	var0:SetImmuneCLS(true)

	if arg1.attach_buff[1].flare then
		var0:spawnArea(true)
	end

	return var0, false
end

function var4._createBeamBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleAntiAirBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(false)

	return var0, false
end

function var4._createGravitationBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleGravitationBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetExplodePosition(arg4)
	var0:SetIsCld(true)
	var0:SetImmuneCLS(true)

	return var0, true
end

function var4._createMissile(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleMissileUnit.New(arg0, arg2:GetIFF())

	var0:SetAttr(arg2._attr)
	var0:SetTemplateData(arg1)
	var0:SetImmuneCLS(true)
	var0:SetIsCld(false)

	return var0, false
end

function var4._createSpaceLaser(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleSpaceLaserUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(true)
	var0:SetImmuneCLS(true)

	return var0, true
end

function var4._createScaleBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleScaleBulletUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(true)

	return var0, true
end

function var4._createAAMissile(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.Battle.BattleTrackingAAMissileUnit.New(arg0, arg2:GetIFF())

	var0:SetIsCld(true)

	return var0, true
end

var4.generateBulletFuncs = {}
var4.generateBulletFuncs[var1.BulletType.CANNON] = var4._createCannonBullet
var4.generateBulletFuncs[var1.BulletType.BOMB] = var4._createBombBullet
var4.generateBulletFuncs[var1.BulletType.TORPEDO] = var4._createTorpedoBullet
var4.generateBulletFuncs[var1.BulletType.DIRECT] = var4._createDirectBullet
var4.generateBulletFuncs[var1.BulletType.ANTI_AIR] = var4._createAntiAirBullet
var4.generateBulletFuncs[var1.BulletType.ANTI_SEA] = var4._createAntiSeaBullet
var4.generateBulletFuncs[var1.BulletType.SHRAPNEL] = var4._createSharpnelBullet
var4.generateBulletFuncs[var1.BulletType.STRAY] = var4._createStrayBullet
var4.generateBulletFuncs[var1.BulletType.EFFECT] = var4._createEffectBullet
var4.generateBulletFuncs[var1.BulletType.BEAM] = var4._createBeamBullet
var4.generateBulletFuncs[var1.BulletType.G_BULLET] = var4._createGravitationBullet
var4.generateBulletFuncs[var1.BulletType.ELECTRIC_ARC] = var4._createDirectBullet
var4.generateBulletFuncs[var1.BulletType.MISSILE] = var4._createMissile
var4.generateBulletFuncs[var1.BulletType.SPACE_LASER] = var4._createSpaceLaser
var4.generateBulletFuncs[var1.BulletType.SCALE] = var4._createScaleBullet
var4.generateBulletFuncs[var1.BulletType.TRIGGER_BOMB] = var4._createBombBullet
var4.generateBulletFuncs[var1.BulletType.AAMissile] = var4._createAAMissile

function var4.ConvertSpecificBarrage(arg0, arg1)
	local var0

	var0[arg1], var0 = var4.barrageInteration(pg.barrage_template[arg0], arg1), var4.ConvertedBarrageTableList[arg0] or {}
	var4.ConvertedBarrageTableList[arg0] = var0
end

function var4.ClearConvertedBarrage()
	var4.ConvertedBarrageTableList = {}
end

function var4.barrageInteration(arg0, arg1)
	local var0 = 1
	local var1 = arg0.primal_repeat
	local var2 = {}
	local var3 = arg0.offset_x
	local var4 = arg0.offset_z
	local var5 = arg0.angle
	local var6 = arg0.delay
	local var7 = arg0.delta_offset_x
	local var8 = arg0.delta_offset_z
	local var9 = arg0.delta_angle
	local var10 = arg0.delta_delay

	for iter0 = 0, var1 do
		local var11 = {
			OffsetX = var3 * arg1,
			OffsetZ = var4,
			Angle = var5,
			Delay = var6
		}

		table.insert(var2, var11)

		var3 = var3 + var7
		var4 = var4 + var8
		var5 = var5 + var9
		var6 = var6 + var10
	end

	return var2
end

var4.ClearConvertedBarrage()
