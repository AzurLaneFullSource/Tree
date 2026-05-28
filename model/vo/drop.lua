local var0_0 = class("Drop", import(".BaseVO"))

function var0_0.__index(arg0_1, arg1_1)
	if arg1_1 == "desc" then
		return HXSet.hxLan(rawget(arg0_1, "_desc"))
	end

	return var0_0[arg1_1]
end

function var0_0.__newindex(arg0_2, arg1_2, arg2_2)
	if arg1_2 == "desc" then
		rawset(arg0_2, "_desc", arg2_2)
	else
		rawset(arg0_2, arg1_2, arg2_2)
	end
end

function var0_0.Create(arg0_3)
	local var0_3 = {}

	var0_3.type, var0_3.id, var0_3.count = unpack(arg0_3)

	return var0_0.New(var0_3)
end

function var0_0.Change(arg0_4)
	if not getmetatable(arg0_4) then
		setmetatable(arg0_4, var0_0)

		arg0_4.class = var0_0

		arg0_4:InitConfig()
	else
		assert(instanceof(arg0_4, var0_0))
	end

	return arg0_4
end

function var0_0.Ctor(arg0_5, arg1_5)
	assert(not getmetatable(arg1_5), "drop data should not has metatable")

	for iter0_5, iter1_5 in pairs(arg1_5) do
		arg0_5[iter0_5] = iter1_5
	end

	arg0_5:InitConfig()
end

function var0_0.InitConfig(arg0_6)
	if not var0_0.inited then
		var0_0.InitSwitch()
	end

	arg0_6.configId = arg0_6.id
	arg0_6.cfg = switch(arg0_6.type, var0_0.ConfigCase, var0_0.ConfigDefault, arg0_6)
end

function var0_0.getConfigTable(arg0_7)
	return arg0_7.cfg
end

function var0_0.getName(arg0_8)
	return arg0_8.name or arg0_8:getConfig("name")
end

function var0_0.getIcon(arg0_9)
	return switch(arg0_9.type, {
		[DROP_TYPE_ICON_FRAME] = function()
			return "Props/icon_frame"
		end,
		[DROP_TYPE_ISLAND_ITEM] = function()
			local var0_11 = arg0_9:getConfig("icon_normal")

			return var0_11 ~= "" and var0_11 or "island/" .. arg0_9:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function()
			return "island/" .. arg0_9:getConfig("cmd_icon")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function()
			local var0_13 = pg.island_item_data_template[arg0_9:getConfig("invite_item")].icon

			return "island/" .. var0_13
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function()
			return "island/" .. arg0_9:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function()
			return "island/" .. arg0_9:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			return "island/IslandFurnitureIcon/" .. arg0_9:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function()
			return "island/" .. arg0_9:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function()
			return arg0_9:getConfig("icon_normal")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function()
			return "island/IslandDressIcon/" .. arg0_9:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_ACTION] = function()
			return "island/IslandActionIcon/" .. arg0_9:getConfig("resource")
		end,
		[DROP_TYPE_ISLAND_SKIN] = function()
			return arg0_9:getConfig("icon_normal")
		end
	}, function()
		return arg0_9:getConfig("icon")
	end)
end

function var0_0.getDefaultIcon(arg0_23)
	return switch(arg0_23.type, {
		[DROP_TYPE_DORM3D_FURNITURE] = function()
			return "props/missing_icon_dorm"
		end,
		[DROP_TYPE_DORM3D_GIFT] = function()
			return "props/missing_icon_dorm"
		end,
		[DROP_TYPE_DORM3D_SKIN] = function()
			return "props/missing_icon_dorm"
		end,
		[DROP_TYPE_ISLAND_ITEM] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_OVERFLOWITEM] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_DRESS] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_SKIN] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_COLLECTION_FRAMENT] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_ACTION] = function()
			return "props/missing_icon_island"
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function()
			return "props/missing_icon_island"
		end
	}, function()
		return "props/missing_icon"
	end)
end

function var0_0.getIslandRarity(arg0_40)
	return switch(arg0_40.type, {
		[DROP_TYPE_ISLAND_ITEM] = function()
			return arg0_40:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			return arg0_40:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function()
			return arg0_40:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function()
			return IslandItemRarity.ORANGE
		end,
		[DROP_TYPE_ISLAND_ACTION] = function()
			return IslandItemRarity.ORANGE
		end,
		[DROP_TYPE_ITEM] = function()
			return IslandItemRarity.ORANGE
		end,
		[DROP_TYPE_VITEM] = function()
			return IslandItemRarity.ORANGE
		end
	}, function()
		return IslandItemRarity.GREY
	end)
end

function var0_0.getCount(arg0_49)
	if arg0_49.type == DROP_TYPE_OPERATION or arg0_49.type == DROP_TYPE_LOVE_LETTER or MallActivity.IsStaffDrop(arg0_49) then
		return 1
	else
		return arg0_49.count
	end
end

function var0_0.isLoveLetter(arg0_50)
	return arg0_50.type == DROP_TYPE_LOVE_LETTER or arg0_50.type == DROP_TYPE_ITEM and arg0_50:getConfig("type") == Item.LOVE_LETTER_TYPE
end

function var0_0.getOwnedCount(arg0_51)
	return switch(arg0_51.type, var0_0.CountCase, var0_0.CountDefault, arg0_51)
end

function var0_0.getSubClass(arg0_52)
	return switch(arg0_52.type, var0_0.SubClassCase, var0_0.SubClassDefault, arg0_52)
end

function var0_0.getDropRarity(arg0_53)
	return switch(arg0_53.type, var0_0.RarityCase, var0_0.RarityDefault, arg0_53)
end

function var0_0.getDropRarityDorm(arg0_54)
	return switch(arg0_54.type, var0_0.RarityCase, var0_0.RarityDefaultDorm, arg0_54)
end

function var0_0.DropTrans(arg0_55, ...)
	return switch(arg0_55.type, var0_0.TransCase, var0_0.TransDefault, arg0_55, ...)
end

function var0_0.AddItemOperation(arg0_56)
	return switch(arg0_56.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_56)
end

function var0_0.MsgboxIntroSet(arg0_57, ...)
	return switch(arg0_57.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_57, ...)
end

function var0_0.UpdateDropTpl(arg0_58, ...)
	return switch(arg0_58.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_58, ...)
end

function var0_0.UpdateCustomDropTpl(arg0_59, ...)
	return switch(arg0_59.type, var0_0.UpdateCustomDropCase, var0_0.UpdateCustomDropDefault, arg0_59, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_61)
			local var0_61 = Item.getConfigData(id2ItemId(arg0_61.id))

			arg0_61.desc = var0_61.display

			return var0_61
		end,
		[DROP_TYPE_ITEM] = function(arg0_62)
			warning(arg0_62.id)

			local var0_62 = Item.getConfigData(arg0_62.id)

			arg0_62.desc = var0_62.display

			if var0_62.type == Item.LOVE_LETTER_TYPE then
				arg0_62.desc = string.gsub(arg0_62.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_62.extra))
			end

			return var0_62
		end,
		[DROP_TYPE_VITEM] = function(arg0_63)
			local var0_63 = Item.getConfigData(arg0_63.id)

			assert(var0_63, arg0_63.id)

			arg0_63.desc = var0_63.display

			return var0_63
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_64)
			local var0_64 = Item.getConfigData(arg0_64.id)

			arg0_64.desc = string.gsub(var0_64.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_64.count))

			return var0_64
		end,
		[DROP_TYPE_EQUIP] = function(arg0_65)
			local var0_65 = Equipment.getConfigData(arg0_65.id)

			arg0_65.desc = var0_65.descrip

			return var0_65
		end,
		[DROP_TYPE_SHIP] = function(arg0_66)
			local var0_66 = pg.ship_data_statistics[arg0_66.id]
			local var1_66, var2_66, var3_66 = ShipWordHelper.GetWordAndCV(var0_66.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_66.desc = var3_66 or i18n("ship_drop_desc_default")
			arg0_66.ship = Ship.New({
				configId = arg0_66.id,
				skin_id = arg0_66.skinId,
				propose = arg0_66.propose
			})
			arg0_66.ship.remoulded = arg0_66.remoulded
			arg0_66.ship.virgin = arg0_66.virgin

			return var0_66
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_67)
			local var0_67 = pg.furniture_data_template[arg0_67.id]

			arg0_67.desc = var0_67.describe

			return var0_67
		end,
		[DROP_TYPE_SKIN] = function(arg0_68)
			local var0_68 = pg.ship_skin_template[arg0_68.id]

			if var0_68.skin_type == ShipSkin.SKIN_TYPE_TB then
				local var1_68, var2_68, var3_68 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_68.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_68.desc = var3_68
			else
				local var4_68, var5_68, var6_68 = ShipWordHelper.GetWordAndCV(arg0_68.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_68.desc = var6_68
			end

			return var0_68
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_69)
			local var0_69 = pg.ship_skin_template[arg0_69.id]

			if var0_69.skin_type == ShipSKin.SKIN_TYPE_TB then
				local var1_69, var2_69, var3_69 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_69.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_69.desc = var3_69
			else
				local var4_69, var5_69, var6_69 = ShipWordHelper.GetWordAndCV(arg0_69.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_69.desc = var6_69
			end

			return var0_69
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_70)
			local var0_70 = pg.equip_skin_template[arg0_70.id]

			arg0_70.desc = var0_70.desc

			return var0_70
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_71)
			local var0_71 = pg.world_item_data_template[arg0_71.id]

			arg0_71.desc = var0_71.display

			return var0_71
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_72)
			local var0_72 = pg.item_data_frame[arg0_72.id]

			arg0_72.desc = var0_72.desc

			return var0_72
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_73)
			return pg.item_data_chat[arg0_73.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_74)
			local var0_74 = pg.spweapon_data_statistics[arg0_74.id]

			arg0_74.desc = var0_74.descrip

			return var0_74
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_75)
			local var0_75 = pg.activity_ryza_item[arg0_75.id]

			arg0_75.item = AtelierMaterial.New({
				configId = arg0_75.id
			})
			arg0_75.desc = arg0_75.item:GetDesc()

			return var0_75
		end,
		[DROP_TYPE_OPERATION] = function(arg0_76)
			arg0_76.ship = getProxy(BayProxy):getShipById(arg0_76.count)

			local var0_76 = pg.ship_data_statistics[arg0_76.ship.configId]
			local var1_76, var2_76, var3_76 = ShipWordHelper.GetWordAndCV(var0_76.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_76.desc = var3_76 or i18n("ship_drop_desc_default")

			return var0_76
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_77)
			return arg0_77.isWorldBuff and pg.world_SLGbuff_data[arg0_77.id] or pg.strategy_data_template[arg0_77.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_78)
			local var0_78 = pg.emoji_template[arg0_78.id]

			arg0_78.name = var0_78.item_name
			arg0_78.desc = var0_78.item_desc

			return var0_78
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_79)
			local var0_79 = WorldCollectionProxy.GetCollectionTemplate(arg0_79.id)

			arg0_79.desc = var0_79.name

			return var0_79
		end,
		[DROP_TYPE_META_PT] = function(arg0_80)
			local var0_80 = pg.ship_strengthen_meta[arg0_80.id]
			local var1_80 = Item.getConfigData(var0_80.itemid)

			arg0_80.desc = var1_80.display

			return var1_80
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_81)
			local var0_81 = pg.activity_workbench_item[arg0_81.id]

			arg0_81.item = WorkBenchItem.New({
				configId = arg0_81.id
			})
			arg0_81.desc = arg0_81.item:GetDesc()

			return var0_81
		end,
		[DROP_TYPE_BUFF] = function(arg0_82)
			local var0_82 = pg.benefit_buff_template[arg0_82.id]

			arg0_82.desc = var0_82.desc

			return var0_82
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_83)
			local var0_83 = pg.commander_data_template[arg0_83.id]

			arg0_83.desc = var0_83.desc

			return var0_83
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_84)
			local var0_84 = pg.island_item_data_template[arg0_84.id]

			arg0_84.desc = var0_84.desc

			return var0_84
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_85)
			local var0_85 = pg.island_ability_template[arg0_85.id]

			arg0_85.desc = ""

			return var0_85
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_86)
			local var0_86 = pg.island_chara_template[arg0_86.id]

			arg0_86.desc = ""

			return var0_86
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_87)
			local var0_87 = pg.island_furniture_template[arg0_87.id]

			arg0_87.desc = var0_87.describe

			return var0_87
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_88)
			local var0_88 = pg.island_dress_template[arg0_88.id]

			arg0_88.desc = var0_88.desc

			return var0_88
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_89)
			local var0_89 = pg.island_skin_template[arg0_89.id]

			arg0_89.desc = var0_89.desc

			return var0_89
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_90)
			local var0_90 = pg.island_action[arg0_90.id]

			arg0_90.desc = var0_90.desc

			return var0_90
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_91)
			local var0_91 = pg.island_speedup_ticket[arg0_91.id]

			arg0_91.desc = var0_91.desc

			return var0_91
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_92)
			local var0_92 = pg.island_card_diy[arg0_92.id]

			arg0_92.desc = var0_92.desc

			return var0_92
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_93)
			return pg.drop_data_restore[arg0_93.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_94)
			local var0_94 = pg.dorm3d_furniture_template[arg0_94.id]

			arg0_94.desc = var0_94.desc

			return var0_94
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_95)
			local var0_95 = pg.dorm3d_gift[arg0_95.id]

			arg0_95.desc = var0_95.display

			return var0_95
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_96)
			local var0_96 = pg.dorm3d_resource[arg0_96.id]

			arg0_96.desc = ""

			return var0_96
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_97)
			local var0_97 = pg.livingarea_cover[arg0_97.id]

			arg0_97.desc = var0_97.desc

			return var0_97
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_98)
			return pg.item_data_battleui[arg0_98.id]
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_99)
			local var0_99 = pg.activity_medal_template[arg0_99.id].item

			return pg.item_virtual_data_statistics[var0_99]
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_100)
			local var0_100 = Item.getConfigData(arg0_100.id)

			assert(var0_100, arg0_100.id)

			arg0_100.desc = var0_100.display

			return var0_100
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_101)
			return pg.island_collection[arg0_101.id]
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_102)
			local var0_102 = pg.island_set.season_pt_show.key_value_int
			local var1_102 = pg.island_item_data_template[var0_102]

			arg0_102.desc = var1_102.desc

			return var1_102
		end
	}

	function var0_0.ConfigDefault(arg0_103)
		local var0_103 = arg0_103.type

		if tonumber(var0_103) and var0_103 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_103 = pg.activity_drop_type[var0_103].relevance

			return var1_103 and pg[var1_103][arg0_103.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_104)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_104.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_105)
			local var0_105 = getProxy(BagProxy):getItemCountById(arg0_105.id)

			if arg0_105:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_105, 1), true
			else
				return var0_105, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_106)
			local var0_106 = arg0_106:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_106], "equip groupId not exist")

			local var1_106 = pg.equip_data_template.get_id_list_by_group[var0_106]

			return underscore.reduce(var1_106, 0, function(arg0_107, arg1_107)
				local var0_107 = getProxy(EquipmentProxy):getEquipmentById(arg1_107)

				return arg0_107 + (var0_107 and var0_107.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_107)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_108)
			return getProxy(BayProxy):getConfigShipCount(arg0_108.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_109)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_109.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_110)
			return arg0_110.count, tobool(arg0_110.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_111)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_111.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_112)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_112.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_113)
			local var0_113 = arg0_113:getConfig("virtual_type")

			return switch(var0_113, {
				[22] = function()
					local var0_114 = getProxy(ActivityProxy):getActivityById(arg0_113:getConfig("link_id"))

					return var0_114 and var0_114.data1 or 0, true
				end,
				[101] = function()
					local var0_115 = getProxy(ActivityProxy):getActivityById(arg0_113:getConfig("link_id"))

					return var0_115 and var0_115.data1 or 0
				end
			}, function()
				return nil
			end)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_117)
			local var0_117 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_117.id)

			return (var0_117 and var0_117.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_117.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_118)
			local var0_118 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_118.type].activity_id)

			if not var0_118 then
				return 0
			end

			local var1_118 = var0_118:GetItemById(arg0_118.id)

			return var1_118 and var1_118.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_119)
			local var0_119 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_119.id)

			return var0_119 and (not var0_119:expiredType() or not not var0_119:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_120)
			local var0_120 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_120.id)

			return var0_120 and (not var0_120:expiredType() or not not var0_120:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_121)
			local var0_121 = nowWorld()

			if var0_121.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_121:GetInventoryProxy():GetItemCount(arg0_121.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_122)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_122.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_123)
			local var0_123 = getProxy(LivingAreaCoverProxy):GetCover(arg0_123.id)

			return var0_123 and var0_123:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_124)
			return getProxy(ApartmentProxy):getGiftCount(arg0_124.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_125)
			local var0_125 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_125.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_126)
			local var0_126 = 0
			local var1_126 = getProxy(IslandProxy):GetIsland()

			if var1_126 then
				var0_126 = var1_126:GetInventoryAgency():GetOwnCount(arg0_126.id)
			end

			return var0_126
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_127)
			return 0
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_128)
			return 0
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_129)
			local var0_129 = getProxy(IslandProxy):GetIsland()

			if var0_129 then
				local var1_129 = var0_129:GetAgoraAgency():GetFurnitures()

				for iter0_129, iter1_129 in ipairs(var1_129) do
					if iter1_129.id == arg0_129.id then
						return iter1_129.count
					end
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_130)
			local var0_130 = getProxy(IslandProxy):GetIsland()

			if var0_130 then
				local var1_130 = arg0_130:getConfig("belongto")

				if var1_130 == 1 then
					return var0_130:GetDressUpAgency():CheckOwnDress(arg0_130.id) and 1 or 0
				elseif var1_130 == 2 then
					return var0_130:GetCharacterAgency():GetDressIdRealCount(arg0_130.id)
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_131)
			local var0_131 = getProxy(IslandProxy)

			if not var0_131 then
				return 0
			end

			local var1_131 = var0_131:GetIsland()

			if var1_131 then
				return var1_131:GetCharacterAgency():CheckSkinIsOwned(arg0_131.id) and 1 or 0
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_132)
			local var0_132 = getProxy(IslandProxy)

			if not var0_132 then
				return 0
			end

			local var1_132 = var0_132:GetIsland()

			if var1_132 then
				return var1_132:GetActionAgency():ExistAction(arg0_132.id) and 1 or 0
			end

			return 0
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_133)
			local var0_133 = getProxy(IslandProxy)

			if not var0_133 then
				return 0
			end

			local var1_133 = var0_133:GetIsland()

			if var1_133 then
				return var1_133:GetSeasonAgency():GetSeason():GetPt()
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_134)
			local var0_134 = getProxy(IslandProxy)

			if not var0_134 then
				return 0
			end

			local var1_134 = var0_134:GetIsland()

			if var1_134 then
				return var1_134:GetCardDiyAgency():GetIdCount(arg0_134.id)
			end

			return 0
		end
	}

	function var0_0.CountDefault(arg0_135)
		local var0_135 = arg0_135.type

		if var0_135 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_135].activity_id):getVitemNumber(arg0_135.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_136)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_137)
			return Item.New(arg0_137)
		end,
		[DROP_TYPE_VITEM] = function(arg0_138)
			return Item.New(arg0_138)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_139)
			return Equipment.New(arg0_139)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_140)
			return Item.New({
				count = 1,
				id = arg0_140.id,
				extra = arg0_140.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_141)
			return WorldItem.New(arg0_141)
		end
	}

	function var0_0.SubClassDefault(arg0_142)
		assert(false, string.format("drop type %d without subClass", arg0_142.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_143)
			return arg0_143:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_144)
			return arg0_144:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_145)
			return arg0_145:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_146)
			return arg0_146:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_147)
			return arg0_147:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_148)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_149)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_150)
			return arg0_150:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_151)
			return arg0_151:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_152)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_153)
			return arg0_153:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_154)
			return arg0_154:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_155)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_156)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_157)
			return arg0_157:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_158)
			return arg0_158:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_159)
			return arg0_159:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_160)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_161)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_162)
			return arg0_162:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_163)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_164)
			return ItemRarity.Gold
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_165)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_166)
		return arg0_166:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_167)
		return arg0_167:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_168)
			local var0_168 = Drop.New({
				type = arg0_168:getConfig("type"),
				id = arg0_168:getConfig("resource_type"),
				count = arg0_168:getConfig("resource_num") * arg0_168.count
			})
			local var1_168 = Drop.New({
				type = arg0_168:getConfig("target_type"),
				id = arg0_168:getConfig("target_id"),
				count = arg0_168.count
			})

			PlayerConst.UpdateLinkActivity({
				var1_168
			})

			var0_168.name = string.format("%s(%s)", var0_168:getName(), var1_168:getName())

			return var0_168
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_169)
			for iter0_169, iter1_169 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_169.id].pt == arg0_169.id then
					return nil, arg0_169
				end
			end

			for iter2_169, iter3_169 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)) do
				if pg.black_friday_battlepass_event_pt[iter3_169.id].pt == arg0_169.id then
					return nil, arg0_169
				end
			end

			return arg0_169
		end,
		[DROP_TYPE_OPERATION] = function(arg0_170)
			if arg0_170.id ~= 3 then
				return nil
			end

			return arg0_170
		end,
		[DROP_TYPE_EMOJI] = function(arg0_171)
			return nil, arg0_171
		end,
		[DROP_TYPE_VITEM] = function(arg0_172, arg1_172, arg2_172)
			assert(arg0_172:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_172.id)

			return switch(arg0_172:getConfig("virtual_type"), {
				function()
					if arg0_172:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_172
					end

					return arg0_172
				end,
				[6] = function()
					local var0_174 = arg2_172.taskId
					local var1_174 = getProxy(ActivityProxy)
					local var2_174 = var1_174:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_174 then
						local var3_174 = var2_174.data1KeyValueList[1]

						var3_174[var0_174] = defaultValue(var3_174[var0_174], 0) + arg0_172.count

						var1_174:updateActivity(var2_174)
					end

					return nil, arg0_172
				end,
				[13] = function()
					local var0_175 = arg0_172:getName()
					local var1_175 = getProxy(ActivityProxy):getActivityById(arg0_172:getConfig("link_id"))

					if not var1_175 or var1_175:isEnd() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_175))

						return nil
					elseif var1_175:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_175))

						return nil
					else
						return arg0_172, nil
					end
				end,
				[17] = function()
					local var0_176 = getProxy(ActivityProxy):getActivityById(arg0_172:getConfig("link_id"))

					if var0_176.data1 < 1 then
						return Drop.New({
							count = 1,
							type = DROP_TYPE_SHIP,
							id = var0_176:getConfig("config_id")
						}), arg0_172
					else
						return Drop.New({
							id = 3,
							type = DROP_TYPE_OPERATION,
							count = var0_176.data2
						}), arg0_172
					end
				end,
				[21] = function()
					return nil, arg0_172
				end,
				[28] = function()
					local var0_178 = Drop.New({
						type = arg0_172.type,
						id = arg0_172.id,
						count = math.floor(arg0_172.count / 1000)
					})
					local var1_178 = Drop.New({
						type = arg0_172.type,
						id = arg0_172.id,
						count = arg0_172.count - math.floor(arg0_172.count / 1000)
					})

					return var0_178, var1_178
				end
			}, function()
				return arg0_172
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_180, arg1_180)
			if Ship.isMetaShipByConfigID(arg0_180.id) and Player.isMetaShipNeedToTrans(arg0_180.id) then
				local var0_180 = table.indexof(arg1_180, arg0_180.id, 1)

				if var0_180 then
					table.remove(arg1_180, var0_180)
				else
					local var1_180 = Player.metaShip2Res(arg0_180.id)
					local var2_180 = Drop.New(var1_180[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_180.id, var2_180)

					return arg0_180, var2_180
				end
			end

			return arg0_180
		end,
		[DROP_TYPE_SKIN] = function(arg0_181)
			arg0_181.isNew = not getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_181.id)

			return arg0_181
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_182)
			local var0_182 = getProxy(PlayerProxy):getRawData()
			local var1_182 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_182:updateMedalList({
				{
					key = arg0_182.id,
					value = var1_182
				}
			})

			return arg0_182
		end,
		[DROP_TYPE_BUFF] = function(arg0_183)
			return nil, arg0_183
		end
	}

	function var0_0.TransDefault(arg0_184)
		return arg0_184
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_185)
			local var0_185 = id2res(arg0_185.id)

			assert(var0_185, "res should be defined: " .. arg0_185.id)

			local var1_185 = getProxy(PlayerProxy)
			local var2_185 = var1_185:getData()

			var2_185:addResources({
				[var0_185] = arg0_185.count
			})
			var1_185:updatePlayer(var2_185)
		end,
		[DROP_TYPE_ITEM] = function(arg0_186)
			if arg0_186:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_186 = getProxy(BagProxy):getItemCountById(arg0_186.id)
				local var1_186 = math.min(arg0_186:getConfig("max_num") - var0_186, arg0_186.count)

				if var1_186 > 0 then
					getProxy(BagProxy):addItemById(arg0_186.id, var1_186)
				end
			else
				getProxy(BagProxy):addItemById(arg0_186.id, arg0_186.count, arg0_186.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_187)
			local var0_187 = arg0_187:getSubClass()

			getProxy(BagProxy):addItemById(var0_187.id, var0_187.count, var0_187.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_188)
			getProxy(EquipmentProxy):addEquipmentById(arg0_188.id, arg0_188.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_189)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_190)
			local var0_190 = getProxy(DormProxy)
			local var1_190 = Furniture.New({
				id = arg0_190.id,
				count = arg0_190.count
			})

			if var1_190:isRecordTime() then
				var1_190.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_190:AddFurniture(var1_190)
		end,
		[DROP_TYPE_SKIN] = function(arg0_191)
			local var0_191 = getProxy(ShipSkinProxy)
			local var1_191 = ShipSkin.New({
				id = arg0_191.id
			})

			var0_191:addSkin(var1_191)
		end,
		[DROP_TYPE_VITEM] = function(arg0_192)
			arg0_192 = arg0_192:getSubClass()

			assert(arg0_192:isVirtualItem(), "item type error(virtual item)>>" .. arg0_192.id)
			switch(arg0_192:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_192.id, arg0_192.count)
				end,
				function()
					local var0_194 = getProxy(ActivityProxy)
					local var1_194 = arg0_192:getConfig("link_id")
					local var2_194

					if var1_194 > 0 then
						var2_194 = var0_194:getActivityById(var1_194)
					else
						var2_194 = var0_194:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_194 and not var2_194:isEnd() then
						if not table.contains(var2_194.data1_list, arg0_192.id) then
							table.insert(var2_194.data1_list, arg0_192.id)
						end

						var0_194:updateActivity(var2_194)
					end
				end,
				function()
					local var0_195 = getProxy(ActivityProxy)
					local var1_195 = var0_195:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_195, iter1_195 in ipairs(var1_195) do
						iter1_195.data1 = iter1_195.data1 + arg0_192.count

						local var2_195 = iter1_195:getConfig("config_id")
						local var3_195 = pg.activity_vote[var2_195]

						if var3_195 and var3_195.ticket_id_period == arg0_192.id then
							iter1_195.data3 = iter1_195.data3 + arg0_192.count
						end

						var0_195:updateActivity(iter1_195)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_192.id,
							ptCount = arg0_192.count
						})
					end
				end,
				[4] = function()
					local var0_196 = getProxy(ColoringProxy):getColorItems()

					var0_196[arg0_192.id] = (var0_196[arg0_192.id] or 0) + arg0_192.count
				end,
				[6] = function()
					local var0_197 = getProxy(ActivityProxy)
					local var1_197 = var0_197:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_197 then
						var1_197.data3 = var1_197.data3 + arg0_192.count

						var0_197:updateActivity(var1_197)
					end
				end,
				[7] = function()
					local var0_198 = getProxy(ChapterProxy)

					var0_198:updateRemasterTicketsNum(math.min(var0_198.remasterTickets + arg0_192.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_199 = getProxy(ActivityProxy)
					local var1_199 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_199 then
						var1_199.data1_list[1] = var1_199.data1_list[1] + arg0_192.count

						var0_199:updateActivity(var1_199)
					end
				end,
				[11] = function()
					local var0_200 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_200 and not var0_200:isEnd() then
						var0_200.data1 = var0_200.data1 + arg0_192.count
					end
				end,
				[12] = function()
					local var0_201 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_201 and not var0_201:isEnd() then
						var0_201.data1KeyValueList[1][arg0_192.id] = (var0_201.data1KeyValueList[1][arg0_192.id] or 0) + arg0_192.count
					end
				end,
				[13] = function()
					local var0_202 = getProxy(ActivityProxy):getActivityById(arg0_192:getConfig("link_id"))

					if var0_202:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

						return
					end

					var0_202.data1 = var0_202.data1 + arg0_192.count

					getProxy(ActivityProxy):updateActivity(var0_202)
				end,
				[14] = function()
					local var0_203 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_192.id then
						var0_203:AddSummonPt(arg0_192.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_192.id then
						var0_203:AddSummonPtOld(arg0_192.count)
					end
				end,
				[15] = function()
					local var0_204 = getProxy(ActivityProxy)
					local var1_204 = var0_204:getActivityById(arg0_192:getConfig("link_id"))

					if not var1_204 or var1_204:isEnd() then
						return
					end

					if var1_204:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_204 = pg.activity_event_grid[var1_204.data1]

						if arg0_192.id == var2_204.ticket_item then
							var1_204.data2 = var1_204.data2 + arg0_192.count
						elseif arg0_192.id == var2_204.explore_item then
							var1_204.data3 = var1_204.data3 + arg0_192.count
						end
					elseif var1_204:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_204.data3 = var1_204.data3 + arg0_192.count
					end

					var0_204:updateActivity(var1_204)
				end,
				[16] = function()
					local var0_205 = getProxy(ActivityProxy)
					local var1_205 = var0_205:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_205, iter1_205 in pairs(var1_205) do
						if iter1_205 and not iter1_205:isEnd() and arg0_192.id == iter1_205:getConfig("config_id") then
							iter1_205.data1 = iter1_205.data1 + arg0_192.count

							var0_205:updateActivity(iter1_205)
						end
					end
				end,
				[17] = function()
					local var0_206 = getProxy(ActivityProxy)
					local var1_206 = var0_206:getActivityById(arg0_192:getConfig("link_id"))

					if not var1_206 or var1_206:isEnd() then
						return
					end

					var1_206.data1 = 2

					var0_206:updateActivity(var1_206)
				end,
				[20] = function()
					local var0_207 = getProxy(BagProxy)
					local var1_207 = pg.gameset.urpt_chapter_max.description
					local var2_207 = var1_207[1]
					local var3_207 = var1_207[2]
					local var4_207 = var0_207:GetLimitCntById(var2_207)
					local var5_207 = math.min(var3_207 - var4_207, arg0_192.count)

					if var5_207 > 0 then
						var0_207:addItemById(var2_207, var5_207)
						var0_207:AddLimitCnt(var2_207, var5_207)
					end
				end,
				[21] = function()
					local var0_208 = getProxy(ActivityProxy)
					local var1_208 = var0_208:getActivityById(arg0_192:getConfig("link_id"))

					if var1_208 and not var1_208:isEnd() then
						var1_208.data2 = 1

						var0_208:updateActivity(var1_208)
					end
				end,
				[22] = function()
					local var0_209 = getProxy(ActivityProxy)
					local var1_209 = var0_209:getActivityById(arg0_192:getConfig("link_id"))

					if var1_209 and not var1_209:isEnd() then
						var1_209.data1 = var1_209.data1 + arg0_192.count

						var0_209:updateActivity(var1_209)
					end
				end,
				[23] = function()
					local var0_210 = (function()
						for iter0_211, iter1_211 in ipairs(pg.gameset.package_lv.description) do
							if arg0_192.id == iter1_211[1] then
								return iter1_211[2]
							end
						end
					end)()

					assert(var0_210)

					local var1_210 = getProxy(PlayerProxy)
					local var2_210 = var1_210:getData()

					var2_210:addExpToLevel(var0_210)
					var1_210:updatePlayer(var2_210)
				end,
				[24] = function()
					local var0_212 = arg0_192:getConfig("link_id")
					local var1_212 = getProxy(ActivityProxy):getActivityById(var0_212)

					if var1_212 and not var1_212:isEnd() and var1_212:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_212.data2 = var1_212.data2 + arg0_192.count

						getProxy(ActivityProxy):updateActivity(var1_212)
					end
				end,
				[25] = function()
					local var0_213 = getProxy(ActivityProxy)
					local var1_213 = var0_213:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_213 and not var1_213:isEnd() then
						var1_213.data1 = var1_213.data1 - 1

						if not table.contains(var1_213.data1_list, arg0_192.id) then
							table.insert(var1_213.data1_list, arg0_192.id)
						end

						var0_213:updateActivity(var1_213)

						local var2_213 = arg0_192:getConfig("link_id")

						if var2_213 > 0 then
							local var3_213 = var0_213:getActivityById(var2_213)

							if var3_213 and not var3_213:isEnd() then
								var3_213.data1 = var3_213.data1 + 1

								var0_213:updateActivity(var3_213)
							end
						end
					end
				end,
				[26] = function()
					local var0_214 = getProxy(ActivityProxy)
					local var1_214 = Clone(var0_214:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_214 and not var1_214:isEnd() then
						var1_214.data1 = var1_214.data1 + arg0_192.count

						var0_214:updateActivity(var1_214)
					end
				end,
				[27] = function()
					local var0_215 = getProxy(ActivityProxy)
					local var1_215 = Clone(var0_215:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_215 and not var1_215:isEnd() then
						var1_215:AddExp(arg0_192.count)
						var0_215:updateActivity(var1_215)
					end
				end,
				[28] = function()
					local var0_216 = getProxy(ActivityProxy)
					local var1_216 = Clone(var0_216:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_216 and not var1_216:isEnd() then
						var1_216:AddGold(arg0_192.count)
						var0_216:updateActivity(var1_216)
					end
				end,
				[29] = function()
					local var0_217 = getProxy(ActivityProxy)
					local var1_217 = Clone(var0_217:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5))

					if var1_217 and not var1_217:isEnd() then
						var1_217.data1 = var1_217.data1 + arg0_192.count

						var0_217:updateActivity(var1_217)
					end
				end,
				[30] = function()
					local var0_218 = arg0_192:getConfig("link_id")
					local var1_218 = getProxy(ActivityProxy):getActivityById(var0_218)

					if not var1_218 or var1_218:isEnd() then
						return
					end

					local var2_218 = arg0_192.count

					if var1_218:IsLimitExpItem(arg0_192.id) then
						var2_218 = var1_218:FilterExp(var2_218)
						var2_218 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_218:GetTargetGroupId(), var2_218)

						var1_218:AddDailyProgress(var2_218)
					else
						local var3_218 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_218:GetTargetGroupId(), var2_218)
					end

					getProxy(ActivityProxy):updateActivity(var1_218)
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_221 = arg0_192:getConfig("link_id")
					local var1_221 = getProxy(ActivityProxy):getActivityById(var0_221)

					if var1_221 and not var1_221:isEnd() then
						var1_221.data1 = var1_221.data1 + arg0_192.count

						getProxy(ActivityProxy):updateActivity(var1_221)
					end
				end,
				[102] = function()
					local var0_222 = arg0_192:getConfig("link_id")
					local var1_222 = pg.activity_template[var0_222].type

					switch(var1_222, {
						[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = function()
							getProxy(CityRebuildProxy):AddPt(var0_222, arg0_192.count)
						end
					})
				end,
				[103] = function()
					local var0_224 = arg0_192:getConfig("link_id")
					local var1_224 = getProxy(ActivityProxy):getActivityById(var0_224)

					if not var1_224 or var1_224:isEnd() then
						return
					end

					local var2_224 = var1_224:getConfig("type")

					switch(var2_224, {
						[ActivityConst.ACTIVITY_TYPE_TOWN2] = function()
							local var0_225 = getProxy(ActivityProxy)
							local var1_225 = Clone(var0_225:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN2))

							if arg0_192:getConfig("id") == pg.activity_town_2[var1_225.id].bubble_drop[1][2] then
								var1_225:AddGold(arg0_192.count)
								var1_225:AddAllGold(arg0_192.count)
							else
								var1_225:AddGold2(arg0_192.count)
							end

							var0_225:updateActivity(var1_225)
						end,
						[ActivityConst.ACTIVITY_TYPE_MALL] = function()
							local var0_226 = var1_224:getConfig("config_data")[1]
							local var1_226 = arg0_192.id ~= var0_226

							if var1_226 then
								var1_224:AddStaff(arg0_192.id, arg0_192.count)
							else
								var1_224:AddGold(arg0_192.count)
							end

							getProxy(ActivityProxy):updateActivity(var1_224)

							if var1_226 then
								pg.m02:sendNotification(GAME.ACTIVITY_MALL_OP, {
									activity_id = var1_224.id,
									cmd = ActivityMallOPCommand.CMD.GET_STAFF_DATA,
									arg1 = arg0_192.count
								})
							end
						end
					}, function()
						assert(var1_224 .. "对应" .. var2_224 .. "错误")
					end)
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_228)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_228.id, arg0_228.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_229)
			local var0_229 = getProxy(BayProxy)
			local var1_229 = var0_229:getShipById(arg0_229.count)

			if var1_229 then
				var1_229:unlockActivityNpc(0)
				var0_229:updateShip(var1_229)
				getProxy(CollectionProxy):flushCollection(var1_229)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_230)
			nowWorld():GetInventoryProxy():AddItem(arg0_230.id, arg0_230.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_231)
			local var0_231 = getProxy(AttireProxy)
			local var1_231 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_231 = IconFrame.New({
				id = arg0_231.id
			})
			local var3_231 = var1_231 + var2_231:getConfig("time_second")

			var2_231:updateData({
				isNew = true,
				end_time = var3_231
			})
			var0_231:addAttireFrame(var2_231)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_231)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_232)
			local var0_232 = getProxy(AttireProxy)
			local var1_232 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_232 = ChatFrame.New({
				id = arg0_232.id
			})
			local var3_232 = var1_232 + var2_232:getConfig("time_second")

			var2_232:updateData({
				isNew = true,
				end_time = var3_232
			})
			var0_232:addAttireFrame(var2_232)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_232)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_233)
			getProxy(EmojiProxy):addNewEmojiID(arg0_233.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_233:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_234)
			nowWorld():GetCollectionProxy():Unlock(arg0_234.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_235)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_235.id):addPT(arg0_235.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_236)
			local var0_236 = arg0_236.id
			local var1_236 = arg0_236.count
			local var2_236 = getProxy(ShipSkinProxy)
			local var3_236 = var2_236:getSkinById(var0_236)

			if var3_236 and var3_236:isExpireType() then
				local var4_236 = var1_236 + var3_236.endTime
				local var5_236 = ShipSkin.New({
					id = var0_236,
					end_time = var4_236
				})

				var2_236:addSkin(var5_236)
			elseif not var3_236 then
				local var6_236 = var1_236 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_236 = ShipSkin.New({
					id = var0_236,
					end_time = var6_236
				})

				var2_236:addSkin(var7_236)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_237)
			local var0_237 = arg0_237.id
			local var1_237 = pg.benefit_buff_template[var0_237]

			assert(var1_237 and var1_237.act_id > 0, "should exist act id")

			local var2_237 = getProxy(ActivityProxy):getActivityById(var1_237.act_id)

			if var2_237 and not var2_237:isEnd() then
				local var3_237 = var1_237.max_time
				local var4_237 = pg.TimeMgr.GetInstance():GetServerTime() + var3_237

				var2_237:AddBuff(ActivityBuff.New(var2_237.id, var0_237, var4_237))
				getProxy(ActivityProxy):updateActivity(var2_237)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_238)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_239)
			getProxy(ApartmentProxy):ModifyRoom(arg0_239:getConfig("room_id"), function(arg0_240)
				arg0_240:AddFurnitureByID(arg0_239.id)
			end)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_241)
			getProxy(ApartmentProxy):changeGiftCount(arg0_241.id, arg0_241.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_242)
			getProxy(ApartmentProxy):ModifyApartment(arg0_242:getConfig("ship_group"), function(arg0_243)
				arg0_243:addSkin(arg0_242.id)
			end)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_244)
			local var0_244 = getProxy(LivingAreaCoverProxy)
			local var1_244 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_244.id
			})

			var0_244:UpdateCover(var1_244)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_244)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_244.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_245)
			local var0_245 = getProxy(AttireProxy)
			local var1_245 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_245 = CombatUIStyle.New({
				id = arg0_245.id
			})

			var2_245:setUnlock()
			var2_245:setNew()
			var0_245:addAttireFrame(var2_245)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_245)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_246)
			local var0_246 = getProxy(IslandProxy):GetIsland()

			if not var0_246 then
				return
			end

			var0_246:GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_246.id,
				num = arg0_246.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_247)
		if arg0_247.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_247 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_247.type].activity_id)

			if arg0_247.type == DROP_TYPE_RYZA_DROP then
				if var0_247 and not var0_247:isEnd() then
					var0_247:AddItem(AtelierMaterial.New({
						configId = arg0_247.id,
						count = arg0_247.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_247)
				end
			elseif var0_247 and not var0_247:isEnd() then
				var0_247:addVitemNumber(arg0_247.id, arg0_247.count)
				getProxy(ActivityProxy):updateActivity(var0_247)
			end
		elseif arg0_247.type >= DROP_TYPE_ISLAND_ITEM and arg0_247.type <= DROP_TYPE_ISLAND_CARD_DIY then
			if not getProxy(IslandProxy):GetIsland() then
				return
			end

			local var1_247 = {}

			table.insert(var1_247, {
				type = arg0_247.type,
				id = arg0_247.id,
				number = arg0_247.count
			})
			IslandDropHelper.AddItems({
				drop_list = var1_247
			})
		else
			print("can not handle this type>>" .. arg0_247.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_248, arg1_248, arg2_248)
			setText(arg2_248, arg0_248:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_249, arg1_249, arg2_249)
			local var0_249 = arg0_249:getConfig("display")

			if arg0_249:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_249 = string.gsub(var0_249, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_249.extra))
			elseif arg0_249:getConfig("combination_display") ~= nil then
				local var1_249 = arg0_249:getConfig("combination_display")

				if var1_249 and #var1_249 > 0 then
					var0_249 = Item.StaticCombinationDisplay(var1_249)
				end
			end

			setText(arg2_249, SwitchSpecialChar(var0_249, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_250, arg1_250, arg2_250)
			setText(arg2_250, arg0_250:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_251, arg1_251, arg2_251)
			local var0_251 = arg0_251:getConfig("skin_id")
			local var1_251, var2_251, var3_251 = ShipWordHelper.GetWordAndCV(var0_251, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_251, var3_251 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_252, arg1_252, arg2_252)
			local var0_252 = arg0_252:getConfig("skin_id")
			local var1_252, var2_252, var3_252 = ShipWordHelper.GetWordAndCV(var0_252, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_252, var3_252 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_253, arg1_253, arg2_253)
			setText(arg2_253, arg1_253.name or arg0_253:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_254, arg1_254, arg2_254)
			local var0_254 = arg0_254:getConfig("desc")

			for iter0_254, iter1_254 in ipairs({
				arg0_254.count
			}) do
				var0_254 = string.gsub(var0_254, "$" .. iter0_254, iter1_254)
			end

			setText(arg2_254, var0_254)
		end,
		[DROP_TYPE_SKIN] = function(arg0_255, arg1_255, arg2_255)
			setText(arg2_255, arg0_255:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_256, arg1_256, arg2_256)
			setText(arg2_256, arg0_256:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_257, arg1_257, arg2_257)
			local var0_257 = arg0_257:getConfig("desc")
			local var1_257 = _.map(arg0_257:getConfig("equip_type"), function(arg0_258)
				return EquipType.Type2Name2(arg0_258)
			end)

			setText(arg2_257, var0_257 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_257, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_259, arg1_259, arg2_259)
			setText(arg2_259, arg0_259:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_260, arg1_260, arg2_260)
			setText(arg2_260, arg0_260:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_261, arg1_261, arg2_261, arg3_261)
			local var0_261 = WorldCollectionProxy.GetCollectionType(arg0_261.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_261, i18n("world_" .. var0_261 .. "_desc", arg0_261:getConfig("name")))
			setText(arg3_261, i18n("world_" .. var0_261 .. "_name", arg0_261:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_262, arg1_262, arg2_262)
			setText(arg2_262, arg0_262.desc and arg0_262.desc or arg0_262:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_263, arg1_263, arg2_263)
			setText(arg2_263, arg0_263:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_264, arg1_264, arg2_264)
			setText(arg2_264, arg0_264:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_265, arg1_265, arg2_265)
			local var0_265 = string.gsub(arg0_265:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_265.count))

			setText(arg2_265, SwitchSpecialChar(var0_265, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_266, arg1_266, arg2_266)
			setText(arg2_266, arg0_266:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_267, arg1_267, arg2_267)
			setText(arg2_267, arg0_267:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_268, arg1_268, arg2_268)
			setText(arg2_268, arg0_268:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_269, arg1_269, arg2_269)
			setText(arg2_269, arg0_269:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_270, arg1_270, arg2_270)
			setText(arg2_270, arg0_270:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_271, arg1_271, arg2_271)
			setText(arg2_271, arg0_271:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_272, arg1_272, arg2_272)
			setText(arg2_272, "")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_273, arg1_273, arg2_273)
			setText(arg2_273, arg0_273.desc)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_274, arg1_274, arg2_274)
			setText(arg2_274, arg0_274.desc)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_275, arg1_275, arg2_275)
			setText(arg2_275, arg0_275.desc)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_276, arg1_276, arg2_276)
			setText(arg2_276, arg0_276.desc)
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_277, arg1_277, arg2_277)
		if arg0_277.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_277, arg0_277:getConfig("display"))
		else
			setText(arg2_277, arg0_277.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_278, arg1_278, arg2_278)
			if arg0_278.id == PlayerConst.ResStoreGold or arg0_278.id == PlayerConst.ResStoreOil then
				arg2_278 = arg2_278 or {}
				arg2_278.frame = "frame_store"
			end

			updateItem(arg1_278, Item.New({
				id = id2ItemId(arg0_278.id)
			}), arg2_278)
		end,
		[DROP_TYPE_ITEM] = function(arg0_279, arg1_279, arg2_279)
			updateItem(arg1_279, arg0_279:getSubClass(), arg2_279)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_280, arg1_280, arg2_280)
			updateEquipment(arg1_280, arg0_280:getSubClass(), arg2_280)
		end,
		[DROP_TYPE_SHIP] = function(arg0_281, arg1_281, arg2_281)
			updateShip(arg1_281, arg0_281.ship, arg2_281)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_282, arg1_282, arg2_282)
			updateShip(arg1_282, arg0_282.ship, arg2_282)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_283, arg1_283, arg2_283)
			updateFurniture(arg1_283, arg0_283, arg2_283)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_284, arg1_284, arg2_284)
			arg2_284.isWorldBuff = arg0_284.isWorldBuff

			updateStrategy(arg1_284, arg0_284, arg2_284)
		end,
		[DROP_TYPE_SKIN] = function(arg0_285, arg1_285, arg2_285)
			arg2_285.isSkin = true
			arg2_285.isNew = arg0_285.isNew

			updateShip(arg1_285, Ship.New({
				configId = tonumber(arg0_285:getConfig("ship_group") .. "1"),
				skin_id = arg0_285.id
			}), arg2_285)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_286, arg1_286, arg2_286)
			local var0_286 = setmetatable({
				count = arg0_286.count
			}, {
				__index = arg0_286:getConfigTable()
			})

			updateEquipmentSkin(arg1_286, var0_286, arg2_286)
		end,
		[DROP_TYPE_VITEM] = function(arg0_287, arg1_287, arg2_287)
			updateItem(arg1_287, Item.New({
				id = arg0_287.id
			}), arg2_287)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_288, arg1_288, arg2_288)
			updateWorldItem(arg1_288, WorldItem.New({
				id = arg0_288.id
			}), arg2_288)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_289, arg1_289, arg2_289)
			updateWorldCollection(arg1_289, arg0_289, arg2_289)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_290, arg1_290, arg2_290)
			updateAttire(arg1_290, AttireConst.TYPE_CHAT_FRAME, arg0_290:getConfigTable(), arg2_290)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_291, arg1_291, arg2_291)
			updateAttire(arg1_291, AttireConst.TYPE_ICON_FRAME, arg0_291:getConfigTable(), arg2_291)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_292, arg1_292, arg2_292)
			updateEmoji(arg1_292, arg0_292:getConfigTable(), arg2_292)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_293, arg1_293, arg2_293)
			arg2_293.count = 1

			updateItem(arg1_293, arg0_293:getSubClass(), arg2_293)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_294, arg1_294, arg2_294)
			updateSpWeapon(arg1_294, SpWeapon.New({
				id = arg0_294.id
			}), arg2_294)
		end,
		[DROP_TYPE_META_PT] = function(arg0_295, arg1_295, arg2_295)
			updateItem(arg1_295, Item.New({
				id = arg0_295:getConfig("id")
			}), arg2_295)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_296, arg1_296, arg2_296)
			arg2_296.isSkin = true
			arg2_296.isTimeLimit = true
			arg2_296.count = 1

			updateShip(arg1_296, Ship.New({
				configId = tonumber(arg0_296:getConfig("ship_group") .. "1"),
				skin_id = arg0_296.id
			}), arg2_296)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_297, arg1_297, arg2_297)
			AtelierMaterial.UpdateRyzaItem(arg1_297, arg0_297.item, arg2_297)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_298, arg1_298, arg2_298)
			WorkBenchItem.UpdateDrop(arg1_298, arg0_298.item, arg2_298)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_299, arg1_299, arg2_299)
			WorkBenchItem.UpdateDrop(arg1_299, WorkBenchItem.New({
				configId = arg0_299.id,
				count = arg0_299.count
			}), arg2_299)
		end,
		[DROP_TYPE_BUFF] = function(arg0_300, arg1_300, arg2_300)
			updateBuff(arg1_300, arg0_300.id, arg2_300)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_301, arg1_301, arg2_301)
			updateCommander(arg1_301, arg0_301, arg2_301)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_302, arg1_302, arg2_302)
			updateCover(arg1_302, arg0_302, arg2_302)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_303, arg1_303, arg2_303)
			updateAttireCombatUI(arg1_303, AttireConst.TYPE_ICON_FRAME, arg0_303:getConfigTable(), arg2_303)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_304, arg1_304, arg2_304)
			updateActivityMedal(arg1_304, arg0_304:getConfigTable(), arg2_304)
		end
	}

	function var0_0.UpdateDropDefault(arg0_305, arg1_305, arg2_305)
		updateDefaultIconTpl(arg1_305, arg0_305, arg2_305)
	end

	var0_0.UpdateCustomDropCase = {
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_306, arg1_306, arg2_306)
			updateDorm3dIcon(arg1_306, arg0_306, arg2_306)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_307, arg1_307, arg2_307)
			updateDorm3dIcon(arg1_307, arg0_307, arg2_307)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_308, arg1_308, arg2_308)
			updateDorm3dIcon(arg1_308, arg0_308, arg2_308)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_309, arg1_309, arg2_309)
			updateIslandItem(arg1_309, arg0_309, arg2_309)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_310, arg1_310, arg2_310)
			updateIslandUnlock(arg1_310, arg0_310, arg2_310)
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_311, arg1_311, arg2_311)
			updateIslandInvitation(arg1_311, arg0_311, arg2_311)
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_312, arg1_312, arg2_312)
			updateIslandSeasonPt(arg1_312, arg0_312, arg2_312)
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_313, arg1_313, arg2_313)
			updateIslandWatherCollect(arg1_313, arg0_313, arg2_313)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_314, arg1_314, arg2_314)
			updateIslandFurniture(arg1_314, arg0_314, arg2_314)
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_315, arg1_315, arg2_315)
			updateIslandCardDiy(arg1_315, arg0_315, arg2_315)
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_316, arg1_316, arg2_316)
			updateIslandSpeedupTicket(arg1_316, arg0_316, arg2_316)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_317, arg1_317, arg2_317)
			updateItem(arg1_317, Item.New({
				id = arg0_317.id
			}), arg2_317)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_318, arg1_318, arg2_318)
			updateIslandSkin(arg1_318, arg0_318, arg2_318)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_319, arg1_319, arg2_319)
			updateIslandDress(arg1_319, arg0_319, arg2_319)
		end
	}

	function var0_0.UpdateCustomDropDefault(arg0_320, arg1_320, arg2_320)
		if arg2_320.style == "dorm" then
			updateDorm3dIcon(arg1_320, arg0_320, arg2_320)
		elseif arg2_320.style == "island" then
			updateIslandDefaultIconTpl(arg1_320, arg0_320, arg2_320)
		else
			warning(string.format("without dropType %d in updateCustomDrop", arg0_320.type))
		end
	end
end

return var0_0
