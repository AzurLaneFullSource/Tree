ys = ys or {}

local var0 = {}

ys.Battle.BattleAttr = var0

local var1 = ys.Battle.BattleConst

var0.AttrListInheritance = {
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

function var0.InsertInheritedAttr(arg0)
	for iter0, iter1 in pairs(arg0) do
		var0.AttrListInheritance[#var0.AttrListInheritance + 1] = iter1
	end
end

var0.InsertInheritedAttr(ys.Battle.BattleConfig.AMMO_DAMAGE_ENHANCE)
var0.InsertInheritedAttr(ys.Battle.BattleConfig.AMMO_DAMAGE_REDUCE)
var0.InsertInheritedAttr(ys.Battle.BattleConfig.DAMAGE_AMMO_TO_ARMOR_RATE_ENHANCE)
var0.InsertInheritedAttr(ys.Battle.BattleConfig.DAMAGE_TO_ARMOR_RATE_ENHANCE)
var0.InsertInheritedAttr(ys.Battle.BattleConfig.SHIP_TYPE_ACCURACY_ENHANCE)

var0.TAG_EHC_KEY = "DMG_TAG_EHC_"
var0.FROM_TAG_EHC_KEY = "DMG_FROM_TAG_"
var0.TAG_CRI_EHC_KEY = "CRI_TAG_EHC_"
var0.TAG_CRIDMG_EHC_KEY = "CRIDMG_TAG_EHC_"
var0.ATTACK_ATTR_TYPE = {
	[var1.WeaponDamageAttr.CANNON] = "cannonPower",
	[var1.WeaponDamageAttr.TORPEDO] = "torpedoPower",
	[var1.WeaponDamageAttr.ANTI_AIR] = "antiAirPower",
	[var1.WeaponDamageAttr.AIR] = "airPower",
	[var1.WeaponDamageAttr.ANIT_SUB] = "antiSubPower"
}

function var0.GetAtkAttrByType(arg0, arg1)
	local var0 = var0.ATTACK_ATTR_TYPE[arg1]

	return math.max(arg0[var0], 0)
end

function var0.SetAttr(arg0, arg1)
	arg0._attr = setmetatable({}, {
		__index = arg1
	})
end

function var0.GetAttr(arg0)
	return arg0._attr
end

function var0.SetBaseAttr(arg0)
	arg0._baseAttr = Clone(arg0._attr)
end

function var0.IsInvincible(arg0)
	local var0 = arg0._attr.isInvincible

	return var0 and var0 > 0
end

function var0.AppendInvincible(arg0)
	local var0 = arg0._attr.isInvincible or 0

	arg0._attr.isInvincible = var0 + 1
end

function var0.AddImmuneAreaLimit(arg0, arg1)
	local var0 = (arg0._attr.immuneAreaLimit or 0) + arg1

	arg0._attr.immuneAreaLimit = var0

	arg0._move:ImmuneAreaLimit(var0 > 0)
end

function var0.AddImmuneMaxAreaLimit(arg0, arg1)
	local var0 = (arg0._attr.immuneMaxAreaLimit or 0) + arg1

	arg0._attr.immuneMaxAreaLimit = var0

	arg0._move:ImmuneMaxAreaLimit(var0 > 0)
end

function var0.IsImmuneAreaLimit(arg0)
	local var0 = arg0._attr.immuneAreaLimit

	return var0 and var0 > 0
end

function var0.IsImmuneMaxAreaLimit(arg0)
	local var0 = arg0._attr.immuneMaxAreaLimit

	return var0 and var0 > 0
end

function var0.IsVisitable(arg0)
	local var0 = arg0._attr.isUnVisitable

	return not var0 or var0 <= 0
end

function var0.UnVisitable(arg0)
	local var0 = arg0._attr.isUnVisitable or 0

	arg0._attr.isUnVisitable = var0 + 1
end

function var0.Visitable(arg0)
	local var0 = arg0._attr.isUnVisitable or 0

	arg0._attr.isUnVisitable = var0 - 1
end

function var0.IsSpirit(arg0)
	local var0 = arg0._attr.isSpirit

	return var0 and var0 > 0
end

function var0.Spirit(arg0)
	local var0 = arg0._attr.isSpirit or 0

	arg0._attr.isSpirit = var0 + 1
end

function var0.Entity(arg0)
	local var0 = arg0._attr.isSpirit or 0

	arg0._attr.isSpirit = var0 - 1
end

function var0.IsStun(arg0)
	local var0 = arg0._attr.isStun

	return var0 and var0 > 0
end

function var0.Stun(arg0)
	local var0 = arg0._attr.isStun or 0

	arg0._attr.isStun = var0 + 1
end

function var0.CancelStun(arg0)
	local var0 = arg0._attr.isStun or 0

	arg0._attr.isStun = var0 - 1
end

function var0.IsCloak(arg0)
	return (arg0._attr.isCloak or 0) == 1
end

function var0.Cloak(arg0)
	arg0._attr.isCloak = 1
	arg0._attr.airResistPierceActive = 1
end

function var0.Uncloak(arg0)
	arg0._attr.isCloak = 0
	arg0._attr.airResistPierceActive = 0
end

function var0.IsLockAimBias(arg0)
	return (arg0._attr.lockAimBias or 0) >= 1
end

function var0.IsUnitCldImmune(arg0)
	return (arg0._attr.unitCldImmune or 0) >= 1
end

function var0.UnitCldImmune(arg0)
	local var0 = arg0._attr.unitCldImmune or 0

	arg0._attr.unitCldImmune = var0 + 1
end

function var0.UnitCldEnable(arg0)
	local var0 = arg0._attr.unitCldImmune or 0

	arg0._attr.unitCldImmune = var0 - 1
end

function var0.GetCurrentTargetSelect(arg0)
	local var0
	local var1 = var0.GetCurrent(arg0, "TargetChoise")
	local var2 = ys.Battle.BattleConfig.TARGET_SELECT_PRIORITY

	for iter0, iter1 in ipairs(var1) do
		if not var0 or var2[iter1] > var2[var0] then
			var0 = iter1
		end
	end

	return var0
end

function var0.AddTargetSelect(arg0, arg1)
	table.insert(var0.GetCurrent(arg0, "TargetChoise"), arg1)
end

function var0.RemoveTargetSelect(arg0, arg1)
	local var0 = var0.GetCurrent(arg0, "TargetChoise")

	for iter0, iter1 in ipairs(var0) do
		if iter1 == arg1 then
			table.remove(var0, iter0)

			break
		end
	end
end

function var0.GetCurrentGuardianID(arg0)
	local var0 = var0.GetCurrent(arg0, "guardian")
	local var1 = #var0

	if var1 == 0 then
		return nil
	else
		return var0[var1]
	end
end

function var0.AddGuardianID(arg0, arg1)
	local var0 = var0.GetCurrent(arg0, "guardian")

	if not table.contains(var0, arg1) then
		table.insert(var0, arg1)
	end
end

function var0.RemoveGuardianID(arg0, arg1)
	local var0 = var0.GetCurrent(arg0, "guardian")

	for iter0, iter1 in ipairs(var0) do
		if iter1 == arg1 then
			table.remove(var0, iter0)

			return
		end
	end
end

function var0.SetPlayerAttrFromOutBattle(arg0, arg1, arg2)
	local var0 = arg0._attr or {}

	arg0._attr = var0
	var0.id = arg1.id
	var0.battleUID = arg0:GetUniqueID()
	var0.level = arg1.level
	var0.formulaLevel = arg1.level
	var0.maxHP = arg1.durability
	var0.HPRate = 1
	var0.DMGRate = 0
	var0.cannonPower = arg1.cannon
	var0.torpedoPower = arg1.torpedo
	var0.antiAirPower = arg1.antiaircraft
	var0.antiSubPower = arg1.antisub or 0
	var0.baseAntiSubPower = arg2 and arg2.antisub or arg1.antisub
	var0.airPower = arg1.air
	var0.loadSpeed = arg1.reload
	var0.armorType = arg1.armorType
	var0.attackRating = arg1.hit
	var0.dodgeRate = arg1.dodge
	var0.velocity = ys.Battle.BattleFormulas.ConvertShipSpeed(arg1.speed)
	var0.baseVelocity = var0.velocity
	var0.luck = arg1.luck
	var0.repressReduce = arg1.repressReduce or 1
	var0.oxyMax = arg1.oxy_max
	var0.oxyCost = arg1.oxy_cost
	var0.oxyRecovery = arg1.oxy_recovery
	var0.oxyRecoverySurface = arg1.oxy_recovery_surface
	var0.oxyRecoveryBench = arg1.oxy_recovery_bench
	var0.oxyAtkDuration = arg1.attack_duration
	var0.raidDist = arg1.raid_distance
	var0.sonarRange = arg1.sonarRange or 0
	var0.cloakExposeBase = arg2 and arg2.dodge + ys.Battle.BattleConfig.CLOAK_EXPOSE_CONST or 0
	var0.cloakExposeExtra = 0
	var0.cloakRestore = var0.cloakExposeBase + var0.cloakExposeExtra + ys.Battle.BattleConfig.CLOAK_BASE_RESTORE_DELTA
	var0.cloakRecovery = ys.Battle.BattleConfig.CLOAK_RECOVERY
	var0.cloakStrikeAdditive = ys.Battle.BattleConfig.CLOAK_STRIKE_ADDITIVE
	var0.cloakBombardAdditive = ys.Battle.BattleConfig.CLOAK_STRIKE_ADDITIVE
	var0.airResistPierce = ys.Battle.BattleConfig.BASE_ARP
	var0.aimBias = 0
	var0.aimBiasDecaySpeed = 0
	var0.aimBiasDecaySpeedRatio = 0
	var0.aimBiasExtraACC = 0
	var0.healingRate = 1
	var0.DMG_TAG_EHC_N_99 = arg1[AttributeType.AntiSiren] or 0
	var0.comboTag = "combo_" .. var0.battleUID
	var0.labelTag = {}
	var0.barrageCounterMod = 1
	var0.TargetChoise = {}
	var0.guardian = {}

	var0.SetBaseAttr(arg0)
end

function var0.AttrFixer(arg0, arg1)
	if arg0 == SYSTEM_SCENARIO then
		arg1.repressReduce = ys.Battle.BattleDataProxy.GetInstance():GetRepressReduce()
	elseif arg0 == SYSTEM_DUEL or arg0 == SYSTEM_SHAM then
		local var0 = arg1.level
		local var1 = arg1.durability
		local var2, var3 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(arg0, var0)

		arg1.durability = var1 * var2 + var3
	end
end

function var0.InitDOTAttr(arg0, arg1)
	local var0 = ys.Battle.BattleConfig.DOT_CONFIG_DEFAULT
	local var1 = ys.Battle.BattleConfig.DOT_CONFIG

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in pairs(iter1) do
			if iter2 == "hit" then
				arg0[iter3] = arg1[iter3] or var0[iter2]
			else
				arg0[iter3] = var0[iter2]
			end
		end
	end
end

function var0.SetEnemyAttr(arg0, arg1)
	local var0 = arg0._tmpData
	local var1 = arg0:GetLevel()
	local var2 = arg0._attr or {}

	arg0._attr = var2
	var2.battleUID = arg0:GetUniqueID()
	var2.level = var1
	var2.formulaLevel = var1

	local var3 = (var1 - 1) / 1000

	var2.maxHP = math.ceil(var0.durability + var0.durability_growth * var3)
	var2.HPRate = 1
	var2.DMGRate = 0
	var2.cannonPower = var0.cannon + var0.cannon_growth * var3
	var2.torpedoPower = var0.torpedo + var0.torpedo_growth * var3
	var2.antiAirPower = var0.antiaircraft + var0.antiaircraft_growth * var3
	var2.airPower = var0.air + var0.air_growth * var3
	var2.antiSubPower = var0.antisub + var0.antisub_growth * var3
	var2.loadSpeed = var0.reload + var0.reload_growth * var3
	var2.armorType = var0.armor_type
	var2.attackRating = var0.hit + var0.hit_growth * var3
	var2.dodgeRate = var0.dodge + var0.dodge_growth * var3
	var2.velocity = ys.Battle.BattleFormulas.ConvertShipSpeed(var0.speed + var0.speed_growth * var3)
	var2.baseVelocity = var2.velocity
	var2.luck = var0.luck + var0.luck_growth * var3
	var2.bulletSpeedRatio = 0
	var2.id = "enemy_" .. tostring(var0.id)
	var2.repressReduce = 1
	var2.healingRate = 1
	var2.comboTag = "combo_" .. var2.battleUID
	var2.labelTag = {}
	var2.TargetChoise = {}
	var2.guardian = {}

	var0.SetBaseAttr(arg0)
end

function var0.SetEnemyWorldEnhance(arg0)
	local var0 = arg0._tmpData
	local var1 = arg0._attr
	local var2 = var1.level
	local var3 = ys.Battle.BattleDataProxy.GetInstance()
	local var4 = var0.world_enhancement
	local var5 = ys.Battle.BattleFormulas

	var1.maxHP = var1.maxHP * var5.WorldEnemyAttrEnhance(var4[1], var2)
	var1.cannonPower = var1.cannonPower * var5.WorldEnemyAttrEnhance(var4[2], var2)
	var1.torpedoPower = var1.torpedoPower * var5.WorldEnemyAttrEnhance(var4[3], var2)
	var1.antiAirPower = var1.antiAirPower * var5.WorldEnemyAttrEnhance(var4[4], var2)
	var1.airPower = var1.airPower * var5.WorldEnemyAttrEnhance(var4[5], var2)
	var1.attackRating = var1.attackRating * var5.WorldEnemyAttrEnhance(var4[6], var2)
	var1.dodgeRate = var1.dodgeRate * var5.WorldEnemyAttrEnhance(var4[7], var2)

	local var6 = var3:GetInitData()
	local var7, var8, var9 = var5.WorldMapRewardAttrEnhance(var6.EnemyMapRewards, var6.FleetMapRewards)

	var1.cannonPower = var1.cannonPower * (1 + var7)
	var1.torpedoPower = var1.torpedoPower * (1 + var7)
	var1.airPower = var1.airPower * (1 + var7)
	var1.antiAirPower = var1.antiAirPower * (1 + var7)
	var1.antiSubPower = var1.antiSubPower * (1 + var7)
	var1.maxHP = math.ceil(var1.maxHP * (1 + var8))
	var1.worldBuffResistance = var9

	var0.SetBaseAttr(arg0)
end

function var0.SetMinionAttr(arg0, arg1)
	local var0 = arg0:GetMaster()
	local var1 = var0.GetAttr(var0)
	local var2 = arg0._tmpData
	local var3 = var1.level
	local var4 = arg0._attr or {}

	arg0._attr = var4
	var4.battleUID = arg0:GetUniqueID()

	for iter0, iter1 in ipairs(var0.AttrListInheritance) do
		var4[iter1] = var1[iter1]
	end

	for iter2, iter3 in pairs(var1) do
		if string.find(iter2, var0.TAG_EHC_KEY) then
			var4[iter2] = iter3
		end
	end

	for iter4, iter5 in pairs(var1) do
		if string.find(iter4, var0.TAG_CRI_EHC_KEY) then
			var4[iter4] = iter5
		end
	end

	var4.id = var1.id
	var4.level = var3
	var4.formulaLevel = var3

	local function var5(arg0, arg1)
		local var0 = var2[arg0 .. "_growth"]

		if var0 ~= 0 then
			var4[arg1] = var1[arg1] * var0 * 0.0001
		else
			var4[arg1] = var2[arg0]
		end
	end

	var4.HPRate = 1
	var4.DMGRate = 0

	var5("durability", "maxHP")
	var5("cannon", "cannonPower")
	var5("torpedo", "torpedoPower")
	var5("antiaircraft", "antiAirPower")
	var5("air", "airPower")
	var5("antisub", "antiSubPower")
	var5("reload", "loadSpeed")
	var5("hit", "attackRating")
	var5("dodge", "dodgeRate")
	var5("luck", "luck")

	var4.armorType = var2.armor_type

	var5("speed", "velocity")

	var4.velocity = ys.Battle.BattleFormulas.ConvertShipSpeed(var4.velocity)
	var4.baseVelocity = var4.velocity
	var4.bulletSpeedRatio = 0
	var4.repressReduce = 1
	var4.healingRate = 1
	var4.comboTag = "combo_" .. var4.battleUID
	var4.labelTag = {}
	var4.TargetChoise = {}
	var4.guardian = {}

	var0.SetBaseAttr(arg0)
end

function var0.IsWorldMapRewardAttrWarning(arg0, arg1)
	for iter0 = 1, 3 do
		if arg1[iter0] / (arg0[iter0] ~= 0 and arg0[iter0] or 1) < pg.gameset.world_mapbuff_tips.key_value / 10000 then
			return true
		end
	end

	return false
end

function var0.MonsterAttrFixer(arg0, arg1)
	if arg0 == SYSTEM_SCENARIO then
		local var0 = ys.Battle.BattleDataProxy.GetInstance()
		local var1 = var0:IsCompletelyRepress() and var0:GetRepressLevel() or 0
		local var2 = var0.GetCurrent(arg1, "level")

		var0.SetCurrent(arg1, "formulaLevel", math.max(1, var2 - var1))
	elseif arg0 == SYSTEM_WORLD then
		var0.SetEnemyWorldEnhance(arg1)
	end
end

function var0.SetAircraftAttFromMother(arg0, arg1)
	local var0 = arg0._attr or {}

	arg0._attr = var0
	var0.battleUID = arg0:GetUniqueID()
	var0.hostUID = arg1:GetUniqueID()

	if not type(arg1._attr.id) == "string" or string.find(arg1._attr.id, "enemy_") == nil then
		var0.id = arg1._attr.id
	end

	local var1 = var0.GetAttr(arg1)

	for iter0, iter1 in ipairs(var0.AttrListInheritance) do
		var0[iter1] = var1[iter1]
	end

	for iter2, iter3 in pairs(var1) do
		if string.find(iter2, var0.TAG_EHC_KEY) then
			var0[iter2] = iter3
		end
	end

	for iter4, iter5 in pairs(var1) do
		if string.find(iter4, var0.TAG_CRI_EHC_KEY) then
			var0[iter4] = iter5
		end
	end

	var0.armorType = 0
	var0.velocity = var0.GetCurrent(arg1, "baseVelocity")
	var0.labelTag = {}
	var0.TargetChoise = {}
	var0.guardian = {}
	var0.comboTag = "combo_" .. var0.hostUID
end

function var0.SetAircraftAttFromTemp(arg0)
	arg0._attr = arg0._attr or {}

	local var0 = var0.GetCurrent(arg0, "hiveExtraHP")

	arg0._attr.velocity = arg0._attr.velocity or ys.Battle.BattleFormulas.ConvertAircraftSpeed(arg0._tmpData.speed)

	local var1 = arg0._attr.level or 1

	arg0._attr.maxHP = arg0._attr.maxHP or arg0._tmpData.max_hp + arg0._tmpData.hp_growth / 1000 * (var1 - 1) + var0
	arg0._attr.crashDMG = arg0._tmpData.crash_DMG
	arg0._attr.dodge = arg0._tmpData.dodge
	arg0._attr.dodgeLimit = arg0._tmpData.dodge_limit
end

function var0.SetAirFighterAttr(arg0, arg1)
	local var0 = arg0._attr or {}

	arg0._attr = var0

	local var1 = ys.Battle.BattleDataProxy.GetInstance()
	local var2 = var1:GetDungeonLevel()

	var0.battleUID = arg0:GetUniqueID()
	var0.hostUID = 0
	var0.id = 0
	var0.level = var2
	var0.formulaLevel = var2

	if var1:IsCompletelyRepress() then
		var0.formulaLevel = math.max(var0.formulaLevel - 10, 1)
	end

	local var3 = (var2 - 1) / 1000

	var0.maxHP = math.floor(arg1.max_hp + arg1.hp_growth * var3)
	var0.attackRating = arg1.accuracy + arg1.ACC_growth * var3

	local var4 = arg1.attack_power + arg1.AP_growth * var3

	var0.dodge = arg1.dodge
	var0.dodgeLimit = arg1.dodge_limit
	var0.cannonPower = var4
	var0.torpedoPower = var4
	var0.antiAirPower = var4
	var0.antiSubPower = var4
	var0.airPower = var4
	var0.loadSpeed = 0
	var0.armorType = 1
	var0.dodgeRate = 0
	var0.luck = 50
	var0.velocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(arg1.speed)
	var0.repressReduce = 1
	var0.TargetChoise = {}
	var0.guardian = {}
	var0.crashDMG = arg1.crash_DMG
end

function var0.SetFusionAttrFromElement(arg0, arg1, arg2, arg3)
	local var0 = var0.GetAttr(arg1)
	local var1 = var0.level
	local var2 = arg0._attr or {}

	arg0._attr = var2
	var2.id = var0.id
	var2.level = var1
	var2.formulaLevel = var1
	var2.battleUID = arg0:GetUniqueID()

	for iter0, iter1 in ipairs(var0.AttrListInheritance) do
		var2[iter1] = var0[iter1]
	end

	for iter2, iter3 in pairs(var0) do
		if string.find(iter2, var0.TAG_EHC_KEY) then
			var2[iter2] = iter3
		end
	end

	for iter4, iter5 in pairs(var0) do
		if string.find(iter4, var0.TAG_CRI_EHC_KEY) then
			var2[iter4] = iter5
		end
	end

	local var3 = arg1:GetHP()

	for iter6, iter7 in ipairs(arg2) do
		var3 = var3 + iter7:GetHP()
	end

	var2.maxHP = var3
	var2.hpProvideRate = {}
	var2.hpProvideRate[var0.GetCurrent(arg1, "id")] = arg1:GetHP() / var3

	for iter8, iter9 in ipairs(arg2) do
		var2.hpProvideRate[var0.GetCurrent(iter9, "id")] = iter9:GetHP() / var3
	end

	local function var4(arg0)
		local var0 = arg3[arg0] or 1

		var2[arg0] = var0.GetCurrent(arg1, arg0) * var0
	end

	var4("cannonPower")
	var4("torpedoPower")
	var4("antiAirPower")
	var4("antiSubPower")
	var4("baseAntiSubPower")
	var4("airPower")
	var4("loadSpeed")
	var4("attackRating")
	var4("dodgeRate")
	var4("luck")
	var4("velocity")
	var4("baseVelocity")

	var2.armorType = var0.GetCurrent(arg1, "armorType")
	var2.aimBias = 0
	var2.aimBiasDecaySpeed = 0
	var2.aimBiasDecaySpeedRatio = 0
	var2.aimBiasExtraACC = 0
	var2.healingRate = 1
	var2.comboTag = "combo_" .. var2.battleUID
	var2.labelTag = {}
	var2.barrageCounterMod = 1
	var2.TargetChoise = {}
	var2.guardian = {}

	var0.SetBaseAttr(arg0)
end

function var0.FlashByBuff(arg0, arg1, arg2)
	arg0._attr[arg1] = arg2 + (arg0._baseAttr[arg1] or 0)

	if string.find(arg1, var0.FROM_TAG_EHC_KEY) then
		local var0 = 0

		for iter0, iter1 in pairs(arg0._attr) do
			if string.find(iter0, var0.FROM_TAG_EHC_KEY) and iter1 ~= 0 then
				var0 = 1

				break
			end
		end

		var0.SetCurrent(arg0, var0.FROM_TAG_EHC_KEY, var0)
	end
end

function var0.FlashVelocity(arg0, arg1, arg2)
	local var0 = var0.GetBase(arg0, "velocity") * 1.8
	local var1 = var0.GetBase(arg0, "velocity") * 0.2
	local var2 = arg0._baseAttr.velocity * arg1 + arg2
	local var3 = Mathf.Clamp(var2, var1, var0)

	var0.SetCurrent(arg0, "velocity", var3)
end

function var0.HasSonar(arg0)
	local var0 = arg0:GetTemplate().type

	return ys.Battle.BattleConfig.VAN_SONAR_PROPERTY[var0] ~= nil
end

function var0.SetCurrent(arg0, arg1, arg2)
	arg0._attr[arg1] = arg2
end

function var0.GetCurrent(arg0, arg1)
	local var0 = AttributeType.IsPrimalBattleAttr(arg1) or false

	return var0._attrFunc[var0](arg0, arg1)
end

function var0._getPrimalAttr(arg0, arg1)
	return math.max(arg0._attr[arg1], 0)
end

function var0._getSecondaryAttr(arg0, arg1)
	return arg0._attr[arg1] or 0
end

var0._attrFunc = {
	[true] = var0._getPrimalAttr,
	[false] = var0._getSecondaryAttr
}

function var0.GetBase(arg0, arg1)
	return arg0._baseAttr[arg1] or 0
end

function var0.GetCurrentTags(arg0)
	return arg0._attr.labelTag or {}
end

function var0.Increase(arg0, arg1, arg2)
	if arg2 then
		arg0._attr[arg1] = (arg0._attr[arg1] or 0) + arg2
	end
end

function var0.RatioIncrease(arg0, arg1, arg2)
	if arg2 then
		arg0._attr[arg1] = arg0._attr[arg1] + arg0._baseAttr[arg1] * arg2 / 10000
	end
end

function var0.GetTagAttr(arg0, arg1, arg2)
	local var0 = arg1:GetLabelTag()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[var0.TAG_EHC_KEY .. iter1] = true
	end

	local var2 = 1

	for iter2, iter3 in pairs(var1) do
		local var3 = var0.GetCurrent(arg0, iter2)

		if var3 ~= 0 then
			if arg2 then
				var3 = ys.Battle.BattleDataFunction.GetLimitAttributeRange(iter2, var3)
			end

			var2 = var2 * (1 + var3)
		end
	end

	if var0.GetCurrent(arg1, var0.FROM_TAG_EHC_KEY) > 0 then
		local var4 = arg0:GetWeaponTempData().attack_attribute
		local var5 = var0.FROM_TAG_EHC_KEY .. var4 .. "_"
		local var6 = var0.GetCurrentTags(arg0)

		for iter4, iter5 in pairs(var6) do
			if iter5 > 0 then
				local var7 = var5 .. iter4
				local var8 = var0.GetCurrent(arg1, var7)

				if var8 ~= 0 then
					var2 = var2 * (1 + var8)
				end
			end
		end
	end

	return var2
end

function var0.GetTagAttrCri(arg0, arg1)
	local var0 = arg1:GetLabelTag()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[var0.TAG_CRI_EHC_KEY .. iter1] = true
	end

	local var2 = 0

	for iter2, iter3 in pairs(var1) do
		local var3 = var0.GetCurrent(arg0, iter2)

		if var3 ~= 0 then
			var2 = var2 + var3
		end
	end

	return var2
end

function var0.GetTagAttrCriDmg(arg0, arg1)
	local var0 = arg1:GetLabelTag()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[var0.TAG_CRIDMG_EHC_KEY .. iter1] = true
	end

	local var2 = 0

	for iter2, iter3 in pairs(var1) do
		local var3 = var0.GetCurrent(arg0, iter2)

		if var3 ~= 0 then
			var2 = var2 + var3
		end
	end

	return var2
end
