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

function var0_0.getOwnedLimit(arg0_52)
	return switch(arg0_52.type, var0_0.LimitCase, var0_0.LimitDefault, arg0_52)
end

function var0_0.getSubClass(arg0_53)
	return switch(arg0_53.type, var0_0.SubClassCase, var0_0.SubClassDefault, arg0_53)
end

function var0_0.getDropRarity(arg0_54)
	return switch(arg0_54.type, var0_0.RarityCase, var0_0.RarityDefault, arg0_54)
end

function var0_0.getDropRarityDorm(arg0_55)
	return switch(arg0_55.type, var0_0.RarityCase, var0_0.RarityDefaultDorm, arg0_55)
end

function var0_0.DropTrans(arg0_56, ...)
	return switch(arg0_56.type, var0_0.TransCase, var0_0.TransDefault, arg0_56, ...)
end

function var0_0.AddItemOperation(arg0_57)
	return switch(arg0_57.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_57)
end

function var0_0.MsgboxIntroSet(arg0_58, ...)
	return switch(arg0_58.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_58, ...)
end

function var0_0.UpdateDropTpl(arg0_59, ...)
	return switch(arg0_59.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_59, ...)
end

function var0_0.UpdateCustomDropTpl(arg0_60, ...)
	return switch(arg0_60.type, var0_0.UpdateCustomDropCase, var0_0.UpdateCustomDropDefault, arg0_60, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_62)
			local var0_62 = Item.getConfigData(id2ItemId(arg0_62.id))

			arg0_62.desc = var0_62.display

			return var0_62
		end,
		[DROP_TYPE_ITEM] = function(arg0_63)
			warning(arg0_63.id)

			local var0_63 = Item.getConfigData(arg0_63.id)

			arg0_63.desc = var0_63.display

			if var0_63.type == Item.LOVE_LETTER_TYPE then
				arg0_63.desc = string.gsub(arg0_63.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_63.extra))
			end

			return var0_63
		end,
		[DROP_TYPE_VITEM] = function(arg0_64)
			local var0_64 = Item.getConfigData(arg0_64.id)

			assert(var0_64, arg0_64.id)

			arg0_64.desc = var0_64.display

			return var0_64
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_65)
			local var0_65 = Item.getConfigData(arg0_65.id)

			arg0_65.desc = string.gsub(var0_65.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_65.count))

			return var0_65
		end,
		[DROP_TYPE_EQUIP] = function(arg0_66)
			local var0_66 = Equipment.getConfigData(arg0_66.id)

			arg0_66.desc = var0_66.descrip

			return var0_66
		end,
		[DROP_TYPE_SHIP] = function(arg0_67)
			local var0_67 = pg.ship_data_statistics[arg0_67.id]
			local var1_67, var2_67, var3_67 = ShipWordHelper.GetWordAndCV(var0_67.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_67.desc = var3_67 or i18n("ship_drop_desc_default")
			arg0_67.ship = Ship.New({
				configId = arg0_67.id,
				skin_id = arg0_67.skinId,
				propose = arg0_67.propose
			})
			arg0_67.ship.remoulded = arg0_67.remoulded
			arg0_67.ship.virgin = arg0_67.virgin

			return var0_67
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_68)
			local var0_68 = pg.furniture_data_template[arg0_68.id]

			arg0_68.desc = var0_68.describe

			return var0_68
		end,
		[DROP_TYPE_SKIN] = function(arg0_69)
			local var0_69 = pg.ship_skin_template[arg0_69.id]

			if var0_69.skin_type == ShipSkin.SKIN_TYPE_TB then
				local var1_69, var2_69, var3_69 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_69.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_69.desc = var3_69
			else
				local var4_69, var5_69, var6_69 = ShipWordHelper.GetWordAndCV(arg0_69.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_69.desc = var6_69
			end

			return var0_69
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_70)
			local var0_70 = pg.ship_skin_template[arg0_70.id]

			if var0_70.skin_type == ShipSKin.SKIN_TYPE_TB then
				local var1_70, var2_70, var3_70 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_70.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_70.desc = var3_70
			else
				local var4_70, var5_70, var6_70 = ShipWordHelper.GetWordAndCV(arg0_70.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_70.desc = var6_70
			end

			return var0_70
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_71)
			warning(arg0_71.id)

			local var0_71 = pg.equip_skin_template[arg0_71.id]

			arg0_71.desc = var0_71.desc

			return var0_71
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_72)
			local var0_72 = pg.world_item_data_template[arg0_72.id]

			arg0_72.desc = var0_72.display

			return var0_72
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_73)
			local var0_73 = pg.item_data_frame[arg0_73.id]

			arg0_73.desc = var0_73.desc

			return var0_73
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_74)
			return pg.item_data_chat[arg0_74.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_75)
			local var0_75 = pg.spweapon_data_statistics[arg0_75.id]

			arg0_75.desc = var0_75.descrip

			return var0_75
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_76)
			local var0_76 = pg.activity_ryza_item[arg0_76.id]

			arg0_76.item = AtelierMaterial.New({
				configId = arg0_76.id
			})
			arg0_76.desc = arg0_76.item:GetDesc()

			return var0_76
		end,
		[DROP_TYPE_OPERATION] = function(arg0_77)
			arg0_77.ship = getProxy(BayProxy):getShipById(arg0_77.count)

			local var0_77 = pg.ship_data_statistics[arg0_77.ship.configId]
			local var1_77, var2_77, var3_77 = ShipWordHelper.GetWordAndCV(var0_77.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_77.desc = var3_77 or i18n("ship_drop_desc_default")

			return var0_77
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_78)
			return arg0_78.isWorldBuff and pg.world_SLGbuff_data[arg0_78.id] or pg.strategy_data_template[arg0_78.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_79)
			local var0_79 = pg.emoji_template[arg0_79.id]

			arg0_79.name = var0_79.item_name
			arg0_79.desc = var0_79.item_desc

			return var0_79
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_80)
			local var0_80 = WorldCollectionProxy.GetCollectionTemplate(arg0_80.id)

			arg0_80.desc = var0_80.name

			return var0_80
		end,
		[DROP_TYPE_META_PT] = function(arg0_81)
			local var0_81 = pg.ship_strengthen_meta[arg0_81.id]
			local var1_81 = Item.getConfigData(var0_81.itemid)

			arg0_81.desc = var1_81.display

			return var1_81
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_82)
			local var0_82 = pg.activity_workbench_item[arg0_82.id]

			arg0_82.item = WorkBenchItem.New({
				configId = arg0_82.id
			})
			arg0_82.desc = arg0_82.item:GetDesc()

			return var0_82
		end,
		[DROP_TYPE_BUFF] = function(arg0_83)
			local var0_83 = pg.benefit_buff_template[arg0_83.id]

			arg0_83.desc = var0_83.desc

			return var0_83
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_84)
			local var0_84 = pg.commander_data_template[arg0_84.id]

			arg0_84.desc = var0_84.desc

			return var0_84
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_85)
			local var0_85 = pg.island_item_data_template[arg0_85.id]

			arg0_85.desc = var0_85.desc

			return var0_85
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_86)
			local var0_86 = pg.island_ability_template[arg0_86.id]

			arg0_86.desc = ""

			return var0_86
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_87)
			local var0_87 = pg.island_chara_template[arg0_87.id]
			local var1_87 = var0_87.invite_item

			arg0_87.desc = pg.island_item_data_template[var1_87].desc

			return var0_87
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_88)
			local var0_88 = pg.island_furniture_template[arg0_88.id]

			arg0_88.desc = var0_88.describe

			return var0_88
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_89)
			local var0_89 = pg.island_dress_template[arg0_89.id]

			arg0_89.desc = var0_89.desc

			return var0_89
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_90)
			local var0_90 = pg.island_skin_template[arg0_90.id]

			arg0_90.desc = var0_90.desc

			return var0_90
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_91)
			local var0_91 = pg.island_action[arg0_91.id]

			arg0_91.desc = var0_91.desc

			return var0_91
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_92)
			local var0_92 = pg.island_speedup_ticket[arg0_92.id]

			arg0_92.desc = var0_92.desc

			return var0_92
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_93)
			local var0_93 = pg.island_card_diy[arg0_93.id]

			arg0_93.desc = var0_93.desc

			return var0_93
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_94)
			return pg.drop_data_restore[arg0_94.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_95)
			local var0_95 = pg.dorm3d_furniture_template[arg0_95.id]

			arg0_95.desc = var0_95.desc

			return var0_95
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_96)
			local var0_96 = pg.dorm3d_gift[arg0_96.id]

			arg0_96.desc = var0_96.display

			return var0_96
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_97)
			local var0_97 = pg.dorm3d_resource[arg0_97.id]

			arg0_97.desc = ""

			return var0_97
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_98)
			local var0_98 = pg.livingarea_cover[arg0_98.id]

			arg0_98.desc = var0_98.desc

			return var0_98
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_99)
			return pg.item_data_battleui[arg0_99.id]
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_100)
			local var0_100 = pg.activity_medal_template[arg0_100.id].item

			return pg.item_virtual_data_statistics[var0_100]
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_101)
			local var0_101 = Item.getConfigData(arg0_101.id)

			assert(var0_101, arg0_101.id)

			arg0_101.desc = var0_101.display

			return var0_101
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_102)
			return pg.island_collection[arg0_102.id]
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_103)
			local var0_103 = pg.island_set.season_pt_show.key_value_int
			local var1_103 = pg.island_item_data_template[var0_103]

			arg0_103.desc = var1_103.desc

			return var1_103
		end
	}

	function var0_0.ConfigDefault(arg0_104)
		local var0_104 = arg0_104.type

		if tonumber(var0_104) and var0_104 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_104 = pg.activity_drop_type[var0_104].relevance

			return var1_104 and pg[var1_104][arg0_104.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_105)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_105.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_106)
			local var0_106 = getProxy(BagProxy):getItemCountById(arg0_106.id)

			if arg0_106:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_106, 1), true
			else
				return var0_106, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_107)
			local var0_107 = arg0_107:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_107], "equip groupId not exist")

			local var1_107 = pg.equip_data_template.get_id_list_by_group[var0_107]

			return underscore.reduce(var1_107, 0, function(arg0_108, arg1_108)
				local var0_108 = getProxy(EquipmentProxy):getEquipmentById(arg1_108)

				return arg0_108 + (var0_108 and var0_108.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_108)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_109)
			return getProxy(BayProxy):getConfigShipCount(arg0_109.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_110)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_110.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_111)
			return arg0_111.count, tobool(arg0_111.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_112)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_112.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_113)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_113.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_114)
			local var0_114 = arg0_114:getConfig("virtual_type")

			return switch(var0_114, {
				[22] = function()
					local var0_115 = getProxy(ActivityProxy):getActivityById(arg0_114:getConfig("link_id"))

					return var0_115 and var0_115.data1 or 0, true
				end,
				[101] = function()
					local var0_116 = getProxy(ActivityProxy):getActivityById(arg0_114:getConfig("link_id"))

					return var0_116 and var0_116.data1 or 0
				end
			}, function()
				return nil
			end)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_118)
			local var0_118 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_118.id)

			return (var0_118 and var0_118.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_118.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_119)
			local var0_119 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_119.type].activity_id)

			if not var0_119 then
				return 0
			end

			local var1_119 = var0_119:GetItemById(arg0_119.id)

			return var1_119 and var1_119.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_120)
			local var0_120 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_120.id)

			return var0_120 and var0_120:isOwned() and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_121)
			local var0_121 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_121.id)

			return var0_121 and var0_121:isOwned() and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_122)
			local var0_122 = nowWorld()

			if var0_122.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_122:GetInventoryProxy():GetItemCount(arg0_122.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_123)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_123.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_124)
			local var0_124 = getProxy(LivingAreaCoverProxy):GetCover(arg0_124.id)

			return var0_124 and var0_124:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_125)
			return getProxy(ApartmentProxy):getGiftCount(arg0_125.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_126)
			local var0_126 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_126.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_127)
			local var0_127 = 0
			local var1_127 = getProxy(IslandProxy):GetIsland()

			if var1_127 then
				var0_127 = var1_127:GetInventoryAgency():GetOwnCount(arg0_127.id)
			end

			return var0_127
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_128)
			return 0
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_129)
			return 0
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_130)
			local var0_130 = getProxy(IslandProxy):GetIsland()

			if var0_130 then
				local var1_130 = var0_130:GetAgoraAgency():GetFurnitures()

				for iter0_130, iter1_130 in ipairs(var1_130) do
					if iter1_130.id == arg0_130.id then
						return iter1_130.count
					end
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_131)
			local var0_131 = getProxy(IslandProxy):GetIsland()

			if var0_131 then
				local var1_131 = arg0_131:getConfig("belongto")

				if var1_131 == 1 then
					return var0_131:GetDressUpAgency():CheckOwnDress(arg0_131.id) and 1 or 0
				elseif var1_131 == 2 then
					return var0_131:GetCharacterAgency():GetDressIdRealCount(arg0_131.id)
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_132)
			local var0_132 = getProxy(IslandProxy)

			if not var0_132 then
				return 0
			end

			local var1_132 = var0_132:GetIsland()

			if var1_132 then
				return var1_132:GetCharacterAgency():CheckSkinIsOwned(arg0_132.id) and 1 or 0
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_133)
			local var0_133 = getProxy(IslandProxy)

			if not var0_133 then
				return 0
			end

			local var1_133 = var0_133:GetIsland()

			if var1_133 then
				return var1_133:GetActionAgency():ExistAction(arg0_133.id) and 1 or 0
			end

			return 0
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_134)
			local var0_134 = getProxy(IslandProxy)

			if not var0_134 then
				return 0
			end

			local var1_134 = var0_134:GetIsland()

			if var1_134 then
				return var1_134:GetSeasonAgency():GetSeason():GetPt()
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_135)
			local var0_135 = getProxy(IslandProxy)

			if not var0_135 then
				return 0
			end

			local var1_135 = var0_135:GetIsland()

			if var1_135 then
				return var1_135:GetCardDiyAgency():GetIdCount(arg0_135.id)
			end

			return 0
		end
	}

	function var0_0.CountDefault(arg0_136)
		local var0_136 = arg0_136.type

		if var0_136 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_136].activity_id):getVitemNumber(arg0_136.id)
		else
			return 0, false
		end
	end

	var0_0.LimitCase = {
		[DROP_TYPE_FURNITURE] = function(arg0_137)
			return arg0_137:getConfig("count")
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_138)
			return 1
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_139)
			return 1
		end,
		[DROP_TYPE_SKIN] = function(arg0_140)
			return 1
		end
	}

	function var0_0.LimitDefault(arg0_141)
		return 0
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_142)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_143)
			return Item.New(arg0_143)
		end,
		[DROP_TYPE_VITEM] = function(arg0_144)
			return Item.New(arg0_144)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_145)
			return Equipment.New(arg0_145)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_146)
			return Item.New({
				count = 1,
				id = arg0_146.id,
				extra = arg0_146.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_147)
			return WorldItem.New(arg0_147)
		end
	}

	function var0_0.SubClassDefault(arg0_148)
		assert(false, string.format("drop type %d without subClass", arg0_148.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_149)
			return arg0_149:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_150)
			return arg0_150:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_151)
			return arg0_151:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_152)
			return arg0_152:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_153)
			return arg0_153:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_154)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_155)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_156)
			return arg0_156:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_157)
			return arg0_157:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_158)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_159)
			return arg0_159:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_160)
			return arg0_160:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_161)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_162)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_163)
			return arg0_163:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_164)
			return arg0_164:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_165)
			return arg0_165:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_166)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_167)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_168)
			return arg0_168:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_169)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_170)
			return ItemRarity.Gold
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_171)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_172)
		return arg0_172:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_173)
		return arg0_173:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_174)
			local var0_174 = Drop.New({
				type = arg0_174:getConfig("type"),
				id = arg0_174:getConfig("resource_type"),
				count = arg0_174:getConfig("resource_num") * arg0_174.count
			})
			local var1_174 = Drop.New({
				type = arg0_174:getConfig("target_type"),
				id = arg0_174:getConfig("target_id"),
				count = arg0_174.count
			})

			PlayerConst.UpdateLinkActivity({
				var1_174
			})

			var0_174.name = string.format("%s(%s)", var0_174:getName(), var1_174:getName())

			return var0_174
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_175)
			for iter0_175, iter1_175 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_175.id].pt == arg0_175.id then
					return nil, arg0_175
				end
			end

			for iter2_175, iter3_175 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)) do
				if pg.black_friday_battlepass_event_pt[iter3_175.id].pt == arg0_175.id then
					return nil, arg0_175
				end
			end

			return arg0_175
		end,
		[DROP_TYPE_OPERATION] = function(arg0_176)
			if arg0_176.id ~= 3 then
				return nil
			end

			return arg0_176
		end,
		[DROP_TYPE_EMOJI] = function(arg0_177)
			return nil, arg0_177
		end,
		[DROP_TYPE_VITEM] = function(arg0_178, arg1_178, arg2_178)
			assert(arg0_178:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_178.id)

			return switch(arg0_178:getConfig("virtual_type"), {
				function()
					if arg0_178:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_178
					end

					return arg0_178
				end,
				[6] = function()
					local var0_180 = arg2_178.taskId
					local var1_180 = getProxy(ActivityProxy)
					local var2_180 = var1_180:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_180 then
						local var3_180 = var2_180.data1KeyValueList[1]

						var3_180[var0_180] = defaultValue(var3_180[var0_180], 0) + arg0_178.count

						var1_180:updateActivity(var2_180)
					end

					return nil, arg0_178
				end,
				[13] = function()
					local var0_181 = arg0_178:getName()
					local var1_181 = getProxy(ActivityProxy):getActivityById(arg0_178:getConfig("link_id"))

					if not var1_181 or var1_181:isEnd() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_181))

						return nil
					elseif var1_181:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_181))

						return nil
					else
						return arg0_178, nil
					end
				end,
				[17] = function()
					local var0_182 = getProxy(ActivityProxy):getActivityById(arg0_178:getConfig("link_id"))

					if var0_182.data1 < 1 then
						return Drop.New({
							count = 1,
							type = DROP_TYPE_SHIP,
							id = var0_182:getConfig("config_id")
						}), arg0_178
					else
						return Drop.New({
							id = 3,
							type = DROP_TYPE_OPERATION,
							count = var0_182.data2
						}), arg0_178
					end
				end,
				[21] = function()
					return nil, arg0_178
				end,
				[28] = function()
					local var0_184 = Drop.New({
						type = arg0_178.type,
						id = arg0_178.id,
						count = math.floor(arg0_178.count / 1000)
					})
					local var1_184 = Drop.New({
						type = arg0_178.type,
						id = arg0_178.id,
						count = arg0_178.count - math.floor(arg0_178.count / 1000)
					})

					return var0_184, var1_184
				end
			}, function()
				return arg0_178
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_186, arg1_186)
			if Ship.isMetaShipByConfigID(arg0_186.id) and Player.isMetaShipNeedToTrans(arg0_186.id) then
				local var0_186 = table.indexof(arg1_186, arg0_186.id, 1)

				if var0_186 then
					table.remove(arg1_186, var0_186)
				else
					local var1_186 = Player.metaShip2Res(arg0_186.id)
					local var2_186 = Drop.New(var1_186[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_186.id, var2_186)

					return arg0_186, var2_186
				end
			end

			return arg0_186
		end,
		[DROP_TYPE_SKIN] = function(arg0_187)
			arg0_187.isNew = not getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_187.id)

			return arg0_187
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_188)
			local var0_188 = getProxy(PlayerProxy):getRawData()
			local var1_188 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_188:updateMedalList({
				{
					key = arg0_188.id,
					value = var1_188
				}
			})

			return arg0_188
		end,
		[DROP_TYPE_BUFF] = function(arg0_189)
			return nil, arg0_189
		end
	}

	function var0_0.TransDefault(arg0_190)
		return arg0_190
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_191)
			local var0_191 = id2res(arg0_191.id)

			assert(var0_191, "res should be defined: " .. arg0_191.id)

			local var1_191 = getProxy(PlayerProxy)
			local var2_191 = var1_191:getData()

			var2_191:addResources({
				[var0_191] = arg0_191.count
			})
			var1_191:updatePlayer(var2_191)
		end,
		[DROP_TYPE_ITEM] = function(arg0_192)
			if arg0_192:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_192 = getProxy(BagProxy):getItemCountById(arg0_192.id)
				local var1_192 = math.min(arg0_192:getConfig("max_num") - var0_192, arg0_192.count)

				if var1_192 > 0 then
					getProxy(BagProxy):addItemById(arg0_192.id, var1_192)
				end
			else
				getProxy(BagProxy):addItemById(arg0_192.id, arg0_192.count, arg0_192.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_193)
			local var0_193 = arg0_193:getSubClass()

			getProxy(BagProxy):addItemById(var0_193.id, var0_193.count, var0_193.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_194)
			getProxy(EquipmentProxy):addEquipmentById(arg0_194.id, arg0_194.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_195)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_196)
			local var0_196 = getProxy(DormProxy)
			local var1_196 = Furniture.New({
				id = arg0_196.id,
				count = arg0_196.count
			})

			if var1_196:isRecordTime() then
				var1_196.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			local var2_196 = var0_196:getRawData()

			var2_196:AddFurniture(var1_196)
			var0_196:updateDrom(var2_196, BackYardConst.DORM_UPDATE_TYPE_FURNITURE)
		end,
		[DROP_TYPE_SKIN] = function(arg0_197)
			local var0_197 = getProxy(ShipSkinProxy)
			local var1_197 = ShipSkin.New({
				id = arg0_197.id
			})

			var0_197:addSkin(var1_197)
		end,
		[DROP_TYPE_VITEM] = function(arg0_198)
			arg0_198 = arg0_198:getSubClass()

			assert(arg0_198:isVirtualItem(), "item type error(virtual item)>>" .. arg0_198.id)
			switch(arg0_198:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_198.id, arg0_198.count)
				end,
				function()
					local var0_200 = getProxy(ActivityProxy)
					local var1_200 = arg0_198:getConfig("link_id")
					local var2_200

					if var1_200 > 0 then
						var2_200 = var0_200:getActivityById(var1_200)
					else
						var2_200 = var0_200:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_200 and not var2_200:isEnd() then
						if not table.contains(var2_200.data1_list, arg0_198.id) then
							table.insert(var2_200.data1_list, arg0_198.id)
						end

						var0_200:updateActivity(var2_200)
					end
				end,
				function()
					local var0_201 = getProxy(ActivityProxy)
					local var1_201 = var0_201:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_201, iter1_201 in ipairs(var1_201) do
						iter1_201.data1 = iter1_201.data1 + arg0_198.count

						local var2_201 = iter1_201:getConfig("config_id")
						local var3_201 = pg.activity_vote[var2_201]

						if var3_201 and var3_201.ticket_id_period == arg0_198.id then
							iter1_201.data3 = iter1_201.data3 + arg0_198.count
						end

						var0_201:updateActivity(iter1_201)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_198.id,
							ptCount = arg0_198.count
						})
					end
				end,
				[4] = function()
					local var0_202 = getProxy(ColoringProxy):getColorItems()

					var0_202[arg0_198.id] = (var0_202[arg0_198.id] or 0) + arg0_198.count
				end,
				[6] = function()
					local var0_203 = getProxy(ActivityProxy)
					local var1_203 = var0_203:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_203 then
						var1_203.data3 = var1_203.data3 + arg0_198.count

						var0_203:updateActivity(var1_203)
					end
				end,
				[7] = function()
					local var0_204 = getProxy(ChapterProxy)

					var0_204:updateRemasterTicketsNum(math.min(var0_204.remasterTickets + arg0_198.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_205 = getProxy(ActivityProxy)
					local var1_205 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_205 then
						var1_205.data1_list[1] = var1_205.data1_list[1] + arg0_198.count

						var0_205:updateActivity(var1_205)
					end
				end,
				[11] = function()
					local var0_206 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_206 and not var0_206:isEnd() then
						var0_206.data1 = var0_206.data1 + arg0_198.count
					end
				end,
				[12] = function()
					local var0_207 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_207 and not var0_207:isEnd() then
						var0_207.data1KeyValueList[1][arg0_198.id] = (var0_207.data1KeyValueList[1][arg0_198.id] or 0) + arg0_198.count
					end
				end,
				[13] = function()
					local var0_208 = getProxy(ActivityProxy):getActivityById(arg0_198:getConfig("link_id"))

					if var0_208:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

						return
					end

					var0_208.data1 = var0_208.data1 + arg0_198.count

					getProxy(ActivityProxy):updateActivity(var0_208)
				end,
				[14] = function()
					local var0_209 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_198.id then
						var0_209:AddSummonPt(arg0_198.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_198.id then
						var0_209:AddSummonPtOld(arg0_198.count)
					end
				end,
				[15] = function()
					local var0_210 = getProxy(ActivityProxy)
					local var1_210 = var0_210:getActivityById(arg0_198:getConfig("link_id"))

					if not var1_210 or var1_210:isEnd() then
						return
					end

					if var1_210:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_210 = pg.activity_event_grid[var1_210.data1]

						if arg0_198.id == var2_210.ticket_item then
							var1_210.data2 = var1_210.data2 + arg0_198.count
						elseif arg0_198.id == var2_210.explore_item then
							var1_210.data3 = var1_210.data3 + arg0_198.count
						end
					elseif var1_210:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_210.data3 = var1_210.data3 + arg0_198.count
					end

					var0_210:updateActivity(var1_210)
				end,
				[16] = function()
					local var0_211 = getProxy(ActivityProxy)
					local var1_211 = var0_211:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_211, iter1_211 in pairs(var1_211) do
						if iter1_211 and not iter1_211:isEnd() and arg0_198.id == iter1_211:getConfig("config_id") then
							iter1_211.data1 = iter1_211.data1 + arg0_198.count

							var0_211:updateActivity(iter1_211)
						end
					end
				end,
				[17] = function()
					local var0_212 = getProxy(ActivityProxy)
					local var1_212 = var0_212:getActivityById(arg0_198:getConfig("link_id"))

					if not var1_212 or var1_212:isEnd() then
						return
					end

					var1_212.data1 = 2

					var0_212:updateActivity(var1_212)
				end,
				[20] = function()
					local var0_213 = getProxy(BagProxy)
					local var1_213 = pg.gameset.urpt_chapter_max.description
					local var2_213 = var1_213[1]
					local var3_213 = var1_213[2]
					local var4_213 = var0_213:GetLimitCntById(var2_213)
					local var5_213 = math.min(var3_213 - var4_213, arg0_198.count)

					if var5_213 > 0 then
						var0_213:addItemById(var2_213, var5_213)
						var0_213:AddLimitCnt(var2_213, var5_213)
					end
				end,
				[21] = function()
					local var0_214 = getProxy(ActivityProxy)
					local var1_214 = var0_214:getActivityById(arg0_198:getConfig("link_id"))

					if var1_214 and not var1_214:isEnd() then
						var1_214.data2 = 1

						var0_214:updateActivity(var1_214)
					end
				end,
				[22] = function()
					local var0_215 = getProxy(ActivityProxy)
					local var1_215 = var0_215:getActivityById(arg0_198:getConfig("link_id"))

					if var1_215 and not var1_215:isEnd() then
						var1_215.data1 = var1_215.data1 + arg0_198.count

						var0_215:updateActivity(var1_215)
					end
				end,
				[23] = function()
					local var0_216 = (function()
						for iter0_217, iter1_217 in ipairs(pg.gameset.package_lv.description) do
							if arg0_198.id == iter1_217[1] then
								return iter1_217[2]
							end
						end
					end)()

					assert(var0_216)

					local var1_216 = getProxy(PlayerProxy)
					local var2_216 = var1_216:getData()

					var2_216:addExpToLevel(var0_216)
					var1_216:updatePlayer(var2_216)
				end,
				[24] = function()
					local var0_218 = arg0_198:getConfig("link_id")
					local var1_218 = getProxy(ActivityProxy):getActivityById(var0_218)

					if var1_218 and not var1_218:isEnd() and var1_218:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_218.data2 = var1_218.data2 + arg0_198.count

						getProxy(ActivityProxy):updateActivity(var1_218)
					end
				end,
				[25] = function()
					local var0_219 = getProxy(ActivityProxy)
					local var1_219 = var0_219:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_219 and not var1_219:isEnd() then
						var1_219.data1 = var1_219.data1 - 1

						if not table.contains(var1_219.data1_list, arg0_198.id) then
							table.insert(var1_219.data1_list, arg0_198.id)
						end

						var0_219:updateActivity(var1_219)

						local var2_219 = arg0_198:getConfig("link_id")

						if var2_219 > 0 then
							local var3_219 = var0_219:getActivityById(var2_219)

							if var3_219 and not var3_219:isEnd() then
								var3_219.data1 = var3_219.data1 + 1

								var0_219:updateActivity(var3_219)
							end
						end
					end
				end,
				[26] = function()
					local var0_220 = getProxy(ActivityProxy)
					local var1_220 = Clone(var0_220:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_220 and not var1_220:isEnd() then
						var1_220.data1 = var1_220.data1 + arg0_198.count

						var0_220:updateActivity(var1_220)
					end
				end,
				[27] = function()
					local var0_221 = getProxy(ActivityProxy)
					local var1_221 = Clone(var0_221:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_221 and not var1_221:isEnd() then
						var1_221:AddExp(arg0_198.count)
						var0_221:updateActivity(var1_221)
					end
				end,
				[28] = function()
					local var0_222 = getProxy(ActivityProxy)
					local var1_222 = Clone(var0_222:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_222 and not var1_222:isEnd() then
						var1_222:AddGold(arg0_198.count)
						var0_222:updateActivity(var1_222)
					end
				end,
				[29] = function()
					local var0_223 = getProxy(ActivityProxy)
					local var1_223 = Clone(var0_223:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5))

					if var1_223 and not var1_223:isEnd() then
						var1_223.data1 = var1_223.data1 + arg0_198.count

						var0_223:updateActivity(var1_223)
					end
				end,
				[30] = function()
					local var0_224 = arg0_198:getConfig("link_id")
					local var1_224 = getProxy(ActivityProxy):getActivityById(var0_224)

					if not var1_224 or var1_224:isEnd() then
						return
					end

					local var2_224 = arg0_198.count

					if var1_224:IsLimitExpItem(arg0_198.id) then
						var2_224 = var1_224:FilterExp(var2_224)
						var2_224 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_224:GetTargetGroupId(), var2_224)

						var1_224:AddDailyProgress(var2_224)
					else
						local var3_224 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_224:GetTargetGroupId(), var2_224)
					end

					getProxy(ActivityProxy):updateActivity(var1_224)
				end,
				[31] = function()
					getProxy(AuctionGameBaseProxy):AddGold(arg0_198.count)
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_228 = arg0_198:getConfig("link_id")
					local var1_228 = getProxy(ActivityProxy):getActivityById(var0_228)

					if var1_228 and not var1_228:isEnd() then
						var1_228.data1 = var1_228.data1 + arg0_198.count

						getProxy(ActivityProxy):updateActivity(var1_228)
					end
				end,
				[102] = function()
					local var0_229 = arg0_198:getConfig("link_id")
					local var1_229 = pg.activity_template[var0_229].type

					switch(var1_229, {
						[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = function()
							getProxy(CityRebuildProxy):AddPt(var0_229, arg0_198.count)
						end
					})
				end,
				[103] = function()
					local var0_231 = arg0_198:getConfig("link_id")
					local var1_231 = getProxy(ActivityProxy):getActivityById(var0_231)

					if not var1_231 or var1_231:isEnd() then
						return
					end

					local var2_231 = var1_231:getConfig("type")

					switch(var2_231, {
						[ActivityConst.ACTIVITY_TYPE_TOWN2] = function()
							local var0_232 = getProxy(ActivityProxy)
							local var1_232 = Clone(var0_232:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN2))

							if arg0_198:getConfig("id") == pg.activity_town_2[var1_232.id].bubble_drop[1][2] then
								var1_232:AddGold(arg0_198.count)
								var1_232:AddAllGold(arg0_198.count)
							else
								var1_232:AddGold2(arg0_198.count)
							end

							var0_232:updateActivity(var1_232)
						end,
						[ActivityConst.ACTIVITY_TYPE_MALL] = function()
							local var0_233 = var1_231:getConfig("config_data")[1]
							local var1_233 = arg0_198.id ~= var0_233

							if var1_233 then
								var1_231:AddStaff(arg0_198.id, arg0_198.count)
							else
								var1_231:AddGold(arg0_198.count)
							end

							getProxy(ActivityProxy):updateActivity(var1_231)

							if var1_233 then
								pg.m02:sendNotification(GAME.ACTIVITY_MALL_OP, {
									activity_id = var1_231.id,
									cmd = ActivityMallOPCommand.CMD.GET_STAFF_DATA,
									arg1 = arg0_198.count
								})
							end
						end
					}, function()
						assert(var1_231 .. "对应" .. var2_231 .. "错误")
					end)
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_235)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_235.id, arg0_235.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_236)
			local var0_236 = getProxy(BayProxy)
			local var1_236 = var0_236:getShipById(arg0_236.count)

			if var1_236 then
				var1_236:unlockActivityNpc(0)
				var0_236:updateShip(var1_236)
				getProxy(CollectionProxy):flushCollection(var1_236)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_237)
			nowWorld():GetInventoryProxy():AddItem(arg0_237.id, arg0_237.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_238)
			local var0_238 = getProxy(AttireProxy)
			local var1_238 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_238 = IconFrame.New({
				id = arg0_238.id
			})
			local var3_238 = var1_238 + var2_238:getConfig("time_second")

			var2_238:updateData({
				isNew = true,
				end_time = var3_238
			})
			var0_238:addAttireFrame(var2_238)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_238)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_239)
			local var0_239 = getProxy(AttireProxy)
			local var1_239 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_239 = ChatFrame.New({
				id = arg0_239.id
			})
			local var3_239 = var1_239 + var2_239:getConfig("time_second")

			var2_239:updateData({
				isNew = true,
				end_time = var3_239
			})
			var0_239:addAttireFrame(var2_239)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_239)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_240)
			getProxy(EmojiProxy):addNewEmojiID(arg0_240.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_240:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_241)
			nowWorld():GetCollectionProxy():Unlock(arg0_241.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_242)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_242.id):addPT(arg0_242.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_243)
			local var0_243 = arg0_243.id
			local var1_243 = arg0_243.count
			local var2_243 = getProxy(ShipSkinProxy)
			local var3_243 = var2_243:getSkinById(var0_243)

			if var3_243 and var3_243:isExpireType() then
				local var4_243 = var1_243 + var3_243.endTime
				local var5_243 = ShipSkin.New({
					id = var0_243,
					end_time = var4_243
				})

				var2_243:addSkin(var5_243)
			elseif not var3_243 then
				local var6_243 = var1_243 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_243 = ShipSkin.New({
					id = var0_243,
					end_time = var6_243
				})

				var2_243:addSkin(var7_243)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_244)
			local var0_244 = arg0_244.id
			local var1_244 = pg.benefit_buff_template[var0_244]

			assert(var1_244 and var1_244.act_id > 0, "should exist act id")

			local var2_244 = getProxy(ActivityProxy):getActivityById(var1_244.act_id)

			if var2_244 and not var2_244:isEnd() then
				local var3_244 = var1_244.max_time
				local var4_244 = pg.TimeMgr.GetInstance():GetServerTime() + var3_244

				var2_244:AddBuff(ActivityBuff.New(var2_244.id, var0_244, var4_244))
				getProxy(ActivityProxy):updateActivity(var2_244)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_245)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_246)
			getProxy(ApartmentProxy):ModifyRoom(arg0_246:getConfig("room_id"), function(arg0_247)
				arg0_247:AddFurnitureByID(arg0_246.id)
			end)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_248)
			getProxy(ApartmentProxy):changeGiftCount(arg0_248.id, arg0_248.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_249)
			getProxy(ApartmentProxy):ModifyApartment(arg0_249:getConfig("ship_group"), function(arg0_250)
				arg0_250:addSkin(arg0_249.id)
			end)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_251)
			local var0_251 = getProxy(LivingAreaCoverProxy)
			local var1_251 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_251.id
			})

			var0_251:UpdateCover(var1_251)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_251)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_251.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_252)
			local var0_252 = getProxy(AttireProxy)
			local var1_252 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_252 = CombatUIStyle.New({
				id = arg0_252.id
			})

			var2_252:setUnlock()
			var2_252:setNew()
			var0_252:addAttireFrame(var2_252)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_252)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_253)
			local var0_253 = getProxy(IslandProxy):GetIsland()

			if not var0_253 then
				return
			end

			var0_253:GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_253.id,
				num = arg0_253.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_254)
		if arg0_254.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_254 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_254.type].activity_id)

			if arg0_254.type == DROP_TYPE_RYZA_DROP then
				if var0_254 and not var0_254:isEnd() then
					var0_254:AddItem(AtelierMaterial.New({
						configId = arg0_254.id,
						count = arg0_254.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_254)
				end
			elseif var0_254 and not var0_254:isEnd() then
				var0_254:addVitemNumber(arg0_254.id, arg0_254.count)
				getProxy(ActivityProxy):updateActivity(var0_254)
			end
		elseif arg0_254.type >= DROP_TYPE_ISLAND_ITEM and arg0_254.type <= DROP_TYPE_ISLAND_CARD_DIY then
			if not getProxy(IslandProxy):GetIsland() then
				return
			end

			local var1_254 = {}

			table.insert(var1_254, {
				type = arg0_254.type,
				id = arg0_254.id,
				number = arg0_254.count
			})
			IslandDropHelper.AddItems({
				drop_list = var1_254
			})
		else
			print("can not handle this type>>" .. arg0_254.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_255, arg1_255, arg2_255)
			setText(arg2_255, arg0_255:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_256, arg1_256, arg2_256)
			local var0_256 = arg0_256:getConfig("display")

			if arg0_256:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_256 = string.gsub(var0_256, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_256.extra))
			elseif arg0_256:getConfig("combination_display") ~= nil then
				local var1_256 = arg0_256:getConfig("combination_display")

				if var1_256 and #var1_256 > 0 then
					var0_256 = Item.StaticCombinationDisplay(var1_256)
				end
			end

			setText(arg2_256, SwitchSpecialChar(var0_256, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_257, arg1_257, arg2_257)
			setText(arg2_257, arg0_257:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_258, arg1_258, arg2_258)
			local var0_258 = arg0_258:getConfig("skin_id")
			local var1_258, var2_258, var3_258 = ShipWordHelper.GetWordAndCV(var0_258, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_258, var3_258 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_259, arg1_259, arg2_259)
			local var0_259 = arg0_259:getConfig("skin_id")
			local var1_259, var2_259, var3_259 = ShipWordHelper.GetWordAndCV(var0_259, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_259, var3_259 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_260, arg1_260, arg2_260)
			setText(arg2_260, arg1_260.name or arg0_260:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_261, arg1_261, arg2_261)
			local var0_261 = arg0_261:getConfig("desc")

			for iter0_261, iter1_261 in ipairs({
				arg0_261.count
			}) do
				var0_261 = string.gsub(var0_261, "$" .. iter0_261, iter1_261)
			end

			setText(arg2_261, var0_261)
		end,
		[DROP_TYPE_SKIN] = function(arg0_262, arg1_262, arg2_262)
			setText(arg2_262, arg0_262:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_263, arg1_263, arg2_263)
			setText(arg2_263, arg0_263:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_264, arg1_264, arg2_264)
			local var0_264 = arg0_264:getConfig("desc")
			local var1_264 = _.map(arg0_264:getConfig("equip_type"), function(arg0_265)
				return EquipType.Type2Name2(arg0_265)
			end)

			setText(arg2_264, var0_264 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_264, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_266, arg1_266, arg2_266)
			setText(arg2_266, arg0_266:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_267, arg1_267, arg2_267)
			setText(arg2_267, arg0_267:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_268, arg1_268, arg2_268, arg3_268)
			local var0_268 = WorldCollectionProxy.GetCollectionType(arg0_268.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_268, i18n("world_" .. var0_268 .. "_desc", arg0_268:getConfig("name")))
			setText(arg3_268, i18n("world_" .. var0_268 .. "_name", arg0_268:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_269, arg1_269, arg2_269)
			setText(arg2_269, arg0_269.desc and arg0_269.desc or arg0_269:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_270, arg1_270, arg2_270)
			setText(arg2_270, arg0_270:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_271, arg1_271, arg2_271)
			setText(arg2_271, arg0_271:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_272, arg1_272, arg2_272)
			local var0_272 = string.gsub(arg0_272:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_272.count))

			setText(arg2_272, SwitchSpecialChar(var0_272, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_273, arg1_273, arg2_273)
			setText(arg2_273, arg0_273:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_274, arg1_274, arg2_274)
			setText(arg2_274, arg0_274:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_275, arg1_275, arg2_275)
			setText(arg2_275, arg0_275:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_276, arg1_276, arg2_276)
			setText(arg2_276, arg0_276:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_277, arg1_277, arg2_277)
			setText(arg2_277, arg0_277:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_278, arg1_278, arg2_278)
			setText(arg2_278, arg0_278:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_279, arg1_279, arg2_279)
			setText(arg2_279, "")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_280, arg1_280, arg2_280)
			setText(arg2_280, arg0_280.desc)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_281, arg1_281, arg2_281)
			setText(arg2_281, arg0_281.desc)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_282, arg1_282, arg2_282)
			setText(arg2_282, arg0_282.desc)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_283, arg1_283, arg2_283)
			setText(arg2_283, arg0_283.desc)
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_284, arg1_284, arg2_284)
		if arg0_284.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_284, arg0_284:getConfig("display"))
		else
			setText(arg2_284, arg0_284.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_285, arg1_285, arg2_285)
			if arg0_285.id == PlayerConst.ResStoreGold or arg0_285.id == PlayerConst.ResStoreOil then
				arg2_285 = arg2_285 or {}
				arg2_285.frame = "frame_store"
			end

			updateItem(arg1_285, Item.New({
				id = id2ItemId(arg0_285.id)
			}), arg2_285)
		end,
		[DROP_TYPE_ITEM] = function(arg0_286, arg1_286, arg2_286)
			updateItem(arg1_286, arg0_286:getSubClass(), arg2_286)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_287, arg1_287, arg2_287)
			updateEquipment(arg1_287, arg0_287:getSubClass(), arg2_287)
		end,
		[DROP_TYPE_SHIP] = function(arg0_288, arg1_288, arg2_288)
			updateShip(arg1_288, arg0_288.ship, arg2_288)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_289, arg1_289, arg2_289)
			updateShip(arg1_289, arg0_289.ship, arg2_289)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_290, arg1_290, arg2_290)
			updateFurniture(arg1_290, arg0_290, arg2_290)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_291, arg1_291, arg2_291)
			arg2_291.isWorldBuff = arg0_291.isWorldBuff

			updateStrategy(arg1_291, arg0_291, arg2_291)
		end,
		[DROP_TYPE_SKIN] = function(arg0_292, arg1_292, arg2_292)
			arg2_292.isSkin = true
			arg2_292.isNew = arg0_292.isNew

			updateShip(arg1_292, Ship.New({
				configId = tonumber(arg0_292:getConfig("ship_group") .. "1"),
				skin_id = arg0_292.id
			}), arg2_292)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_293, arg1_293, arg2_293)
			local var0_293 = setmetatable({
				count = arg0_293.count
			}, {
				__index = arg0_293:getConfigTable()
			})

			updateEquipmentSkin(arg1_293, var0_293, arg2_293)
		end,
		[DROP_TYPE_VITEM] = function(arg0_294, arg1_294, arg2_294)
			updateItem(arg1_294, Item.New({
				id = arg0_294.id
			}), arg2_294)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_295, arg1_295, arg2_295)
			updateWorldItem(arg1_295, WorldItem.New({
				id = arg0_295.id
			}), arg2_295)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_296, arg1_296, arg2_296)
			updateWorldCollection(arg1_296, arg0_296, arg2_296)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_297, arg1_297, arg2_297)
			updateAttire(arg1_297, AttireConst.TYPE_CHAT_FRAME, arg0_297:getConfigTable(), arg2_297)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_298, arg1_298, arg2_298)
			updateAttire(arg1_298, AttireConst.TYPE_ICON_FRAME, arg0_298:getConfigTable(), arg2_298)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_299, arg1_299, arg2_299)
			updateEmoji(arg1_299, arg0_299:getConfigTable(), arg2_299)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_300, arg1_300, arg2_300)
			arg2_300.count = 1

			updateItem(arg1_300, arg0_300:getSubClass(), arg2_300)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_301, arg1_301, arg2_301)
			updateSpWeapon(arg1_301, SpWeapon.New({
				id = arg0_301.id
			}), arg2_301)
		end,
		[DROP_TYPE_META_PT] = function(arg0_302, arg1_302, arg2_302)
			updateItem(arg1_302, Item.New({
				id = arg0_302:getConfig("id")
			}), arg2_302)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_303, arg1_303, arg2_303)
			arg2_303.isSkin = true
			arg2_303.isTimeLimit = true
			arg2_303.count = 1

			updateShip(arg1_303, Ship.New({
				configId = tonumber(arg0_303:getConfig("ship_group") .. "1"),
				skin_id = arg0_303.id
			}), arg2_303)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_304, arg1_304, arg2_304)
			AtelierMaterial.UpdateRyzaItem(arg1_304, arg0_304.item, arg2_304)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_305, arg1_305, arg2_305)
			WorkBenchItem.UpdateDrop(arg1_305, arg0_305.item, arg2_305)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_306, arg1_306, arg2_306)
			WorkBenchItem.UpdateDrop(arg1_306, WorkBenchItem.New({
				configId = arg0_306.id,
				count = arg0_306.count
			}), arg2_306)
		end,
		[DROP_TYPE_BUFF] = function(arg0_307, arg1_307, arg2_307)
			updateBuff(arg1_307, arg0_307.id, arg2_307)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_308, arg1_308, arg2_308)
			updateCommander(arg1_308, arg0_308, arg2_308)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_309, arg1_309, arg2_309)
			updateCover(arg1_309, arg0_309, arg2_309)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_310, arg1_310, arg2_310)
			updateAttireCombatUI(arg1_310, AttireConst.TYPE_ICON_FRAME, arg0_310:getConfigTable(), arg2_310)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_311, arg1_311, arg2_311)
			updateActivityMedal(arg1_311, arg0_311:getConfigTable(), arg2_311)
		end
	}

	function var0_0.UpdateDropDefault(arg0_312, arg1_312, arg2_312)
		updateDefaultIconTpl(arg1_312, arg0_312, arg2_312)
	end

	var0_0.UpdateCustomDropCase = {
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_313, arg1_313, arg2_313)
			updateDorm3dIcon(arg1_313, arg0_313, arg2_313)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_314, arg1_314, arg2_314)
			updateDorm3dIcon(arg1_314, arg0_314, arg2_314)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_315, arg1_315, arg2_315)
			updateDorm3dIcon(arg1_315, arg0_315, arg2_315)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_316, arg1_316, arg2_316)
			updateIslandItem(arg1_316, arg0_316, arg2_316)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_317, arg1_317, arg2_317)
			updateIslandUnlock(arg1_317, arg0_317, arg2_317)
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_318, arg1_318, arg2_318)
			updateIslandInvitation(arg1_318, arg0_318, arg2_318)
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_319, arg1_319, arg2_319)
			updateIslandSeasonPt(arg1_319, arg0_319, arg2_319)
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_320, arg1_320, arg2_320)
			updateIslandWatherCollect(arg1_320, arg0_320, arg2_320)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_321, arg1_321, arg2_321)
			updateIslandFurniture(arg1_321, arg0_321, arg2_321)
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_322, arg1_322, arg2_322)
			updateIslandCardDiy(arg1_322, arg0_322, arg2_322)
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_323, arg1_323, arg2_323)
			updateIslandSpeedupTicket(arg1_323, arg0_323, arg2_323)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_324, arg1_324, arg2_324)
			updateItem(arg1_324, Item.New({
				id = arg0_324.id
			}), arg2_324)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_325, arg1_325, arg2_325)
			updateIslandSkin(arg1_325, arg0_325, arg2_325)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_326, arg1_326, arg2_326)
			updateIslandDress(arg1_326, arg0_326, arg2_326)
		end
	}

	function var0_0.UpdateCustomDropDefault(arg0_327, arg1_327, arg2_327)
		if arg2_327.style == "dorm" then
			updateDorm3dIcon(arg1_327, arg0_327, arg2_327)
		elseif arg2_327.style == "island" then
			updateIslandDefaultIconTpl(arg1_327, arg0_327, arg2_327)
		else
			warning(string.format("without dropType %d in updateCustomDrop", arg0_327.type))
		end
	end
end

return var0_0
