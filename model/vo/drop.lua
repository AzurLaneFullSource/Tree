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
			return getIslandSeasonPtInfo()
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
		end
	}

	function var0_0.CountDefault(arg0_131)
		local var0_131 = arg0_131.type

		if var0_131 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_131].activity_id):getVitemNumber(arg0_131.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_132)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_133)
			return Item.New(arg0_133)
		end,
		[DROP_TYPE_VITEM] = function(arg0_134)
			return Item.New(arg0_134)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_135)
			return Equipment.New(arg0_135)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_136)
			return Item.New({
				count = 1,
				id = arg0_136.id,
				extra = arg0_136.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_137)
			return WorldItem.New(arg0_137)
		end
	}

	function var0_0.SubClassDefault(arg0_138)
		assert(false, string.format("drop type %d without subClass", arg0_138.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_139)
			return arg0_139:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_140)
			return arg0_140:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_141)
			return arg0_141:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_142)
			return arg0_142:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_143)
			return arg0_143:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_144)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_145)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_146)
			return arg0_146:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_147)
			return arg0_147:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_148)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_149)
			return arg0_149:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_150)
			return arg0_150:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_151)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_152)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_153)
			return arg0_153:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_154)
			return arg0_154:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_155)
			return arg0_155:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_156)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_157)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_158)
			return arg0_158:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_159)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_160)
			return ItemRarity.Gold
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_161)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_162)
		return arg0_162:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_163)
		return arg0_163:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_164)
			local var0_164 = Drop.New({
				type = arg0_164:getConfig("type"),
				id = arg0_164:getConfig("resource_type"),
				count = arg0_164:getConfig("resource_num") * arg0_164.count
			})
			local var1_164 = Drop.New({
				type = arg0_164:getConfig("target_type"),
				id = arg0_164:getConfig("target_id"),
				count = arg0_164.count
			})

			PlayerConst.UpdateLinkActivity({
				var1_164
			})

			var0_164.name = string.format("%s(%s)", var0_164:getName(), var1_164:getName())

			return var0_164
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_165)
			for iter0_165, iter1_165 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_165.id].pt == arg0_165.id then
					return nil, arg0_165
				end
			end

			for iter2_165, iter3_165 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)) do
				if pg.black_friday_battlepass_event_pt[iter3_165.id].pt == arg0_165.id then
					return nil, arg0_165
				end
			end

			return arg0_165
		end,
		[DROP_TYPE_OPERATION] = function(arg0_166)
			if arg0_166.id ~= 3 then
				return nil
			end

			return arg0_166
		end,
		[DROP_TYPE_EMOJI] = function(arg0_167)
			return nil, arg0_167
		end,
		[DROP_TYPE_VITEM] = function(arg0_168, arg1_168, arg2_168)
			assert(arg0_168:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_168.id)

			return switch(arg0_168:getConfig("virtual_type"), {
				function()
					if arg0_168:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_168
					end

					return arg0_168
				end,
				[6] = function()
					local var0_170 = arg2_168.taskId
					local var1_170 = getProxy(ActivityProxy)
					local var2_170 = var1_170:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_170 then
						local var3_170 = var2_170.data1KeyValueList[1]

						var3_170[var0_170] = defaultValue(var3_170[var0_170], 0) + arg0_168.count

						var1_170:updateActivity(var2_170)
					end

					return nil, arg0_168
				end,
				[13] = function()
					local var0_171 = arg0_168:getName()
					local var1_171 = getProxy(ActivityProxy):getActivityById(arg0_168:getConfig("link_id"))

					if not var1_171 or var1_171:isEnd() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_171))

						return nil
					elseif var1_171:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_171))

						return nil
					else
						return arg0_168, nil
					end
				end,
				[17] = function()
					local var0_172 = getProxy(ActivityProxy):getActivityById(arg0_168:getConfig("link_id"))

					if var0_172.data1 < 1 then
						return Drop.New({
							count = 1,
							type = DROP_TYPE_SHIP,
							id = var0_172:getConfig("config_id")
						}), arg0_168
					else
						return Drop.New({
							id = 3,
							type = DROP_TYPE_OPERATION,
							count = var0_172.data2
						}), arg0_168
					end
				end,
				[21] = function()
					return nil, arg0_168
				end,
				[28] = function()
					local var0_174 = Drop.New({
						type = arg0_168.type,
						id = arg0_168.id,
						count = math.floor(arg0_168.count / 1000)
					})
					local var1_174 = Drop.New({
						type = arg0_168.type,
						id = arg0_168.id,
						count = arg0_168.count - math.floor(arg0_168.count / 1000)
					})

					return var0_174, var1_174
				end
			}, function()
				return arg0_168
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_176, arg1_176)
			if Ship.isMetaShipByConfigID(arg0_176.id) and Player.isMetaShipNeedToTrans(arg0_176.id) then
				local var0_176 = table.indexof(arg1_176, arg0_176.id, 1)

				if var0_176 then
					table.remove(arg1_176, var0_176)
				else
					local var1_176 = Player.metaShip2Res(arg0_176.id)
					local var2_176 = Drop.New(var1_176[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_176.id, var2_176)

					return arg0_176, var2_176
				end
			end

			return arg0_176
		end,
		[DROP_TYPE_SKIN] = function(arg0_177)
			arg0_177.isNew = not getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_177.id)

			return arg0_177
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_178)
			local var0_178 = getProxy(PlayerProxy):getRawData()
			local var1_178 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_178:updateMedalList({
				{
					key = arg0_178.id,
					value = var1_178
				}
			})

			return arg0_178
		end,
		[DROP_TYPE_BUFF] = function(arg0_179)
			return nil, arg0_179
		end
	}

	function var0_0.TransDefault(arg0_180)
		return arg0_180
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_181)
			local var0_181 = id2res(arg0_181.id)

			assert(var0_181, "res should be defined: " .. arg0_181.id)

			local var1_181 = getProxy(PlayerProxy)
			local var2_181 = var1_181:getData()

			var2_181:addResources({
				[var0_181] = arg0_181.count
			})
			var1_181:updatePlayer(var2_181)
		end,
		[DROP_TYPE_ITEM] = function(arg0_182)
			if arg0_182:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_182 = getProxy(BagProxy):getItemCountById(arg0_182.id)
				local var1_182 = math.min(arg0_182:getConfig("max_num") - var0_182, arg0_182.count)

				if var1_182 > 0 then
					getProxy(BagProxy):addItemById(arg0_182.id, var1_182)
				end
			else
				getProxy(BagProxy):addItemById(arg0_182.id, arg0_182.count, arg0_182.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_183)
			local var0_183 = arg0_183:getSubClass()

			getProxy(BagProxy):addItemById(var0_183.id, var0_183.count, var0_183.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_184)
			getProxy(EquipmentProxy):addEquipmentById(arg0_184.id, arg0_184.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_185)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_186)
			local var0_186 = getProxy(DormProxy)
			local var1_186 = Furniture.New({
				id = arg0_186.id,
				count = arg0_186.count
			})

			if var1_186:isRecordTime() then
				var1_186.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_186:AddFurniture(var1_186)
		end,
		[DROP_TYPE_SKIN] = function(arg0_187)
			local var0_187 = getProxy(ShipSkinProxy)
			local var1_187 = ShipSkin.New({
				id = arg0_187.id
			})

			var0_187:addSkin(var1_187)
		end,
		[DROP_TYPE_VITEM] = function(arg0_188)
			arg0_188 = arg0_188:getSubClass()

			assert(arg0_188:isVirtualItem(), "item type error(virtual item)>>" .. arg0_188.id)
			switch(arg0_188:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_188.id, arg0_188.count)
				end,
				function()
					local var0_190 = getProxy(ActivityProxy)
					local var1_190 = arg0_188:getConfig("link_id")
					local var2_190

					if var1_190 > 0 then
						var2_190 = var0_190:getActivityById(var1_190)
					else
						var2_190 = var0_190:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_190 and not var2_190:isEnd() then
						if not table.contains(var2_190.data1_list, arg0_188.id) then
							table.insert(var2_190.data1_list, arg0_188.id)
						end

						var0_190:updateActivity(var2_190)
					end
				end,
				function()
					local var0_191 = getProxy(ActivityProxy)
					local var1_191 = var0_191:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_191, iter1_191 in ipairs(var1_191) do
						iter1_191.data1 = iter1_191.data1 + arg0_188.count

						local var2_191 = iter1_191:getConfig("config_id")
						local var3_191 = pg.activity_vote[var2_191]

						if var3_191 and var3_191.ticket_id_period == arg0_188.id then
							iter1_191.data3 = iter1_191.data3 + arg0_188.count
						end

						var0_191:updateActivity(iter1_191)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_188.id,
							ptCount = arg0_188.count
						})
					end
				end,
				[4] = function()
					local var0_192 = getProxy(ColoringProxy):getColorItems()

					var0_192[arg0_188.id] = (var0_192[arg0_188.id] or 0) + arg0_188.count
				end,
				[6] = function()
					local var0_193 = getProxy(ActivityProxy)
					local var1_193 = var0_193:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_193 then
						var1_193.data3 = var1_193.data3 + arg0_188.count

						var0_193:updateActivity(var1_193)
					end
				end,
				[7] = function()
					local var0_194 = getProxy(ChapterProxy)

					var0_194:updateRemasterTicketsNum(math.min(var0_194.remasterTickets + arg0_188.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_195 = getProxy(ActivityProxy)
					local var1_195 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_195 then
						var1_195.data1_list[1] = var1_195.data1_list[1] + arg0_188.count

						var0_195:updateActivity(var1_195)
					end
				end,
				[11] = function()
					local var0_196 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_196 and not var0_196:isEnd() then
						var0_196.data1 = var0_196.data1 + arg0_188.count
					end
				end,
				[12] = function()
					local var0_197 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_197 and not var0_197:isEnd() then
						var0_197.data1KeyValueList[1][arg0_188.id] = (var0_197.data1KeyValueList[1][arg0_188.id] or 0) + arg0_188.count
					end
				end,
				[13] = function()
					local var0_198 = getProxy(ActivityProxy):getActivityById(arg0_188:getConfig("link_id"))

					if var0_198:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

						return
					end

					var0_198.data1 = var0_198.data1 + arg0_188.count

					getProxy(ActivityProxy):updateActivity(var0_198)
				end,
				[14] = function()
					local var0_199 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_188.id then
						var0_199:AddSummonPt(arg0_188.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_188.id then
						var0_199:AddSummonPtOld(arg0_188.count)
					end
				end,
				[15] = function()
					local var0_200 = getProxy(ActivityProxy)
					local var1_200 = var0_200:getActivityById(arg0_188:getConfig("link_id"))

					if not var1_200 or var1_200:isEnd() then
						return
					end

					if var1_200:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_200 = pg.activity_event_grid[var1_200.data1]

						if arg0_188.id == var2_200.ticket_item then
							var1_200.data2 = var1_200.data2 + arg0_188.count
						elseif arg0_188.id == var2_200.explore_item then
							var1_200.data3 = var1_200.data3 + arg0_188.count
						end
					elseif var1_200:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_200.data3 = var1_200.data3 + arg0_188.count
					end

					var0_200:updateActivity(var1_200)
				end,
				[16] = function()
					local var0_201 = getProxy(ActivityProxy)
					local var1_201 = var0_201:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_201, iter1_201 in pairs(var1_201) do
						if iter1_201 and not iter1_201:isEnd() and arg0_188.id == iter1_201:getConfig("config_id") then
							iter1_201.data1 = iter1_201.data1 + arg0_188.count

							var0_201:updateActivity(iter1_201)
						end
					end
				end,
				[17] = function()
					local var0_202 = getProxy(ActivityProxy)
					local var1_202 = var0_202:getActivityById(arg0_188:getConfig("link_id"))

					if not var1_202 or var1_202:isEnd() then
						return
					end

					var1_202.data1 = 2

					var0_202:updateActivity(var1_202)
				end,
				[20] = function()
					local var0_203 = getProxy(BagProxy)
					local var1_203 = pg.gameset.urpt_chapter_max.description
					local var2_203 = var1_203[1]
					local var3_203 = var1_203[2]
					local var4_203 = var0_203:GetLimitCntById(var2_203)
					local var5_203 = math.min(var3_203 - var4_203, arg0_188.count)

					if var5_203 > 0 then
						var0_203:addItemById(var2_203, var5_203)
						var0_203:AddLimitCnt(var2_203, var5_203)
					end
				end,
				[21] = function()
					local var0_204 = getProxy(ActivityProxy)
					local var1_204 = var0_204:getActivityById(arg0_188:getConfig("link_id"))

					if var1_204 and not var1_204:isEnd() then
						var1_204.data2 = 1

						var0_204:updateActivity(var1_204)
					end
				end,
				[22] = function()
					local var0_205 = getProxy(ActivityProxy)
					local var1_205 = var0_205:getActivityById(arg0_188:getConfig("link_id"))

					if var1_205 and not var1_205:isEnd() then
						var1_205.data1 = var1_205.data1 + arg0_188.count

						var0_205:updateActivity(var1_205)
					end
				end,
				[23] = function()
					local var0_206 = (function()
						for iter0_207, iter1_207 in ipairs(pg.gameset.package_lv.description) do
							if arg0_188.id == iter1_207[1] then
								return iter1_207[2]
							end
						end
					end)()

					assert(var0_206)

					local var1_206 = getProxy(PlayerProxy)
					local var2_206 = var1_206:getData()

					var2_206:addExpToLevel(var0_206)
					var1_206:updatePlayer(var2_206)
				end,
				[24] = function()
					local var0_208 = arg0_188:getConfig("link_id")
					local var1_208 = getProxy(ActivityProxy):getActivityById(var0_208)

					if var1_208 and not var1_208:isEnd() and var1_208:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_208.data2 = var1_208.data2 + arg0_188.count

						getProxy(ActivityProxy):updateActivity(var1_208)
					end
				end,
				[25] = function()
					local var0_209 = getProxy(ActivityProxy)
					local var1_209 = var0_209:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_209 and not var1_209:isEnd() then
						var1_209.data1 = var1_209.data1 - 1

						if not table.contains(var1_209.data1_list, arg0_188.id) then
							table.insert(var1_209.data1_list, arg0_188.id)
						end

						var0_209:updateActivity(var1_209)

						local var2_209 = arg0_188:getConfig("link_id")

						if var2_209 > 0 then
							local var3_209 = var0_209:getActivityById(var2_209)

							if var3_209 and not var3_209:isEnd() then
								var3_209.data1 = var3_209.data1 + 1

								var0_209:updateActivity(var3_209)
							end
						end
					end
				end,
				[26] = function()
					local var0_210 = getProxy(ActivityProxy)
					local var1_210 = Clone(var0_210:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_210 and not var1_210:isEnd() then
						var1_210.data1 = var1_210.data1 + arg0_188.count

						var0_210:updateActivity(var1_210)
					end
				end,
				[27] = function()
					local var0_211 = getProxy(ActivityProxy)
					local var1_211 = Clone(var0_211:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_211 and not var1_211:isEnd() then
						var1_211:AddExp(arg0_188.count)
						var0_211:updateActivity(var1_211)
					end
				end,
				[28] = function()
					local var0_212 = getProxy(ActivityProxy)
					local var1_212 = Clone(var0_212:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_212 and not var1_212:isEnd() then
						var1_212:AddGold(arg0_188.count)
						var0_212:updateActivity(var1_212)
					end
				end,
				[29] = function()
					local var0_213 = getProxy(ActivityProxy)
					local var1_213 = Clone(var0_213:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5))

					if var1_213 and not var1_213:isEnd() then
						var1_213.data1 = var1_213.data1 + arg0_188.count

						var0_213:updateActivity(var1_213)
					end
				end,
				[30] = function()
					local var0_214 = arg0_188:getConfig("link_id")
					local var1_214 = getProxy(ActivityProxy):getActivityById(var0_214)

					if not var1_214 or var1_214:isEnd() then
						return
					end

					local var2_214 = arg0_188.count

					if var1_214:IsLimitExpItem(arg0_188.id) then
						var2_214 = var1_214:FilterExp(var2_214)
						var2_214 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_214:GetTargetGroupId(), var2_214)

						var1_214:AddDailyProgress(var2_214)
					else
						local var3_214 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_214:GetTargetGroupId(), var2_214)
					end

					getProxy(ActivityProxy):updateActivity(var1_214)
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_217 = arg0_188:getConfig("link_id")
					local var1_217 = getProxy(ActivityProxy):getActivityById(var0_217)

					if var1_217 and not var1_217:isEnd() then
						var1_217.data1 = var1_217.data1 + arg0_188.count

						getProxy(ActivityProxy):updateActivity(var1_217)
					end
				end,
				[102] = function()
					local var0_218 = arg0_188:getConfig("link_id")
					local var1_218 = pg.activity_template[var0_218].type

					switch(var1_218, {
						[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = function()
							getProxy(CityRebuildProxy):AddPt(var0_218, arg0_188.count)
						end
					})
				end,
				[103] = function()
					local var0_220 = arg0_188:getConfig("link_id")
					local var1_220 = getProxy(ActivityProxy):getActivityById(var0_220)

					if not var1_220 or var1_220:isEnd() then
						return
					end

					switch(var1_220:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_TOWN2] = function()
							local var0_221 = getProxy(ActivityProxy)
							local var1_221 = Clone(var0_221:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN2))

							if arg0_188:getConfig("id") == pg.activity_town_2[var1_221.id].bubble_drop[1][2] then
								var1_221:AddGold(arg0_188.count)
								var1_221:AddAllGold(arg0_188.count)
							else
								var1_221:AddGold2(arg0_188.count)
							end

							var0_221:updateActivity(var1_221)
						end
					}, function()
						assert(var1_220 .. "对应" .. type .. "错误")
					end)
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_223)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_223.id, arg0_223.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_224)
			local var0_224 = getProxy(BayProxy)
			local var1_224 = var0_224:getShipById(arg0_224.count)

			if var1_224 then
				var1_224:unlockActivityNpc(0)
				var0_224:updateShip(var1_224)
				getProxy(CollectionProxy):flushCollection(var1_224)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_225)
			nowWorld():GetInventoryProxy():AddItem(arg0_225.id, arg0_225.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_226)
			local var0_226 = getProxy(AttireProxy)
			local var1_226 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_226 = IconFrame.New({
				id = arg0_226.id
			})
			local var3_226 = var1_226 + var2_226:getConfig("time_second")

			var2_226:updateData({
				isNew = true,
				end_time = var3_226
			})
			var0_226:addAttireFrame(var2_226)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_226)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_227)
			local var0_227 = getProxy(AttireProxy)
			local var1_227 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_227 = ChatFrame.New({
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
		[DROP_TYPE_EMOJI] = function(arg0_228)
			getProxy(EmojiProxy):addNewEmojiID(arg0_228.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_228:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_229)
			nowWorld():GetCollectionProxy():Unlock(arg0_229.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_230)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_230.id):addPT(arg0_230.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_231)
			local var0_231 = arg0_231.id
			local var1_231 = arg0_231.count
			local var2_231 = getProxy(ShipSkinProxy)
			local var3_231 = var2_231:getSkinById(var0_231)

			if var3_231 and var3_231:isExpireType() then
				local var4_231 = var1_231 + var3_231.endTime
				local var5_231 = ShipSkin.New({
					id = var0_231,
					end_time = var4_231
				})

				var2_231:addSkin(var5_231)
			elseif not var3_231 then
				local var6_231 = var1_231 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_231 = ShipSkin.New({
					id = var0_231,
					end_time = var6_231
				})

				var2_231:addSkin(var7_231)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_232)
			local var0_232 = arg0_232.id
			local var1_232 = pg.benefit_buff_template[var0_232]

			assert(var1_232 and var1_232.act_id > 0, "should exist act id")

			local var2_232 = getProxy(ActivityProxy):getActivityById(var1_232.act_id)

			if var2_232 and not var2_232:isEnd() then
				local var3_232 = var1_232.max_time
				local var4_232 = pg.TimeMgr.GetInstance():GetServerTime() + var3_232

				var2_232:AddBuff(ActivityBuff.New(var2_232.id, var0_232, var4_232))
				getProxy(ActivityProxy):updateActivity(var2_232)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_233)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_234)
			getProxy(ApartmentProxy):ModifyRoom(arg0_234:getConfig("room_id"), function(arg0_235)
				arg0_235:AddFurnitureByID(arg0_234.id)
			end)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_236)
			getProxy(ApartmentProxy):changeGiftCount(arg0_236.id, arg0_236.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_237)
			getProxy(ApartmentProxy):ModifyApartment(arg0_237:getConfig("ship_group"), function(arg0_238)
				arg0_238:addSkin(arg0_237.id)
			end)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_239)
			local var0_239 = getProxy(LivingAreaCoverProxy)
			local var1_239 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_239.id
			})

			var0_239:UpdateCover(var1_239)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_239)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_239.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_240)
			local var0_240 = getProxy(AttireProxy)
			local var1_240 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_240 = CombatUIStyle.New({
				id = arg0_240.id
			})

			var2_240:setUnlock()
			var2_240:setNew()
			var0_240:addAttireFrame(var2_240)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_240)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_241)
			local var0_241 = getProxy(IslandProxy):GetIsland()

			if not var0_241 then
				return
			end

			var0_241:GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_241.id,
				num = arg0_241.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_242)
		if arg0_242.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_242 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_242.type].activity_id)

			if arg0_242.type == DROP_TYPE_RYZA_DROP then
				if var0_242 and not var0_242:isEnd() then
					var0_242:AddItem(AtelierMaterial.New({
						configId = arg0_242.id,
						count = arg0_242.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_242)
				end
			elseif var0_242 and not var0_242:isEnd() then
				var0_242:addVitemNumber(arg0_242.id, arg0_242.count)
				getProxy(ActivityProxy):updateActivity(var0_242)
			end
		elseif arg0_242.type >= DROP_TYPE_ISLAND_ITEM and arg0_242.type <= DROP_TYPE_ISLAND_CARD_DIY then
			if not getProxy(IslandProxy):GetIsland() then
				return
			end

			local var1_242 = {}

			table.insert(var1_242, {
				type = arg0_242.type,
				id = arg0_242.id,
				number = arg0_242.count
			})
			IslandDropHelper.AddItems({
				drop_list = var1_242
			})
		else
			print("can not handle this type>>" .. arg0_242.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_243, arg1_243, arg2_243)
			setText(arg2_243, arg0_243:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_244, arg1_244, arg2_244)
			local var0_244 = arg0_244:getConfig("display")

			if arg0_244:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_244 = string.gsub(var0_244, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_244.extra))
			elseif arg0_244:getConfig("combination_display") ~= nil then
				local var1_244 = arg0_244:getConfig("combination_display")

				if var1_244 and #var1_244 > 0 then
					var0_244 = Item.StaticCombinationDisplay(var1_244)
				end
			end

			setText(arg2_244, SwitchSpecialChar(var0_244, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_245, arg1_245, arg2_245)
			setText(arg2_245, arg0_245:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_246, arg1_246, arg2_246)
			local var0_246 = arg0_246:getConfig("skin_id")
			local var1_246, var2_246, var3_246 = ShipWordHelper.GetWordAndCV(var0_246, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_246, var3_246 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_247, arg1_247, arg2_247)
			local var0_247 = arg0_247:getConfig("skin_id")
			local var1_247, var2_247, var3_247 = ShipWordHelper.GetWordAndCV(var0_247, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_247, var3_247 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_248, arg1_248, arg2_248)
			setText(arg2_248, arg1_248.name or arg0_248:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_249, arg1_249, arg2_249)
			local var0_249 = arg0_249:getConfig("desc")

			for iter0_249, iter1_249 in ipairs({
				arg0_249.count
			}) do
				var0_249 = string.gsub(var0_249, "$" .. iter0_249, iter1_249)
			end

			setText(arg2_249, var0_249)
		end,
		[DROP_TYPE_SKIN] = function(arg0_250, arg1_250, arg2_250)
			setText(arg2_250, arg0_250:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_251, arg1_251, arg2_251)
			setText(arg2_251, arg0_251:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_252, arg1_252, arg2_252)
			local var0_252 = arg0_252:getConfig("desc")
			local var1_252 = _.map(arg0_252:getConfig("equip_type"), function(arg0_253)
				return EquipType.Type2Name2(arg0_253)
			end)

			setText(arg2_252, var0_252 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_252, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_254, arg1_254, arg2_254)
			setText(arg2_254, arg0_254:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_255, arg1_255, arg2_255)
			setText(arg2_255, arg0_255:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_256, arg1_256, arg2_256, arg3_256)
			local var0_256 = WorldCollectionProxy.GetCollectionType(arg0_256.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_256, i18n("world_" .. var0_256 .. "_desc", arg0_256:getConfig("name")))
			setText(arg3_256, i18n("world_" .. var0_256 .. "_name", arg0_256:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_257, arg1_257, arg2_257)
			setText(arg2_257, arg0_257.desc and arg0_257.desc or arg0_257:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_258, arg1_258, arg2_258)
			setText(arg2_258, arg0_258:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_259, arg1_259, arg2_259)
			setText(arg2_259, arg0_259:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_260, arg1_260, arg2_260)
			local var0_260 = string.gsub(arg0_260:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_260.count))

			setText(arg2_260, SwitchSpecialChar(var0_260, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_261, arg1_261, arg2_261)
			setText(arg2_261, arg0_261:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_262, arg1_262, arg2_262)
			setText(arg2_262, arg0_262:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_263, arg1_263, arg2_263)
			setText(arg2_263, arg0_263:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_264, arg1_264, arg2_264)
			setText(arg2_264, arg0_264:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_265, arg1_265, arg2_265)
			setText(arg2_265, arg0_265:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_266, arg1_266, arg2_266)
			setText(arg2_266, arg0_266:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_267, arg1_267, arg2_267)
			setText(arg2_267, "")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_268, arg1_268, arg2_268)
			setText(arg2_268, arg0_268.desc)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_269, arg1_269, arg2_269)
			setText(arg2_269, arg0_269.desc)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_270, arg1_270, arg2_270)
			setText(arg2_270, arg0_270.desc)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_271, arg1_271, arg2_271)
			setText(arg2_271, arg0_271.desc)
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_272, arg1_272, arg2_272)
		if arg0_272.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_272, arg0_272:getConfig("display"))
		else
			setText(arg2_272, arg0_272.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_273, arg1_273, arg2_273)
			if arg0_273.id == PlayerConst.ResStoreGold or arg0_273.id == PlayerConst.ResStoreOil then
				arg2_273 = arg2_273 or {}
				arg2_273.frame = "frame_store"
			end

			updateItem(arg1_273, Item.New({
				id = id2ItemId(arg0_273.id)
			}), arg2_273)
		end,
		[DROP_TYPE_ITEM] = function(arg0_274, arg1_274, arg2_274)
			updateItem(arg1_274, arg0_274:getSubClass(), arg2_274)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_275, arg1_275, arg2_275)
			updateEquipment(arg1_275, arg0_275:getSubClass(), arg2_275)
		end,
		[DROP_TYPE_SHIP] = function(arg0_276, arg1_276, arg2_276)
			updateShip(arg1_276, arg0_276.ship, arg2_276)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_277, arg1_277, arg2_277)
			updateShip(arg1_277, arg0_277.ship, arg2_277)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_278, arg1_278, arg2_278)
			updateFurniture(arg1_278, arg0_278, arg2_278)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_279, arg1_279, arg2_279)
			arg2_279.isWorldBuff = arg0_279.isWorldBuff

			updateStrategy(arg1_279, arg0_279, arg2_279)
		end,
		[DROP_TYPE_SKIN] = function(arg0_280, arg1_280, arg2_280)
			arg2_280.isSkin = true
			arg2_280.isNew = arg0_280.isNew

			updateShip(arg1_280, Ship.New({
				configId = tonumber(arg0_280:getConfig("ship_group") .. "1"),
				skin_id = arg0_280.id
			}), arg2_280)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_281, arg1_281, arg2_281)
			local var0_281 = setmetatable({
				count = arg0_281.count
			}, {
				__index = arg0_281:getConfigTable()
			})

			updateEquipmentSkin(arg1_281, var0_281, arg2_281)
		end,
		[DROP_TYPE_VITEM] = function(arg0_282, arg1_282, arg2_282)
			updateItem(arg1_282, Item.New({
				id = arg0_282.id
			}), arg2_282)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_283, arg1_283, arg2_283)
			updateWorldItem(arg1_283, WorldItem.New({
				id = arg0_283.id
			}), arg2_283)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_284, arg1_284, arg2_284)
			updateWorldCollection(arg1_284, arg0_284, arg2_284)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_285, arg1_285, arg2_285)
			updateAttire(arg1_285, AttireConst.TYPE_CHAT_FRAME, arg0_285:getConfigTable(), arg2_285)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_286, arg1_286, arg2_286)
			updateAttire(arg1_286, AttireConst.TYPE_ICON_FRAME, arg0_286:getConfigTable(), arg2_286)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_287, arg1_287, arg2_287)
			updateEmoji(arg1_287, arg0_287:getConfigTable(), arg2_287)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_288, arg1_288, arg2_288)
			arg2_288.count = 1

			updateItem(arg1_288, arg0_288:getSubClass(), arg2_288)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_289, arg1_289, arg2_289)
			updateSpWeapon(arg1_289, SpWeapon.New({
				id = arg0_289.id
			}), arg2_289)
		end,
		[DROP_TYPE_META_PT] = function(arg0_290, arg1_290, arg2_290)
			updateItem(arg1_290, Item.New({
				id = arg0_290:getConfig("id")
			}), arg2_290)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_291, arg1_291, arg2_291)
			arg2_291.isSkin = true
			arg2_291.isTimeLimit = true
			arg2_291.count = 1

			updateShip(arg1_291, Ship.New({
				configId = tonumber(arg0_291:getConfig("ship_group") .. "1"),
				skin_id = arg0_291.id
			}), arg2_291)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_292, arg1_292, arg2_292)
			AtelierMaterial.UpdateRyzaItem(arg1_292, arg0_292.item, arg2_292)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_293, arg1_293, arg2_293)
			WorkBenchItem.UpdateDrop(arg1_293, arg0_293.item, arg2_293)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_294, arg1_294, arg2_294)
			WorkBenchItem.UpdateDrop(arg1_294, WorkBenchItem.New({
				configId = arg0_294.id,
				count = arg0_294.count
			}), arg2_294)
		end,
		[DROP_TYPE_BUFF] = function(arg0_295, arg1_295, arg2_295)
			updateBuff(arg1_295, arg0_295.id, arg2_295)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_296, arg1_296, arg2_296)
			updateCommander(arg1_296, arg0_296, arg2_296)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_297, arg1_297, arg2_297)
			updateCover(arg1_297, arg0_297, arg2_297)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_298, arg1_298, arg2_298)
			updateAttireCombatUI(arg1_298, AttireConst.TYPE_ICON_FRAME, arg0_298:getConfigTable(), arg2_298)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_299, arg1_299, arg2_299)
			updateActivityMedal(arg1_299, arg0_299:getConfigTable(), arg2_299)
		end
	}

	function var0_0.UpdateDropDefault(arg0_300, arg1_300, arg2_300)
		updateDefaultIconTpl(arg1_300, arg0_300, arg2_300)
	end

	var0_0.UpdateCustomDropCase = {
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_301, arg1_301, arg2_301)
			updateDorm3dIcon(arg1_301, arg0_301, arg2_301)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_302, arg1_302, arg2_302)
			updateDorm3dIcon(arg1_302, arg0_302, arg2_302)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_303, arg1_303, arg2_303)
			updateDorm3dIcon(arg1_303, arg0_303, arg2_303)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_304, arg1_304, arg2_304)
			updateIslandItem(arg1_304, arg0_304, arg2_304)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_305, arg1_305, arg2_305)
			updateIslandUnlock(arg1_305, arg0_305, arg2_305)
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_306, arg1_306, arg2_306)
			updateIslandInvitation(arg1_306, arg0_306, arg2_306)
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_307, arg1_307, arg2_307)
			updateIslandSeasonPt(arg1_307, arg0_307, arg2_307)
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_308, arg1_308, arg2_308)
			updateIslandWatherCollect(arg1_308, arg0_308, arg2_308)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_309, arg1_309, arg2_309)
			updateIslandFurniture(arg1_309, arg0_309, arg2_309)
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_310, arg1_310, arg2_310)
			updateIslandCardDiy(arg1_310, arg0_310, arg2_310)
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_311, arg1_311, arg2_311)
			updateIslandSpeedupTicket(arg1_311, arg0_311, arg2_311)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_312, arg1_312, arg2_312)
			updateItem(arg1_312, Item.New({
				id = arg0_312.id
			}), arg2_312)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_313, arg1_313, arg2_313)
			updateIslandSkin(arg1_313, arg0_313, arg2_313)
		end
	}

	function var0_0.UpdateCustomDropDefault(arg0_314, arg1_314, arg2_314)
		if arg2_314.style == "dorm" then
			updateDorm3dIcon(arg1_314, arg0_314, arg2_314)
		elseif arg2_314.style == "island" then
			updateIslandDefaultIconTpl(arg1_314, arg0_314, arg2_314)
		else
			warning(string.format("without dropType %d in updateCustomDrop", arg0_314.type))
		end
	end
end

return var0_0
