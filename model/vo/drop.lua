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
			return "island/IslandDressIcon/" .. arg0_7:getConfig("icon")
		end
	}, function()
		return arg0_7:getConfig("icon")
	end)
end

function var0_0.getIslandRarity(arg0_21)
	return switch(arg0_21.type, {
		[DROP_TYPE_ISLAND_ITEM] = function()
			return arg0_21:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function()
			return arg0_21:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function()
			return arg0_21:getConfig("rarity")
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

function var0_0.getCount(arg0_30)
	if arg0_30.type == DROP_TYPE_OPERATION or arg0_30.type == DROP_TYPE_LOVE_LETTER then
		return 1
	else
		return arg0_30.count
	end
end

function var0_0.isLoveLetter(arg0_31)
	return arg0_31.type == DROP_TYPE_LOVE_LETTER or arg0_31.type == DROP_TYPE_ITEM and arg0_31:getConfig("type") == Item.LOVE_LETTER_TYPE
end

function var0_0.getOwnedCount(arg0_32)
	return switch(arg0_32.type, var0_0.CountCase, var0_0.CountDefault, arg0_32)
end

function var0_0.getSubClass(arg0_33)
	return switch(arg0_33.type, var0_0.SubClassCase, var0_0.SubClassDefault, arg0_33)
end

function var0_0.getDropRarity(arg0_34)
	return switch(arg0_34.type, var0_0.RarityCase, var0_0.RarityDefault, arg0_34)
end

function var0_0.getDropRarityDorm(arg0_35)
	return switch(arg0_35.type, var0_0.RarityCase, var0_0.RarityDefaultDorm, arg0_35)
end

function var0_0.DropTrans(arg0_36, ...)
	return switch(arg0_36.type, var0_0.TransCase, var0_0.TransDefault, arg0_36, ...)
end

function var0_0.AddItemOperation(arg0_37)
	return switch(arg0_37.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_37)
end

function var0_0.MsgboxIntroSet(arg0_38, ...)
	return switch(arg0_38.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_38, ...)
end

function var0_0.UpdateDropTpl(arg0_39, ...)
	return switch(arg0_39.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_39, ...)
end

function var0_0.UpdateCustomDropTpl(arg0_40, ...)
	return switch(arg0_40.type, var0_0.UpdateCustomDropCase, var0_0.UpdateCustomDropDefault, arg0_40, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_42)
			local var0_42 = Item.getConfigData(id2ItemId(arg0_42.id))

			arg0_42.desc = var0_42.display

			return var0_42
		end,
		[DROP_TYPE_ITEM] = function(arg0_43)
			local var0_43 = Item.getConfigData(arg0_43.id)

			arg0_43.desc = var0_43.display

			if var0_43.type == Item.LOVE_LETTER_TYPE then
				arg0_43.desc = string.gsub(arg0_43.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_43.extra))
			end

			return var0_43
		end,
		[DROP_TYPE_VITEM] = function(arg0_44)
			local var0_44 = Item.getConfigData(arg0_44.id)

			assert(var0_44, arg0_44.id)

			arg0_44.desc = var0_44.display

			return var0_44
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_45)
			local var0_45 = Item.getConfigData(arg0_45.id)

			arg0_45.desc = string.gsub(var0_45.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_45.count))

			return var0_45
		end,
		[DROP_TYPE_EQUIP] = function(arg0_46)
			local var0_46 = Equipment.getConfigData(arg0_46.id)

			arg0_46.desc = var0_46.descrip

			return var0_46
		end,
		[DROP_TYPE_SHIP] = function(arg0_47)
			local var0_47 = pg.ship_data_statistics[arg0_47.id]
			local var1_47, var2_47, var3_47 = ShipWordHelper.GetWordAndCV(var0_47.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_47.desc = var3_47 or i18n("ship_drop_desc_default")
			arg0_47.ship = Ship.New({
				configId = arg0_47.id,
				skin_id = arg0_47.skinId,
				propose = arg0_47.propose
			})
			arg0_47.ship.remoulded = arg0_47.remoulded
			arg0_47.ship.virgin = arg0_47.virgin

			return var0_47
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_48)
			local var0_48 = pg.furniture_data_template[arg0_48.id]

			arg0_48.desc = var0_48.describe

			return var0_48
		end,
		[DROP_TYPE_SKIN] = function(arg0_49)
			local var0_49 = pg.ship_skin_template[arg0_49.id]

			if var0_49.skin_type == ShipSkin.SKIN_TYPE_TB then
				local var1_49, var2_49, var3_49 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_49.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_49.desc = var3_49
			else
				local var4_49, var5_49, var6_49 = ShipWordHelper.GetWordAndCV(arg0_49.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_49.desc = var6_49
			end

			return var0_49
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_50)
			local var0_50 = pg.ship_skin_template[arg0_50.id]

			if var0_50.skin_type == ShipSKin.SKIN_TYPE_TB then
				local var1_50, var2_50, var3_50 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_50.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_50.desc = var3_50
			else
				local var4_50, var5_50, var6_50 = ShipWordHelper.GetWordAndCV(arg0_50.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_50.desc = var6_50
			end

			return var0_50
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_51)
			local var0_51 = pg.equip_skin_template[arg0_51.id]

			arg0_51.desc = var0_51.desc

			return var0_51
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_52)
			local var0_52 = pg.world_item_data_template[arg0_52.id]

			arg0_52.desc = var0_52.display

			return var0_52
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_53)
			local var0_53 = pg.item_data_frame[arg0_53.id]

			arg0_53.desc = var0_53.desc

			return var0_53
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_54)
			return pg.item_data_chat[arg0_54.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_55)
			local var0_55 = pg.spweapon_data_statistics[arg0_55.id]

			arg0_55.desc = var0_55.descrip

			return var0_55
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_56)
			local var0_56 = pg.activity_ryza_item[arg0_56.id]

			arg0_56.item = AtelierMaterial.New({
				configId = arg0_56.id
			})
			arg0_56.desc = arg0_56.item:GetDesc()

			return var0_56
		end,
		[DROP_TYPE_OPERATION] = function(arg0_57)
			arg0_57.ship = getProxy(BayProxy):getShipById(arg0_57.count)

			local var0_57 = pg.ship_data_statistics[arg0_57.ship.configId]
			local var1_57, var2_57, var3_57 = ShipWordHelper.GetWordAndCV(var0_57.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_57.desc = var3_57 or i18n("ship_drop_desc_default")

			return var0_57
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_58)
			return arg0_58.isWorldBuff and pg.world_SLGbuff_data[arg0_58.id] or pg.strategy_data_template[arg0_58.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_59)
			local var0_59 = pg.emoji_template[arg0_59.id]

			arg0_59.name = var0_59.item_name
			arg0_59.desc = var0_59.item_desc

			return var0_59
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_60)
			local var0_60 = WorldCollectionProxy.GetCollectionTemplate(arg0_60.id)

			arg0_60.desc = var0_60.name

			return var0_60
		end,
		[DROP_TYPE_META_PT] = function(arg0_61)
			local var0_61 = pg.ship_strengthen_meta[arg0_61.id]
			local var1_61 = Item.getConfigData(var0_61.itemid)

			arg0_61.desc = var1_61.display

			return var1_61
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_62)
			local var0_62 = pg.activity_workbench_item[arg0_62.id]

			arg0_62.item = WorkBenchItem.New({
				configId = arg0_62.id
			})
			arg0_62.desc = arg0_62.item:GetDesc()

			return var0_62
		end,
		[DROP_TYPE_BUFF] = function(arg0_63)
			local var0_63 = pg.benefit_buff_template[arg0_63.id]

			arg0_63.desc = var0_63.desc

			return var0_63
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_64)
			local var0_64 = pg.commander_data_template[arg0_64.id]

			arg0_64.desc = var0_64.desc

			return var0_64
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_65)
			local var0_65 = pg.island_item_data_template[arg0_65.id]

			arg0_65.desc = ""

			return var0_65
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_66)
			local var0_66 = pg.island_ability_template[arg0_66.id]

			arg0_66.desc = ""

			return var0_66
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_67)
			local var0_67 = pg.island_chara_template[arg0_67.id]

			arg0_67.desc = ""

			return var0_67
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_68)
			local var0_68 = pg.island_furniture_template[arg0_68.id]

			arg0_68.desc = ""

			return var0_68
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_69)
			local var0_69 = pg.island_dress_template[arg0_69.id]

			arg0_69.desc = ""

			return var0_69
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_70)
			local var0_70 = pg.island_skin_template[arg0_70.id]

			arg0_70.desc = ""

			return var0_70
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_71)
			local var0_71 = pg.island_action[arg0_71.id]

			arg0_71.desc = ""

			return var0_71
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_72)
			local var0_72 = pg.island_speedup_ticket[arg0_72.id]

			arg0_72.desc = var0_72.desc

			return var0_72
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_73)
			return pg.island_card_diy[arg0_73.id]
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_74)
			return pg.drop_data_restore[arg0_74.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_75)
			local var0_75 = pg.dorm3d_furniture_template[arg0_75.id]

			arg0_75.desc = var0_75.desc

			return var0_75
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_76)
			local var0_76 = pg.dorm3d_gift[arg0_76.id]

			arg0_76.desc = var0_76.display

			return var0_76
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_77)
			local var0_77 = pg.dorm3d_resource[arg0_77.id]

			arg0_77.desc = ""

			return var0_77
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_78)
			local var0_78 = pg.livingarea_cover[arg0_78.id]

			arg0_78.desc = var0_78.desc

			return var0_78
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_79)
			return pg.item_data_battleui[arg0_79.id]
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_80)
			local var0_80 = pg.activity_medal_template[arg0_80.id].item

			return pg.item_virtual_data_statistics[var0_80]
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_81)
			local var0_81 = Item.getConfigData(arg0_81.id)

			assert(var0_81, arg0_81.id)

			arg0_81.desc = var0_81.display

			return var0_81
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_82)
			return pg.island_collection[arg0_82.id]
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_83)
			return getIslandSeasonPtInfo()
		end
	}

	function var0_0.ConfigDefault(arg0_84)
		local var0_84 = arg0_84.type

		if tonumber(var0_84) and var0_84 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_84 = pg.activity_drop_type[var0_84].relevance

			return var1_84 and pg[var1_84][arg0_84.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_85)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_85.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_86)
			local var0_86 = getProxy(BagProxy):getItemCountById(arg0_86.id)

			if arg0_86:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_86, 1), true
			else
				return var0_86, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_87)
			local var0_87 = arg0_87:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_87], "equip groupId not exist")

			local var1_87 = pg.equip_data_template.get_id_list_by_group[var0_87]

			return underscore.reduce(var1_87, 0, function(arg0_88, arg1_88)
				local var0_88 = getProxy(EquipmentProxy):getEquipmentById(arg1_88)

				return arg0_88 + (var0_88 and var0_88.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_88)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_89)
			return getProxy(BayProxy):getConfigShipCount(arg0_89.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_90)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_90.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_91)
			return arg0_91.count, tobool(arg0_91.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_92)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_92.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_93)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_93.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_94)
			local var0_94 = arg0_94:getConfig("virtual_type")

			return switch(var0_94, {
				[22] = function()
					local var0_95 = getProxy(ActivityProxy):getActivityById(arg0_94:getConfig("link_id"))

					return var0_95 and var0_95.data1 or 0, true
				end,
				[101] = function()
					local var0_96 = getProxy(ActivityProxy):getActivityById(arg0_94:getConfig("link_id"))

					return var0_96 and var0_96.data1 or 0
				end
			}, function()
				return nil
			end)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_98)
			local var0_98 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_98.id)

			return (var0_98 and var0_98.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_98.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_99)
			local var0_99 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_99.type].activity_id)

			if not var0_99 then
				return 0
			end

			local var1_99 = var0_99:GetItemById(arg0_99.id)

			return var1_99 and var1_99.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_100)
			local var0_100 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_100.id)

			return var0_100 and (not var0_100:expiredType() or not not var0_100:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_101)
			local var0_101 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_101.id)

			return var0_101 and (not var0_101:expiredType() or not not var0_101:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_102)
			local var0_102 = nowWorld()

			if var0_102.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_102:GetInventoryProxy():GetItemCount(arg0_102.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_103)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_103.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_104)
			local var0_104 = getProxy(LivingAreaCoverProxy):GetCover(arg0_104.id)

			return var0_104 and var0_104:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_105)
			return getProxy(ApartmentProxy):getGiftCount(arg0_105.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_106)
			local var0_106 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_106.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_107)
			local var0_107 = 0
			local var1_107 = getProxy(IslandProxy):GetIsland()

			if var1_107 then
				var0_107 = var1_107:GetInventoryAgency():GetOwnCount(arg0_107.id)
			end

			return var0_107
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_108)
			return 0
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_109)
			return 0
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_110)
			local var0_110 = getProxy(IslandProxy):GetIsland()

			if var0_110 then
				local var1_110 = var0_110:GetAgoraAgency():GetFurnitures()

				for iter0_110, iter1_110 in ipairs(var1_110) do
					if iter1_110.id == arg0_110.id then
						return iter1_110.count
					end
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_111)
			local var0_111 = getProxy(IslandProxy):GetIsland()

			if var0_111 then
				local var1_111 = arg0_111:getConfig("belongto")

				if var1_111 == 1 then
					return var0_111:GetDressUpAgency():CheckOwnDress(arg0_111.id) and 1 or 0
				elseif var1_111 == 2 then
					return var0_111:GetCharacterAgency():GetDressIdRealCount(arg0_111.id)
				end
			end

			return 0
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_112)
			local var0_112 = getProxy(IslandProxy):GetIsland()

			if var0_112 then
				return var0_112:GetCharacterAgency():CheckSkinIsOwned(arg0_112.id) and 1 or 0
			end

			return 0
		end
	}

	function var0_0.CountDefault(arg0_113)
		local var0_113 = arg0_113.type

		if var0_113 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_113].activity_id):getVitemNumber(arg0_113.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_114)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_115)
			return Item.New(arg0_115)
		end,
		[DROP_TYPE_VITEM] = function(arg0_116)
			return Item.New(arg0_116)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_117)
			return Equipment.New(arg0_117)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_118)
			return Item.New({
				count = 1,
				id = arg0_118.id,
				extra = arg0_118.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_119)
			return WorldItem.New(arg0_119)
		end
	}

	function var0_0.SubClassDefault(arg0_120)
		assert(false, string.format("drop type %d without subClass", arg0_120.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_121)
			return arg0_121:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_122)
			return arg0_122:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_123)
			return arg0_123:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_124)
			return arg0_124:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_125)
			return arg0_125:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_126)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_127)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_128)
			return arg0_128:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_129)
			return arg0_129:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_130)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_131)
			return arg0_131:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_132)
			return arg0_132:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_133)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_134)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_135)
			return arg0_135:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_136)
			return arg0_136:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_137)
			return arg0_137:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_138)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_139)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_140)
			return arg0_140:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_141)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_142)
			return ItemRarity.Gold
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_143)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_144)
		return arg0_144:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_145)
		return arg0_145:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_146)
			local var0_146 = Drop.New({
				type = arg0_146:getConfig("type"),
				id = arg0_146:getConfig("resource_type"),
				count = arg0_146:getConfig("resource_num") * arg0_146.count
			})
			local var1_146 = Drop.New({
				type = arg0_146:getConfig("target_type"),
				id = arg0_146:getConfig("target_id"),
				count = arg0_146.count
			})

			PlayerConst.UpdateLinkActivity({
				var1_146
			})

			var0_146.name = string.format("%s(%s)", var0_146:getName(), var1_146:getName())

			return var0_146
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_147)
			for iter0_147, iter1_147 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_147.id].pt == arg0_147.id then
					return nil, arg0_147
				end
			end

			return arg0_147
		end,
		[DROP_TYPE_OPERATION] = function(arg0_148)
			if arg0_148.id ~= 3 then
				return nil
			end

			return arg0_148
		end,
		[DROP_TYPE_EMOJI] = function(arg0_149)
			return nil, arg0_149
		end,
		[DROP_TYPE_VITEM] = function(arg0_150, arg1_150, arg2_150)
			assert(arg0_150:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_150.id)

			return switch(arg0_150:getConfig("virtual_type"), {
				function()
					if arg0_150:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_150
					end

					return arg0_150
				end,
				[6] = function()
					local var0_152 = arg2_150.taskId
					local var1_152 = getProxy(ActivityProxy)
					local var2_152 = var1_152:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_152 then
						local var3_152 = var2_152.data1KeyValueList[1]

						var3_152[var0_152] = defaultValue(var3_152[var0_152], 0) + arg0_150.count

						var1_152:updateActivity(var2_152)
					end

					return nil, arg0_150
				end,
				[13] = function()
					local var0_153 = arg0_150:getName()
					local var1_153 = getProxy(ActivityProxy):getActivityById(arg0_150:getConfig("link_id"))

					if not var1_153 or var1_153:isEnd() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_153))

						return nil
					elseif var1_153:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_153))

						return nil
					else
						return arg0_150, nil
					end
				end,
				[21] = function()
					return nil, arg0_150
				end,
				[28] = function()
					local var0_155 = Drop.New({
						type = arg0_150.type,
						id = arg0_150.id,
						count = math.floor(arg0_150.count / 1000)
					})
					local var1_155 = Drop.New({
						type = arg0_150.type,
						id = arg0_150.id,
						count = arg0_150.count - math.floor(arg0_150.count / 1000)
					})

					return var0_155, var1_155
				end
			}, function()
				return arg0_150
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_157, arg1_157)
			if Ship.isMetaShipByConfigID(arg0_157.id) and Player.isMetaShipNeedToTrans(arg0_157.id) then
				local var0_157 = table.indexof(arg1_157, arg0_157.id, 1)

				if var0_157 then
					table.remove(arg1_157, var0_157)
				else
					local var1_157 = Player.metaShip2Res(arg0_157.id)
					local var2_157 = Drop.New(var1_157[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_157.id, var2_157)

					return arg0_157, var2_157
				end
			end

			return arg0_157
		end,
		[DROP_TYPE_SKIN] = function(arg0_158)
			arg0_158.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_158.id)

			return arg0_158
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_159)
			local var0_159 = getProxy(PlayerProxy):getRawData()
			local var1_159 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_159:updateMedalList({
				{
					key = arg0_159.id,
					value = var1_159
				}
			})

			return arg0_159
		end,
		[DROP_TYPE_BUFF] = function(arg0_160)
			return nil, arg0_160
		end
	}

	function var0_0.TransDefault(arg0_161)
		return arg0_161
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_162)
			local var0_162 = id2res(arg0_162.id)

			assert(var0_162, "res should be defined: " .. arg0_162.id)

			local var1_162 = getProxy(PlayerProxy)
			local var2_162 = var1_162:getData()

			var2_162:addResources({
				[var0_162] = arg0_162.count
			})
			var1_162:updatePlayer(var2_162)
		end,
		[DROP_TYPE_ITEM] = function(arg0_163)
			if arg0_163:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_163 = getProxy(BagProxy):getItemCountById(arg0_163.id)
				local var1_163 = math.min(arg0_163:getConfig("max_num") - var0_163, arg0_163.count)

				if var1_163 > 0 then
					getProxy(BagProxy):addItemById(arg0_163.id, var1_163)
				end
			else
				getProxy(BagProxy):addItemById(arg0_163.id, arg0_163.count, arg0_163.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_164)
			local var0_164 = arg0_164:getSubClass()

			getProxy(BagProxy):addItemById(var0_164.id, var0_164.count, var0_164.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_165)
			getProxy(EquipmentProxy):addEquipmentById(arg0_165.id, arg0_165.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_166)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_167)
			local var0_167 = getProxy(DormProxy)
			local var1_167 = Furniture.New({
				id = arg0_167.id,
				count = arg0_167.count
			})

			if var1_167:isRecordTime() then
				var1_167.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_167:AddFurniture(var1_167)
		end,
		[DROP_TYPE_SKIN] = function(arg0_168)
			local var0_168 = getProxy(ShipSkinProxy)
			local var1_168 = ShipSkin.New({
				id = arg0_168.id
			})

			var0_168:addSkin(var1_168)
		end,
		[DROP_TYPE_VITEM] = function(arg0_169)
			arg0_169 = arg0_169:getSubClass()

			assert(arg0_169:isVirtualItem(), "item type error(virtual item)>>" .. arg0_169.id)
			switch(arg0_169:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_169.id, arg0_169.count)
				end,
				function()
					local var0_171 = getProxy(ActivityProxy)
					local var1_171 = arg0_169:getConfig("link_id")
					local var2_171

					if var1_171 > 0 then
						var2_171 = var0_171:getActivityById(var1_171)
					else
						var2_171 = var0_171:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_171 and not var2_171:isEnd() then
						if not table.contains(var2_171.data1_list, arg0_169.id) then
							table.insert(var2_171.data1_list, arg0_169.id)
						end

						var0_171:updateActivity(var2_171)
					end
				end,
				function()
					local var0_172 = getProxy(ActivityProxy)
					local var1_172 = var0_172:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_172, iter1_172 in ipairs(var1_172) do
						iter1_172.data1 = iter1_172.data1 + arg0_169.count

						local var2_172 = iter1_172:getConfig("config_id")
						local var3_172 = pg.activity_vote[var2_172]

						if var3_172 and var3_172.ticket_id_period == arg0_169.id then
							iter1_172.data3 = iter1_172.data3 + arg0_169.count
						end

						var0_172:updateActivity(iter1_172)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_169.id,
							ptCount = arg0_169.count
						})
					end
				end,
				[4] = function()
					local var0_173 = getProxy(ColoringProxy):getColorItems()

					var0_173[arg0_169.id] = (var0_173[arg0_169.id] or 0) + arg0_169.count
				end,
				[6] = function()
					local var0_174 = getProxy(ActivityProxy)
					local var1_174 = var0_174:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_174 then
						var1_174.data3 = var1_174.data3 + arg0_169.count

						var0_174:updateActivity(var1_174)
					end
				end,
				[7] = function()
					local var0_175 = getProxy(ChapterProxy)

					var0_175:updateRemasterTicketsNum(math.min(var0_175.remasterTickets + arg0_169.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_176 = getProxy(ActivityProxy)
					local var1_176 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_176 then
						var1_176.data1_list[1] = var1_176.data1_list[1] + arg0_169.count

						var0_176:updateActivity(var1_176)
					end
				end,
				[11] = function()
					local var0_177 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_177 and not var0_177:isEnd() then
						var0_177.data1 = var0_177.data1 + arg0_169.count
					end
				end,
				[12] = function()
					local var0_178 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_178 and not var0_178:isEnd() then
						var0_178.data1KeyValueList[1][arg0_169.id] = (var0_178.data1KeyValueList[1][arg0_169.id] or 0) + arg0_169.count
					end
				end,
				[13] = function()
					local var0_179 = getProxy(ActivityProxy):getActivityById(arg0_169:getConfig("link_id"))

					if var0_179:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

						return
					end

					var0_179.data1 = var0_179.data1 + arg0_169.count

					getProxy(ActivityProxy):updateActivity(var0_179)
				end,
				[14] = function()
					local var0_180 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_169.id then
						var0_180:AddSummonPt(arg0_169.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_169.id then
						var0_180:AddSummonPtOld(arg0_169.count)
					end
				end,
				[15] = function()
					local var0_181 = getProxy(ActivityProxy)
					local var1_181 = var0_181:getActivityById(arg0_169:getConfig("link_id"))

					if not var1_181 or var1_181:isEnd() then
						return
					end

					if var1_181:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_181 = pg.activity_event_grid[var1_181.data1]

						if arg0_169.id == var2_181.ticket_item then
							var1_181.data2 = var1_181.data2 + arg0_169.count
						elseif arg0_169.id == var2_181.explore_item then
							var1_181.data3 = var1_181.data3 + arg0_169.count
						end
					elseif var1_181:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_181.data3 = var1_181.data3 + arg0_169.count
					end

					var0_181:updateActivity(var1_181)
				end,
				[16] = function()
					local var0_182 = getProxy(ActivityProxy)
					local var1_182 = var0_182:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_182, iter1_182 in pairs(var1_182) do
						if iter1_182 and not iter1_182:isEnd() and arg0_169.id == iter1_182:getConfig("config_id") then
							iter1_182.data1 = iter1_182.data1 + arg0_169.count

							var0_182:updateActivity(iter1_182)
						end
					end
				end,
				[20] = function()
					local var0_183 = getProxy(BagProxy)
					local var1_183 = pg.gameset.urpt_chapter_max.description
					local var2_183 = var1_183[1]
					local var3_183 = var1_183[2]
					local var4_183 = var0_183:GetLimitCntById(var2_183)
					local var5_183 = math.min(var3_183 - var4_183, arg0_169.count)

					if var5_183 > 0 then
						var0_183:addItemById(var2_183, var5_183)
						var0_183:AddLimitCnt(var2_183, var5_183)
					end
				end,
				[21] = function()
					local var0_184 = getProxy(ActivityProxy)
					local var1_184 = var0_184:getActivityById(arg0_169:getConfig("link_id"))

					if var1_184 and not var1_184:isEnd() then
						var1_184.data2 = 1

						var0_184:updateActivity(var1_184)
					end
				end,
				[22] = function()
					local var0_185 = getProxy(ActivityProxy)
					local var1_185 = var0_185:getActivityById(arg0_169:getConfig("link_id"))

					if var1_185 and not var1_185:isEnd() then
						var1_185.data1 = var1_185.data1 + arg0_169.count

						var0_185:updateActivity(var1_185)
					end
				end,
				[23] = function()
					local var0_186 = (function()
						for iter0_187, iter1_187 in ipairs(pg.gameset.package_lv.description) do
							if arg0_169.id == iter1_187[1] then
								return iter1_187[2]
							end
						end
					end)()

					assert(var0_186)

					local var1_186 = getProxy(PlayerProxy)
					local var2_186 = var1_186:getData()

					var2_186:addExpToLevel(var0_186)
					var1_186:updatePlayer(var2_186)
				end,
				[24] = function()
					local var0_188 = arg0_169:getConfig("link_id")
					local var1_188 = getProxy(ActivityProxy):getActivityById(var0_188)

					if var1_188 and not var1_188:isEnd() and var1_188:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_188.data2 = var1_188.data2 + arg0_169.count

						getProxy(ActivityProxy):updateActivity(var1_188)
					end
				end,
				[25] = function()
					local var0_189 = getProxy(ActivityProxy)
					local var1_189 = var0_189:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_189 and not var1_189:isEnd() then
						var1_189.data1 = var1_189.data1 - 1

						if not table.contains(var1_189.data1_list, arg0_169.id) then
							table.insert(var1_189.data1_list, arg0_169.id)
						end

						var0_189:updateActivity(var1_189)

						local var2_189 = arg0_169:getConfig("link_id")

						if var2_189 > 0 then
							local var3_189 = var0_189:getActivityById(var2_189)

							if var3_189 and not var3_189:isEnd() then
								var3_189.data1 = var3_189.data1 + 1

								var0_189:updateActivity(var3_189)
							end
						end
					end
				end,
				[26] = function()
					local var0_190 = getProxy(ActivityProxy)
					local var1_190 = Clone(var0_190:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_190 and not var1_190:isEnd() then
						var1_190.data1 = var1_190.data1 + arg0_169.count

						var0_190:updateActivity(var1_190)
					end
				end,
				[27] = function()
					local var0_191 = getProxy(ActivityProxy)
					local var1_191 = Clone(var0_191:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_191 and not var1_191:isEnd() then
						var1_191:AddExp(arg0_169.count)
						var0_191:updateActivity(var1_191)
					end
				end,
				[28] = function()
					local var0_192 = getProxy(ActivityProxy)
					local var1_192 = Clone(var0_192:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_192 and not var1_192:isEnd() then
						var1_192:AddGold(arg0_169.count)
						var0_192:updateActivity(var1_192)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_195 = arg0_169:getConfig("link_id")
					local var1_195 = getProxy(ActivityProxy):getActivityById(var0_195)

					if var1_195 and not var1_195:isEnd() then
						var1_195.data1 = var1_195.data1 + arg0_169.count

						getProxy(ActivityProxy):updateActivity(var1_195)
					end
				end,
				[102] = function()
					local var0_196 = arg0_169:getConfig("link_id")
					local var1_196 = pg.activity_template[var0_196].type

					switch(var1_196, {
						[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = function()
							getProxy(CityRebuildProxy):AddPt(var0_196, arg0_169.count)
						end
					})
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_198)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_198.id, arg0_198.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_199)
			local var0_199 = getProxy(BayProxy)
			local var1_199 = var0_199:getShipById(arg0_199.count)

			if var1_199 then
				var1_199:unlockActivityNpc(0)
				var0_199:updateShip(var1_199)
				getProxy(CollectionProxy):flushCollection(var1_199)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_200)
			nowWorld():GetInventoryProxy():AddItem(arg0_200.id, arg0_200.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_201)
			local var0_201 = getProxy(AttireProxy)
			local var1_201 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_201 = IconFrame.New({
				id = arg0_201.id
			})
			local var3_201 = var1_201 + var2_201:getConfig("time_second")

			var2_201:updateData({
				isNew = true,
				end_time = var3_201
			})
			var0_201:addAttireFrame(var2_201)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_201)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_202)
			local var0_202 = getProxy(AttireProxy)
			local var1_202 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_202 = ChatFrame.New({
				id = arg0_202.id
			})
			local var3_202 = var1_202 + var2_202:getConfig("time_second")

			var2_202:updateData({
				isNew = true,
				end_time = var3_202
			})
			var0_202:addAttireFrame(var2_202)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_202)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_203)
			getProxy(EmojiProxy):addNewEmojiID(arg0_203.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_203:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_204)
			nowWorld():GetCollectionProxy():Unlock(arg0_204.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_205)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_205.id):addPT(arg0_205.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_206)
			local var0_206 = arg0_206.id
			local var1_206 = arg0_206.count
			local var2_206 = getProxy(ShipSkinProxy)
			local var3_206 = var2_206:getSkinById(var0_206)

			if var3_206 and var3_206:isExpireType() then
				local var4_206 = var1_206 + var3_206.endTime
				local var5_206 = ShipSkin.New({
					id = var0_206,
					end_time = var4_206
				})

				var2_206:addSkin(var5_206)
			elseif not var3_206 then
				local var6_206 = var1_206 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_206 = ShipSkin.New({
					id = var0_206,
					end_time = var6_206
				})

				var2_206:addSkin(var7_206)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_207)
			local var0_207 = arg0_207.id
			local var1_207 = pg.benefit_buff_template[var0_207]

			assert(var1_207 and var1_207.act_id > 0, "should exist act id")

			local var2_207 = getProxy(ActivityProxy):getActivityById(var1_207.act_id)

			if var2_207 and not var2_207:isEnd() then
				local var3_207 = var1_207.max_time
				local var4_207 = pg.TimeMgr.GetInstance():GetServerTime() + var3_207

				var2_207:AddBuff(ActivityBuff.New(var2_207.id, var0_207, var4_207))
				getProxy(ActivityProxy):updateActivity(var2_207)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_208)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_209)
			getProxy(ApartmentProxy):ModifyRoom(arg0_209:getConfig("room_id"), function(arg0_210)
				arg0_210:AddFurnitureByID(arg0_209.id)
			end)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_211)
			getProxy(ApartmentProxy):changeGiftCount(arg0_211.id, arg0_211.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_212)
			getProxy(ApartmentProxy):ModifyApartment(arg0_212:getConfig("ship_group"), function(arg0_213)
				arg0_213:addSkin(arg0_212.id)
			end)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_214)
			local var0_214 = getProxy(LivingAreaCoverProxy)
			local var1_214 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_214.id
			})

			var0_214:UpdateCover(var1_214)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_214)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_214.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_215)
			local var0_215 = getProxy(AttireProxy)
			local var1_215 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_215 = CombatUIStyle.New({
				id = arg0_215.id
			})

			var2_215:setUnlock()
			var2_215:setNew()
			var0_215:addAttireFrame(var2_215)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_215)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_216)
			local var0_216 = getProxy(IslandProxy):GetIsland()

			if not var0_216 then
				return
			end

			var0_216:GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_216.id,
				num = arg0_216.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_217)
		if arg0_217.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_217 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_217.type].activity_id)

			if arg0_217.type == DROP_TYPE_RYZA_DROP then
				if var0_217 and not var0_217:isEnd() then
					var0_217:AddItem(AtelierMaterial.New({
						configId = arg0_217.id,
						count = arg0_217.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_217)
				end
			elseif var0_217 and not var0_217:isEnd() then
				var0_217:addVitemNumber(arg0_217.id, arg0_217.count)
				getProxy(ActivityProxy):updateActivity(var0_217)
			end
		else
			print("can not handle this type>>" .. arg0_217.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_218, arg1_218, arg2_218)
			setText(arg2_218, arg0_218:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_219, arg1_219, arg2_219)
			local var0_219 = arg0_219:getConfig("display")

			if arg0_219:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_219 = string.gsub(var0_219, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_219.extra))
			elseif arg0_219:getConfig("combination_display") ~= nil then
				local var1_219 = arg0_219:getConfig("combination_display")

				if var1_219 and #var1_219 > 0 then
					var0_219 = Item.StaticCombinationDisplay(var1_219)
				end
			end

			setText(arg2_219, SwitchSpecialChar(var0_219, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_220, arg1_220, arg2_220)
			setText(arg2_220, arg0_220:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_221, arg1_221, arg2_221)
			local var0_221 = arg0_221:getConfig("skin_id")
			local var1_221, var2_221, var3_221 = ShipWordHelper.GetWordAndCV(var0_221, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_221, var3_221 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_222, arg1_222, arg2_222)
			local var0_222 = arg0_222:getConfig("skin_id")
			local var1_222, var2_222, var3_222 = ShipWordHelper.GetWordAndCV(var0_222, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_222, var3_222 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_223, arg1_223, arg2_223)
			setText(arg2_223, arg1_223.name or arg0_223:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_224, arg1_224, arg2_224)
			local var0_224 = arg0_224:getConfig("desc")

			for iter0_224, iter1_224 in ipairs({
				arg0_224.count
			}) do
				var0_224 = string.gsub(var0_224, "$" .. iter0_224, iter1_224)
			end

			setText(arg2_224, var0_224)
		end,
		[DROP_TYPE_SKIN] = function(arg0_225, arg1_225, arg2_225)
			setText(arg2_225, arg0_225:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_226, arg1_226, arg2_226)
			setText(arg2_226, arg0_226:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_227, arg1_227, arg2_227)
			local var0_227 = arg0_227:getConfig("desc")
			local var1_227 = _.map(arg0_227:getConfig("equip_type"), function(arg0_228)
				return EquipType.Type2Name2(arg0_228)
			end)

			setText(arg2_227, var0_227 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_227, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_229, arg1_229, arg2_229)
			setText(arg2_229, arg0_229:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_230, arg1_230, arg2_230)
			setText(arg2_230, arg0_230:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_231, arg1_231, arg2_231, arg3_231)
			local var0_231 = WorldCollectionProxy.GetCollectionType(arg0_231.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_231, i18n("world_" .. var0_231 .. "_desc", arg0_231:getConfig("name")))
			setText(arg3_231, i18n("world_" .. var0_231 .. "_name", arg0_231:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_232, arg1_232, arg2_232)
			setText(arg2_232, arg0_232:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_233, arg1_233, arg2_233)
			setText(arg2_233, arg0_233:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_234, arg1_234, arg2_234)
			setText(arg2_234, arg0_234:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_235, arg1_235, arg2_235)
			local var0_235 = string.gsub(arg0_235:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_235.count))

			setText(arg2_235, SwitchSpecialChar(var0_235, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_236, arg1_236, arg2_236)
			setText(arg2_236, arg0_236:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_237, arg1_237, arg2_237)
			setText(arg2_237, arg0_237:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_238, arg1_238, arg2_238)
			setText(arg2_238, arg0_238:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_239, arg1_239, arg2_239)
			setText(arg2_239, arg0_239:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_240, arg1_240, arg2_240)
			setText(arg2_240, arg0_240:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_241, arg1_241, arg2_241)
			setText(arg2_241, arg0_241:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_242, arg1_242, arg2_242)
			setText(arg2_242, "")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_243, arg1_243, arg2_243)
			setText(arg2_243, "")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_244, arg1_244, arg2_244)
			setText(arg2_244, "")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_245, arg1_245, arg2_245)
			setText(arg2_245, "")
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_246, arg1_246, arg2_246)
			setText(arg2_246, "")
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_247, arg1_247, arg2_247)
		if arg0_247.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_247, arg0_247:getConfig("display"))
		else
			setText(arg2_247, arg0_247.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_248, arg1_248, arg2_248)
			if arg0_248.id == PlayerConst.ResStoreGold or arg0_248.id == PlayerConst.ResStoreOil then
				arg2_248 = arg2_248 or {}
				arg2_248.frame = "frame_store"
			end

			updateItem(arg1_248, Item.New({
				id = id2ItemId(arg0_248.id)
			}), arg2_248)
		end,
		[DROP_TYPE_ITEM] = function(arg0_249, arg1_249, arg2_249)
			updateItem(arg1_249, arg0_249:getSubClass(), arg2_249)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_250, arg1_250, arg2_250)
			updateEquipment(arg1_250, arg0_250:getSubClass(), arg2_250)
		end,
		[DROP_TYPE_SHIP] = function(arg0_251, arg1_251, arg2_251)
			updateShip(arg1_251, arg0_251.ship, arg2_251)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_252, arg1_252, arg2_252)
			updateShip(arg1_252, arg0_252.ship, arg2_252)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_253, arg1_253, arg2_253)
			updateFurniture(arg1_253, arg0_253, arg2_253)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_254, arg1_254, arg2_254)
			arg2_254.isWorldBuff = arg0_254.isWorldBuff

			updateStrategy(arg1_254, arg0_254, arg2_254)
		end,
		[DROP_TYPE_SKIN] = function(arg0_255, arg1_255, arg2_255)
			arg2_255.isSkin = true
			arg2_255.isNew = arg0_255.isNew

			updateShip(arg1_255, Ship.New({
				configId = tonumber(arg0_255:getConfig("ship_group") .. "1"),
				skin_id = arg0_255.id
			}), arg2_255)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_256, arg1_256, arg2_256)
			local var0_256 = setmetatable({
				count = arg0_256.count
			}, {
				__index = arg0_256:getConfigTable()
			})

			updateEquipmentSkin(arg1_256, var0_256, arg2_256)
		end,
		[DROP_TYPE_VITEM] = function(arg0_257, arg1_257, arg2_257)
			updateItem(arg1_257, Item.New({
				id = arg0_257.id
			}), arg2_257)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_258, arg1_258, arg2_258)
			updateWorldItem(arg1_258, WorldItem.New({
				id = arg0_258.id
			}), arg2_258)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_259, arg1_259, arg2_259)
			updateWorldCollection(arg1_259, arg0_259, arg2_259)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_260, arg1_260, arg2_260)
			updateAttire(arg1_260, AttireConst.TYPE_CHAT_FRAME, arg0_260:getConfigTable(), arg2_260)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_261, arg1_261, arg2_261)
			updateAttire(arg1_261, AttireConst.TYPE_ICON_FRAME, arg0_261:getConfigTable(), arg2_261)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_262, arg1_262, arg2_262)
			updateEmoji(arg1_262, arg0_262:getConfigTable(), arg2_262)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_263, arg1_263, arg2_263)
			arg2_263.count = 1

			updateItem(arg1_263, arg0_263:getSubClass(), arg2_263)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_264, arg1_264, arg2_264)
			updateSpWeapon(arg1_264, SpWeapon.New({
				id = arg0_264.id
			}), arg2_264)
		end,
		[DROP_TYPE_META_PT] = function(arg0_265, arg1_265, arg2_265)
			updateItem(arg1_265, Item.New({
				id = arg0_265:getConfig("id")
			}), arg2_265)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_266, arg1_266, arg2_266)
			arg2_266.isSkin = true
			arg2_266.isTimeLimit = true
			arg2_266.count = 1

			updateShip(arg1_266, Ship.New({
				configId = tonumber(arg0_266:getConfig("ship_group") .. "1"),
				skin_id = arg0_266.id
			}), arg2_266)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_267, arg1_267, arg2_267)
			AtelierMaterial.UpdateRyzaItem(arg1_267, arg0_267.item, arg2_267)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_268, arg1_268, arg2_268)
			WorkBenchItem.UpdateDrop(arg1_268, arg0_268.item, arg2_268)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_269, arg1_269, arg2_269)
			WorkBenchItem.UpdateDrop(arg1_269, WorkBenchItem.New({
				configId = arg0_269.id,
				count = arg0_269.count
			}), arg2_269)
		end,
		[DROP_TYPE_BUFF] = function(arg0_270, arg1_270, arg2_270)
			updateBuff(arg1_270, arg0_270.id, arg2_270)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_271, arg1_271, arg2_271)
			updateCommander(arg1_271, arg0_271, arg2_271)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_272, arg1_272, arg2_272)
			updateCover(arg1_272, arg0_272, arg2_272)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_273, arg1_273, arg2_273)
			updateAttireCombatUI(arg1_273, AttireConst.TYPE_ICON_FRAME, arg0_273:getConfigTable(), arg2_273)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_274, arg1_274, arg2_274)
			updateActivityMedal(arg1_274, arg0_274:getConfigTable(), arg2_274)
		end
	}

	function var0_0.UpdateDropDefault(arg0_275, arg1_275, arg2_275)
		updateDefaultIconTpl(arg1_275, arg0_275, arg2_275)
	end

	var0_0.UpdateCustomDropCase = {
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_276, arg1_276, arg2_276)
			updateDorm3dIcon(arg1_276, arg0_276, arg2_276)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_277, arg1_277, arg2_277)
			updateDorm3dIcon(arg1_277, arg0_277, arg2_277)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_278, arg1_278, arg2_278)
			updateDorm3dIcon(arg1_278, arg0_278, arg2_278)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_279, arg1_279, arg2_279)
			updateIslandItem(arg1_279, arg0_279, arg2_279)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_280, arg1_280, arg2_280)
			updateIslandUnlock(arg1_280, arg0_280, arg2_280)
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_281, arg1_281, arg2_281)
			updateIslandInvitation(arg1_281, arg0_281, arg2_281)
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_282, arg1_282, arg2_282)
			updateIslandSeasonPt(arg1_282, arg0_282, arg2_282)
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_283, arg1_283, arg2_283)
			updateIslandWatherCollect(arg1_283, arg0_283, arg2_283)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_284, arg1_284, arg2_284)
			updateIslandFurniture(arg1_284, arg0_284, arg2_284)
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_285, arg1_285, arg2_285)
			updateIslandCardDiy(arg1_285, arg0_285, arg2_285)
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_286, arg1_286, arg2_286)
			updateIslandSpeedupTicket(arg1_286, arg0_286, arg2_286)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_287, arg1_287, arg2_287)
			updateItem(arg1_287, Item.New({
				id = arg0_287.id
			}), arg2_287)
		end
	}

	function var0_0.UpdateCustomDropDefault(arg0_288, arg1_288, arg2_288)
		if arg2_288.style == "dorm" then
			updateDorm3dIcon(arg1_288, arg0_288, arg2_288)
		elseif arg2_288.style == "island" then
			updateIslandDefaultIconTpl(arg1_288, arg0_288, arg2_288)
		else
			warning(string.format("without dropType %d in updateCustomDrop", arg0_288.type))
		end
	end
end

return var0_0
