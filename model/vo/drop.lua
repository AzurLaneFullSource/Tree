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
			local var0_9 = arg0_7:getConfig("icon_normal")

			return var0_9 ~= "" and var0_9 or "island/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function()
			return "island/" .. arg0_7:getConfig("cmd_icon")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function()
			local var0_11 = pg.island_item_data_template[arg0_7:getConfig("invite_item")].icon

			return "island/" .. var0_11
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function()
			return "island/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function()
			return "island/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			return "island/IslandFurnitureIcon/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function()
			return "island/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function()
			return arg0_7:getConfig("icon_normal")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function()
			return "island/IslandDressIcon/" .. arg0_7:getConfig("icon")
		end,
		[DROP_TYPE_ISLAND_ACTION] = function()
			return "island/IslandActionIcon/" .. arg0_7:getConfig("resource")
		end,
		[DROP_TYPE_ISLAND_SKIN] = function()
			return arg0_7:getConfig("icon_normal")
		end
	}, function()
		return arg0_7:getConfig("icon")
	end)
end

function var0_0.getDefaultIcon(arg0_21)
	return switch(arg0_21.type, {
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

function var0_0.getIslandRarity(arg0_38)
	return switch(arg0_38.type, {
		[DROP_TYPE_ISLAND_ITEM] = function()
			return arg0_38:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			return arg0_38:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function()
			return arg0_38:getConfig("rarity")
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

function var0_0.getCount(arg0_47)
	if arg0_47.type == DROP_TYPE_OPERATION or arg0_47.type == DROP_TYPE_LOVE_LETTER then
		return 1
	else
		return arg0_47.count
	end
end

function var0_0.isLoveLetter(arg0_48)
	return arg0_48.type == DROP_TYPE_LOVE_LETTER or arg0_48.type == DROP_TYPE_ITEM and arg0_48:getConfig("type") == Item.LOVE_LETTER_TYPE
end

function var0_0.getOwnedCount(arg0_49)
	return switch(arg0_49.type, var0_0.CountCase, var0_0.CountDefault, arg0_49)
end

function var0_0.getSubClass(arg0_50)
	return switch(arg0_50.type, var0_0.SubClassCase, var0_0.SubClassDefault, arg0_50)
end

function var0_0.getDropRarity(arg0_51)
	return switch(arg0_51.type, var0_0.RarityCase, var0_0.RarityDefault, arg0_51)
end

function var0_0.getDropRarityDorm(arg0_52)
	return switch(arg0_52.type, var0_0.RarityCase, var0_0.RarityDefaultDorm, arg0_52)
end

function var0_0.DropTrans(arg0_53, ...)
	return switch(arg0_53.type, var0_0.TransCase, var0_0.TransDefault, arg0_53, ...)
end

function var0_0.AddItemOperation(arg0_54)
	return switch(arg0_54.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_54)
end

function var0_0.MsgboxIntroSet(arg0_55, ...)
	return switch(arg0_55.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_55, ...)
end

function var0_0.UpdateDropTpl(arg0_56, ...)
	return switch(arg0_56.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_56, ...)
end

function var0_0.UpdateCustomDropTpl(arg0_57, ...)
	return switch(arg0_57.type, var0_0.UpdateCustomDropCase, var0_0.UpdateCustomDropDefault, arg0_57, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_59)
			local var0_59 = Item.getConfigData(id2ItemId(arg0_59.id))

			arg0_59.desc = var0_59.display

			return var0_59
		end,
		[DROP_TYPE_ITEM] = function(arg0_60)
			warning(arg0_60.id)

			local var0_60 = Item.getConfigData(arg0_60.id)

			arg0_60.desc = var0_60.display

			if var0_60.type == Item.LOVE_LETTER_TYPE then
				arg0_60.desc = string.gsub(arg0_60.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_60.extra))
			end

			return var0_60
		end,
		[DROP_TYPE_VITEM] = function(arg0_61)
			local var0_61 = Item.getConfigData(arg0_61.id)

			assert(var0_61, arg0_61.id)

			arg0_61.desc = var0_61.display

			return var0_61
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_62)
			local var0_62 = Item.getConfigData(arg0_62.id)

			arg0_62.desc = string.gsub(var0_62.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_62.count))

			return var0_62
		end,
		[DROP_TYPE_EQUIP] = function(arg0_63)
			local var0_63 = Equipment.getConfigData(arg0_63.id)

			arg0_63.desc = var0_63.descrip

			return var0_63
		end,
		[DROP_TYPE_SHIP] = function(arg0_64)
			local var0_64 = pg.ship_data_statistics[arg0_64.id]
			local var1_64, var2_64, var3_64 = ShipWordHelper.GetWordAndCV(var0_64.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_64.desc = var3_64 or i18n("ship_drop_desc_default")
			arg0_64.ship = Ship.New({
				configId = arg0_64.id,
				skin_id = arg0_64.skinId,
				propose = arg0_64.propose
			})
			arg0_64.ship.remoulded = arg0_64.remoulded
			arg0_64.ship.virgin = arg0_64.virgin

			return var0_64
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_65)
			local var0_65 = pg.furniture_data_template[arg0_65.id]

			arg0_65.desc = var0_65.describe

			return var0_65
		end,
		[DROP_TYPE_SKIN] = function(arg0_66)
			local var0_66 = pg.ship_skin_template[arg0_66.id]

			if var0_66.skin_type == ShipSkin.SKIN_TYPE_TB then
				local var1_66, var2_66, var3_66 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_66.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_66.desc = var3_66
			else
				local var4_66, var5_66, var6_66 = ShipWordHelper.GetWordAndCV(arg0_66.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_66.desc = var6_66
			end

			return var0_66
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_67)
			local var0_67 = pg.ship_skin_template[arg0_67.id]

			if var0_67.skin_type == ShipSKin.SKIN_TYPE_TB then
				local var1_67, var2_67, var3_67 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_67.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_67.desc = var3_67
			else
				local var4_67, var5_67, var6_67 = ShipWordHelper.GetWordAndCV(arg0_67.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_67.desc = var6_67
			end

			return var0_67
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_68)
			local var0_68 = pg.equip_skin_template[arg0_68.id]

			arg0_68.desc = var0_68.desc

			return var0_68
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_69)
			local var0_69 = pg.world_item_data_template[arg0_69.id]

			arg0_69.desc = var0_69.display

			return var0_69
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_70)
			local var0_70 = pg.item_data_frame[arg0_70.id]

			arg0_70.desc = var0_70.desc

			return var0_70
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_71)
			return pg.item_data_chat[arg0_71.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_72)
			local var0_72 = pg.spweapon_data_statistics[arg0_72.id]

			arg0_72.desc = var0_72.descrip

			return var0_72
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_73)
			local var0_73 = pg.activity_ryza_item[arg0_73.id]

			arg0_73.item = AtelierMaterial.New({
				configId = arg0_73.id
			})
			arg0_73.desc = arg0_73.item:GetDesc()

			return var0_73
		end,
		[DROP_TYPE_OPERATION] = function(arg0_74)
			arg0_74.ship = getProxy(BayProxy):getShipById(arg0_74.count)

			local var0_74 = pg.ship_data_statistics[arg0_74.ship.configId]
			local var1_74, var2_74, var3_74 = ShipWordHelper.GetWordAndCV(var0_74.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_74.desc = var3_74 or i18n("ship_drop_desc_default")

			return var0_74
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_75)
			return arg0_75.isWorldBuff and pg.world_SLGbuff_data[arg0_75.id] or pg.strategy_data_template[arg0_75.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_76)
			local var0_76 = pg.emoji_template[arg0_76.id]

			arg0_76.name = var0_76.item_name
			arg0_76.desc = var0_76.item_desc

			return var0_76
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_77)
			local var0_77 = WorldCollectionProxy.GetCollectionTemplate(arg0_77.id)

			arg0_77.desc = var0_77.name

			return var0_77
		end,
		[DROP_TYPE_META_PT] = function(arg0_78)
			local var0_78 = pg.ship_strengthen_meta[arg0_78.id]
			local var1_78 = Item.getConfigData(var0_78.itemid)

			arg0_78.desc = var1_78.display

			return var1_78
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_79)
			local var0_79 = pg.activity_workbench_item[arg0_79.id]

			arg0_79.item = WorkBenchItem.New({
				configId = arg0_79.id
			})
			arg0_79.desc = arg0_79.item:GetDesc()

			return var0_79
		end,
		[DROP_TYPE_BUFF] = function(arg0_80)
			local var0_80 = pg.benefit_buff_template[arg0_80.id]

			arg0_80.desc = var0_80.desc

			return var0_80
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_81)
			local var0_81 = pg.commander_data_template[arg0_81.id]

			arg0_81.desc = var0_81.desc

			return var0_81
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_82)
			local var0_82 = pg.island_item_data_template[arg0_82.id]

			arg0_82.desc = var0_82.desc

			return var0_82
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_83)
			local var0_83 = pg.island_ability_template[arg0_83.id]

			arg0_83.desc = ""

			return var0_83
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_84)
			local var0_84 = pg.island_chara_template[arg0_84.id]

			arg0_84.desc = ""

			return var0_84
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_85)
			local var0_85 = pg.island_furniture_template[arg0_85.id]

			arg0_85.desc = var0_85.describe

			return var0_85
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_86)
			local var0_86 = pg.island_dress_template[arg0_86.id]

			arg0_86.desc = var0_86.desc

			return var0_86
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_87)
			local var0_87 = pg.island_skin_template[arg0_87.id]

			arg0_87.desc = var0_87.desc

			return var0_87
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_88)
			local var0_88 = pg.island_action[arg0_88.id]

			arg0_88.desc = var0_88.desc

			return var0_88
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_89)
			local var0_89 = pg.island_speedup_ticket[arg0_89.id]

			arg0_89.desc = var0_89.desc

			return var0_89
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_90)
			local var0_90 = pg.island_card_diy[arg0_90.id]

			arg0_90.desc = var0_90.desc

			return var0_90
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_91)
			return pg.drop_data_restore[arg0_91.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_92)
			local var0_92 = pg.dorm3d_furniture_template[arg0_92.id]

			arg0_92.desc = var0_92.desc

			return var0_92
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_93)
			local var0_93 = pg.dorm3d_gift[arg0_93.id]

			arg0_93.desc = var0_93.display

			return var0_93
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_94)
			local var0_94 = pg.dorm3d_resource[arg0_94.id]

			arg0_94.desc = ""

			return var0_94
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_95)
			local var0_95 = pg.livingarea_cover[arg0_95.id]

			arg0_95.desc = var0_95.desc

			return var0_95
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_96)
			return pg.item_data_battleui[arg0_96.id]
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_97)
			local var0_97 = pg.activity_medal_template[arg0_97.id].item

			return pg.item_virtual_data_statistics[var0_97]
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_98)
			local var0_98 = Item.getConfigData(arg0_98.id)

			assert(var0_98, arg0_98.id)

			arg0_98.desc = var0_98.display

			return var0_98
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_99)
			return pg.island_collection[arg0_99.id]
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_100)
			local var0_100 = pg.island_set.season_pt_show.key_value_int
			local var1_100 = pg.island_item_data_template[var0_100]

			arg0_100.desc = var1_100.desc

			return var1_100
		end
	}

	function var0_0.ConfigDefault(arg0_101)
		local var0_101 = arg0_101.type

		if tonumber(var0_101) and var0_101 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_101 = pg.activity_drop_type[var0_101].relevance

			return var1_101 and pg[var1_101][arg0_101.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_102)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_102.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_103)
			local var0_103 = getProxy(BagProxy):getItemCountById(arg0_103.id)

			if arg0_103:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_103, 1), true
			else
				return var0_103, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_104)
			local var0_104 = arg0_104:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_104], "equip groupId not exist")

			local var1_104 = pg.equip_data_template.get_id_list_by_group[var0_104]

			return underscore.reduce(var1_104, 0, function(arg0_105, arg1_105)
				local var0_105 = getProxy(EquipmentProxy):getEquipmentById(arg1_105)

				return arg0_105 + (var0_105 and var0_105.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_105)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_106)
			return getProxy(BayProxy):getConfigShipCount(arg0_106.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_107)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_107.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_108)
			return arg0_108.count, tobool(arg0_108.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_109)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_109.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_110)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_110.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_111)
			local var0_111 = arg0_111:getConfig("virtual_type")

			return switch(var0_111, {
				[22] = function()
					local var0_112 = getProxy(ActivityProxy):getActivityById(arg0_111:getConfig("link_id"))

					return var0_112 and var0_112.data1 or 0, true
				end,
				[101] = function()
					local var0_113 = getProxy(ActivityProxy):getActivityById(arg0_111:getConfig("link_id"))

					return var0_113 and var0_113.data1 or 0
				end
			}, function()
				return nil
			end)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_115)
			local var0_115 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_115.id)

			return (var0_115 and var0_115.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_115.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_116)
			local var0_116 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_116.type].activity_id)

			if not var0_116 then
				return 0
			end

			local var1_116 = var0_116:GetItemById(arg0_116.id)

			return var1_116 and var1_116.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_117)
			local var0_117 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_117.id)

			return var0_117 and (not var0_117:expiredType() or not not var0_117:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_118)
			local var0_118 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_118.id)

			return var0_118 and (not var0_118:expiredType() or not not var0_118:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_119)
			local var0_119 = nowWorld()

			if var0_119.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_119:GetInventoryProxy():GetItemCount(arg0_119.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_120)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_120.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_121)
			local var0_121 = getProxy(LivingAreaCoverProxy):GetCover(arg0_121.id)

			return var0_121 and var0_121:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_122)
			return getProxy(ApartmentProxy):getGiftCount(arg0_122.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_123)
			local var0_123 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_123.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_124)
			local var0_124 = 0
			local var1_124 = getProxy(IslandProxy):GetIsland()

			if var1_124 then
				var0_124 = var1_124:GetInventoryAgency():GetOwnCount(arg0_124.id)
			end

			return var0_124
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_125)
			return 0
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_126)
			return 0
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_127)
			local var0_127 = getProxy(IslandProxy):GetIsland()

			if var0_127 then
				local var1_127 = var0_127:GetAgoraAgency():GetFurnitures()

				for iter0_127, iter1_127 in ipairs(var1_127) do
					if iter1_127.id == arg0_127.id then
						return iter1_127.count
					end
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_128)
			local var0_128 = getProxy(IslandProxy):GetIsland()

			if var0_128 then
				local var1_128 = arg0_128:getConfig("belongto")

				if var1_128 == 1 then
					return var0_128:GetDressUpAgency():CheckOwnDress(arg0_128.id) and 1 or 0
				elseif var1_128 == 2 then
					return var0_128:GetCharacterAgency():GetDressIdRealCount(arg0_128.id)
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_129)
			local var0_129 = getProxy(IslandProxy)

			if not var0_129 then
				return 0
			end

			local var1_129 = var0_129:GetIsland()

			if var1_129 then
				return var1_129:GetCharacterAgency():CheckSkinIsOwned(arg0_129.id) and 1 or 0
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_130)
			local var0_130 = getProxy(IslandProxy)

			if not var0_130 then
				return 0
			end

			local var1_130 = var0_130:GetIsland()

			if var1_130 then
				return var1_130:GetActionAgency():ExistAction(arg0_130.id) and 1 or 0
			end

			return 0
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_131)
			local var0_131 = getProxy(IslandProxy)

			if not var0_131 then
				return 0
			end

			local var1_131 = var0_131:GetIsland()

			if var1_131 then
				return var1_131:GetSeasonAgency():GetSeason():GetPt()
			end

			return 0
		end
	}

	function var0_0.CountDefault(arg0_132)
		local var0_132 = arg0_132.type

		if var0_132 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_132].activity_id):getVitemNumber(arg0_132.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_133)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_134)
			return Item.New(arg0_134)
		end,
		[DROP_TYPE_VITEM] = function(arg0_135)
			return Item.New(arg0_135)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_136)
			return Equipment.New(arg0_136)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_137)
			return Item.New({
				count = 1,
				id = arg0_137.id,
				extra = arg0_137.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_138)
			return WorldItem.New(arg0_138)
		end
	}

	function var0_0.SubClassDefault(arg0_139)
		assert(false, string.format("drop type %d without subClass", arg0_139.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_140)
			return arg0_140:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_141)
			return arg0_141:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_142)
			return arg0_142:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_143)
			return arg0_143:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_144)
			return arg0_144:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_145)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_146)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_147)
			return arg0_147:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_148)
			return arg0_148:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_149)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_150)
			return arg0_150:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_151)
			return arg0_151:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_152)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_153)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_154)
			return arg0_154:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_155)
			return arg0_155:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_156)
			return arg0_156:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_157)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_158)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_159)
			return arg0_159:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_160)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_161)
			return ItemRarity.Gold
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_162)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_163)
		return arg0_163:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_164)
		return arg0_164:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_165)
			local var0_165 = Drop.New({
				type = arg0_165:getConfig("type"),
				id = arg0_165:getConfig("resource_type"),
				count = arg0_165:getConfig("resource_num") * arg0_165.count
			})
			local var1_165 = Drop.New({
				type = arg0_165:getConfig("target_type"),
				id = arg0_165:getConfig("target_id"),
				count = arg0_165.count
			})

			PlayerConst.UpdateLinkActivity({
				var1_165
			})

			var0_165.name = string.format("%s(%s)", var0_165:getName(), var1_165:getName())

			return var0_165
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_166)
			for iter0_166, iter1_166 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_166.id].pt == arg0_166.id then
					return nil, arg0_166
				end
			end

			for iter2_166, iter3_166 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)) do
				if pg.black_friday_battlepass_event_pt[iter3_166.id].pt == arg0_166.id then
					return nil, arg0_166
				end
			end

			return arg0_166
		end,
		[DROP_TYPE_OPERATION] = function(arg0_167)
			if arg0_167.id ~= 3 then
				return nil
			end

			return arg0_167
		end,
		[DROP_TYPE_EMOJI] = function(arg0_168)
			return nil, arg0_168
		end,
		[DROP_TYPE_VITEM] = function(arg0_169, arg1_169, arg2_169)
			assert(arg0_169:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_169.id)

			return switch(arg0_169:getConfig("virtual_type"), {
				function()
					if arg0_169:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_169
					end

					return arg0_169
				end,
				[6] = function()
					local var0_171 = arg2_169.taskId
					local var1_171 = getProxy(ActivityProxy)
					local var2_171 = var1_171:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_171 then
						local var3_171 = var2_171.data1KeyValueList[1]

						var3_171[var0_171] = defaultValue(var3_171[var0_171], 0) + arg0_169.count

						var1_171:updateActivity(var2_171)
					end

					return nil, arg0_169
				end,
				[13] = function()
					local var0_172 = arg0_169:getName()
					local var1_172 = getProxy(ActivityProxy):getActivityById(arg0_169:getConfig("link_id"))

					if not var1_172 or var1_172:isEnd() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_172))

						return nil
					elseif var1_172:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_172))

						return nil
					else
						return arg0_169, nil
					end
				end,
				[17] = function()
					local var0_173 = getProxy(ActivityProxy):getActivityById(arg0_169:getConfig("link_id"))

					if var0_173.data1 < 1 then
						return Drop.New({
							count = 1,
							type = DROP_TYPE_SHIP,
							id = var0_173:getConfig("config_id")
						}), arg0_169
					else
						return Drop.New({
							id = 3,
							type = DROP_TYPE_OPERATION,
							count = var0_173.data2
						}), arg0_169
					end
				end,
				[21] = function()
					return nil, arg0_169
				end,
				[28] = function()
					local var0_175 = Drop.New({
						type = arg0_169.type,
						id = arg0_169.id,
						count = math.floor(arg0_169.count / 1000)
					})
					local var1_175 = Drop.New({
						type = arg0_169.type,
						id = arg0_169.id,
						count = arg0_169.count - math.floor(arg0_169.count / 1000)
					})

					return var0_175, var1_175
				end
			}, function()
				return arg0_169
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_177, arg1_177)
			if Ship.isMetaShipByConfigID(arg0_177.id) and Player.isMetaShipNeedToTrans(arg0_177.id) then
				local var0_177 = table.indexof(arg1_177, arg0_177.id, 1)

				if var0_177 then
					table.remove(arg1_177, var0_177)
				else
					local var1_177 = Player.metaShip2Res(arg0_177.id)
					local var2_177 = Drop.New(var1_177[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_177.id, var2_177)

					return arg0_177, var2_177
				end
			end

			return arg0_177
		end,
		[DROP_TYPE_SKIN] = function(arg0_178)
			arg0_178.isNew = not getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_178.id)

			return arg0_178
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_179)
			local var0_179 = getProxy(PlayerProxy):getRawData()
			local var1_179 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_179:updateMedalList({
				{
					key = arg0_179.id,
					value = var1_179
				}
			})

			return arg0_179
		end,
		[DROP_TYPE_BUFF] = function(arg0_180)
			return nil, arg0_180
		end
	}

	function var0_0.TransDefault(arg0_181)
		return arg0_181
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_182)
			local var0_182 = id2res(arg0_182.id)

			assert(var0_182, "res should be defined: " .. arg0_182.id)

			local var1_182 = getProxy(PlayerProxy)
			local var2_182 = var1_182:getData()

			var2_182:addResources({
				[var0_182] = arg0_182.count
			})
			var1_182:updatePlayer(var2_182)
		end,
		[DROP_TYPE_ITEM] = function(arg0_183)
			if arg0_183:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_183 = getProxy(BagProxy):getItemCountById(arg0_183.id)
				local var1_183 = math.min(arg0_183:getConfig("max_num") - var0_183, arg0_183.count)

				if var1_183 > 0 then
					getProxy(BagProxy):addItemById(arg0_183.id, var1_183)
				end
			else
				getProxy(BagProxy):addItemById(arg0_183.id, arg0_183.count, arg0_183.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_184)
			local var0_184 = arg0_184:getSubClass()

			getProxy(BagProxy):addItemById(var0_184.id, var0_184.count, var0_184.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_185)
			getProxy(EquipmentProxy):addEquipmentById(arg0_185.id, arg0_185.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_186)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_187)
			local var0_187 = getProxy(DormProxy)
			local var1_187 = Furniture.New({
				id = arg0_187.id,
				count = arg0_187.count
			})

			if var1_187:isRecordTime() then
				var1_187.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_187:AddFurniture(var1_187)
		end,
		[DROP_TYPE_SKIN] = function(arg0_188)
			local var0_188 = getProxy(ShipSkinProxy)
			local var1_188 = ShipSkin.New({
				id = arg0_188.id
			})

			var0_188:addSkin(var1_188)
		end,
		[DROP_TYPE_VITEM] = function(arg0_189)
			arg0_189 = arg0_189:getSubClass()

			assert(arg0_189:isVirtualItem(), "item type error(virtual item)>>" .. arg0_189.id)
			switch(arg0_189:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_189.id, arg0_189.count)
				end,
				function()
					local var0_191 = getProxy(ActivityProxy)
					local var1_191 = arg0_189:getConfig("link_id")
					local var2_191

					if var1_191 > 0 then
						var2_191 = var0_191:getActivityById(var1_191)
					else
						var2_191 = var0_191:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_191 and not var2_191:isEnd() then
						if not table.contains(var2_191.data1_list, arg0_189.id) then
							table.insert(var2_191.data1_list, arg0_189.id)
						end

						var0_191:updateActivity(var2_191)
					end
				end,
				function()
					local var0_192 = getProxy(ActivityProxy)
					local var1_192 = var0_192:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_192, iter1_192 in ipairs(var1_192) do
						iter1_192.data1 = iter1_192.data1 + arg0_189.count

						local var2_192 = iter1_192:getConfig("config_id")
						local var3_192 = pg.activity_vote[var2_192]

						if var3_192 and var3_192.ticket_id_period == arg0_189.id then
							iter1_192.data3 = iter1_192.data3 + arg0_189.count
						end

						var0_192:updateActivity(iter1_192)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_189.id,
							ptCount = arg0_189.count
						})
					end
				end,
				[4] = function()
					local var0_193 = getProxy(ColoringProxy):getColorItems()

					var0_193[arg0_189.id] = (var0_193[arg0_189.id] or 0) + arg0_189.count
				end,
				[6] = function()
					local var0_194 = getProxy(ActivityProxy)
					local var1_194 = var0_194:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_194 then
						var1_194.data3 = var1_194.data3 + arg0_189.count

						var0_194:updateActivity(var1_194)
					end
				end,
				[7] = function()
					local var0_195 = getProxy(ChapterProxy)

					var0_195:updateRemasterTicketsNum(math.min(var0_195.remasterTickets + arg0_189.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_196 = getProxy(ActivityProxy)
					local var1_196 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_196 then
						var1_196.data1_list[1] = var1_196.data1_list[1] + arg0_189.count

						var0_196:updateActivity(var1_196)
					end
				end,
				[11] = function()
					local var0_197 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_197 and not var0_197:isEnd() then
						var0_197.data1 = var0_197.data1 + arg0_189.count
					end
				end,
				[12] = function()
					local var0_198 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_198 and not var0_198:isEnd() then
						var0_198.data1KeyValueList[1][arg0_189.id] = (var0_198.data1KeyValueList[1][arg0_189.id] or 0) + arg0_189.count
					end
				end,
				[13] = function()
					local var0_199 = getProxy(ActivityProxy):getActivityById(arg0_189:getConfig("link_id"))

					if var0_199:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

						return
					end

					var0_199.data1 = var0_199.data1 + arg0_189.count

					getProxy(ActivityProxy):updateActivity(var0_199)
				end,
				[14] = function()
					local var0_200 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_189.id then
						var0_200:AddSummonPt(arg0_189.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_189.id then
						var0_200:AddSummonPtOld(arg0_189.count)
					end
				end,
				[15] = function()
					local var0_201 = getProxy(ActivityProxy)
					local var1_201 = var0_201:getActivityById(arg0_189:getConfig("link_id"))

					if not var1_201 or var1_201:isEnd() then
						return
					end

					if var1_201:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_201 = pg.activity_event_grid[var1_201.data1]

						if arg0_189.id == var2_201.ticket_item then
							var1_201.data2 = var1_201.data2 + arg0_189.count
						elseif arg0_189.id == var2_201.explore_item then
							var1_201.data3 = var1_201.data3 + arg0_189.count
						end
					elseif var1_201:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_201.data3 = var1_201.data3 + arg0_189.count
					end

					var0_201:updateActivity(var1_201)
				end,
				[16] = function()
					local var0_202 = getProxy(ActivityProxy)
					local var1_202 = var0_202:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_202, iter1_202 in pairs(var1_202) do
						if iter1_202 and not iter1_202:isEnd() and arg0_189.id == iter1_202:getConfig("config_id") then
							iter1_202.data1 = iter1_202.data1 + arg0_189.count

							var0_202:updateActivity(iter1_202)
						end
					end
				end,
				[17] = function()
					local var0_203 = getProxy(ActivityProxy)
					local var1_203 = var0_203:getActivityById(arg0_189:getConfig("link_id"))

					if not var1_203 or var1_203:isEnd() then
						return
					end

					var1_203.data1 = 2

					var0_203:updateActivity(var1_203)
				end,
				[20] = function()
					local var0_204 = getProxy(BagProxy)
					local var1_204 = pg.gameset.urpt_chapter_max.description
					local var2_204 = var1_204[1]
					local var3_204 = var1_204[2]
					local var4_204 = var0_204:GetLimitCntById(var2_204)
					local var5_204 = math.min(var3_204 - var4_204, arg0_189.count)

					if var5_204 > 0 then
						var0_204:addItemById(var2_204, var5_204)
						var0_204:AddLimitCnt(var2_204, var5_204)
					end
				end,
				[21] = function()
					local var0_205 = getProxy(ActivityProxy)
					local var1_205 = var0_205:getActivityById(arg0_189:getConfig("link_id"))

					if var1_205 and not var1_205:isEnd() then
						var1_205.data2 = 1

						var0_205:updateActivity(var1_205)
					end
				end,
				[22] = function()
					local var0_206 = getProxy(ActivityProxy)
					local var1_206 = var0_206:getActivityById(arg0_189:getConfig("link_id"))

					if var1_206 and not var1_206:isEnd() then
						var1_206.data1 = var1_206.data1 + arg0_189.count

						var0_206:updateActivity(var1_206)
					end
				end,
				[23] = function()
					local var0_207 = (function()
						for iter0_208, iter1_208 in ipairs(pg.gameset.package_lv.description) do
							if arg0_189.id == iter1_208[1] then
								return iter1_208[2]
							end
						end
					end)()

					assert(var0_207)

					local var1_207 = getProxy(PlayerProxy)
					local var2_207 = var1_207:getData()

					var2_207:addExpToLevel(var0_207)
					var1_207:updatePlayer(var2_207)
				end,
				[24] = function()
					local var0_209 = arg0_189:getConfig("link_id")
					local var1_209 = getProxy(ActivityProxy):getActivityById(var0_209)

					if var1_209 and not var1_209:isEnd() and var1_209:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_209.data2 = var1_209.data2 + arg0_189.count

						getProxy(ActivityProxy):updateActivity(var1_209)
					end
				end,
				[25] = function()
					local var0_210 = getProxy(ActivityProxy)
					local var1_210 = var0_210:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_210 and not var1_210:isEnd() then
						var1_210.data1 = var1_210.data1 - 1

						if not table.contains(var1_210.data1_list, arg0_189.id) then
							table.insert(var1_210.data1_list, arg0_189.id)
						end

						var0_210:updateActivity(var1_210)

						local var2_210 = arg0_189:getConfig("link_id")

						if var2_210 > 0 then
							local var3_210 = var0_210:getActivityById(var2_210)

							if var3_210 and not var3_210:isEnd() then
								var3_210.data1 = var3_210.data1 + 1

								var0_210:updateActivity(var3_210)
							end
						end
					end
				end,
				[26] = function()
					local var0_211 = getProxy(ActivityProxy)
					local var1_211 = Clone(var0_211:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_211 and not var1_211:isEnd() then
						var1_211.data1 = var1_211.data1 + arg0_189.count

						var0_211:updateActivity(var1_211)
					end
				end,
				[27] = function()
					local var0_212 = getProxy(ActivityProxy)
					local var1_212 = Clone(var0_212:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_212 and not var1_212:isEnd() then
						var1_212:AddExp(arg0_189.count)
						var0_212:updateActivity(var1_212)
					end
				end,
				[28] = function()
					local var0_213 = getProxy(ActivityProxy)
					local var1_213 = Clone(var0_213:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_213 and not var1_213:isEnd() then
						var1_213:AddGold(arg0_189.count)
						var0_213:updateActivity(var1_213)
					end
				end,
				[29] = function()
					local var0_214 = getProxy(ActivityProxy)
					local var1_214 = Clone(var0_214:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5))

					if var1_214 and not var1_214:isEnd() then
						var1_214.data1 = var1_214.data1 + arg0_189.count

						var0_214:updateActivity(var1_214)
					end
				end,
				[30] = function()
					local var0_215 = arg0_189:getConfig("link_id")
					local var1_215 = getProxy(ActivityProxy):getActivityById(var0_215)

					if not var1_215 or var1_215:isEnd() then
						return
					end

					local var2_215 = arg0_189.count

					if var1_215:IsLimitExpItem(arg0_189.id) then
						var2_215 = var1_215:FilterExp(var2_215)
						var2_215 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_215:GetTargetGroupId(), var2_215)

						var1_215:AddDailyProgress(var2_215)
					else
						local var3_215 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_215:GetTargetGroupId(), var2_215)
					end

					getProxy(ActivityProxy):updateActivity(var1_215)
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_218 = arg0_189:getConfig("link_id")
					local var1_218 = getProxy(ActivityProxy):getActivityById(var0_218)

					if var1_218 and not var1_218:isEnd() then
						var1_218.data1 = var1_218.data1 + arg0_189.count

						getProxy(ActivityProxy):updateActivity(var1_218)
					end
				end,
				[102] = function()
					local var0_219 = arg0_189:getConfig("link_id")
					local var1_219 = pg.activity_template[var0_219].type

					switch(var1_219, {
						[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = function()
							getProxy(CityRebuildProxy):AddPt(var0_219, arg0_189.count)
						end
					})
				end,
				[103] = function()
					local var0_221 = arg0_189:getConfig("link_id")
					local var1_221 = getProxy(ActivityProxy):getActivityById(var0_221)

					if not var1_221 or var1_221:isEnd() then
						return
					end

					switch(var1_221:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_TOWN2] = function()
							local var0_222 = getProxy(ActivityProxy)
							local var1_222 = Clone(var0_222:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN2))

							if arg0_189:getConfig("id") == pg.activity_town_2[var1_222.id].bubble_drop[1][2] then
								var1_222:AddGold(arg0_189.count)
								var1_222:AddAllGold(arg0_189.count)
							else
								var1_222:AddGold2(arg0_189.count)
							end

							var0_222:updateActivity(var1_222)
						end
					}, function()
						assert(var1_221 .. "对应" .. type .. "错误")
					end)
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_224)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_224.id, arg0_224.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_225)
			local var0_225 = getProxy(BayProxy)
			local var1_225 = var0_225:getShipById(arg0_225.count)

			if var1_225 then
				var1_225:unlockActivityNpc(0)
				var0_225:updateShip(var1_225)
				getProxy(CollectionProxy):flushCollection(var1_225)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_226)
			nowWorld():GetInventoryProxy():AddItem(arg0_226.id, arg0_226.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_227)
			local var0_227 = getProxy(AttireProxy)
			local var1_227 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_227 = IconFrame.New({
				id = arg0_227.id
			})
			local var3_227 = var1_227 + var2_227:getConfig("time_second")

			var2_227:updateData({
				isNew = true,
				end_time = var3_227
			})
			var0_227:addAttireFrame(var2_227)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_227)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_228)
			local var0_228 = getProxy(AttireProxy)
			local var1_228 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_228 = ChatFrame.New({
				id = arg0_228.id
			})
			local var3_228 = var1_228 + var2_228:getConfig("time_second")

			var2_228:updateData({
				isNew = true,
				end_time = var3_228
			})
			var0_228:addAttireFrame(var2_228)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_228)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_229)
			getProxy(EmojiProxy):addNewEmojiID(arg0_229.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_229:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_230)
			nowWorld():GetCollectionProxy():Unlock(arg0_230.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_231)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_231.id):addPT(arg0_231.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_232)
			local var0_232 = arg0_232.id
			local var1_232 = arg0_232.count
			local var2_232 = getProxy(ShipSkinProxy)
			local var3_232 = var2_232:getSkinById(var0_232)

			if var3_232 and var3_232:isExpireType() then
				local var4_232 = var1_232 + var3_232.endTime
				local var5_232 = ShipSkin.New({
					id = var0_232,
					end_time = var4_232
				})

				var2_232:addSkin(var5_232)
			elseif not var3_232 then
				local var6_232 = var1_232 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_232 = ShipSkin.New({
					id = var0_232,
					end_time = var6_232
				})

				var2_232:addSkin(var7_232)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_233)
			local var0_233 = arg0_233.id
			local var1_233 = pg.benefit_buff_template[var0_233]

			assert(var1_233 and var1_233.act_id > 0, "should exist act id")

			local var2_233 = getProxy(ActivityProxy):getActivityById(var1_233.act_id)

			if var2_233 and not var2_233:isEnd() then
				local var3_233 = var1_233.max_time
				local var4_233 = pg.TimeMgr.GetInstance():GetServerTime() + var3_233

				var2_233:AddBuff(ActivityBuff.New(var2_233.id, var0_233, var4_233))
				getProxy(ActivityProxy):updateActivity(var2_233)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_234)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_235)
			getProxy(ApartmentProxy):ModifyRoom(arg0_235:getConfig("room_id"), function(arg0_236)
				arg0_236:AddFurnitureByID(arg0_235.id)
			end)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_237)
			getProxy(ApartmentProxy):changeGiftCount(arg0_237.id, arg0_237.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_238)
			getProxy(ApartmentProxy):ModifyApartment(arg0_238:getConfig("ship_group"), function(arg0_239)
				arg0_239:addSkin(arg0_238.id)
			end)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_240)
			local var0_240 = getProxy(LivingAreaCoverProxy)
			local var1_240 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_240.id
			})

			var0_240:UpdateCover(var1_240)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_240)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_240.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_241)
			local var0_241 = getProxy(AttireProxy)
			local var1_241 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_241 = CombatUIStyle.New({
				id = arg0_241.id
			})

			var2_241:setUnlock()
			var2_241:setNew()
			var0_241:addAttireFrame(var2_241)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_241)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_242)
			local var0_242 = getProxy(IslandProxy):GetIsland()

			if not var0_242 then
				return
			end

			var0_242:GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_242.id,
				num = arg0_242.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_243)
		if arg0_243.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_243 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_243.type].activity_id)

			if arg0_243.type == DROP_TYPE_RYZA_DROP then
				if var0_243 and not var0_243:isEnd() then
					var0_243:AddItem(AtelierMaterial.New({
						configId = arg0_243.id,
						count = arg0_243.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_243)
				end
			elseif var0_243 and not var0_243:isEnd() then
				var0_243:addVitemNumber(arg0_243.id, arg0_243.count)
				getProxy(ActivityProxy):updateActivity(var0_243)
			end
		elseif arg0_243.type >= DROP_TYPE_ISLAND_ITEM and arg0_243.type <= DROP_TYPE_ISLAND_CARD_DIY then
			if not getProxy(IslandProxy):GetIsland() then
				return
			end

			local var1_243 = {}

			table.insert(var1_243, {
				type = arg0_243.type,
				id = arg0_243.id,
				number = arg0_243.count
			})
			IslandDropHelper.AddItems({
				drop_list = var1_243
			})
		else
			print("can not handle this type>>" .. arg0_243.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_244, arg1_244, arg2_244)
			setText(arg2_244, arg0_244:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_245, arg1_245, arg2_245)
			local var0_245 = arg0_245:getConfig("display")

			if arg0_245:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_245 = string.gsub(var0_245, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_245.extra))
			elseif arg0_245:getConfig("combination_display") ~= nil then
				local var1_245 = arg0_245:getConfig("combination_display")

				if var1_245 and #var1_245 > 0 then
					var0_245 = Item.StaticCombinationDisplay(var1_245)
				end
			end

			setText(arg2_245, SwitchSpecialChar(var0_245, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_246, arg1_246, arg2_246)
			setText(arg2_246, arg0_246:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_247, arg1_247, arg2_247)
			local var0_247 = arg0_247:getConfig("skin_id")
			local var1_247, var2_247, var3_247 = ShipWordHelper.GetWordAndCV(var0_247, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_247, var3_247 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_248, arg1_248, arg2_248)
			local var0_248 = arg0_248:getConfig("skin_id")
			local var1_248, var2_248, var3_248 = ShipWordHelper.GetWordAndCV(var0_248, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_248, var3_248 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_249, arg1_249, arg2_249)
			setText(arg2_249, arg1_249.name or arg0_249:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_250, arg1_250, arg2_250)
			local var0_250 = arg0_250:getConfig("desc")

			for iter0_250, iter1_250 in ipairs({
				arg0_250.count
			}) do
				var0_250 = string.gsub(var0_250, "$" .. iter0_250, iter1_250)
			end

			setText(arg2_250, var0_250)
		end,
		[DROP_TYPE_SKIN] = function(arg0_251, arg1_251, arg2_251)
			setText(arg2_251, arg0_251:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_252, arg1_252, arg2_252)
			setText(arg2_252, arg0_252:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_253, arg1_253, arg2_253)
			local var0_253 = arg0_253:getConfig("desc")
			local var1_253 = _.map(arg0_253:getConfig("equip_type"), function(arg0_254)
				return EquipType.Type2Name2(arg0_254)
			end)

			setText(arg2_253, var0_253 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_253, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_255, arg1_255, arg2_255)
			setText(arg2_255, arg0_255:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_256, arg1_256, arg2_256)
			setText(arg2_256, arg0_256:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_257, arg1_257, arg2_257, arg3_257)
			local var0_257 = WorldCollectionProxy.GetCollectionType(arg0_257.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_257, i18n("world_" .. var0_257 .. "_desc", arg0_257:getConfig("name")))
			setText(arg3_257, i18n("world_" .. var0_257 .. "_name", arg0_257:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_258, arg1_258, arg2_258)
			setText(arg2_258, arg0_258.desc and arg0_258.desc or arg0_258:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_259, arg1_259, arg2_259)
			setText(arg2_259, arg0_259:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_260, arg1_260, arg2_260)
			setText(arg2_260, arg0_260:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_261, arg1_261, arg2_261)
			local var0_261 = string.gsub(arg0_261:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_261.count))

			setText(arg2_261, SwitchSpecialChar(var0_261, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_262, arg1_262, arg2_262)
			setText(arg2_262, arg0_262:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_263, arg1_263, arg2_263)
			setText(arg2_263, arg0_263:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_264, arg1_264, arg2_264)
			setText(arg2_264, arg0_264:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_265, arg1_265, arg2_265)
			setText(arg2_265, arg0_265:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_266, arg1_266, arg2_266)
			setText(arg2_266, arg0_266:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_267, arg1_267, arg2_267)
			setText(arg2_267, arg0_267:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_268, arg1_268, arg2_268)
			setText(arg2_268, "")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_269, arg1_269, arg2_269)
			setText(arg2_269, arg0_269.desc)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_270, arg1_270, arg2_270)
			setText(arg2_270, arg0_270.desc)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_271, arg1_271, arg2_271)
			setText(arg2_271, arg0_271.desc)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_272, arg1_272, arg2_272)
			setText(arg2_272, arg0_272.desc)
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_273, arg1_273, arg2_273)
		if arg0_273.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_273, arg0_273:getConfig("display"))
		else
			setText(arg2_273, arg0_273.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_274, arg1_274, arg2_274)
			if arg0_274.id == PlayerConst.ResStoreGold or arg0_274.id == PlayerConst.ResStoreOil then
				arg2_274 = arg2_274 or {}
				arg2_274.frame = "frame_store"
			end

			updateItem(arg1_274, Item.New({
				id = id2ItemId(arg0_274.id)
			}), arg2_274)
		end,
		[DROP_TYPE_ITEM] = function(arg0_275, arg1_275, arg2_275)
			updateItem(arg1_275, arg0_275:getSubClass(), arg2_275)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_276, arg1_276, arg2_276)
			updateEquipment(arg1_276, arg0_276:getSubClass(), arg2_276)
		end,
		[DROP_TYPE_SHIP] = function(arg0_277, arg1_277, arg2_277)
			updateShip(arg1_277, arg0_277.ship, arg2_277)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_278, arg1_278, arg2_278)
			updateShip(arg1_278, arg0_278.ship, arg2_278)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_279, arg1_279, arg2_279)
			updateFurniture(arg1_279, arg0_279, arg2_279)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_280, arg1_280, arg2_280)
			arg2_280.isWorldBuff = arg0_280.isWorldBuff

			updateStrategy(arg1_280, arg0_280, arg2_280)
		end,
		[DROP_TYPE_SKIN] = function(arg0_281, arg1_281, arg2_281)
			arg2_281.isSkin = true
			arg2_281.isNew = arg0_281.isNew

			updateShip(arg1_281, Ship.New({
				configId = tonumber(arg0_281:getConfig("ship_group") .. "1"),
				skin_id = arg0_281.id
			}), arg2_281)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_282, arg1_282, arg2_282)
			local var0_282 = setmetatable({
				count = arg0_282.count
			}, {
				__index = arg0_282:getConfigTable()
			})

			updateEquipmentSkin(arg1_282, var0_282, arg2_282)
		end,
		[DROP_TYPE_VITEM] = function(arg0_283, arg1_283, arg2_283)
			updateItem(arg1_283, Item.New({
				id = arg0_283.id
			}), arg2_283)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_284, arg1_284, arg2_284)
			updateWorldItem(arg1_284, WorldItem.New({
				id = arg0_284.id
			}), arg2_284)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_285, arg1_285, arg2_285)
			updateWorldCollection(arg1_285, arg0_285, arg2_285)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_286, arg1_286, arg2_286)
			updateAttire(arg1_286, AttireConst.TYPE_CHAT_FRAME, arg0_286:getConfigTable(), arg2_286)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_287, arg1_287, arg2_287)
			updateAttire(arg1_287, AttireConst.TYPE_ICON_FRAME, arg0_287:getConfigTable(), arg2_287)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_288, arg1_288, arg2_288)
			updateEmoji(arg1_288, arg0_288:getConfigTable(), arg2_288)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_289, arg1_289, arg2_289)
			arg2_289.count = 1

			updateItem(arg1_289, arg0_289:getSubClass(), arg2_289)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_290, arg1_290, arg2_290)
			updateSpWeapon(arg1_290, SpWeapon.New({
				id = arg0_290.id
			}), arg2_290)
		end,
		[DROP_TYPE_META_PT] = function(arg0_291, arg1_291, arg2_291)
			updateItem(arg1_291, Item.New({
				id = arg0_291:getConfig("id")
			}), arg2_291)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_292, arg1_292, arg2_292)
			arg2_292.isSkin = true
			arg2_292.isTimeLimit = true
			arg2_292.count = 1

			updateShip(arg1_292, Ship.New({
				configId = tonumber(arg0_292:getConfig("ship_group") .. "1"),
				skin_id = arg0_292.id
			}), arg2_292)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_293, arg1_293, arg2_293)
			AtelierMaterial.UpdateRyzaItem(arg1_293, arg0_293.item, arg2_293)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_294, arg1_294, arg2_294)
			WorkBenchItem.UpdateDrop(arg1_294, arg0_294.item, arg2_294)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_295, arg1_295, arg2_295)
			WorkBenchItem.UpdateDrop(arg1_295, WorkBenchItem.New({
				configId = arg0_295.id,
				count = arg0_295.count
			}), arg2_295)
		end,
		[DROP_TYPE_BUFF] = function(arg0_296, arg1_296, arg2_296)
			updateBuff(arg1_296, arg0_296.id, arg2_296)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_297, arg1_297, arg2_297)
			updateCommander(arg1_297, arg0_297, arg2_297)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_298, arg1_298, arg2_298)
			updateCover(arg1_298, arg0_298, arg2_298)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_299, arg1_299, arg2_299)
			updateAttireCombatUI(arg1_299, AttireConst.TYPE_ICON_FRAME, arg0_299:getConfigTable(), arg2_299)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_300, arg1_300, arg2_300)
			updateActivityMedal(arg1_300, arg0_300:getConfigTable(), arg2_300)
		end
	}

	function var0_0.UpdateDropDefault(arg0_301, arg1_301, arg2_301)
		updateDefaultIconTpl(arg1_301, arg0_301, arg2_301)
	end

	var0_0.UpdateCustomDropCase = {
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_302, arg1_302, arg2_302)
			updateDorm3dIcon(arg1_302, arg0_302, arg2_302)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_303, arg1_303, arg2_303)
			updateDorm3dIcon(arg1_303, arg0_303, arg2_303)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_304, arg1_304, arg2_304)
			updateDorm3dIcon(arg1_304, arg0_304, arg2_304)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_305, arg1_305, arg2_305)
			updateIslandItem(arg1_305, arg0_305, arg2_305)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_306, arg1_306, arg2_306)
			updateIslandUnlock(arg1_306, arg0_306, arg2_306)
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_307, arg1_307, arg2_307)
			updateIslandInvitation(arg1_307, arg0_307, arg2_307)
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_308, arg1_308, arg2_308)
			updateIslandSeasonPt(arg1_308, arg0_308, arg2_308)
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_309, arg1_309, arg2_309)
			updateIslandWatherCollect(arg1_309, arg0_309, arg2_309)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_310, arg1_310, arg2_310)
			updateIslandFurniture(arg1_310, arg0_310, arg2_310)
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_311, arg1_311, arg2_311)
			updateIslandCardDiy(arg1_311, arg0_311, arg2_311)
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_312, arg1_312, arg2_312)
			updateIslandSpeedupTicket(arg1_312, arg0_312, arg2_312)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_313, arg1_313, arg2_313)
			updateItem(arg1_313, Item.New({
				id = arg0_313.id
			}), arg2_313)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_314, arg1_314, arg2_314)
			updateIslandSkin(arg1_314, arg0_314, arg2_314)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_315, arg1_315, arg2_315)
			updateIslandDress(arg1_315, arg0_315, arg2_315)
		end
	}

	function var0_0.UpdateCustomDropDefault(arg0_316, arg1_316, arg2_316)
		if arg2_316.style == "dorm" then
			updateDorm3dIcon(arg1_316, arg0_316, arg2_316)
		elseif arg2_316.style == "island" then
			updateIslandDefaultIconTpl(arg1_316, arg0_316, arg2_316)
		else
			warning(string.format("without dropType %d in updateCustomDrop", arg0_316.type))
		end
	end
end

return var0_0
