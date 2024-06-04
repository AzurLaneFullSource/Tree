local var0 = class("Drop", import(".BaseVO"))

function var0.Create(arg0)
	local var0 = {}

	var0.type, var0.id, var0.count = unpack(arg0)

	return var0.New(var0)
end

function var0.Change(arg0)
	if not getmetatable(arg0) then
		setmetatable(arg0, var0)

		arg0.class = var0

		arg0:InitConfig()
	else
		assert(instanceof(arg0, var0))
	end

	return arg0
end

function var0.Ctor(arg0, arg1)
	assert(not getmetatable(arg1), "drop data should not has metatable")

	for iter0, iter1 in pairs(arg1) do
		arg0[iter0] = iter1
	end

	arg0:InitConfig()
end

function var0.InitConfig(arg0)
	if not var0.inited then
		var0.InitSwitch()
	end

	arg0.configId = arg0.id
	arg0.cfg = switch(arg0.type, var0.ConfigCase, var0.ConfigDefault, arg0)
end

function var0.getConfigTable(arg0)
	return arg0.cfg
end

function var0.getName(arg0)
	return arg0.name or arg0:getConfig("name")
end

function var0.getIcon(arg0)
	return arg0:getConfig("icon")
end

function var0.getCount(arg0)
	if arg0.type == DROP_TYPE_OPERATION or arg0.type == DROP_TYPE_LOVE_LETTER then
		return 1
	else
		return arg0.count
	end
end

function var0.getOwnedCount(arg0)
	return switch(arg0.type, var0.CountCase, var0.CountDefault, arg0)
end

function var0.getSubClass(arg0)
	return switch(arg0.type, var0.SubClassCase, var0.SubClassDefault, arg0)
end

function var0.getDropRarity(arg0)
	return switch(arg0.type, var0.RarityCase, var0.RarityDefault, arg0)
end

function var0.DropTrans(arg0, ...)
	return switch(arg0.type, var0.TransCase, var0.TransDefault, arg0, ...)
end

function var0.AddItemOperation(arg0)
	return switch(arg0.type, var0.AddItemCase, var0.AddItemDefault, arg0)
end

function var0.MsgboxIntroSet(arg0, ...)
	return switch(arg0.type, var0.MsgboxIntroCase, var0.MsgboxIntroDefault, arg0, ...)
end

function var0.UpdateDropTpl(arg0, ...)
	return switch(arg0.type, var0.UpdateDropCase, var0.UpdateDropDefault, arg0, ...)
end

function var0.InitSwitch()
	var0.inited = true
	var0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0)
			local var0 = Item.getConfigData(id2ItemId(arg0.id))

			arg0.desc = var0.display

			return var0
		end,
		[DROP_TYPE_ITEM] = function(arg0)
			local var0 = Item.getConfigData(arg0.id)

			arg0.desc = var0.display

			if var0.type == Item.LOVE_LETTER_TYPE then
				arg0.desc = string.gsub(arg0.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0.extra))
			end

			return var0
		end,
		[DROP_TYPE_VITEM] = function(arg0)
			local var0 = Item.getConfigData(arg0.id)

			arg0.desc = var0.display

			return var0
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0)
			local var0 = Item.getConfigData(arg0.id)

			arg0.desc = string.gsub(var0.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0.count))

			return var0
		end,
		[DROP_TYPE_EQUIP] = function(arg0)
			local var0 = Equipment.getConfigData(arg0.id)

			arg0.desc = var0.descrip

			return var0
		end,
		[DROP_TYPE_SHIP] = function(arg0)
			local var0 = pg.ship_data_statistics[arg0.id]
			local var1, var2, var3 = ShipWordHelper.GetWordAndCV(var0.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0.desc = var3 or i18n("ship_drop_desc_default")
			arg0.ship = Ship.New({
				configId = arg0.id,
				skin_id = arg0.skinId,
				propose = arg0.propose
			})
			arg0.ship.remoulded = arg0.remoulded
			arg0.ship.virgin = arg0.virgin

			return var0
		end,
		[DROP_TYPE_FURNITURE] = function(arg0)
			local var0 = pg.furniture_data_template[arg0.id]

			arg0.desc = var0.describe

			return var0
		end,
		[DROP_TYPE_SKIN] = function(arg0)
			local var0 = pg.ship_skin_template[arg0.id]
			local var1, var2, var3 = ShipWordHelper.GetWordAndCV(arg0.id, ShipWordHelper.WORD_TYPE_DROP)

			arg0.desc = var3

			return var0
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0)
			local var0 = pg.ship_skin_template[arg0.id]
			local var1, var2, var3 = ShipWordHelper.GetWordAndCV(arg0.id, ShipWordHelper.WORD_TYPE_DROP)

			arg0.desc = var3

			return var0
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0)
			local var0 = pg.equip_skin_template[arg0.id]

			arg0.desc = var0.desc

			return var0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0)
			local var0 = pg.world_item_data_template[arg0.id]

			arg0.desc = var0.display

			return var0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0)
			return pg.item_data_frame[arg0.id]
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0)
			return pg.item_data_chat[arg0.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0)
			local var0 = pg.spweapon_data_statistics[arg0.id]

			arg0.desc = var0.descrip

			return var0
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0)
			local var0 = pg.activity_ryza_item[arg0.id]

			arg0.item = AtelierMaterial.New({
				configId = arg0.id
			})
			arg0.desc = arg0.item:GetDesc()

			return var0
		end,
		[DROP_TYPE_OPERATION] = function(arg0)
			arg0.ship = getProxy(BayProxy):getShipById(arg0.count)

			local var0 = pg.ship_data_statistics[arg0.ship.configId]
			local var1, var2, var3 = ShipWordHelper.GetWordAndCV(var0.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0.desc = var3 or i18n("ship_drop_desc_default")

			return var0
		end,
		[DROP_TYPE_STRATEGY] = function(arg0)
			return arg0.isWorldBuff and pg.world_SLGbuff_data[arg0.id] or pg.strategy_data_template[arg0.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0)
			local var0 = pg.emoji_template[arg0.id]

			arg0.name = var0.item_name
			arg0.desc = var0.item_desc

			return var0
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0)
			local var0 = WorldCollectionProxy.GetCollectionTemplate(arg0.id)

			arg0.desc = var0.name

			return var0
		end,
		[DROP_TYPE_META_PT] = function(arg0)
			local var0 = pg.ship_strengthen_meta[arg0.id]
			local var1 = Item.getConfigData(var0.itemid)

			arg0.desc = var1.display

			return var1
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0)
			local var0 = pg.activity_workbench_item[arg0.id]

			arg0.item = WorkBenchItem.New({
				configId = arg0.id
			})
			arg0.desc = arg0.item:GetDesc()

			return var0
		end,
		[DROP_TYPE_BUFF] = function(arg0)
			local var0 = pg.benefit_buff_template[arg0.id]

			arg0.desc = var0.desc

			return var0
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0)
			local var0 = pg.commander_data_template[arg0.id]

			arg0.desc = ""

			return var0
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0)
			return pg.drop_data_restore[arg0.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0)
			local var0 = pg.dorm3d_furniture_template[arg0.id]

			arg0.desc = var0.desc

			return var0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0)
			local var0 = pg.dorm3d_gift[arg0.id]

			arg0.desc = ""

			return var0
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0)
			local var0 = pg.dorm3d_resource[arg0.id]

			arg0.desc = ""

			return var0
		end
	}

	function var0.ConfigDefault(arg0)
		local var0 = arg0.type

		if var0 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1 = pg.activity_drop_type[var0].relevance

			return var1 and pg[var1][arg0.id]
		end
	end

	var0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0)
			return getProxy(PlayerProxy):getRawData():getResById(arg0.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0)
			local var0 = getProxy(BagProxy):getItemCountById(arg0.id)

			if arg0:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0, 1), true
			else
				return var0, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0)
			local var0 = arg0:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0], "equip groupId not exist")

			local var1 = pg.equip_data_template.get_id_list_by_group[var0]

			return underscore.reduce(var1, 0, function(arg0, arg1)
				local var0 = getProxy(EquipmentProxy):getEquipmentById(arg1)

				return arg0 + (var0 and var0.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0)
			return getProxy(BayProxy):getConfigShipCount(arg0.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0)
			return arg0.count, tobool(arg0.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0)
			if arg0:getConfig("virtual_type") == 22 then
				local var0 = getProxy(ActivityProxy):getActivityById(arg0:getConfig("link_id"))

				return var0 and var0.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0)
			local var0 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0.id)

			return (var0 and var0.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0)
			local var0 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0.type].activity_id):GetItemById(arg0.id)

			return var0 and var0.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0)
			local var0 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0.id)

			return var0 and (not var0:expiredType() or not not var0:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0)
			local var0 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0.id)

			return var0 and (not var0:expiredType() or not not var0:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0)
			local var0 = nowWorld()

			if var0.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0:GetInventoryProxy():GetItemCount(arg0.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0.id)
		end
	}

	function var0.CountDefault(arg0)
		local var0 = arg0.type

		if var0 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0].activity_id):getVitemNumber(arg0.id)
		else
			return 0, false
		end
	end

	var0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0)
			return Item.New(arg0)
		end,
		[DROP_TYPE_VITEM] = function(arg0)
			return Item.New(arg0)
		end,
		[DROP_TYPE_EQUIP] = function(arg0)
			return Equipment.New(arg0)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0)
			return Item.New({
				count = 1,
				id = arg0.id,
				extra = arg0.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0)
			return WorldItem.New(arg0)
		end
	}

	function var0.SubClassDefault(arg0)
		assert(false, string.format("drop type %d without subClass", arg0.type))
	end

	var0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0)
			return arg0:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0)
			return arg0:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0)
			return arg0:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0)
			return arg0:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0)
			return arg0:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0)
			return arg0:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0)
			return arg0:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0)
			return arg0:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0)
			return arg0:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0)
			return ItemRarity.Gold
		end
	}

	function var0.RarityDefault(arg0)
		return 1
	end

	var0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0)
			local var0 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0:getConfig("resource_type"),
				count = arg0:getConfig("resource_num") * arg0.count
			})
			local var1 = Drop.New({
				type = arg0:getConfig("target_type"),
				id = arg0:getConfig("target_id")
			})

			var0.name = string.format("%s(%s)", var0:getName(), var1:getName())

			return var0
		end,
		[DROP_TYPE_RESOURCE] = function(arg0)
			for iter0, iter1 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1.id].pt == arg0.id then
					return nil, arg0
				end
			end

			return arg0
		end,
		[DROP_TYPE_OPERATION] = function(arg0)
			if arg0.id ~= 3 then
				return nil
			end

			return arg0
		end,
		[DROP_TYPE_VITEM] = function(arg0, arg1, arg2)
			assert(arg0:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0.id)

			return switch(arg0:getConfig("virtual_type"), {
				function()
					if arg0:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0
					end

					return arg0
				end,
				[6] = function()
					local var0 = arg2.taskId
					local var1 = getProxy(ActivityProxy)
					local var2 = var1:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2 then
						local var3 = var2.data1KeyValueList[1]

						var3[var0] = defaultValue(var3[var0], 0) + arg0.count

						var1:updateActivity(var2)
					end

					return nil, arg0
				end,
				[13] = function()
					local var0 = arg0:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0))

						return nil
					elseif SkinCouponActivity.StaticOwnAllSkin() then
						if arg0.count > 1 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0))
						end

						return SkinCouponActivity.StaticGetEquivalentRes(), nil
					else
						return arg0, nil
					end
				end,
				[21] = function()
					return nil, arg0
				end
			}, function()
				return arg0
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0, arg1)
			if Ship.isMetaShipByConfigID(arg0.id) and Player.isMetaShipNeedToTrans(arg0.id) then
				local var0 = table.indexof(arg1, arg0.id, 1)

				if var0 then
					table.remove(arg1, var0)
				else
					local var1 = Player.metaShip2Res(arg0.id)
					local var2 = Drop.New(var1[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0.id, var2)

					return arg0, var2
				end
			end

			return arg0
		end,
		[DROP_TYPE_SKIN] = function(arg0)
			arg0.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0.id)

			return arg0
		end
	}

	function var0.TransDefault(arg0)
		return arg0
	end

	var0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0)
			local var0 = id2res(arg0.id)

			assert(var0, "res should be defined: " .. arg0.id)

			local var1 = getProxy(PlayerProxy)
			local var2 = var1:getData()

			var2:addResources({
				[var0] = arg0.count
			})
			var1:updatePlayer(var2)
		end,
		[DROP_TYPE_ITEM] = function(arg0)
			if arg0:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0 = getProxy(BagProxy):getItemCountById(arg0.id)
				local var1 = math.min(arg0:getConfig("max_num") - var0, arg0.count)

				if var1 > 0 then
					getProxy(BagProxy):addItemById(arg0.id, var1)
				end
			else
				getProxy(BagProxy):addItemById(arg0.id, arg0.count, arg0.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0)
			local var0 = arg0:getSubClass()

			getProxy(BagProxy):addItemById(var0.id, var0.count, var0.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0)
			getProxy(EquipmentProxy):addEquipmentById(arg0.id, arg0.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0)
			local var0 = getProxy(DormProxy)
			local var1 = Furniture.New({
				id = arg0.id,
				count = arg0.count
			})

			if var1:isRecordTime() then
				var1.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0:AddFurniture(var1)
		end,
		[DROP_TYPE_SKIN] = function(arg0)
			local var0 = getProxy(ShipSkinProxy)
			local var1 = ShipSkin.New({
				id = arg0.id
			})

			var0:addSkin(var1)
		end,
		[DROP_TYPE_VITEM] = function(arg0)
			arg0 = arg0:getSubClass()

			assert(arg0:isVirtualItem(), "item type error(virtual item)>>" .. arg0.id)
			switch(arg0:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0.id, arg0.count)
				end,
				function()
					local var0 = getProxy(ActivityProxy)
					local var1 = arg0:getConfig("link_id")
					local var2

					if var1 > 0 then
						var2 = var0:getActivityById(var1)
					else
						var2 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2 and not var2:isEnd() then
						if not table.contains(var2.data1_list, arg0.id) then
							table.insert(var2.data1_list, arg0.id)
						end

						var0:updateActivity(var2)
					end
				end,
				function()
					local var0 = getProxy(ActivityProxy)
					local var1 = var0:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0, iter1 in ipairs(var1) do
						iter1.data1 = iter1.data1 + arg0.count

						local var2 = iter1:getConfig("config_id")
						local var3 = pg.activity_vote[var2]

						if var3 and var3.ticket_id_period == arg0.id then
							iter1.data3 = iter1.data3 + arg0.count
						end

						var0:updateActivity(iter1)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0.id,
							ptCount = arg0.count
						})
					end
				end,
				[4] = function()
					local var0 = getProxy(ColoringProxy):getColorItems()

					var0[arg0.id] = (var0[arg0.id] or 0) + arg0.count
				end,
				[6] = function()
					local var0 = getProxy(ActivityProxy)
					local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1 then
						var1.data3 = var1.data3 + arg0.count

						var0:updateActivity(var1)
					end
				end,
				[7] = function()
					local var0 = getProxy(ChapterProxy)

					var0:updateRemasterTicketsNum(math.min(var0.remasterTickets + arg0.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0 = getProxy(ActivityProxy)
					local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1 then
						var1.data1_list[1] = var1.data1_list[1] + arg0.count

						var0:updateActivity(var1)
					end
				end,
				[10] = function()
					local var0 = getProxy(ActivityProxy)
					local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1 and not var1:isEnd() then
						var1.data1 = var1.data1 + arg0.count

						var0:updateActivity(var1)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1
						})
					end
				end,
				[11] = function()
					local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0 and not var0:isEnd() then
						var0.data1 = var0.data1 + arg0.count
					end
				end,
				[12] = function()
					local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0 and not var0:isEnd() then
						var0.data1KeyValueList[1][arg0.id] = (var0.data1KeyValueList[1][arg0.id] or 0) + arg0.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0.id)
				end,
				[14] = function()
					local var0 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0.id then
						var0:AddSummonPt(arg0.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0.id then
						var0:AddSummonPtOld(arg0.count)
					end
				end,
				[15] = function()
					local var0 = getProxy(ActivityProxy)
					local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

					if var1 and not var1:isEnd() then
						local var2 = pg.activity_event_grid[var1.data1]

						if arg0.id == var2.ticket_item then
							var1.data2 = var1.data2 + arg0.count
						elseif arg0.id == var2.explore_item then
							var1.data3 = var1.data3 + arg0.count
						end
					end

					var0:updateActivity(var1)
				end,
				[16] = function()
					local var0 = getProxy(ActivityProxy)
					local var1 = var0:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0, iter1 in pairs(var1) do
						if iter1 and not iter1:isEnd() and arg0.id == iter1:getConfig("config_id") then
							iter1.data1 = iter1.data1 + arg0.count

							var0:updateActivity(iter1)
						end
					end
				end,
				[20] = function()
					local var0 = getProxy(BagProxy)
					local var1 = pg.gameset.urpt_chapter_max.description
					local var2 = var1[1]
					local var3 = var1[2]
					local var4 = var0:GetLimitCntById(var2)
					local var5 = math.min(var3 - var4, arg0.count)

					if var5 > 0 then
						var0:addItemById(var2, var5)
						var0:AddLimitCnt(var2, var5)
					end
				end,
				[21] = function()
					local var0 = getProxy(ActivityProxy)
					local var1 = var0:getActivityById(arg0:getConfig("link_id"))

					if var1 and not var1:isEnd() then
						var1.data2 = 1

						var0:updateActivity(var1)
					end
				end,
				[22] = function()
					local var0 = getProxy(ActivityProxy)
					local var1 = var0:getActivityById(arg0:getConfig("link_id"))

					if var1 and not var1:isEnd() then
						var1.data1 = var1.data1 + arg0.count

						var0:updateActivity(var1)
					end
				end,
				[23] = function()
					local var0 = (function()
						for iter0, iter1 in ipairs(pg.gameset.package_lv.description) do
							if arg0.id == iter1[1] then
								return iter1[2]
							end
						end
					end)()

					assert(var0)

					local var1 = getProxy(PlayerProxy)
					local var2 = var1:getData()

					var2:addExpToLevel(var0)
					var1:updatePlayer(var2)
				end,
				[24] = function()
					local var0 = arg0:getConfig("link_id")
					local var1 = getProxy(ActivityProxy):getActivityById(var0)

					if var1 and not var1:isEnd() and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1.data2 = var1.data2 + arg0.count

						getProxy(ActivityProxy):updateActivity(var1)
					end
				end,
				[25] = function()
					local var0 = getProxy(ActivityProxy)
					local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1 and not var1:isEnd() then
						var1.data1 = var1.data1 - 1

						if not table.contains(var1.data1_list, arg0.id) then
							table.insert(var1.data1_list, arg0.id)
						end

						var0:updateActivity(var1)

						local var2 = arg0:getConfig("link_id")

						if var2 > 0 then
							local var3 = var0:getActivityById(var2)

							if var3 and not var3:isEnd() then
								var3.data1 = var3.data1 + 1

								var0:updateActivity(var3)
							end
						end
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0.id, arg0.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0)
			local var0 = getProxy(BayProxy)
			local var1 = var0:getShipById(arg0.count)

			if var1 then
				var1:unlockActivityNpc(0)
				var0:updateShip(var1)
				getProxy(CollectionProxy):flushCollection(var1)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0)
			nowWorld():GetInventoryProxy():AddItem(arg0.id, arg0.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0)
			local var0 = getProxy(AttireProxy)
			local var1 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2 = IconFrame.New({
				id = arg0.id
			})
			local var3 = var1 + var2:getConfig("time_second")

			var2:updateData({
				isNew = true,
				end_time = var3
			})
			var0:addAttireFrame(var2)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0)
			local var0 = getProxy(AttireProxy)
			local var1 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2 = ChatFrame.New({
				id = arg0.id
			})
			local var3 = var1 + var2:getConfig("time_second")

			var2:updateData({
				isNew = true,
				end_time = var3
			})
			var0:addAttireFrame(var2)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2)
		end,
		[DROP_TYPE_EMOJI] = function(arg0)
			getProxy(EmojiProxy):addNewEmojiID(arg0.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0)
			nowWorld():GetCollectionProxy():Unlock(arg0.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0.id):addPT(arg0.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0)
			local var0 = arg0.id
			local var1 = arg0.count
			local var2 = getProxy(ShipSkinProxy)
			local var3 = var2:getSkinById(var0)

			if var3 and var3:isExpireType() then
				local var4 = var1 + var3.endTime
				local var5 = ShipSkin.New({
					id = var0,
					end_time = var4
				})

				var2:addSkin(var5)
			elseif not var3 then
				local var6 = var1 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7 = ShipSkin.New({
					id = var0,
					end_time = var6
				})

				var2:addSkin(var7)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0)
			local var0 = arg0.id
			local var1 = pg.benefit_buff_template[var0]

			assert(var1 and var1.act_id > 0, "should exist act id")

			local var2 = getProxy(ActivityProxy):getActivityById(var1.act_id)

			if var2 and not var2:isEnd() then
				local var3 = var1.max_time
				local var4 = pg.TimeMgr.GetInstance():GetServerTime() + var3

				var2:AddBuff(ActivityBuff.New(var2.id, var0, var4))
				getProxy(ActivityProxy):updateActivity(var2)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0)
			return
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0)
			getProxy(ApartmentProxy):changeGiftCount(arg0.id, arg0.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0)
			local var0 = getProxy(ApartmentProxy)
			local var1 = var0:getApartment(arg0:getConfig("ship_group"))

			var1:addSkin(arg0.id)
			var0:updateApartment(var1)
		end
	}

	function var0.AddItemDefault(arg0)
		if arg0.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0.type].activity_id)

			if arg0.type == DROP_TYPE_RYZA_DROP then
				if var0 and not var0:isEnd() then
					var0:AddItem(AtelierMaterial.New({
						configId = arg0.id,
						count = arg0.count
					}))
					getProxy(ActivityProxy):updateActivity(var0)
				end
			elseif var0 and not var0:isEnd() then
				var0:addVitemNumber(arg0.id, arg0.count)
				getProxy(ActivityProxy):updateActivity(var0)
			end
		else
			print("can not handle this type>>" .. arg0.type)
		end
	end

	var0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0, arg1, arg2)
			local var0 = arg0:getConfig("display")

			if arg0:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0 = string.gsub(var0, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0.extra))
			elseif arg0:getConfig("combination_display") ~= nil then
				local var1 = arg0:getConfig("combination_display")

				if var1 and #var1 > 0 then
					var0 = Item.StaticCombinationDisplay(var1)
				end
			end

			setText(arg2, SwitchSpecialChar(var0, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0, arg1, arg2)
			local var0 = arg0:getConfig("skin_id")
			local var1, var2, var3 = ShipWordHelper.GetWordAndCV(var0, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2, var3 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0, arg1, arg2)
			local var0 = arg0:getConfig("skin_id")
			local var1, var2, var3 = ShipWordHelper.GetWordAndCV(var0, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2, var3 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0, arg1, arg2)
			setText(arg2, arg1.name or arg0:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0, arg1, arg2)
			local var0 = arg0:getConfig("desc")

			for iter0, iter1 in ipairs({
				arg0.count
			}) do
				var0 = string.gsub(var0, "$" .. iter0, iter1)
			end

			setText(arg2, var0)
		end,
		[DROP_TYPE_SKIN] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0, arg1, arg2)
			local var0 = arg0:getConfig("desc")
			local var1 = _.map(arg0:getConfig("equip_type"), function(arg0)
				return EquipType.Type2Name2(arg0)
			end)

			setText(arg2, var0 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0, arg1, arg2, arg3)
			local var0 = WorldCollectionProxy.GetCollectionType(arg0.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2, i18n("world_" .. var0 .. "_desc", arg0:getConfig("name")))
			setText(arg3, i18n("world_" .. var0 .. "_name", arg0:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0, arg1, arg2)
			local var0 = string.gsub(arg0:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0.count))

			setText(arg2, SwitchSpecialChar(var0, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0, arg1, arg2)
			setText(arg2, arg0:getConfig("desc"))
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0, arg1, arg2)
			setText(arg2, "")
		end
	}

	function var0.MsgboxIntroDefault(arg0, arg1, arg2)
		if arg0.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2, arg0:getConfig("display"))
		else
			assert(false, "can not handle this type>>" .. arg0.type)
		end
	end

	var0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0, arg1, arg2)
			if arg0.id == PlayerConst.ResStoreGold or arg0.id == PlayerConst.ResStoreOil then
				arg2 = arg2 or {}
				arg2.frame = "frame_store"
			end

			updateItem(arg1, Item.New({
				id = id2ItemId(arg0.id)
			}), arg2)
		end,
		[DROP_TYPE_ITEM] = function(arg0, arg1, arg2)
			updateItem(arg1, arg0:getSubClass(), arg2)
		end,
		[DROP_TYPE_EQUIP] = function(arg0, arg1, arg2)
			updateEquipment(arg1, arg0:getSubClass(), arg2)
		end,
		[DROP_TYPE_SHIP] = function(arg0, arg1, arg2)
			updateShip(arg1, arg0.ship, arg2)
		end,
		[DROP_TYPE_OPERATION] = function(arg0, arg1, arg2)
			updateShip(arg1, arg0.ship, arg2)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0, arg1, arg2)
			updateFurniture(arg1, arg0, arg2)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0, arg1, arg2)
			arg2.isWorldBuff = arg0.isWorldBuff

			updateStrategy(arg1, arg0, arg2)
		end,
		[DROP_TYPE_SKIN] = function(arg0, arg1, arg2)
			arg2.isSkin = true
			arg2.isNew = arg0.isNew

			updateShip(arg1, Ship.New({
				configId = tonumber(arg0:getConfig("ship_group") .. "1"),
				skin_id = arg0.id
			}), arg2)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0, arg1, arg2)
			local var0 = setmetatable({
				count = arg0.count
			}, {
				__index = arg0:getConfigTable()
			})

			updateEquipmentSkin(arg1, var0, arg2)
		end,
		[DROP_TYPE_VITEM] = function(arg0, arg1, arg2)
			updateItem(arg1, Item.New({
				id = arg0.id
			}), arg2)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0, arg1, arg2)
			updateWorldItem(arg1, WorldItem.New({
				id = arg0.id
			}), arg2)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0, arg1, arg2)
			updateWorldCollection(arg1, arg0, arg2)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0, arg1, arg2)
			updateAttire(arg1, AttireConst.TYPE_CHAT_FRAME, arg0:getConfigTable(), arg2)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0, arg1, arg2)
			updateAttire(arg1, AttireConst.TYPE_ICON_FRAME, arg0:getConfigTable(), arg2)
		end,
		[DROP_TYPE_EMOJI] = function(arg0, arg1, arg2)
			updateEmoji(arg1, arg0:getConfigTable(), arg2)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0, arg1, arg2)
			arg2.count = 1

			updateItem(arg1, arg0:getSubClass(), arg2)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0, arg1, arg2)
			updateSpWeapon(arg1, SpWeapon.New({
				id = arg0.id
			}), arg2)
		end,
		[DROP_TYPE_META_PT] = function(arg0, arg1, arg2)
			updateItem(arg1, Item.New({
				id = arg0:getConfig("id")
			}), arg2)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0, arg1, arg2)
			arg2.isSkin = true
			arg2.isTimeLimit = true
			arg2.count = 1

			updateShip(arg1, Ship.New({
				configId = tonumber(arg0:getConfig("ship_group") .. "1"),
				skin_id = arg0.id
			}), arg2)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0, arg1, arg2)
			AtelierMaterial.UpdateRyzaItem(arg1, arg0.item, arg2)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0, arg1, arg2)
			WorkBenchItem.UpdateDrop(arg1, arg0.item, arg2)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0, arg1, arg2)
			WorkBenchItem.UpdateDrop(arg1, WorkBenchItem.New({
				configId = arg0.id,
				count = arg0.count
			}), arg2)
		end,
		[DROP_TYPE_BUFF] = function(arg0, arg1, arg2)
			updateBuff(arg1, arg0.id, arg2)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0, arg1, arg2)
			updateCommander(arg1, arg0, arg2)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0, arg1, arg2)
			updateDorm3dFurniture(arg1, arg0, arg2)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0, arg1, arg2)
			updateDorm3dGift(arg1, arg0, arg2)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0, arg1, arg2)
			updateDorm3dSkin(arg1, arg0, arg2)
		end
	}

	function var0.UpdateDropDefault(arg0, arg1, arg2)
		warning(string.format("without dropType %d in updateDrop", arg0.type))
	end
end

return var0
