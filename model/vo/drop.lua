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
			local var1_26, var2_26, var3_26 = ShipWordHelper.GetWordAndCV(arg0_26.id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_26.desc = var3_26

			return var0_26
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_27)
			local var0_27 = pg.ship_skin_template[arg0_27.id]
			local var1_27, var2_27, var3_27 = ShipWordHelper.GetWordAndCV(arg0_27.id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_27.desc = var3_27

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
		[DROP_TYPE_TRANS_ITEM] = function(arg0_42)
			return pg.drop_data_restore[arg0_42.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_43)
			local var0_43 = pg.dorm3d_furniture_template[arg0_43.id]

			arg0_43.desc = var0_43.desc

			return var0_43
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_44)
			local var0_44 = pg.dorm3d_gift[arg0_44.id]

			arg0_44.desc = var0_44.display

			return var0_44
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_45)
			local var0_45 = pg.dorm3d_resource[arg0_45.id]

			arg0_45.desc = ""

			return var0_45
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_46)
			local var0_46 = pg.livingarea_cover[arg0_46.id]

			arg0_46.desc = var0_46.desc

			return var0_46
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_47)
			return pg.item_data_battleui[arg0_47.id]
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_48)
			local var0_48 = pg.activity_medal_template[arg0_48.id].item
			local var1_48 = pg.item_virtual_data_statistics[var0_48]

			print(var1_48)

			return var1_48
		end
	}

	function var0_0.ConfigDefault(arg0_49)
		local var0_49 = arg0_49.type

		if var0_49 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_49 = pg.activity_drop_type[var0_49].relevance

			return var1_49 and pg[var1_49][arg0_49.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_50)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_50.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_51)
			local var0_51 = getProxy(BagProxy):getItemCountById(arg0_51.id)

			if arg0_51:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_51, 1), true
			else
				return var0_51, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_52)
			local var0_52 = arg0_52:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_52], "equip groupId not exist")

			local var1_52 = pg.equip_data_template.get_id_list_by_group[var0_52]

			return underscore.reduce(var1_52, 0, function(arg0_53, arg1_53)
				local var0_53 = getProxy(EquipmentProxy):getEquipmentById(arg1_53)

				return arg0_53 + (var0_53 and var0_53.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_53)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_54)
			return getProxy(BayProxy):getConfigShipCount(arg0_54.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_55)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_55.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_56)
			return arg0_56.count, tobool(arg0_56.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_57)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_57.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_58)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_58.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_59)
			if arg0_59:getConfig("virtual_type") == 22 then
				local var0_59 = getProxy(ActivityProxy):getActivityById(arg0_59:getConfig("link_id"))

				return var0_59 and var0_59.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_60)
			local var0_60 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_60.id)

			return (var0_60 and var0_60.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_60.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_61)
			local var0_61 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_61.type].activity_id):GetItemById(arg0_61.id)

			return var0_61 and var0_61.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_62)
			local var0_62 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_62.id)

			return var0_62 and (not var0_62:expiredType() or not not var0_62:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_63)
			local var0_63 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_63.id)

			return var0_63 and (not var0_63:expiredType() or not not var0_63:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_64)
			local var0_64 = nowWorld()

			if var0_64.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_64:GetInventoryProxy():GetItemCount(arg0_64.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_65)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_65.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_66)
			local var0_66 = getProxy(LivingAreaCoverProxy):GetCover(arg0_66.id)

			return var0_66 and var0_66:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_67)
			return getProxy(ApartmentProxy):getGiftCount(arg0_67.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_68)
			local var0_68 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_68.id)

			return 1
		end
	}

	function var0_0.CountDefault(arg0_69)
		local var0_69 = arg0_69.type

		if var0_69 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_69].activity_id):getVitemNumber(arg0_69.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_70)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_71)
			return Item.New(arg0_71)
		end,
		[DROP_TYPE_VITEM] = function(arg0_72)
			return Item.New(arg0_72)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_73)
			return Equipment.New(arg0_73)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_74)
			return Item.New({
				count = 1,
				id = arg0_74.id,
				extra = arg0_74.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_75)
			return WorldItem.New(arg0_75)
		end
	}

	function var0_0.SubClassDefault(arg0_76)
		assert(false, string.format("drop type %d without subClass", arg0_76.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_77)
			return arg0_77:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_78)
			return arg0_78:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_79)
			return arg0_79:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_80)
			return arg0_80:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_81)
			return arg0_81:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_82)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_83)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_84)
			return arg0_84:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_85)
			return arg0_85:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_86)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_87)
			return arg0_87:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_88)
			return arg0_88:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_89)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_90)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_91)
			return arg0_91:getConfig("rare")
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_92)
			return arg0_92:getConfig("rarity")
		end
	}

	function var0_0.RarityDefault(arg0_93)
		return arg0_93:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_94)
		return arg0_94:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_95)
			local var0_95 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_95:getConfig("resource_type"),
				count = arg0_95:getConfig("resource_num") * arg0_95.count
			})
			local var1_95 = Drop.New({
				type = arg0_95:getConfig("target_type"),
				id = arg0_95:getConfig("target_id")
			})

			var0_95.name = string.format("%s(%s)", var0_95:getName(), var1_95:getName())

			return var0_95
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_96)
			for iter0_96, iter1_96 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_96.id].pt == arg0_96.id then
					return nil, arg0_96
				end
			end

			return arg0_96
		end,
		[DROP_TYPE_OPERATION] = function(arg0_97)
			if arg0_97.id ~= 3 then
				return nil
			end

			return arg0_97
		end,
		[DROP_TYPE_EMOJI] = function(arg0_98)
			return nil, arg0_98
		end,
		[DROP_TYPE_VITEM] = function(arg0_99, arg1_99, arg2_99)
			assert(arg0_99:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_99.id)

			return switch(arg0_99:getConfig("virtual_type"), {
				function()
					if arg0_99:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_99
					end

					return arg0_99
				end,
				[6] = function()
					local var0_101 = arg2_99.taskId
					local var1_101 = getProxy(ActivityProxy)
					local var2_101 = var1_101:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_101 then
						local var3_101 = var2_101.data1KeyValueList[1]

						var3_101[var0_101] = defaultValue(var3_101[var0_101], 0) + arg0_99.count

						var1_101:updateActivity(var2_101)
					end

					return nil, arg0_99
				end,
				[13] = function()
					local var0_102 = arg0_99:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_102))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_102))

						return nil
					elseif SkinCouponActivity.StaticOwnAllSkin() then
						if arg0_99.count > 1 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_102))
						end

						return SkinCouponActivity.StaticGetEquivalentRes(), nil
					else
						return arg0_99, nil
					end
				end,
				[21] = function()
					return nil, arg0_99
				end,
				[28] = function()
					local var0_104 = Drop.New({
						type = arg0_99.type,
						id = arg0_99.id,
						count = math.floor(arg0_99.count / 1000)
					})
					local var1_104 = Drop.New({
						type = arg0_99.type,
						id = arg0_99.id,
						count = arg0_99.count - math.floor(arg0_99.count / 1000)
					})

					return var0_104, var1_104
				end
			}, function()
				return arg0_99
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_106, arg1_106)
			if Ship.isMetaShipByConfigID(arg0_106.id) and Player.isMetaShipNeedToTrans(arg0_106.id) then
				local var0_106 = table.indexof(arg1_106, arg0_106.id, 1)

				if var0_106 then
					table.remove(arg1_106, var0_106)
				else
					local var1_106 = Player.metaShip2Res(arg0_106.id)
					local var2_106 = Drop.New(var1_106[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_106.id, var2_106)

					return arg0_106, var2_106
				end
			end

			return arg0_106
		end,
		[DROP_TYPE_SKIN] = function(arg0_107)
			arg0_107.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_107.id)

			return arg0_107
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_108)
			local var0_108 = getProxy(PlayerProxy):getRawData()
			local var1_108 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_108:updateMedalList({
				{
					key = arg0_108.id,
					value = var1_108
				}
			})

			return arg0_108
		end
	}

	function var0_0.TransDefault(arg0_109)
		return arg0_109
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_110)
			local var0_110 = id2res(arg0_110.id)

			assert(var0_110, "res should be defined: " .. arg0_110.id)

			local var1_110 = getProxy(PlayerProxy)
			local var2_110 = var1_110:getData()

			var2_110:addResources({
				[var0_110] = arg0_110.count
			})
			var1_110:updatePlayer(var2_110)
		end,
		[DROP_TYPE_ITEM] = function(arg0_111)
			if arg0_111:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_111 = getProxy(BagProxy):getItemCountById(arg0_111.id)
				local var1_111 = math.min(arg0_111:getConfig("max_num") - var0_111, arg0_111.count)

				if var1_111 > 0 then
					getProxy(BagProxy):addItemById(arg0_111.id, var1_111)
				end
			else
				getProxy(BagProxy):addItemById(arg0_111.id, arg0_111.count, arg0_111.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_112)
			local var0_112 = arg0_112:getSubClass()

			getProxy(BagProxy):addItemById(var0_112.id, var0_112.count, var0_112.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_113)
			getProxy(EquipmentProxy):addEquipmentById(arg0_113.id, arg0_113.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_114)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_115)
			local var0_115 = getProxy(DormProxy)
			local var1_115 = Furniture.New({
				id = arg0_115.id,
				count = arg0_115.count
			})

			if var1_115:isRecordTime() then
				var1_115.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_115:AddFurniture(var1_115)
		end,
		[DROP_TYPE_SKIN] = function(arg0_116)
			local var0_116 = getProxy(ShipSkinProxy)
			local var1_116 = ShipSkin.New({
				id = arg0_116.id
			})

			var0_116:addSkin(var1_116)
		end,
		[DROP_TYPE_VITEM] = function(arg0_117)
			arg0_117 = arg0_117:getSubClass()

			assert(arg0_117:isVirtualItem(), "item type error(virtual item)>>" .. arg0_117.id)
			switch(arg0_117:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_117.id, arg0_117.count)
				end,
				function()
					local var0_119 = getProxy(ActivityProxy)
					local var1_119 = arg0_117:getConfig("link_id")
					local var2_119

					if var1_119 > 0 then
						var2_119 = var0_119:getActivityById(var1_119)
					else
						var2_119 = var0_119:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_119 and not var2_119:isEnd() then
						if not table.contains(var2_119.data1_list, arg0_117.id) then
							table.insert(var2_119.data1_list, arg0_117.id)
						end

						var0_119:updateActivity(var2_119)
					end
				end,
				function()
					local var0_120 = getProxy(ActivityProxy)
					local var1_120 = var0_120:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_120, iter1_120 in ipairs(var1_120) do
						iter1_120.data1 = iter1_120.data1 + arg0_117.count

						local var2_120 = iter1_120:getConfig("config_id")
						local var3_120 = pg.activity_vote[var2_120]

						if var3_120 and var3_120.ticket_id_period == arg0_117.id then
							iter1_120.data3 = iter1_120.data3 + arg0_117.count
						end

						var0_120:updateActivity(iter1_120)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_117.id,
							ptCount = arg0_117.count
						})
					end
				end,
				[4] = function()
					local var0_121 = getProxy(ColoringProxy):getColorItems()

					var0_121[arg0_117.id] = (var0_121[arg0_117.id] or 0) + arg0_117.count
				end,
				[6] = function()
					local var0_122 = getProxy(ActivityProxy)
					local var1_122 = var0_122:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_122 then
						var1_122.data3 = var1_122.data3 + arg0_117.count

						var0_122:updateActivity(var1_122)
					end
				end,
				[7] = function()
					local var0_123 = getProxy(ChapterProxy)

					var0_123:updateRemasterTicketsNum(math.min(var0_123.remasterTickets + arg0_117.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_124 = getProxy(ActivityProxy)
					local var1_124 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_124 then
						var1_124.data1_list[1] = var1_124.data1_list[1] + arg0_117.count

						var0_124:updateActivity(var1_124)
					end
				end,
				[10] = function()
					local var0_125 = getProxy(ActivityProxy)
					local var1_125 = var0_125:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_125 and not var1_125:isEnd() then
						var1_125.data1 = var1_125.data1 + arg0_117.count

						var0_125:updateActivity(var1_125)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_125
						})
					end
				end,
				[11] = function()
					local var0_126 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_126 and not var0_126:isEnd() then
						var0_126.data1 = var0_126.data1 + arg0_117.count
					end
				end,
				[12] = function()
					local var0_127 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_127 and not var0_127:isEnd() then
						var0_127.data1KeyValueList[1][arg0_117.id] = (var0_127.data1KeyValueList[1][arg0_117.id] or 0) + arg0_117.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_117.id)
				end,
				[14] = function()
					local var0_129 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_117.id then
						var0_129:AddSummonPt(arg0_117.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_117.id then
						var0_129:AddSummonPtOld(arg0_117.count)
					end
				end,
				[15] = function()
					local var0_130 = getProxy(ActivityProxy)
					local var1_130 = var0_130:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

					if var1_130 and not var1_130:isEnd() then
						local var2_130 = pg.activity_event_grid[var1_130.data1]

						if arg0_117.id == var2_130.ticket_item then
							var1_130.data2 = var1_130.data2 + arg0_117.count
						elseif arg0_117.id == var2_130.explore_item then
							var1_130.data3 = var1_130.data3 + arg0_117.count
						end
					end

					var0_130:updateActivity(var1_130)
				end,
				[16] = function()
					local var0_131 = getProxy(ActivityProxy)
					local var1_131 = var0_131:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_131, iter1_131 in pairs(var1_131) do
						if iter1_131 and not iter1_131:isEnd() and arg0_117.id == iter1_131:getConfig("config_id") then
							iter1_131.data1 = iter1_131.data1 + arg0_117.count

							var0_131:updateActivity(iter1_131)
						end
					end
				end,
				[20] = function()
					local var0_132 = getProxy(BagProxy)
					local var1_132 = pg.gameset.urpt_chapter_max.description
					local var2_132 = var1_132[1]
					local var3_132 = var1_132[2]
					local var4_132 = var0_132:GetLimitCntById(var2_132)
					local var5_132 = math.min(var3_132 - var4_132, arg0_117.count)

					if var5_132 > 0 then
						var0_132:addItemById(var2_132, var5_132)
						var0_132:AddLimitCnt(var2_132, var5_132)
					end
				end,
				[21] = function()
					local var0_133 = getProxy(ActivityProxy)
					local var1_133 = var0_133:getActivityById(arg0_117:getConfig("link_id"))

					if var1_133 and not var1_133:isEnd() then
						var1_133.data2 = 1

						var0_133:updateActivity(var1_133)
					end
				end,
				[22] = function()
					local var0_134 = getProxy(ActivityProxy)
					local var1_134 = var0_134:getActivityById(arg0_117:getConfig("link_id"))

					if var1_134 and not var1_134:isEnd() then
						var1_134.data1 = var1_134.data1 + arg0_117.count

						var0_134:updateActivity(var1_134)
					end
				end,
				[23] = function()
					local var0_135 = (function()
						for iter0_136, iter1_136 in ipairs(pg.gameset.package_lv.description) do
							if arg0_117.id == iter1_136[1] then
								return iter1_136[2]
							end
						end
					end)()

					assert(var0_135)

					local var1_135 = getProxy(PlayerProxy)
					local var2_135 = var1_135:getData()

					var2_135:addExpToLevel(var0_135)
					var1_135:updatePlayer(var2_135)
				end,
				[24] = function()
					local var0_137 = arg0_117:getConfig("link_id")
					local var1_137 = getProxy(ActivityProxy):getActivityById(var0_137)

					if var1_137 and not var1_137:isEnd() and var1_137:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_137.data2 = var1_137.data2 + arg0_117.count

						getProxy(ActivityProxy):updateActivity(var1_137)
					end
				end,
				[25] = function()
					local var0_138 = getProxy(ActivityProxy)
					local var1_138 = var0_138:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_138 and not var1_138:isEnd() then
						var1_138.data1 = var1_138.data1 - 1

						if not table.contains(var1_138.data1_list, arg0_117.id) then
							table.insert(var1_138.data1_list, arg0_117.id)
						end

						var0_138:updateActivity(var1_138)

						local var2_138 = arg0_117:getConfig("link_id")

						if var2_138 > 0 then
							local var3_138 = var0_138:getActivityById(var2_138)

							if var3_138 and not var3_138:isEnd() then
								var3_138.data1 = var3_138.data1 + 1

								var0_138:updateActivity(var3_138)
							end
						end
					end
				end,
				[26] = function()
					local var0_139 = getProxy(ActivityProxy)
					local var1_139 = Clone(var0_139:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_139 and not var1_139:isEnd() then
						var1_139.data1 = var1_139.data1 + arg0_117.count

						var0_139:updateActivity(var1_139)
					end
				end,
				[27] = function()
					local var0_140 = getProxy(ActivityProxy)
					local var1_140 = Clone(var0_140:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_140 and not var1_140:isEnd() then
						var1_140:AddExp(arg0_117.count)
						var0_140:updateActivity(var1_140)
					end
				end,
				[28] = function()
					local var0_141 = getProxy(ActivityProxy)
					local var1_141 = Clone(var0_141:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_141 and not var1_141:isEnd() then
						var1_141:AddGold(arg0_117.count)
						var0_141:updateActivity(var1_141)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_144 = arg0_117:getConfig("link_id")
					local var1_144 = getProxy(ActivityProxy):getActivityById(var0_144)

					if var1_144 and not var1_144:isEnd() then
						var1_144.data1 = var1_144.data1 + arg0_117.count

						getProxy(ActivityProxy):updateActivity(var1_144)
					end
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_145)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_145.id, arg0_145.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_146)
			local var0_146 = getProxy(BayProxy)
			local var1_146 = var0_146:getShipById(arg0_146.count)

			if var1_146 then
				var1_146:unlockActivityNpc(0)
				var0_146:updateShip(var1_146)
				getProxy(CollectionProxy):flushCollection(var1_146)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_147)
			nowWorld():GetInventoryProxy():AddItem(arg0_147.id, arg0_147.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_148)
			local var0_148 = getProxy(AttireProxy)
			local var1_148 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_148 = IconFrame.New({
				id = arg0_148.id
			})
			local var3_148 = var1_148 + var2_148:getConfig("time_second")

			var2_148:updateData({
				isNew = true,
				end_time = var3_148
			})
			var0_148:addAttireFrame(var2_148)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_148)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_149)
			local var0_149 = getProxy(AttireProxy)
			local var1_149 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_149 = ChatFrame.New({
				id = arg0_149.id
			})
			local var3_149 = var1_149 + var2_149:getConfig("time_second")

			var2_149:updateData({
				isNew = true,
				end_time = var3_149
			})
			var0_149:addAttireFrame(var2_149)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_149)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_150)
			getProxy(EmojiProxy):addNewEmojiID(arg0_150.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_150:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_151)
			nowWorld():GetCollectionProxy():Unlock(arg0_151.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_152)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_152.id):addPT(arg0_152.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_153)
			local var0_153 = arg0_153.id
			local var1_153 = arg0_153.count
			local var2_153 = getProxy(ShipSkinProxy)
			local var3_153 = var2_153:getSkinById(var0_153)

			if var3_153 and var3_153:isExpireType() then
				local var4_153 = var1_153 + var3_153.endTime
				local var5_153 = ShipSkin.New({
					id = var0_153,
					end_time = var4_153
				})

				var2_153:addSkin(var5_153)
			elseif not var3_153 then
				local var6_153 = var1_153 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_153 = ShipSkin.New({
					id = var0_153,
					end_time = var6_153
				})

				var2_153:addSkin(var7_153)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_154)
			local var0_154 = arg0_154.id
			local var1_154 = pg.benefit_buff_template[var0_154]

			assert(var1_154 and var1_154.act_id > 0, "should exist act id")

			local var2_154 = getProxy(ActivityProxy):getActivityById(var1_154.act_id)

			if var2_154 and not var2_154:isEnd() then
				local var3_154 = var1_154.max_time
				local var4_154 = pg.TimeMgr.GetInstance():GetServerTime() + var3_154

				var2_154:AddBuff(ActivityBuff.New(var2_154.id, var0_154, var4_154))
				getProxy(ActivityProxy):updateActivity(var2_154)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_155)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_156)
			local var0_156 = getProxy(ApartmentProxy)
			local var1_156 = var0_156:getRoom(arg0_156:getConfig("room_id"))

			var1_156:AddFurnitureByID(arg0_156.id)
			var0_156:updateRoom(var1_156)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_157)
			getProxy(ApartmentProxy):changeGiftCount(arg0_157.id, arg0_157.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_158)
			local var0_158 = getProxy(ApartmentProxy)
			local var1_158 = var0_158:getApartment(arg0_158:getConfig("ship_group"))

			var1_158:addSkin(arg0_158.id)
			var0_158:updateApartment(var1_158)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_159)
			local var0_159 = getProxy(LivingAreaCoverProxy)
			local var1_159 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_159.id
			})

			var0_159:UpdateCover(var1_159)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_159)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_159.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_160)
			local var0_160 = getProxy(AttireProxy)
			local var1_160 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_160 = CombatUIStyle.New({
				id = arg0_160.id
			})

			var2_160:setUnlock()
			var2_160:setNew()
			var0_160:addAttireFrame(var2_160)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_160)
		end
	}

	function var0_0.AddItemDefault(arg0_161)
		if arg0_161.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_161 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_161.type].activity_id)

			if arg0_161.type == DROP_TYPE_RYZA_DROP then
				if var0_161 and not var0_161:isEnd() then
					var0_161:AddItem(AtelierMaterial.New({
						configId = arg0_161.id,
						count = arg0_161.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_161)
				end
			elseif var0_161 and not var0_161:isEnd() then
				var0_161:addVitemNumber(arg0_161.id, arg0_161.count)
				getProxy(ActivityProxy):updateActivity(var0_161)
			end
		else
			print("can not handle this type>>" .. arg0_161.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_162, arg1_162, arg2_162)
			setText(arg2_162, arg0_162:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_163, arg1_163, arg2_163)
			local var0_163 = arg0_163:getConfig("display")

			if arg0_163:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_163 = string.gsub(var0_163, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_163.extra))
			elseif arg0_163:getConfig("combination_display") ~= nil then
				local var1_163 = arg0_163:getConfig("combination_display")

				if var1_163 and #var1_163 > 0 then
					var0_163 = Item.StaticCombinationDisplay(var1_163)
				end
			end

			setText(arg2_163, SwitchSpecialChar(var0_163, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_164, arg1_164, arg2_164)
			setText(arg2_164, arg0_164:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_165, arg1_165, arg2_165)
			local var0_165 = arg0_165:getConfig("skin_id")
			local var1_165, var2_165, var3_165 = ShipWordHelper.GetWordAndCV(var0_165, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_165, var3_165 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_166, arg1_166, arg2_166)
			local var0_166 = arg0_166:getConfig("skin_id")
			local var1_166, var2_166, var3_166 = ShipWordHelper.GetWordAndCV(var0_166, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_166, var3_166 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_167, arg1_167, arg2_167)
			setText(arg2_167, arg1_167.name or arg0_167:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_168, arg1_168, arg2_168)
			local var0_168 = arg0_168:getConfig("desc")

			for iter0_168, iter1_168 in ipairs({
				arg0_168.count
			}) do
				var0_168 = string.gsub(var0_168, "$" .. iter0_168, iter1_168)
			end

			setText(arg2_168, var0_168)
		end,
		[DROP_TYPE_SKIN] = function(arg0_169, arg1_169, arg2_169)
			setText(arg2_169, arg0_169:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_170, arg1_170, arg2_170)
			setText(arg2_170, arg0_170:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_171, arg1_171, arg2_171)
			local var0_171 = arg0_171:getConfig("desc")
			local var1_171 = _.map(arg0_171:getConfig("equip_type"), function(arg0_172)
				return EquipType.Type2Name2(arg0_172)
			end)

			setText(arg2_171, var0_171 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_171, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_173, arg1_173, arg2_173)
			setText(arg2_173, arg0_173:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_174, arg1_174, arg2_174)
			setText(arg2_174, arg0_174:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_175, arg1_175, arg2_175, arg3_175)
			local var0_175 = WorldCollectionProxy.GetCollectionType(arg0_175.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_175, i18n("world_" .. var0_175 .. "_desc", arg0_175:getConfig("name")))
			setText(arg3_175, i18n("world_" .. var0_175 .. "_name", arg0_175:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_176, arg1_176, arg2_176)
			setText(arg2_176, arg0_176:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_177, arg1_177, arg2_177)
			setText(arg2_177, arg0_177:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_178, arg1_178, arg2_178)
			setText(arg2_178, arg0_178:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_179, arg1_179, arg2_179)
			local var0_179 = string.gsub(arg0_179:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_179.count))

			setText(arg2_179, SwitchSpecialChar(var0_179, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_180, arg1_180, arg2_180)
			setText(arg2_180, arg0_180:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_181, arg1_181, arg2_181)
			setText(arg2_181, arg0_181:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_182, arg1_182, arg2_182)
			setText(arg2_182, arg0_182:getConfig("desc"))
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_183, arg1_183, arg2_183)
			setText(arg2_183, arg0_183:getConfig("display"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_184, arg1_184, arg2_184)
			setText(arg2_184, arg0_184:getConfig("desc"))
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_185, arg1_185, arg2_185)
		if arg0_185.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_185, arg0_185:getConfig("display"))
		else
			setText(arg2_185, arg0_185.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_186, arg1_186, arg2_186)
			if arg0_186.id == PlayerConst.ResStoreGold or arg0_186.id == PlayerConst.ResStoreOil then
				arg2_186 = arg2_186 or {}
				arg2_186.frame = "frame_store"
			end

			updateItem(arg1_186, Item.New({
				id = id2ItemId(arg0_186.id)
			}), arg2_186)
		end,
		[DROP_TYPE_ITEM] = function(arg0_187, arg1_187, arg2_187)
			updateItem(arg1_187, arg0_187:getSubClass(), arg2_187)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_188, arg1_188, arg2_188)
			updateEquipment(arg1_188, arg0_188:getSubClass(), arg2_188)
		end,
		[DROP_TYPE_SHIP] = function(arg0_189, arg1_189, arg2_189)
			updateShip(arg1_189, arg0_189.ship, arg2_189)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_190, arg1_190, arg2_190)
			updateShip(arg1_190, arg0_190.ship, arg2_190)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_191, arg1_191, arg2_191)
			updateFurniture(arg1_191, arg0_191, arg2_191)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_192, arg1_192, arg2_192)
			arg2_192.isWorldBuff = arg0_192.isWorldBuff

			updateStrategy(arg1_192, arg0_192, arg2_192)
		end,
		[DROP_TYPE_SKIN] = function(arg0_193, arg1_193, arg2_193)
			arg2_193.isSkin = true
			arg2_193.isNew = arg0_193.isNew

			updateShip(arg1_193, Ship.New({
				configId = tonumber(arg0_193:getConfig("ship_group") .. "1"),
				skin_id = arg0_193.id
			}), arg2_193)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_194, arg1_194, arg2_194)
			local var0_194 = setmetatable({
				count = arg0_194.count
			}, {
				__index = arg0_194:getConfigTable()
			})

			updateEquipmentSkin(arg1_194, var0_194, arg2_194)
		end,
		[DROP_TYPE_VITEM] = function(arg0_195, arg1_195, arg2_195)
			updateItem(arg1_195, Item.New({
				id = arg0_195.id
			}), arg2_195)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_196, arg1_196, arg2_196)
			updateWorldItem(arg1_196, WorldItem.New({
				id = arg0_196.id
			}), arg2_196)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_197, arg1_197, arg2_197)
			updateWorldCollection(arg1_197, arg0_197, arg2_197)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_198, arg1_198, arg2_198)
			updateAttire(arg1_198, AttireConst.TYPE_CHAT_FRAME, arg0_198:getConfigTable(), arg2_198)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_199, arg1_199, arg2_199)
			updateAttire(arg1_199, AttireConst.TYPE_ICON_FRAME, arg0_199:getConfigTable(), arg2_199)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_200, arg1_200, arg2_200)
			updateEmoji(arg1_200, arg0_200:getConfigTable(), arg2_200)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_201, arg1_201, arg2_201)
			arg2_201.count = 1

			updateItem(arg1_201, arg0_201:getSubClass(), arg2_201)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_202, arg1_202, arg2_202)
			updateSpWeapon(arg1_202, SpWeapon.New({
				id = arg0_202.id
			}), arg2_202)
		end,
		[DROP_TYPE_META_PT] = function(arg0_203, arg1_203, arg2_203)
			updateItem(arg1_203, Item.New({
				id = arg0_203:getConfig("id")
			}), arg2_203)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_204, arg1_204, arg2_204)
			arg2_204.isSkin = true
			arg2_204.isTimeLimit = true
			arg2_204.count = 1

			updateShip(arg1_204, Ship.New({
				configId = tonumber(arg0_204:getConfig("ship_group") .. "1"),
				skin_id = arg0_204.id
			}), arg2_204)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_205, arg1_205, arg2_205)
			AtelierMaterial.UpdateRyzaItem(arg1_205, arg0_205.item, arg2_205)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_206, arg1_206, arg2_206)
			WorkBenchItem.UpdateDrop(arg1_206, arg0_206.item, arg2_206)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_207, arg1_207, arg2_207)
			WorkBenchItem.UpdateDrop(arg1_207, WorkBenchItem.New({
				configId = arg0_207.id,
				count = arg0_207.count
			}), arg2_207)
		end,
		[DROP_TYPE_BUFF] = function(arg0_208, arg1_208, arg2_208)
			updateBuff(arg1_208, arg0_208.id, arg2_208)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_209, arg1_209, arg2_209)
			updateCommander(arg1_209, arg0_209, arg2_209)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_210, arg1_210, arg2_210)
			updateDorm3dFurniture(arg1_210, arg0_210, arg2_210)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_211, arg1_211, arg2_211)
			updateDorm3dGift(arg1_211, arg0_211, arg2_211)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_212, arg1_212, arg2_212)
			updateDorm3dSkin(arg1_212, arg0_212, arg2_212)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_213, arg1_213, arg2_213)
			updateCover(arg1_213, arg0_213, arg2_213)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_214, arg1_214, arg2_214)
			updateAttireCombatUI(arg1_214, AttireConst.TYPE_ICON_FRAME, arg0_214:getConfigTable(), arg2_214)
		end,
		[DROP_TYPE_ACTIVITY_MEDAL] = function(arg0_215, arg1_215, arg2_215)
			updateActivityMedal(arg1_215, arg0_215:getConfigTable(), arg2_215)
		end
	}

	function var0_0.UpdateDropDefault(arg0_216, arg1_216, arg2_216)
		warning(string.format("without dropType %d in updateDrop", arg0_216.type))
	end
end

return var0_0
