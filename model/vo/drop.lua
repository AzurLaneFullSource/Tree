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
	if arg0_7.type == DROP_TYPE_ICON_FRAME then
		return "Props/icon_frame"
	else
		return arg0_7:getConfig("icon")
	end
end

function var0_0.getCount(arg0_8)
	if arg0_8.type == DROP_TYPE_OPERATION or arg0_8.type == DROP_TYPE_LOVE_LETTER then
		return 1
	else
		return arg0_8.count
	end
end

function var0_0.isLoveLetter(arg0_9)
	return arg0_9.type == DROP_TYPE_LOVE_LETTER or arg0_9.type == DROP_TYPE_ITEM and arg0_9:getConfig("type") == Item.LOVE_LETTER_TYPE
end

function var0_0.getOwnedCount(arg0_10)
	return switch(arg0_10.type, var0_0.CountCase, var0_0.CountDefault, arg0_10)
end

function var0_0.getSubClass(arg0_11)
	return switch(arg0_11.type, var0_0.SubClassCase, var0_0.SubClassDefault, arg0_11)
end

function var0_0.getDropRarity(arg0_12)
	return switch(arg0_12.type, var0_0.RarityCase, var0_0.RarityDefault, arg0_12)
end

function var0_0.getDropRarityDorm(arg0_13)
	return switch(arg0_13.type, var0_0.RarityCase, var0_0.RarityDefaultDorm, arg0_13)
end

function var0_0.DropTrans(arg0_14, ...)
	return switch(arg0_14.type, var0_0.TransCase, var0_0.TransDefault, arg0_14, ...)
end

function var0_0.AddItemOperation(arg0_15)
	return switch(arg0_15.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_15)
end

function var0_0.MsgboxIntroSet(arg0_16, ...)
	return switch(arg0_16.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_16, ...)
end

function var0_0.UpdateDropTpl(arg0_17, ...)
	return switch(arg0_17.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_17, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_19)
			local var0_19 = Item.getConfigData(id2ItemId(arg0_19.id))

			arg0_19.desc = var0_19.display

			return var0_19
		end,
		[DROP_TYPE_ITEM] = function(arg0_20)
			local var0_20 = Item.getConfigData(arg0_20.id)

			arg0_20.desc = var0_20.display

			if var0_20.type == Item.LOVE_LETTER_TYPE then
				arg0_20.desc = string.gsub(arg0_20.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_20.extra))
			end

			return var0_20
		end,
		[DROP_TYPE_VITEM] = function(arg0_21)
			local var0_21 = Item.getConfigData(arg0_21.id)

			assert(var0_21, arg0_21.id)

			arg0_21.desc = var0_21.display

			return var0_21
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_22)
			local var0_22 = Item.getConfigData(arg0_22.id)

			arg0_22.desc = string.gsub(var0_22.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_22.count))

			return var0_22
		end,
		[DROP_TYPE_EQUIP] = function(arg0_23)
			local var0_23 = Equipment.getConfigData(arg0_23.id)

			arg0_23.desc = var0_23.descrip

			return var0_23
		end,
		[DROP_TYPE_SHIP] = function(arg0_24)
			local var0_24 = pg.ship_data_statistics[arg0_24.id]
			local var1_24, var2_24, var3_24 = ShipWordHelper.GetWordAndCV(var0_24.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_24.desc = var3_24 or i18n("ship_drop_desc_default")
			arg0_24.ship = Ship.New({
				configId = arg0_24.id,
				skin_id = arg0_24.skinId,
				propose = arg0_24.propose
			})
			arg0_24.ship.remoulded = arg0_24.remoulded
			arg0_24.ship.virgin = arg0_24.virgin

			return var0_24
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_25)
			local var0_25 = pg.furniture_data_template[arg0_25.id]

			arg0_25.desc = var0_25.describe

			return var0_25
		end,
		[DROP_TYPE_SKIN] = function(arg0_26)
			local var0_26 = pg.ship_skin_template[arg0_26.id]

			if var0_26.skin_type == ShipSkin.SKIN_TYPE_TB then
				local var1_26, var2_26, var3_26 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_26.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_26.desc = var3_26
			else
				local var4_26, var5_26, var6_26 = ShipWordHelper.GetWordAndCV(arg0_26.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_26.desc = var6_26
			end

			return var0_26
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_27)
			local var0_27 = pg.ship_skin_template[arg0_27.id]

			if var0_27.skin_type == ShipSKin.SKIN_TYPE_TB then
				local var1_27, var2_27, var3_27 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_27.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_27.desc = var3_27
			else
				local var4_27, var5_27, var6_27 = ShipWordHelper.GetWordAndCV(arg0_27.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_27.desc = var6_27
			end

			return var0_27
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_28)
			local var0_28 = pg.equip_skin_template[arg0_28.id]

			arg0_28.desc = var0_28.desc

			return var0_28
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_29)
			local var0_29 = pg.world_item_data_template[arg0_29.id]

			arg0_29.desc = var0_29.display

			return var0_29
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_30)
			local var0_30 = pg.item_data_frame[arg0_30.id]

			arg0_30.desc = var0_30.desc

			return var0_30
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_31)
			return pg.item_data_chat[arg0_31.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_32)
			local var0_32 = pg.spweapon_data_statistics[arg0_32.id]

			arg0_32.desc = var0_32.descrip

			return var0_32
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_33)
			local var0_33 = pg.activity_ryza_item[arg0_33.id]

			arg0_33.item = AtelierMaterial.New({
				configId = arg0_33.id
			})
			arg0_33.desc = arg0_33.item:GetDesc()

			return var0_33
		end,
		[DROP_TYPE_OPERATION] = function(arg0_34)
			arg0_34.ship = getProxy(BayProxy):getShipById(arg0_34.count)

			local var0_34 = pg.ship_data_statistics[arg0_34.ship.configId]
			local var1_34, var2_34, var3_34 = ShipWordHelper.GetWordAndCV(var0_34.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_34.desc = var3_34 or i18n("ship_drop_desc_default")

			return var0_34
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_35)
			return arg0_35.isWorldBuff and pg.world_SLGbuff_data[arg0_35.id] or pg.strategy_data_template[arg0_35.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_36)
			local var0_36 = pg.emoji_template[arg0_36.id]

			arg0_36.name = var0_36.item_name
			arg0_36.desc = var0_36.item_desc

			return var0_36
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_37)
			local var0_37 = WorldCollectionProxy.GetCollectionTemplate(arg0_37.id)

			arg0_37.desc = var0_37.name

			return var0_37
		end,
		[DROP_TYPE_META_PT] = function(arg0_38)
			local var0_38 = pg.ship_strengthen_meta[arg0_38.id]
			local var1_38 = Item.getConfigData(var0_38.itemid)

			arg0_38.desc = var1_38.display

			return var1_38
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_39)
			local var0_39 = pg.activity_workbench_item[arg0_39.id]

			arg0_39.item = WorkBenchItem.New({
				configId = arg0_39.id
			})
			arg0_39.desc = arg0_39.item:GetDesc()

			return var0_39
		end,
		[DROP_TYPE_BUFF] = function(arg0_40)
			local var0_40 = pg.benefit_buff_template[arg0_40.id]

			arg0_40.desc = var0_40.desc

			return var0_40
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_41)
			local var0_41 = pg.commander_data_template[arg0_41.id]

			arg0_41.desc = var0_41.desc

			return var0_41
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_42)
			local var0_42 = pg.island_item_data_template[arg0_42.id]

			arg0_42.desc = ""

			return var0_42
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_43)
			local var0_43 = pg.island_ability_template[arg0_43.id]

			arg0_43.desc = ""

			return var0_43
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_44)
			return pg.drop_data_restore[arg0_44.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_45)
			local var0_45 = pg.dorm3d_furniture_template[arg0_45.id]

			arg0_45.desc = var0_45.desc

			return var0_45
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_46)
			local var0_46 = pg.dorm3d_gift[arg0_46.id]

			arg0_46.desc = var0_46.display

			return var0_46
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_47)
			local var0_47 = pg.dorm3d_resource[arg0_47.id]

			arg0_47.desc = ""

			return var0_47
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_48)
			local var0_48 = pg.livingarea_cover[arg0_48.id]

			arg0_48.desc = var0_48.desc

			return var0_48
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_49)
			return pg.item_data_battleui[arg0_49.id]
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_50)
			local var0_50 = pg.activity_medal_template[arg0_50.id].item

			return pg.item_virtual_data_statistics[var0_50]
		end
	}

	function var0_0.ConfigDefault(arg0_51)
		local var0_51 = arg0_51.type

		if var0_51 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_51 = pg.activity_drop_type[var0_51].relevance

			return var1_51 and pg[var1_51][arg0_51.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_52)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_52.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_53)
			local var0_53 = getProxy(BagProxy):getItemCountById(arg0_53.id)

			if arg0_53:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_53, 1), true
			else
				return var0_53, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_54)
			local var0_54 = arg0_54:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_54], "equip groupId not exist")

			local var1_54 = pg.equip_data_template.get_id_list_by_group[var0_54]

			return underscore.reduce(var1_54, 0, function(arg0_55, arg1_55)
				local var0_55 = getProxy(EquipmentProxy):getEquipmentById(arg1_55)

				return arg0_55 + (var0_55 and var0_55.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_55)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_56)
			return getProxy(BayProxy):getConfigShipCount(arg0_56.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_57)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_57.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_58)
			return arg0_58.count, tobool(arg0_58.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_59)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_59.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_60)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_60.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_61)
			if arg0_61:getConfig("virtual_type") == 22 then
				local var0_61 = getProxy(ActivityProxy):getActivityById(arg0_61:getConfig("link_id"))

				return var0_61 and var0_61.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_62)
			local var0_62 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_62.id)

			return (var0_62 and var0_62.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_62.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_63)
			local var0_63 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_63.type].activity_id):GetItemById(arg0_63.id)

			return var0_63 and var0_63.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_64)
			local var0_64 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_64.id)

			return var0_64 and (not var0_64:expiredType() or not not var0_64:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_65)
			local var0_65 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_65.id)

			return var0_65 and (not var0_65:expiredType() or not not var0_65:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_66)
			local var0_66 = nowWorld()

			if var0_66.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_66:GetInventoryProxy():GetItemCount(arg0_66.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_67)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_67.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_68)
			local var0_68 = getProxy(LivingAreaCoverProxy):GetCover(arg0_68.id)

			return var0_68 and var0_68:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_69)
			return getProxy(ApartmentProxy):getGiftCount(arg0_69.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_70)
			local var0_70 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_70.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_71)
			local var0_71 = 0
			local var1_71 = getProxy(IslandProxy):GetIsland()

			if var1_71 then
				var0_71 = var1_71:GetInventoryAgency():GetOwnCount(arg0_71.id)
			end

			return var0_71
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_72)
			return 0
		end
	}

	function var0_0.CountDefault(arg0_73)
		local var0_73 = arg0_73.type

		if var0_73 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_73].activity_id):getVitemNumber(arg0_73.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_74)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_75)
			return Item.New(arg0_75)
		end,
		[DROP_TYPE_VITEM] = function(arg0_76)
			return Item.New(arg0_76)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_77)
			return Equipment.New(arg0_77)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_78)
			return Item.New({
				count = 1,
				id = arg0_78.id,
				extra = arg0_78.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_79)
			return WorldItem.New(arg0_79)
		end
	}

	function var0_0.SubClassDefault(arg0_80)
		assert(false, string.format("drop type %d without subClass", arg0_80.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_81)
			return arg0_81:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_82)
			return arg0_82:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_83)
			return arg0_83:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_84)
			return arg0_84:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_85)
			return arg0_85:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_86)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_87)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_88)
			return arg0_88:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_89)
			return arg0_89:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_90)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_91)
			return arg0_91:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_92)
			return arg0_92:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_93)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_94)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_95)
			return arg0_95:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_96)
			return arg0_96:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_97)
			return arg0_97:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_98)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_99)
		return arg0_99:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_100)
		return arg0_100:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_101)
			local var0_101 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_101:getConfig("resource_type"),
				count = arg0_101:getConfig("resource_num") * arg0_101.count
			})
			local var1_101 = Drop.New({
				type = arg0_101:getConfig("target_type"),
				id = arg0_101:getConfig("target_id")
			})

			var0_101.name = string.format("%s(%s)", var0_101:getName(), var1_101:getName())

			return var0_101
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_102)
			for iter0_102, iter1_102 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_102.id].pt == arg0_102.id then
					return nil, arg0_102
				end
			end

			return arg0_102
		end,
		[DROP_TYPE_OPERATION] = function(arg0_103)
			if arg0_103.id ~= 3 then
				return nil
			end

			return arg0_103
		end,
		[DROP_TYPE_EMOJI] = function(arg0_104)
			return nil, arg0_104
		end,
		[DROP_TYPE_VITEM] = function(arg0_105, arg1_105, arg2_105)
			assert(arg0_105:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_105.id)

			return switch(arg0_105:getConfig("virtual_type"), {
				function()
					if arg0_105:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_105
					end

					return arg0_105
				end,
				[6] = function()
					local var0_107 = arg2_105.taskId
					local var1_107 = getProxy(ActivityProxy)
					local var2_107 = var1_107:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_107 then
						local var3_107 = var2_107.data1KeyValueList[1]

						var3_107[var0_107] = defaultValue(var3_107[var0_107], 0) + arg0_105.count

						var1_107:updateActivity(var2_107)
					end

					return nil, arg0_105
				end,
				[13] = function()
					local var0_108 = arg0_105:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_108))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_108))

						return nil
					else
						return arg0_105, nil
					end
				end,
				[21] = function()
					return nil, arg0_105
				end,
				[28] = function()
					local var0_110 = Drop.New({
						type = arg0_105.type,
						id = arg0_105.id,
						count = math.floor(arg0_105.count / 1000)
					})
					local var1_110 = Drop.New({
						type = arg0_105.type,
						id = arg0_105.id,
						count = arg0_105.count - math.floor(arg0_105.count / 1000)
					})

					return var0_110, var1_110
				end
			}, function()
				return arg0_105
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_112, arg1_112)
			if Ship.isMetaShipByConfigID(arg0_112.id) and Player.isMetaShipNeedToTrans(arg0_112.id) then
				local var0_112 = table.indexof(arg1_112, arg0_112.id, 1)

				if var0_112 then
					table.remove(arg1_112, var0_112)
				else
					local var1_112 = Player.metaShip2Res(arg0_112.id)
					local var2_112 = Drop.New(var1_112[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_112.id, var2_112)

					return arg0_112, var2_112
				end
			end

			return arg0_112
		end,
		[DROP_TYPE_SKIN] = function(arg0_113)
			arg0_113.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_113.id)

			return arg0_113
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_114)
			local var0_114 = getProxy(PlayerProxy):getRawData()
			local var1_114 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_114:updateMedalList({
				{
					key = arg0_114.id,
					value = var1_114
				}
			})

			return arg0_114
		end
	}

	function var0_0.TransDefault(arg0_115)
		return arg0_115
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_116)
			local var0_116 = id2res(arg0_116.id)

			assert(var0_116, "res should be defined: " .. arg0_116.id)

			local var1_116 = getProxy(PlayerProxy)
			local var2_116 = var1_116:getData()

			var2_116:addResources({
				[var0_116] = arg0_116.count
			})
			var1_116:updatePlayer(var2_116)
		end,
		[DROP_TYPE_ITEM] = function(arg0_117)
			if arg0_117:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_117 = getProxy(BagProxy):getItemCountById(arg0_117.id)
				local var1_117 = math.min(arg0_117:getConfig("max_num") - var0_117, arg0_117.count)

				if var1_117 > 0 then
					getProxy(BagProxy):addItemById(arg0_117.id, var1_117)
				end
			else
				getProxy(BagProxy):addItemById(arg0_117.id, arg0_117.count, arg0_117.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_118)
			local var0_118 = arg0_118:getSubClass()

			getProxy(BagProxy):addItemById(var0_118.id, var0_118.count, var0_118.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_119)
			getProxy(EquipmentProxy):addEquipmentById(arg0_119.id, arg0_119.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_120)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_121)
			local var0_121 = getProxy(DormProxy)
			local var1_121 = Furniture.New({
				id = arg0_121.id,
				count = arg0_121.count
			})

			if var1_121:isRecordTime() then
				var1_121.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_121:AddFurniture(var1_121)
		end,
		[DROP_TYPE_SKIN] = function(arg0_122)
			local var0_122 = getProxy(ShipSkinProxy)
			local var1_122 = ShipSkin.New({
				id = arg0_122.id
			})

			var0_122:addSkin(var1_122)
		end,
		[DROP_TYPE_VITEM] = function(arg0_123)
			arg0_123 = arg0_123:getSubClass()

			assert(arg0_123:isVirtualItem(), "item type error(virtual item)>>" .. arg0_123.id)
			switch(arg0_123:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_123.id, arg0_123.count)
				end,
				function()
					local var0_125 = getProxy(ActivityProxy)
					local var1_125 = arg0_123:getConfig("link_id")
					local var2_125

					if var1_125 > 0 then
						var2_125 = var0_125:getActivityById(var1_125)
					else
						var2_125 = var0_125:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_125 and not var2_125:isEnd() then
						if not table.contains(var2_125.data1_list, arg0_123.id) then
							table.insert(var2_125.data1_list, arg0_123.id)
						end

						var0_125:updateActivity(var2_125)
					end
				end,
				function()
					local var0_126 = getProxy(ActivityProxy)
					local var1_126 = var0_126:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_126, iter1_126 in ipairs(var1_126) do
						iter1_126.data1 = iter1_126.data1 + arg0_123.count

						local var2_126 = iter1_126:getConfig("config_id")
						local var3_126 = pg.activity_vote[var2_126]

						if var3_126 and var3_126.ticket_id_period == arg0_123.id then
							iter1_126.data3 = iter1_126.data3 + arg0_123.count
						end

						var0_126:updateActivity(iter1_126)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_123.id,
							ptCount = arg0_123.count
						})
					end
				end,
				[4] = function()
					local var0_127 = getProxy(ColoringProxy):getColorItems()

					var0_127[arg0_123.id] = (var0_127[arg0_123.id] or 0) + arg0_123.count
				end,
				[6] = function()
					local var0_128 = getProxy(ActivityProxy)
					local var1_128 = var0_128:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_128 then
						var1_128.data3 = var1_128.data3 + arg0_123.count

						var0_128:updateActivity(var1_128)
					end
				end,
				[7] = function()
					local var0_129 = getProxy(ChapterProxy)

					var0_129:updateRemasterTicketsNum(math.min(var0_129.remasterTickets + arg0_123.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_130 = getProxy(ActivityProxy)
					local var1_130 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_130 then
						var1_130.data1_list[1] = var1_130.data1_list[1] + arg0_123.count

						var0_130:updateActivity(var1_130)
					end
				end,
				[10] = function()
					local var0_131 = getProxy(ActivityProxy)
					local var1_131 = var0_131:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_131 and not var1_131:isEnd() then
						var1_131.data1 = var1_131.data1 + arg0_123.count

						var0_131:updateActivity(var1_131)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_131
						})
					end
				end,
				[11] = function()
					local var0_132 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_132 and not var0_132:isEnd() then
						var0_132.data1 = var0_132.data1 + arg0_123.count
					end
				end,
				[12] = function()
					local var0_133 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_133 and not var0_133:isEnd() then
						var0_133.data1KeyValueList[1][arg0_123.id] = (var0_133.data1KeyValueList[1][arg0_123.id] or 0) + arg0_123.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_123.id, arg0_123.count)
				end,
				[14] = function()
					local var0_135 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_123.id then
						var0_135:AddSummonPt(arg0_123.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_123.id then
						var0_135:AddSummonPtOld(arg0_123.count)
					end
				end,
				[15] = function()
					local var0_136 = getProxy(ActivityProxy)
					local var1_136 = var0_136:getActivityById(arg0_123:getConfig("link_id"))

					if not var1_136 or var1_136:isEnd() then
						return
					end

					if var1_136:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_136 = pg.activity_event_grid[var1_136.data1]

						if arg0_123.id == var2_136.ticket_item then
							var1_136.data2 = var1_136.data2 + arg0_123.count
						elseif arg0_123.id == var2_136.explore_item then
							var1_136.data3 = var1_136.data3 + arg0_123.count
						end
					elseif var1_136:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_136.data3 = var1_136.data3 + arg0_123.count
					end

					var0_136:updateActivity(var1_136)
				end,
				[16] = function()
					local var0_137 = getProxy(ActivityProxy)
					local var1_137 = var0_137:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_137, iter1_137 in pairs(var1_137) do
						if iter1_137 and not iter1_137:isEnd() and arg0_123.id == iter1_137:getConfig("config_id") then
							iter1_137.data1 = iter1_137.data1 + arg0_123.count

							var0_137:updateActivity(iter1_137)
						end
					end
				end,
				[20] = function()
					local var0_138 = getProxy(BagProxy)
					local var1_138 = pg.gameset.urpt_chapter_max.description
					local var2_138 = var1_138[1]
					local var3_138 = var1_138[2]
					local var4_138 = var0_138:GetLimitCntById(var2_138)
					local var5_138 = math.min(var3_138 - var4_138, arg0_123.count)

					if var5_138 > 0 then
						var0_138:addItemById(var2_138, var5_138)
						var0_138:AddLimitCnt(var2_138, var5_138)
					end
				end,
				[21] = function()
					local var0_139 = getProxy(ActivityProxy)
					local var1_139 = var0_139:getActivityById(arg0_123:getConfig("link_id"))

					if var1_139 and not var1_139:isEnd() then
						var1_139.data2 = 1

						var0_139:updateActivity(var1_139)
					end
				end,
				[22] = function()
					local var0_140 = getProxy(ActivityProxy)
					local var1_140 = var0_140:getActivityById(arg0_123:getConfig("link_id"))

					if var1_140 and not var1_140:isEnd() then
						var1_140.data1 = var1_140.data1 + arg0_123.count

						var0_140:updateActivity(var1_140)
					end
				end,
				[23] = function()
					local var0_141 = (function()
						for iter0_142, iter1_142 in ipairs(pg.gameset.package_lv.description) do
							if arg0_123.id == iter1_142[1] then
								return iter1_142[2]
							end
						end
					end)()

					assert(var0_141)

					local var1_141 = getProxy(PlayerProxy)
					local var2_141 = var1_141:getData()

					var2_141:addExpToLevel(var0_141)
					var1_141:updatePlayer(var2_141)
				end,
				[24] = function()
					local var0_143 = arg0_123:getConfig("link_id")
					local var1_143 = getProxy(ActivityProxy):getActivityById(var0_143)

					if var1_143 and not var1_143:isEnd() and var1_143:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_143.data2 = var1_143.data2 + arg0_123.count

						getProxy(ActivityProxy):updateActivity(var1_143)
					end
				end,
				[25] = function()
					local var0_144 = getProxy(ActivityProxy)
					local var1_144 = var0_144:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_144 and not var1_144:isEnd() then
						var1_144.data1 = var1_144.data1 - 1

						if not table.contains(var1_144.data1_list, arg0_123.id) then
							table.insert(var1_144.data1_list, arg0_123.id)
						end

						var0_144:updateActivity(var1_144)

						local var2_144 = arg0_123:getConfig("link_id")

						if var2_144 > 0 then
							local var3_144 = var0_144:getActivityById(var2_144)

							if var3_144 and not var3_144:isEnd() then
								var3_144.data1 = var3_144.data1 + 1

								var0_144:updateActivity(var3_144)
							end
						end
					end
				end,
				[50] = function()
					local var0_145 = getProxy(IslandProxy):GetIsland()

					if var0_145 then
						var0_145:AddExp(arg0_123.count)
					end
				end,
				[51] = function()
					local var0_146 = getProxy(IslandProxy):GetIsland()

					if not var0_146 then
						return
					end

					local var1_146 = var0_146:GetOrderAgency()

					if not var1_146 then
						return
					end

					var1_146:AddExp(arg0_123.count)
				end,
				[26] = function()
					local var0_147 = getProxy(ActivityProxy)
					local var1_147 = Clone(var0_147:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_147 and not var1_147:isEnd() then
						var1_147.data1 = var1_147.data1 + arg0_123.count

						var0_147:updateActivity(var1_147)
					end
				end,
				[27] = function()
					local var0_148 = getProxy(ActivityProxy)
					local var1_148 = Clone(var0_148:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_148 and not var1_148:isEnd() then
						var1_148:AddExp(arg0_123.count)
						var0_148:updateActivity(var1_148)
					end
				end,
				[28] = function()
					local var0_149 = getProxy(ActivityProxy)
					local var1_149 = Clone(var0_149:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_149 and not var1_149:isEnd() then
						var1_149:AddGold(arg0_123.count)
						var0_149:updateActivity(var1_149)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_152 = arg0_123:getConfig("link_id")
					local var1_152 = getProxy(ActivityProxy):getActivityById(var0_152)

					if var1_152 and not var1_152:isEnd() then
						var1_152.data1 = var1_152.data1 + arg0_123.count

						getProxy(ActivityProxy):updateActivity(var1_152)
					end
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_153)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_153.id, arg0_153.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_154)
			local var0_154 = getProxy(BayProxy)
			local var1_154 = var0_154:getShipById(arg0_154.count)

			if var1_154 then
				var1_154:unlockActivityNpc(0)
				var0_154:updateShip(var1_154)
				getProxy(CollectionProxy):flushCollection(var1_154)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_155)
			nowWorld():GetInventoryProxy():AddItem(arg0_155.id, arg0_155.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_156)
			local var0_156 = getProxy(AttireProxy)
			local var1_156 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_156 = IconFrame.New({
				id = arg0_156.id
			})
			local var3_156 = var1_156 + var2_156:getConfig("time_second")

			var2_156:updateData({
				isNew = true,
				end_time = var3_156
			})
			var0_156:addAttireFrame(var2_156)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_156)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_157)
			local var0_157 = getProxy(AttireProxy)
			local var1_157 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_157 = ChatFrame.New({
				id = arg0_157.id
			})
			local var3_157 = var1_157 + var2_157:getConfig("time_second")

			var2_157:updateData({
				isNew = true,
				end_time = var3_157
			})
			var0_157:addAttireFrame(var2_157)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_157)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_158)
			getProxy(EmojiProxy):addNewEmojiID(arg0_158.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_158:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_159)
			nowWorld():GetCollectionProxy():Unlock(arg0_159.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_160)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_160.id):addPT(arg0_160.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_161)
			local var0_161 = arg0_161.id
			local var1_161 = arg0_161.count
			local var2_161 = getProxy(ShipSkinProxy)
			local var3_161 = var2_161:getSkinById(var0_161)

			if var3_161 and var3_161:isExpireType() then
				local var4_161 = var1_161 + var3_161.endTime
				local var5_161 = ShipSkin.New({
					id = var0_161,
					end_time = var4_161
				})

				var2_161:addSkin(var5_161)
			elseif not var3_161 then
				local var6_161 = var1_161 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_161 = ShipSkin.New({
					id = var0_161,
					end_time = var6_161
				})

				var2_161:addSkin(var7_161)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_162)
			local var0_162 = arg0_162.id
			local var1_162 = pg.benefit_buff_template[var0_162]

			assert(var1_162 and var1_162.act_id > 0, "should exist act id")

			local var2_162 = getProxy(ActivityProxy):getActivityById(var1_162.act_id)

			if var2_162 and not var2_162:isEnd() then
				local var3_162 = var1_162.max_time
				local var4_162 = pg.TimeMgr.GetInstance():GetServerTime() + var3_162

				var2_162:AddBuff(ActivityBuff.New(var2_162.id, var0_162, var4_162))
				getProxy(ActivityProxy):updateActivity(var2_162)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_163)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_164)
			local var0_164 = getProxy(ApartmentProxy)
			local var1_164 = var0_164:getRoom(arg0_164:getConfig("room_id"))

			var1_164:AddFurnitureByID(arg0_164.id)
			var0_164:updateRoom(var1_164)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_165)
			getProxy(ApartmentProxy):changeGiftCount(arg0_165.id, arg0_165.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_166)
			local var0_166 = getProxy(ApartmentProxy)
			local var1_166 = var0_166:getApartment(arg0_166:getConfig("ship_group"))

			var1_166:addSkin(arg0_166.id)
			var0_166:updateApartment(var1_166)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_167)
			local var0_167 = getProxy(LivingAreaCoverProxy)
			local var1_167 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_167.id
			})

			var0_167:UpdateCover(var1_167)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_167)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_167.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_168)
			local var0_168 = getProxy(AttireProxy)
			local var1_168 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_168 = CombatUIStyle.New({
				id = arg0_168.id
			})

			var2_168:setUnlock()
			var2_168:setNew()
			var0_168:addAttireFrame(var2_168)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_168)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_169)
			getProxy(IslandProxy):GetIsland():GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_169.id,
				num = arg0_169.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_170)
		if arg0_170.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_170 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_170.type].activity_id)

			if arg0_170.type == DROP_TYPE_RYZA_DROP then
				if var0_170 and not var0_170:isEnd() then
					var0_170:AddItem(AtelierMaterial.New({
						configId = arg0_170.id,
						count = arg0_170.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_170)
				end
			elseif var0_170 and not var0_170:isEnd() then
				var0_170:addVitemNumber(arg0_170.id, arg0_170.count)
				getProxy(ActivityProxy):updateActivity(var0_170)
			end
		else
			print("can not handle this type>>" .. arg0_170.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_171, arg1_171, arg2_171)
			setText(arg2_171, arg0_171:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_172, arg1_172, arg2_172)
			local var0_172 = arg0_172:getConfig("display")

			if arg0_172:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_172 = string.gsub(var0_172, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_172.extra))
			elseif arg0_172:getConfig("combination_display") ~= nil then
				local var1_172 = arg0_172:getConfig("combination_display")

				if var1_172 and #var1_172 > 0 then
					var0_172 = Item.StaticCombinationDisplay(var1_172)
				end
			end

			setText(arg2_172, SwitchSpecialChar(var0_172, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_173, arg1_173, arg2_173)
			setText(arg2_173, arg0_173:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_174, arg1_174, arg2_174)
			local var0_174 = arg0_174:getConfig("skin_id")
			local var1_174, var2_174, var3_174 = ShipWordHelper.GetWordAndCV(var0_174, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_174, var3_174 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_175, arg1_175, arg2_175)
			local var0_175 = arg0_175:getConfig("skin_id")
			local var1_175, var2_175, var3_175 = ShipWordHelper.GetWordAndCV(var0_175, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_175, var3_175 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_176, arg1_176, arg2_176)
			setText(arg2_176, arg1_176.name or arg0_176:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_177, arg1_177, arg2_177)
			local var0_177 = arg0_177:getConfig("desc")

			for iter0_177, iter1_177 in ipairs({
				arg0_177.count
			}) do
				var0_177 = string.gsub(var0_177, "$" .. iter0_177, iter1_177)
			end

			setText(arg2_177, var0_177)
		end,
		[DROP_TYPE_SKIN] = function(arg0_178, arg1_178, arg2_178)
			setText(arg2_178, arg0_178:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_179, arg1_179, arg2_179)
			setText(arg2_179, arg0_179:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_180, arg1_180, arg2_180)
			local var0_180 = arg0_180:getConfig("desc")
			local var1_180 = _.map(arg0_180:getConfig("equip_type"), function(arg0_181)
				return EquipType.Type2Name2(arg0_181)
			end)

			setText(arg2_180, var0_180 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_180, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_182, arg1_182, arg2_182)
			setText(arg2_182, arg0_182:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_183, arg1_183, arg2_183)
			setText(arg2_183, arg0_183:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_184, arg1_184, arg2_184, arg3_184)
			local var0_184 = WorldCollectionProxy.GetCollectionType(arg0_184.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_184, i18n("world_" .. var0_184 .. "_desc", arg0_184:getConfig("name")))
			setText(arg3_184, i18n("world_" .. var0_184 .. "_name", arg0_184:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_185, arg1_185, arg2_185)
			setText(arg2_185, arg0_185:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_186, arg1_186, arg2_186)
			setText(arg2_186, arg0_186:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_187, arg1_187, arg2_187)
			setText(arg2_187, arg0_187:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_188, arg1_188, arg2_188)
			local var0_188 = string.gsub(arg0_188:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_188.count))

			setText(arg2_188, SwitchSpecialChar(var0_188, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_189, arg1_189, arg2_189)
			setText(arg2_189, arg0_189:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_190, arg1_190, arg2_190)
			setText(arg2_190, arg0_190:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_191, arg1_191, arg2_191)
			setText(arg2_191, arg0_191:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_192, arg1_192, arg2_192)
			setText(arg2_192, arg0_192:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_193, arg1_193, arg2_193)
			setText(arg2_193, arg0_193:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_194, arg1_194, arg2_194)
			setText(arg2_194, arg0_194:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_195, arg1_195, arg2_195)
			setText(arg2_195, "")
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_196, arg1_196, arg2_196)
		if arg0_196.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_196, arg0_196:getConfig("display"))
		else
			setText(arg2_196, arg0_196.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_197, arg1_197, arg2_197)
			if arg0_197.id == PlayerConst.ResStoreGold or arg0_197.id == PlayerConst.ResStoreOil then
				arg2_197 = arg2_197 or {}
				arg2_197.frame = "frame_store"
			end

			updateItem(arg1_197, Item.New({
				id = id2ItemId(arg0_197.id)
			}), arg2_197)
		end,
		[DROP_TYPE_ITEM] = function(arg0_198, arg1_198, arg2_198)
			updateItem(arg1_198, arg0_198:getSubClass(), arg2_198)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_199, arg1_199, arg2_199)
			updateEquipment(arg1_199, arg0_199:getSubClass(), arg2_199)
		end,
		[DROP_TYPE_SHIP] = function(arg0_200, arg1_200, arg2_200)
			updateShip(arg1_200, arg0_200.ship, arg2_200)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_201, arg1_201, arg2_201)
			updateShip(arg1_201, arg0_201.ship, arg2_201)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_202, arg1_202, arg2_202)
			updateFurniture(arg1_202, arg0_202, arg2_202)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_203, arg1_203, arg2_203)
			arg2_203.isWorldBuff = arg0_203.isWorldBuff

			updateStrategy(arg1_203, arg0_203, arg2_203)
		end,
		[DROP_TYPE_SKIN] = function(arg0_204, arg1_204, arg2_204)
			arg2_204.isSkin = true
			arg2_204.isNew = arg0_204.isNew

			updateShip(arg1_204, Ship.New({
				configId = tonumber(arg0_204:getConfig("ship_group") .. "1"),
				skin_id = arg0_204.id
			}), arg2_204)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_205, arg1_205, arg2_205)
			local var0_205 = setmetatable({
				count = arg0_205.count
			}, {
				__index = arg0_205:getConfigTable()
			})

			updateEquipmentSkin(arg1_205, var0_205, arg2_205)
		end,
		[DROP_TYPE_VITEM] = function(arg0_206, arg1_206, arg2_206)
			updateItem(arg1_206, Item.New({
				id = arg0_206.id
			}), arg2_206)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_207, arg1_207, arg2_207)
			updateWorldItem(arg1_207, WorldItem.New({
				id = arg0_207.id
			}), arg2_207)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_208, arg1_208, arg2_208)
			updateWorldCollection(arg1_208, arg0_208, arg2_208)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_209, arg1_209, arg2_209)
			updateAttire(arg1_209, AttireConst.TYPE_CHAT_FRAME, arg0_209:getConfigTable(), arg2_209)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_210, arg1_210, arg2_210)
			updateAttire(arg1_210, AttireConst.TYPE_ICON_FRAME, arg0_210:getConfigTable(), arg2_210)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_211, arg1_211, arg2_211)
			updateEmoji(arg1_211, arg0_211:getConfigTable(), arg2_211)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_212, arg1_212, arg2_212)
			arg2_212.count = 1

			updateItem(arg1_212, arg0_212:getSubClass(), arg2_212)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_213, arg1_213, arg2_213)
			updateSpWeapon(arg1_213, SpWeapon.New({
				id = arg0_213.id
			}), arg2_213)
		end,
		[DROP_TYPE_META_PT] = function(arg0_214, arg1_214, arg2_214)
			updateItem(arg1_214, Item.New({
				id = arg0_214:getConfig("id")
			}), arg2_214)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_215, arg1_215, arg2_215)
			arg2_215.isSkin = true
			arg2_215.isTimeLimit = true
			arg2_215.count = 1

			updateShip(arg1_215, Ship.New({
				configId = tonumber(arg0_215:getConfig("ship_group") .. "1"),
				skin_id = arg0_215.id
			}), arg2_215)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_216, arg1_216, arg2_216)
			AtelierMaterial.UpdateRyzaItem(arg1_216, arg0_216.item, arg2_216)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_217, arg1_217, arg2_217)
			WorkBenchItem.UpdateDrop(arg1_217, arg0_217.item, arg2_217)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_218, arg1_218, arg2_218)
			WorkBenchItem.UpdateDrop(arg1_218, WorkBenchItem.New({
				configId = arg0_218.id,
				count = arg0_218.count
			}), arg2_218)
		end,
		[DROP_TYPE_BUFF] = function(arg0_219, arg1_219, arg2_219)
			updateBuff(arg1_219, arg0_219.id, arg2_219)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_220, arg1_220, arg2_220)
			updateCommander(arg1_220, arg0_220, arg2_220)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_221, arg1_221, arg2_221)
			updateDorm3dFurniture(arg1_221, arg0_221, arg2_221)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_222, arg1_222, arg2_222)
			updateDorm3dGift(arg1_222, arg0_222, arg2_222)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_223, arg1_223, arg2_223)
			updateDorm3dSkin(arg1_223, arg0_223, arg2_223)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_224, arg1_224, arg2_224)
			updateCover(arg1_224, arg0_224, arg2_224)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_225, arg1_225, arg2_225)
			updateAttireCombatUI(arg1_225, AttireConst.TYPE_ICON_FRAME, arg0_225:getConfigTable(), arg2_225)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_226, arg1_226, arg2_226)
			updateActivityMedal(arg1_226, arg0_226:getConfigTable(), arg2_226)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_227, arg1_227, arg2_227)
			updateIslandItem(arg1_227, arg0_227, arg2_227)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_228, arg1_228, arg2_228)
			updateIslandUnlock(arg1_228, arg0_228, arg2_228)
		end
	}

	function var0_0.UpdateDropDefault(arg0_229, arg1_229, arg2_229)
		warning(string.format("without dropType %d in updateDrop", arg0_229.type))
	end
end

return var0_0
