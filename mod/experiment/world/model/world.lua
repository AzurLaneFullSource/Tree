local var0 = class("World", import("...BaseEntity"))

var0.Fields = {
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
var0.EventUpdateSubmarineSupport = "World.EventUpdateSubmarineSupport"
var0.EventSwitchMap = "World.EventSwitchMap"
var0.EventUpdateProgress = "World.EventUpdateProgress"
var0.EventUpdateShopGoods = "World.EventUpdateShopGoods"
var0.EventUpdateGlobalBuff = "World.EventUpdateGlobalBuff"
var0.EventAddPortShip = "World.EventAddPortShip"
var0.EventRemovePortShip = "World.EventRemovePortShip"
var0.EventAchieved = "World.EventAchieved"
var0.Listeners = {
	onUpdateItem = "OnUpdateItem",
	onUpdateTask = "OnUpdateTask"
}
var0.TypeBase = 0
var0.TypeFull = 1
var0.InheritNameList = {
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

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0)

	arg0.type = arg1

	arg0:InheritReset(arg2)
end

function var0.Build(arg0)
	arg0.atlas = WorldAtlas.New(WorldConst.DefaultAtlas)
	arg0.realm = 0
	arg0.fleets = {}
	arg0.defaultFleets = {}
	arg0.activateTime = 0
	arg0.expiredTime = 0
	arg0.roundIndex = nil
	arg0.submarineSupport = nil
	arg0.achievements = {}
	arg0.achieveEntranceStar = {}

	arg0:InitWorldShopGoods()
	arg0:InitWorldColorDictionary()

	arg0.activateCount = 0
	arg0.stepCount = 0
	arg0.treasureCount = 0
	arg0.progress = 0
	arg0.cdTimeList = {}
	arg0.globalBuffDic = {}
	arg0.pressingAwardDic = {}
	arg0.lowestHP = {}
	arg0.gobalFlag = {}
	arg0.isAutoFight = false

	arg0:InitAutoInfos()

	arg0.inventoryProxy = WorldInventoryProxy.New()

	arg0.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, arg0.onUpdateItem)

	arg0.taskProxy = WorldTaskProxy.New()

	arg0.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, arg0.onUpdateTask)

	arg0.baseShipIds = {}
	arg0.baseCmdIds = {}
end

function var0.Dispose(arg0, arg1)
	local var0 = arg1 and {
		realm = arg0.realm,
		defaultFleets = arg0.defaultFleets,
		achievements = arg0.achievements,
		achieveEntranceStar = arg0.achieveEntranceStar,
		activateCount = arg0.activateCount,
		progress = arg0.progress,
		staminaMgr = arg0.staminaMgr,
		collectionProxy = arg0.collectionProxy
	} or {}

	var0.worldBossProxy = arg0.worldBossProxy

	for iter0 in pairs(var0.InheritNameList) do
		if not var0[iter0] then
			arg0[iter0]:Dispose()
		end
	end

	arg0.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0.onUpdateItem)
	arg0.inventoryProxy:Dispose()
	arg0.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, arg0.onUpdateTask)
	arg0.taskProxy:Dispose()
	arg0.atlas:Dispose()
	arg0:Clear()

	return var0
end

function var0.InheritReset(arg0, arg1)
	arg1 = arg1 or {}

	if arg1.progress then
		arg0:UpdateProgress(arg1.progress)

		arg1.progress = nil
	end

	for iter0, iter1 in pairs(arg1) do
		arg0[iter0] = iter1
	end

	for iter2, iter3 in pairs(var0.InheritNameList) do
		if not arg1[iter2] then
			arg0[iter2] = iter3()
		end
	end
end

function var0.UsePortNShop(arg0)
	return arg0:IsReseted() and arg0.activateTime >= WorldConst.GetNShopTimeStamp()
end

function var0.IsReseted(arg0)
	return arg0.activateCount > (arg0:IsActivate() and 1 or 0)
end

function var0.IsActivate(arg0)
	if arg0.type == World.TypeBase then
		return #arg0.baseShipIds > 0
	else
		return tobool(arg0:GetActiveMap())
	end
end

function var0.CheckResetProgress(arg0)
	return pg.gameset.world_resetting_stage.key_value <= arg0.progress
end

function var0.GetResetWaitingTime(arg0)
	return arg0.expiredTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.CheckReset(arg0, arg1)
	return arg0:IsActivate() and (arg1 or arg0:CheckResetProgress()) and arg0:GetResetWaitingTime() < 0
end

function var0.GetAtlas(arg0)
	return arg0.atlas
end

function var0.GetEntrance(arg0, arg1)
	return arg0.atlas:GetEntrance(arg1)
end

function var0.GetActiveEntrance(arg0)
	return arg0.atlas:GetActiveEntrance()
end

function var0.GetMap(arg0, arg1)
	return arg0.atlas:GetMap(arg1)
end

function var0.GetActiveMap(arg0)
	return arg0.atlas:GetActiveMap()
end

function var0.OnSwitchMap(arg0)
	arg0:ResetRound()

	if arg0.submarineSupport then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_5"))
		arg0:ResetSubmarine()
		arg0:UpdateSubmarineSupport(false)
	end

	arg0:DispatchEvent(var0.EventSwitchMap)
	print("switch 2 map: " .. arg0:GetActiveMap().id .. ", " .. tostring(arg0:GetActiveMap().gid))
end

function var0.GetRound(arg0)
	return arg0.roundIndex % 2
end

function var0.IncRound(arg0)
	arg0.roundIndex = arg0.roundIndex + 1
end

function var0.ResetRound(arg0)
	arg0.roundIndex = 0
end

function var0.UpdateProgress(arg0, arg1)
	if arg1 > arg0.progress then
		local var0 = arg0.progress

		arg0.progress = arg1

		arg0.atlas:UpdateProgress(var0, arg1)
		arg0:DispatchEvent(var0.EventUpdateProgress)
	end
end

function var0.GetProgress(arg0)
	return arg0.progress
end

function var0.SetRealm(arg0, arg1)
	if arg0.realm ~= arg1 then
		arg0.realm = arg1
	end
end

function var0.GetRealm(arg0)
	return 1
end

function var0.CanCallSubmarineSupport(arg0)
	return arg0:GetSubmarineFleet()
end

function var0.IsSubmarineSupporting(arg0)
	return arg0.submarineSupport
end

function var0.UpdateSubmarineSupport(arg0, arg1)
	arg0.submarineSupport = arg1

	arg0:DispatchEvent(var0.EventUpdateSubmarineSupport)
end

function var0.GetSubAidFlag(arg0)
	return arg0:IsSubmarineSupporting() and arg0:GetSubmarineFleet():GetAmmo() > 0
end

function var0.ResetSubmarine(arg0)
	local var0 = arg0:GetSubmarineFleet()

	if var0 then
		var0:RepairSubmarine()
	end
end

function var0.SetFleets(arg0, arg1)
	arg0.fleets = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
end

function var0.GetFleets(arg0)
	return _.rest(arg0.fleets, 1)
end

function var0.GetFleet(arg0, arg1)
	return arg1 and _.detect(arg0.fleets, function(arg0)
		return arg0.id == arg1
	end) or arg0:GetActiveMap():GetFleet()
end

function var0.GetNormalFleets(arg0)
	return _.filter(arg0.fleets, function(arg0)
		return arg0:GetFleetType() == FleetType.Normal
	end)
end

function var0.GetSubmarineFleet(arg0)
	return _.detect(arg0.fleets, function(arg0)
		return arg0:GetFleetType() == FleetType.Submarine
	end)
end

function var0.GetShips(arg0)
	local var0 = {}

	_.each(arg0:GetFleets(), function(arg0)
		_.each(arg0:GetShips(true), function(arg0)
			table.insert(var0, arg0)
		end)
	end)

	return var0
end

function var0.GetShipVOs(arg0)
	if arg0.type == World.TypeBase then
		return underscore.map(arg0.baseShipIds, function(arg0)
			return WorldConst.FetchShipVO(arg0)
		end)
	else
		return _.map(arg0:GetShips(), function(arg0)
			return WorldConst.FetchShipVO(arg0.id)
		end)
	end
end

function var0.GetShip(arg0, arg1)
	return _.detect(arg0:GetShips(), function(arg0)
		return arg0.id == arg1
	end)
end

function var0.GetShipVO(arg0, arg1)
	local var0 = arg0:GetShip(arg1)

	return var0 and WorldConst.FetchShipVO(var0.id)
end

function var0.SetDefaultFleets(arg0, arg1)
	arg0.defaultFleets = arg1
end

function var0.GetDefaultFleets(arg0)
	return underscore.rest(arg0.defaultFleets, 1)
end

function var0.TransDefaultFleets(arg0)
	arg0.defaultFleets = underscore.map(arg0.fleets, function(arg0)
		return arg0:Trans(WorldBaseFleet)
	end)
end

function var0.GetLevel(arg0)
	return _(arg0:GetFleets()):chain():map(function(arg0)
		return arg0:GetLevel()
	end):max():value()
end

function var0.GetWorldPower(arg0)
	local var0 = 0

	underscore.each(arg0.fleets, function(arg0)
		var0 = var0 + arg0:GetGearScoreSum()
	end)

	return math.floor(var0 * (1 + arg0:GetWorldMapBuffAverageLevel() / pg.gameset.world_strength_correct.key_value))
end

function var0.GetWorldRank(arg0)
	local var0 = 0
	local var1 = underscore.map(arg0:GetNormalFleets(), function(arg0)
		return arg0:GetLevelCount() / 6
	end)
	local var2 = pg.gameset.world_level_correct.description

	for iter0, iter1 in ipairs(var1) do
		var0 = var0 + iter1 * var2[iter0]
	end

	local var3 = arg0:GetSubmarineFleet()

	if var3 then
		var0 = var0 + var3:GetLevelCount() / 3 * var2[5]
	end

	local var4 = var0 * arg0:GetWorldMapBuffAverageLevel()
	local var5
	local var6 = pg.gameset.world_suggest_level.description

	for iter2, iter3 in ipairs(var6) do
		if var4 < iter3 then
			break
		else
			var5 = iter2
		end
	end

	return var5
end

function var0.GetBossProxy(arg0)
	return arg0.worldBossProxy
end

function var0.GetTaskProxy(arg0)
	return arg0.taskProxy
end

function var0.GetInventoryProxy(arg0)
	return arg0.inventoryProxy
end

function var0.GetCollectionProxy(arg0)
	return arg0.collectionProxy
end

function var0.VerifyFormation(arg0)
	local var0 = {}

	_.each(arg0:GetShips(), function(arg0)
		var0[arg0.id] = (var0[arg0.id] or 0) + 1

		assert(var0[arg0.id] <= 1, "repeated ship id: " .. arg0.id)
	end)
end

function var0.CalcRepairCost(arg0, arg1)
	local var0 = WorldConst.FetchShipVO(arg1.id).level - arg0:GetLevel()

	if arg1:IsBroken() then
		local var1 = pg.gameset.world_port_service_2_interval.description

		return (_.detect(var1, function(arg0)
			return arg0[1] >= var0
		end) or var1[#var1])[2] * pg.gameset.world_port_service_2_price.key_value
	elseif not arg1:IsHpFull() then
		local var2 = pg.gameset.world_port_service_1_interval.description
		local var3 = pg.gameset.world_port_service_1_price.description

		return (_.detect(var2, function(arg0)
			return arg0[1] >= var0
		end) or var2[#var2])[2] * (_.detect(var3, function(arg0)
			return arg0[1] >= arg1.hpRant
		end) or var3[#var3])[2]
	end

	return 0
end

function var0.GetMoveRange(arg0, arg1)
	local var0 = arg0:GetActiveMap()

	if var0:CanLongMove(arg1) then
		return var0:GetLongMoveRange(arg1)
	else
		return var0:GetMoveRange(arg1)
	end
end

function var0.IsRookie(arg0)
	return arg0.activateCount == 0 and arg0.progress <= 0
end

function var0.EntranceToReplacementMapList(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1.config.stage_chapter) do
		if arg0:GetProgress() >= iter1[1] and arg0:GetProgress() <= iter1[2] then
			table.insert(var0, arg0:GetMap(iter1[3]))
		end
	end

	for iter2, iter3 in ipairs(arg1.config.task_chapter) do
		local var1 = arg0.taskProxy:getTaskById(iter3[1])

		if var1 and var1:isAlive() then
			table.insert(var0, arg0:GetMap(iter3[2]))
		end
	end

	if arg1.becomeSairen then
		table.insert(var0, arg0:GetMap(arg1.config.sairen_chapter[1]))
	end

	for iter4, iter5 in ipairs(arg1.config.teasure_chapter) do
		if arg0.inventoryProxy:GetItemCount(iter5[1]) > 0 then
			table.insert(var0, arg0:GetMap(iter5[2]))
		end
	end

	local var2 = arg1:GetBaseMap()

	if var2.isPressing and #arg1.config.complete_chapter > 0 then
		table.insert(var0, arg0:GetMap(arg1.config.complete_chapter[1]))
	end

	table.insert(var0, var2)

	if arg1.active and not underscore.any(var0, function(arg0)
		return arg0.active
	end) then
		table.insert(var0, arg0:GetActiveMap())
	end

	local var3 = {}

	return (underscore.filter(var0, function(arg0)
		if var3[arg0.id] then
			return false
		else
			var3[arg0.id] = true

			return true
		end
	end))
end

function var0.ReplacementMapType(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.config.stage_chapter) do
		if iter1[3] == arg1.id then
			return "stage_chapter", i18n("area_zhuxian")
		end
	end

	for iter2, iter3 in ipairs(arg0.config.task_chapter) do
		if iter3[2] == arg1.id then
			local var0 = pg.world_task_data[iter3[1]].type

			if var0 == 0 then
				return "task_chapter", i18n("area_zhuxian")
			elseif var0 == 6 then
				return "task_chapter", i18n("area_dangan")
			else
				return "task_chapter", i18n("area_renwu")
			end
		end
	end

	for iter4, iter5 in ipairs(arg0.config.teasure_chapter) do
		if iter5[2] == arg1.id then
			local var1 = pg.world_item_data_template[iter5[1]].usage_arg[1] == 1

			return "teasure_chapter", var1 and i18n("area_shenyuan") or i18n("area_yinmi")
		end
	end

	if arg0.config.sairen_chapter[1] == arg1.id then
		return "sairen_chapter", i18n("area_yaosai")
	end

	if arg0.config.complete_chapter[1] == arg1.id then
		return "complete_chapter", i18n("area_anquan")
	end

	if arg0:GetBaseMapId() == arg1.id then
		return "base_chapter", i18n("area_putong")
	end

	return "test_chapter", i18n("area_unkown")
end

function var0.FindTreasureEntrance(arg0, arg1)
	return underscore.values(arg0.atlas:GetTreasureDic(arg1))[1]
end

function var0.TreasureMap2ItemId(arg0, arg1, arg2)
	local var0 = arg0:GetEntrance(arg2)

	for iter0, iter1 in ipairs(var0.config.teasure_chapter) do
		if iter1[2] == arg1 then
			return iter1[1]
		end
	end
end

function var0.CheckFleetMovable(arg0)
	local var0 = arg0:GetActiveMap()
	local var1 = var0:GetFleet()

	return arg0:GetRound() == WorldConst.RoundPlayer and var0:CheckFleetMovable(var1) and not var0:CheckInteractive()
end

function var0.SetAchieveSuccess(arg0, arg1, arg2)
	arg0.achieveEntranceStar[arg1] = arg0.achieveEntranceStar[arg1] or {}
	arg0.achieveEntranceStar[arg1][arg2] = true
end

function var0.GetMapAchieveStarDic(arg0, arg1)
	return arg0.achieveEntranceStar[arg1] or {}
end

function var0.GetAchievement(arg0, arg1)
	if not arg0.achievements[arg1] then
		arg0.achievements[arg1] = WorldAchievement.New()

		arg0.achievements[arg1]:Setup(arg1)
	end

	return arg0.achievements[arg1]
end

function var0.GetAchievements(arg0, arg1)
	local var0 = {}

	_.each(arg1.config.normal_target, function(arg0)
		table.insert(var0, arg0:GetAchievement(arg0))
	end)
	_.each(arg1.config.cryptic_target, function(arg0)
		table.insert(var0, arg0:GetAchievement(arg0))
	end)

	return var0
end

function var0.IsNormalAchievementAchieved(arg0, arg1)
	return arg0:CountAchievements(arg1) >= #arg1.config.normal_target
end

function var0.AnyUnachievedAchievement(arg0, arg1)
	local var0 = arg0:GetMapAchieveStarDic(arg1.id)
	local var1 = _.detect(arg1:GetAchievementAwards(), function(arg0)
		return not var0[arg0.star]
	end)

	if var1 then
		local var2, var3 = arg0:CountAchievements(arg1)

		return var2 + var3 >= var1.star, var1
	end
end

function var0.GetFinishAchievements(arg0, arg1)
	arg1 = arg1 or arg0.atlas:GetAchEntranceList()

	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var2, var3 = arg0:CountAchievements(iter1)
		local var4 = arg0:GetMapAchieveStarDic(iter1.id)
		local var5 = {}

		for iter2, iter3 in ipairs(iter1:GetAchievementAwards()) do
			if not var4[iter3.star] and var2 + var3 >= iter3.star then
				table.insert(var5, iter3.star)
			end
		end

		if #var5 > 0 then
			table.insert(var0, {
				id = iter1.id,
				star_list = var5
			})
			table.insert(var1, iter1.id)
		end
	end

	return var0, var1
end

function var0.CountAchievements(arg0, arg1)
	local var0 = 0
	local var1 = 0
	local var2 = 0
	local var3 = arg1 and {
		arg1
	} or arg0.atlas:GetAchEntranceList()

	for iter0, iter1 in ipairs(var3) do
		for iter2, iter3 in ipairs(iter1.config.normal_target) do
			var0 = var0 + (arg0.achievements[iter3] and arg0.achievements[iter3]:IsAchieved() and 1 or 0)
		end

		for iter4, iter5 in ipairs(iter1.config.cryptic_target) do
			var1 = var1 + (arg0.achievements[iter5] and arg0.achievements[iter5]:IsAchieved() and 1 or 0)
		end

		var2 = var2 + #iter1.config.normal_target + #iter1.config.cryptic_target
	end

	return var0, var1, var2
end

local function var1()
	return {
		[TeamType.Main] = {},
		[TeamType.Vanguard] = {},
		[TeamType.Submarine] = {},
		commanders = {}
	}
end

function var0.BuildFormationIds(arg0)
	local var0 = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}
	local var1 = {
		[FleetType.Normal] = 2,
		[FleetType.Submarine] = 0
	}
	local var2 = {
		[FleetType.Normal] = 1,
		[FleetType.Submarine] = 1
	}

	for iter0, iter1 in ipairs(pg.world_stage_template) do
		if arg0:GetProgress() >= iter1.stage_key then
			var1[FleetType.Normal] = math.max(var1[FleetType.Normal], iter1.fleet_num)
		else
			break
		end
	end

	if arg0:IsSystemOpen(WorldConst.SystemSubmarine) then
		var1[FleetType.Submarine] = 1
	end

	for iter2, iter3 in pairs(var0) do
		for iter4 = 1, var1[iter2] do
			table.insert(iter3, var1())
		end
	end

	for iter5, iter6 in ipairs(arg0:IsActivate() and arg0:GetFleets() or arg0:GetDefaultFleets()) do
		local var3 = iter6:GetFleetType()
		local var4 = var2[var3]

		if var4 <= var1[var3] then
			var0[var3][var4] = iter6:BuildFormationIds()
			var2[var3] = var4 + 1
		end
	end

	local var5
	local var6 = arg0:GetTaskProxy():getTasks()

	for iter7, iter8 in pairs(var6) do
		if iter8.config.complete_condition == WorldConst.TaskTypeFleetExpansion and iter8:isAlive() then
			var5 = iter8.config.complete_parameter[1]

			break
		end
	end

	if var5 then
		for iter9 = #var0[FleetType.Normal] + 1, var5 do
			var0[FleetType.Normal][iter9] = var1()
		end
	end

	local var7 = 0

	for iter10, iter11 in pairs(var0) do
		var7 = var7 + #iter11
	end

	return var5 and WorldConst.FleetExpansion or WorldConst.FleetRedeploy, var0, var7
end

function var0.FormationIds2NetIds(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs({
		FleetType.Normal,
		FleetType.Submarine
	}) do
		for iter2, iter3 in ipairs(arg1[iter1]) do
			local var1 = {}

			for iter4, iter5 in ipairs({
				TeamType.Main,
				TeamType.Vanguard,
				TeamType.Submarine
			}) do
				for iter6 = 1, 3 do
					if iter3[iter5][iter6] then
						table.insert(var1, iter3[iter5][iter6])
					end
				end
			end

			if #var1 > 0 then
				table.insert(var0, {
					ship_id_list = var1,
					commanders = Clone(iter3.commanders)
				})
			end
		end
	end

	return var0
end

function var0.CompareRedeploy(arg0, arg1)
	local var0 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}
	local var1 = {}
	local var2 = 0

	for iter0, iter1 in pairs(arg1) do
		for iter2, iter3 in ipairs(iter1) do
			for iter4, iter5 in ipairs(var0) do
				for iter6 = 1, 3 do
					local var3 = iter3[iter5][iter6]

					if var3 and not var1[var3] then
						var1[var3] = true
						var2 = var2 + 1
					end
				end
			end
		end
	end

	local var4 = {}
	local var5 = 0

	for iter7, iter8 in ipairs(arg0:GetFleets()) do
		for iter9, iter10 in ipairs(var0) do
			local var6 = iter8:GetTeamShips(iter10, true)

			for iter11, iter12 in ipairs(var6) do
				if not var4[iter12.id] then
					var4[iter12.id] = true
					var5 = var5 + 1
				end
			end
		end
	end

	if var5 ~= var2 then
		return true
	end

	for iter13, iter14 in pairs(var4) do
		if not var1[iter13] then
			return true
		end
	end

	for iter15, iter16 in pairs(var1) do
		if not var4[iter15] then
			return true
		end
	end

	return false
end

function var0.IsSystemOpen(arg0, arg1)
	local var0 = arg0:GetRealm()

	for iter0, iter1 in ipairs(pg.world_stage_template.all) do
		local var1 = pg.world_stage_template[iter1]

		if var1.stage_ui[1] == arg1 and (var1.stage_ui[2] == 0 or var1.stage_ui[2] == var0) then
			return arg0:GetProgress() >= var1.stage_key
		end
	end

	return true
end

function var0.CalcCDTimeCost(arg0, arg1, arg2)
	local var0 = math.max(pg.TimeMgr.GetInstance():GetServerTime() - arg1, 0)

	return math.floor(arg0[1] * math.max(arg0[2] - var0, 0) / arg0[2] * math.max(10000 - arg2, 0) / 10000)
end

function var0.GetReqCDTime(arg0, arg1)
	return arg0.cdTimeList[arg1] or 0
end

function var0.SetReqCDTime(arg0, arg1, arg2)
	arg0.cdTimeList[arg1] = arg2
end

function var0.InitWorldShopGoods(arg0)
	arg0.goodDic = {}

	for iter0, iter1 in ipairs({
		ShopArgs.WorldShop,
		ShopArgs.WorldCollection
	}) do
		for iter2, iter3 in ipairs(pg.shop_template.get_id_list_by_genre[iter1]) do
			arg0.goodDic[iter3] = 0
		end
	end
end

function var0.UpdateWorldShopGoods(arg0, arg1)
	_.each(arg1, function(arg0)
		assert(arg0.goodDic[arg0.goods_id], "without this good in id " .. arg0.goods_id)

		arg0.goodDic[arg0.goods_id] = arg0.goodDic[arg0.goods_id] + arg0.count
	end)
	arg0:DispatchEvent(var0.EventUpdateShopGoods, arg0.goodDic)
end

function var0.GetWorldShopGoodsDictionary(arg0)
	return arg0.goodDic
end

function var0.InitWorldColorDictionary(arg0)
	arg0.colorDic = {}

	_.each(pg.world_chapter_colormask.all, function(arg0)
		local var0 = pg.world_chapter_colormask[arg0]
		local var1 = Color.New(var0.color[1] / 255, var0.color[2] / 255, var0.color[3] / 255)

		arg0.colorDic[var1:ToHex()] = var0.id
	end)
end

function var0.ColorToEntrance(arg0, arg1)
	return arg0.colorDic[arg1:ToHex()] and arg0:GetEntrance(arg0.colorDic[arg1:ToHex()])
end

function var0.GetGlobalBuff(arg0, arg1)
	if not arg0.globalBuffDic[arg1] then
		local var0 = WorldBuff.New()

		var0:Setup({
			floor = 0,
			id = arg1
		})

		arg0.globalBuffDic[arg1] = var0
	end

	return arg0.globalBuffDic[arg1]
end

function var0.AddGlobalBuff(arg0, arg1, arg2)
	assert(arg1 and arg2)
	arg0:GetGlobalBuff(arg1):AddFloor(arg2)
	arg0:DispatchEvent(var0.EventUpdateGlobalBuff)
end

function var0.RemoveBuff(arg0, arg1, arg2)
	assert(arg1)

	local var0 = arg0:GetGlobalBuff(arg1)

	if arg2 then
		var0:AddFloor(arg2 * -1)
	else
		arg0.globalBuffDic[arg1] = nil
	end

	arg0:DispatchEvent(var0.EventUpdateGlobalBuff)
end

function var0.GetWorldMapBuffLevel(arg0)
	local var0 = pg.gameset.world_mapbuff_list.description

	return _.map(var0, function(arg0)
		return arg0:GetGlobalBuff(arg0).floor
	end)
end

function var0.GetWorldMapBuffAverageLevel(arg0)
	local var0 = arg0:GetWorldMapBuffLevel()
	local var1 = 0

	underscore.each(var0, function(arg0)
		var1 = var1 + arg0
	end)

	return var1 / #var0
end

function var0.GetWorldMapBuffs(arg0)
	local var0 = pg.gameset.world_mapbuff_list.description

	return _.map(var0, function(arg0)
		return arg0:GetGlobalBuff(arg0)
	end)
end

function var0.GetWorldMapDifficultyBuffLevel(arg0)
	local var0 = arg0:GetActiveMap().config.difficulty

	return pg.gameset.world_difficult_value.description[var0]
end

function var0.OnUpdateItem(arg0, arg1, arg2, arg3)
	if arg3:getWorldItemType() == WorldItem.UsageWorldMap and arg0.atlas then
		arg0.atlas:UpdateTreasure(arg3.id)
	end

	arg0.taskProxy:doUpdateTaskByItem(arg3)
end

function var0.OnUpdateTask(arg0, arg1, arg2, arg3)
	if arg0.atlas then
		arg0.atlas:UpdateTask(arg3)
	end
end

function var0.GetPressingAward(arg0, arg1)
	return arg0.pressingAwardDic[arg1]
end

function var0.FlagMapPressingAward(arg0, arg1)
	local var0 = arg0:GetPressingAward(arg1)

	if var0 then
		var0.flag = false
	end
end

function var0.IsMapPressingAwardFlag(arg0, arg1)
	local var0 = arg0:GetPressingAward(arg1)

	return var0 and var0.flag == false
end

function var0.CheckAreaUnlock(arg0, arg1)
	return arg0.progress >= pg.world_regions_data[arg1].open_stage[1]
end

function var0.CheckTaskLockMap(arg0)
	local var0 = arg0.taskProxy:getTaskVOs()
	local var1 = arg0:GetActiveMap().gid

	return _.any(var0, function(arg0)
		local var0 = arg0.config.task_target_map

		return arg0:isAlive() and arg0:IsLockMap() and _.any(var0, function(arg0)
			return arg0 == var1
		end)
	end)
end

function var0.CheckResetAward(arg0, arg1)
	arg0.resetAward = arg1

	if getProxy(PlayerProxy):getData():getResource(WorldConst.ResourceID) == pg.gameset.world_resource_max.key_value then
		arg0.resetLimitTip = true
	end
end

function var0.ClearResetAward(arg0)
	arg0.resetAward = nil
	arg0.resetLimitTip = nil
end

function var0.GetTargetMapPressingCount(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg1) do
		if arg0:GetMap(iter1).isPressing then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.ClearAllFleetDefeatEnemies(arg0)
	underscore.each(arg0:GetFleets(), function(arg0)
		arg0:ClearDefeatEnemies()
	end)
end

function var0.GetAreaEntranceIds(arg0, arg1)
	return arg0.atlas.areaEntranceList[arg1]
end

function var0.CalcOrderCost(arg0, arg1)
	local var0 = 0

	if arg1 == WorldConst.OpReqRedeploy then
		return World.CalcCDTimeCost(pg.gameset.world_fleet_redeploy_cost.description, arg0:GetReqCDTime(WorldConst.OpReqRedeploy), var0)
	elseif arg1 == WorldConst.OpReqMaintenance then
		return pg.gameset.world_instruction_maintenance.description[1] * math.max(10000 - var0, 0) / 10000
	elseif arg1 == WorldConst.OpReqSub then
		local var1 = arg0:GetSubmarineFleet()

		if var1 then
			underscore.each(var1:GetShips(true), function(arg0)
				var0 = var0 + arg0:GetImportWorldShipVO():GetStaminaDiscount(WorldConst.OpReqSub)
			end)
		end

		return World.CalcCDTimeCost(pg.gameset.world_instruction_submarine.description, arg0:GetReqCDTime(WorldConst.OpReqSub), var0)
	elseif arg1 == WorldConst.OpReqVision then
		return World.CalcCDTimeCost(pg.gameset.world_instruction_detect.description, arg0:GetReqCDTime(WorldConst.OpReqVision), var0)
	else
		assert(false, "op type error: " .. arg1)
	end
end

function var0.GetDisplayPressingCount(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.atlas.pressingMapList) do
		if arg0.atlas:GetMap(iter1):CheckMapPressingDisplay() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.CheckCommanderInFleet(arg0, arg1)
	if arg0.type == World.TypeBase then
		return underscore.any(arg0.baseCmdIds, function(arg0)
			return arg0 == arg1
		end)
	else
		for iter0, iter1 in ipairs(arg0.fleets) do
			if iter1:HasCommander(arg1) then
				return true
			end
		end

		return false
	end
end

function var0.CheckSkipBattle(arg0)
	return getProxy(PlayerProxy):getRawData():CheckIdentityFlag() and world_skip_battle == 1
end

function var0.IsMapVisioned(arg0, arg1)
	local var0 = arg0:GetActiveMap()

	if var0.id == arg1 then
		local var1 = arg0:GetActiveEntrance()
		local var2, var3 = var0.ReplacementMapType(var1, var0)

		if var2 == "base_chapter" and var0.isPressing then
			return true
		elseif var2 == "teasure_chapter" and var3 == i18n("area_yinmi") and arg0:GetGobalFlag("treasure_flag") then
			return true
		end
	end

	return arg0:IsMapPressingAwardFlag(arg1)
end

function var0.HasAutoFightDrops(arg0)
	local var0 = arg0.autoInfos

	return #var0.drops > 0 or underscore.any(var0.salvage, function(arg0)
		return #arg0 > 0
	end) or #var0.buffs > 0 or #var0.message > 0
end

function var0.AddAutoInfo(arg0, arg1, arg2)
	if arg1 == "drops" then
		arg0.autoInfos.drops = table.mergeArray(arg0.autoInfos.drops, arg2)
	elseif arg1 == "salvage" then
		arg0.autoInfos.salvage[arg2.rarity] = table.mergeArray(arg0.autoInfos.salvage[arg2.rarity], arg2.drops)
	elseif arg1 == "events" then
		table.insert(arg0.autoInfos.events, arg2)
	elseif arg1 == "buffs" then
		table.insert(arg0.autoInfos.buffs, arg2)
	elseif arg1 == "message" then
		table.insert(arg0.autoInfos.message, arg2)
	else
		assert(false, "type error:" .. arg1)
	end
end

function var0.InitAutoInfos(arg0)
	arg0.autoInfos = {
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

function var0.TriggerAutoFight(arg0, arg1)
	arg1 = arg1 and arg0:GetActiveMap():CanAutoFight()

	if tobool(arg1) ~= tobool(arg0.isAutoFight) then
		arg0.isAutoFight = arg1

		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(arg1)

		if arg1 then
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

	if not arg1 then
		arg0:TriggerAutoSwitch(false)
	end
end

function var0.TriggerAutoSwitch(arg0, arg1)
	if tobool(arg1) ~= tobool(arg0.isAutoSwitch) then
		arg0.isAutoSwitch = arg1

		pg.m02:sendNotification(GAME.WORLD_TRIGGER_AUTO_SWITCH)
	end
end

function var0.GetHistoryLowestHP(arg0, arg1)
	return arg0.lowestHP[arg1] or 10000
end

function var0.SetHistoryLowestHP(arg0, arg1, arg2)
	arg0.lowestHP[arg1] = arg2
end

local var2 = {
	treasure_flag = 1
}

function var0.SetGlobalFlag(arg0, arg1, arg2)
	arg0.gobalFlag[var2[arg1]] = arg2
end

function var0.GetGobalFlag(arg0, arg1)
	return arg0.gobalFlag[var2[arg1]]
end

return var0
