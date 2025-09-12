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
	return switch(arg0_7.type, {
		[DROP_TYPE_ICON_FRAME] = function()
			return "Props/icon_frame"
		end,
		[DROP_TYPE_ISLAND_ITEM] = function()
			return "island/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function()
			return "island/" .. arg0_7:getConfig("cmd_icon")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function()
			return "island/" .. arg0_7:getConfig("icon")
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function()
			return "island/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function()
			return "island/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			return "island/IslandFurnitureIcon/" .. arg0_7:getConfig("icon")
		end
	}, function()
		return arg0_7:getConfig("icon")
	end)
end

function var0_0.getCount(arg0_16)
	if arg0_16.type == DROP_TYPE_OPERATION or arg0_16.type == DROP_TYPE_LOVE_LETTER then
		return 1
	else
		return arg0_16.count
	end
end

function var0_0.isLoveLetter(arg0_17)
	return arg0_17.type == DROP_TYPE_LOVE_LETTER or arg0_17.type == DROP_TYPE_ITEM and arg0_17:getConfig("type") == Item.LOVE_LETTER_TYPE
end

function var0_0.getOwnedCount(arg0_18)
	return switch(arg0_18.type, var0_0.CountCase, var0_0.CountDefault, arg0_18)
end

function var0_0.getSubClass(arg0_19)
	return switch(arg0_19.type, var0_0.SubClassCase, var0_0.SubClassDefault, arg0_19)
end

function var0_0.getDropRarity(arg0_20)
	return switch(arg0_20.type, var0_0.RarityCase, var0_0.RarityDefault, arg0_20)
end

function var0_0.getDropRarityDorm(arg0_21)
	return switch(arg0_21.type, var0_0.RarityCase, var0_0.RarityDefaultDorm, arg0_21)
end

function var0_0.DropTrans(arg0_22, ...)
	return switch(arg0_22.type, var0_0.TransCase, var0_0.TransDefault, arg0_22, ...)
end

function var0_0.AddItemOperation(arg0_23)
	return switch(arg0_23.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_23)
end

function var0_0.MsgboxIntroSet(arg0_24, ...)
	return switch(arg0_24.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_24, ...)
end

function var0_0.UpdateDropTpl(arg0_25, ...)
	return switch(arg0_25.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_25, ...)
end

function var0_0.UpdateCustomDropTpl(arg0_26, ...)
	return switch(arg0_26.type, var0_0.UpdateCustomDropCase, var0_0.UpdateCustomDropDefault, arg0_26, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_28)
			local var0_28 = Item.getConfigData(id2ItemId(arg0_28.id))

			arg0_28.desc = var0_28.display

			return var0_28
		end,
		[DROP_TYPE_ITEM] = function(arg0_29)
			local var0_29 = Item.getConfigData(arg0_29.id)

			arg0_29.desc = var0_29.display

			if var0_29.type == Item.LOVE_LETTER_TYPE then
				arg0_29.desc = string.gsub(arg0_29.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_29.extra))
			end

			return var0_29
		end,
		[DROP_TYPE_VITEM] = function(arg0_30)
			local var0_30 = Item.getConfigData(arg0_30.id)

			assert(var0_30, arg0_30.id)

			arg0_30.desc = var0_30.display

			return var0_30
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_31)
			local var0_31 = Item.getConfigData(arg0_31.id)

			arg0_31.desc = string.gsub(var0_31.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_31.count))

			return var0_31
		end,
		[DROP_TYPE_EQUIP] = function(arg0_32)
			local var0_32 = Equipment.getConfigData(arg0_32.id)

			arg0_32.desc = var0_32.descrip

			return var0_32
		end,
		[DROP_TYPE_SHIP] = function(arg0_33)
			local var0_33 = pg.ship_data_statistics[arg0_33.id]
			local var1_33, var2_33, var3_33 = ShipWordHelper.GetWordAndCV(var0_33.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_33.desc = var3_33 or i18n("ship_drop_desc_default")
			arg0_33.ship = Ship.New({
				configId = arg0_33.id,
				skin_id = arg0_33.skinId,
				propose = arg0_33.propose
			})
			arg0_33.ship.remoulded = arg0_33.remoulded
			arg0_33.ship.virgin = arg0_33.virgin

			return var0_33
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_34)
			local var0_34 = pg.furniture_data_template[arg0_34.id]

			arg0_34.desc = var0_34.describe

			return var0_34
		end,
		[DROP_TYPE_SKIN] = function(arg0_35)
			local var0_35 = pg.ship_skin_template[arg0_35.id]

			if var0_35.skin_type == ShipSkin.SKIN_TYPE_TB then
				local var1_35, var2_35, var3_35 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_35.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_35.desc = var3_35
			else
				local var4_35, var5_35, var6_35 = ShipWordHelper.GetWordAndCV(arg0_35.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_35.desc = var6_35
			end

			return var0_35
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_36)
			local var0_36 = pg.ship_skin_template[arg0_36.id]

			if var0_36.skin_type == ShipSKin.SKIN_TYPE_TB then
				local var1_36, var2_36, var3_36 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_36.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_36.desc = var3_36
			else
				local var4_36, var5_36, var6_36 = ShipWordHelper.GetWordAndCV(arg0_36.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_36.desc = var6_36
			end

			return var0_36
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_37)
			local var0_37 = pg.equip_skin_template[arg0_37.id]

			arg0_37.desc = var0_37.desc

			return var0_37
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_38)
			local var0_38 = pg.world_item_data_template[arg0_38.id]

			arg0_38.desc = var0_38.display

			return var0_38
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_39)
			local var0_39 = pg.item_data_frame[arg0_39.id]

			arg0_39.desc = var0_39.desc

			return var0_39
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_40)
			return pg.item_data_chat[arg0_40.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_41)
			local var0_41 = pg.spweapon_data_statistics[arg0_41.id]

			arg0_41.desc = var0_41.descrip

			return var0_41
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_42)
			local var0_42 = pg.activity_ryza_item[arg0_42.id]

			arg0_42.item = AtelierMaterial.New({
				configId = arg0_42.id
			})
			arg0_42.desc = arg0_42.item:GetDesc()

			return var0_42
		end,
		[DROP_TYPE_OPERATION] = function(arg0_43)
			arg0_43.ship = getProxy(BayProxy):getShipById(arg0_43.count)

			local var0_43 = pg.ship_data_statistics[arg0_43.ship.configId]
			local var1_43, var2_43, var3_43 = ShipWordHelper.GetWordAndCV(var0_43.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_43.desc = var3_43 or i18n("ship_drop_desc_default")

			return var0_43
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_44)
			return arg0_44.isWorldBuff and pg.world_SLGbuff_data[arg0_44.id] or pg.strategy_data_template[arg0_44.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_45)
			local var0_45 = pg.emoji_template[arg0_45.id]

			arg0_45.name = var0_45.item_name
			arg0_45.desc = var0_45.item_desc

			return var0_45
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_46)
			local var0_46 = WorldCollectionProxy.GetCollectionTemplate(arg0_46.id)

			arg0_46.desc = var0_46.name

			return var0_46
		end,
		[DROP_TYPE_META_PT] = function(arg0_47)
			local var0_47 = pg.ship_strengthen_meta[arg0_47.id]
			local var1_47 = Item.getConfigData(var0_47.itemid)

			arg0_47.desc = var1_47.display

			return var1_47
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_48)
			local var0_48 = pg.activity_workbench_item[arg0_48.id]

			arg0_48.item = WorkBenchItem.New({
				configId = arg0_48.id
			})
			arg0_48.desc = arg0_48.item:GetDesc()

			return var0_48
		end,
		[DROP_TYPE_BUFF] = function(arg0_49)
			local var0_49 = pg.benefit_buff_template[arg0_49.id]

			arg0_49.desc = var0_49.desc

			return var0_49
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_50)
			local var0_50 = pg.commander_data_template[arg0_50.id]

			arg0_50.desc = var0_50.desc

			return var0_50
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_51)
			local var0_51 = pg.island_item_data_template[arg0_51.id]

			arg0_51.desc = ""

			return var0_51
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_52)
			local var0_52 = pg.island_ability_template[arg0_52.id]

			arg0_52.desc = ""

			return var0_52
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_53)
			arg0_53.desc = ""

			return {}
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_54)
			local var0_54 = pg.island_furniture_template[arg0_54.id]

			arg0_54.desc = ""

			return var0_54
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_55)
			local var0_55 = pg.island_dress_template[arg0_55.id]

			arg0_55.desc = ""

			return var0_55
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_56)
			local var0_56 = pg.island_skin_template[arg0_56.id]

			arg0_56.desc = ""

			return var0_56
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_57)
			return pg.drop_data_restore[arg0_57.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_58)
			local var0_58 = pg.dorm3d_furniture_template[arg0_58.id]

			arg0_58.desc = var0_58.desc

			return var0_58
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_59)
			local var0_59 = pg.dorm3d_gift[arg0_59.id]

			arg0_59.desc = var0_59.display

			return var0_59
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_60)
			local var0_60 = pg.dorm3d_resource[arg0_60.id]

			arg0_60.desc = ""

			return var0_60
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_61)
			local var0_61 = pg.livingarea_cover[arg0_61.id]

			arg0_61.desc = var0_61.desc

			return var0_61
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_62)
			return pg.item_data_battleui[arg0_62.id]
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_63)
			local var0_63 = pg.activity_medal_template[arg0_63.id].item

			return pg.item_virtual_data_statistics[var0_63]
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_64)
			local var0_64 = Item.getConfigData(arg0_64.id)

			assert(var0_64, arg0_64.id)

			arg0_64.desc = var0_64.display

			return var0_64
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_65)
			return pg.island_collection[arg0_65.id]
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_66)
			return getIslandSeasonPtInfo()
		end
	}

	function var0_0.ConfigDefault(arg0_67)
		local var0_67 = arg0_67.type

		if tonumber(var0_67) and var0_67 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_67 = pg.activity_drop_type[var0_67].relevance

			return var1_67 and pg[var1_67][arg0_67.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_68)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_68.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_69)
			local var0_69 = getProxy(BagProxy):getItemCountById(arg0_69.id)

			if arg0_69:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_69, 1), true
			else
				return var0_69, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_70)
			local var0_70 = arg0_70:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_70], "equip groupId not exist")

			local var1_70 = pg.equip_data_template.get_id_list_by_group[var0_70]

			return underscore.reduce(var1_70, 0, function(arg0_71, arg1_71)
				local var0_71 = getProxy(EquipmentProxy):getEquipmentById(arg1_71)

				return arg0_71 + (var0_71 and var0_71.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_71)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_72)
			return getProxy(BayProxy):getConfigShipCount(arg0_72.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_73)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_73.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_74)
			return arg0_74.count, tobool(arg0_74.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_75)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_75.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_76)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_76.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_77)
			if arg0_77:getConfig("virtual_type") == 22 then
				local var0_77 = getProxy(ActivityProxy):getActivityById(arg0_77:getConfig("link_id"))

				return var0_77 and var0_77.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_78)
			local var0_78 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_78.id)

			return (var0_78 and var0_78.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_78.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_79)
			local var0_79 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_79.type].activity_id)

			if not var0_79 then
				return 0
			end

			local var1_79 = var0_79:GetItemById(arg0_79.id)

			return var1_79 and var1_79.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_80)
			local var0_80 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_80.id)

			return var0_80 and (not var0_80:expiredType() or not not var0_80:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_81)
			local var0_81 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_81.id)

			return var0_81 and (not var0_81:expiredType() or not not var0_81:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_82)
			local var0_82 = nowWorld()

			if var0_82.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_82:GetInventoryProxy():GetItemCount(arg0_82.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_83)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_83.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_84)
			local var0_84 = getProxy(LivingAreaCoverProxy):GetCover(arg0_84.id)

			return var0_84 and var0_84:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_85)
			return getProxy(ApartmentProxy):getGiftCount(arg0_85.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_86)
			local var0_86 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_86.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_87)
			local var0_87 = 0
			local var1_87 = getProxy(IslandProxy):GetIsland()

			if var1_87 then
				var0_87 = var1_87:GetInventoryAgency():GetOwnCount(arg0_87.id)
			end

			return var0_87
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_88)
			return 0
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_89)
			return 0
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_90)
			return 0
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_91)
			return 0
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_92)
			return 0
		end
	}

	function var0_0.CountDefault(arg0_93)
		local var0_93 = arg0_93.type

		if var0_93 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_93].activity_id):getVitemNumber(arg0_93.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_94)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_95)
			return Item.New(arg0_95)
		end,
		[DROP_TYPE_VITEM] = function(arg0_96)
			return Item.New(arg0_96)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_97)
			return Equipment.New(arg0_97)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_98)
			return Item.New({
				count = 1,
				id = arg0_98.id,
				extra = arg0_98.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_99)
			return WorldItem.New(arg0_99)
		end
	}

	function var0_0.SubClassDefault(arg0_100)
		assert(false, string.format("drop type %d without subClass", arg0_100.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_101)
			return arg0_101:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_102)
			return arg0_102:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_103)
			return arg0_103:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_104)
			return arg0_104:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_105)
			return arg0_105:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_106)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_107)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_108)
			return arg0_108:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_109)
			return arg0_109:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_110)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_111)
			return arg0_111:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_112)
			return arg0_112:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_113)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_114)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_115)
			return arg0_115:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_116)
			return arg0_116:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_117)
			return arg0_117:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_118)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_119)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_120)
			return arg0_120:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_121)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_122)
			return ItemRarity.Gold
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_123)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_124)
		return arg0_124:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_125)
		return arg0_125:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_126)
			local var0_126 = Drop.New({
				type = arg0_126:getConfig("type"),
				id = arg0_126:getConfig("resource_type"),
				count = arg0_126:getConfig("resource_num") * arg0_126.count
			})
			local var1_126 = Drop.New({
				type = arg0_126:getConfig("target_type"),
				id = arg0_126:getConfig("target_id"),
				count = arg0_126.count
			})

			PlayerConst.UpdateLinkActivity({
				var1_126
			})

			var0_126.name = string.format("%s(%s)", var0_126:getName(), var1_126:getName())

			return var0_126
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_127)
			for iter0_127, iter1_127 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_127.id].pt == arg0_127.id then
					return nil, arg0_127
				end
			end

			return arg0_127
		end,
		[DROP_TYPE_OPERATION] = function(arg0_128)
			if arg0_128.id ~= 3 then
				return nil
			end

			return arg0_128
		end,
		[DROP_TYPE_EMOJI] = function(arg0_129)
			return nil, arg0_129
		end,
		[DROP_TYPE_VITEM] = function(arg0_130, arg1_130, arg2_130)
			assert(arg0_130:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_130.id)

			return switch(arg0_130:getConfig("virtual_type"), {
				function()
					if arg0_130:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_130
					end

					return arg0_130
				end,
				[6] = function()
					local var0_132 = arg2_130.taskId
					local var1_132 = getProxy(ActivityProxy)
					local var2_132 = var1_132:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_132 then
						local var3_132 = var2_132.data1KeyValueList[1]

						var3_132[var0_132] = defaultValue(var3_132[var0_132], 0) + arg0_130.count

						var1_132:updateActivity(var2_132)
					end

					return nil, arg0_130
				end,
				[13] = function()
					local var0_133 = arg0_130:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_133))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_133))

						return nil
					else
						return arg0_130, nil
					end
				end,
				[21] = function()
					return nil, arg0_130
				end,
				[28] = function()
					local var0_135 = Drop.New({
						type = arg0_130.type,
						id = arg0_130.id,
						count = math.floor(arg0_130.count / 1000)
					})
					local var1_135 = Drop.New({
						type = arg0_130.type,
						id = arg0_130.id,
						count = arg0_130.count - math.floor(arg0_130.count / 1000)
					})

					return var0_135, var1_135
				end
			}, function()
				return arg0_130
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_137, arg1_137)
			if Ship.isMetaShipByConfigID(arg0_137.id) and Player.isMetaShipNeedToTrans(arg0_137.id) then
				local var0_137 = table.indexof(arg1_137, arg0_137.id, 1)

				if var0_137 then
					table.remove(arg1_137, var0_137)
				else
					local var1_137 = Player.metaShip2Res(arg0_137.id)
					local var2_137 = Drop.New(var1_137[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_137.id, var2_137)

					return arg0_137, var2_137
				end
			end

			return arg0_137
		end,
		[DROP_TYPE_SKIN] = function(arg0_138)
			arg0_138.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_138.id)

			return arg0_138
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_139)
			local var0_139 = getProxy(PlayerProxy):getRawData()
			local var1_139 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_139:updateMedalList({
				{
					key = arg0_139.id,
					value = var1_139
				}
			})

			return arg0_139
		end,
		[DROP_TYPE_BUFF] = function(arg0_140)
			return nil, arg0_140
		end
	}

	function var0_0.TransDefault(arg0_141)
		return arg0_141
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_142)
			local var0_142 = id2res(arg0_142.id)

			assert(var0_142, "res should be defined: " .. arg0_142.id)

			local var1_142 = getProxy(PlayerProxy)
			local var2_142 = var1_142:getData()

			var2_142:addResources({
				[var0_142] = arg0_142.count
			})
			var1_142:updatePlayer(var2_142)
		end,
		[DROP_TYPE_ITEM] = function(arg0_143)
			if arg0_143:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_143 = getProxy(BagProxy):getItemCountById(arg0_143.id)
				local var1_143 = math.min(arg0_143:getConfig("max_num") - var0_143, arg0_143.count)

				if var1_143 > 0 then
					getProxy(BagProxy):addItemById(arg0_143.id, var1_143)
				end
			else
				getProxy(BagProxy):addItemById(arg0_143.id, arg0_143.count, arg0_143.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_144)
			local var0_144 = arg0_144:getSubClass()

			getProxy(BagProxy):addItemById(var0_144.id, var0_144.count, var0_144.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_145)
			getProxy(EquipmentProxy):addEquipmentById(arg0_145.id, arg0_145.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_146)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_147)
			local var0_147 = getProxy(DormProxy)
			local var1_147 = Furniture.New({
				id = arg0_147.id,
				count = arg0_147.count
			})

			if var1_147:isRecordTime() then
				var1_147.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_147:AddFurniture(var1_147)
		end,
		[DROP_TYPE_SKIN] = function(arg0_148)
			local var0_148 = getProxy(ShipSkinProxy)
			local var1_148 = ShipSkin.New({
				id = arg0_148.id
			})

			var0_148:addSkin(var1_148)
		end,
		[DROP_TYPE_VITEM] = function(arg0_149)
			arg0_149 = arg0_149:getSubClass()

			assert(arg0_149:isVirtualItem(), "item type error(virtual item)>>" .. arg0_149.id)
			switch(arg0_149:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_149.id, arg0_149.count)
				end,
				function()
					local var0_151 = getProxy(ActivityProxy)
					local var1_151 = arg0_149:getConfig("link_id")
					local var2_151

					if var1_151 > 0 then
						var2_151 = var0_151:getActivityById(var1_151)
					else
						var2_151 = var0_151:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_151 and not var2_151:isEnd() then
						if not table.contains(var2_151.data1_list, arg0_149.id) then
							table.insert(var2_151.data1_list, arg0_149.id)
						end

						var0_151:updateActivity(var2_151)
					end
				end,
				function()
					local var0_152 = getProxy(ActivityProxy)
					local var1_152 = var0_152:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_152, iter1_152 in ipairs(var1_152) do
						iter1_152.data1 = iter1_152.data1 + arg0_149.count

						local var2_152 = iter1_152:getConfig("config_id")
						local var3_152 = pg.activity_vote[var2_152]

						if var3_152 and var3_152.ticket_id_period == arg0_149.id then
							iter1_152.data3 = iter1_152.data3 + arg0_149.count
						end

						var0_152:updateActivity(iter1_152)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_149.id,
							ptCount = arg0_149.count
						})
					end
				end,
				[4] = function()
					local var0_153 = getProxy(ColoringProxy):getColorItems()

					var0_153[arg0_149.id] = (var0_153[arg0_149.id] or 0) + arg0_149.count
				end,
				[6] = function()
					local var0_154 = getProxy(ActivityProxy)
					local var1_154 = var0_154:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_154 then
						var1_154.data3 = var1_154.data3 + arg0_149.count

						var0_154:updateActivity(var1_154)
					end
				end,
				[7] = function()
					local var0_155 = getProxy(ChapterProxy)

					var0_155:updateRemasterTicketsNum(math.min(var0_155.remasterTickets + arg0_149.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_156 = getProxy(ActivityProxy)
					local var1_156 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_156 then
						var1_156.data1_list[1] = var1_156.data1_list[1] + arg0_149.count

						var0_156:updateActivity(var1_156)
					end
				end,
				[11] = function()
					local var0_157 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_157 and not var0_157:isEnd() then
						var0_157.data1 = var0_157.data1 + arg0_149.count
					end
				end,
				[12] = function()
					local var0_158 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_158 and not var0_158:isEnd() then
						var0_158.data1KeyValueList[1][arg0_149.id] = (var0_158.data1KeyValueList[1][arg0_149.id] or 0) + arg0_149.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_149.id, arg0_149.count)
				end,
				[14] = function()
					local var0_160 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_149.id then
						var0_160:AddSummonPt(arg0_149.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_149.id then
						var0_160:AddSummonPtOld(arg0_149.count)
					end
				end,
				[15] = function()
					local var0_161 = getProxy(ActivityProxy)
					local var1_161 = var0_161:getActivityById(arg0_149:getConfig("link_id"))

					if not var1_161 or var1_161:isEnd() then
						return
					end

					if var1_161:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_161 = pg.activity_event_grid[var1_161.data1]

						if arg0_149.id == var2_161.ticket_item then
							var1_161.data2 = var1_161.data2 + arg0_149.count
						elseif arg0_149.id == var2_161.explore_item then
							var1_161.data3 = var1_161.data3 + arg0_149.count
						end
					elseif var1_161:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_161.data3 = var1_161.data3 + arg0_149.count
					end

					var0_161:updateActivity(var1_161)
				end,
				[16] = function()
					local var0_162 = getProxy(ActivityProxy)
					local var1_162 = var0_162:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_162, iter1_162 in pairs(var1_162) do
						if iter1_162 and not iter1_162:isEnd() and arg0_149.id == iter1_162:getConfig("config_id") then
							iter1_162.data1 = iter1_162.data1 + arg0_149.count

							var0_162:updateActivity(iter1_162)
						end
					end
				end,
				[20] = function()
					local var0_163 = getProxy(BagProxy)
					local var1_163 = pg.gameset.urpt_chapter_max.description
					local var2_163 = var1_163[1]
					local var3_163 = var1_163[2]
					local var4_163 = var0_163:GetLimitCntById(var2_163)
					local var5_163 = math.min(var3_163 - var4_163, arg0_149.count)

					if var5_163 > 0 then
						var0_163:addItemById(var2_163, var5_163)
						var0_163:AddLimitCnt(var2_163, var5_163)
					end
				end,
				[21] = function()
					local var0_164 = getProxy(ActivityProxy)
					local var1_164 = var0_164:getActivityById(arg0_149:getConfig("link_id"))

					if var1_164 and not var1_164:isEnd() then
						var1_164.data2 = 1

						var0_164:updateActivity(var1_164)
					end
				end,
				[22] = function()
					local var0_165 = getProxy(ActivityProxy)
					local var1_165 = var0_165:getActivityById(arg0_149:getConfig("link_id"))

					if var1_165 and not var1_165:isEnd() then
						var1_165.data1 = var1_165.data1 + arg0_149.count

						var0_165:updateActivity(var1_165)
					end
				end,
				[23] = function()
					local var0_166 = (function()
						for iter0_167, iter1_167 in ipairs(pg.gameset.package_lv.description) do
							if arg0_149.id == iter1_167[1] then
								return iter1_167[2]
							end
						end
					end)()

					assert(var0_166)

					local var1_166 = getProxy(PlayerProxy)
					local var2_166 = var1_166:getData()

					var2_166:addExpToLevel(var0_166)
					var1_166:updatePlayer(var2_166)
				end,
				[24] = function()
					local var0_168 = arg0_149:getConfig("link_id")
					local var1_168 = getProxy(ActivityProxy):getActivityById(var0_168)

					if var1_168 and not var1_168:isEnd() and var1_168:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_168.data2 = var1_168.data2 + arg0_149.count

						getProxy(ActivityProxy):updateActivity(var1_168)
					end
				end,
				[25] = function()
					local var0_169 = getProxy(ActivityProxy)
					local var1_169 = var0_169:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_169 and not var1_169:isEnd() then
						var1_169.data1 = var1_169.data1 - 1

						if not table.contains(var1_169.data1_list, arg0_149.id) then
							table.insert(var1_169.data1_list, arg0_149.id)
						end

						var0_169:updateActivity(var1_169)

						local var2_169 = arg0_149:getConfig("link_id")

						if var2_169 > 0 then
							local var3_169 = var0_169:getActivityById(var2_169)

							if var3_169 and not var3_169:isEnd() then
								var3_169.data1 = var3_169.data1 + 1

								var0_169:updateActivity(var3_169)
							end
						end
					end
				end,
				[26] = function()
					local var0_170 = getProxy(ActivityProxy)
					local var1_170 = Clone(var0_170:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_170 and not var1_170:isEnd() then
						var1_170.data1 = var1_170.data1 + arg0_149.count

						var0_170:updateActivity(var1_170)
					end
				end,
				[27] = function()
					local var0_171 = getProxy(ActivityProxy)
					local var1_171 = Clone(var0_171:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_171 and not var1_171:isEnd() then
						var1_171:AddExp(arg0_149.count)
						var0_171:updateActivity(var1_171)
					end
				end,
				[28] = function()
					local var0_172 = getProxy(ActivityProxy)
					local var1_172 = Clone(var0_172:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_172 and not var1_172:isEnd() then
						var1_172:AddGold(arg0_149.count)
						var0_172:updateActivity(var1_172)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_175 = arg0_149:getConfig("link_id")
					local var1_175 = getProxy(ActivityProxy):getActivityById(var0_175)

					if var1_175 and not var1_175:isEnd() then
						var1_175.data1 = var1_175.data1 + arg0_149.count

						getProxy(ActivityProxy):updateActivity(var1_175)
					end
				end,
				[102] = function()
					local var0_176 = arg0_149:getConfig("link_id")
					local var1_176 = pg.activity_template[var0_176].type

					switch(var1_176, {
						[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = function()
							getProxy(CityRebuildProxy):AddPt(var0_176, arg0_149.count)
						end
					})
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_178)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_178.id, arg0_178.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_179)
			local var0_179 = getProxy(BayProxy)
			local var1_179 = var0_179:getShipById(arg0_179.count)

			if var1_179 then
				var1_179:unlockActivityNpc(0)
				var0_179:updateShip(var1_179)
				getProxy(CollectionProxy):flushCollection(var1_179)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_180)
			nowWorld():GetInventoryProxy():AddItem(arg0_180.id, arg0_180.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_181)
			local var0_181 = getProxy(AttireProxy)
			local var1_181 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_181 = IconFrame.New({
				id = arg0_181.id
			})
			local var3_181 = var1_181 + var2_181:getConfig("time_second")

			var2_181:updateData({
				isNew = true,
				end_time = var3_181
			})
			var0_181:addAttireFrame(var2_181)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_181)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_182)
			local var0_182 = getProxy(AttireProxy)
			local var1_182 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_182 = ChatFrame.New({
				id = arg0_182.id
			})
			local var3_182 = var1_182 + var2_182:getConfig("time_second")

			var2_182:updateData({
				isNew = true,
				end_time = var3_182
			})
			var0_182:addAttireFrame(var2_182)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_182)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_183)
			getProxy(EmojiProxy):addNewEmojiID(arg0_183.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_183:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_184)
			nowWorld():GetCollectionProxy():Unlock(arg0_184.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_185)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_185.id):addPT(arg0_185.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_186)
			local var0_186 = arg0_186.id
			local var1_186 = arg0_186.count
			local var2_186 = getProxy(ShipSkinProxy)
			local var3_186 = var2_186:getSkinById(var0_186)

			if var3_186 and var3_186:isExpireType() then
				local var4_186 = var1_186 + var3_186.endTime
				local var5_186 = ShipSkin.New({
					id = var0_186,
					end_time = var4_186
				})

				var2_186:addSkin(var5_186)
			elseif not var3_186 then
				local var6_186 = var1_186 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_186 = ShipSkin.New({
					id = var0_186,
					end_time = var6_186
				})

				var2_186:addSkin(var7_186)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_187)
			local var0_187 = arg0_187.id
			local var1_187 = pg.benefit_buff_template[var0_187]

			assert(var1_187 and var1_187.act_id > 0, "should exist act id")

			local var2_187 = getProxy(ActivityProxy):getActivityById(var1_187.act_id)

			if var2_187 and not var2_187:isEnd() then
				local var3_187 = var1_187.max_time
				local var4_187 = pg.TimeMgr.GetInstance():GetServerTime() + var3_187

				var2_187:AddBuff(ActivityBuff.New(var2_187.id, var0_187, var4_187))
				getProxy(ActivityProxy):updateActivity(var2_187)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_188)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_189)
			getProxy(ApartmentProxy):ModifyRoom(arg0_189:getConfig("room_id"), function(arg0_190)
				arg0_190:AddFurnitureByID(arg0_189.id)
			end)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_191)
			getProxy(ApartmentProxy):changeGiftCount(arg0_191.id, arg0_191.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_192)
			getProxy(ApartmentProxy):ModifyApartment(arg0_192:getConfig("ship_group"), function(arg0_193)
				arg0_193:addSkin(arg0_192.id)
			end)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_194)
			local var0_194 = getProxy(LivingAreaCoverProxy)
			local var1_194 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_194.id
			})

			var0_194:UpdateCover(var1_194)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_194)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_194.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_195)
			local var0_195 = getProxy(AttireProxy)
			local var1_195 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_195 = CombatUIStyle.New({
				id = arg0_195.id
			})

			var2_195:setUnlock()
			var2_195:setNew()
			var0_195:addAttireFrame(var2_195)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_195)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_196)
			local var0_196 = getProxy(IslandProxy):GetIsland()

			if not var0_196 then
				return
			end

			var0_196:GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_196.id,
				num = arg0_196.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_197)
		if arg0_197.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_197 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_197.type].activity_id)

			if arg0_197.type == DROP_TYPE_RYZA_DROP then
				if var0_197 and not var0_197:isEnd() then
					var0_197:AddItem(AtelierMaterial.New({
						configId = arg0_197.id,
						count = arg0_197.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_197)
				end
			elseif var0_197 and not var0_197:isEnd() then
				var0_197:addVitemNumber(arg0_197.id, arg0_197.count)
				getProxy(ActivityProxy):updateActivity(var0_197)
			end
		else
			print("can not handle this type>>" .. arg0_197.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_198, arg1_198, arg2_198)
			setText(arg2_198, arg0_198:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_199, arg1_199, arg2_199)
			local var0_199 = arg0_199:getConfig("display")

			if arg0_199:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_199 = string.gsub(var0_199, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_199.extra))
			elseif arg0_199:getConfig("combination_display") ~= nil then
				local var1_199 = arg0_199:getConfig("combination_display")

				if var1_199 and #var1_199 > 0 then
					var0_199 = Item.StaticCombinationDisplay(var1_199)
				end
			end

			setText(arg2_199, SwitchSpecialChar(var0_199, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_200, arg1_200, arg2_200)
			setText(arg2_200, arg0_200:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_201, arg1_201, arg2_201)
			local var0_201 = arg0_201:getConfig("skin_id")
			local var1_201, var2_201, var3_201 = ShipWordHelper.GetWordAndCV(var0_201, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_201, var3_201 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_202, arg1_202, arg2_202)
			local var0_202 = arg0_202:getConfig("skin_id")
			local var1_202, var2_202, var3_202 = ShipWordHelper.GetWordAndCV(var0_202, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_202, var3_202 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_203, arg1_203, arg2_203)
			setText(arg2_203, arg1_203.name or arg0_203:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_204, arg1_204, arg2_204)
			local var0_204 = arg0_204:getConfig("desc")

			for iter0_204, iter1_204 in ipairs({
				arg0_204.count
			}) do
				var0_204 = string.gsub(var0_204, "$" .. iter0_204, iter1_204)
			end

			setText(arg2_204, var0_204)
		end,
		[DROP_TYPE_SKIN] = function(arg0_205, arg1_205, arg2_205)
			setText(arg2_205, arg0_205:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_206, arg1_206, arg2_206)
			setText(arg2_206, arg0_206:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_207, arg1_207, arg2_207)
			local var0_207 = arg0_207:getConfig("desc")
			local var1_207 = _.map(arg0_207:getConfig("equip_type"), function(arg0_208)
				return EquipType.Type2Name2(arg0_208)
			end)

			setText(arg2_207, var0_207 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_207, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_209, arg1_209, arg2_209)
			setText(arg2_209, arg0_209:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_210, arg1_210, arg2_210)
			setText(arg2_210, arg0_210:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_211, arg1_211, arg2_211, arg3_211)
			local var0_211 = WorldCollectionProxy.GetCollectionType(arg0_211.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_211, i18n("world_" .. var0_211 .. "_desc", arg0_211:getConfig("name")))
			setText(arg3_211, i18n("world_" .. var0_211 .. "_name", arg0_211:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_212, arg1_212, arg2_212)
			setText(arg2_212, arg0_212:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_213, arg1_213, arg2_213)
			setText(arg2_213, arg0_213:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_214, arg1_214, arg2_214)
			setText(arg2_214, arg0_214:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_215, arg1_215, arg2_215)
			local var0_215 = string.gsub(arg0_215:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_215.count))

			setText(arg2_215, SwitchSpecialChar(var0_215, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_216, arg1_216, arg2_216)
			setText(arg2_216, arg0_216:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_217, arg1_217, arg2_217)
			setText(arg2_217, arg0_217:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_218, arg1_218, arg2_218)
			setText(arg2_218, arg0_218:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_219, arg1_219, arg2_219)
			setText(arg2_219, arg0_219:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_220, arg1_220, arg2_220)
			setText(arg2_220, arg0_220:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_221, arg1_221, arg2_221)
			setText(arg2_221, arg0_221:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_222, arg1_222, arg2_222)
			setText(arg2_222, "")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_223, arg1_223, arg2_223)
			setText(arg2_223, "")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_224, arg1_224, arg2_224)
			setText(arg2_224, "")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_225, arg1_225, arg2_225)
			setText(arg2_225, "")
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_226, arg1_226, arg2_226)
			setText(arg2_226, "")
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_227, arg1_227, arg2_227)
		if arg0_227.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_227, arg0_227:getConfig("display"))
		else
			setText(arg2_227, arg0_227.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_228, arg1_228, arg2_228)
			if arg0_228.id == PlayerConst.ResStoreGold or arg0_228.id == PlayerConst.ResStoreOil then
				arg2_228 = arg2_228 or {}
				arg2_228.frame = "frame_store"
			end

			updateItem(arg1_228, Item.New({
				id = id2ItemId(arg0_228.id)
			}), arg2_228)
		end,
		[DROP_TYPE_ITEM] = function(arg0_229, arg1_229, arg2_229)
			updateItem(arg1_229, arg0_229:getSubClass(), arg2_229)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_230, arg1_230, arg2_230)
			updateEquipment(arg1_230, arg0_230:getSubClass(), arg2_230)
		end,
		[DROP_TYPE_SHIP] = function(arg0_231, arg1_231, arg2_231)
			updateShip(arg1_231, arg0_231.ship, arg2_231)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_232, arg1_232, arg2_232)
			updateShip(arg1_232, arg0_232.ship, arg2_232)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_233, arg1_233, arg2_233)
			updateFurniture(arg1_233, arg0_233, arg2_233)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_234, arg1_234, arg2_234)
			arg2_234.isWorldBuff = arg0_234.isWorldBuff

			updateStrategy(arg1_234, arg0_234, arg2_234)
		end,
		[DROP_TYPE_SKIN] = function(arg0_235, arg1_235, arg2_235)
			arg2_235.isSkin = true
			arg2_235.isNew = arg0_235.isNew

			updateShip(arg1_235, Ship.New({
				configId = tonumber(arg0_235:getConfig("ship_group") .. "1"),
				skin_id = arg0_235.id
			}), arg2_235)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_236, arg1_236, arg2_236)
			local var0_236 = setmetatable({
				count = arg0_236.count
			}, {
				__index = arg0_236:getConfigTable()
			})

			updateEquipmentSkin(arg1_236, var0_236, arg2_236)
		end,
		[DROP_TYPE_VITEM] = function(arg0_237, arg1_237, arg2_237)
			updateItem(arg1_237, Item.New({
				id = arg0_237.id
			}), arg2_237)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_238, arg1_238, arg2_238)
			updateWorldItem(arg1_238, WorldItem.New({
				id = arg0_238.id
			}), arg2_238)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_239, arg1_239, arg2_239)
			updateWorldCollection(arg1_239, arg0_239, arg2_239)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_240, arg1_240, arg2_240)
			updateAttire(arg1_240, AttireConst.TYPE_CHAT_FRAME, arg0_240:getConfigTable(), arg2_240)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_241, arg1_241, arg2_241)
			updateAttire(arg1_241, AttireConst.TYPE_ICON_FRAME, arg0_241:getConfigTable(), arg2_241)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_242, arg1_242, arg2_242)
			updateEmoji(arg1_242, arg0_242:getConfigTable(), arg2_242)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_243, arg1_243, arg2_243)
			arg2_243.count = 1

			updateItem(arg1_243, arg0_243:getSubClass(), arg2_243)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_244, arg1_244, arg2_244)
			updateSpWeapon(arg1_244, SpWeapon.New({
				id = arg0_244.id
			}), arg2_244)
		end,
		[DROP_TYPE_META_PT] = function(arg0_245, arg1_245, arg2_245)
			updateItem(arg1_245, Item.New({
				id = arg0_245:getConfig("id")
			}), arg2_245)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_246, arg1_246, arg2_246)
			arg2_246.isSkin = true
			arg2_246.isTimeLimit = true
			arg2_246.count = 1

			updateShip(arg1_246, Ship.New({
				configId = tonumber(arg0_246:getConfig("ship_group") .. "1"),
				skin_id = arg0_246.id
			}), arg2_246)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_247, arg1_247, arg2_247)
			AtelierMaterial.UpdateRyzaItem(arg1_247, arg0_247.item, arg2_247)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_248, arg1_248, arg2_248)
			WorkBenchItem.UpdateDrop(arg1_248, arg0_248.item, arg2_248)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_249, arg1_249, arg2_249)
			WorkBenchItem.UpdateDrop(arg1_249, WorkBenchItem.New({
				configId = arg0_249.id,
				count = arg0_249.count
			}), arg2_249)
		end,
		[DROP_TYPE_BUFF] = function(arg0_250, arg1_250, arg2_250)
			updateBuff(arg1_250, arg0_250.id, arg2_250)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_251, arg1_251, arg2_251)
			updateCommander(arg1_251, arg0_251, arg2_251)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_252, arg1_252, arg2_252)
			updateCover(arg1_252, arg0_252, arg2_252)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_253, arg1_253, arg2_253)
			updateAttireCombatUI(arg1_253, AttireConst.TYPE_ICON_FRAME, arg0_253:getConfigTable(), arg2_253)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_254, arg1_254, arg2_254)
			updateActivityMedal(arg1_254, arg0_254:getConfigTable(), arg2_254)
		end
	}

	function var0_0.UpdateDropDefault(arg0_255, arg1_255, arg2_255)
		updateDefaultIconTpl(arg1_255, arg0_255, arg2_255)
	end

	var0_0.UpdateCustomDropCase = {
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_256, arg1_256, arg2_256)
			updateDorm3dIcon(arg1_256, arg0_256, arg2_256)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_257, arg1_257, arg2_257)
			updateDorm3dIcon(arg1_257, arg0_257, arg2_257)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_258, arg1_258, arg2_258)
			updateDorm3dIcon(arg1_258, arg0_258, arg2_258)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_259, arg1_259, arg2_259)
			updateIslandItem(arg1_259, arg0_259, arg2_259)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_260, arg1_260, arg2_260)
			updateIslandUnlock(arg1_260, arg0_260, arg2_260)
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_261, arg1_261, arg2_261)
			updateIslandInvitation(arg1_261, arg0_261, arg2_261)
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_262, arg1_262, arg2_262)
			updateIslandSeasonPt(arg1_262, arg0_262, arg2_262)
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_263, arg1_263, arg2_263)
			updateIslandWatherCollect(arg1_263, arg0_263, arg2_263)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_264, arg1_264, arg2_264)
			updateIslandFurniture(arg1_264, arg0_264, arg2_264)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_265, arg1_265, arg2_265)
			updateItem(arg1_265, Item.New({
				id = arg0_265.id
			}), arg2_265)
		end
	}

	function var0_0.UpdateCustomDropDefault(arg0_266, arg1_266, arg2_266)
		if arg2_266.style == "dorm" then
			updateDorm3dIcon(arg1_266, arg0_266, arg2_266)
		else
			warning(string.format("without dropType %d in updateCustomDrop", arg0_266.type))
		end
	end
end

return var0_0
