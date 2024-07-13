ys = ys or {}

local var0_0 = {}

ys.Battle.BattleAttr = var0_0

local var1_0 = ys.Battle.BattleConst

var0_0.AttrListInheritance = {
	"level",
	"formulaLevel",
	"repressReduce",
	"cannonPower",
	"torpedoPower",
	"antiAirPower",
	"airPower",
	"antiSubPower",
	"fleetGS",
	"loadSpeed",
	"attackRating",
	"dodgeRate",
	"velocity",
	"luck",
	"cri",
	"criDamage",
	"criDamageResist",
	"hiveExtraHP",
	"GCT",
	"bulletSpeedRatio",
	"torpedoSpeedExtra",
	"damageRatioBullet",
	"damageEnhanceProjectile",
	"healingEnhancement",
	"injureRatio",
	"injureRatioByCannon",
	"injureRatioByBulletTorpedo",
	"injureRatioByAir",
	"damageRatioByCannon",
	"damageRatioByBulletTorpedo",
	"damageRatioByAir",
	"damagePreventRantTorpedo",
	"accuracyRateExtra",
	"dodgeRateExtra",
	"perfectDodge",
	"immuneDirectHit",
	"chargeBulletAccuracy",
	"dropBombAccuracy",
	"aircraftBooster",
	"manualEnhancement",
	"initialEnhancement",
	"worldBuffResistance",
	"airResistPierceActive",
	"airResistPierce"
}

function var0_0.InsertInheritedAttr(arg0_1)
	for iter0_1, iter1_1 in pairs(arg0_1) do
		var0_0.AttrListInheritance[#var0_0.AttrListInheritance + 1] = iter1_1
	end
end

var0_0.InsertInheritedAttr(ys.Battle.BattleConfig.AMMO_DAMAGE_ENHANCE)
var0_0.InsertInheritedAttr(ys.Battle.BattleConfig.AMMO_DAMAGE_REDUCE)
var0_0.InsertInheritedAttr(ys.Battle.BattleConfig.DAMAGE_AMMO_TO_ARMOR_RATE_ENHANCE)
var0_0.InsertInheritedAttr(ys.Battle.BattleConfig.DAMAGE_TO_ARMOR_RATE_ENHANCE)
var0_0.InsertInheritedAttr(ys.Battle.BattleConfig.SHIP_TYPE_ACCURACY_ENHANCE)

var0_0.TAG_EHC_KEY = "DMG_TAG_EHC_"
var0_0.FROM_TAG_EHC_KEY = "DMG_FROM_TAG_"
var0_0.TAG_CRI_EHC_KEY = "CRI_TAG_EHC_"
var0_0.TAG_CRIDMG_EHC_KEY = "CRIDMG_TAG_EHC_"
var0_0.ATTACK_ATTR_TYPE = {
	[var1_0.WeaponDamageAttr.CANNON] = "cannonPower",
	[var1_0.WeaponDamageAttr.TORPEDO] = "torpedoPower",
	[var1_0.WeaponDamageAttr.ANTI_AIR] = "antiAirPower",
	[var1_0.WeaponDamageAttr.AIR] = "airPower",
	[var1_0.WeaponDamageAttr.ANIT_SUB] = "antiSubPower"
}

function var0_0.GetAtkAttrByType(arg0_2, arg1_2)
	local var0_2 = var0_0.ATTACK_ATTR_TYPE[arg1_2]

	return math.max(arg0_2[var0_2], 0)
end

function var0_0.SetAttr(arg0_3, arg1_3)
	arg0_3._attr = setmetatable({}, {
		__index = arg1_3
	})
end

function var0_0.GetAttr(arg0_4)
	return arg0_4._attr
end

function var0_0.SetBaseAttr(arg0_5)
	arg0_5._baseAttr = Clone(arg0_5._attr)
end

function var0_0.IsInvincible(arg0_6)
	local var0_6 = arg0_6._attr.isInvincible

	return var0_6 and var0_6 > 0
end

function var0_0.AppendInvincible(arg0_7)
	local var0_7 = arg0_7._attr.isInvincible or 0

	arg0_7._attr.isInvincible = var0_7 + 1
end

function var0_0.AddImmuneAreaLimit(arg0_8, arg1_8)
	local var0_8 = (arg0_8._attr.immuneAreaLimit or 0) + arg1_8

	arg0_8._attr.immuneAreaLimit = var0_8

	arg0_8._move:ImmuneAreaLimit(var0_8 > 0)
end

function var0_0.AddImmuneMaxAreaLimit(arg0_9, arg1_9)
	local var0_9 = (arg0_9._attr.immuneMaxAreaLimit or 0) + arg1_9

	arg0_9._attr.immuneMaxAreaLimit = var0_9

	arg0_9._move:ImmuneMaxAreaLimit(var0_9 > 0)
end

function var0_0.IsImmuneAreaLimit(arg0_10)
	local var0_10 = arg0_10._attr.immuneAreaLimit

	return var0_10 and var0_10 > 0
end

function var0_0.IsImmuneMaxAreaLimit(arg0_11)
	local var0_11 = arg0_11._attr.immuneMaxAreaLimit

	return var0_11 and var0_11 > 0
end

function var0_0.IsVisitable(arg0_12)
	local var0_12 = arg0_12._attr.isUnVisitable

	return not var0_12 or var0_12 <= 0
end

function var0_0.UnVisitable(arg0_13)
	local var0_13 = arg0_13._attr.isUnVisitable or 0

	arg0_13._attr.isUnVisitable = var0_13 + 1
end

function var0_0.Visitable(arg0_14)
	local var0_14 = arg0_14._attr.isUnVisitable or 0

	arg0_14._attr.isUnVisitable = var0_14 - 1
end

function var0_0.IsSpirit(arg0_15)
	local var0_15 = arg0_15._attr.isSpirit

	return var0_15 and var0_15 > 0
end

function var0_0.Spirit(arg0_16)
	local var0_16 = arg0_16._attr.isSpirit or 0

	arg0_16._attr.isSpirit = var0_16 + 1
end

function var0_0.Entity(arg0_17)
	local var0_17 = arg0_17._attr.isSpirit or 0

	arg0_17._attr.isSpirit = var0_17 - 1
end

function var0_0.IsStun(arg0_18)
	local var0_18 = arg0_18._attr.isStun

	return var0_18 and var0_18 > 0
end

function var0_0.Stun(arg0_19)
	local var0_19 = arg0_19._attr.isStun or 0

	arg0_19._attr.isStun = var0_19 + 1
end

function var0_0.CancelStun(arg0_20)
	local var0_20 = arg0_20._attr.isStun or 0

	arg0_20._attr.isStun = var0_20 - 1
end

function var0_0.IsCloak(arg0_21)
	return (arg0_21._attr.isCloak or 0) == 1
end

function var0_0.Cloak(arg0_22)
	arg0_22._attr.isCloak = 1
	arg0_22._attr.airResistPierceActive = 1
end

function var0_0.Uncloak(arg0_23)
	arg0_23._attr.isCloak = 0
	arg0_23._attr.airResistPierceActive = 0
end

function var0_0.IsLockAimBias(arg0_24)
	return (arg0_24._attr.lockAimBias or 0) >= 1
end

function var0_0.IsUnitCldImmune(arg0_25)
	return (arg0_25._attr.unitCldImmune or 0) >= 1
end

function var0_0.UnitCldImmune(arg0_26)
	local var0_26 = arg0_26._attr.unitCldImmune or 0

	arg0_26._attr.unitCldImmune = var0_26 + 1
end

function var0_0.UnitCldEnable(arg0_27)
	local var0_27 = arg0_27._attr.unitCldImmune or 0

	arg0_27._attr.unitCldImmune = var0_27 - 1
end

function var0_0.GetCurrentTargetSelect(arg0_28)
	local var0_28
	local var1_28 = var0_0.GetCurrent(arg0_28, "TargetChoise")
	local var2_28 = ys.Battle.BattleConfig.TARGET_SELECT_PRIORITY

	for iter0_28, iter1_28 in ipairs(var1_28) do
		if not var0_28 or var2_28[iter1_28] > var2_28[var0_28] then
			var0_28 = iter1_28
		end
	end

	return var0_28
end

function var0_0.AddTargetSelect(arg0_29, arg1_29)
	table.insert(var0_0.GetCurrent(arg0_29, "TargetChoise"), arg1_29)
end

function var0_0.RemoveTargetSelect(arg0_30, arg1_30)
	local var0_30 = var0_0.GetCurrent(arg0_30, "TargetChoise")

	for iter0_30, iter1_30 in ipairs(var0_30) do
		if iter1_30 == arg1_30 then
			table.remove(var0_30, iter0_30)

			break
		end
	end
end

function var0_0.GetCurrentGuardianID(arg0_31)
	local var0_31 = var0_0.GetCurrent(arg0_31, "guardian")
	local var1_31 = #var0_31

	if var1_31 == 0 then
		return nil
	else
		return var0_31[var1_31]
	end
end

function var0_0.AddGuardianID(arg0_32, arg1_32)
	local var0_32 = var0_0.GetCurrent(arg0_32, "guardian")

	if not table.contains(var0_32, arg1_32) then
		table.insert(var0_32, arg1_32)
	end
end

function var0_0.RemoveGuardianID(arg0_33, arg1_33)
	local var0_33 = var0_0.GetCurrent(arg0_33, "guardian")

	for iter0_33, iter1_33 in ipairs(var0_33) do
		if iter1_33 == arg1_33 then
			table.remove(var0_33, iter0_33)

			return
		end
	end
end

function var0_0.SetPlayerAttrFromOutBattle(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34._attr or {}

	arg0_34._attr = var0_34
	var0_34.id = arg1_34.id
	var0_34.battleUID = arg0_34:GetUniqueID()
	var0_34.level = arg1_34.level
	var0_34.formulaLevel = arg1_34.level
	var0_34.maxHP = arg1_34.durability
	var0_34.HPRate = 1
	var0_34.DMGRate = 0
	var0_34.cannonPower = arg1_34.cannon
	var0_34.torpedoPower = arg1_34.torpedo
	var0_34.antiAirPower = arg1_34.antiaircraft
	var0_34.antiSubPower = arg1_34.antisub or 0
	var0_34.baseAntiSubPower = arg2_34 and arg2_34.antisub or arg1_34.antisub
	var0_34.airPower = arg1_34.air
	var0_34.loadSpeed = arg1_34.reload
	var0_34.armorType = arg1_34.armorType
	var0_34.attackRating = arg1_34.hit
	var0_34.dodgeRate = arg1_34.dodge
	var0_34.velocity = ys.Battle.BattleFormulas.ConvertShipSpeed(arg1_34.speed)
	var0_34.baseVelocity = var0_34.velocity
	var0_34.luck = arg1_34.luck
	var0_34.repressReduce = arg1_34.repressReduce or 1
	var0_34.oxyMax = arg1_34.oxy_max
	var0_34.oxyCost = arg1_34.oxy_cost
	var0_34.oxyRecovery = arg1_34.oxy_recovery
	var0_34.oxyRecoverySurface = arg1_34.oxy_recovery_surface
	var0_34.oxyRecoveryBench = arg1_34.oxy_recovery_bench
	var0_34.oxyAtkDuration = arg1_34.attack_duration
	var0_34.raidDist = arg1_34.raid_distance
	var0_34.sonarRange = arg1_34.sonarRange or 0
	var0_34.cloakExposeBase = arg2_34 and arg2_34.dodge + ys.Battle.BattleConfig.CLOAK_EXPOSE_CONST or 0
	var0_34.cloakExposeExtra = 0
	var0_34.cloakRestore = var0_34.cloakExposeBase + var0_34.cloakExposeExtra + ys.Battle.BattleConfig.CLOAK_BASE_RESTORE_DELTA
	var0_34.cloakRecovery = ys.Battle.BattleConfig.CLOAK_RECOVERY
	var0_34.cloakStrikeAdditive = ys.Battle.BattleConfig.CLOAK_STRIKE_ADDITIVE
	var0_34.cloakBombardAdditive = ys.Battle.BattleConfig.CLOAK_STRIKE_ADDITIVE
	var0_34.airResistPierce = ys.Battle.BattleConfig.BASE_ARP
	var0_34.aimBias = 0
	var0_34.aimBiasDecaySpeed = 0
	var0_34.aimBiasDecaySpeedRatio = 0
	var0_34.aimBiasExtraACC = 0
	var0_34.healingRate = 1
	var0_34.DMG_TAG_EHC_N_99 = arg1_34[AttributeType.AntiSiren] or 0
	var0_34.comboTag = "combo_" .. var0_34.battleUID
	var0_34.labelTag = {}
	var0_34.barrageCounterMod = 1
	var0_34.TargetChoise = {}
	var0_34.guardian = {}

	var0_0.SetBaseAttr(arg0_34)
end

function var0_0.AttrFixer(arg0_35, arg1_35)
	if arg0_35 == SYSTEM_SCENARIO then
		arg1_35.repressReduce = ys.Battle.BattleDataProxy.GetInstance():GetRepressReduce()
	elseif arg0_35 == SYSTEM_DUEL or arg0_35 == SYSTEM_SHAM then
		local var0_35 = arg1_35.level
		local var1_35 = arg1_35.durability
		local var2_35, var3_35 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(arg0_35, var0_35)

		arg1_35.durability = var1_35 * var2_35 + var3_35
	end
end

function var0_0.InitDOTAttr(arg0_36, arg1_36)
	local var0_36 = ys.Battle.BattleConfig.DOT_CONFIG_DEFAULT
	local var1_36 = ys.Battle.BattleConfig.DOT_CONFIG

	for iter0_36, iter1_36 in ipairs(var1_36) do
		for iter2_36, iter3_36 in pairs(iter1_36) do
			if iter2_36 == "hit" then
				arg0_36[iter3_36] = arg1_36[iter3_36] or var0_36[iter2_36]
			else
				arg0_36[iter3_36] = var0_36[iter2_36]
			end
		end
	end
end

function var0_0.SetEnemyAttr(arg0_37, arg1_37)
	local var0_37 = arg0_37._tmpData
	local var1_37 = arg0_37:GetLevel()
	local var2_37 = arg0_37._attr or {}

	arg0_37._attr = var2_37
	var2_37.battleUID = arg0_37:GetUniqueID()
	var2_37.level = var1_37
	var2_37.formulaLevel = var1_37

	local var3_37 = (var1_37 - 1) / 1000

	var2_37.maxHP = math.ceil(var0_37.durability + var0_37.durability_growth * var3_37)
	var2_37.HPRate = 1
	var2_37.DMGRate = 0
	var2_37.cannonPower = var0_37.cannon + var0_37.cannon_growth * var3_37
	var2_37.torpedoPower = var0_37.torpedo + var0_37.torpedo_growth * var3_37
	var2_37.antiAirPower = var0_37.antiaircraft + var0_37.antiaircraft_growth * var3_37
	var2_37.airPower = var0_37.air + var0_37.air_growth * var3_37
	var2_37.antiSubPower = var0_37.antisub + var0_37.antisub_growth * var3_37
	var2_37.loadSpeed = var0_37.reload + var0_37.reload_growth * var3_37
	var2_37.armorType = var0_37.armor_type
	var2_37.attackRating = var0_37.hit + var0_37.hit_growth * var3_37
	var2_37.dodgeRate = var0_37.dodge + var0_37.dodge_growth * var3_37
	var2_37.velocity = ys.Battle.BattleFormulas.ConvertShipSpeed(var0_37.speed + var0_37.speed_growth * var3_37)
	var2_37.baseVelocity = var2_37.velocity
	var2_37.luck = var0_37.luck + var0_37.luck_growth * var3_37
	var2_37.bulletSpeedRatio = 0
	var2_37.id = "enemy_" .. tostring(var0_37.id)
	var2_37.repressReduce = 1
	var2_37.healingRate = 1
	var2_37.comboTag = "combo_" .. var2_37.battleUID
	var2_37.labelTag = {}
	var2_37.TargetChoise = {}
	var2_37.guardian = {}

	var0_0.SetBaseAttr(arg0_37)
end

function var0_0.SetEnemyWorldEnhance(arg0_38)
	local var0_38 = arg0_38._tmpData
	local var1_38 = arg0_38._attr
	local var2_38 = var1_38.level
	local var3_38 = ys.Battle.BattleDataProxy.GetInstance()
	local var4_38 = var0_38.world_enhancement
	local var5_38 = ys.Battle.BattleFormulas

	var1_38.maxHP = var1_38.maxHP * var5_38.WorldEnemyAttrEnhance(var4_38[1], var2_38)
	var1_38.cannonPower = var1_38.cannonPower * var5_38.WorldEnemyAttrEnhance(var4_38[2], var2_38)
	var1_38.torpedoPower = var1_38.torpedoPower * var5_38.WorldEnemyAttrEnhance(var4_38[3], var2_38)
	var1_38.antiAirPower = var1_38.antiAirPower * var5_38.WorldEnemyAttrEnhance(var4_38[4], var2_38)
	var1_38.airPower = var1_38.airPower * var5_38.WorldEnemyAttrEnhance(var4_38[5], var2_38)
	var1_38.attackRating = var1_38.attackRating * var5_38.WorldEnemyAttrEnhance(var4_38[6], var2_38)
	var1_38.dodgeRate = var1_38.dodgeRate * var5_38.WorldEnemyAttrEnhance(var4_38[7], var2_38)

	local var6_38 = var3_38:GetInitData()
	local var7_38, var8_38, var9_38 = var5_38.WorldMapRewardAttrEnhance(var6_38.EnemyMapRewards, var6_38.FleetMapRewards)

	var1_38.cannonPower = var1_38.cannonPower * (1 + var7_38)
	var1_38.torpedoPower = var1_38.torpedoPower * (1 + var7_38)
	var1_38.airPower = var1_38.airPower * (1 + var7_38)
	var1_38.antiAirPower = var1_38.antiAirPower * (1 + var7_38)
	var1_38.antiSubPower = var1_38.antiSubPower * (1 + var7_38)
	var1_38.maxHP = math.ceil(var1_38.maxHP * (1 + var8_38))
	var1_38.worldBuffResistance = var9_38

	var0_0.SetBaseAttr(arg0_38)
end

function var0_0.SetMinionAttr(arg0_39, arg1_39)
	local var0_39 = arg0_39:GetMaster()
	local var1_39 = var0_0.GetAttr(var0_39)
	local var2_39 = arg0_39._tmpData
	local var3_39 = var1_39.level
	local var4_39 = arg0_39._attr or {}

	arg0_39._attr = var4_39
	var4_39.battleUID = arg0_39:GetUniqueID()

	for iter0_39, iter1_39 in ipairs(var0_0.AttrListInheritance) do
		var4_39[iter1_39] = var1_39[iter1_39]
	end

	for iter2_39, iter3_39 in pairs(var1_39) do
		if string.find(iter2_39, var0_0.TAG_EHC_KEY) then
			var4_39[iter2_39] = iter3_39
		end
	end

	for iter4_39, iter5_39 in pairs(var1_39) do
		if string.find(iter4_39, var0_0.TAG_CRI_EHC_KEY) then
			var4_39[iter4_39] = iter5_39
		end
	end

	var4_39.id = var1_39.id
	var4_39.level = var3_39
	var4_39.formulaLevel = var3_39

	local function var5_39(arg0_40, arg1_40)
		local var0_40 = var2_39[arg0_40 .. "_growth"]

		if var0_40 ~= 0 then
			var4_39[arg1_40] = var1_39[arg1_40] * var0_40 * 0.0001
		else
			var4_39[arg1_40] = var2_39[arg0_40]
		end
	end

	var4_39.HPRate = 1
	var4_39.DMGRate = 0

	var5_39("durability", "maxHP")
	var5_39("cannon", "cannonPower")
	var5_39("torpedo", "torpedoPower")
	var5_39("antiaircraft", "antiAirPower")
	var5_39("air", "airPower")
	var5_39("antisub", "antiSubPower")
	var5_39("reload", "loadSpeed")
	var5_39("hit", "attackRating")
	var5_39("dodge", "dodgeRate")
	var5_39("luck", "luck")

	var4_39.armorType = var2_39.armor_type

	var5_39("speed", "velocity")

	var4_39.velocity = ys.Battle.BattleFormulas.ConvertShipSpeed(var4_39.velocity)
	var4_39.baseVelocity = var4_39.velocity
	var4_39.bulletSpeedRatio = 0
	var4_39.repressReduce = 1
	var4_39.healingRate = 1
	var4_39.comboTag = "combo_" .. var4_39.battleUID
	var4_39.labelTag = {}
	var4_39.TargetChoise = {}
	var4_39.guardian = {}

	var0_0.SetBaseAttr(arg0_39)
end

function var0_0.IsWorldMapRewardAttrWarning(arg0_41, arg1_41)
	for iter0_41 = 1, 3 do
		if arg1_41[iter0_41] / (arg0_41[iter0_41] ~= 0 and arg0_41[iter0_41] or 1) < pg.gameset.world_mapbuff_tips.key_value / 10000 then
			return true
		end
	end

	return false
end

function var0_0.MonsterAttrFixer(arg0_42, arg1_42)
	if arg0_42 == SYSTEM_SCENARIO then
		local var0_42 = ys.Battle.BattleDataProxy.GetInstance()
		local var1_42 = var0_42:IsCompletelyRepress() and var0_42:GetRepressLevel() or 0
		local var2_42 = var0_0.GetCurrent(arg1_42, "level")

		var0_0.SetCurrent(arg1_42, "formulaLevel", math.max(1, var2_42 - var1_42))
	elseif arg0_42 == SYSTEM_WORLD then
		var0_0.SetEnemyWorldEnhance(arg1_42)
	end
end

function var0_0.SetAircraftAttFromMother(arg0_43, arg1_43)
	local var0_43 = arg0_43._attr or {}

	arg0_43._attr = var0_43
	var0_43.battleUID = arg0_43:GetUniqueID()
	var0_43.hostUID = arg1_43:GetUniqueID()

	if not type(arg1_43._attr.id) == "string" or string.find(arg1_43._attr.id, "enemy_") == nil then
		var0_43.id = arg1_43._attr.id
	end

	local var1_43 = var0_0.GetAttr(arg1_43)

	for iter0_43, iter1_43 in ipairs(var0_0.AttrListInheritance) do
		var0_43[iter1_43] = var1_43[iter1_43]
	end

	for iter2_43, iter3_43 in pairs(var1_43) do
		if string.find(iter2_43, var0_0.TAG_EHC_KEY) then
			var0_43[iter2_43] = iter3_43
		end
	end

	for iter4_43, iter5_43 in pairs(var1_43) do
		if string.find(iter4_43, var0_0.TAG_CRI_EHC_KEY) then
			var0_43[iter4_43] = iter5_43
		end
	end

	var0_43.armorType = 0
	var0_43.velocity = var0_0.GetCurrent(arg1_43, "baseVelocity")
	var0_43.labelTag = {}
	var0_43.TargetChoise = {}
	var0_43.guardian = {}
	var0_43.comboTag = "combo_" .. var0_43.hostUID
end

function var0_0.SetAircraftAttFromTemp(arg0_44)
	arg0_44._attr = arg0_44._attr or {}

	local var0_44 = var0_0.GetCurrent(arg0_44, "hiveExtraHP")

	arg0_44._attr.velocity = arg0_44._attr.velocity or ys.Battle.BattleFormulas.ConvertAircraftSpeed(arg0_44._tmpData.speed)

	local var1_44 = arg0_44._attr.level or 1

	arg0_44._attr.maxHP = arg0_44._attr.maxHP or arg0_44._tmpData.max_hp + arg0_44._tmpData.hp_growth / 1000 * (var1_44 - 1) + var0_44
	arg0_44._attr.crashDMG = arg0_44._tmpData.crash_DMG
	arg0_44._attr.dodge = arg0_44._tmpData.dodge
	arg0_44._attr.dodgeLimit = arg0_44._tmpData.dodge_limit
end

function var0_0.SetAirFighterAttr(arg0_45, arg1_45)
	local var0_45 = arg0_45._attr or {}

	arg0_45._attr = var0_45

	local var1_45 = ys.Battle.BattleDataProxy.GetInstance()
	local var2_45 = var1_45:GetDungeonLevel()

	var0_45.battleUID = arg0_45:GetUniqueID()
	var0_45.hostUID = 0
	var0_45.id = 0
	var0_45.level = var2_45
	var0_45.formulaLevel = var2_45

	if var1_45:IsCompletelyRepress() then
		var0_45.formulaLevel = math.max(var0_45.formulaLevel - 10, 1)
	end

	local var3_45 = (var2_45 - 1) / 1000

	var0_45.maxHP = math.floor(arg1_45.max_hp + arg1_45.hp_growth * var3_45)
	var0_45.attackRating = arg1_45.accuracy + arg1_45.ACC_growth * var3_45

	local var4_45 = arg1_45.attack_power + arg1_45.AP_growth * var3_45

	var0_45.dodge = arg1_45.dodge
	var0_45.dodgeLimit = arg1_45.dodge_limit
	var0_45.cannonPower = var4_45
	var0_45.torpedoPower = var4_45
	var0_45.antiAirPower = var4_45
	var0_45.antiSubPower = var4_45
	var0_45.airPower = var4_45
	var0_45.loadSpeed = 0
	var0_45.armorType = 1
	var0_45.dodgeRate = 0
	var0_45.luck = 50
	var0_45.velocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(arg1_45.speed)
	var0_45.repressReduce = 1
	var0_45.TargetChoise = {}
	var0_45.guardian = {}
	var0_45.crashDMG = arg1_45.crash_DMG
end

function var0_0.SetFusionAttrFromElement(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = var0_0.GetAttr(arg1_46)
	local var1_46 = var0_46.level
	local var2_46 = arg0_46._attr or {}

	arg0_46._attr = var2_46
	var2_46.id = var0_46.id
	var2_46.level = var1_46
	var2_46.formulaLevel = var1_46
	var2_46.battleUID = arg0_46:GetUniqueID()

	for iter0_46, iter1_46 in ipairs(var0_0.AttrListInheritance) do
		var2_46[iter1_46] = var0_46[iter1_46]
	end

	for iter2_46, iter3_46 in pairs(var0_46) do
		if string.find(iter2_46, var0_0.TAG_EHC_KEY) then
			var2_46[iter2_46] = iter3_46
		end
	end

	for iter4_46, iter5_46 in pairs(var0_46) do
		if string.find(iter4_46, var0_0.TAG_CRI_EHC_KEY) then
			var2_46[iter4_46] = iter5_46
		end
	end

	local var3_46 = arg1_46:GetHP()

	for iter6_46, iter7_46 in ipairs(arg2_46) do
		var3_46 = var3_46 + iter7_46:GetHP()
	end

	var2_46.maxHP = var3_46
	var2_46.hpProvideRate = {}
	var2_46.hpProvideRate[var0_0.GetCurrent(arg1_46, "id")] = arg1_46:GetHP() / var3_46

	for iter8_46, iter9_46 in ipairs(arg2_46) do
		var2_46.hpProvideRate[var0_0.GetCurrent(iter9_46, "id")] = iter9_46:GetHP() / var3_46
	end

	local function var4_46(arg0_47)
		local var0_47 = arg3_46[arg0_47] or 1

		var2_46[arg0_47] = var0_0.GetCurrent(arg1_46, arg0_47) * var0_47
	end

	var4_46("cannonPower")
	var4_46("torpedoPower")
	var4_46("antiAirPower")
	var4_46("antiSubPower")
	var4_46("baseAntiSubPower")
	var4_46("airPower")
	var4_46("loadSpeed")
	var4_46("attackRating")
	var4_46("dodgeRate")
	var4_46("luck")
	var4_46("velocity")
	var4_46("baseVelocity")

	var2_46.armorType = var0_0.GetCurrent(arg1_46, "armorType")
	var2_46.aimBias = 0
	var2_46.aimBiasDecaySpeed = 0
	var2_46.aimBiasDecaySpeedRatio = 0
	var2_46.aimBiasExtraACC = 0
	var2_46.healingRate = 1
	var2_46.comboTag = "combo_" .. var2_46.battleUID
	var2_46.labelTag = {}
	var2_46.barrageCounterMod = 1
	var2_46.TargetChoise = {}
	var2_46.guardian = {}

	var0_0.SetBaseAttr(arg0_46)
end

function var0_0.FlashByBuff(arg0_48, arg1_48, arg2_48)
	arg0_48._attr[arg1_48] = arg2_48 + (arg0_48._baseAttr[arg1_48] or 0)

	if string.find(arg1_48, var0_0.FROM_TAG_EHC_KEY) then
		local var0_48 = 0

		for iter0_48, iter1_48 in pairs(arg0_48._attr) do
			if string.find(iter0_48, var0_0.FROM_TAG_EHC_KEY) and iter1_48 ~= 0 then
				var0_48 = 1

				break
			end
		end

		var0_0.SetCurrent(arg0_48, var0_0.FROM_TAG_EHC_KEY, var0_48)
	end
end

function var0_0.FlashVelocity(arg0_49, arg1_49, arg2_49)
	local var0_49 = var0_0.GetBase(arg0_49, "velocity") * 1.8
	local var1_49 = var0_0.GetBase(arg0_49, "velocity") * 0.2
	local var2_49 = arg0_49._baseAttr.velocity * arg1_49 + arg2_49
	local var3_49 = Mathf.Clamp(var2_49, var1_49, var0_49)

	var0_0.SetCurrent(arg0_49, "velocity", var3_49)
end

function var0_0.HasSonar(arg0_50)
	local var0_50 = arg0_50:GetTemplate().type

	return ys.Battle.BattleConfig.VAN_SONAR_PROPERTY[var0_50] ~= nil
end

function var0_0.SetCurrent(arg0_51, arg1_51, arg2_51)
	arg0_51._attr[arg1_51] = arg2_51
end

function var0_0.GetCurrent(arg0_52, arg1_52)
	local var0_52 = AttributeType.IsPrimalBattleAttr(arg1_52) or false

	return var0_0._attrFunc[var0_52](arg0_52, arg1_52)
end

function var0_0._getPrimalAttr(arg0_53, arg1_53)
	return math.max(arg0_53._attr[arg1_53], 0)
end

function var0_0._getSecondaryAttr(arg0_54, arg1_54)
	return arg0_54._attr[arg1_54] or 0
end

var0_0._attrFunc = {
	[true] = var0_0._getPrimalAttr,
	[false] = var0_0._getSecondaryAttr
}

function var0_0.GetBase(arg0_55, arg1_55)
	return arg0_55._baseAttr[arg1_55] or 0
end

function var0_0.GetCurrentTags(arg0_56)
	return arg0_56._attr.labelTag or {}
end

function var0_0.Increase(arg0_57, arg1_57, arg2_57)
	if arg2_57 then
		arg0_57._attr[arg1_57] = (arg0_57._attr[arg1_57] or 0) + arg2_57
	end
end

function var0_0.RatioIncrease(arg0_58, arg1_58, arg2_58)
	if arg2_58 then
		arg0_58._attr[arg1_58] = arg0_58._attr[arg1_58] + arg0_58._baseAttr[arg1_58] * arg2_58 / 10000
	end
end

function var0_0.GetTagAttr(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg1_59:GetLabelTag()
	local var1_59 = {}

	for iter0_59, iter1_59 in ipairs(var0_59) do
		var1_59[var0_0.TAG_EHC_KEY .. iter1_59] = true
	end

	local var2_59 = 1

	for iter2_59, iter3_59 in pairs(var1_59) do
		local var3_59 = var0_0.GetCurrent(arg0_59, iter2_59)

		if var3_59 ~= 0 then
			if arg2_59 then
				var3_59 = ys.Battle.BattleDataFunction.GetLimitAttributeRange(iter2_59, var3_59)
			end

			var2_59 = var2_59 * (1 + var3_59)
		end
	end

	if var0_0.GetCurrent(arg1_59, var0_0.FROM_TAG_EHC_KEY) > 0 then
		local var4_59 = arg0_59:GetWeaponTempData().attack_attribute
		local var5_59 = var0_0.FROM_TAG_EHC_KEY .. var4_59 .. "_"
		local var6_59 = var0_0.GetCurrentTags(arg0_59)

		for iter4_59, iter5_59 in pairs(var6_59) do
			if iter5_59 > 0 then
				local var7_59 = var5_59 .. iter4_59
				local var8_59 = var0_0.GetCurrent(arg1_59, var7_59)

				if var8_59 ~= 0 then
					var2_59 = var2_59 * (1 + var8_59)
				end
			end
		end
	end

	return var2_59
end

function var0_0.GetTagAttrCri(arg0_60, arg1_60)
	local var0_60 = arg1_60:GetLabelTag()
	local var1_60 = {}

	for iter0_60, iter1_60 in ipairs(var0_60) do
		var1_60[var0_0.TAG_CRI_EHC_KEY .. iter1_60] = true
	end

	local var2_60 = 0

	for iter2_60, iter3_60 in pairs(var1_60) do
		local var3_60 = var0_0.GetCurrent(arg0_60, iter2_60)

		if var3_60 ~= 0 then
			var2_60 = var2_60 + var3_60
		end
	end

	return var2_60
end

function var0_0.GetTagAttrCriDmg(arg0_61, arg1_61)
	local var0_61 = arg1_61:GetLabelTag()
	local var1_61 = {}

	for iter0_61, iter1_61 in ipairs(var0_61) do
		var1_61[var0_0.TAG_CRIDMG_EHC_KEY .. iter1_61] = true
	end

	local var2_61 = 0

	for iter2_61, iter3_61 in pairs(var1_61) do
		local var3_61 = var0_0.GetCurrent(arg0_61, iter2_61)

		if var3_61 ~= 0 then
			var2_61 = var2_61 + var3_61
		end
	end

	return var2_61
end
