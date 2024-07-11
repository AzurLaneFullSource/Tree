local var0_0 = class("Drop", import(".BaseVO"))

function var0_0.Create(arg0_1)
	local var0_1 = {}

	var0_1.type, var0_1.id, var0_1.count = unpack(arg0_1)

	return var0_0.New(var0_1)
end

function var0_0.Change(arg0_2)
	if not getmetatable(arg0_2) then
		setmetatable(arg0_2, var0_0)

		arg0_2.class = var0_0

		arg0_2:InitConfig()
	else
		assert(instanceof(arg0_2, var0_0))
	end

	return arg0_2
end

function var0_0.Ctor(arg0_3, arg1_3)
	assert(not getmetatable(arg1_3), "drop data should not has metatable")

	for iter0_3, iter1_3 in pairs(arg1_3) do
		arg0_3[iter0_3] = iter1_3
	end

	arg0_3:InitConfig()
end

function var0_0.InitConfig(arg0_4)
	if not var0_0.inited then
		var0_0.InitSwitch()
	end

	arg0_4.configId = arg0_4.id
	arg0_4.cfg = switch(arg0_4.type, var0_0.ConfigCase, var0_0.ConfigDefault, arg0_4)
end

function var0_0.getConfigTable(arg0_5)
	return arg0_5.cfg
end

function var0_0.getName(arg0_6)
	return arg0_6.name or arg0_6:getConfig("name")
end

function var0_0.getIcon(arg0_7)
	return arg0_7:getConfig("icon")
end

function var0_0.getCount(arg0_8)
	if arg0_8.type == DROP_TYPE_OPERATION or arg0_8.type == DROP_TYPE_LOVE_LETTER then
		return 1
	else
		return arg0_8.count
	end
end

function var0_0.getOwnedCount(arg0_9)
	return switch(arg0_9.type, var0_0.CountCase, var0_0.CountDefault, arg0_9)
end

function var0_0.getSubClass(arg0_10)
	return switch(arg0_10.type, var0_0.SubClassCase, var0_0.SubClassDefault, arg0_10)
end

function var0_0.getDropRarity(arg0_11)
	return switch(arg0_11.type, var0_0.RarityCase, var0_0.RarityDefault, arg0_11)
end

function var0_0.DropTrans(arg0_12, ...)
	return switch(arg0_12.type, var0_0.TransCase, var0_0.TransDefault, arg0_12, ...)
end

function var0_0.AddItemOperation(arg0_13)
	return switch(arg0_13.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_13)
end

function var0_0.MsgboxIntroSet(arg0_14, ...)
	return switch(arg0_14.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_14, ...)
end

function var0_0.UpdateDropTpl(arg0_15, ...)
	return switch(arg0_15.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_15, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_17)
			local var0_17 = Item.getConfigData(id2ItemId(arg0_17.id))

			arg0_17.desc = var0_17.display

			return var0_17
		end,
		[DROP_TYPE_ITEM] = function(arg0_18)
			local var0_18 = Item.getConfigData(arg0_18.id)

			arg0_18.desc = var0_18.display

			if var0_18.type == Item.LOVE_LETTER_TYPE then
				arg0_18.desc = string.gsub(arg0_18.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_18.extra))
			end

			return var0_18
		end,
		[DROP_TYPE_VITEM] = function(arg0_19)
			local var0_19 = Item.getConfigData(arg0_19.id)

			arg0_19.desc = var0_19.display

			return var0_19
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_20)
			local var0_20 = Item.getConfigData(arg0_20.id)

			arg0_20.desc = string.gsub(var0_20.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_20.count))

			return var0_20
		end,
		[DROP_TYPE_EQUIP] = function(arg0_21)
			local var0_21 = Equipment.getConfigData(arg0_21.id)

			arg0_21.desc = var0_21.descrip

			return var0_21
		end,
		[DROP_TYPE_SHIP] = function(arg0_22)
			local var0_22 = pg.ship_data_statistics[arg0_22.id]
			local var1_22, var2_22, var3_22 = ShipWordHelper.GetWordAndCV(var0_22.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_22.desc = var3_22 or i18n("ship_drop_desc_default")
			arg0_22.ship = Ship.New({
				configId = arg0_22.id,
				skin_id = arg0_22.skinId,
				propose = arg0_22.propose
			})
			arg0_22.ship.remoulded = arg0_22.remoulded
			arg0_22.ship.virgin = arg0_22.virgin

			return var0_22
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_23)
			local var0_23 = pg.furniture_data_template[arg0_23.id]

			arg0_23.desc = var0_23.describe

			return var0_23
		end,
		[DROP_TYPE_SKIN] = function(arg0_24)
			local var0_24 = pg.ship_skin_template[arg0_24.id]
			local var1_24, var2_24, var3_24 = ShipWordHelper.GetWordAndCV(arg0_24.id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_24.desc = var3_24

			return var0_24
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_25)
			local var0_25 = pg.ship_skin_template[arg0_25.id]
			local var1_25, var2_25, var3_25 = ShipWordHelper.GetWordAndCV(arg0_25.id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_25.desc = var3_25

			return var0_25
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_26)
			local var0_26 = pg.equip_skin_template[arg0_26.id]

			arg0_26.desc = var0_26.desc

			return var0_26
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_27)
			local var0_27 = pg.world_item_data_template[arg0_27.id]

			arg0_27.desc = var0_27.display

			return var0_27
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_28)
			return pg.item_data_frame[arg0_28.id]
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_29)
			return pg.item_data_chat[arg0_29.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_30)
			local var0_30 = pg.spweapon_data_statistics[arg0_30.id]

			arg0_30.desc = var0_30.descrip

			return var0_30
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_31)
			local var0_31 = pg.activity_ryza_item[arg0_31.id]

			arg0_31.item = AtelierMaterial.New({
				configId = arg0_31.id
			})
			arg0_31.desc = arg0_31.item:GetDesc()

			return var0_31
		end,
		[DROP_TYPE_OPERATION] = function(arg0_32)
			arg0_32.ship = getProxy(BayProxy):getShipById(arg0_32.count)

			local var0_32 = pg.ship_data_statistics[arg0_32.ship.configId]
			local var1_32, var2_32, var3_32 = ShipWordHelper.GetWordAndCV(var0_32.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_32.desc = var3_32 or i18n("ship_drop_desc_default")

			return var0_32
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_33)
			return arg0_33.isWorldBuff and pg.world_SLGbuff_data[arg0_33.id] or pg.strategy_data_template[arg0_33.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_34)
			local var0_34 = pg.emoji_template[arg0_34.id]

			arg0_34.name = var0_34.item_name
			arg0_34.desc = var0_34.item_desc

			return var0_34
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_35)
			local var0_35 = WorldCollectionProxy.GetCollectionTemplate(arg0_35.id)

			arg0_35.desc = var0_35.name

			return var0_35
		end,
		[DROP_TYPE_META_PT] = function(arg0_36)
			local var0_36 = pg.ship_strengthen_meta[arg0_36.id]
			local var1_36 = Item.getConfigData(var0_36.itemid)

			arg0_36.desc = var1_36.display

			return var1_36
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_37)
			local var0_37 = pg.activity_workbench_item[arg0_37.id]

			arg0_37.item = WorkBenchItem.New({
				configId = arg0_37.id
			})
			arg0_37.desc = arg0_37.item:GetDesc()

			return var0_37
		end,
		[DROP_TYPE_BUFF] = function(arg0_38)
			local var0_38 = pg.benefit_buff_template[arg0_38.id]

			arg0_38.desc = var0_38.desc

			return var0_38
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_39)
			local var0_39 = pg.commander_data_template[arg0_39.id]

			arg0_39.desc = ""

			return var0_39
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_40)
			return pg.drop_data_restore[arg0_40.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_41)
			local var0_41 = pg.dorm3d_furniture_template[arg0_41.id]

			arg0_41.desc = var0_41.desc

			return var0_41
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_42)
			local var0_42 = pg.dorm3d_gift[arg0_42.id]

			arg0_42.desc = ""

			return var0_42
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_43)
			local var0_43 = pg.dorm3d_resource[arg0_43.id]

			arg0_43.desc = ""

			return var0_43
		end
	}

	function var0_0.ConfigDefault(arg0_44)
		local var0_44 = arg0_44.type

		if var0_44 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_44 = pg.activity_drop_type[var0_44].relevance

			return var1_44 and pg[var1_44][arg0_44.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_45)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_45.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_46)
			local var0_46 = getProxy(BagProxy):getItemCountById(arg0_46.id)

			if arg0_46:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_46, 1), true
			else
				return var0_46, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_47)
			local var0_47 = arg0_47:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_47], "equip groupId not exist")

			local var1_47 = pg.equip_data_template.get_id_list_by_group[var0_47]

			return underscore.reduce(var1_47, 0, function(arg0_48, arg1_48)
				local var0_48 = getProxy(EquipmentProxy):getEquipmentById(arg1_48)

				return arg0_48 + (var0_48 and var0_48.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_48)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_49)
			return getProxy(BayProxy):getConfigShipCount(arg0_49.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_50)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_50.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_51)
			return arg0_51.count, tobool(arg0_51.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_52)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_52.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_53)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_53.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_54)
			if arg0_54:getConfig("virtual_type") == 22 then
				local var0_54 = getProxy(ActivityProxy):getActivityById(arg0_54:getConfig("link_id"))

				return var0_54 and var0_54.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_55)
			local var0_55 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_55.id)

			return (var0_55 and var0_55.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_55.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_56)
			local var0_56 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_56.type].activity_id):GetItemById(arg0_56.id)

			return var0_56 and var0_56.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_57)
			local var0_57 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_57.id)

			return var0_57 and (not var0_57:expiredType() or not not var0_57:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_58)
			local var0_58 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_58.id)

			return var0_58 and (not var0_58:expiredType() or not not var0_58:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_59)
			local var0_59 = nowWorld()

			if var0_59.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_59:GetInventoryProxy():GetItemCount(arg0_59.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_60)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_60.id)
		end
	}

	function var0_0.CountDefault(arg0_61)
		local var0_61 = arg0_61.type

		if var0_61 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_61].activity_id):getVitemNumber(arg0_61.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_62)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_63)
			return Item.New(arg0_63)
		end,
		[DROP_TYPE_VITEM] = function(arg0_64)
			return Item.New(arg0_64)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_65)
			return Equipment.New(arg0_65)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_66)
			return Item.New({
				count = 1,
				id = arg0_66.id,
				extra = arg0_66.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_67)
			return WorldItem.New(arg0_67)
		end
	}

	function var0_0.SubClassDefault(arg0_68)
		assert(false, string.format("drop type %d without subClass", arg0_68.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_69)
			return arg0_69:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_70)
			return arg0_70:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_71)
			return arg0_71:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_72)
			return arg0_72:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_73)
			return arg0_73:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_74)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_75)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_76)
			return arg0_76:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_77)
			return arg0_77:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_78)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_79)
			return arg0_79:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_80)
			return arg0_80:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_81)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_82)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_83)
		return 1
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_84)
			local var0_84 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_84:getConfig("resource_type"),
				count = arg0_84:getConfig("resource_num") * arg0_84.count
			})
			local var1_84 = Drop.New({
				type = arg0_84:getConfig("target_type"),
				id = arg0_84:getConfig("target_id")
			})

			var0_84.name = string.format("%s(%s)", var0_84:getName(), var1_84:getName())

			return var0_84
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_85)
			for iter0_85, iter1_85 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_85.id].pt == arg0_85.id then
					return nil, arg0_85
				end
			end

			return arg0_85
		end,
		[DROP_TYPE_OPERATION] = function(arg0_86)
			if arg0_86.id ~= 3 then
				return nil
			end

			return arg0_86
		end,
		[DROP_TYPE_VITEM] = function(arg0_87, arg1_87, arg2_87)
			assert(arg0_87:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_87.id)

			return switch(arg0_87:getConfig("virtual_type"), {
				function()
					if arg0_87:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_87
					end

					return arg0_87
				end,
				[6] = function()
					local var0_89 = arg2_87.taskId
					local var1_89 = getProxy(ActivityProxy)
					local var2_89 = var1_89:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_89 then
						local var3_89 = var2_89.data1KeyValueList[1]

						var3_89[var0_89] = defaultValue(var3_89[var0_89], 0) + arg0_87.count

						var1_89:updateActivity(var2_89)
					end

					return nil, arg0_87
				end,
				[13] = function()
					local var0_90 = arg0_87:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_90))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_90))

						return nil
					elseif SkinCouponActivity.StaticOwnAllSkin() then
						if arg0_87.count > 1 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_90))
						end

						return SkinCouponActivity.StaticGetEquivalentRes(), nil
					else
						return arg0_87, nil
					end
				end,
				[21] = function()
					return nil, arg0_87
				end
			}, function()
				return arg0_87
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_93, arg1_93)
			if Ship.isMetaShipByConfigID(arg0_93.id) and Player.isMetaShipNeedToTrans(arg0_93.id) then
				local var0_93 = table.indexof(arg1_93, arg0_93.id, 1)

				if var0_93 then
					table.remove(arg1_93, var0_93)
				else
					local var1_93 = Player.metaShip2Res(arg0_93.id)
					local var2_93 = Drop.New(var1_93[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_93.id, var2_93)

					return arg0_93, var2_93
				end
			end

			return arg0_93
		end,
		[DROP_TYPE_SKIN] = function(arg0_94)
			arg0_94.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_94.id)

			return arg0_94
		end
	}

	function var0_0.TransDefault(arg0_95)
		return arg0_95
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_96)
			local var0_96 = id2res(arg0_96.id)

			assert(var0_96, "res should be defined: " .. arg0_96.id)

			local var1_96 = getProxy(PlayerProxy)
			local var2_96 = var1_96:getData()

			var2_96:addResources({
				[var0_96] = arg0_96.count
			})
			var1_96:updatePlayer(var2_96)
		end,
		[DROP_TYPE_ITEM] = function(arg0_97)
			if arg0_97:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_97 = getProxy(BagProxy):getItemCountById(arg0_97.id)
				local var1_97 = math.min(arg0_97:getConfig("max_num") - var0_97, arg0_97.count)

				if var1_97 > 0 then
					getProxy(BagProxy):addItemById(arg0_97.id, var1_97)
				end
			else
				getProxy(BagProxy):addItemById(arg0_97.id, arg0_97.count, arg0_97.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_98)
			local var0_98 = arg0_98:getSubClass()

			getProxy(BagProxy):addItemById(var0_98.id, var0_98.count, var0_98.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_99)
			getProxy(EquipmentProxy):addEquipmentById(arg0_99.id, arg0_99.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_100)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_101)
			local var0_101 = getProxy(DormProxy)
			local var1_101 = Furniture.New({
				id = arg0_101.id,
				count = arg0_101.count
			})

			if var1_101:isRecordTime() then
				var1_101.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_101:AddFurniture(var1_101)
		end,
		[DROP_TYPE_SKIN] = function(arg0_102)
			local var0_102 = getProxy(ShipSkinProxy)
			local var1_102 = ShipSkin.New({
				id = arg0_102.id
			})

			var0_102:addSkin(var1_102)
		end,
		[DROP_TYPE_VITEM] = function(arg0_103)
			arg0_103 = arg0_103:getSubClass()

			assert(arg0_103:isVirtualItem(), "item type error(virtual item)>>" .. arg0_103.id)
			switch(arg0_103:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_103.id, arg0_103.count)
				end,
				function()
					local var0_105 = getProxy(ActivityProxy)
					local var1_105 = arg0_103:getConfig("link_id")
					local var2_105

					if var1_105 > 0 then
						var2_105 = var0_105:getActivityById(var1_105)
					else
						var2_105 = var0_105:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_105 and not var2_105:isEnd() then
						if not table.contains(var2_105.data1_list, arg0_103.id) then
							table.insert(var2_105.data1_list, arg0_103.id)
						end

						var0_105:updateActivity(var2_105)
					end
				end,
				function()
					local var0_106 = getProxy(ActivityProxy)
					local var1_106 = var0_106:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_106, iter1_106 in ipairs(var1_106) do
						iter1_106.data1 = iter1_106.data1 + arg0_103.count

						local var2_106 = iter1_106:getConfig("config_id")
						local var3_106 = pg.activity_vote[var2_106]

						if var3_106 and var3_106.ticket_id_period == arg0_103.id then
							iter1_106.data3 = iter1_106.data3 + arg0_103.count
						end

						var0_106:updateActivity(iter1_106)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_103.id,
							ptCount = arg0_103.count
						})
					end
				end,
				[4] = function()
					local var0_107 = getProxy(ColoringProxy):getColorItems()

					var0_107[arg0_103.id] = (var0_107[arg0_103.id] or 0) + arg0_103.count
				end,
				[6] = function()
					local var0_108 = getProxy(ActivityProxy)
					local var1_108 = var0_108:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_108 then
						var1_108.data3 = var1_108.data3 + arg0_103.count

						var0_108:updateActivity(var1_108)
					end
				end,
				[7] = function()
					local var0_109 = getProxy(ChapterProxy)

					var0_109:updateRemasterTicketsNum(math.min(var0_109.remasterTickets + arg0_103.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_110 = getProxy(ActivityProxy)
					local var1_110 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_110 then
						var1_110.data1_list[1] = var1_110.data1_list[1] + arg0_103.count

						var0_110:updateActivity(var1_110)
					end
				end,
				[10] = function()
					local var0_111 = getProxy(ActivityProxy)
					local var1_111 = var0_111:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_111 and not var1_111:isEnd() then
						var1_111.data1 = var1_111.data1 + arg0_103.count

						var0_111:updateActivity(var1_111)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_111
						})
					end
				end,
				[11] = function()
					local var0_112 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_112 and not var0_112:isEnd() then
						var0_112.data1 = var0_112.data1 + arg0_103.count
					end
				end,
				[12] = function()
					local var0_113 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_113 and not var0_113:isEnd() then
						var0_113.data1KeyValueList[1][arg0_103.id] = (var0_113.data1KeyValueList[1][arg0_103.id] or 0) + arg0_103.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_103.id)
				end,
				[14] = function()
					local var0_115 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_103.id then
						var0_115:AddSummonPt(arg0_103.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_103.id then
						var0_115:AddSummonPtOld(arg0_103.count)
					end
				end,
				[15] = function()
					local var0_116 = getProxy(ActivityProxy)
					local var1_116 = var0_116:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

					if var1_116 and not var1_116:isEnd() then
						local var2_116 = pg.activity_event_grid[var1_116.data1]

						if arg0_103.id == var2_116.ticket_item then
							var1_116.data2 = var1_116.data2 + arg0_103.count
						elseif arg0_103.id == var2_116.explore_item then
							var1_116.data3 = var1_116.data3 + arg0_103.count
						end
					end

					var0_116:updateActivity(var1_116)
				end,
				[16] = function()
					local var0_117 = getProxy(ActivityProxy)
					local var1_117 = var0_117:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_117, iter1_117 in pairs(var1_117) do
						if iter1_117 and not iter1_117:isEnd() and arg0_103.id == iter1_117:getConfig("config_id") then
							iter1_117.data1 = iter1_117.data1 + arg0_103.count

							var0_117:updateActivity(iter1_117)
						end
					end
				end,
				[20] = function()
					local var0_118 = getProxy(BagProxy)
					local var1_118 = pg.gameset.urpt_chapter_max.description
					local var2_118 = var1_118[1]
					local var3_118 = var1_118[2]
					local var4_118 = var0_118:GetLimitCntById(var2_118)
					local var5_118 = math.min(var3_118 - var4_118, arg0_103.count)

					if var5_118 > 0 then
						var0_118:addItemById(var2_118, var5_118)
						var0_118:AddLimitCnt(var2_118, var5_118)
					end
				end,
				[21] = function()
					local var0_119 = getProxy(ActivityProxy)
					local var1_119 = var0_119:getActivityById(arg0_103:getConfig("link_id"))

					if var1_119 and not var1_119:isEnd() then
						var1_119.data2 = 1

						var0_119:updateActivity(var1_119)
					end
				end,
				[22] = function()
					local var0_120 = getProxy(ActivityProxy)
					local var1_120 = var0_120:getActivityById(arg0_103:getConfig("link_id"))

					if var1_120 and not var1_120:isEnd() then
						var1_120.data1 = var1_120.data1 + arg0_103.count

						var0_120:updateActivity(var1_120)
					end
				end,
				[23] = function()
					local var0_121 = (function()
						for iter0_122, iter1_122 in ipairs(pg.gameset.package_lv.description) do
							if arg0_103.id == iter1_122[1] then
								return iter1_122[2]
							end
						end
					end)()

					assert(var0_121)

					local var1_121 = getProxy(PlayerProxy)
					local var2_121 = var1_121:getData()

					var2_121:addExpToLevel(var0_121)
					var1_121:updatePlayer(var2_121)
				end,
				[24] = function()
					local var0_123 = arg0_103:getConfig("link_id")
					local var1_123 = getProxy(ActivityProxy):getActivityById(var0_123)

					if var1_123 and not var1_123:isEnd() and var1_123:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_123.data2 = var1_123.data2 + arg0_103.count

						getProxy(ActivityProxy):updateActivity(var1_123)
					end
				end,
				[25] = function()
					local var0_124 = getProxy(ActivityProxy)
					local var1_124 = var0_124:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_124 and not var1_124:isEnd() then
						var1_124.data1 = var1_124.data1 - 1

						if not table.contains(var1_124.data1_list, arg0_103.id) then
							table.insert(var1_124.data1_list, arg0_103.id)
						end

						var0_124:updateActivity(var1_124)

						local var2_124 = arg0_103:getConfig("link_id")

						if var2_124 > 0 then
							local var3_124 = var0_124:getActivityById(var2_124)

							if var3_124 and not var3_124:isEnd() then
								var3_124.data1 = var3_124.data1 + 1

								var0_124:updateActivity(var3_124)
							end
						end
					end
				end,
				[26] = function()
					local var0_125 = getProxy(ActivityProxy)
					local var1_125 = Clone(var0_125:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_125 and not var1_125:isEnd() then
						var1_125.data1 = var1_125.data1 + arg0_103.count

						var0_125:updateActivity(var1_125)
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
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_128)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_128.id, arg0_128.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_129)
			local var0_129 = getProxy(BayProxy)
			local var1_129 = var0_129:getShipById(arg0_129.count)

			if var1_129 then
				var1_129:unlockActivityNpc(0)
				var0_129:updateShip(var1_129)
				getProxy(CollectionProxy):flushCollection(var1_129)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_130)
			nowWorld():GetInventoryProxy():AddItem(arg0_130.id, arg0_130.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_131)
			local var0_131 = getProxy(AttireProxy)
			local var1_131 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_131 = IconFrame.New({
				id = arg0_131.id
			})
			local var3_131 = var1_131 + var2_131:getConfig("time_second")

			var2_131:updateData({
				isNew = true,
				end_time = var3_131
			})
			var0_131:addAttireFrame(var2_131)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_131)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_132)
			local var0_132 = getProxy(AttireProxy)
			local var1_132 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_132 = ChatFrame.New({
				id = arg0_132.id
			})
			local var3_132 = var1_132 + var2_132:getConfig("time_second")

			var2_132:updateData({
				isNew = true,
				end_time = var3_132
			})
			var0_132:addAttireFrame(var2_132)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_132)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_133)
			getProxy(EmojiProxy):addNewEmojiID(arg0_133.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_133:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_134)
			nowWorld():GetCollectionProxy():Unlock(arg0_134.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_135)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_135.id):addPT(arg0_135.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_136)
			local var0_136 = arg0_136.id
			local var1_136 = arg0_136.count
			local var2_136 = getProxy(ShipSkinProxy)
			local var3_136 = var2_136:getSkinById(var0_136)

			if var3_136 and var3_136:isExpireType() then
				local var4_136 = var1_136 + var3_136.endTime
				local var5_136 = ShipSkin.New({
					id = var0_136,
					end_time = var4_136
				})

				var2_136:addSkin(var5_136)
			elseif not var3_136 then
				local var6_136 = var1_136 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_136 = ShipSkin.New({
					id = var0_136,
					end_time = var6_136
				})

				var2_136:addSkin(var7_136)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_137)
			local var0_137 = arg0_137.id
			local var1_137 = pg.benefit_buff_template[var0_137]

			assert(var1_137 and var1_137.act_id > 0, "should exist act id")

			local var2_137 = getProxy(ActivityProxy):getActivityById(var1_137.act_id)

			if var2_137 and not var2_137:isEnd() then
				local var3_137 = var1_137.max_time
				local var4_137 = pg.TimeMgr.GetInstance():GetServerTime() + var3_137

				var2_137:AddBuff(ActivityBuff.New(var2_137.id, var0_137, var4_137))
				getProxy(ActivityProxy):updateActivity(var2_137)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_138)
			return
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_139)
			getProxy(ApartmentProxy):changeGiftCount(arg0_139.id, arg0_139.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_140)
			local var0_140 = getProxy(ApartmentProxy)
			local var1_140 = var0_140:getApartment(arg0_140:getConfig("ship_group"))

			var1_140:addSkin(arg0_140.id)
			var0_140:updateApartment(var1_140)
		end
	}

	function var0_0.AddItemDefault(arg0_141)
		if arg0_141.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_141 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_141.type].activity_id)

			if arg0_141.type == DROP_TYPE_RYZA_DROP then
				if var0_141 and not var0_141:isEnd() then
					var0_141:AddItem(AtelierMaterial.New({
						configId = arg0_141.id,
						count = arg0_141.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_141)
				end
			elseif var0_141 and not var0_141:isEnd() then
				var0_141:addVitemNumber(arg0_141.id, arg0_141.count)
				getProxy(ActivityProxy):updateActivity(var0_141)
			end
		else
			print("can not handle this type>>" .. arg0_141.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_142, arg1_142, arg2_142)
			setText(arg2_142, arg0_142:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_143, arg1_143, arg2_143)
			local var0_143 = arg0_143:getConfig("display")

			if arg0_143:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_143 = string.gsub(var0_143, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_143.extra))
			elseif arg0_143:getConfig("combination_display") ~= nil then
				local var1_143 = arg0_143:getConfig("combination_display")

				if var1_143 and #var1_143 > 0 then
					var0_143 = Item.StaticCombinationDisplay(var1_143)
				end
			end

			setText(arg2_143, SwitchSpecialChar(var0_143, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_144, arg1_144, arg2_144)
			setText(arg2_144, arg0_144:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_145, arg1_145, arg2_145)
			local var0_145 = arg0_145:getConfig("skin_id")
			local var1_145, var2_145, var3_145 = ShipWordHelper.GetWordAndCV(var0_145, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_145, var3_145 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_146, arg1_146, arg2_146)
			local var0_146 = arg0_146:getConfig("skin_id")
			local var1_146, var2_146, var3_146 = ShipWordHelper.GetWordAndCV(var0_146, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_146, var3_146 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_147, arg1_147, arg2_147)
			setText(arg2_147, arg1_147.name or arg0_147:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_148, arg1_148, arg2_148)
			local var0_148 = arg0_148:getConfig("desc")

			for iter0_148, iter1_148 in ipairs({
				arg0_148.count
			}) do
				var0_148 = string.gsub(var0_148, "$" .. iter0_148, iter1_148)
			end

			setText(arg2_148, var0_148)
		end,
		[DROP_TYPE_SKIN] = function(arg0_149, arg1_149, arg2_149)
			setText(arg2_149, arg0_149:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_150, arg1_150, arg2_150)
			setText(arg2_150, arg0_150:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_151, arg1_151, arg2_151)
			local var0_151 = arg0_151:getConfig("desc")
			local var1_151 = _.map(arg0_151:getConfig("equip_type"), function(arg0_152)
				return EquipType.Type2Name2(arg0_152)
			end)

			setText(arg2_151, var0_151 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_151, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_153, arg1_153, arg2_153)
			setText(arg2_153, arg0_153:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_154, arg1_154, arg2_154)
			setText(arg2_154, arg0_154:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_155, arg1_155, arg2_155, arg3_155)
			local var0_155 = WorldCollectionProxy.GetCollectionType(arg0_155.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_155, i18n("world_" .. var0_155 .. "_desc", arg0_155:getConfig("name")))
			setText(arg3_155, i18n("world_" .. var0_155 .. "_name", arg0_155:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_156, arg1_156, arg2_156)
			setText(arg2_156, arg0_156:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_157, arg1_157, arg2_157)
			setText(arg2_157, arg0_157:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_158, arg1_158, arg2_158)
			setText(arg2_158, arg0_158:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_159, arg1_159, arg2_159)
			local var0_159 = string.gsub(arg0_159:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_159.count))

			setText(arg2_159, SwitchSpecialChar(var0_159, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_160, arg1_160, arg2_160)
			setText(arg2_160, arg0_160:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_161, arg1_161, arg2_161)
			setText(arg2_161, arg0_161:getConfig("desc"))
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_162, arg1_162, arg2_162)
			setText(arg2_162, "")
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_163, arg1_163, arg2_163)
		if arg0_163.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_163, arg0_163:getConfig("display"))
		else
			assert(false, "can not handle this type>>" .. arg0_163.type)
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_164, arg1_164, arg2_164)
			if arg0_164.id == PlayerConst.ResStoreGold or arg0_164.id == PlayerConst.ResStoreOil then
				arg2_164 = arg2_164 or {}
				arg2_164.frame = "frame_store"
			end

			updateItem(arg1_164, Item.New({
				id = id2ItemId(arg0_164.id)
			}), arg2_164)
		end,
		[DROP_TYPE_ITEM] = function(arg0_165, arg1_165, arg2_165)
			updateItem(arg1_165, arg0_165:getSubClass(), arg2_165)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_166, arg1_166, arg2_166)
			updateEquipment(arg1_166, arg0_166:getSubClass(), arg2_166)
		end,
		[DROP_TYPE_SHIP] = function(arg0_167, arg1_167, arg2_167)
			updateShip(arg1_167, arg0_167.ship, arg2_167)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_168, arg1_168, arg2_168)
			updateShip(arg1_168, arg0_168.ship, arg2_168)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_169, arg1_169, arg2_169)
			updateFurniture(arg1_169, arg0_169, arg2_169)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_170, arg1_170, arg2_170)
			arg2_170.isWorldBuff = arg0_170.isWorldBuff

			updateStrategy(arg1_170, arg0_170, arg2_170)
		end,
		[DROP_TYPE_SKIN] = function(arg0_171, arg1_171, arg2_171)
			arg2_171.isSkin = true
			arg2_171.isNew = arg0_171.isNew

			updateShip(arg1_171, Ship.New({
				configId = tonumber(arg0_171:getConfig("ship_group") .. "1"),
				skin_id = arg0_171.id
			}), arg2_171)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_172, arg1_172, arg2_172)
			local var0_172 = setmetatable({
				count = arg0_172.count
			}, {
				__index = arg0_172:getConfigTable()
			})

			updateEquipmentSkin(arg1_172, var0_172, arg2_172)
		end,
		[DROP_TYPE_VITEM] = function(arg0_173, arg1_173, arg2_173)
			updateItem(arg1_173, Item.New({
				id = arg0_173.id
			}), arg2_173)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_174, arg1_174, arg2_174)
			updateWorldItem(arg1_174, WorldItem.New({
				id = arg0_174.id
			}), arg2_174)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_175, arg1_175, arg2_175)
			updateWorldCollection(arg1_175, arg0_175, arg2_175)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_176, arg1_176, arg2_176)
			updateAttire(arg1_176, AttireConst.TYPE_CHAT_FRAME, arg0_176:getConfigTable(), arg2_176)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_177, arg1_177, arg2_177)
			updateAttire(arg1_177, AttireConst.TYPE_ICON_FRAME, arg0_177:getConfigTable(), arg2_177)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_178, arg1_178, arg2_178)
			updateEmoji(arg1_178, arg0_178:getConfigTable(), arg2_178)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_179, arg1_179, arg2_179)
			arg2_179.count = 1

			updateItem(arg1_179, arg0_179:getSubClass(), arg2_179)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_180, arg1_180, arg2_180)
			updateSpWeapon(arg1_180, SpWeapon.New({
				id = arg0_180.id
			}), arg2_180)
		end,
		[DROP_TYPE_META_PT] = function(arg0_181, arg1_181, arg2_181)
			updateItem(arg1_181, Item.New({
				id = arg0_181:getConfig("id")
			}), arg2_181)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_182, arg1_182, arg2_182)
			arg2_182.isSkin = true
			arg2_182.isTimeLimit = true
			arg2_182.count = 1

			updateShip(arg1_182, Ship.New({
				configId = tonumber(arg0_182:getConfig("ship_group") .. "1"),
				skin_id = arg0_182.id
			}), arg2_182)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_183, arg1_183, arg2_183)
			AtelierMaterial.UpdateRyzaItem(arg1_183, arg0_183.item, arg2_183)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_184, arg1_184, arg2_184)
			WorkBenchItem.UpdateDrop(arg1_184, arg0_184.item, arg2_184)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_185, arg1_185, arg2_185)
			WorkBenchItem.UpdateDrop(arg1_185, WorkBenchItem.New({
				configId = arg0_185.id,
				count = arg0_185.count
			}), arg2_185)
		end,
		[DROP_TYPE_BUFF] = function(arg0_186, arg1_186, arg2_186)
			updateBuff(arg1_186, arg0_186.id, arg2_186)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_187, arg1_187, arg2_187)
			updateCommander(arg1_187, arg0_187, arg2_187)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_188, arg1_188, arg2_188)
			updateDorm3dFurniture(arg1_188, arg0_188, arg2_188)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_189, arg1_189, arg2_189)
			updateDorm3dGift(arg1_189, arg0_189, arg2_189)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_190, arg1_190, arg2_190)
			updateDorm3dSkin(arg1_190, arg0_190, arg2_190)
		end
	}

	function var0_0.UpdateDropDefault(arg0_191, arg1_191, arg2_191)
		warning(string.format("without dropType %d in updateDrop", arg0_191.type))
	end
end

return var0_0
