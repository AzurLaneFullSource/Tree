local var0_0 = class("World", import("...BaseEntity"))

var0_0.Fields = {
	colorDic = "table",
	stepCount = "number",
	cdTimeList = "table",
	type = "number",
	inventoryProxy = "table",
	staminaMgr = "table",
	taskProxy = "table",
	autoInfos = "table",
	roundIndex = "number",
	fleets = "table",
	expiredTime = "number",
	activateCount = "number",
	pressingAwardDic = "table",
	achievements = "table",
	submarineSupport = "boolean",
	collectionProxy = "table",
	goodDic = "table",
	achieveEntranceStar = "table",
	baseCmdIds = "table",
	resetAward = "table",
	gobalFlag = "table",
	forceLock = "boolean",
	resetLimitTip = "boolean",
	atlas = "table",
	worldBossProxy = "table",
	progress = "number",
	globalBuffDic = "table",
	lowestHP = "table",
	treasureCount = "number",
	defaultFleets = "table",
	realm = "number",
	isAutoSwitch = "boolean",
	isAutoFight = "boolean",
	baseShipIds = "table",
	activateTime = "number"
}
var0_0.EventUpdateSubmarineSupport = "World.EventUpdateSubmarineSupport"
var0_0.EventSwitchMap = "World.EventSwitchMap"
var0_0.EventUpdateProgress = "World.EventUpdateProgress"
var0_0.EventUpdateShopGoods = "World.EventUpdateShopGoods"
var0_0.EventUpdateGlobalBuff = "World.EventUpdateGlobalBuff"
var0_0.EventAddPortShip = "World.EventAddPortShip"
var0_0.EventRemovePortShip = "World.EventRemovePortShip"
var0_0.EventAchieved = "World.EventAchieved"
var0_0.Listeners = {
	onUpdateItem = "OnUpdateItem",
	onUpdateTask = "OnUpdateTask"
}
var0_0.TypeBase = 0
var0_0.TypeFull = 1
var0_0.InheritNameList = {
	staminaMgr = function()
		return WorldStaminaManager.New()
	end,
	collectionProxy = function()
		return WorldCollectionProxy.New()
	end,
	worldBossProxy = function()
		return WorldBossProxy.New()
	end
}

function var0_0.Ctor(arg0_4, arg1_4, arg2_4)
	var0_0.super.Ctor(arg0_4)

	arg0_4.type = arg1_4

	arg0_4:InheritReset(arg2_4)
end

function var0_0.Build(arg0_5)
	arg0_5.atlas = WorldAtlas.New(WorldConst.DefaultAtlas)
	arg0_5.realm = 0
	arg0_5.fleets = {}
	arg0_5.defaultFleets = {}
	arg0_5.activateTime = 0
	arg0_5.expiredTime = 0
	arg0_5.roundIndex = nil
	arg0_5.submarineSupport = nil
	arg0_5.achievements = {}
	arg0_5.achieveEntranceStar = {}

	arg0_5:InitWorldShopGoods()
	arg0_5:InitWorldColorDictionary()

	arg0_5.activateCount = 0
	arg0_5.stepCount = 0
	arg0_5.treasureCount = 0
	arg0_5.progress = 0
	arg0_5.cdTimeList = {}
	arg0_5.globalBuffDic = {}
	arg0_5.pressingAwardDic = {}
	arg0_5.lowestHP = {}
	arg0_5.gobalFlag = {}
	arg0_5.isAutoFight = false

	arg0_5:InitAutoInfos()

	arg0_5.inventoryProxy = WorldInventoryProxy.New()

	arg0_5.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, arg0_5.onUpdateItem)

	arg0_5.taskProxy = WorldTaskProxy.New()

	arg0_5.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, arg0_5.onUpdateTask)

	arg0_5.baseShipIds = {}
	arg0_5.baseCmdIds = {}
end

function var0_0.Dispose(arg0_6, arg1_6)
	local var0_6 = arg1_6 and {
		realm = arg0_6.realm,
		defaultFleets = arg0_6.defaultFleets,
		achievements = arg0_6.achievements,
		achieveEntranceStar = arg0_6.achieveEntranceStar,
		activateCount = arg0_6.activateCount,
		progress = arg0_6.progress,
		staminaMgr = arg0_6.staminaMgr,
		collectionProxy = arg0_6.collectionProxy
	} or {}

	var0_6.worldBossProxy = arg0_6.worldBossProxy

	for iter0_6 in pairs(var0_0.InheritNameList) do
		if not var0_6[iter0_6] then
			arg0_6[iter0_6]:Dispose()
		end
	end

	arg0_6.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0_6.onUpdateItem)
	arg0_6.inventoryProxy:Dispose()
	arg0_6.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, arg0_6.onUpdateTask)
	arg0_6.taskProxy:Dispose()
	arg0_6.atlas:Dispose()
	arg0_6:Clear()

	return var0_6
end

function var0_0.InheritReset(arg0_7, arg1_7)
	arg1_7 = arg1_7 or {}

	if arg1_7.progress then
		arg0_7:UpdateProgress(arg1_7.progress)

		arg1_7.progress = nil
	end

	for iter0_7, iter1_7 in pairs(arg1_7) do
		arg0_7[iter0_7] = iter1_7
	end

	for iter2_7, iter3_7 in pairs(var0_0.InheritNameList) do
		if not arg1_7[iter2_7] then
			arg0_7[iter2_7] = iter3_7()
		end
	end
end

function var0_0.UsePortNShop(arg0_8)
	return arg0_8:IsReseted() and arg0_8.activateTime >= WorldConst.GetNShopTimeStamp()
end

function var0_0.IsReseted(arg0_9)
	return arg0_9.activateCount > (arg0_9:IsActivate() and 1 or 0)
end

function var0_0.IsActivate(arg0_10)
	if arg0_10.type == World.TypeBase then
		return #arg0_10.baseShipIds > 0
	else
		return tobool(arg0_10:GetActiveMap())
	end
end

function var0_0.CheckResetProgress(arg0_11)
	return pg.gameset.world_resetting_stage.key_value <= arg0_11.progress
end

function var0_0.GetResetWaitingTime(arg0_12)
	return arg0_12.expiredTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.CheckReset(arg0_13, arg1_13)
	return arg0_13:IsActivate() and (arg1_13 or arg0_13:CheckResetProgress()) and arg0_13:GetResetWaitingTime() < 0
end

function var0_0.GetAtlas(arg0_14)
	return arg0_14.atlas
end

function var0_0.GetEntrance(arg0_15, arg1_15)
	return arg0_15.atlas:GetEntrance(arg1_15)
end

function var0_0.GetActiveEntrance(arg0_16)
	return arg0_16.atlas:GetActiveEntrance()
end

function var0_0.GetMap(arg0_17, arg1_17)
	return arg0_17.atlas:GetMap(arg1_17)
end

function var0_0.GetActiveMap(arg0_18)
	return arg0_18.atlas:GetActiveMap()
end

function var0_0.OnSwitchMap(arg0_19)
	arg0_19:ResetRound()

	if arg0_19.submarineSupport then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_5"))
		arg0_19:ResetSubmarine()
		arg0_19:UpdateSubmarineSupport(false)
	end

	arg0_19:DispatchEvent(var0_0.EventSwitchMap)
	print("switch 2 map: " .. arg0_19:GetActiveMap().id .. ", " .. tostring(arg0_19:GetActiveMap().gid))
end

function var0_0.GetRound(arg0_20)
	return arg0_20.roundIndex % 2
end

function var0_0.IncRound(arg0_21)
	arg0_21.roundIndex = arg0_21.roundIndex + 1
end

function var0_0.ResetRound(arg0_22)
	arg0_22.roundIndex = 0
end

function var0_0.UpdateProgress(arg0_23, arg1_23)
	if arg1_23 > arg0_23.progress then
		local var0_23 = arg0_23.progress

		arg0_23.progress = arg1_23

		arg0_23.atlas:UpdateProgress(var0_23, arg1_23)
		arg0_23:DispatchEvent(var0_0.EventUpdateProgress)
	end
end

function var0_0.GetProgress(arg0_24)
	return arg0_24.progress
end

function var0_0.SetRealm(arg0_25, arg1_25)
	if arg0_25.realm ~= arg1_25 then
		arg0_25.realm = arg1_25
	end
end

function var0_0.GetRealm(arg0_26)
	return 1
end

function var0_0.CanCallSubmarineSupport(arg0_27)
	return arg0_27:GetSubmarineFleet()
end

function var0_0.IsSubmarineSupporting(arg0_28)
	return arg0_28.submarineSupport
end

function var0_0.UpdateSubmarineSupport(arg0_29, arg1_29)
	arg0_29.submarineSupport = arg1_29

	arg0_29:DispatchEvent(var0_0.EventUpdateSubmarineSupport)
end

function var0_0.GetSubAidFlag(arg0_30)
	return arg0_30:IsSubmarineSupporting() and arg0_30:GetSubmarineFleet():GetAmmo() > 0
end

function var0_0.ResetSubmarine(arg0_31)
	local var0_31 = arg0_31:GetSubmarineFleet()

	if var0_31 then
		var0_31:RepairSubmarine()
	end
end

function var0_0.SetFleets(arg0_32, arg1_32)
	arg0_32.fleets = arg1_32

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
end

function var0_0.GetFleets(arg0_33)
	return _.rest(arg0_33.fleets, 1)
end

function var0_0.GetFleet(arg0_34, arg1_34)
	return arg1_34 and _.detect(arg0_34.fleets, function(arg0_35)
		return arg0_35.id == arg1_34
	end) or arg0_34:GetActiveMap():GetFleet()
end

function var0_0.GetNormalFleets(arg0_36)
	return _.filter(arg0_36.fleets, function(arg0_37)
		return arg0_37:GetFleetType() == FleetType.Normal
	end)
end

function var0_0.GetSubmarineFleet(arg0_38)
	return _.detect(arg0_38.fleets, function(arg0_39)
		return arg0_39:GetFleetType() == FleetType.Submarine
	end)
end

function var0_0.GetShips(arg0_40)
	local var0_40 = {}

	_.each(arg0_40:GetFleets(), function(arg0_41)
		_.each(arg0_41:GetShips(true), function(arg0_42)
			table.insert(var0_40, arg0_42)
		end)
	end)

	return var0_40
end

function var0_0.GetShipVOs(arg0_43)
	if arg0_43.type == World.TypeBase then
		return underscore.map(arg0_43.baseShipIds, function(arg0_44)
			return WorldConst.FetchShipVO(arg0_44)
		end)
	else
		return _.map(arg0_43:GetShips(), function(arg0_45)
			return WorldConst.FetchShipVO(arg0_45.id)
		end)
	end
end

function var0_0.GetShip(arg0_46, arg1_46)
	return _.detect(arg0_46:GetShips(), function(arg0_47)
		return arg0_47.id == arg1_46
	end)
end

function var0_0.GetShipVO(arg0_48, arg1_48)
	local var0_48 = arg0_48:GetShip(arg1_48)

	return var0_48 and WorldConst.FetchShipVO(var0_48.id)
end

function var0_0.SetDefaultFleets(arg0_49, arg1_49)
	arg0_49.defaultFleets = arg1_49
end

function var0_0.GetDefaultFleets(arg0_50)
	return underscore.rest(arg0_50.defaultFleets, 1)
end

function var0_0.TransDefaultFleets(arg0_51)
	arg0_51.defaultFleets = underscore.map(arg0_51.fleets, function(arg0_52)
		return arg0_52:Trans(WorldBaseFleet)
	end)
end

function var0_0.GetLevel(arg0_53)
	return _(arg0_53:GetFleets()):chain():map(function(arg0_54)
		return arg0_54:GetLevel()
	end):max():value()
end

function var0_0.GetWorldPower(arg0_55)
	local var0_55 = 0

	underscore.each(arg0_55.fleets, function(arg0_56)
		var0_55 = var0_55 + arg0_56:GetGearScoreSum()
	end)

	return math.floor(var0_55 * (1 + arg0_55:GetWorldMapBuffAverageLevel() / pg.gameset.world_strength_correct.key_value))
end

function var0_0.GetWorldRank(arg0_57)
	local var0_57 = 0
	local var1_57 = underscore.map(arg0_57:GetNormalFleets(), function(arg0_58)
		return arg0_58:GetLevelCount() / 6
	end)
	local var2_57 = pg.gameset.world_level_correct.description

	for iter0_57, iter1_57 in ipairs(var1_57) do
		var0_57 = var0_57 + iter1_57 * var2_57[iter0_57]
	end

	local var3_57 = arg0_57:GetSubmarineFleet()

	if var3_57 then
		var0_57 = var0_57 + var3_57:GetLevelCount() / 3 * var2_57[5]
	end

	local var4_57 = var0_57 * arg0_57:GetWorldMapBuffAverageLevel()
	local var5_57
	local var6_57 = pg.gameset.world_suggest_level.description

	for iter2_57, iter3_57 in ipairs(var6_57) do
		if var4_57 < iter3_57 then
			break
		else
			var5_57 = iter2_57
		end
	end

	return var5_57
end

function var0_0.GetBossProxy(arg0_59)
	return arg0_59.worldBossProxy
end

function var0_0.GetTaskProxy(arg0_60)
	return arg0_60.taskProxy
end

function var0_0.GetInventoryProxy(arg0_61)
	return arg0_61.inventoryProxy
end

function var0_0.GetCollectionProxy(arg0_62)
	return arg0_62.collectionProxy
end

function var0_0.VerifyFormation(arg0_63)
	local var0_63 = {}

	_.each(arg0_63:GetShips(), function(arg0_64)
		var0_63[arg0_64.id] = (var0_63[arg0_64.id] or 0) + 1

		assert(var0_63[arg0_64.id] <= 1, "repeated ship id: " .. arg0_64.id)
	end)
end

function var0_0.CalcRepairCost(arg0_65, arg1_65)
	local var0_65 = WorldConst.FetchShipVO(arg1_65.id).level - arg0_65:GetLevel()

	if arg1_65:IsBroken() then
		local var1_65 = pg.gameset.world_port_service_2_interval.description

		return (_.detect(var1_65, function(arg0_66)
			return arg0_66[1] >= var0_65
		end) or var1_65[#var1_65])[2] * pg.gameset.world_port_service_2_price.key_value
	elseif not arg1_65:IsHpFull() then
		local var2_65 = pg.gameset.world_port_service_1_interval.description
		local var3_65 = pg.gameset.world_port_service_1_price.description

		return (_.detect(var2_65, function(arg0_67)
			return arg0_67[1] >= var0_65
		end) or var2_65[#var2_65])[2] * (_.detect(var3_65, function(arg0_68)
			return arg0_68[1] >= arg1_65.hpRant
		end) or var3_65[#var3_65])[2]
	end

	return 0
end

function var0_0.GetMoveRange(arg0_69, arg1_69)
	local var0_69 = arg0_69:GetActiveMap()

	if var0_69:CanLongMove(arg1_69) then
		return var0_69:GetLongMoveRange(arg1_69)
	else
		return var0_69:GetMoveRange(arg1_69)
	end
end

function var0_0.IsRookie(arg0_70)
	return arg0_70.activateCount == 0 and arg0_70.progress <= 0
end

function var0_0.EntranceToReplacementMapList(arg0_71, arg1_71)
	local var0_71 = {}

	for iter0_71, iter1_71 in ipairs(arg1_71.config.stage_chapter) do
		if arg0_71:GetProgress() >= iter1_71[1] and arg0_71:GetProgress() <= iter1_71[2] then
			table.insert(var0_71, arg0_71:GetMap(iter1_71[3]))
		end
	end

	for iter2_71, iter3_71 in ipairs(arg1_71.config.task_chapter) do
		local var1_71 = arg0_71.taskProxy:getTaskById(iter3_71[1])

		if var1_71 and var1_71:isAlive() then
			table.insert(var0_71, arg0_71:GetMap(iter3_71[2]))
		end
	end

	if arg1_71.becomeSairen then
		table.insert(var0_71, arg0_71:GetMap(arg1_71.config.sairen_chapter[1]))
	end

	for iter4_71, iter5_71 in ipairs(arg1_71.config.teasure_chapter) do
		if arg0_71.inventoryProxy:GetItemCount(iter5_71[1]) > 0 then
			table.insert(var0_71, arg0_71:GetMap(iter5_71[2]))
		end
	end

	local var2_71 = arg1_71:GetBaseMap()

	if var2_71.isPressing and #arg1_71.config.complete_chapter > 0 then
		table.insert(var0_71, arg0_71:GetMap(arg1_71.config.complete_chapter[1]))
	end

	table.insert(var0_71, var2_71)

	if arg1_71.active and not underscore.any(var0_71, function(arg0_72)
		return arg0_72.active
	end) then
		table.insert(var0_71, arg0_71:GetActiveMap())
	end

	local var3_71 = {}

	return (underscore.filter(var0_71, function(arg0_73)
		if var3_71[arg0_73.id] then
			return false
		else
			var3_71[arg0_73.id] = true

			return true
		end
	end))
end

function var0_0.ReplacementMapType(arg0_74, arg1_74)
	for iter0_74, iter1_74 in ipairs(arg0_74.config.stage_chapter) do
		if iter1_74[3] == arg1_74.id then
			return "stage_chapter", i18n("area_zhuxian")
		end
	end

	for iter2_74, iter3_74 in ipairs(arg0_74.config.task_chapter) do
		if iter3_74[2] == arg1_74.id then
			local var0_74 = pg.world_task_data[iter3_74[1]].type

			if var0_74 == 0 then
				return "task_chapter", i18n("area_zhuxian")
			elseif var0_74 == 6 then
				return "task_chapter", i18n("area_dangan")
			else
				return "task_chapter", i18n("area_renwu")
			end
		end
	end

	for iter4_74, iter5_74 in ipairs(arg0_74.config.teasure_chapter) do
		if iter5_74[2] == arg1_74.id then
			local var1_74 = pg.world_item_data_template[iter5_74[1]].usage_arg[1] == 1

			return "teasure_chapter", var1_74 and i18n("area_shenyuan") or i18n("area_yinmi")
		end
	end

	if arg0_74.config.sairen_chapter[1] == arg1_74.id then
		return "sairen_chapter", i18n("area_yaosai")
	end

	if arg0_74.config.complete_chapter[1] == arg1_74.id then
		return "complete_chapter", i18n("area_anquan")
	end

	if arg0_74:GetBaseMapId() == arg1_74.id then
		return "base_chapter", i18n("area_putong")
	end

	return "test_chapter", i18n("area_unkown")
end

function var0_0.FindTreasureEntrance(arg0_75, arg1_75)
	return underscore.values(arg0_75.atlas:GetTreasureDic(arg1_75))[1]
end

function var0_0.TreasureMap2ItemId(arg0_76, arg1_76, arg2_76)
	local var0_76 = arg0_76:GetEntrance(arg2_76)

	for iter0_76, iter1_76 in ipairs(var0_76.config.teasure_chapter) do
		if iter1_76[2] == arg1_76 then
			return iter1_76[1]
		end
	end
end

function var0_0.CheckFleetMovable(arg0_77)
	local var0_77 = arg0_77:GetActiveMap()
	local var1_77 = var0_77:GetFleet()

	return arg0_77:GetRound() == WorldConst.RoundPlayer and var0_77:CheckFleetMovable(var1_77) and not var0_77:CheckInteractive()
end

function var0_0.SetAchieveSuccess(arg0_78, arg1_78, arg2_78)
	arg0_78.achieveEntranceStar[arg1_78] = arg0_78.achieveEntranceStar[arg1_78] or {}
	arg0_78.achieveEntranceStar[arg1_78][arg2_78] = true
end

function var0_0.GetMapAchieveStarDic(arg0_79, arg1_79)
	return arg0_79.achieveEntranceStar[arg1_79] or {}
end

function var0_0.GetAchievement(arg0_80, arg1_80)
	if not arg0_80.achievements[arg1_80] then
		arg0_80.achievements[arg1_80] = WorldAchievement.New()

		arg0_80.achievements[arg1_80]:Setup(arg1_80)
	end

	return arg0_80.achievements[arg1_80]
end

function var0_0.GetAchievements(arg0_81, arg1_81)
	local var0_81 = {}

	_.each(arg1_81.config.normal_target, function(arg0_82)
		table.insert(var0_81, arg0_81:GetAchievement(arg0_82))
	end)
	_.each(arg1_81.config.cryptic_target, function(arg0_83)
		table.insert(var0_81, arg0_81:GetAchievement(arg0_83))
	end)

	return var0_81
end

function var0_0.IsNormalAchievementAchieved(arg0_84, arg1_84)
	return arg0_84:CountAchievements(arg1_84) >= #arg1_84.config.normal_target
end

function var0_0.AnyUnachievedAchievement(arg0_85, arg1_85)
	local var0_85 = arg0_85:GetMapAchieveStarDic(arg1_85.id)
	local var1_85 = _.detect(arg1_85:GetAchievementAwards(), function(arg0_86)
		return not var0_85[arg0_86.star]
	end)

	if var1_85 then
		local var2_85, var3_85 = arg0_85:CountAchievements(arg1_85)

		return var2_85 + var3_85 >= var1_85.star, var1_85
	end
end

function var0_0.GetFinishAchievements(arg0_87, arg1_87)
	arg1_87 = arg1_87 or arg0_87.atlas:GetAchEntranceList()

	local var0_87 = {}
	local var1_87 = {}

	for iter0_87, iter1_87 in ipairs(arg1_87) do
		local var2_87, var3_87 = arg0_87:CountAchievements(iter1_87)
		local var4_87 = arg0_87:GetMapAchieveStarDic(iter1_87.id)
		local var5_87 = {}

		for iter2_87, iter3_87 in ipairs(iter1_87:GetAchievementAwards()) do
			if not var4_87[iter3_87.star] and var2_87 + var3_87 >= iter3_87.star then
				table.insert(var5_87, iter3_87.star)
			end
		end

		if #var5_87 > 0 then
			table.insert(var0_87, {
				id = iter1_87.id,
				star_list = var5_87
			})
			table.insert(var1_87, iter1_87.id)
		end
	end

	return var0_87, var1_87
end

function var0_0.CountAchievements(arg0_88, arg1_88)
	local var0_88 = 0
	local var1_88 = 0
	local var2_88 = 0
	local var3_88 = arg1_88 and {
		arg1_88
	} or arg0_88.atlas:GetAchEntranceList()

	for iter0_88, iter1_88 in ipairs(var3_88) do
		for iter2_88, iter3_88 in ipairs(iter1_88.config.normal_target) do
			var0_88 = var0_88 + (arg0_88.achievements[iter3_88] and arg0_88.achievements[iter3_88]:IsAchieved() and 1 or 0)
		end

		for iter4_88, iter5_88 in ipairs(iter1_88.config.cryptic_target) do
			var1_88 = var1_88 + (arg0_88.achievements[iter5_88] and arg0_88.achievements[iter5_88]:IsAchieved() and 1 or 0)
		end

		var2_88 = var2_88 + #iter1_88.config.normal_target + #iter1_88.config.cryptic_target
	end

	return var0_88, var1_88, var2_88
end

local function var1_0()
	return {
		[TeamType.Main] = {},
		[TeamType.Vanguard] = {},
		[TeamType.Submarine] = {},
		commanders = {}
	}
end

function var0_0.BuildFormationIds(arg0_90)
	local var0_90 = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}
	local var1_90 = {
		[FleetType.Normal] = 2,
		[FleetType.Submarine] = 0
	}
	local var2_90 = {
		[FleetType.Normal] = 1,
		[FleetType.Submarine] = 1
	}

	for iter0_90, iter1_90 in ipairs(pg.world_stage_template) do
		if arg0_90:GetProgress() >= iter1_90.stage_key then
			var1_90[FleetType.Normal] = math.max(var1_90[FleetType.Normal], iter1_90.fleet_num)
		else
			break
		end
	end

	if arg0_90:IsSystemOpen(WorldConst.SystemSubmarine) then
		var1_90[FleetType.Submarine] = 1
	end

	for iter2_90, iter3_90 in pairs(var0_90) do
		for iter4_90 = 1, var1_90[iter2_90] do
			table.insert(iter3_90, var1_0())
		end
	end

	for iter5_90, iter6_90 in ipairs(arg0_90:IsActivate() and arg0_90:GetFleets() or arg0_90:GetDefaultFleets()) do
		local var3_90 = iter6_90:GetFleetType()
		local var4_90 = var2_90[var3_90]

		if var4_90 <= var1_90[var3_90] then
			var0_90[var3_90][var4_90] = iter6_90:BuildFormationIds()
			var2_90[var3_90] = var4_90 + 1
		end
	end

	local var5_90
	local var6_90 = arg0_90:GetTaskProxy():getTasks()

	for iter7_90, iter8_90 in pairs(var6_90) do
		if iter8_90.config.complete_condition == WorldConst.TaskTypeFleetExpansion and iter8_90:isAlive() then
			var5_90 = iter8_90.config.complete_parameter[1]

			break
		end
	end

	if var5_90 then
		for iter9_90 = #var0_90[FleetType.Normal] + 1, var5_90 do
			var0_90[FleetType.Normal][iter9_90] = var1_0()
		end
	end

	local var7_90 = 0

	for iter10_90, iter11_90 in pairs(var0_90) do
		var7_90 = var7_90 + #iter11_90
	end

	return var5_90 and WorldConst.FleetExpansion or WorldConst.FleetRedeploy, var0_90, var7_90
end

function var0_0.FormationIds2NetIds(arg0_91, arg1_91)
	local var0_91 = {}

	for iter0_91, iter1_91 in ipairs({
		FleetType.Normal,
		FleetType.Submarine
	}) do
		for iter2_91, iter3_91 in ipairs(arg1_91[iter1_91]) do
			local var1_91 = {}

			for iter4_91, iter5_91 in ipairs({
				TeamType.Main,
				TeamType.Vanguard,
				TeamType.Submarine
			}) do
				for iter6_91 = 1, 3 do
					if iter3_91[iter5_91][iter6_91] then
						table.insert(var1_91, iter3_91[iter5_91][iter6_91])
					end
				end
			end

			if #var1_91 > 0 then
				table.insert(var0_91, {
					ship_id_list = var1_91,
					commanders = Clone(iter3_91.commanders)
				})
			end
		end
	end

	return var0_91
end

function var0_0.CompareRedeploy(arg0_92, arg1_92)
	local var0_92 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}
	local var1_92 = {}
	local var2_92 = 0

	for iter0_92, iter1_92 in pairs(arg1_92) do
		for iter2_92, iter3_92 in ipairs(iter1_92) do
			for iter4_92, iter5_92 in ipairs(var0_92) do
				for iter6_92 = 1, 3 do
					local var3_92 = iter3_92[iter5_92][iter6_92]

					if var3_92 and not var1_92[var3_92] then
						var1_92[var3_92] = true
						var2_92 = var2_92 + 1
					end
				end
			end
		end
	end

	local var4_92 = {}
	local var5_92 = 0

	for iter7_92, iter8_92 in ipairs(arg0_92:GetFleets()) do
		for iter9_92, iter10_92 in ipairs(var0_92) do
			local var6_92 = iter8_92:GetTeamShips(iter10_92, true)

			for iter11_92, iter12_92 in ipairs(var6_92) do
				if not var4_92[iter12_92.id] then
					var4_92[iter12_92.id] = true
					var5_92 = var5_92 + 1
				end
			end
		end
	end

	if var5_92 ~= var2_92 then
		return true
	end

	for iter13_92, iter14_92 in pairs(var4_92) do
		if not var1_92[iter13_92] then
			return true
		end
	end

	for iter15_92, iter16_92 in pairs(var1_92) do
		if not var4_92[iter15_92] then
			return true
		end
	end

	return false
end

function var0_0.IsSystemOpen(arg0_93, arg1_93)
	local var0_93 = arg0_93:GetRealm()

	for iter0_93, iter1_93 in ipairs(pg.world_stage_template.all) do
		local var1_93 = pg.world_stage_template[iter1_93]

		if var1_93.stage_ui[1] == arg1_93 and (var1_93.stage_ui[2] == 0 or var1_93.stage_ui[2] == var0_93) then
			return arg0_93:GetProgress() >= var1_93.stage_key
		end
	end

	return true
end

function var0_0.CalcCDTimeCost(arg0_94, arg1_94, arg2_94)
	local var0_94 = math.max(pg.TimeMgr.GetInstance():GetServerTime() - arg1_94, 0)

	return math.floor(arg0_94[1] * math.max(arg0_94[2] - var0_94, 0) / arg0_94[2] * math.max(10000 - arg2_94, 0) / 10000)
end

function var0_0.GetReqCDTime(arg0_95, arg1_95)
	return arg0_95.cdTimeList[arg1_95] or 0
end

function var0_0.SetReqCDTime(arg0_96, arg1_96, arg2_96)
	arg0_96.cdTimeList[arg1_96] = arg2_96
end

function var0_0.InitWorldShopGoods(arg0_97)
	arg0_97.goodDic = {}

	for iter0_97, iter1_97 in ipairs({
		ShopArgs.WorldShop,
		ShopArgs.WorldCollection
	}) do
		for iter2_97, iter3_97 in ipairs(pg.shop_template.get_id_list_by_genre[iter1_97]) do
			arg0_97.goodDic[iter3_97] = 0
		end
	end
end

function var0_0.UpdateWorldShopGoods(arg0_98, arg1_98)
	_.each(arg1_98, function(arg0_99)
		assert(arg0_98.goodDic[arg0_99.goods_id], "without this good in id " .. arg0_99.goods_id)

		arg0_98.goodDic[arg0_99.goods_id] = arg0_98.goodDic[arg0_99.goods_id] + arg0_99.count
	end)
	arg0_98:DispatchEvent(var0_0.EventUpdateShopGoods, arg0_98.goodDic)
end

function var0_0.GetWorldShopGoodsDictionary(arg0_100)
	return arg0_100.goodDic
end

function var0_0.InitWorldColorDictionary(arg0_101)
	arg0_101.colorDic = {}

	_.each(pg.world_chapter_colormask.all, function(arg0_102)
		local var0_102 = pg.world_chapter_colormask[arg0_102]
		local var1_102 = Color.New(var0_102.color[1] / 255, var0_102.color[2] / 255, var0_102.color[3] / 255)

		arg0_101.colorDic[var1_102:ToHex()] = var0_102.id
	end)
end

function var0_0.ColorToEntrance(arg0_103, arg1_103)
	return arg0_103.colorDic[arg1_103:ToHex()] and arg0_103:GetEntrance(arg0_103.colorDic[arg1_103:ToHex()])
end

function var0_0.GetGlobalBuff(arg0_104, arg1_104)
	if not arg0_104.globalBuffDic[arg1_104] then
		local var0_104 = WorldBuff.New()

		var0_104:Setup({
			floor = 0,
			id = arg1_104
		})

		arg0_104.globalBuffDic[arg1_104] = var0_104
	end

	return arg0_104.globalBuffDic[arg1_104]
end

function var0_0.AddGlobalBuff(arg0_105, arg1_105, arg2_105)
	assert(arg1_105 and arg2_105)
	arg0_105:GetGlobalBuff(arg1_105):AddFloor(arg2_105)
	arg0_105:DispatchEvent(var0_0.EventUpdateGlobalBuff)
end

function var0_0.RemoveBuff(arg0_106, arg1_106, arg2_106)
	assert(arg1_106)

	local var0_106 = arg0_106:GetGlobalBuff(arg1_106)

	if arg2_106 then
		var0_106:AddFloor(arg2_106 * -1)
	else
		arg0_106.globalBuffDic[arg1_106] = nil
	end

	arg0_106:DispatchEvent(var0_0.EventUpdateGlobalBuff)
end

function var0_0.GetWorldMapBuffLevel(arg0_107)
	local var0_107 = pg.gameset.world_mapbuff_list.description

	return _.map(var0_107, function(arg0_108)
		return arg0_107:GetGlobalBuff(arg0_108).floor
	end)
end

function var0_0.GetWorldMapBuffAverageLevel(arg0_109)
	local var0_109 = arg0_109:GetWorldMapBuffLevel()
	local var1_109 = 0

	underscore.each(var0_109, function(arg0_110)
		var1_109 = var1_109 + arg0_110
	end)

	return var1_109 / #var0_109
end

function var0_0.GetWorldMapBuffs(arg0_111)
	local var0_111 = pg.gameset.world_mapbuff_list.description

	return _.map(var0_111, function(arg0_112)
		return arg0_111:GetGlobalBuff(arg0_112)
	end)
end

function var0_0.GetWorldMapDifficultyBuffLevel(arg0_113)
	local var0_113 = arg0_113:GetActiveMap().config.difficulty

	return pg.gameset.world_difficult_value.description[var0_113]
end

function var0_0.OnUpdateItem(arg0_114, arg1_114, arg2_114, arg3_114)
	if arg3_114:getWorldItemType() == WorldItem.UsageWorldMap and arg0_114.atlas then
		arg0_114.atlas:UpdateTreasure(arg3_114.id)
	end

	arg0_114.taskProxy:doUpdateTaskByItem(arg3_114)
end

function var0_0.OnUpdateTask(arg0_115, arg1_115, arg2_115, arg3_115)
	if arg0_115.atlas then
		arg0_115.atlas:UpdateTask(arg3_115)
	end
end

function var0_0.GetPressingAward(arg0_116, arg1_116)
	return arg0_116.pressingAwardDic[arg1_116]
end

function var0_0.FlagMapPressingAward(arg0_117, arg1_117)
	local var0_117 = arg0_117:GetPressingAward(arg1_117)

	if var0_117 then
		var0_117.flag = false
	end
end

function var0_0.IsMapPressingAwardFlag(arg0_118, arg1_118)
	local var0_118 = arg0_118:GetPressingAward(arg1_118)

	return var0_118 and var0_118.flag == false
end

function var0_0.CheckAreaUnlock(arg0_119, arg1_119)
	return arg0_119.progress >= pg.world_regions_data[arg1_119].open_stage[1]
end

function var0_0.CheckTaskLockMap(arg0_120)
	local var0_120 = arg0_120.taskProxy:getTaskVOs()
	local var1_120 = arg0_120:GetActiveMap().gid

	return _.any(var0_120, function(arg0_121)
		local var0_121 = arg0_121.config.task_target_map

		return arg0_121:isAlive() and arg0_121:IsLockMap() and _.any(var0_121, function(arg0_122)
			return arg0_122 == var1_120
		end)
	end)
end

function var0_0.CheckResetAward(arg0_123, arg1_123)
	arg0_123.resetAward = arg1_123

	if getProxy(PlayerProxy):getData():getResource(WorldConst.ResourceID) == pg.gameset.world_resource_max.key_value then
		arg0_123.resetLimitTip = true
	end
end

function var0_0.ClearResetAward(arg0_124)
	arg0_124.resetAward = nil
	arg0_124.resetLimitTip = nil
end

function var0_0.GetTargetMapPressingCount(arg0_125, arg1_125)
	local var0_125 = 0

	for iter0_125, iter1_125 in ipairs(arg1_125) do
		if arg0_125:GetMap(iter1_125).isPressing then
			var0_125 = var0_125 + 1
		end
	end

	return var0_125
end

function var0_0.ClearAllFleetDefeatEnemies(arg0_126)
	underscore.each(arg0_126:GetFleets(), function(arg0_127)
		arg0_127:ClearDefeatEnemies()
	end)
end

function var0_0.GetAreaEntranceIds(arg0_128, arg1_128)
	return arg0_128.atlas.areaEntranceList[arg1_128]
end

function var0_0.CalcOrderCost(arg0_129, arg1_129)
	local var0_129 = 0

	if arg1_129 == WorldConst.OpReqRedeploy then
		return World.CalcCDTimeCost(pg.gameset.world_fleet_redeploy_cost.description, arg0_129:GetReqCDTime(WorldConst.OpReqRedeploy), var0_129)
	elseif arg1_129 == WorldConst.OpReqMaintenance then
		return pg.gameset.world_instruction_maintenance.description[1] * math.max(10000 - var0_129, 0) / 10000
	elseif arg1_129 == WorldConst.OpReqSub then
		local var1_129 = arg0_129:GetSubmarineFleet()

		if var1_129 then
			underscore.each(var1_129:GetShips(true), function(arg0_130)
				var0_129 = var0_129 + arg0_130:GetImportWorldShipVO():GetStaminaDiscount(WorldConst.OpReqSub)
			end)
		end

		return World.CalcCDTimeCost(pg.gameset.world_instruction_submarine.description, arg0_129:GetReqCDTime(WorldConst.OpReqSub), var0_129)
	elseif arg1_129 == WorldConst.OpReqVision then
		return World.CalcCDTimeCost(pg.gameset.world_instruction_detect.description, arg0_129:GetReqCDTime(WorldConst.OpReqVision), var0_129)
	else
		assert(false, "op type error: " .. arg1_129)
	end
end

function var0_0.GetDisplayPressingCount(arg0_131)
	local var0_131 = 0

	for iter0_131, iter1_131 in ipairs(arg0_131.atlas.pressingMapList) do
		if arg0_131.atlas:GetMap(iter1_131):CheckMapPressingDisplay() then
			var0_131 = var0_131 + 1
		end
	end

	return var0_131
end

function var0_0.CheckCommanderInFleet(arg0_132, arg1_132)
	if arg0_132.type == World.TypeBase then
		return underscore.any(arg0_132.baseCmdIds, function(arg0_133)
			return arg0_133 == arg1_132
		end)
	else
		for iter0_132, iter1_132 in ipairs(arg0_132.fleets) do
			if iter1_132:HasCommander(arg1_132) then
				return true
			end
		end

		return false
	end
end

function var0_0.CheckSkipBattle(arg0_134)
	return getProxy(PlayerProxy):getRawData():CheckIdentityFlag() and world_skip_battle == 1
end

function var0_0.IsMapVisioned(arg0_135, arg1_135)
	local var0_135 = arg0_135:GetActiveMap()

	if var0_135.id == arg1_135 then
		local var1_135 = arg0_135:GetActiveEntrance()
		local var2_135, var3_135 = var0_0.ReplacementMapType(var1_135, var0_135)

		if var2_135 == "base_chapter" and var0_135.isPressing then
			return true
		elseif var2_135 == "teasure_chapter" and var3_135 == i18n("area_yinmi") and arg0_135:GetGobalFlag("treasure_flag") then
			return true
		end
	end

	return arg0_135:IsMapPressingAwardFlag(arg1_135)
end

function var0_0.HasAutoFightDrops(arg0_136)
	local var0_136 = arg0_136.autoInfos

	return #var0_136.drops > 0 or underscore.any(var0_136.salvage, function(arg0_137)
		return #arg0_137 > 0
	end) or #var0_136.buffs > 0 or #var0_136.message > 0
end

function var0_0.AddAutoInfo(arg0_138, arg1_138, arg2_138)
	if arg1_138 == "drops" then
		arg0_138.autoInfos.drops = table.mergeArray(arg0_138.autoInfos.drops, arg2_138)
	elseif arg1_138 == "salvage" then
		arg0_138.autoInfos.salvage[arg2_138.rarity] = table.mergeArray(arg0_138.autoInfos.salvage[arg2_138.rarity], arg2_138.drops)
	elseif arg1_138 == "events" then
		table.insert(arg0_138.autoInfos.events, arg2_138)
	elseif arg1_138 == "buffs" then
		table.insert(arg0_138.autoInfos.buffs, arg2_138)
	elseif arg1_138 == "message" then
		table.insert(arg0_138.autoInfos.message, arg2_138)
	else
		assert(false, "type error:" .. arg1_138)
	end
end

function var0_0.InitAutoInfos(arg0_139)
	arg0_139.autoInfos = {
		drops = {},
		salvage = {
			{},
			{},
			{}
		},
		buffs = {},
		message = {}
	}
end

function var0_0.TriggerAutoFight(arg0_140, arg1_140)
	arg1_140 = arg1_140 and arg0_140:GetActiveMap():CanAutoFight()

	if tobool(arg1_140) ~= tobool(arg0_140.isAutoFight) then
		arg0_140.isAutoFight = arg1_140

		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(arg1_140)

		if arg1_140 then
			if not LOCK_BATTERY_SAVEMODE and PlayerPrefs.GetInt(AUTOFIGHT_BATTERY_SAVEMODE, 0) == 1 and pg.BrightnessMgr.GetInstance():IsPermissionGranted() then
				pg.BrightnessMgr.GetInstance():EnterManualMode()

				if PlayerPrefs.GetInt(AUTOFIGHT_DOWN_FRAME, 0) == 1 then
					getProxy(SettingsProxy):RecordFrameRate()

					Application.targetFrameRate = 30
				end
			end
		elseif not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end

		pg.m02:sendNotification(GAME.WORLD_TRIGGER_AUTO_FIGHT)
	end

	if not arg1_140 then
		arg0_140:TriggerAutoSwitch(false)
	end
end

function var0_0.TriggerAutoSwitch(arg0_141, arg1_141)
	if tobool(arg1_141) ~= tobool(arg0_141.isAutoSwitch) then
		arg0_141.isAutoSwitch = arg1_141

		pg.m02:sendNotification(GAME.WORLD_TRIGGER_AUTO_SWITCH)
	end
end

function var0_0.GetHistoryLowestHP(arg0_142, arg1_142)
	return arg0_142.lowestHP[arg1_142] or 10000
end

function var0_0.SetHistoryLowestHP(arg0_143, arg1_143, arg2_143)
	arg0_143.lowestHP[arg1_143] = arg2_143
end

local var2_0 = {
	treasure_flag = 1
}

function var0_0.SetGlobalFlag(arg0_144, arg1_144, arg2_144)
	arg0_144.gobalFlag[var2_0[arg1_144]] = arg2_144
end

function var0_0.GetGobalFlag(arg0_145, arg1_145)
	return arg0_145.gobalFlag[var2_0[arg1_145]]
end

return var0_0
