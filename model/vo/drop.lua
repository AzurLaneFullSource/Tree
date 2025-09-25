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
			return "island/" .. arg0_7:getConfig("icon")
		end
	}, function()
		return arg0_7:getConfig("icon")
	end)
end

function var0_0.getCount(arg0_18)
	if arg0_18.type == DROP_TYPE_OPERATION or arg0_18.type == DROP_TYPE_LOVE_LETTER then
		return 1
	else
		return arg0_18.count
	end
end

function var0_0.isLoveLetter(arg0_19)
	return arg0_19.type == DROP_TYPE_LOVE_LETTER or arg0_19.type == DROP_TYPE_ITEM and arg0_19:getConfig("type") == Item.LOVE_LETTER_TYPE
end

function var0_0.getOwnedCount(arg0_20)
	return switch(arg0_20.type, var0_0.CountCase, var0_0.CountDefault, arg0_20)
end

function var0_0.getSubClass(arg0_21)
	return switch(arg0_21.type, var0_0.SubClassCase, var0_0.SubClassDefault, arg0_21)
end

function var0_0.getDropRarity(arg0_22)
	return switch(arg0_22.type, var0_0.RarityCase, var0_0.RarityDefault, arg0_22)
end

function var0_0.getDropRarityDorm(arg0_23)
	return switch(arg0_23.type, var0_0.RarityCase, var0_0.RarityDefaultDorm, arg0_23)
end

function var0_0.DropTrans(arg0_24, ...)
	return switch(arg0_24.type, var0_0.TransCase, var0_0.TransDefault, arg0_24, ...)
end

function var0_0.AddItemOperation(arg0_25)
	return switch(arg0_25.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_25)
end

function var0_0.MsgboxIntroSet(arg0_26, ...)
	return switch(arg0_26.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_26, ...)
end

function var0_0.UpdateDropTpl(arg0_27, ...)
	return switch(arg0_27.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_27, ...)
end

function var0_0.UpdateCustomDropTpl(arg0_28, ...)
	return switch(arg0_28.type, var0_0.UpdateCustomDropCase, var0_0.UpdateCustomDropDefault, arg0_28, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_30)
			local var0_30 = Item.getConfigData(id2ItemId(arg0_30.id))

			arg0_30.desc = var0_30.display

			return var0_30
		end,
		[DROP_TYPE_ITEM] = function(arg0_31)
			local var0_31 = Item.getConfigData(arg0_31.id)

			arg0_31.desc = var0_31.display

			if var0_31.type == Item.LOVE_LETTER_TYPE then
				arg0_31.desc = string.gsub(arg0_31.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_31.extra))
			end

			return var0_31
		end,
		[DROP_TYPE_VITEM] = function(arg0_32)
			local var0_32 = Item.getConfigData(arg0_32.id)

			assert(var0_32, arg0_32.id)

			arg0_32.desc = var0_32.display

			return var0_32
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_33)
			local var0_33 = Item.getConfigData(arg0_33.id)

			arg0_33.desc = string.gsub(var0_33.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_33.count))

			return var0_33
		end,
		[DROP_TYPE_EQUIP] = function(arg0_34)
			local var0_34 = Equipment.getConfigData(arg0_34.id)

			arg0_34.desc = var0_34.descrip

			return var0_34
		end,
		[DROP_TYPE_SHIP] = function(arg0_35)
			local var0_35 = pg.ship_data_statistics[arg0_35.id]
			local var1_35, var2_35, var3_35 = ShipWordHelper.GetWordAndCV(var0_35.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_35.desc = var3_35 or i18n("ship_drop_desc_default")
			arg0_35.ship = Ship.New({
				configId = arg0_35.id,
				skin_id = arg0_35.skinId,
				propose = arg0_35.propose
			})
			arg0_35.ship.remoulded = arg0_35.remoulded
			arg0_35.ship.virgin = arg0_35.virgin

			return var0_35
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_36)
			local var0_36 = pg.furniture_data_template[arg0_36.id]

			arg0_36.desc = var0_36.describe

			return var0_36
		end,
		[DROP_TYPE_SKIN] = function(arg0_37)
			local var0_37 = pg.ship_skin_template[arg0_37.id]

			if var0_37.skin_type == ShipSkin.SKIN_TYPE_TB then
				local var1_37, var2_37, var3_37 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_37.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_37.desc = var3_37
			else
				local var4_37, var5_37, var6_37 = ShipWordHelper.GetWordAndCV(arg0_37.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_37.desc = var6_37
			end

			return var0_37
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_38)
			local var0_38 = pg.ship_skin_template[arg0_38.id]

			if var0_38.skin_type == ShipSKin.SKIN_TYPE_TB then
				local var1_38, var2_38, var3_38 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg0_38.id), EducateCharWordHelper.WORD_KEY_LOGIN)

				arg0_38.desc = var3_38
			else
				local var4_38, var5_38, var6_38 = ShipWordHelper.GetWordAndCV(arg0_38.id, ShipWordHelper.WORD_TYPE_DROP)

				arg0_38.desc = var6_38
			end

			return var0_38
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_39)
			local var0_39 = pg.equip_skin_template[arg0_39.id]

			arg0_39.desc = var0_39.desc

			return var0_39
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_40)
			local var0_40 = pg.world_item_data_template[arg0_40.id]

			arg0_40.desc = var0_40.display

			return var0_40
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_41)
			local var0_41 = pg.item_data_frame[arg0_41.id]

			arg0_41.desc = var0_41.desc

			return var0_41
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_42)
			return pg.item_data_chat[arg0_42.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_43)
			local var0_43 = pg.spweapon_data_statistics[arg0_43.id]

			arg0_43.desc = var0_43.descrip

			return var0_43
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_44)
			local var0_44 = pg.activity_ryza_item[arg0_44.id]

			arg0_44.item = AtelierMaterial.New({
				configId = arg0_44.id
			})
			arg0_44.desc = arg0_44.item:GetDesc()

			return var0_44
		end,
		[DROP_TYPE_OPERATION] = function(arg0_45)
			arg0_45.ship = getProxy(BayProxy):getShipById(arg0_45.count)

			local var0_45 = pg.ship_data_statistics[arg0_45.ship.configId]
			local var1_45, var2_45, var3_45 = ShipWordHelper.GetWordAndCV(var0_45.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_45.desc = var3_45 or i18n("ship_drop_desc_default")

			return var0_45
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_46)
			return arg0_46.isWorldBuff and pg.world_SLGbuff_data[arg0_46.id] or pg.strategy_data_template[arg0_46.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_47)
			local var0_47 = pg.emoji_template[arg0_47.id]

			arg0_47.name = var0_47.item_name
			arg0_47.desc = var0_47.item_desc

			return var0_47
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_48)
			local var0_48 = WorldCollectionProxy.GetCollectionTemplate(arg0_48.id)

			arg0_48.desc = var0_48.name

			return var0_48
		end,
		[DROP_TYPE_META_PT] = function(arg0_49)
			local var0_49 = pg.ship_strengthen_meta[arg0_49.id]
			local var1_49 = Item.getConfigData(var0_49.itemid)

			arg0_49.desc = var1_49.display

			return var1_49
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_50)
			local var0_50 = pg.activity_workbench_item[arg0_50.id]

			arg0_50.item = WorkBenchItem.New({
				configId = arg0_50.id
			})
			arg0_50.desc = arg0_50.item:GetDesc()

			return var0_50
		end,
		[DROP_TYPE_BUFF] = function(arg0_51)
			local var0_51 = pg.benefit_buff_template[arg0_51.id]

			arg0_51.desc = var0_51.desc

			return var0_51
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_52)
			local var0_52 = pg.commander_data_template[arg0_52.id]

			arg0_52.desc = var0_52.desc

			return var0_52
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_53)
			local var0_53 = pg.island_item_data_template[arg0_53.id]

			arg0_53.desc = ""

			return var0_53
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_54)
			local var0_54 = pg.island_ability_template[arg0_54.id]

			arg0_54.desc = ""

			return var0_54
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_55)
			local var0_55 = pg.island_chara_template[arg0_55.id]

			arg0_55.desc = ""

			return var0_55
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_56)
			local var0_56 = pg.island_furniture_template[arg0_56.id]

			arg0_56.desc = ""

			return var0_56
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_57)
			local var0_57 = pg.island_dress_template[arg0_57.id]

			arg0_57.desc = ""

			return var0_57
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_58)
			local var0_58 = pg.island_skin_template[arg0_58.id]

			arg0_58.desc = ""

			return var0_58
		end,
		[DROP_TYPE_ISLAND_ACTION] = function(arg0_59)
			local var0_59 = pg.island_action[arg0_59.id]

			arg0_59.desc = ""

			return var0_59
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_60)
			local var0_60 = pg.island_speedup_ticket[arg0_60.id]

			arg0_60.desc = ""

			return var0_60
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_61)
			return pg.island_card_diy[arg0_61.id]
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_62)
			return pg.drop_data_restore[arg0_62.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_63)
			local var0_63 = pg.dorm3d_furniture_template[arg0_63.id]

			arg0_63.desc = var0_63.desc

			return var0_63
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_64)
			local var0_64 = pg.dorm3d_gift[arg0_64.id]

			arg0_64.desc = var0_64.display

			return var0_64
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_65)
			local var0_65 = pg.dorm3d_resource[arg0_65.id]

			arg0_65.desc = ""

			return var0_65
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_66)
			local var0_66 = pg.livingarea_cover[arg0_66.id]

			arg0_66.desc = var0_66.desc

			return var0_66
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_67)
			return pg.item_data_battleui[arg0_67.id]
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_68)
			local var0_68 = pg.activity_medal_template[arg0_68.id].item

			return pg.item_virtual_data_statistics[var0_68]
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_69)
			local var0_69 = Item.getConfigData(arg0_69.id)

			assert(var0_69, arg0_69.id)

			arg0_69.desc = var0_69.display

			return var0_69
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_70)
			return pg.island_collection[arg0_70.id]
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_71)
			return getIslandSeasonPtInfo()
		end
	}

	function var0_0.ConfigDefault(arg0_72)
		local var0_72 = arg0_72.type

		if tonumber(var0_72) and var0_72 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_72 = pg.activity_drop_type[var0_72].relevance

			return var1_72 and pg[var1_72][arg0_72.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_73)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_73.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_74)
			local var0_74 = getProxy(BagProxy):getItemCountById(arg0_74.id)

			if arg0_74:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_74, 1), true
			else
				return var0_74, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_75)
			local var0_75 = arg0_75:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_75], "equip groupId not exist")

			local var1_75 = pg.equip_data_template.get_id_list_by_group[var0_75]

			return underscore.reduce(var1_75, 0, function(arg0_76, arg1_76)
				local var0_76 = getProxy(EquipmentProxy):getEquipmentById(arg1_76)

				return arg0_76 + (var0_76 and var0_76.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_76)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_77)
			return getProxy(BayProxy):getConfigShipCount(arg0_77.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_78)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_78.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_79)
			return arg0_79.count, tobool(arg0_79.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_80)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_80.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_81)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_81.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_82)
			local var0_82 = arg0_82:getConfig("virtual_type")

			return switch(var0_82, {
				[22] = function()
					local var0_83 = getProxy(ActivityProxy):getActivityById(arg0_82:getConfig("link_id"))

					return var0_83 and var0_83.data1 or 0, true
				end,
				[101] = function()
					local var0_84 = getProxy(ActivityProxy):getActivityById(arg0_82:getConfig("link_id"))

					return var0_84 and var0_84.data1 or 0
				end
			}, function()
				return nil
			end)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_86)
			local var0_86 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_86.id)

			return (var0_86 and var0_86.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_86.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_87)
			local var0_87 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_87.type].activity_id)

			if not var0_87 then
				return 0
			end

			local var1_87 = var0_87:GetItemById(arg0_87.id)

			return var1_87 and var1_87.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_88)
			local var0_88 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_88.id)

			return var0_88 and (not var0_88:expiredType() or not not var0_88:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_89)
			local var0_89 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_89.id)

			return var0_89 and (not var0_89:expiredType() or not not var0_89:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_90)
			local var0_90 = nowWorld()

			if var0_90.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_90:GetInventoryProxy():GetItemCount(arg0_90.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_91)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_91.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_92)
			local var0_92 = getProxy(LivingAreaCoverProxy):GetCover(arg0_92.id)

			return var0_92 and var0_92:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_93)
			return getProxy(ApartmentProxy):getGiftCount(arg0_93.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_94)
			local var0_94 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_94.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_95)
			local var0_95 = 0
			local var1_95 = getProxy(IslandProxy):GetIsland()

			if var1_95 then
				var0_95 = var1_95:GetInventoryAgency():GetOwnCount(arg0_95.id)
			end

			return var0_95
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_96)
			return 0
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_97)
			return 0
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_98)
			return 0
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_99)
			return 0
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_100)
			return 0
		end
	}

	function var0_0.CountDefault(arg0_101)
		local var0_101 = arg0_101.type

		if var0_101 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_101].activity_id):getVitemNumber(arg0_101.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_102)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_103)
			return Item.New(arg0_103)
		end,
		[DROP_TYPE_VITEM] = function(arg0_104)
			return Item.New(arg0_104)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_105)
			return Equipment.New(arg0_105)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_106)
			return Item.New({
				count = 1,
				id = arg0_106.id,
				extra = arg0_106.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_107)
			return WorldItem.New(arg0_107)
		end
	}

	function var0_0.SubClassDefault(arg0_108)
		assert(false, string.format("drop type %d without subClass", arg0_108.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_109)
			return arg0_109:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_110)
			return arg0_110:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_111)
			return arg0_111:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_112)
			return arg0_112:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_113)
			return arg0_113:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_114)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_115)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_116)
			return arg0_116:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_117)
			return arg0_117:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_118)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_119)
			return arg0_119:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_120)
			return arg0_120:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_121)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_122)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_123)
			return arg0_123:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_124)
			return arg0_124:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_125)
			return arg0_125:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_126)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_127)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_128)
			return arg0_128:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_129)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_130)
			return ItemRarity.Gold
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_131)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_132)
		return arg0_132:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_133)
		return arg0_133:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_134)
			local var0_134 = Drop.New({
				type = arg0_134:getConfig("type"),
				id = arg0_134:getConfig("resource_type"),
				count = arg0_134:getConfig("resource_num") * arg0_134.count
			})
			local var1_134 = Drop.New({
				type = arg0_134:getConfig("target_type"),
				id = arg0_134:getConfig("target_id"),
				count = arg0_134.count
			})

			PlayerConst.UpdateLinkActivity({
				var1_134
			})

			var0_134.name = string.format("%s(%s)", var0_134:getName(), var1_134:getName())

			return var0_134
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_135)
			for iter0_135, iter1_135 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_135.id].pt == arg0_135.id then
					return nil, arg0_135
				end
			end

			return arg0_135
		end,
		[DROP_TYPE_OPERATION] = function(arg0_136)
			if arg0_136.id ~= 3 then
				return nil
			end

			return arg0_136
		end,
		[DROP_TYPE_EMOJI] = function(arg0_137)
			return nil, arg0_137
		end,
		[DROP_TYPE_VITEM] = function(arg0_138, arg1_138, arg2_138)
			assert(arg0_138:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_138.id)

			return switch(arg0_138:getConfig("virtual_type"), {
				function()
					if arg0_138:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_138
					end

					return arg0_138
				end,
				[6] = function()
					local var0_140 = arg2_138.taskId
					local var1_140 = getProxy(ActivityProxy)
					local var2_140 = var1_140:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_140 then
						local var3_140 = var2_140.data1KeyValueList[1]

						var3_140[var0_140] = defaultValue(var3_140[var0_140], 0) + arg0_138.count

						var1_140:updateActivity(var2_140)
					end

					return nil, arg0_138
				end,
				[13] = function()
					local var0_141 = arg0_138:getName()
					local var1_141 = getProxy(ActivityProxy):getActivityById(arg0_138:getConfig("link_id"))

					if not var1_141 or var1_141:isEnd() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_141))

						return nil
					elseif var1_141:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_141))

						return nil
					else
						return arg0_138, nil
					end
				end,
				[21] = function()
					return nil, arg0_138
				end,
				[28] = function()
					local var0_143 = Drop.New({
						type = arg0_138.type,
						id = arg0_138.id,
						count = math.floor(arg0_138.count / 1000)
					})
					local var1_143 = Drop.New({
						type = arg0_138.type,
						id = arg0_138.id,
						count = arg0_138.count - math.floor(arg0_138.count / 1000)
					})

					return var0_143, var1_143
				end
			}, function()
				return arg0_138
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_145, arg1_145)
			if Ship.isMetaShipByConfigID(arg0_145.id) and Player.isMetaShipNeedToTrans(arg0_145.id) then
				local var0_145 = table.indexof(arg1_145, arg0_145.id, 1)

				if var0_145 then
					table.remove(arg1_145, var0_145)
				else
					local var1_145 = Player.metaShip2Res(arg0_145.id)
					local var2_145 = Drop.New(var1_145[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_145.id, var2_145)

					return arg0_145, var2_145
				end
			end

			return arg0_145
		end,
		[DROP_TYPE_SKIN] = function(arg0_146)
			arg0_146.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_146.id)

			return arg0_146
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_147)
			local var0_147 = getProxy(PlayerProxy):getRawData()
			local var1_147 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_147:updateMedalList({
				{
					key = arg0_147.id,
					value = var1_147
				}
			})

			return arg0_147
		end,
		[DROP_TYPE_BUFF] = function(arg0_148)
			return nil, arg0_148
		end
	}

	function var0_0.TransDefault(arg0_149)
		return arg0_149
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_150)
			local var0_150 = id2res(arg0_150.id)

			assert(var0_150, "res should be defined: " .. arg0_150.id)

			local var1_150 = getProxy(PlayerProxy)
			local var2_150 = var1_150:getData()

			var2_150:addResources({
				[var0_150] = arg0_150.count
			})
			var1_150:updatePlayer(var2_150)
		end,
		[DROP_TYPE_ITEM] = function(arg0_151)
			if arg0_151:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_151 = getProxy(BagProxy):getItemCountById(arg0_151.id)
				local var1_151 = math.min(arg0_151:getConfig("max_num") - var0_151, arg0_151.count)

				if var1_151 > 0 then
					getProxy(BagProxy):addItemById(arg0_151.id, var1_151)
				end
			else
				getProxy(BagProxy):addItemById(arg0_151.id, arg0_151.count, arg0_151.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_152)
			local var0_152 = arg0_152:getSubClass()

			getProxy(BagProxy):addItemById(var0_152.id, var0_152.count, var0_152.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_153)
			getProxy(EquipmentProxy):addEquipmentById(arg0_153.id, arg0_153.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_154)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_155)
			local var0_155 = getProxy(DormProxy)
			local var1_155 = Furniture.New({
				id = arg0_155.id,
				count = arg0_155.count
			})

			if var1_155:isRecordTime() then
				var1_155.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_155:AddFurniture(var1_155)
		end,
		[DROP_TYPE_SKIN] = function(arg0_156)
			local var0_156 = getProxy(ShipSkinProxy)
			local var1_156 = ShipSkin.New({
				id = arg0_156.id
			})

			var0_156:addSkin(var1_156)
		end,
		[DROP_TYPE_VITEM] = function(arg0_157)
			arg0_157 = arg0_157:getSubClass()

			assert(arg0_157:isVirtualItem(), "item type error(virtual item)>>" .. arg0_157.id)
			switch(arg0_157:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_157.id, arg0_157.count)
				end,
				function()
					local var0_159 = getProxy(ActivityProxy)
					local var1_159 = arg0_157:getConfig("link_id")
					local var2_159

					if var1_159 > 0 then
						var2_159 = var0_159:getActivityById(var1_159)
					else
						var2_159 = var0_159:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_159 and not var2_159:isEnd() then
						if not table.contains(var2_159.data1_list, arg0_157.id) then
							table.insert(var2_159.data1_list, arg0_157.id)
						end

						var0_159:updateActivity(var2_159)
					end
				end,
				function()
					local var0_160 = getProxy(ActivityProxy)
					local var1_160 = var0_160:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_160, iter1_160 in ipairs(var1_160) do
						iter1_160.data1 = iter1_160.data1 + arg0_157.count

						local var2_160 = iter1_160:getConfig("config_id")
						local var3_160 = pg.activity_vote[var2_160]

						if var3_160 and var3_160.ticket_id_period == arg0_157.id then
							iter1_160.data3 = iter1_160.data3 + arg0_157.count
						end

						var0_160:updateActivity(iter1_160)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_157.id,
							ptCount = arg0_157.count
						})
					end
				end,
				[4] = function()
					local var0_161 = getProxy(ColoringProxy):getColorItems()

					var0_161[arg0_157.id] = (var0_161[arg0_157.id] or 0) + arg0_157.count
				end,
				[6] = function()
					local var0_162 = getProxy(ActivityProxy)
					local var1_162 = var0_162:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_162 then
						var1_162.data3 = var1_162.data3 + arg0_157.count

						var0_162:updateActivity(var1_162)
					end
				end,
				[7] = function()
					local var0_163 = getProxy(ChapterProxy)

					var0_163:updateRemasterTicketsNum(math.min(var0_163.remasterTickets + arg0_157.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_164 = getProxy(ActivityProxy)
					local var1_164 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_164 then
						var1_164.data1_list[1] = var1_164.data1_list[1] + arg0_157.count

						var0_164:updateActivity(var1_164)
					end
				end,
				[11] = function()
					local var0_165 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_165 and not var0_165:isEnd() then
						var0_165.data1 = var0_165.data1 + arg0_157.count
					end
				end,
				[12] = function()
					local var0_166 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_166 and not var0_166:isEnd() then
						var0_166.data1KeyValueList[1][arg0_157.id] = (var0_166.data1KeyValueList[1][arg0_157.id] or 0) + arg0_157.count
					end
				end,
				[13] = function()
					local var0_167 = getProxy(ActivityProxy):getActivityById(arg0_157:getConfig("link_id"))

					if var0_167:IsMaxCnt() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

						return
					end

					var0_167.data1 = var0_167.data1 + arg0_157.count

					getProxy(ActivityProxy):updateActivity(var0_167)
				end,
				[14] = function()
					local var0_168 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_157.id then
						var0_168:AddSummonPt(arg0_157.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_157.id then
						var0_168:AddSummonPtOld(arg0_157.count)
					end
				end,
				[15] = function()
					local var0_169 = getProxy(ActivityProxy)
					local var1_169 = var0_169:getActivityById(arg0_157:getConfig("link_id"))

					if not var1_169 or var1_169:isEnd() then
						return
					end

					if var1_169:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_169 = pg.activity_event_grid[var1_169.data1]

						if arg0_157.id == var2_169.ticket_item then
							var1_169.data2 = var1_169.data2 + arg0_157.count
						elseif arg0_157.id == var2_169.explore_item then
							var1_169.data3 = var1_169.data3 + arg0_157.count
						end
					elseif var1_169:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_169.data3 = var1_169.data3 + arg0_157.count
					end

					var0_169:updateActivity(var1_169)
				end,
				[16] = function()
					local var0_170 = getProxy(ActivityProxy)
					local var1_170 = var0_170:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_170, iter1_170 in pairs(var1_170) do
						if iter1_170 and not iter1_170:isEnd() and arg0_157.id == iter1_170:getConfig("config_id") then
							iter1_170.data1 = iter1_170.data1 + arg0_157.count

							var0_170:updateActivity(iter1_170)
						end
					end
				end,
				[20] = function()
					local var0_171 = getProxy(BagProxy)
					local var1_171 = pg.gameset.urpt_chapter_max.description
					local var2_171 = var1_171[1]
					local var3_171 = var1_171[2]
					local var4_171 = var0_171:GetLimitCntById(var2_171)
					local var5_171 = math.min(var3_171 - var4_171, arg0_157.count)

					if var5_171 > 0 then
						var0_171:addItemById(var2_171, var5_171)
						var0_171:AddLimitCnt(var2_171, var5_171)
					end
				end,
				[21] = function()
					local var0_172 = getProxy(ActivityProxy)
					local var1_172 = var0_172:getActivityById(arg0_157:getConfig("link_id"))

					if var1_172 and not var1_172:isEnd() then
						var1_172.data2 = 1

						var0_172:updateActivity(var1_172)
					end
				end,
				[22] = function()
					local var0_173 = getProxy(ActivityProxy)
					local var1_173 = var0_173:getActivityById(arg0_157:getConfig("link_id"))

					if var1_173 and not var1_173:isEnd() then
						var1_173.data1 = var1_173.data1 + arg0_157.count

						var0_173:updateActivity(var1_173)
					end
				end,
				[23] = function()
					local var0_174 = (function()
						for iter0_175, iter1_175 in ipairs(pg.gameset.package_lv.description) do
							if arg0_157.id == iter1_175[1] then
								return iter1_175[2]
							end
						end
					end)()

					assert(var0_174)

					local var1_174 = getProxy(PlayerProxy)
					local var2_174 = var1_174:getData()

					var2_174:addExpToLevel(var0_174)
					var1_174:updatePlayer(var2_174)
				end,
				[24] = function()
					local var0_176 = arg0_157:getConfig("link_id")
					local var1_176 = getProxy(ActivityProxy):getActivityById(var0_176)

					if var1_176 and not var1_176:isEnd() and var1_176:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_176.data2 = var1_176.data2 + arg0_157.count

						getProxy(ActivityProxy):updateActivity(var1_176)
					end
				end,
				[25] = function()
					local var0_177 = getProxy(ActivityProxy)
					local var1_177 = var0_177:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_177 and not var1_177:isEnd() then
						var1_177.data1 = var1_177.data1 - 1

						if not table.contains(var1_177.data1_list, arg0_157.id) then
							table.insert(var1_177.data1_list, arg0_157.id)
						end

						var0_177:updateActivity(var1_177)

						local var2_177 = arg0_157:getConfig("link_id")

						if var2_177 > 0 then
							local var3_177 = var0_177:getActivityById(var2_177)

							if var3_177 and not var3_177:isEnd() then
								var3_177.data1 = var3_177.data1 + 1

								var0_177:updateActivity(var3_177)
							end
						end
					end
				end,
				[26] = function()
					local var0_178 = getProxy(ActivityProxy)
					local var1_178 = Clone(var0_178:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_178 and not var1_178:isEnd() then
						var1_178.data1 = var1_178.data1 + arg0_157.count

						var0_178:updateActivity(var1_178)
					end
				end,
				[27] = function()
					local var0_179 = getProxy(ActivityProxy)
					local var1_179 = Clone(var0_179:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_179 and not var1_179:isEnd() then
						var1_179:AddExp(arg0_157.count)
						var0_179:updateActivity(var1_179)
					end
				end,
				[28] = function()
					local var0_180 = getProxy(ActivityProxy)
					local var1_180 = Clone(var0_180:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_180 and not var1_180:isEnd() then
						var1_180:AddGold(arg0_157.count)
						var0_180:updateActivity(var1_180)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_183 = arg0_157:getConfig("link_id")
					local var1_183 = getProxy(ActivityProxy):getActivityById(var0_183)

					if var1_183 and not var1_183:isEnd() then
						var1_183.data1 = var1_183.data1 + arg0_157.count

						getProxy(ActivityProxy):updateActivity(var1_183)
					end
				end,
				[102] = function()
					local var0_184 = arg0_157:getConfig("link_id")
					local var1_184 = pg.activity_template[var0_184].type

					switch(var1_184, {
						[ActivityConst.ACTIVITY_TYPE_CITY_REBUILD] = function()
							getProxy(CityRebuildProxy):AddPt(var0_184, arg0_157.count)
						end
					})
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_186)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_186.id, arg0_186.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_187)
			local var0_187 = getProxy(BayProxy)
			local var1_187 = var0_187:getShipById(arg0_187.count)

			if var1_187 then
				var1_187:unlockActivityNpc(0)
				var0_187:updateShip(var1_187)
				getProxy(CollectionProxy):flushCollection(var1_187)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_188)
			nowWorld():GetInventoryProxy():AddItem(arg0_188.id, arg0_188.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_189)
			local var0_189 = getProxy(AttireProxy)
			local var1_189 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_189 = IconFrame.New({
				id = arg0_189.id
			})
			local var3_189 = var1_189 + var2_189:getConfig("time_second")

			var2_189:updateData({
				isNew = true,
				end_time = var3_189
			})
			var0_189:addAttireFrame(var2_189)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_189)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_190)
			local var0_190 = getProxy(AttireProxy)
			local var1_190 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_190 = ChatFrame.New({
				id = arg0_190.id
			})
			local var3_190 = var1_190 + var2_190:getConfig("time_second")

			var2_190:updateData({
				isNew = true,
				end_time = var3_190
			})
			var0_190:addAttireFrame(var2_190)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_190)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_191)
			getProxy(EmojiProxy):addNewEmojiID(arg0_191.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_191:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_192)
			nowWorld():GetCollectionProxy():Unlock(arg0_192.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_193)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_193.id):addPT(arg0_193.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_194)
			local var0_194 = arg0_194.id
			local var1_194 = arg0_194.count
			local var2_194 = getProxy(ShipSkinProxy)
			local var3_194 = var2_194:getSkinById(var0_194)

			if var3_194 and var3_194:isExpireType() then
				local var4_194 = var1_194 + var3_194.endTime
				local var5_194 = ShipSkin.New({
					id = var0_194,
					end_time = var4_194
				})

				var2_194:addSkin(var5_194)
			elseif not var3_194 then
				local var6_194 = var1_194 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_194 = ShipSkin.New({
					id = var0_194,
					end_time = var6_194
				})

				var2_194:addSkin(var7_194)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_195)
			local var0_195 = arg0_195.id
			local var1_195 = pg.benefit_buff_template[var0_195]

			assert(var1_195 and var1_195.act_id > 0, "should exist act id")

			local var2_195 = getProxy(ActivityProxy):getActivityById(var1_195.act_id)

			if var2_195 and not var2_195:isEnd() then
				local var3_195 = var1_195.max_time
				local var4_195 = pg.TimeMgr.GetInstance():GetServerTime() + var3_195

				var2_195:AddBuff(ActivityBuff.New(var2_195.id, var0_195, var4_195))
				getProxy(ActivityProxy):updateActivity(var2_195)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_196)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_197)
			getProxy(ApartmentProxy):ModifyRoom(arg0_197:getConfig("room_id"), function(arg0_198)
				arg0_198:AddFurnitureByID(arg0_197.id)
			end)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_199)
			getProxy(ApartmentProxy):changeGiftCount(arg0_199.id, arg0_199.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_200)
			getProxy(ApartmentProxy):ModifyApartment(arg0_200:getConfig("ship_group"), function(arg0_201)
				arg0_201:addSkin(arg0_200.id)
			end)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_202)
			local var0_202 = getProxy(LivingAreaCoverProxy)
			local var1_202 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_202.id
			})

			var0_202:UpdateCover(var1_202)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_202)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_202.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_203)
			local var0_203 = getProxy(AttireProxy)
			local var1_203 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_203 = CombatUIStyle.New({
				id = arg0_203.id
			})

			var2_203:setUnlock()
			var2_203:setNew()
			var0_203:addAttireFrame(var2_203)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_203)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_204)
			local var0_204 = getProxy(IslandProxy):GetIsland()

			if not var0_204 then
				return
			end

			var0_204:GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_204.id,
				num = arg0_204.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_205)
		if arg0_205.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_205 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_205.type].activity_id)

			if arg0_205.type == DROP_TYPE_RYZA_DROP then
				if var0_205 and not var0_205:isEnd() then
					var0_205:AddItem(AtelierMaterial.New({
						configId = arg0_205.id,
						count = arg0_205.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_205)
				end
			elseif var0_205 and not var0_205:isEnd() then
				var0_205:addVitemNumber(arg0_205.id, arg0_205.count)
				getProxy(ActivityProxy):updateActivity(var0_205)
			end
		else
			print("can not handle this type>>" .. arg0_205.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_206, arg1_206, arg2_206)
			setText(arg2_206, arg0_206:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_207, arg1_207, arg2_207)
			local var0_207 = arg0_207:getConfig("display")

			if arg0_207:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_207 = string.gsub(var0_207, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_207.extra))
			elseif arg0_207:getConfig("combination_display") ~= nil then
				local var1_207 = arg0_207:getConfig("combination_display")

				if var1_207 and #var1_207 > 0 then
					var0_207 = Item.StaticCombinationDisplay(var1_207)
				end
			end

			setText(arg2_207, SwitchSpecialChar(var0_207, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_208, arg1_208, arg2_208)
			setText(arg2_208, arg0_208:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_209, arg1_209, arg2_209)
			local var0_209 = arg0_209:getConfig("skin_id")
			local var1_209, var2_209, var3_209 = ShipWordHelper.GetWordAndCV(var0_209, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_209, var3_209 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_210, arg1_210, arg2_210)
			local var0_210 = arg0_210:getConfig("skin_id")
			local var1_210, var2_210, var3_210 = ShipWordHelper.GetWordAndCV(var0_210, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_210, var3_210 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_211, arg1_211, arg2_211)
			setText(arg2_211, arg1_211.name or arg0_211:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_212, arg1_212, arg2_212)
			local var0_212 = arg0_212:getConfig("desc")

			for iter0_212, iter1_212 in ipairs({
				arg0_212.count
			}) do
				var0_212 = string.gsub(var0_212, "$" .. iter0_212, iter1_212)
			end

			setText(arg2_212, var0_212)
		end,
		[DROP_TYPE_SKIN] = function(arg0_213, arg1_213, arg2_213)
			setText(arg2_213, arg0_213:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_214, arg1_214, arg2_214)
			setText(arg2_214, arg0_214:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_215, arg1_215, arg2_215)
			local var0_215 = arg0_215:getConfig("desc")
			local var1_215 = _.map(arg0_215:getConfig("equip_type"), function(arg0_216)
				return EquipType.Type2Name2(arg0_216)
			end)

			setText(arg2_215, var0_215 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_215, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_217, arg1_217, arg2_217)
			setText(arg2_217, arg0_217:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_218, arg1_218, arg2_218)
			setText(arg2_218, arg0_218:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_219, arg1_219, arg2_219, arg3_219)
			local var0_219 = WorldCollectionProxy.GetCollectionType(arg0_219.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_219, i18n("world_" .. var0_219 .. "_desc", arg0_219:getConfig("name")))
			setText(arg3_219, i18n("world_" .. var0_219 .. "_name", arg0_219:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_220, arg1_220, arg2_220)
			setText(arg2_220, arg0_220:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_221, arg1_221, arg2_221)
			setText(arg2_221, arg0_221:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_222, arg1_222, arg2_222)
			setText(arg2_222, arg0_222:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_223, arg1_223, arg2_223)
			local var0_223 = string.gsub(arg0_223:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_223.count))

			setText(arg2_223, SwitchSpecialChar(var0_223, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_224, arg1_224, arg2_224)
			setText(arg2_224, arg0_224:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_225, arg1_225, arg2_225)
			setText(arg2_225, arg0_225:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_226, arg1_226, arg2_226)
			setText(arg2_226, arg0_226:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_227, arg1_227, arg2_227)
			setText(arg2_227, arg0_227:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_228, arg1_228, arg2_228)
			setText(arg2_228, arg0_228:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_229, arg1_229, arg2_229)
			setText(arg2_229, arg0_229:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_230, arg1_230, arg2_230)
			setText(arg2_230, "")
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_231, arg1_231, arg2_231)
			setText(arg2_231, "")
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_232, arg1_232, arg2_232)
			setText(arg2_232, "")
		end,
		[DROP_TYPE_ISLAND_DRESS] = function(arg0_233, arg1_233, arg2_233)
			setText(arg2_233, "")
		end,
		[DROP_TYPE_ISLAND_SKIN] = function(arg0_234, arg1_234, arg2_234)
			setText(arg2_234, "")
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_235, arg1_235, arg2_235)
		if arg0_235.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_235, arg0_235:getConfig("display"))
		else
			setText(arg2_235, arg0_235.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_236, arg1_236, arg2_236)
			if arg0_236.id == PlayerConst.ResStoreGold or arg0_236.id == PlayerConst.ResStoreOil then
				arg2_236 = arg2_236 or {}
				arg2_236.frame = "frame_store"
			end

			updateItem(arg1_236, Item.New({
				id = id2ItemId(arg0_236.id)
			}), arg2_236)
		end,
		[DROP_TYPE_ITEM] = function(arg0_237, arg1_237, arg2_237)
			updateItem(arg1_237, arg0_237:getSubClass(), arg2_237)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_238, arg1_238, arg2_238)
			updateEquipment(arg1_238, arg0_238:getSubClass(), arg2_238)
		end,
		[DROP_TYPE_SHIP] = function(arg0_239, arg1_239, arg2_239)
			updateShip(arg1_239, arg0_239.ship, arg2_239)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_240, arg1_240, arg2_240)
			updateShip(arg1_240, arg0_240.ship, arg2_240)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_241, arg1_241, arg2_241)
			updateFurniture(arg1_241, arg0_241, arg2_241)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_242, arg1_242, arg2_242)
			arg2_242.isWorldBuff = arg0_242.isWorldBuff

			updateStrategy(arg1_242, arg0_242, arg2_242)
		end,
		[DROP_TYPE_SKIN] = function(arg0_243, arg1_243, arg2_243)
			arg2_243.isSkin = true
			arg2_243.isNew = arg0_243.isNew

			updateShip(arg1_243, Ship.New({
				configId = tonumber(arg0_243:getConfig("ship_group") .. "1"),
				skin_id = arg0_243.id
			}), arg2_243)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_244, arg1_244, arg2_244)
			local var0_244 = setmetatable({
				count = arg0_244.count
			}, {
				__index = arg0_244:getConfigTable()
			})

			updateEquipmentSkin(arg1_244, var0_244, arg2_244)
		end,
		[DROP_TYPE_VITEM] = function(arg0_245, arg1_245, arg2_245)
			updateItem(arg1_245, Item.New({
				id = arg0_245.id
			}), arg2_245)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_246, arg1_246, arg2_246)
			updateWorldItem(arg1_246, WorldItem.New({
				id = arg0_246.id
			}), arg2_246)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_247, arg1_247, arg2_247)
			updateWorldCollection(arg1_247, arg0_247, arg2_247)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_248, arg1_248, arg2_248)
			updateAttire(arg1_248, AttireConst.TYPE_CHAT_FRAME, arg0_248:getConfigTable(), arg2_248)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_249, arg1_249, arg2_249)
			updateAttire(arg1_249, AttireConst.TYPE_ICON_FRAME, arg0_249:getConfigTable(), arg2_249)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_250, arg1_250, arg2_250)
			updateEmoji(arg1_250, arg0_250:getConfigTable(), arg2_250)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_251, arg1_251, arg2_251)
			arg2_251.count = 1

			updateItem(arg1_251, arg0_251:getSubClass(), arg2_251)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_252, arg1_252, arg2_252)
			updateSpWeapon(arg1_252, SpWeapon.New({
				id = arg0_252.id
			}), arg2_252)
		end,
		[DROP_TYPE_META_PT] = function(arg0_253, arg1_253, arg2_253)
			updateItem(arg1_253, Item.New({
				id = arg0_253:getConfig("id")
			}), arg2_253)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_254, arg1_254, arg2_254)
			arg2_254.isSkin = true
			arg2_254.isTimeLimit = true
			arg2_254.count = 1

			updateShip(arg1_254, Ship.New({
				configId = tonumber(arg0_254:getConfig("ship_group") .. "1"),
				skin_id = arg0_254.id
			}), arg2_254)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_255, arg1_255, arg2_255)
			AtelierMaterial.UpdateRyzaItem(arg1_255, arg0_255.item, arg2_255)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_256, arg1_256, arg2_256)
			WorkBenchItem.UpdateDrop(arg1_256, arg0_256.item, arg2_256)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_257, arg1_257, arg2_257)
			WorkBenchItem.UpdateDrop(arg1_257, WorkBenchItem.New({
				configId = arg0_257.id,
				count = arg0_257.count
			}), arg2_257)
		end,
		[DROP_TYPE_BUFF] = function(arg0_258, arg1_258, arg2_258)
			updateBuff(arg1_258, arg0_258.id, arg2_258)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_259, arg1_259, arg2_259)
			updateCommander(arg1_259, arg0_259, arg2_259)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_260, arg1_260, arg2_260)
			updateCover(arg1_260, arg0_260, arg2_260)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_261, arg1_261, arg2_261)
			updateAttireCombatUI(arg1_261, AttireConst.TYPE_ICON_FRAME, arg0_261:getConfigTable(), arg2_261)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_262, arg1_262, arg2_262)
			updateActivityMedal(arg1_262, arg0_262:getConfigTable(), arg2_262)
		end
	}

	function var0_0.UpdateDropDefault(arg0_263, arg1_263, arg2_263)
		updateDefaultIconTpl(arg1_263, arg0_263, arg2_263)
	end

	var0_0.UpdateCustomDropCase = {
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_264, arg1_264, arg2_264)
			updateDorm3dIcon(arg1_264, arg0_264, arg2_264)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_265, arg1_265, arg2_265)
			updateDorm3dIcon(arg1_265, arg0_265, arg2_265)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_266, arg1_266, arg2_266)
			updateDorm3dIcon(arg1_266, arg0_266, arg2_266)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_267, arg1_267, arg2_267)
			updateIslandItem(arg1_267, arg0_267, arg2_267)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_268, arg1_268, arg2_268)
			updateIslandUnlock(arg1_268, arg0_268, arg2_268)
		end,
		[DROP_TYPE_ISLAND_INVITATION] = function(arg0_269, arg1_269, arg2_269)
			updateIslandInvitation(arg1_269, arg0_269, arg2_269)
		end,
		[VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT] = function(arg0_270, arg1_270, arg2_270)
			updateIslandSeasonPt(arg1_270, arg0_270, arg2_270)
		end,
		[DROP_TYPE_ISLAND_COLLECTION] = function(arg0_271, arg1_271, arg2_271)
			updateIslandWatherCollect(arg1_271, arg0_271, arg2_271)
		end,
		[DROP_TYPE_ISLAND_FURNITURE] = function(arg0_272, arg1_272, arg2_272)
			updateIslandFurniture(arg1_272, arg0_272, arg2_272)
		end,
		[DROP_TYPE_ISLAND_CARD_DIY] = function(arg0_273, arg1_273, arg2_273)
			updateIslandCardDiy(arg1_273, arg0_273, arg2_273)
		end,
		[DROP_TYPE_ISLAND_SPEEDUP_TICKET] = function(arg0_274, arg1_274, arg2_274)
			updateIslandSpeedupTicket(arg1_274, arg0_274, arg2_274)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_275, arg1_275, arg2_275)
			updateItem(arg1_275, Item.New({
				id = arg0_275.id
			}), arg2_275)
		end
	}

	function var0_0.UpdateCustomDropDefault(arg0_276, arg1_276, arg2_276)
		if arg2_276.style == "dorm" then
			updateDorm3dIcon(arg1_276, arg0_276, arg2_276)
		elseif arg2_276.style == "island" then
			updateIslandDefaultIconTpl(arg1_276, arg0_276, arg2_276)
		else
			warning(string.format("without dropType %d in updateCustomDrop", arg0_276.type))
		end
	end
end

return var0_0
