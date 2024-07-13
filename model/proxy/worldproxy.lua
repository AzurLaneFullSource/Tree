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

function var0_0.timeCall(arg0_10)
	return {
		[ProxyRegister.DayCall] = function(arg0_11)
			local var0_11 = nowWorld()

			if pg.TimeMgr.GetInstance():GetServerWeek() == 1 then
				var0_11.staminaMgr.staminaExchangeTimes = 0
			end

			if var0_11 then
				local var1_11 = var0_11:GetBossProxy()

				var1_11:increasePt()
				var1_11:ClearSummonPtDailyAcc()
				var1_11:ClearSummonPtOldAcc()
			end
		end
	}
end

function var0_0.remove(arg0_12)
	if arg0_12.world then
		arg0_12.world:GetBossProxy():Dispose()
	end

	removeWorld()
	WPool:Dispose()

	WPool = nil

	WBank:Dispose()

	WBank = nil
end

function var0_0.BuildTestFunc(arg0_13)
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
			local var0_15 = pg.m02:retrieveMediator(WorldMediator.__cname)

			if var0_15 then
				var0_15.viewComponent:ShowSubView("DebugPanel")
			end
		end

		pg.UIMgr.GetInstance():AddWorldTestButton("WorldDebug", function()
			WorldConst.Debug = true
		end)
	end
end

function var0_0.BuildWorld(arg0_17, arg1_17, arg2_17)
	arg0_17.world = World.New(arg1_17, arg0_17.world and arg0_17.world:Dispose(tobool(arg2_17)))

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
end

function var0_0.NetFullUpdate(arg0_18, arg1_18)
	arg0_18.isProtoLock = arg1_18.is_world_open == 0

	arg0_18:NetUpdateWorld(arg1_18.world, arg1_18.global_flag_list, arg1_18.camp)
	arg0_18:NetUpdateWorldDefaultFleets(arg1_18.fleet_list)
	arg0_18:NetUpdateWorldAchievements(arg1_18.target_list, arg1_18.target_fetch_list)
	arg0_18:NetUpdateWorldCountInfo(arg1_18.count_info)
	arg0_18:NetUpdateWorldMapPressing(arg1_18.clean_chapter)
	arg0_18:NetUpdateWorldPressingAward(arg1_18.chapter_award)
	arg0_18:NetUpdateWorldShopGoods(arg1_18.out_shop_buy_list)
	arg0_18:NetUpdateWorldPortShopMark(arg1_18.port_list, arg1_18.new_flag_port_list)
end

function var0_0.NetUpdateWorld(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19.world

	var0_19:SetRealm(arg3_19)

	var0_19.activateTime = arg1_19.time
	var0_19.expiredTime = arg1_19.last_change_group_timestamp
	var0_19.roundIndex = arg1_19.round
	var0_19.submarineSupport = arg1_19.submarine_state == 1

	var0_19.staminaMgr:Setup({
		arg1_19.action_power,
		arg1_19.action_power_extra,
		arg1_19.last_recover_timestamp,
		arg1_19.action_power_fetch_count
	})

	var0_19.gobalFlag = underscore.map(arg2_19, function(arg0_20)
		return arg0_20 > 0
	end)

	local var1_19 = var0_19:GetAtlas()

	var1_19:SetCostMapList(_.rest(arg1_19.chapter_list, 1))
	var1_19:SetSairenEntranceList(_.rest(arg1_19.sairen_chapter, 1))
	var1_19:InitWorldNShopGoods(arg1_19.goods_list)
	var0_19:SetFleets(arg0_19:NetBuildMapFleetList(arg1_19.group_list))

	local var2_19 = arg1_19.map_id > 0 and _.detect(arg1_19.chapter_list, function(arg0_21)
		return arg0_21.random_id == arg1_19.map_id
	end)

	assert(arg1_19.map_id > 0 == tobool(var2_19), "error active map info:" .. arg1_19.map_id)

	if var2_19 then
		local var3_19 = arg1_19.enter_map_id
		local var4_19 = var2_19.random_id
		local var5_19 = var2_19.template_id
		local var6_19 = var0_19:GetEntrance(var3_19)
		local var7_19 = var0_19:GetMap(var4_19)

		assert(var6_19, "entrance not exist: " .. var3_19)
		assert(var7_19, "map not exist: " .. var4_19)
		assert(pg.world_chapter_template[var5_19], "world_chapter_template not exist: " .. var5_19)
		assert(#arg1_19.group_list > 0, "amount of group_list is not enough.")
		var6_19:UpdateActive(true)
		var7_19:UpdateGridId(var5_19)

		local var8_19 = arg1_19.group_list[1].id

		var7_19.findex = table.indexof(var0_19.fleets, var0_19:GetFleet(var8_19))

		var7_19:BindFleets(var0_19.fleets)
		var7_19:UpdateActive(true)
	end

	var0_19:GetInventoryProxy():Setup(arg1_19.item_list)

	local var9_19 = var0_19:GetTaskProxy()

	var9_19:Setup(arg1_19.task_list)

	var9_19.taskFinishCount = arg1_19.task_finish_count

	_.each(arg1_19.cd_list, function(arg0_22)
		var0_19.cdTimeList[arg0_22.id] = arg0_22.time
	end)
	_.each(arg1_19.buff_list, function(arg0_23)
		var0_19.globalBuffDic[arg0_23.id] = WorldBuff.New()

		var0_19.globalBuffDic[arg0_23.id]:Setup({
			id = arg0_23.id,
			floor = arg0_23.stack
		})
	end)
	underscore.each(arg1_19.month_boss, function(arg0_24)
		var0_19.lowestHP[arg0_24.key] = arg0_24.value
	end)
end

function var0_0.NetUpdateWorldDefaultFleets(arg0_25, arg1_25)
	local var0_25 = {}

	_.each(arg1_25, function(arg0_26)
		local var0_26 = WorldBaseFleet.New()

		var0_26:Setup(arg0_26)
		table.insert(var0_25, var0_26)
	end)
	table.sort(var0_25, function(arg0_27, arg1_27)
		return arg0_27.id < arg1_27.id
	end)
	arg0_25.world:SetDefaultFleets(var0_25)
end

function var0_0.NetUpdateWorldAchievements(arg0_28, arg1_28, arg2_28)
	arg0_28.world.achievements = {}

	arg0_28:NetUpdateAchievements(arg1_28)

	arg0_28.world.achieveEntranceStar = {}

	_.each(arg2_28, function(arg0_29)
		for iter0_29, iter1_29 in ipairs(arg0_29.star_list) do
			arg0_28.world:SetAchieveSuccess(arg0_29.id, iter1_29)
		end
	end)
end

function var0_0.NetUpdateWorldCountInfo(arg0_30, arg1_30)
	arg0_30.world.stepCount = arg1_30.step_count
	arg0_30.world.treasureCount = arg1_30.treasure_count
	arg0_30.world.activateCount = arg1_30.activate_count

	arg0_30.world:GetCollectionProxy():Setup(arg1_30.collection_list)
	arg0_30.world:UpdateProgress(arg1_30.task_progress)
end

function var0_0.NetUpdateActiveMap(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = arg0_31.world:GetActiveEntrance()
	local var1_31 = arg0_31.world:GetActiveMap()

	if var1_31:NeedClear() and var0_31.becomeSairen and var0_31:GetSairenMapId() == var1_31.id then
		arg0_31.world:GetAtlas():RemoveSairenEntrance(var0_31)
	end

	local var2_31 = arg0_31.world:GetEntrance(arg1_31)

	assert(var2_31, "entrance not exist: " .. arg1_31)

	if var0_31.id ~= var2_31.id then
		var0_31:UpdateActive(false)
		var2_31:UpdateActive(true)
	end

	local var3_31 = arg0_31.world:GetMap(arg2_31)

	assert(var3_31, "map not exist: " .. arg2_31)

	if var1_31.id ~= var3_31.id then
		var1_31:UpdateActive(false)
		var1_31:RemoveFleetsCarries()
		var1_31:UnbindFleets()

		var3_31.findex = var1_31.findex
		var1_31.findex = nil

		var3_31:UpdateGridId(arg3_31)
		var3_31:BindFleets(arg0_31.world.fleets)
		var3_31:UpdateActive(true)
	end

	arg0_31.world:OnSwitchMap()
end

function var0_0.NetUpdateMap(arg0_32, arg1_32)
	local var0_32 = arg1_32.id.random_id
	local var1_32 = arg1_32.id.template_id

	assert(pg.world_chapter_random[var0_32], "world_chapter_random not exist: " .. var0_32)
	assert(pg.world_chapter_template[var1_32], "world_chapter_template not exist: " .. var1_32)

	local var2_32 = {}

	_.each(arg1_32.state_flag, function(arg0_33)
		var2_32[arg0_33] = true
	end)

	local var3_32 = arg0_32.world:GetMap(var0_32)

	var3_32:UpdateClearFlag(var2_32[1])
	var3_32:UpdateVisionFlag(var2_32[2] or arg0_32.world:IsMapVisioned(var0_32))
	arg0_32:NetUpdateMapDiscoveredCells(var3_32.id, var2_32[3], arg1_32.cell_list)

	local var4_32 = arg0_32:NetBuildMapAttachmentCells(arg1_32.pos_list)

	arg0_32:UpdateMapAttachmentCells(var3_32.id, var4_32)

	local var5_32 = arg0_32:NetBuildFleetAttachUpdate(arg1_32.pos_list)

	arg0_32:ApplyFleetAttachUpdate(var3_32.id, var5_32)
	WPool:ReturnArray(var5_32)

	local var6_32 = arg0_32:NetBulidTerrainUpdate(arg1_32.land_list)

	arg0_32:ApplyTerrainUpdate(var3_32.id, var6_32)
	WPool:ReturnArray(var6_32)
	var3_32:SetValid(true)
end

function var0_0.NetUpdateMapDiscoveredCells(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = arg0_34.world:GetMap(arg1_34)

	assert(var0_34, "map not exist: " .. arg1_34)

	if arg2_34 then
		for iter0_34, iter1_34 in pairs(var0_34.cells) do
			iter1_34:UpdateDiscovered(true)
		end
	else
		_.each(arg3_34, function(arg0_35)
			local var0_35 = var0_34:GetCell(arg0_35.pos.row, arg0_35.pos.column)

			assert(var0_35, "cell not exist: " .. arg0_35.pos.row .. ", " .. arg0_35.pos.column)
			var0_35:UpdateDiscovered(true)
		end)
	end
end

function var0_0.NetUpdateMapPort(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36.world:GetMap(arg1_36)

	assert(var0_36, "map not exist: " .. arg1_36)

	local var1_36 = var0_36:GetPort(arg2_36.port_id)

	assert(var1_36, "port not exist: " .. arg2_36.port_id)
	var1_36:UpdateTaskIds(_.rest(arg2_36.task_list, 1))
	var1_36:UpdateGoods(_.map(arg2_36.goods_list, function(arg0_37)
		local var0_37 = WPool:Get(WorldGoods)

		var0_37:Setup(arg0_37)

		return var0_37
	end))
	var1_36:UpdateExpiredTime(arg2_36.next_refresh_time)
end

function var0_0.NetUpdateAchievements(arg0_38, arg1_38)
	_.each(arg1_38, function(arg0_39)
		local var0_39 = arg0_38.world:GetAchievement(arg0_39.id)

		arg0_38.world:DispatchEvent(World.EventAchieved, var0_39:NetUpdate(arg0_39.process_list))
	end)
end

function var0_0.NetBuildMapFleetList(arg0_40, arg1_40)
	local var0_40 = {}

	if arg1_40 and #arg1_40 > 0 then
		_.each(arg1_40, function(arg0_41)
			local var0_41 = WorldMapFleet.New()

			var0_41:Setup(arg0_41)
			table.insert(var0_40, var0_41)
		end)
		table.sort(var0_40, function(arg0_42, arg1_42)
			return arg0_42.id < arg1_42.id
		end)

		local var1_40 = {
			[FleetType.Normal] = 1,
			[FleetType.Submarine] = 1
		}

		_.each(var0_40, function(arg0_43)
			local var0_43 = arg0_43:GetFleetType()

			arg0_43.index = var1_40[var0_43]
			var1_40[var0_43] = var1_40[var0_43] + 1
		end)
	end

	return var0_40
end

function var0_0.NetBuildPortShipList(arg0_44, arg1_44)
	return _.map(arg1_44, function(arg0_45)
		local var0_45 = WPool:Get(WorldMapShip)

		var0_45:Setup(arg0_45)

		return var0_45
	end)
end

function var0_0.NetResetWorld(arg0_46)
	arg0_46:sendNotification(GAME.SEND_CMD, {
		cmd = "world",
		arg1 = "reset"
	})
	arg0_46:sendNotification(GAME.SEND_CMD, {
		cmd = "kick"
	})
end

function var0_0.NetBuildMapAttachmentCells(arg0_47, arg1_47)
	local var0_47 = {}

	_.each(arg1_47, function(arg0_48)
		var0_47[WorldMapCell.GetName(arg0_48.pos.row, arg0_48.pos.column)] = {
			pos = {
				row = arg0_48.pos.row,
				column = arg0_48.pos.column
			},
			attachmentList = arg0_48.item_list
		}
	end)

	for iter0_47, iter1_47 in pairs(var0_47) do
		local var1_47 = {}

		_.each(iter1_47.attachmentList, function(arg0_49)
			local var0_49 = WPool:Get(WorldMapAttachment)

			var0_49:Setup(setmetatable({
				pos = iter1_47.pos
			}, {
				__index = arg0_49
			}))
			table.insert(var1_47, var0_49)
		end)

		iter1_47.attachmentList = var1_47
	end

	return var0_47
end

function var0_0.UpdateMapAttachmentCells(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg0_50.world:GetMap(arg1_50)

	assert(var0_50, "map not exist: " .. arg1_50)

	for iter0_50, iter1_50 in pairs(arg2_50) do
		local var1_50 = var0_50:GetCell(iter1_50.pos.row, iter1_50.pos.column)
		local var2_50 = var1_50.attachments

		for iter2_50 = #var2_50, 1, -1 do
			local var3_50 = var2_50[iter2_50]

			if not WorldMapAttachment.IsFakeType(var2_50[iter2_50].type) and not _.any(iter1_50.attachmentList, function(arg0_51)
				return var3_50.type == arg0_51.type and var3_50.id == arg0_51.id
			end) then
				var1_50:RemoveAttachment(iter2_50)
			end
		end

		_.each(iter1_50.attachmentList, function(arg0_52)
			if arg0_52.type ~= WorldMapAttachment.TypeFleet then
				local var0_52 = _.detect(var1_50.attachments, function(arg0_53)
					return arg0_53.type == arg0_52.type and arg0_53.id == arg0_52.id
				end)

				if var0_52 then
					var0_52:UpdateFlag(arg0_52.flag)
					var0_52:UpdateData(arg0_52.data, arg0_52.effects)
					var0_50:AddPhaseDisplay(var0_52:UpdateBuffList(arg0_52.buffList))
				else
					var1_50:AddAttachment(arg0_52)
				end
			end
		end)
	end
end

function var0_0.NetBuildFleetAttachUpdate(arg0_54, arg1_54)
	local var0_54 = {}

	_.each(arg1_54, function(arg0_55)
		local var0_55 = {
			row = arg0_55.pos.row,
			column = arg0_55.pos.column
		}

		_.each(arg0_55.item_list, function(arg0_56)
			if arg0_56.item_type == WorldMapAttachment.TypeFleet then
				local var0_56 = WPool:Get(NetFleetAttachUpdate)

				var0_56:Setup(setmetatable({
					pos = var0_55
				}, {
					__index = arg0_56
				}))
				table.insert(var0_54, var0_56)
			end
		end)
	end)

	return var0_54
end

function var0_0.ApplyFleetAttachUpdate(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg0_57.world:GetMap(arg1_57)

	assert(var0_57, "map not exist: " .. arg1_57)
	_.each(arg2_57, function(arg0_58)
		var0_57:UpdateFleetLocation(arg0_58.id, arg0_58.row, arg0_58.column)
	end)
end

function var0_0.NetBulidTerrainUpdate(arg0_59, arg1_59)
	return _.map(arg1_59, function(arg0_60)
		local var0_60 = WPool:Get(NetTerrainUpdate)

		var0_60:Setup(arg0_60)

		return var0_60
	end)
end

function var0_0.ApplyTerrainUpdate(arg0_61, arg1_61, arg2_61)
	local var0_61 = arg0_61.world:GetMap(arg1_61)

	assert(var0_61, "map not exist: " .. arg1_61)
	_.each(arg2_61, function(arg0_62)
		local var0_62 = var0_61:GetCell(arg0_62.row, arg0_62.column)
		local var1_62 = var0_61:FindFleet(var0_62.row, var0_62.column)

		if var1_62 then
			var0_61:CheckFleetUpdateFOV(var1_62, function()
				var0_62:UpdateTerrain(arg0_62:GetTerrain(), arg0_62.terrainDir, arg0_62.terrainStrong)
			end)
		else
			var0_62:UpdateTerrain(arg0_62:GetTerrain(), arg0_62.terrainDir, arg0_62.terrainStrong)
		end
	end)
end

function var0_0.NetBuildFleetUpdate(arg0_64, arg1_64)
	return _.map(arg1_64, function(arg0_65)
		local var0_65 = WPool:Get(NetFleetUpdate)

		var0_65:Setup(arg0_65)

		return var0_65
	end)
end

function var0_0.ApplyFleetUpdate(arg0_66, arg1_66, arg2_66)
	local var0_66 = arg0_66.world:GetMap(arg1_66)

	assert(var0_66, "map not exist: " .. arg1_66)
	_.each(arg2_66, function(arg0_67)
		local var0_67 = var0_66:GetFleet(arg0_67.id)

		assert(var0_67, "fleet not exist: " .. arg0_67.id)
		var0_66:CheckFleetUpdateFOV(var0_67, function()
			var0_67:UpdateBuffs(arg0_67.buffs)
		end)
	end)
end

function var0_0.NetBuildShipUpdate(arg0_69, arg1_69)
	return _.map(arg1_69, function(arg0_70)
		local var0_70 = WPool:Get(NetShipUpdate)

		var0_70:Setup(arg0_70)

		return var0_70
	end)
end

function var0_0.ApplyShipUpdate(arg0_71, arg1_71)
	_.each(arg1_71, function(arg0_72)
		local var0_72 = arg0_71.world:GetShip(arg0_72.id)

		assert(var0_72, "ship not exist: " .. arg0_72.id)
		var0_72:UpdateHpRant(arg0_72.hpRant)
	end)
end

function var0_0.NetUpdateWorldSairenChapter(arg0_73, arg1_73)
	local var0_73 = _.rest(arg1_73, 1)

	arg0_73.world:GetAtlas():SetSairenEntranceList(var0_73)
end

function var0_0.NetUpdateWorldMapPressing(arg0_74, arg1_74)
	local var0_74 = _.rest(arg1_74, 1)

	arg0_74.world:GetAtlas():SetPressingMarkList(var0_74)
	arg0_74.world:GetAtlas():InitPortMarkNShopList()
end

function var0_0.NetUpdateWorldShopGoods(arg0_75, arg1_75)
	arg0_75.world:InitWorldShopGoods()
	arg0_75.world:UpdateWorldShopGoods(arg1_75)
end

function var0_0.NetUpdateWorldPressingAward(arg0_76, arg1_76)
	local var0_76 = arg0_76.world:GetAtlas()

	_.each(arg1_76, function(arg0_77)
		local var0_77 = arg0_77.id
		local var1_77 = {
			id = arg0_77.award,
			flag = arg0_77.flag == 1
		}

		arg0_76.world.pressingAwardDic[var0_77] = var1_77

		if not var1_77.flag then
			var0_76:MarkMapTransport(var0_77)
		end
	end)
end

function var0_0.NetUpdateWorldPortShopMark(arg0_78, arg1_78, arg2_78)
	arg0_78.world:GetAtlas():SetPortMarkList(arg1_78, arg2_78)
end

function var0_0.NetBuildSalvageUpdate(arg0_79, arg1_79)
	return _.map(arg1_79, function(arg0_80)
		local var0_80 = WPool:Get(NetSalvageUpdate)

		var0_80:Setup(arg0_80)

		return var0_80
	end)
end

function var0_0.ApplySalvageUpdate(arg0_81, arg1_81)
	_.each(arg1_81, function(arg0_82)
		local var0_82 = arg0_81.world:GetFleet(arg0_82.id)

		assert(var0_82, "fleet not exit: " .. arg0_82.id)
		var0_82:UpdateCatSalvage(arg0_82.step, arg0_82.list, arg0_82.mapId)
	end)
end

return var0_0
