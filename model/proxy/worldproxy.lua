local var0_0 = class("WorldProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	WPool = BaseEntityPool.New()
	WBank = BaseEntityBank.New()

	arg0_1:BuildTestFunc()
	arg0_1:on(33114, function(arg0_2)
		arg0_1.isProtoLock = arg0_2.is_world_open == 0

		arg0_1:BuildWorld(World.TypeBase)

		arg0_1.world.baseShipIds = underscore.rest(arg0_2.ship_id_list, 1)
		arg0_1.world.baseCmdIds = underscore.rest(arg0_2.cmd_id_list, 1)

		arg0_1.world:UpdateProgress(arg0_2.progress)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
		arg0_1:sendNotification(GAME.WORLD_GET_BOSS)
	end)
	arg0_1:on(33105, function(arg0_3)
		local var0_3 = arg0_1.world:GetActiveMap()

		assert(var0_3, "active map not exist.")

		local var1_3 = arg0_1:NetBuildMapAttachmentCells(arg0_3.pos_list)

		arg0_1:UpdateMapAttachmentCells(var0_3.id, var1_3)

		local var2_3 = arg0_1:NetBuildFleetAttachUpdate(arg0_3.pos_list)

		arg0_1:ApplyFleetAttachUpdate(var0_3.id, var2_3)
		WPool:ReturnArray(var2_3)
	end)
	arg0_1:on(33203, function(arg0_4)
		local var0_4 = arg0_1.world:GetTaskProxy()

		for iter0_4, iter1_4 in ipairs(arg0_4.update_list) do
			local var1_4 = WorldTask.New(iter1_4)

			if var0_4:getTaskById(var1_4.id) then
				var0_4:updateTask(var1_4)
			else
				var0_4:addTask(var1_4)
				arg0_1:sendNotification(GAME.WORLD_TRIGGER_TASK_DONE, {
					task = var1_4
				})
			end
		end
	end)
	arg0_1:on(33204, function(arg0_5)
		local var0_5 = arg0_1.world:GetTaskProxy()

		for iter0_5, iter1_5 in ipairs(arg0_5.delete_list) do
			var0_5:deleteTask(iter1_5)
		end
	end)
	arg0_1:on(33601, function(arg0_6)
		arg0_1:NetUpdateAchievements(arg0_6.target_list)
	end)
	arg0_1:on(34507, function(arg0_7)
		if arg0_1.world then
			local var0_7 = arg0_1.world:GetBossProxy()
			local var1_7 = WorldBoss.New()

			var1_7:Setup(arg0_7.boss_info, Player.New(arg0_7.user_info))
			var1_7:UpdateBossType(arg0_7.type)
			var1_7:SetJoinTime(pg.TimeMgr.GetInstance():GetServerTime())

			if var0_7.isSetup then
				var0_7:ClearRank(var1_7.id)
				var0_7:UpdateCacheBoss(var1_7)
			end

			if not var0_7:IsSelfBoss(var1_7) and arg0_1.world:IsSystemOpen(WorldConst.SystemWorldBoss) then
				pg.WorldBossTipMgr.GetInstance():Show(var1_7)
			end
		end
	end)
	arg0_1:on(34508, function(arg0_8)
		local var0_8 = arg0_1.world:GetBossProxy()

		if var0_8.isSetup then
			arg0_1:sendNotification(GAME.WORLD_GET_BOSS_RANK, {
				bossId = arg0_8.boss_id,
				callback = function()
					var0_8:updateBossHp(arg0_8.boss_id, arg0_8.hp)
				end
			})
		end
	end)
end

function var0_0.remove(arg0_10)
	if arg0_10.world then
		arg0_10.world:GetBossProxy():Dispose()
	end

	removeWorld()
	WPool:Dispose()

	WPool = nil

	WBank:Dispose()

	WBank = nil
end

function var0_0.BuildTestFunc(arg0_11)
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
			local var0_13 = pg.m02:retrieveMediator(WorldMediator.__cname)

			if var0_13 then
				var0_13.viewComponent:ShowSubView("DebugPanel")
			end
		end

		pg.UIMgr.GetInstance():AddWorldTestButton("WorldDebug", function()
			WorldConst.Debug = true
		end)
	end
end

function var0_0.BuildWorld(arg0_15, arg1_15, arg2_15)
	arg0_15.world = World.New(arg1_15, arg0_15.world and arg0_15.world:Dispose(tobool(arg2_15)))

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
end

function var0_0.NetFullUpdate(arg0_16, arg1_16)
	arg0_16.isProtoLock = arg1_16.is_world_open == 0

	arg0_16:NetUpdateWorld(arg1_16.world, arg1_16.global_flag_list, arg1_16.camp)
	arg0_16:NetUpdateWorldDefaultFleets(arg1_16.fleet_list)
	arg0_16:NetUpdateWorldAchievements(arg1_16.target_list, arg1_16.target_fetch_list)
	arg0_16:NetUpdateWorldCountInfo(arg1_16.count_info)
	arg0_16:NetUpdateWorldMapPressing(arg1_16.clean_chapter)
	arg0_16:NetUpdateWorldPressingAward(arg1_16.chapter_award)
	arg0_16:NetUpdateWorldShopGoods(arg1_16.out_shop_buy_list)
	arg0_16:NetUpdateWorldPortShopMark(arg1_16.port_list, arg1_16.new_flag_port_list)
end

function var0_0.NetUpdateWorld(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg0_17.world

	var0_17:SetRealm(arg3_17)

	var0_17.activateTime = arg1_17.time
	var0_17.expiredTime = arg1_17.last_change_group_timestamp
	var0_17.roundIndex = arg1_17.round
	var0_17.submarineSupport = arg1_17.submarine_state == 1

	var0_17.staminaMgr:Setup({
		arg1_17.action_power,
		arg1_17.action_power_extra,
		arg1_17.last_recover_timestamp,
		arg1_17.action_power_fetch_count
	})

	var0_17.gobalFlag = underscore.map(arg2_17, function(arg0_18)
		return arg0_18 > 0
	end)

	local var1_17 = var0_17:GetAtlas()

	var1_17:SetCostMapList(_.rest(arg1_17.chapter_list, 1))
	var1_17:SetSairenEntranceList(_.rest(arg1_17.sairen_chapter, 1))
	var1_17:InitWorldNShopGoods(arg1_17.goods_list)
	var0_17:SetFleets(arg0_17:NetBuildMapFleetList(arg1_17.group_list))

	local var2_17 = arg1_17.map_id > 0 and _.detect(arg1_17.chapter_list, function(arg0_19)
		return arg0_19.random_id == arg1_17.map_id
	end)

	assert(arg1_17.map_id > 0 == tobool(var2_17), "error active map info:" .. arg1_17.map_id)

	if var2_17 then
		local var3_17 = arg1_17.enter_map_id
		local var4_17 = var2_17.random_id
		local var5_17 = var2_17.template_id
		local var6_17 = var0_17:GetEntrance(var3_17)
		local var7_17 = var0_17:GetMap(var4_17)

		assert(var6_17, "entrance not exist: " .. var3_17)
		assert(var7_17, "map not exist: " .. var4_17)
		assert(pg.world_chapter_template[var5_17], "world_chapter_template not exist: " .. var5_17)
		assert(#arg1_17.group_list > 0, "amount of group_list is not enough.")
		var6_17:UpdateActive(true)
		var7_17:UpdateGridId(var5_17)

		local var8_17 = arg1_17.group_list[1].id

		var7_17.findex = table.indexof(var0_17.fleets, var0_17:GetFleet(var8_17))

		var7_17:BindFleets(var0_17.fleets)
		var7_17:UpdateActive(true)
	end

	var0_17:GetInventoryProxy():Setup(arg1_17.item_list)

	local var9_17 = var0_17:GetTaskProxy()

	var9_17:Setup(arg1_17.task_list)

	var9_17.taskFinishCount = arg1_17.task_finish_count

	_.each(arg1_17.cd_list, function(arg0_20)
		var0_17.cdTimeList[arg0_20.id] = arg0_20.time
	end)
	_.each(arg1_17.buff_list, function(arg0_21)
		var0_17.globalBuffDic[arg0_21.id] = WorldBuff.New()

		var0_17.globalBuffDic[arg0_21.id]:Setup({
			id = arg0_21.id,
			floor = arg0_21.stack
		})
	end)
	underscore.each(arg1_17.month_boss, function(arg0_22)
		var0_17.lowestHP[arg0_22.key] = arg0_22.value
	end)
end

function var0_0.NetUpdateWorldDefaultFleets(arg0_23, arg1_23)
	local var0_23 = {}

	_.each(arg1_23, function(arg0_24)
		local var0_24 = WorldBaseFleet.New()

		var0_24:Setup(arg0_24)
		table.insert(var0_23, var0_24)
	end)
	table.sort(var0_23, function(arg0_25, arg1_25)
		return arg0_25.id < arg1_25.id
	end)
	arg0_23.world:SetDefaultFleets(var0_23)
end

function var0_0.NetUpdateWorldAchievements(arg0_26, arg1_26, arg2_26)
	arg0_26.world.achievements = {}

	arg0_26:NetUpdateAchievements(arg1_26)

	arg0_26.world.achieveEntranceStar = {}

	_.each(arg2_26, function(arg0_27)
		for iter0_27, iter1_27 in ipairs(arg0_27.star_list) do
			arg0_26.world:SetAchieveSuccess(arg0_27.id, iter1_27)
		end
	end)
end

function var0_0.NetUpdateWorldCountInfo(arg0_28, arg1_28)
	arg0_28.world.stepCount = arg1_28.step_count
	arg0_28.world.treasureCount = arg1_28.treasure_count
	arg0_28.world.activateCount = arg1_28.activate_count

	arg0_28.world:GetCollectionProxy():Setup(arg1_28.collection_list)
	arg0_28.world:UpdateProgress(arg1_28.task_progress)
end

function var0_0.NetUpdateActiveMap(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg0_29.world:GetActiveEntrance()
	local var1_29 = arg0_29.world:GetActiveMap()

	if var1_29:NeedClear() and var0_29.becomeSairen and var0_29:GetSairenMapId() == var1_29.id then
		arg0_29.world:GetAtlas():RemoveSairenEntrance(var0_29)
	end

	local var2_29 = arg0_29.world:GetEntrance(arg1_29)

	assert(var2_29, "entrance not exist: " .. arg1_29)

	if var0_29.id ~= var2_29.id then
		var0_29:UpdateActive(false)
		var2_29:UpdateActive(true)
	end

	local var3_29 = arg0_29.world:GetMap(arg2_29)

	assert(var3_29, "map not exist: " .. arg2_29)

	if var1_29.id ~= var3_29.id then
		var1_29:UpdateActive(false)
		var1_29:RemoveFleetsCarries()
		var1_29:UnbindFleets()

		var3_29.findex = var1_29.findex
		var1_29.findex = nil

		var3_29:UpdateGridId(arg3_29)
		var3_29:BindFleets(arg0_29.world.fleets)
		var3_29:UpdateActive(true)
	end

	arg0_29.world:OnSwitchMap()
end

function var0_0.NetUpdateMap(arg0_30, arg1_30)
	local var0_30 = arg1_30.id.random_id
	local var1_30 = arg1_30.id.template_id

	assert(pg.world_chapter_random[var0_30], "world_chapter_random not exist: " .. var0_30)
	assert(pg.world_chapter_template[var1_30], "world_chapter_template not exist: " .. var1_30)

	local var2_30 = {}

	_.each(arg1_30.state_flag, function(arg0_31)
		var2_30[arg0_31] = true
	end)

	local var3_30 = arg0_30.world:GetMap(var0_30)

	var3_30:UpdateClearFlag(var2_30[1])
	var3_30:UpdateVisionFlag(var2_30[2] or arg0_30.world:IsMapVisioned(var0_30))
	arg0_30:NetUpdateMapDiscoveredCells(var3_30.id, var2_30[3], arg1_30.cell_list)

	local var4_30 = arg0_30:NetBuildMapAttachmentCells(arg1_30.pos_list)

	arg0_30:UpdateMapAttachmentCells(var3_30.id, var4_30)

	local var5_30 = arg0_30:NetBuildFleetAttachUpdate(arg1_30.pos_list)

	arg0_30:ApplyFleetAttachUpdate(var3_30.id, var5_30)
	WPool:ReturnArray(var5_30)

	local var6_30 = arg0_30:NetBulidTerrainUpdate(arg1_30.land_list)

	arg0_30:ApplyTerrainUpdate(var3_30.id, var6_30)
	WPool:ReturnArray(var6_30)
	var3_30:SetValid(true)
end

function var0_0.NetUpdateMapDiscoveredCells(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = arg0_32.world:GetMap(arg1_32)

	assert(var0_32, "map not exist: " .. arg1_32)

	if arg2_32 then
		for iter0_32, iter1_32 in pairs(var0_32.cells) do
			iter1_32:UpdateDiscovered(true)
		end
	else
		_.each(arg3_32, function(arg0_33)
			local var0_33 = var0_32:GetCell(arg0_33.pos.row, arg0_33.pos.column)

			assert(var0_33, "cell not exist: " .. arg0_33.pos.row .. ", " .. arg0_33.pos.column)
			var0_33:UpdateDiscovered(true)
		end)
	end
end

function var0_0.NetUpdateMapPort(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.world:GetMap(arg1_34)

	assert(var0_34, "map not exist: " .. arg1_34)

	local var1_34 = var0_34:GetPort(arg2_34.port_id)

	assert(var1_34, "port not exist: " .. arg2_34.port_id)
	var1_34:UpdateTaskIds(_.rest(arg2_34.task_list, 1))
	var1_34:UpdateGoods(_.map(arg2_34.goods_list, function(arg0_35)
		local var0_35 = WPool:Get(WorldGoods)

		var0_35:Setup(arg0_35)

		return var0_35
	end))
	var1_34:UpdateExpiredTime(arg2_34.next_refresh_time)
end

function var0_0.NetUpdateAchievements(arg0_36, arg1_36)
	_.each(arg1_36, function(arg0_37)
		local var0_37 = arg0_36.world:GetAchievement(arg0_37.id)

		arg0_36.world:DispatchEvent(World.EventAchieved, var0_37:NetUpdate(arg0_37.process_list))
	end)
end

function var0_0.NetBuildMapFleetList(arg0_38, arg1_38)
	local var0_38 = {}

	if arg1_38 and #arg1_38 > 0 then
		_.each(arg1_38, function(arg0_39)
			local var0_39 = WorldMapFleet.New()

			var0_39:Setup(arg0_39)
			table.insert(var0_38, var0_39)
		end)
		table.sort(var0_38, function(arg0_40, arg1_40)
			return arg0_40.id < arg1_40.id
		end)

		local var1_38 = {
			[FleetType.Normal] = 1,
			[FleetType.Submarine] = 1
		}

		_.each(var0_38, function(arg0_41)
			local var0_41 = arg0_41:GetFleetType()

			arg0_41.index = var1_38[var0_41]
			var1_38[var0_41] = var1_38[var0_41] + 1
		end)
	end

	return var0_38
end

function var0_0.NetBuildPortShipList(arg0_42, arg1_42)
	return _.map(arg1_42, function(arg0_43)
		local var0_43 = WPool:Get(WorldMapShip)

		var0_43:Setup(arg0_43)

		return var0_43
	end)
end

function var0_0.NetResetWorld(arg0_44)
	arg0_44:sendNotification(GAME.SEND_CMD, {
		cmd = "world",
		arg1 = "reset"
	})
	arg0_44:sendNotification(GAME.SEND_CMD, {
		cmd = "kick"
	})
end

function var0_0.NetBuildMapAttachmentCells(arg0_45, arg1_45)
	local var0_45 = {}

	_.each(arg1_45, function(arg0_46)
		var0_45[WorldMapCell.GetName(arg0_46.pos.row, arg0_46.pos.column)] = {
			pos = {
				row = arg0_46.pos.row,
				column = arg0_46.pos.column
			},
			attachmentList = arg0_46.item_list
		}
	end)

	for iter0_45, iter1_45 in pairs(var0_45) do
		local var1_45 = {}

		_.each(iter1_45.attachmentList, function(arg0_47)
			local var0_47 = WPool:Get(WorldMapAttachment)

			var0_47:Setup(setmetatable({
				pos = iter1_45.pos
			}, {
				__index = arg0_47
			}))
			table.insert(var1_45, var0_47)
		end)

		iter1_45.attachmentList = var1_45
	end

	return var0_45
end

function var0_0.UpdateMapAttachmentCells(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg0_48.world:GetMap(arg1_48)

	assert(var0_48, "map not exist: " .. arg1_48)

	for iter0_48, iter1_48 in pairs(arg2_48) do
		local var1_48 = var0_48:GetCell(iter1_48.pos.row, iter1_48.pos.column)
		local var2_48 = var1_48.attachments

		for iter2_48 = #var2_48, 1, -1 do
			local var3_48 = var2_48[iter2_48]

			if not WorldMapAttachment.IsFakeType(var2_48[iter2_48].type) and not _.any(iter1_48.attachmentList, function(arg0_49)
				return var3_48.type == arg0_49.type and var3_48.id == arg0_49.id
			end) then
				var1_48:RemoveAttachment(iter2_48)
			end
		end

		_.each(iter1_48.attachmentList, function(arg0_50)
			if arg0_50.type ~= WorldMapAttachment.TypeFleet then
				local var0_50 = _.detect(var1_48.attachments, function(arg0_51)
					return arg0_51.type == arg0_50.type and arg0_51.id == arg0_50.id
				end)

				if var0_50 then
					var0_50:UpdateFlag(arg0_50.flag)
					var0_50:UpdateData(arg0_50.data, arg0_50.effects)
					var0_48:AddPhaseDisplay(var0_50:UpdateBuffList(arg0_50.buffList))
				else
					var1_48:AddAttachment(arg0_50)
				end
			end
		end)
	end
end

function var0_0.NetBuildFleetAttachUpdate(arg0_52, arg1_52)
	local var0_52 = {}

	_.each(arg1_52, function(arg0_53)
		local var0_53 = {
			row = arg0_53.pos.row,
			column = arg0_53.pos.column
		}

		_.each(arg0_53.item_list, function(arg0_54)
			if arg0_54.item_type == WorldMapAttachment.TypeFleet then
				local var0_54 = WPool:Get(NetFleetAttachUpdate)

				var0_54:Setup(setmetatable({
					pos = var0_53
				}, {
					__index = arg0_54
				}))
				table.insert(var0_52, var0_54)
			end
		end)
	end)

	return var0_52
end

function var0_0.ApplyFleetAttachUpdate(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg0_55.world:GetMap(arg1_55)

	assert(var0_55, "map not exist: " .. arg1_55)
	_.each(arg2_55, function(arg0_56)
		var0_55:UpdateFleetLocation(arg0_56.id, arg0_56.row, arg0_56.column)
	end)
end

function var0_0.NetBulidTerrainUpdate(arg0_57, arg1_57)
	return _.map(arg1_57, function(arg0_58)
		local var0_58 = WPool:Get(NetTerrainUpdate)

		var0_58:Setup(arg0_58)

		return var0_58
	end)
end

function var0_0.ApplyTerrainUpdate(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg0_59.world:GetMap(arg1_59)

	assert(var0_59, "map not exist: " .. arg1_59)
	_.each(arg2_59, function(arg0_60)
		local var0_60 = var0_59:GetCell(arg0_60.row, arg0_60.column)
		local var1_60 = var0_59:FindFleet(var0_60.row, var0_60.column)

		if var1_60 then
			var0_59:CheckFleetUpdateFOV(var1_60, function()
				var0_60:UpdateTerrain(arg0_60:GetTerrain(), arg0_60.terrainDir, arg0_60.terrainStrong)
			end)
		else
			var0_60:UpdateTerrain(arg0_60:GetTerrain(), arg0_60.terrainDir, arg0_60.terrainStrong)
		end
	end)
end

function var0_0.NetBuildFleetUpdate(arg0_62, arg1_62)
	return _.map(arg1_62, function(arg0_63)
		local var0_63 = WPool:Get(NetFleetUpdate)

		var0_63:Setup(arg0_63)

		return var0_63
	end)
end

function var0_0.ApplyFleetUpdate(arg0_64, arg1_64, arg2_64)
	local var0_64 = arg0_64.world:GetMap(arg1_64)

	assert(var0_64, "map not exist: " .. arg1_64)
	_.each(arg2_64, function(arg0_65)
		local var0_65 = var0_64:GetFleet(arg0_65.id)

		assert(var0_65, "fleet not exist: " .. arg0_65.id)
		var0_64:CheckFleetUpdateFOV(var0_65, function()
			var0_65:UpdateBuffs(arg0_65.buffs)
		end)
	end)
end

function var0_0.NetBuildShipUpdate(arg0_67, arg1_67)
	return _.map(arg1_67, function(arg0_68)
		local var0_68 = WPool:Get(NetShipUpdate)

		var0_68:Setup(arg0_68)

		return var0_68
	end)
end

function var0_0.ApplyShipUpdate(arg0_69, arg1_69)
	_.each(arg1_69, function(arg0_70)
		local var0_70 = arg0_69.world:GetShip(arg0_70.id)

		assert(var0_70, "ship not exist: " .. arg0_70.id)
		var0_70:UpdateHpRant(arg0_70.hpRant)
	end)
end

function var0_0.NetUpdateWorldSairenChapter(arg0_71, arg1_71)
	local var0_71 = _.rest(arg1_71, 1)

	arg0_71.world:GetAtlas():SetSairenEntranceList(var0_71)
end

function var0_0.NetUpdateWorldMapPressing(arg0_72, arg1_72)
	local var0_72 = _.rest(arg1_72, 1)

	arg0_72.world:GetAtlas():SetPressingMarkList(var0_72)
	arg0_72.world:GetAtlas():InitPortMarkNShopList()
end

function var0_0.NetUpdateWorldShopGoods(arg0_73, arg1_73)
	arg0_73.world:InitWorldShopGoods()
	arg0_73.world:UpdateWorldShopGoods(arg1_73)
end

function var0_0.NetUpdateWorldPressingAward(arg0_74, arg1_74)
	local var0_74 = arg0_74.world:GetAtlas()

	_.each(arg1_74, function(arg0_75)
		local var0_75 = arg0_75.id
		local var1_75 = {
			id = arg0_75.award,
			flag = arg0_75.flag == 1
		}

		arg0_74.world.pressingAwardDic[var0_75] = var1_75

		if not var1_75.flag then
			var0_74:MarkMapTransport(var0_75)
		end
	end)
end

function var0_0.NetUpdateWorldPortShopMark(arg0_76, arg1_76, arg2_76)
	arg0_76.world:GetAtlas():SetPortMarkList(arg1_76, arg2_76)
end

function var0_0.NetBuildSalvageUpdate(arg0_77, arg1_77)
	return _.map(arg1_77, function(arg0_78)
		local var0_78 = WPool:Get(NetSalvageUpdate)

		var0_78:Setup(arg0_78)

		return var0_78
	end)
end

function var0_0.ApplySalvageUpdate(arg0_79, arg1_79)
	_.each(arg1_79, function(arg0_80)
		local var0_80 = arg0_79.world:GetFleet(arg0_80.id)

		assert(var0_80, "fleet not exit: " .. arg0_80.id)
		var0_80:UpdateCatSalvage(arg0_80.step, arg0_80.list, arg0_80.mapId)
	end)
end

return var0_0
