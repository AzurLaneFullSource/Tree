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
				end,
				[103] = function()
					local var0_117 = getProxy(ActivityProxy):getActivityById(arg0_114:getConfig("link_id"))

					return switch(var0_117:getConfig("type"), {
						[ActivityConst.ACTIVITY_TYPE_PT_BUFF_MARK2] = function()
							return var0_117:GetTotalPtCount()
						end
					}, function()
						assert(false)
					end)
				end,
				[104] = function()
					local var0_120 = getProxy(CollectionProxy):GetTrophyById(arg0_114:getConfig("link_id"))

					if var0_120 and (var0_120:canClaimed() or var0_120:isClaimed()) then
						return 1
					else
						return 0
					end
				end
			}, function()
				return nil
			end)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_122)
			local var0_122 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_122.id)

			return (var0_122 and var0_122.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_122.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_123)
			local var0_123 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_123.type].activity_id)

			if not var0_123 then
				return 0
			end

			local var1_123 = var0_123:GetItemById(arg0_123.id)

			return var1_123 and var1_123.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_124)
			local var0_124 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_124.id)

			return var0_124 and var0_124:isOwned() and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_125)
			local var0_125 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_125.id)

			return var0_125 and var0_125:isOwned() and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_126)
			local var0_126 = nowWorld()

			if var0_126.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_126:GetInventoryProxy():GetItemCount(arg0_126.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_127)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_127.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_128)
			local var0_128 = getProxy(LivingAreaCoverProxy):GetCover(arg0_128.id)

			return var0_128 and var0_128:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_129)
			return getProxy(ApartmentProxy):getGiftCount(arg0_129.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_130)
			local var0_130 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_130.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_131)
			local var0_131 = 0
			local var1_131 = getProxy(IslandProxy):GetIsland()

			if var1_131 then
				var0_131 = var1_131:GetInventoryAgency():GetOwnCount(arg0_131.id)
			end

			return var0_131
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_132)
			return 0
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_133)
			return 0
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_134)
			local var0_134 = getProxy(IslandProxy):GetIsland()

			if var0_134 then
				local var1_134 = var0_134:GetAgoraAgency():GetFurnitures()

				for iter0_134, iter1_134 in ipairs(var1_134) do
					if iter1_134.id == arg0_134.id then
						return iter1_134.count
					end
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_135)
			local var0_135 = getProxy(IslandProxy):GetIsland()

			if var0_135 then
				local var1_135 = arg0_135:getConfig("belongto")

				if var1_135 == 1 then
					return var0_135:GetDressUpAgency():CheckOwnDress(arg0_135.id) and 1 or 0
				elseif var1_135 == 2 then
					return var0_135:GetCharacterAgency():GetDressIdRealCount(arg0_135.id)
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_136)
			local var0_136 = getProxy(IslandProxy)

			if not var0_136 then
				return 0
			end

			local var1_136 = var0_136:GetIsland()

			if var1_136 then
				return var1_136:GetCharacterAgency():CheckSkinIsOwned(arg0_136.id) and 1 or 0
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_137)
			local var0_137 = getProxy(IslandProxy)

			if not var0_137 then
				return 0
			end

			local var1_137 = var0_137:GetIsland()

			if var1_137 then
				return var1_137:GetActionAgency():ExistAction(arg0_137.id) and 1 or 0
			end

			return 0
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_138)
			local var0_138 = getProxy(IslandProxy)

			if not var0_138 then
				return 0
			end

			local var1_138 = var0_138:GetIsland()

			if var1_138 then
				return var1_138:GetSeasonAgency():GetSeason():GetPt()
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_139)
			local var0_139 = getProxy(IslandProxy)

			if not var0_139 then
				return 0
			end

			local var1_139 = var0_139:GetIsland()

			if var1_139 then
				return var1_139:GetCardDiyAgency():GetIdCount(arg0_139.id)
			end

			return 0
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_140)
			local var0_140 = getProxy(PlayerProxy):getRawData()

			return var0_140 and var0_140:getActivityMedalExist(arg0_140.id) and 1 or 0
		end
	}

	function var0_0.CountDefault(arg0_141)
		local var0_141 = arg0_141.type

		if var0_141 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_141].activity_id):getVitemNumber(arg0_141.id)
		else
			return 0, false
		end
	end

	var0_0.LimitCase = {
		[DROP_TYPE_FURNITURE] = function(arg0_142)
			return arg0_142:getConfig("count")
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_143)
			return 1
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_144)
			return 1
		end,
		[DROP_TYPE_SKIN] = function(arg0_145)
			return 1
		end
	}

	function var0_0.LimitDefault(arg0_146)
		return 0
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_147)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_148)
			return Item.New(arg0_148)
		end,
		[DROP_TYPE_VITEM] = function(arg0_149)
			return Item.New(arg0_149)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_150)
			return Equipment.New(arg0_150)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_151)
			return Item.New({
				count = 1,
				id = arg0_151.id,
				extra = arg0_151.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_152)
			return WorldItem.New(arg0_152)
		end
	}

	function var0_0.SubClassDefault(arg0_153)
		assert(false, string.format("drop type %d without subClass", arg0_153.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_154)
			return arg0_154:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_155)
			return arg0_155:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_156)
			return arg0_156:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_157)
			return arg0_157:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_158)
			return arg0_158:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_159)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_160)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_161)
			return arg0_161:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_162)
			return arg0_162:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_163)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_164)
			return arg0_164:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_165)
			return arg0_165:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_166)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_167)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_168)
			return arg0_168:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_169)
			return arg0_169:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_170)
			return arg0_170:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_171)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_172)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_173)
			return arg0_173:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_174)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_175)
			return ItemRarity.Gold
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_176)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_177)
		return arg0_177:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_178)
		return arg0_178:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_179)
			local var0_179 = Drop.New({
				type = arg0_179:getConfig("type"),
				id = arg0_179:getConfig("resource_type"),
				count = arg0_179:getConfig("resource_num") * arg0_179.count
			})
			local var1_179 = Drop.New({
				type = arg0_179:getConfig("target_type"),
				id = arg0_179:getConfig("target_id"),
				count = arg0_179.count
			})

			PlayerConst.UpdateLinkActivity({
				var1_179
			})

			var0_179.name = string.format("%s(%s)", var0_179:getName(), var1_179:getName())

			return var0_179
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_180)
			for iter0_180, iter1_180 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_180.id].pt == arg0_180.id then
					return nil, arg0_180
				end
			end

			for iter2_180, iter3_180 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)) do
				if pg.black_friday_battlepass_event_pt[iter3_180.id].pt == arg0_180.id then
					return nil, arg0_180
				end
			end

			return arg0_180
		end,
		[DROP_TYPE_OPERATION] = function(arg0_181)
			if arg0_181.id ~= 3 then
				return nil
			end

			return arg0_181
		end,
		[DROP_TYPE_EMOJI] = function(arg0_182)
			return nil, arg0_182
		end,
		[DROP_TYPE_VITEM] = function(arg0_183, arg1_183, arg2_183)
			assert(arg0_183:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_183.id)

			return switch(arg0_183:getConfig("virtual_type"), {
				function()
					if arg0_183:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_183
					end

					return arg0_183
				end,
				[6] = function()
					local var0_185 = arg2_183.taskId
					local var1_185 = getProxy(ActivityProxy)
					local var2_185 = var1_185:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_185 then
						local var3_185 = var2_185.data1KeyValueList[1]

						var3_185[var0_185] = defaultValue(var3_185[var0_185], 0) + arg0_183.count

						var1_185:updateActivity(var2_185)
					end

					return nil, arg0_183
				end,
				[13] = function()
					local var0_186 = arg0_183:getName()
					local var1_186 = getProxy(ActivityProxy):getActivityById(arg0_183:getConfig("link_id"))

					if not var1_186 or var1_186:isEnd() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_186))

						return nil
					elseif var1_186:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_186))

						return nil
					else
						return arg0_183, nil
					end
				end,
				[17] = function()
					local var0_187 = getProxy(ActivityProxy):getActivityById(arg0_183:getConfig("link_id"))

					if var0_187.data1 < 1 then
						return Drop.New({
							count = 1,
							type = DROP_TYPE_SHIP,
							id = var0_187:getConfig("config_id")
						}), arg0_183
					else
						return Drop.New({
							id = 3,
							type = DROP_TYPE_OPERATION,
							count = var0_187.data2
						}), arg0_183
					end
				end,
				[21] = function()
					return nil, arg0_183
				end,
				[28] = function()
					local var0_189 = Drop.New({
						type = arg0_183.type,
						id = arg0_183.id,
						count = math.floor(arg0_183.count / 1000)
					})
					local var1_189 = Drop.New({
						type = arg0_183.type,
						id = arg0_183.id,
						count = arg0_183.count - math.floor(arg0_183.count / 1000)
					})

					return var0_189, var1_189
				end
			}, function()
				return arg0_183
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_191, arg1_191)
			if Ship.isMetaShipByConfigID(arg0_191.id) and Player.isMetaShipNeedToTrans(arg0_191.id) then
				local var0_191 = table.indexof(arg1_191, arg0_191.id, 1)

				if var0_191 then
					table.remove(arg1_191, var0_191)
				else
					local var1_191 = Player.metaShip2Res(arg0_191.id)
					local var2_191 = Drop.New(var1_191[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_191.id, var2_191)

					return arg0_191, var2_191
				end
			end

			return arg0_191
		end,
		[DROP_TYPE_SKIN] = function(arg0_192)
			arg0_192.isNew = not getProxy(ShipSkinProxy):hasNonLimitSkin(arg0_192.id)

			return arg0_192
		end,
		[DROP_TYPE_BUFF] = function(arg0_193)
			return nil, arg0_193
		end
	}

	function var0_0.TransDefault(arg0_194)
		return arg0_194
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_195)
			local var0_195 = id2res(arg0_195.id)

			assert(var0_195, "res should be defined: " .. arg0_195.id)

			local var1_195 = getProxy(PlayerProxy)
			local var2_195 = var1_195:getData()

			var2_195:addResources({
				[var0_195] = arg0_195.count
			})
			var1_195:updatePlayer(var2_195)
		end,
		[DROP_TYPE_ITEM] = function(arg0_196)
			if arg0_196:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_196 = getProxy(BagProxy):getItemCountById(arg0_196.id)
				local var1_196 = math.min(arg0_196:getConfig("max_num") - var0_196, arg0_196.count)

				if var1_196 > 0 then
					getProxy(BagProxy):addItemById(arg0_196.id, var1_196)
				end
			else
				getProxy(BagProxy):addItemById(arg0_196.id, arg0_196.count, arg0_196.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_197)
			local var0_197 = arg0_197:getSubClass()

			getProxy(BagProxy):addItemById(var0_197.id, var0_197.count, var0_197.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_198)
			getProxy(EquipmentProxy):addEquipmentById(arg0_198.id, arg0_198.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_199)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_200)
			local var0_200 = getProxy(DormProxy)
			local var1_200 = Furniture.New({
				id = arg0_200.id,
				count = arg0_200.count
			})

			if var1_200:isRecordTime() then
				var1_200.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			local var2_200 = var0_200:getRawData()

			var2_200:AddFurniture(var1_200)
			var0_200:updateDrom(var2_200, BackYardConst.DORM_UPDATE_TYPE_FURNITURE)
		end,
		[DROP_TYPE_SKIN] = function(arg0_201)
			local var0_201 = getProxy(ShipSkinProxy)
			local var1_201 = ShipSkin.New({
				id = arg0_201.id
			})

			var0_201:addSkin(var1_201)
		end,
		[DROP_TYPE_VITEM] = function(arg0_202)
			arg0_202 = arg0_202:getSubClass()

			assert(arg0_202:isVirtualItem(), "item type error(virtual item)>>" .. arg0_202.id)
			switch(arg0_202:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_202.id, arg0_202.count)
				end,
				function()
					local var0_204 = getProxy(ActivityProxy)
					local var1_204 = arg0_202:getConfig("link_id")
					local var2_204

					if var1_204 > 0 then
						var2_204 = var0_204:getActivityById(var1_204)
					else
						var2_204 = var0_204:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_204 and not var2_204:isEnd() then
						if not table.contains(var2_204.data1_list, arg0_202.id) then
							table.insert(var2_204.data1_list, arg0_202.id)
						end

						var0_204:updateActivity(var2_204)
					end
				end,
				function()
					local var0_205 = getProxy(ActivityProxy)
					local var1_205 = var0_205:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_205, iter1_205 in ipairs(var1_205) do
						iter1_205.data1 = iter1_205.data1 + arg0_202.count

						local var2_205 = iter1_205:getConfig("config_id")
						local var3_205 = pg.activity_vote[var2_205]

						if var3_205 and var3_205.ticket_id_period == arg0_202.id then
							iter1_205.data3 = iter1_205.data3 + arg0_202.count
						end

						var0_205:updateActivity(iter1_205)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_202.id,
							ptCount = arg0_202.count
						})
					end
				end,
				[4] = function()
					local var0_206 = getProxy(ColoringProxy):getColorItems()

					var0_206[arg0_202.id] = (var0_206[arg0_202.id] or 0) + arg0_202.count
				end,
				[6] = function()
					local var0_207 = getProxy(ActivityProxy)
					local var1_207 = var0_207:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_207 then
						var1_207.data3 = var1_207.data3 + arg0_202.count

						var0_207:updateActivity(var1_207)
					end
				end,
				[7] = function()
					local var0_208 = getProxy(ChapterProxy)

					var0_208:updateRemasterTicketsNum(math.min(var0_208.remasterTickets + arg0_202.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_209 = getProxy(ActivityProxy)
					local var1_209 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_209 then
						var1_209.data1_list[1] = var1_209.data1_list[1] + arg0_202.count

						var0_209:updateActivity(var1_209)
					end
				end,
				[11] = function()
					local var0_210 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_210 and not var0_210:isEnd() then
						var0_210.data1 = var0_210.data1 + arg0_202.count
					end
				end,
				[12] = function()
					local var0_211 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_211 and not var0_211:isEnd() then
						var0_211.data1KeyValueList[1][arg0_202.id] = (var0_211.data1KeyValueList[1][arg0_202.id] or 0) + arg0_202.count
					end
				end,
				[13] = function()
					local var0_212 = getProxy(ActivityProxy):getActivityById(arg0_202:getConfig("link_id"))

					if var0_212:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

						return
					end

					var0_212.data1 = var0_212.data1 + arg0_202.count

					getProxy(ActivityProxy):updateActivity(var0_212)
				end,
				[14] = function()
					local var0_213 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_202.id then
						var0_213:AddSummonPt(arg0_202.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_202.id then
						var0_213:AddSummonPtOld(arg0_202.count)
					end
				end,
				[15] = function()
					local var0_214 = getProxy(ActivityProxy)
					local var1_214 = var0_214:getActivityById(arg0_202:getConfig("link_id"))

					if not var1_214 or var1_214:isEnd() then
						return
					end

					if var1_214:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_214 = pg.activity_event_grid[var1_214.data1]

						if arg0_202.id == var2_214.ticket_item then
							var1_214.data2 = var1_214.data2 + arg0_202.count
						elseif arg0_202.id == var2_214.explore_item then
							var1_214.data3 = var1_214.data3 + arg0_202.count
						end
					elseif var1_214:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_214.data3 = var1_214.data3 + arg0_202.count
					end

					var0_214:updateActivity(var1_214)
				end,
				[16] = function()
					local var0_215 = getProxy(ActivityProxy)
					local var1_215 = var0_215:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_215, iter1_215 in pairs(var1_215) do
						if iter1_215 and not iter1_215:isEnd() and arg0_202.id == iter1_215:getConfig("config_id") then
							iter1_215.data1 = iter1_215.data1 + arg0_202.count

							var0_215:updateActivity(iter1_215)
						end
					end
				end,
				[17] = function()
					local var0_216 = getProxy(ActivityProxy)
					local var1_216 = var0_216:getActivityById(arg0_202:getConfig("link_id"))

					if not var1_216 or var1_216:isEnd() then
						return
					end

					var1_216.data1 = 2

					var0_216:updateActivity(var1_216)
				end,
				[20] = function()
					local var0_217 = getProxy(BagProxy)
					local var1_217 = pg.gameset.urpt_chapter_max.description
					local var2_217 = var1_217[1]
					local var3_217 = var1_217[2]
					local var4_217 = var0_217:GetLimitCntById(var2_217)
					local var5_217 = math.min(var3_217 - var4_217, arg0_202.count)

					if var5_217 > 0 then
						var0_217:addItemById(var2_217, var5_217)
						var0_217:AddLimitCnt(var2_217, var5_217)
					end
				end,
				[21] = function()
					local var0_218 = getProxy(ActivityProxy)
					local var1_218 = var0_218:getActivityById(arg0_202:getConfig("link_id"))

					if var1_218 and not var1_218:isEnd() then
						var1_218.data2 = 1

						var0_218:updateActivity(var1_218)
					end
				end,
				[22] = function()
					local var0_219 = getProxy(ActivityProxy)
					local var1_219 = var0_219:getActivityById(arg0_202:getConfig("link_id"))

					if var1_219 and not var1_219:isEnd() then
						var1_219.data1 = var1_219.data1 + arg0_202.count

						var0_219:updateActivity(var1_219)
					end
				end,
				[23] = function()
					local var0_220 = (function()
						for iter0_221, iter1_221 in ipairs(pg.gameset.package_lv.description) do
							if arg0_202.id == iter1_221[1] then
								return iter1_221[2]
							end
						end
					end)()

					assert(var0_220)

					local var1_220 = getProxy(PlayerProxy)
					local var2_220 = var1_220:getData()

					var2_220:addExpToLevel(var0_220)
					var1_220:updatePlayer(var2_220)
				end,
				[24] = function()
					local var0_222 = arg0_202:getConfig("link_id")
					local var1_222 = getProxy(ActivityProxy):getActivityById(var0_222)

					if var1_222 and not var1_222:isEnd() and var1_222:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_222.data2 = var1_222.data2 + arg0_202.count

						getProxy(ActivityProxy):updateActivity(var1_222)
					end
				end,
				[25] = function()
					local var0_223 = getProxy(ActivityProxy)
					local var1_223 = var0_223:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_223 and not var1_223:isEnd() then
						var1_223.data1 = var1_223.data1 - 1

						if not table.contains(var1_223.data1_list, arg0_202.id) then
							table.insert(var1_223.data1_list, arg0_202.id)
						end

						var0_223:updateActivity(var1_223)

						local var2_223 = arg0_202:getConfig("link_id")

						if var2_223 > 0 then
							local var3_223 = var0_223:getActivityById(var2_223)

							if var3_223 and not var3_223:isEnd() then
								var3_223.data1 = var3_223.data1 + 1

								var0_223:updateActivity(var3_223)
							end
						end
					end
				end,
				[26] = function()
					local var0_224 = getProxy(ActivityProxy)
					local var1_224 = Clone(var0_224:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_224 and not var1_224:isEnd() then
						var1_224.data1 = var1_224.data1 + arg0_202.count

						var0_224:updateActivity(var1_224)
					end
				end,
				[27] = function()
					local var0_225 = getProxy(ActivityProxy)
					local var1_225 = Clone(var0_225:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_225 and not var1_225:isEnd() then
						var1_225:AddExp(arg0_202.count)
						var0_225:updateActivity(var1_225)
					end
				end,
				[28] = function()
					local var0_226 = getProxy(ActivityProxy)
					local var1_226 = Clone(var0_226:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_226 and not var1_226:isEnd() then
						var1_226:AddGold(arg0_202.count)
						var0_226:updateActivity(var1_226)
					end
				end,
				[29] = function()
					local var0_227 = getProxy(ActivityProxy)
					local var1_227 = Clone(var0_227:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5))

					if var1_227 and not var1_227:isEnd() then
						var1_227.data1 = var1_227.data1 + arg0_202.count

						var0_227:updateActivity(var1_227)
					end
				end,
				[30] = function()
					local var0_228 = arg0_202:getConfig("link_id")
					local var1_228 = getProxy(ActivityProxy):getActivityById(var0_228)

					if not var1_228 or var1_228:isEnd() then
						return
					end

					local var2_228 = arg0_202.count

					if var1_228:IsLimitExpItem(arg0_202.id) then
						var2_228 = var1_228:FilterExp(var2_228)
						var2_228 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_228:GetTargetGroupId(), var2_228)

						var1_228:AddDailyProgress(var2_228)
					else
						local var3_228 = getProxy(LoveLetterProxy):AddLoveLetterExp(var1_228:GetTargetGroupId(), var2_228)
					end

					getProxy(ActivityProxy):updateActivity(var1_228)
				end,
				[31] = function()
					getProxy(AuctionGameBaseProxy):AddGold(arg0_202.count)
				end,
				[32] = function()
					getProxy(ChapterAutoProxy):AddTicketByItem(ChapterAutoTicket.TYPE.WORLD, arg0_202)
				end,
				[33] = function()
					getProxy(ChapterAutoProxy):AddTicketByItem(ChapterAutoTicket.TYPE.TIME, arg0_202)
				end,
				[34] = function()
					getProxy(ChapterAutoProxy):AddTicketByItem(ChapterAutoTicket.TYPE.MAIN, arg0_202)
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_235 = arg0_202:getConfig("link_id")
					local var1_235 = getProxy(ActivityProxy):getActivityById(var0_235)

					if var1_235 and not var1_235:isEnd() then
						var1_235.data1 = var1_235.data1 + arg0_202.count

						getProxy(ActivityProxy):updateActivity(var1_235)
					end
				end,
				[102] = function()
					local var0_236 = arg0_202:getConfig("link_id")
					local var1_236 = pg.activity_template[var0_236].type

					switch(var1_236, {
						[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = function()
							getProxy(CityRebuildProxy):AddPt(var0_236, arg0_202.count)
						end
					})
				end,
				[103] = function()
					local var0_238 = arg0_202:getConfig("link_id")
					local var1_238 = getProxy(ActivityProxy):getActivityById(var0_238)

					if not var1_238 or var1_238:isEnd() then
						return
					end

					local var2_238 = var1_238:getConfig("type")

					switch(var2_238, {
						[ActivityConst.ACTIVITY_TYPE_TOWN2] = function()
							local var0_239 = getProxy(ActivityProxy)
							local var1_239 = Clone(var0_239:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN2))

							if arg0_202:getConfig("id") == pg.activity_town_2[var1_239.id].bubble_drop[1][2] then
								var1_239:AddGold(arg0_202.count)
								var1_239:AddAllGold(arg0_202.count)
							else
								var1_239:AddGold2(arg0_202.count)
							end

							var0_239:updateActivity(var1_239)
						end,
						[ActivityConst.ACTIVITY_TYPE_MALL] = function()
							local var0_240 = var1_238:getConfig("config_data")[1]
							local var1_240 = arg0_202.id ~= var0_240

							if var1_240 then
								var1_238:AddStaff(arg0_202.id, arg0_202.count)
							else
								var1_238:AddGold(arg0_202.count)
							end

							getProxy(ActivityProxy):updateActivity(var1_238)

							if var1_240 then
								pg.m02:sendNotification(GAME.ACTIVITY_MALL_OP, {
									activity_id = var1_238.id,
									cmd = ActivityMallOPCommand.CMD.GET_STAFF_DATA,
									arg1 = arg0_202.count
								})
							end
						end,
						[ActivityConst.ACTIVITY_TYPE_PT_BUFF] = function()
							assert(var1_238:getDataConfig("pt") == arg0_202.id, "error drop id for pt_buff")

							if var1_238:getDataConfig("type") == 8 then
								var1_238.data1 = var1_238.data1 + arg0_202.count

								getProxy(ActivityProxy):updateActivity(var1_238)
							end
						end,
						[ActivityConst.ACTIVITY_TYPE_PT_BUFF_MARK2] = function()
							assert(var1_238:getDataConfig("pt") == arg0_202.id, "error drop id for pt_buff_mark2")

							if var1_238:getDataConfig("type") == 8 then
								var1_238.data1 = var1_238.data1 + arg0_202.count
							end

							var1_238.data4 = var1_238.data4 + arg0_202.count

							getProxy(ActivityProxy):UpdatePTRank({
								Drop.New({
									type = DROP_TYPE_VITEM,
									id = arg0_202.id,
									count = arg0_202.count
								})
							})
							getProxy(ActivityProxy):updateActivity(var1_238)
						end
					}, function()
						assert(var1_238 .. "对应" .. var2_238 .. "错误")
					end)
				end,
				[104] = function()
					return
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_245)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_245.id, arg0_245.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_246)
			local var0_246 = getProxy(BayProxy)
			local var1_246 = var0_246:getShipById(arg0_246.count)

			if var1_246 then
				var1_246:unlockActivityNpc(0)
				var0_246:updateShip(var1_246)
				getProxy(CollectionProxy):flushCollection(var1_246)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_247)
			nowWorld():GetInventoryProxy():AddItem(arg0_247.id, arg0_247.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_248)
			local var0_248 = getProxy(AttireProxy)
			local var1_248 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_248 = IconFrame.New({
				id = arg0_248.id
			})
			local var3_248 = var1_248 + var2_248:getConfig("time_second")

			var2_248:updateData({
				isNew = true,
				end_time = var3_248
			})
			var0_248:addAttireFrame(var2_248)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_248)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_249)
			local var0_249 = getProxy(AttireProxy)
			local var1_249 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_249 = ChatFrame.New({
				id = arg0_249.id
			})
			local var3_249 = var1_249 + var2_249:getConfig("time_second")

			var2_249:updateData({
				isNew = true,
				end_time = var3_249
			})
			var0_249:addAttireFrame(var2_249)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_249)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_250)
			getProxy(EmojiProxy):addNewEmojiID(arg0_250.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_250:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_251)
			nowWorld():GetCollectionProxy():Unlock(arg0_251.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_252)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_252.id):addPT(arg0_252.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_253)
			local var0_253 = arg0_253.id
			local var1_253 = arg0_253.count
			local var2_253 = getProxy(ShipSkinProxy)
			local var3_253 = var2_253:getSkinById(var0_253)

			if var3_253 and var3_253:isExpireType() then
				local var4_253 = var1_253 + var3_253.endTime
				local var5_253 = ShipSkin.New({
					id = var0_253,
					end_time = var4_253
				})

				var2_253:addSkin(var5_253)
			elseif not var3_253 then
				local var6_253 = var1_253 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_253 = ShipSkin.New({
					id = var0_253,
					end_time = var6_253
				})

				var2_253:addSkin(var7_253)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_254)
			local var0_254 = arg0_254.id
			local var1_254 = pg.benefit_buff_template[var0_254]

			assert(var1_254 and var1_254.act_id > 0, "should exist act id")

			local var2_254 = getProxy(ActivityProxy):getActivityById(var1_254.act_id)

			if var2_254 and not var2_254:isEnd() then
				local var3_254 = var1_254.max_time
				local var4_254 = pg.TimeMgr.GetInstance():GetServerTime() + var3_254

				var2_254:AddBuff(ActivityBuff.New(var2_254.id, var0_254, var4_254))
				getProxy(ActivityProxy):updateActivity(var2_254)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_255)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_256)
			getProxy(ApartmentProxy):ModifyRoom(arg0_256:getConfig("room_id"), function(arg0_257)
				arg0_257:AddFurnitureByID(arg0_256.id)
			end)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_258)
			getProxy(ApartmentProxy):changeGiftCount(arg0_258.id, arg0_258.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_259)
			getProxy(ApartmentProxy):ModifyApartment(arg0_259:getConfig("ship_group"), function(arg0_260)
				arg0_260:addSkin(arg0_259.id)
			end)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_261)
			local var0_261 = getProxy(LivingAreaCoverProxy)
			local var1_261 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_261.id
			})

			var0_261:UpdateCover(var1_261)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_261)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_261.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_262)
			local var0_262 = getProxy(AttireProxy)
			local var1_262 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_262 = CombatUIStyle.New({
				id = arg0_262.id
			})

			var2_262:setUnlock()
			var2_262:setNew()
			var0_262:addAttireFrame(var2_262)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_262)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_263)
			local var0_263 = getProxy(IslandProxy):GetIsland()

			if not var0_263 then
				return
			end

			var0_263:GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_263.id,
				num = arg0_263.count
			}))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_264)
			local var0_264 = getProxy(PlayerProxy):getRawData()
			local var1_264 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_264:updateMedalList({
				{
					key = arg0_264.id,
					value = var1_264
				}
			})
		end
	}

	function var0_0.AddItemDefault(arg0_265)
		if arg0_265.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_265 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_265.type].activity_id)

			if arg0_265.type == DROP_TYPE_RYZA_DROP then
				if var0_265 and not var0_265:isEnd() then
					var0_265:AddItem(AtelierMaterial.New({
						configId = arg0_265.id,
						count = arg0_265.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_265)
				end
			elseif var0_265 and not var0_265:isEnd() then
				var0_265:addVitemNumber(arg0_265.id, arg0_265.count)
				getProxy(ActivityProxy):updateActivity(var0_265)
			end
		elseif arg0_265.type >= DROP_TYPE_ISLAND_ITEM and arg0_265.type <= DROP_TYPE_ISLAND_CARD_DIY then
			if not getProxy(IslandProxy):GetIsland() then
				return
			end

			local var1_265 = {}

			table.insert(var1_265, {
				type = arg0_265.type,
				id = arg0_265.id,
				number = arg0_265.count
			})
			IslandDropHelper.AddItems({
				drop_list = var1_265
			})
		else
			print("can not handle this type>>" .. arg0_265.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_266, arg1_266, arg2_266)
			setText(arg2_266, arg0_266:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_267, arg1_267, arg2_267)
			local var0_267 = arg0_267:getConfig("display")

			if arg0_267:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_267 = string.gsub(var0_267, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_267.extra))
			elseif arg0_267:getConfig("combination_display") ~= nil then
				local var1_267 = arg0_267:getConfig("combination_display")

				if var1_267 and #var1_267 > 0 then
					var0_267 = Item.StaticCombinationDisplay(var1_267)
				end
			end

			setText(arg2_267, SwitchSpecialChar(var0_267, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_268, arg1_268, arg2_268)
			setText(arg2_268, arg0_268:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_269, arg1_269, arg2_269)
			local var0_269 = arg0_269:getConfig("skin_id")
			local var1_269, var2_269, var3_269 = ShipWordHelper.GetWordAndCV(var0_269, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_269, var3_269 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_270, arg1_270, arg2_270)
			local var0_270 = arg0_270:getConfig("skin_id")
			local var1_270, var2_270, var3_270 = ShipWordHelper.GetWordAndCV(var0_270, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_270, var3_270 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_271, arg1_271, arg2_271)
			setText(arg2_271, arg1_271.name or arg0_271:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_272, arg1_272, arg2_272)
			local var0_272 = arg0_272:getConfig("desc")

			for iter0_272, iter1_272 in ipairs({
				arg0_272.count
			}) do
				var0_272 = string.gsub(var0_272, "$" .. iter0_272, iter1_272)
			end

			setText(arg2_272, var0_272)
		end,
		[DROP_TYPE_SKIN] = function(arg0_273, arg1_273, arg2_273)
			setText(arg2_273, arg0_273:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_274, arg1_274, arg2_274)
			setText(arg2_274, arg0_274:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_275, arg1_275, arg2_275)
			local var0_275 = arg0_275:getConfig("desc")
			local var1_275 = _.map(arg0_275:getConfig("equip_type"), function(arg0_276)
				return EquipType.Type2Name2(arg0_276)
			end)

			setText(arg2_275, var0_275 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_275, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_277, arg1_277, arg2_277)
			setText(arg2_277, arg0_277:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_278, arg1_278, arg2_278)
			setText(arg2_278, arg0_278:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_279, arg1_279, arg2_279, arg3_279)
			local var0_279 = WorldCollectionProxy.GetCollectionType(arg0_279.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_279, i18n("world_" .. var0_279 .. "_desc", arg0_279:getConfig("name")))
			setText(arg3_279, i18n("world_" .. var0_279 .. "_name", arg0_279:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_280, arg1_280, arg2_280)
			setText(arg2_280, arg0_280.desc and arg0_280.desc or arg0_280:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_281, arg1_281, arg2_281)
			setText(arg2_281, arg0_281:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_282, arg1_282, arg2_282)
			setText(arg2_282, arg0_282:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_283, arg1_283, arg2_283)
			local var0_283 = string.gsub(arg0_283:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_283.count))

			setText(arg2_283, SwitchSpecialChar(var0_283, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_284, arg1_284, arg2_284)
			setText(arg2_284, arg0_284:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_285, arg1_285, arg2_285)
			setText(arg2_285, arg0_285:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_286, arg1_286, arg2_286)
			setText(arg2_286, arg0_286:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_287, arg1_287, arg2_287)
			setText(arg2_287, arg0_287:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_288, arg1_288, arg2_288)
			setText(arg2_288, arg0_288:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_289, arg1_289, arg2_289)
			setText(arg2_289, arg0_289:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_290, arg1_290, arg2_290)
			setText(arg2_290, "")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_291, arg1_291, arg2_291)
			setText(arg2_291, arg0_291.desc)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_292, arg1_292, arg2_292)
			setText(arg2_292, arg0_292.desc)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_293, arg1_293, arg2_293)
			setText(arg2_293, arg0_293.desc)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_294, arg1_294, arg2_294)
			setText(arg2_294, arg0_294.desc)
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_295, arg1_295, arg2_295)
		if arg0_295.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_295, arg0_295:getConfig("display"))
		else
			setText(arg2_295, arg0_295.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_296, arg1_296, arg2_296)
			if arg0_296.id == PlayerConst.ResStoreGold or arg0_296.id == PlayerConst.ResStoreOil then
				arg2_296 = arg2_296 or {}
				arg2_296.frame = "frame_store"
			end

			updateItem(arg1_296, Item.New({
				id = id2ItemId(arg0_296.id)
			}), arg2_296)
		end,
		[DROP_TYPE_ITEM] = function(arg0_297, arg1_297, arg2_297)
			updateItem(arg1_297, arg0_297:getSubClass(), arg2_297)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_298, arg1_298, arg2_298)
			updateEquipment(arg1_298, arg0_298:getSubClass(), arg2_298)
		end,
		[DROP_TYPE_SHIP] = function(arg0_299, arg1_299, arg2_299)
			updateShip(arg1_299, arg0_299.ship, arg2_299)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_300, arg1_300, arg2_300)
			updateShip(arg1_300, arg0_300.ship, arg2_300)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_301, arg1_301, arg2_301)
			updateFurniture(arg1_301, arg0_301, arg2_301)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_302, arg1_302, arg2_302)
			arg2_302.isWorldBuff = arg0_302.isWorldBuff

			updateStrategy(arg1_302, arg0_302, arg2_302)
		end,
		[DROP_TYPE_SKIN] = function(arg0_303, arg1_303, arg2_303)
			arg2_303.isSkin = true
			arg2_303.isNew = arg0_303.isNew

			updateShip(arg1_303, Ship.New({
				configId = tonumber(arg0_303:getConfig("ship_group") .. "1"),
				skin_id = arg0_303.id
			}), arg2_303)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_304, arg1_304, arg2_304)
			local var0_304 = setmetatable({
				count = arg0_304.count
			}, {
				__index = arg0_304:getConfigTable()
			})

			updateEquipmentSkin(arg1_304, var0_304, arg2_304)
		end,
		[DROP_TYPE_VITEM] = function(arg0_305, arg1_305, arg2_305)
			updateItem(arg1_305, Item.New({
				id = arg0_305.id
			}), arg2_305)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_306, arg1_306, arg2_306)
			updateWorldItem(arg1_306, WorldItem.New({
				id = arg0_306.id
			}), arg2_306)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_307, arg1_307, arg2_307)
			updateWorldCollection(arg1_307, arg0_307, arg2_307)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_308, arg1_308, arg2_308)
			updateAttire(arg1_308, AttireConst.TYPE_CHAT_FRAME, arg0_308:getConfigTable(), arg2_308)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_309, arg1_309, arg2_309)
			updateAttire(arg1_309, AttireConst.TYPE_ICON_FRAME, arg0_309:getConfigTable(), arg2_309)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_310, arg1_310, arg2_310)
			updateEmoji(arg1_310, arg0_310:getConfigTable(), arg2_310)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_311, arg1_311, arg2_311)
			arg2_311.count = 1

			updateItem(arg1_311, arg0_311:getSubClass(), arg2_311)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_312, arg1_312, arg2_312)
			updateSpWeapon(arg1_312, SpWeapon.New({
				id = arg0_312.id
			}), arg2_312)
		end,
		[DROP_TYPE_META_PT] = function(arg0_313, arg1_313, arg2_313)
			updateItem(arg1_313, Item.New({
				id = arg0_313:getConfig("id")
			}), arg2_313)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_314, arg1_314, arg2_314)
			arg2_314.isSkin = true
			arg2_314.isTimeLimit = true
			arg2_314.count = 1

			updateShip(arg1_314, Ship.New({
				configId = tonumber(arg0_314:getConfig("ship_group") .. "1"),
				skin_id = arg0_314.id
			}), arg2_314)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_315, arg1_315, arg2_315)
			AtelierMaterial.UpdateRyzaItem(arg1_315, arg0_315.item, arg2_315)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_316, arg1_316, arg2_316)
			WorkBenchItem.UpdateDrop(arg1_316, arg0_316.item, arg2_316)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_317, arg1_317, arg2_317)
			WorkBenchItem.UpdateDrop(arg1_317, WorkBenchItem.New({
				configId = arg0_317.id,
				count = arg0_317.count
			}), arg2_317)
		end,
		[DROP_TYPE_BUFF] = function(arg0_318, arg1_318, arg2_318)
			updateBuff(arg1_318, arg0_318.id, arg2_318)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_319, arg1_319, arg2_319)
			updateCommander(arg1_319, arg0_319, arg2_319)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_320, arg1_320, arg2_320)
			updateCover(arg1_320, arg0_320, arg2_320)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_321, arg1_321, arg2_321)
			updateAttireCombatUI(arg1_321, AttireConst.TYPE_ICON_FRAME, arg0_321:getConfigTable(), arg2_321)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_322, arg1_322, arg2_322)
			updateActivityMedal(arg1_322, arg0_322:getConfigTable(), arg2_322)
		end
	}

	function var0_0.UpdateDropDefault(arg0_323, arg1_323, arg2_323)
		updateDefaultIconTpl(arg1_323, arg0_323, arg2_323)
	end

	var0_0.UpdateCustomDropCase = {
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_324, arg1_324, arg2_324)
			updateDorm3dIcon(arg1_324, arg0_324, arg2_324)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_325, arg1_325, arg2_325)
			updateDorm3dIcon(arg1_325, arg0_325, arg2_325)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_326, arg1_326, arg2_326)
			updateDorm3dIcon(arg1_326, arg0_326, arg2_326)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_327, arg1_327, arg2_327)
			updateIslandItem(arg1_327, arg0_327, arg2_327)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_328, arg1_328, arg2_328)
			updateIslandUnlock(arg1_328, arg0_328, arg2_328)
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_329, arg1_329, arg2_329)
			updateIslandInvitation(arg1_329, arg0_329, arg2_329)
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_330, arg1_330, arg2_330)
			updateIslandSeasonPt(arg1_330, arg0_330, arg2_330)
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_331, arg1_331, arg2_331)
			updateIslandWatherCollect(arg1_331, arg0_331, arg2_331)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_332, arg1_332, arg2_332)
			updateIslandFurniture(arg1_332, arg0_332, arg2_332)
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_333, arg1_333, arg2_333)
			updateIslandCardDiy(arg1_333, arg0_333, arg2_333)
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_334, arg1_334, arg2_334)
			updateIslandSpeedupTicket(arg1_334, arg0_334, arg2_334)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_335, arg1_335, arg2_335)
			updateItem(arg1_335, Item.New({
				id = arg0_335.id
			}), arg2_335)
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_336, arg1_336, arg2_336)
			updateIslandSkin(arg1_336, arg0_336, arg2_336)
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_337, arg1_337, arg2_337)
			updateIslandDress(arg1_337, arg0_337, arg2_337)
		end
	}

	function var0_0.UpdateCustomDropDefault(arg0_338, arg1_338, arg2_338)
		if arg2_338.style == "dorm" then
			updateDorm3dIcon(arg1_338, arg0_338, arg2_338)
		elseif arg2_338.style == "island" then
			updateIslandDefaultIconTpl(arg1_338, arg0_338, arg2_338)
		else
			warning(string.format("without dropType %d in updateCustomDrop", arg0_338.type))
		end
	end
end

return var0_0
