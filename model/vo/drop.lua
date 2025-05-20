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
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_51)
			local var0_51 = Item.getConfigData(arg0_51.id)

			assert(var0_51, arg0_51.id)

			arg0_51.desc = var0_51.display

			return var0_51
		end
	}

	function var0_0.ConfigDefault(arg0_52)
		local var0_52 = arg0_52.type

		if var0_52 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_52 = pg.activity_drop_type[var0_52].relevance

			return var1_52 and pg[var1_52][arg0_52.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_53)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_53.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_54)
			local var0_54 = getProxy(BagProxy):getItemCountById(arg0_54.id)

			if arg0_54:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_54, 1), true
			else
				return var0_54, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_55)
			local var0_55 = arg0_55:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_55], "equip groupId not exist")

			local var1_55 = pg.equip_data_template.get_id_list_by_group[var0_55]

			return underscore.reduce(var1_55, 0, function(arg0_56, arg1_56)
				local var0_56 = getProxy(EquipmentProxy):getEquipmentById(arg1_56)

				return arg0_56 + (var0_56 and var0_56.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_56)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_57)
			return getProxy(BayProxy):getConfigShipCount(arg0_57.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_58)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_58.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_59)
			return arg0_59.count, tobool(arg0_59.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_60)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_60.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_61)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_61.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_62)
			if arg0_62:getConfig("virtual_type") == 22 then
				local var0_62 = getProxy(ActivityProxy):getActivityById(arg0_62:getConfig("link_id"))

				return var0_62 and var0_62.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_63)
			local var0_63 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_63.id)

			return (var0_63 and var0_63.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_63.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_64)
			local var0_64 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_64.type].activity_id):GetItemById(arg0_64.id)

			return var0_64 and var0_64.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_65)
			local var0_65 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_65.id)

			return var0_65 and (not var0_65:expiredType() or not not var0_65:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_66)
			local var0_66 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_66.id)

			return var0_66 and (not var0_66:expiredType() or not not var0_66:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_67)
			local var0_67 = nowWorld()

			if var0_67.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_67:GetInventoryProxy():GetItemCount(arg0_67.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_68)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_68.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_69)
			local var0_69 = getProxy(LivingAreaCoverProxy):GetCover(arg0_69.id)

			return var0_69 and var0_69:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_70)
			return getProxy(ApartmentProxy):getGiftCount(arg0_70.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_71)
			local var0_71 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_71.id)

			return 1
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_72)
			local var0_72 = 0
			local var1_72 = getProxy(IslandProxy):GetIsland()

			if var1_72 then
				var0_72 = var1_72:GetInventoryAgency():GetOwnCount(arg0_72.id)
			end

			return var0_72
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_73)
			return 0
		end
	}

	function var0_0.CountDefault(arg0_74)
		local var0_74 = arg0_74.type

		if var0_74 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_74].activity_id):getVitemNumber(arg0_74.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_75)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_76)
			return Item.New(arg0_76)
		end,
		[DROP_TYPE_VITEM] = function(arg0_77)
			return Item.New(arg0_77)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_78)
			return Equipment.New(arg0_78)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_79)
			return Item.New({
				count = 1,
				id = arg0_79.id,
				extra = arg0_79.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_80)
			return WorldItem.New(arg0_80)
		end
	}

	function var0_0.SubClassDefault(arg0_81)
		assert(false, string.format("drop type %d without subClass", arg0_81.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_82)
			return arg0_82:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_83)
			return arg0_83:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_84)
			return arg0_84:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_85)
			return arg0_85:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_86)
			return arg0_86:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_87)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_88)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_89)
			return arg0_89:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_90)
			return arg0_90:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_91)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_92)
			return arg0_92:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_93)
			return arg0_93:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_94)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_95)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_96)
			return arg0_96:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_97)
			return arg0_97:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_98)
			return arg0_98:getConfig("rarity")
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_99)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_100)
		return arg0_100:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_101)
		return arg0_101:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_102)
			local var0_102 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_102:getConfig("resource_type"),
				count = arg0_102:getConfig("resource_num") * arg0_102.count
			})
			local var1_102 = Drop.New({
				type = arg0_102:getConfig("target_type"),
				id = arg0_102:getConfig("target_id")
			})

			var0_102.name = string.format("%s(%s)", var0_102:getName(), var1_102:getName())

			return var0_102
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_103)
			for iter0_103, iter1_103 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_103.id].pt == arg0_103.id then
					return nil, arg0_103
				end
			end

			return arg0_103
		end,
		[DROP_TYPE_OPERATION] = function(arg0_104)
			if arg0_104.id ~= 3 then
				return nil
			end

			return arg0_104
		end,
		[DROP_TYPE_EMOJI] = function(arg0_105)
			return nil, arg0_105
		end,
		[DROP_TYPE_VITEM] = function(arg0_106, arg1_106, arg2_106)
			assert(arg0_106:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_106.id)

			return switch(arg0_106:getConfig("virtual_type"), {
				function()
					if arg0_106:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_106
					end

					return arg0_106
				end,
				[6] = function()
					local var0_108 = arg2_106.taskId
					local var1_108 = getProxy(ActivityProxy)
					local var2_108 = var1_108:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_108 then
						local var3_108 = var2_108.data1KeyValueList[1]

						var3_108[var0_108] = defaultValue(var3_108[var0_108], 0) + arg0_106.count

						var1_108:updateActivity(var2_108)
					end

					return nil, arg0_106
				end,
				[13] = function()
					local var0_109 = arg0_106:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_109))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_109))

						return nil
					else
						return arg0_106, nil
					end
				end,
				[21] = function()
					return nil, arg0_106
				end,
				[28] = function()
					local var0_111 = Drop.New({
						type = arg0_106.type,
						id = arg0_106.id,
						count = math.floor(arg0_106.count / 1000)
					})
					local var1_111 = Drop.New({
						type = arg0_106.type,
						id = arg0_106.id,
						count = arg0_106.count - math.floor(arg0_106.count / 1000)
					})

					return var0_111, var1_111
				end
			}, function()
				return arg0_106
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_113, arg1_113)
			if Ship.isMetaShipByConfigID(arg0_113.id) and Player.isMetaShipNeedToTrans(arg0_113.id) then
				local var0_113 = table.indexof(arg1_113, arg0_113.id, 1)

				if var0_113 then
					table.remove(arg1_113, var0_113)
				else
					local var1_113 = Player.metaShip2Res(arg0_113.id)
					local var2_113 = Drop.New(var1_113[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_113.id, var2_113)

					return arg0_113, var2_113
				end
			end

			return arg0_113
		end,
		[DROP_TYPE_SKIN] = function(arg0_114)
			arg0_114.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_114.id)

			return arg0_114
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_115)
			local var0_115 = getProxy(PlayerProxy):getRawData()
			local var1_115 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_115:updateMedalList({
				{
					key = arg0_115.id,
					value = var1_115
				}
			})

			return arg0_115
		end
	}

	function var0_0.TransDefault(arg0_116)
		return arg0_116
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_117)
			local var0_117 = id2res(arg0_117.id)

			assert(var0_117, "res should be defined: " .. arg0_117.id)

			local var1_117 = getProxy(PlayerProxy)
			local var2_117 = var1_117:getData()

			var2_117:addResources({
				[var0_117] = arg0_117.count
			})
			var1_117:updatePlayer(var2_117)
		end,
		[DROP_TYPE_ITEM] = function(arg0_118)
			if arg0_118:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_118 = getProxy(BagProxy):getItemCountById(arg0_118.id)
				local var1_118 = math.min(arg0_118:getConfig("max_num") - var0_118, arg0_118.count)

				if var1_118 > 0 then
					getProxy(BagProxy):addItemById(arg0_118.id, var1_118)
				end
			else
				getProxy(BagProxy):addItemById(arg0_118.id, arg0_118.count, arg0_118.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_119)
			local var0_119 = arg0_119:getSubClass()

			getProxy(BagProxy):addItemById(var0_119.id, var0_119.count, var0_119.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_120)
			getProxy(EquipmentProxy):addEquipmentById(arg0_120.id, arg0_120.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_121)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_122)
			local var0_122 = getProxy(DormProxy)
			local var1_122 = Furniture.New({
				id = arg0_122.id,
				count = arg0_122.count
			})

			if var1_122:isRecordTime() then
				var1_122.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_122:AddFurniture(var1_122)
		end,
		[DROP_TYPE_SKIN] = function(arg0_123)
			local var0_123 = getProxy(ShipSkinProxy)
			local var1_123 = ShipSkin.New({
				id = arg0_123.id
			})

			var0_123:addSkin(var1_123)
		end,
		[DROP_TYPE_VITEM] = function(arg0_124)
			arg0_124 = arg0_124:getSubClass()

			assert(arg0_124:isVirtualItem(), "item type error(virtual item)>>" .. arg0_124.id)
			switch(arg0_124:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_124.id, arg0_124.count)
				end,
				function()
					local var0_126 = getProxy(ActivityProxy)
					local var1_126 = arg0_124:getConfig("link_id")
					local var2_126

					if var1_126 > 0 then
						var2_126 = var0_126:getActivityById(var1_126)
					else
						var2_126 = var0_126:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_126 and not var2_126:isEnd() then
						if not table.contains(var2_126.data1_list, arg0_124.id) then
							table.insert(var2_126.data1_list, arg0_124.id)
						end

						var0_126:updateActivity(var2_126)
					end
				end,
				function()
					local var0_127 = getProxy(ActivityProxy)
					local var1_127 = var0_127:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_127, iter1_127 in ipairs(var1_127) do
						iter1_127.data1 = iter1_127.data1 + arg0_124.count

						local var2_127 = iter1_127:getConfig("config_id")
						local var3_127 = pg.activity_vote[var2_127]

						if var3_127 and var3_127.ticket_id_period == arg0_124.id then
							iter1_127.data3 = iter1_127.data3 + arg0_124.count
						end

						var0_127:updateActivity(iter1_127)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_124.id,
							ptCount = arg0_124.count
						})
					end
				end,
				[4] = function()
					local var0_128 = getProxy(ColoringProxy):getColorItems()

					var0_128[arg0_124.id] = (var0_128[arg0_124.id] or 0) + arg0_124.count
				end,
				[6] = function()
					local var0_129 = getProxy(ActivityProxy)
					local var1_129 = var0_129:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_129 then
						var1_129.data3 = var1_129.data3 + arg0_124.count

						var0_129:updateActivity(var1_129)
					end
				end,
				[7] = function()
					local var0_130 = getProxy(ChapterProxy)

					var0_130:updateRemasterTicketsNum(math.min(var0_130.remasterTickets + arg0_124.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_131 = getProxy(ActivityProxy)
					local var1_131 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_131 then
						var1_131.data1_list[1] = var1_131.data1_list[1] + arg0_124.count

						var0_131:updateActivity(var1_131)
					end
				end,
				[10] = function()
					local var0_132 = getProxy(ActivityProxy)
					local var1_132 = var0_132:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_132 and not var1_132:isEnd() then
						var1_132.data1 = var1_132.data1 + arg0_124.count

						var0_132:updateActivity(var1_132)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_132
						})
					end
				end,
				[11] = function()
					local var0_133 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_133 and not var0_133:isEnd() then
						var0_133.data1 = var0_133.data1 + arg0_124.count
					end
				end,
				[12] = function()
					local var0_134 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_134 and not var0_134:isEnd() then
						var0_134.data1KeyValueList[1][arg0_124.id] = (var0_134.data1KeyValueList[1][arg0_124.id] or 0) + arg0_124.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_124.id, arg0_124.count)
				end,
				[14] = function()
					local var0_136 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_124.id then
						var0_136:AddSummonPt(arg0_124.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_124.id then
						var0_136:AddSummonPtOld(arg0_124.count)
					end
				end,
				[15] = function()
					local var0_137 = getProxy(ActivityProxy)
					local var1_137 = var0_137:getActivityById(arg0_124:getConfig("link_id"))

					if not var1_137 or var1_137:isEnd() then
						return
					end

					if var1_137:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE then
						local var2_137 = pg.activity_event_grid[var1_137.data1]

						if arg0_124.id == var2_137.ticket_item then
							var1_137.data2 = var1_137.data2 + arg0_124.count
						elseif arg0_124.id == var2_137.explore_item then
							var1_137.data3 = var1_137.data3 + arg0_124.count
						end
					elseif var1_137:getConfig("type") == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
						var1_137.data3 = var1_137.data3 + arg0_124.count
					end

					var0_137:updateActivity(var1_137)
				end,
				[16] = function()
					local var0_138 = getProxy(ActivityProxy)
					local var1_138 = var0_138:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_138, iter1_138 in pairs(var1_138) do
						if iter1_138 and not iter1_138:isEnd() and arg0_124.id == iter1_138:getConfig("config_id") then
							iter1_138.data1 = iter1_138.data1 + arg0_124.count

							var0_138:updateActivity(iter1_138)
						end
					end
				end,
				[20] = function()
					local var0_139 = getProxy(BagProxy)
					local var1_139 = pg.gameset.urpt_chapter_max.description
					local var2_139 = var1_139[1]
					local var3_139 = var1_139[2]
					local var4_139 = var0_139:GetLimitCntById(var2_139)
					local var5_139 = math.min(var3_139 - var4_139, arg0_124.count)

					if var5_139 > 0 then
						var0_139:addItemById(var2_139, var5_139)
						var0_139:AddLimitCnt(var2_139, var5_139)
					end
				end,
				[21] = function()
					local var0_140 = getProxy(ActivityProxy)
					local var1_140 = var0_140:getActivityById(arg0_124:getConfig("link_id"))

					if var1_140 and not var1_140:isEnd() then
						var1_140.data2 = 1

						var0_140:updateActivity(var1_140)
					end
				end,
				[22] = function()
					local var0_141 = getProxy(ActivityProxy)
					local var1_141 = var0_141:getActivityById(arg0_124:getConfig("link_id"))

					if var1_141 and not var1_141:isEnd() then
						var1_141.data1 = var1_141.data1 + arg0_124.count

						var0_141:updateActivity(var1_141)
					end
				end,
				[23] = function()
					local var0_142 = (function()
						for iter0_143, iter1_143 in ipairs(pg.gameset.package_lv.description) do
							if arg0_124.id == iter1_143[1] then
								return iter1_143[2]
							end
						end
					end)()

					assert(var0_142)

					local var1_142 = getProxy(PlayerProxy)
					local var2_142 = var1_142:getData()

					var2_142:addExpToLevel(var0_142)
					var1_142:updatePlayer(var2_142)
				end,
				[24] = function()
					local var0_144 = arg0_124:getConfig("link_id")
					local var1_144 = getProxy(ActivityProxy):getActivityById(var0_144)

					if var1_144 and not var1_144:isEnd() and var1_144:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_144.data2 = var1_144.data2 + arg0_124.count

						getProxy(ActivityProxy):updateActivity(var1_144)
					end
				end,
				[25] = function()
					local var0_145 = getProxy(ActivityProxy)
					local var1_145 = var0_145:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_145 and not var1_145:isEnd() then
						var1_145.data1 = var1_145.data1 - 1

						if not table.contains(var1_145.data1_list, arg0_124.id) then
							table.insert(var1_145.data1_list, arg0_124.id)
						end

						var0_145:updateActivity(var1_145)

						local var2_145 = arg0_124:getConfig("link_id")

						if var2_145 > 0 then
							local var3_145 = var0_145:getActivityById(var2_145)

							if var3_145 and not var3_145:isEnd() then
								var3_145.data1 = var3_145.data1 + 1

								var0_145:updateActivity(var3_145)
							end
						end
					end
				end,
				[50] = function()
					local var0_146 = getProxy(IslandProxy):GetIsland()

					if var0_146 then
						var0_146:AddExp(arg0_124.count)
					end
				end,
				[51] = function()
					local var0_147 = getProxy(IslandProxy):GetIsland()

					if not var0_147 then
						return
					end

					local var1_147 = var0_147:GetOrderAgency()

					if not var1_147 then
						return
					end

					var1_147:AddExp(arg0_124.count)
				end,
				[26] = function()
					local var0_148 = getProxy(ActivityProxy)
					local var1_148 = Clone(var0_148:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_148 and not var1_148:isEnd() then
						var1_148.data1 = var1_148.data1 + arg0_124.count

						var0_148:updateActivity(var1_148)
					end
				end,
				[27] = function()
					local var0_149 = getProxy(ActivityProxy)
					local var1_149 = Clone(var0_149:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_149 and not var1_149:isEnd() then
						var1_149:AddExp(arg0_124.count)
						var0_149:updateActivity(var1_149)
					end
				end,
				[28] = function()
					local var0_150 = getProxy(ActivityProxy)
					local var1_150 = Clone(var0_150:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_150 and not var1_150:isEnd() then
						var1_150:AddGold(arg0_124.count)
						var0_150:updateActivity(var1_150)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_153 = arg0_124:getConfig("link_id")
					local var1_153 = getProxy(ActivityProxy):getActivityById(var0_153)

					if var1_153 and not var1_153:isEnd() then
						var1_153.data1 = var1_153.data1 + arg0_124.count

						getProxy(ActivityProxy):updateActivity(var1_153)
					end
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_154)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_154.id, arg0_154.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_155)
			local var0_155 = getProxy(BayProxy)
			local var1_155 = var0_155:getShipById(arg0_155.count)

			if var1_155 then
				var1_155:unlockActivityNpc(0)
				var0_155:updateShip(var1_155)
				getProxy(CollectionProxy):flushCollection(var1_155)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_156)
			nowWorld():GetInventoryProxy():AddItem(arg0_156.id, arg0_156.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_157)
			local var0_157 = getProxy(AttireProxy)
			local var1_157 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_157 = IconFrame.New({
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
		[DROP_TYPE_CHAT_FRAME] = function(arg0_158)
			local var0_158 = getProxy(AttireProxy)
			local var1_158 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_158 = ChatFrame.New({
				id = arg0_158.id
			})
			local var3_158 = var1_158 + var2_158:getConfig("time_second")

			var2_158:updateData({
				isNew = true,
				end_time = var3_158
			})
			var0_158:addAttireFrame(var2_158)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_158)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_159)
			getProxy(EmojiProxy):addNewEmojiID(arg0_159.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_159:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_160)
			nowWorld():GetCollectionProxy():Unlock(arg0_160.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_161)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_161.id):addPT(arg0_161.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_162)
			local var0_162 = arg0_162.id
			local var1_162 = arg0_162.count
			local var2_162 = getProxy(ShipSkinProxy)
			local var3_162 = var2_162:getSkinById(var0_162)

			if var3_162 and var3_162:isExpireType() then
				local var4_162 = var1_162 + var3_162.endTime
				local var5_162 = ShipSkin.New({
					id = var0_162,
					end_time = var4_162
				})

				var2_162:addSkin(var5_162)
			elseif not var3_162 then
				local var6_162 = var1_162 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_162 = ShipSkin.New({
					id = var0_162,
					end_time = var6_162
				})

				var2_162:addSkin(var7_162)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_163)
			local var0_163 = arg0_163.id
			local var1_163 = pg.benefit_buff_template[var0_163]

			assert(var1_163 and var1_163.act_id > 0, "should exist act id")

			local var2_163 = getProxy(ActivityProxy):getActivityById(var1_163.act_id)

			if var2_163 and not var2_163:isEnd() then
				local var3_163 = var1_163.max_time
				local var4_163 = pg.TimeMgr.GetInstance():GetServerTime() + var3_163

				var2_163:AddBuff(ActivityBuff.New(var2_163.id, var0_163, var4_163))
				getProxy(ActivityProxy):updateActivity(var2_163)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_164)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_165)
			local var0_165 = getProxy(ApartmentProxy)
			local var1_165 = var0_165:getRoom(arg0_165:getConfig("room_id"))

			var1_165:AddFurnitureByID(arg0_165.id)
			var0_165:updateRoom(var1_165)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_166)
			getProxy(ApartmentProxy):changeGiftCount(arg0_166.id, arg0_166.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_167)
			local var0_167 = getProxy(ApartmentProxy)
			local var1_167 = var0_167:getApartment(arg0_167:getConfig("ship_group"))

			var1_167:addSkin(arg0_167.id)
			var0_167:updateApartment(var1_167)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_168)
			local var0_168 = getProxy(LivingAreaCoverProxy)
			local var1_168 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_168.id
			})

			var0_168:UpdateCover(var1_168)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_168)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_168.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_169)
			local var0_169 = getProxy(AttireProxy)
			local var1_169 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_169 = CombatUIStyle.New({
				id = arg0_169.id
			})

			var2_169:setUnlock()
			var2_169:setNew()
			var0_169:addAttireFrame(var2_169)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_169)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_170)
			getProxy(IslandProxy):GetIsland():GetInventoryAgency():AddItem(IslandItem.New({
				id = arg0_170.id,
				num = arg0_170.count
			}))
		end
	}

	function var0_0.AddItemDefault(arg0_171)
		if arg0_171.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_171 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_171.type].activity_id)

			if arg0_171.type == DROP_TYPE_RYZA_DROP then
				if var0_171 and not var0_171:isEnd() then
					var0_171:AddItem(AtelierMaterial.New({
						configId = arg0_171.id,
						count = arg0_171.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_171)
				end
			elseif var0_171 and not var0_171:isEnd() then
				var0_171:addVitemNumber(arg0_171.id, arg0_171.count)
				getProxy(ActivityProxy):updateActivity(var0_171)
			end
		else
			print("can not handle this type>>" .. arg0_171.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_172, arg1_172, arg2_172)
			setText(arg2_172, arg0_172:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_173, arg1_173, arg2_173)
			local var0_173 = arg0_173:getConfig("display")

			if arg0_173:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_173 = string.gsub(var0_173, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_173.extra))
			elseif arg0_173:getConfig("combination_display") ~= nil then
				local var1_173 = arg0_173:getConfig("combination_display")

				if var1_173 and #var1_173 > 0 then
					var0_173 = Item.StaticCombinationDisplay(var1_173)
				end
			end

			setText(arg2_173, SwitchSpecialChar(var0_173, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_174, arg1_174, arg2_174)
			setText(arg2_174, arg0_174:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_175, arg1_175, arg2_175)
			local var0_175 = arg0_175:getConfig("skin_id")
			local var1_175, var2_175, var3_175 = ShipWordHelper.GetWordAndCV(var0_175, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_175, var3_175 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_176, arg1_176, arg2_176)
			local var0_176 = arg0_176:getConfig("skin_id")
			local var1_176, var2_176, var3_176 = ShipWordHelper.GetWordAndCV(var0_176, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_176, var3_176 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_177, arg1_177, arg2_177)
			setText(arg2_177, arg1_177.name or arg0_177:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_178, arg1_178, arg2_178)
			local var0_178 = arg0_178:getConfig("desc")

			for iter0_178, iter1_178 in ipairs({
				arg0_178.count
			}) do
				var0_178 = string.gsub(var0_178, "$" .. iter0_178, iter1_178)
			end

			setText(arg2_178, var0_178)
		end,
		[DROP_TYPE_SKIN] = function(arg0_179, arg1_179, arg2_179)
			setText(arg2_179, arg0_179:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_180, arg1_180, arg2_180)
			setText(arg2_180, arg0_180:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_181, arg1_181, arg2_181)
			local var0_181 = arg0_181:getConfig("desc")
			local var1_181 = _.map(arg0_181:getConfig("equip_type"), function(arg0_182)
				return EquipType.Type2Name2(arg0_182)
			end)

			setText(arg2_181, var0_181 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_181, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_183, arg1_183, arg2_183)
			setText(arg2_183, arg0_183:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_184, arg1_184, arg2_184)
			setText(arg2_184, arg0_184:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_185, arg1_185, arg2_185, arg3_185)
			local var0_185 = WorldCollectionProxy.GetCollectionType(arg0_185.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_185, i18n("world_" .. var0_185 .. "_desc", arg0_185:getConfig("name")))
			setText(arg3_185, i18n("world_" .. var0_185 .. "_name", arg0_185:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_186, arg1_186, arg2_186)
			setText(arg2_186, arg0_186:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_187, arg1_187, arg2_187)
			setText(arg2_187, arg0_187:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_188, arg1_188, arg2_188)
			setText(arg2_188, arg0_188:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_189, arg1_189, arg2_189)
			local var0_189 = string.gsub(arg0_189:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_189.count))

			setText(arg2_189, SwitchSpecialChar(var0_189, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_190, arg1_190, arg2_190)
			setText(arg2_190, arg0_190:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_191, arg1_191, arg2_191)
			setText(arg2_191, arg0_191:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_192, arg1_192, arg2_192)
			setText(arg2_192, arg0_192:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_193, arg1_193, arg2_193)
			setText(arg2_193, arg0_193:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_194, arg1_194, arg2_194)
			setText(arg2_194, arg0_194:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_195, arg1_195, arg2_195)
			setText(arg2_195, arg0_195:getConfig("desc"))
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_196, arg1_196, arg2_196)
			setText(arg2_196, "")
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_197, arg1_197, arg2_197)
		if arg0_197.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_197, arg0_197:getConfig("display"))
		else
			setText(arg2_197, arg0_197.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_198, arg1_198, arg2_198)
			if arg0_198.id == PlayerConst.ResStoreGold or arg0_198.id == PlayerConst.ResStoreOil then
				arg2_198 = arg2_198 or {}
				arg2_198.frame = "frame_store"
			end

			updateItem(arg1_198, Item.New({
				id = id2ItemId(arg0_198.id)
			}), arg2_198)
		end,
		[DROP_TYPE_ITEM] = function(arg0_199, arg1_199, arg2_199)
			updateItem(arg1_199, arg0_199:getSubClass(), arg2_199)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_200, arg1_200, arg2_200)
			updateEquipment(arg1_200, arg0_200:getSubClass(), arg2_200)
		end,
		[DROP_TYPE_SHIP] = function(arg0_201, arg1_201, arg2_201)
			updateShip(arg1_201, arg0_201.ship, arg2_201)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_202, arg1_202, arg2_202)
			updateShip(arg1_202, arg0_202.ship, arg2_202)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_203, arg1_203, arg2_203)
			updateFurniture(arg1_203, arg0_203, arg2_203)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_204, arg1_204, arg2_204)
			arg2_204.isWorldBuff = arg0_204.isWorldBuff

			updateStrategy(arg1_204, arg0_204, arg2_204)
		end,
		[DROP_TYPE_SKIN] = function(arg0_205, arg1_205, arg2_205)
			arg2_205.isSkin = true
			arg2_205.isNew = arg0_205.isNew

			updateShip(arg1_205, Ship.New({
				configId = tonumber(arg0_205:getConfig("ship_group") .. "1"),
				skin_id = arg0_205.id
			}), arg2_205)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_206, arg1_206, arg2_206)
			local var0_206 = setmetatable({
				count = arg0_206.count
			}, {
				__index = arg0_206:getConfigTable()
			})

			updateEquipmentSkin(arg1_206, var0_206, arg2_206)
		end,
		[DROP_TYPE_VITEM] = function(arg0_207, arg1_207, arg2_207)
			updateItem(arg1_207, Item.New({
				id = arg0_207.id
			}), arg2_207)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_208, arg1_208, arg2_208)
			updateWorldItem(arg1_208, WorldItem.New({
				id = arg0_208.id
			}), arg2_208)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_209, arg1_209, arg2_209)
			updateWorldCollection(arg1_209, arg0_209, arg2_209)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_210, arg1_210, arg2_210)
			updateAttire(arg1_210, AttireConst.TYPE_CHAT_FRAME, arg0_210:getConfigTable(), arg2_210)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_211, arg1_211, arg2_211)
			updateAttire(arg1_211, AttireConst.TYPE_ICON_FRAME, arg0_211:getConfigTable(), arg2_211)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_212, arg1_212, arg2_212)
			updateEmoji(arg1_212, arg0_212:getConfigTable(), arg2_212)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_213, arg1_213, arg2_213)
			arg2_213.count = 1

			updateItem(arg1_213, arg0_213:getSubClass(), arg2_213)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_214, arg1_214, arg2_214)
			updateSpWeapon(arg1_214, SpWeapon.New({
				id = arg0_214.id
			}), arg2_214)
		end,
		[DROP_TYPE_META_PT] = function(arg0_215, arg1_215, arg2_215)
			updateItem(arg1_215, Item.New({
				id = arg0_215:getConfig("id")
			}), arg2_215)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_216, arg1_216, arg2_216)
			arg2_216.isSkin = true
			arg2_216.isTimeLimit = true
			arg2_216.count = 1

			updateShip(arg1_216, Ship.New({
				configId = tonumber(arg0_216:getConfig("ship_group") .. "1"),
				skin_id = arg0_216.id
			}), arg2_216)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_217, arg1_217, arg2_217)
			AtelierMaterial.UpdateRyzaItem(arg1_217, arg0_217.item, arg2_217)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_218, arg1_218, arg2_218)
			WorkBenchItem.UpdateDrop(arg1_218, arg0_218.item, arg2_218)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_219, arg1_219, arg2_219)
			WorkBenchItem.UpdateDrop(arg1_219, WorkBenchItem.New({
				configId = arg0_219.id,
				count = arg0_219.count
			}), arg2_219)
		end,
		[DROP_TYPE_BUFF] = function(arg0_220, arg1_220, arg2_220)
			updateBuff(arg1_220, arg0_220.id, arg2_220)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_221, arg1_221, arg2_221)
			updateCommander(arg1_221, arg0_221, arg2_221)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_222, arg1_222, arg2_222)
			updateDorm3dFurniture(arg1_222, arg0_222, arg2_222)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_223, arg1_223, arg2_223)
			updateDorm3dGift(arg1_223, arg0_223, arg2_223)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_224, arg1_224, arg2_224)
			updateDorm3dSkin(arg1_224, arg0_224, arg2_224)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_225, arg1_225, arg2_225)
			updateCover(arg1_225, arg0_225, arg2_225)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_226, arg1_226, arg2_226)
			updateAttireCombatUI(arg1_226, AttireConst.TYPE_ICON_FRAME, arg0_226:getConfigTable(), arg2_226)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_227, arg1_227, arg2_227)
			updateActivityMedal(arg1_227, arg0_227:getConfigTable(), arg2_227)
		end,
		[DROP_TYPE_ISLAND_ITEM] = function(arg0_228, arg1_228, arg2_228)
			updateIslandItem(arg1_228, arg0_228, arg2_228)
		end,
		[DROP_TYPE_ISLAND_ABILITY] = function(arg0_229, arg1_229, arg2_229)
			updateIslandUnlock(arg1_229, arg0_229, arg2_229)
		end,
		[DROP_TYPE_HOLIDAY_VILLA] = function(arg0_230, arg1_230, arg2_230)
			updateItem(arg1_230, Item.New({
				id = arg0_230.id
			}), arg2_230)
		end
	}

	function var0_0.UpdateDropDefault(arg0_231, arg1_231, arg2_231)
		warning(string.format("without dropType %d in updateDrop", arg0_231.type))
	end
end

return var0_0
