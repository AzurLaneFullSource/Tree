local var0 = class("WorldProxy", import(".NetProxy"))

function var0.register(arg0)
	WPool = BaseEntityPool.New()
	WBank = BaseEntityBank.New()

	arg0:BuildTestFunc()
	arg0:on(33114, function(arg0)
		arg0.isProtoLock = arg0.is_world_open == 0

		arg0:BuildWorld(World.TypeBase)

		arg0.world.baseShipIds = underscore.rest(arg0.ship_id_list, 1)
		arg0.world.baseCmdIds = underscore.rest(arg0.cmd_id_list, 1)

		arg0.world:UpdateProgress(arg0.progress)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
		arg0:sendNotification(GAME.WORLD_GET_BOSS)
	end)
	arg0:on(33105, function(arg0)
		local var0 = arg0.world:GetActiveMap()

		assert(var0, "active map not exist.")

		local var1 = arg0:NetBuildMapAttachmentCells(arg0.pos_list)

		arg0:UpdateMapAttachmentCells(var0.id, var1)

		local var2 = arg0:NetBuildFleetAttachUpdate(arg0.pos_list)

		arg0:ApplyFleetAttachUpdate(var0.id, var2)
		WPool:ReturnArray(var2)
	end)
	arg0:on(33203, function(arg0)
		local var0 = arg0.world:GetTaskProxy()

		for iter0, iter1 in ipairs(arg0.update_list) do
			local var1 = WorldTask.New(iter1)

			if var0:getTaskById(var1.id) then
				var0:updateTask(var1)
			else
				var0:addTask(var1)
				arg0:sendNotification(GAME.WORLD_TRIGGER_TASK_DONE, {
					task = var1
				})
			end
		end
	end)
	arg0:on(33204, function(arg0)
		local var0 = arg0.world:GetTaskProxy()

		for iter0, iter1 in ipairs(arg0.delete_list) do
			var0:deleteTask(iter1)
		end
	end)
	arg0:on(33601, function(arg0)
		arg0:NetUpdateAchievements(arg0.target_list)
	end)
	arg0:on(34507, function(arg0)
		if arg0.world then
			local var0 = arg0.world:GetBossProxy()
			local var1 = WorldBoss.New()

			var1:Setup(arg0.boss_info, Player.New(arg0.user_info))
			var1:UpdateBossType(arg0.type)
			var1:SetJoinTime(pg.TimeMgr.GetInstance():GetServerTime())

			if var0.isSetup then
				var0:ClearRank(var1.id)
				var0:UpdateCacheBoss(var1)
			end

			if not var0:IsSelfBoss(var1) and arg0.world:IsSystemOpen(WorldConst.SystemWorldBoss) then
				pg.WorldBossTipMgr.GetInstance():Show(var1)
			end
		end
	end)
	arg0:on(34508, function(arg0)
		local var0 = arg0.world:GetBossProxy()

		if var0.isSetup then
			arg0:sendNotification(GAME.WORLD_GET_BOSS_RANK, {
				bossId = arg0.boss_id,
				callback = function()
					var0:updateBossHp(arg0.boss_id, arg0.hp)
				end
			})
		end
	end)
end

function var0.remove(arg0)
	if arg0.world then
		arg0.world:GetBossProxy():Dispose()
	end

	removeWorld()
	WPool:Dispose()

	WPool = nil

	WBank:Dispose()

	WBank = nil
end

function var0.BuildTestFunc(arg0)
	world_skip_battle = PlayerPrefs.GetInt("world_skip_battle") or 0

	function switch_world_skip_battle()
		if getProxy(PlayerProxy):getRawData():CheckIdentityFlag() then
			world_skip_battle = 1 - world_skip_battle

			PlayerPrefs.SetInt("world_skip_battle", world_skip_battle)
			PlayerPrefs.Save()
			pg.TipsMgr.GetInstance():ShowTips(world_skip_battle == 1 and "已开启大世界战斗跳略" or "已关闭大世界战斗跳略")
		end
	end

	if IsUnityEditor then
		function display_world_debug_panel()
			local var0 = pg.m02:retrieveMediator(WorldMediator.__cname)

			if var0 then
				var0.viewComponent:ShowSubView("DebugPanel")
			end
		end

		pg.UIMgr.GetInstance():AddWorldTestButton("WorldDebug", function()
			WorldConst.Debug = true
		end)
	end
end

function var0.BuildWorld(arg0, arg1, arg2)
	arg0.world = World.New(arg1, arg0.world and arg0.world:Dispose(tobool(arg2)))

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
end

function var0.NetFullUpdate(arg0, arg1)
	arg0.isProtoLock = arg1.is_world_open == 0

	arg0:NetUpdateWorld(arg1.world, arg1.global_flag_list, arg1.camp)
	arg0:NetUpdateWorldDefaultFleets(arg1.fleet_list)
	arg0:NetUpdateWorldAchievements(arg1.target_list, arg1.target_fetch_list)
	arg0:NetUpdateWorldCountInfo(arg1.count_info)
	arg0:NetUpdateWorldMapPressing(arg1.clean_chapter)
	arg0:NetUpdateWorldPressingAward(arg1.chapter_award)
	arg0:NetUpdateWorldShopGoods(arg1.out_shop_buy_list)
	arg0:NetUpdateWorldPortShopMark(arg1.port_list, arg1.new_flag_port_list)
end

function var0.NetUpdateWorld(arg0, arg1, arg2, arg3)
	local var0 = arg0.world

	var0:SetRealm(arg3)

	var0.activateTime = arg1.time
	var0.expiredTime = arg1.last_change_group_timestamp
	var0.roundIndex = arg1.round
	var0.submarineSupport = arg1.submarine_state == 1

	var0.staminaMgr:Setup({
		arg1.action_power,
		arg1.action_power_extra,
		arg1.last_recover_timestamp,
		arg1.action_power_fetch_count
	})

	var0.gobalFlag = underscore.map(arg2, function(arg0)
		return arg0 > 0
	end)

	local var1 = var0:GetAtlas()

	var1:SetCostMapList(_.rest(arg1.chapter_list, 1))
	var1:SetSairenEntranceList(_.rest(arg1.sairen_chapter, 1))
	var1:InitWorldNShopGoods(arg1.goods_list)
	var0:SetFleets(arg0:NetBuildMapFleetList(arg1.group_list))

	local var2 = arg1.map_id > 0 and _.detect(arg1.chapter_list, function(arg0)
		return arg0.random_id == arg1.map_id
	end)

	assert(arg1.map_id > 0 == tobool(var2), "error active map info:" .. arg1.map_id)

	if var2 then
		local var3 = arg1.enter_map_id
		local var4 = var2.random_id
		local var5 = var2.template_id
		local var6 = var0:GetEntrance(var3)
		local var7 = var0:GetMap(var4)

		assert(var6, "entrance not exist: " .. var3)
		assert(var7, "map not exist: " .. var4)
		assert(pg.world_chapter_template[var5], "world_chapter_template not exist: " .. var5)
		assert(#arg1.group_list > 0, "amount of group_list is not enough.")
		var6:UpdateActive(true)
		var7:UpdateGridId(var5)

		local var8 = arg1.group_list[1].id

		var7.findex = table.indexof(var0.fleets, var0:GetFleet(var8))

		var7:BindFleets(var0.fleets)
		var7:UpdateActive(true)
	end

	var0:GetInventoryProxy():Setup(arg1.item_list)

	local var9 = var0:GetTaskProxy()

	var9:Setup(arg1.task_list)

	var9.taskFinishCount = arg1.task_finish_count

	_.each(arg1.cd_list, function(arg0)
		var0.cdTimeList[arg0.id] = arg0.time
	end)
	_.each(arg1.buff_list, function(arg0)
		var0.globalBuffDic[arg0.id] = WorldBuff.New()

		var0.globalBuffDic[arg0.id]:Setup({
			id = arg0.id,
			floor = arg0.stack
		})
	end)
	underscore.each(arg1.month_boss, function(arg0)
		var0.lowestHP[arg0.key] = arg0.value
	end)
end

function var0.NetUpdateWorldDefaultFleets(arg0, arg1)
	local var0 = {}

	_.each(arg1, function(arg0)
		local var0 = WorldBaseFleet.New()

		var0:Setup(arg0)
		table.insert(var0, var0)
	end)
	table.sort(var0, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	arg0.world:SetDefaultFleets(var0)
end

function var0.NetUpdateWorldAchievements(arg0, arg1, arg2)
	arg0.world.achievements = {}

	arg0:NetUpdateAchievements(arg1)

	arg0.world.achieveEntranceStar = {}

	_.each(arg2, function(arg0)
		for iter0, iter1 in ipairs(arg0.star_list) do
			arg0.world:SetAchieveSuccess(arg0.id, iter1)
		end
	end)
end

function var0.NetUpdateWorldCountInfo(arg0, arg1)
	arg0.world.stepCount = arg1.step_count
	arg0.world.treasureCount = arg1.treasure_count
	arg0.world.activateCount = arg1.activate_count

	arg0.world:GetCollectionProxy():Setup(arg1.collection_list)
	arg0.world:UpdateProgress(arg1.task_progress)
end

function var0.NetUpdateActiveMap(arg0, arg1, arg2, arg3)
	local var0 = arg0.world:GetActiveEntrance()
	local var1 = arg0.world:GetActiveMap()

	if var1:NeedClear() and var0.becomeSairen and var0:GetSairenMapId() == var1.id then
		arg0.world:GetAtlas():RemoveSairenEntrance(var0)
	end

	local var2 = arg0.world:GetEntrance(arg1)

	assert(var2, "entrance not exist: " .. arg1)

	if var0.id ~= var2.id then
		var0:UpdateActive(false)
		var2:UpdateActive(true)
	end

	local var3 = arg0.world:GetMap(arg2)

	assert(var3, "map not exist: " .. arg2)

	if var1.id ~= var3.id then
		var1:UpdateActive(false)
		var1:RemoveFleetsCarries()
		var1:UnbindFleets()

		var3.findex = var1.findex
		var1.findex = nil

		var3:UpdateGridId(arg3)
		var3:BindFleets(arg0.world.fleets)
		var3:UpdateActive(true)
	end

	arg0.world:OnSwitchMap()
end

function var0.NetUpdateMap(arg0, arg1)
	local var0 = arg1.id.random_id
	local var1 = arg1.id.template_id

	assert(pg.world_chapter_random[var0], "world_chapter_random not exist: " .. var0)
	assert(pg.world_chapter_template[var1], "world_chapter_template not exist: " .. var1)

	local var2 = {}

	_.each(arg1.state_flag, function(arg0)
		var2[arg0] = true
	end)

	local var3 = arg0.world:GetMap(var0)

	var3:UpdateClearFlag(var2[1])
	var3:UpdateVisionFlag(var2[2] or arg0.world:IsMapVisioned(var0))
	arg0:NetUpdateMapDiscoveredCells(var3.id, var2[3], arg1.cell_list)

	local var4 = arg0:NetBuildMapAttachmentCells(arg1.pos_list)

	arg0:UpdateMapAttachmentCells(var3.id, var4)

	local var5 = arg0:NetBuildFleetAttachUpdate(arg1.pos_list)

	arg0:ApplyFleetAttachUpdate(var3.id, var5)
	WPool:ReturnArray(var5)

	local var6 = arg0:NetBulidTerrainUpdate(arg1.land_list)

	arg0:ApplyTerrainUpdate(var3.id, var6)
	WPool:ReturnArray(var6)
	var3:SetValid(true)
end

function var0.NetUpdateMapDiscoveredCells(arg0, arg1, arg2, arg3)
	local var0 = arg0.world:GetMap(arg1)

	assert(var0, "map not exist: " .. arg1)

	if arg2 then
		for iter0, iter1 in pairs(var0.cells) do
			iter1:UpdateDiscovered(true)
		end
	else
		_.each(arg3, function(arg0)
			local var0 = var0:GetCell(arg0.pos.row, arg0.pos.column)

			assert(var0, "cell not exist: " .. arg0.pos.row .. ", " .. arg0.pos.column)
			var0:UpdateDiscovered(true)
		end)
	end
end

function var0.NetUpdateMapPort(arg0, arg1, arg2)
	local var0 = arg0.world:GetMap(arg1)

	assert(var0, "map not exist: " .. arg1)

	local var1 = var0:GetPort(arg2.port_id)

	assert(var1, "port not exist: " .. arg2.port_id)
	var1:UpdateTaskIds(_.rest(arg2.task_list, 1))
	var1:UpdateGoods(_.map(arg2.goods_list, function(arg0)
		local var0 = WPool:Get(WorldGoods)

		var0:Setup(arg0)

		return var0
	end))
	var1:UpdateExpiredTime(arg2.next_refresh_time)
end

function var0.NetUpdateAchievements(arg0, arg1)
	_.each(arg1, function(arg0)
		local var0 = arg0.world:GetAchievement(arg0.id)

		arg0.world:DispatchEvent(World.EventAchieved, var0:NetUpdate(arg0.process_list))
	end)
end

function var0.NetBuildMapFleetList(arg0, arg1)
	local var0 = {}

	if arg1 and #arg1 > 0 then
		_.each(arg1, function(arg0)
			local var0 = WorldMapFleet.New()

			var0:Setup(arg0)
			table.insert(var0, var0)
		end)
		table.sort(var0, function(arg0, arg1)
			return arg0.id < arg1.id
		end)

		local var1 = {
			[FleetType.Normal] = 1,
			[FleetType.Submarine] = 1
		}

		_.each(var0, function(arg0)
			local var0 = arg0:GetFleetType()

			arg0.index = var1[var0]
			var1[var0] = var1[var0] + 1
		end)
	end

	return var0
end

function var0.NetBuildPortShipList(arg0, arg1)
	return _.map(arg1, function(arg0)
		local var0 = WPool:Get(WorldMapShip)

		var0:Setup(arg0)

		return var0
	end)
end

function var0.NetResetWorld(arg0)
	arg0:sendNotification(GAME.SEND_CMD, {
		cmd = "world",
		arg1 = "reset"
	})
	arg0:sendNotification(GAME.SEND_CMD, {
		cmd = "kick"
	})
end

function var0.NetBuildMapAttachmentCells(arg0, arg1)
	local var0 = {}

	_.each(arg1, function(arg0)
		var0[WorldMapCell.GetName(arg0.pos.row, arg0.pos.column)] = {
			pos = {
				row = arg0.pos.row,
				column = arg0.pos.column
			},
			attachmentList = arg0.item_list
		}
	end)

	for iter0, iter1 in pairs(var0) do
		local var1 = {}

		_.each(iter1.attachmentList, function(arg0)
			local var0 = WPool:Get(WorldMapAttachment)

			var0:Setup(setmetatable({
				pos = iter1.pos
			}, {
				__index = arg0
			}))
			table.insert(var1, var0)
		end)

		iter1.attachmentList = var1
	end

	return var0
end

function var0.UpdateMapAttachmentCells(arg0, arg1, arg2)
	local var0 = arg0.world:GetMap(arg1)

	assert(var0, "map not exist: " .. arg1)

	for iter0, iter1 in pairs(arg2) do
		local var1 = var0:GetCell(iter1.pos.row, iter1.pos.column)
		local var2 = var1.attachments

		for iter2 = #var2, 1, -1 do
			local var3 = var2[iter2]

			if not WorldMapAttachment.IsFakeType(var2[iter2].type) and not _.any(iter1.attachmentList, function(arg0)
				return var3.type == arg0.type and var3.id == arg0.id
			end) then
				var1:RemoveAttachment(iter2)
			end
		end

		_.each(iter1.attachmentList, function(arg0)
			if arg0.type ~= WorldMapAttachment.TypeFleet then
				local var0 = _.detect(var1.attachments, function(arg0)
					return arg0.type == arg0.type and arg0.id == arg0.id
				end)

				if var0 then
					var0:UpdateFlag(arg0.flag)
					var0:UpdateData(arg0.data, arg0.effects)
					var0:AddPhaseDisplay(var0:UpdateBuffList(arg0.buffList))
				else
					var1:AddAttachment(arg0)
				end
			end
		end)
	end
end

function var0.NetBuildFleetAttachUpdate(arg0, arg1)
	local var0 = {}

	_.each(arg1, function(arg0)
		local var0 = {
			row = arg0.pos.row,
			column = arg0.pos.column
		}

		_.each(arg0.item_list, function(arg0)
			if arg0.item_type == WorldMapAttachment.TypeFleet then
				local var0 = WPool:Get(NetFleetAttachUpdate)

				var0:Setup(setmetatable({
					pos = var0
				}, {
					__index = arg0
				}))
				table.insert(var0, var0)
			end
		end)
	end)

	return var0
end

function var0.ApplyFleetAttachUpdate(arg0, arg1, arg2)
	local var0 = arg0.world:GetMap(arg1)

	assert(var0, "map not exist: " .. arg1)
	_.each(arg2, function(arg0)
		var0:UpdateFleetLocation(arg0.id, arg0.row, arg0.column)
	end)
end

function var0.NetBulidTerrainUpdate(arg0, arg1)
	return _.map(arg1, function(arg0)
		local var0 = WPool:Get(NetTerrainUpdate)

		var0:Setup(arg0)

		return var0
	end)
end

function var0.ApplyTerrainUpdate(arg0, arg1, arg2)
	local var0 = arg0.world:GetMap(arg1)

	assert(var0, "map not exist: " .. arg1)
	_.each(arg2, function(arg0)
		local var0 = var0:GetCell(arg0.row, arg0.column)
		local var1 = var0:FindFleet(var0.row, var0.column)

		if var1 then
			var0:CheckFleetUpdateFOV(var1, function()
				var0:UpdateTerrain(arg0:GetTerrain(), arg0.terrainDir, arg0.terrainStrong)
			end)
		else
			var0:UpdateTerrain(arg0:GetTerrain(), arg0.terrainDir, arg0.terrainStrong)
		end
	end)
end

function var0.NetBuildFleetUpdate(arg0, arg1)
	return _.map(arg1, function(arg0)
		local var0 = WPool:Get(NetFleetUpdate)

		var0:Setup(arg0)

		return var0
	end)
end

function var0.ApplyFleetUpdate(arg0, arg1, arg2)
	local var0 = arg0.world:GetMap(arg1)

	assert(var0, "map not exist: " .. arg1)
	_.each(arg2, function(arg0)
		local var0 = var0:GetFleet(arg0.id)

		assert(var0, "fleet not exist: " .. arg0.id)
		var0:CheckFleetUpdateFOV(var0, function()
			var0:UpdateBuffs(arg0.buffs)
		end)
	end)
end

function var0.NetBuildShipUpdate(arg0, arg1)
	return _.map(arg1, function(arg0)
		local var0 = WPool:Get(NetShipUpdate)

		var0:Setup(arg0)

		return var0
	end)
end

function var0.ApplyShipUpdate(arg0, arg1)
	_.each(arg1, function(arg0)
		local var0 = arg0.world:GetShip(arg0.id)

		assert(var0, "ship not exist: " .. arg0.id)
		var0:UpdateHpRant(arg0.hpRant)
	end)
end

function var0.NetUpdateWorldSairenChapter(arg0, arg1)
	local var0 = _.rest(arg1, 1)

	arg0.world:GetAtlas():SetSairenEntranceList(var0)
end

function var0.NetUpdateWorldMapPressing(arg0, arg1)
	local var0 = _.rest(arg1, 1)

	arg0.world:GetAtlas():SetPressingMarkList(var0)
	arg0.world:GetAtlas():InitPortMarkNShopList()
end

function var0.NetUpdateWorldShopGoods(arg0, arg1)
	arg0.world:InitWorldShopGoods()
	arg0.world:UpdateWorldShopGoods(arg1)
end

function var0.NetUpdateWorldPressingAward(arg0, arg1)
	local var0 = arg0.world:GetAtlas()

	_.each(arg1, function(arg0)
		local var0 = arg0.id
		local var1 = {
			id = arg0.award,
			flag = arg0.flag == 1
		}

		arg0.world.pressingAwardDic[var0] = var1

		if not var1.flag then
			var0:MarkMapTransport(var0)
		end
	end)
end

function var0.NetUpdateWorldPortShopMark(arg0, arg1, arg2)
	arg0.world:GetAtlas():SetPortMarkList(arg1, arg2)
end

function var0.NetBuildSalvageUpdate(arg0, arg1)
	return _.map(arg1, function(arg0)
		local var0 = WPool:Get(NetSalvageUpdate)

		var0:Setup(arg0)

		return var0
	end)
end

function var0.ApplySalvageUpdate(arg0, arg1)
	_.each(arg1, function(arg0)
		local var0 = arg0.world:GetFleet(arg0.id)

		assert(var0, "fleet not exit: " .. arg0.id)
		var0:UpdateCatSalvage(arg0.step, arg0.list, arg0.mapId)
	end)
end

return var0
