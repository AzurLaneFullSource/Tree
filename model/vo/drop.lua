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
		end
	}

	function var0_0.ConfigDefault(arg0_48)
		local var0_48 = arg0_48.type

		if var0_48 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_48 = pg.activity_drop_type[var0_48].relevance

			return var1_48 and pg[var1_48][arg0_48.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_49)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_49.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_50)
			local var0_50 = getProxy(BagProxy):getItemCountById(arg0_50.id)

			if arg0_50:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_50, 1), true
			else
				return var0_50, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_51)
			local var0_51 = arg0_51:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_51], "equip groupId not exist")

			local var1_51 = pg.equip_data_template.get_id_list_by_group[var0_51]

			return underscore.reduce(var1_51, 0, function(arg0_52, arg1_52)
				local var0_52 = getProxy(EquipmentProxy):getEquipmentById(arg1_52)

				return arg0_52 + (var0_52 and var0_52.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_52)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_53)
			return getProxy(BayProxy):getConfigShipCount(arg0_53.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_54)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_54.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_55)
			return arg0_55.count, tobool(arg0_55.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_56)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_56.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_57)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_57.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_58)
			if arg0_58:getConfig("virtual_type") == 22 then
				local var0_58 = getProxy(ActivityProxy):getActivityById(arg0_58:getConfig("link_id"))

				return var0_58 and var0_58.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_59)
			local var0_59 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_59.id)

			return (var0_59 and var0_59.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_59.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_60)
			local var0_60 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_60.type].activity_id):GetItemById(arg0_60.id)

			return var0_60 and var0_60.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_61)
			local var0_61 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_61.id)

			return var0_61 and (not var0_61:expiredType() or not not var0_61:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_62)
			local var0_62 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_62.id)

			return var0_62 and (not var0_62:expiredType() or not not var0_62:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_63)
			local var0_63 = nowWorld()

			if var0_63.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_63:GetInventoryProxy():GetItemCount(arg0_63.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_64)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_64.id)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_65)
			local var0_65 = getProxy(LivingAreaCoverProxy):GetCover(arg0_65.id)

			return var0_65 and var0_65:IsUnlock() and 1 or 0
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_66)
			return getProxy(ApartmentProxy):getGiftCount(arg0_66.id), true
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_67)
			local var0_67 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_67.id)

			return 1
		end
	}

	function var0_0.CountDefault(arg0_68)
		local var0_68 = arg0_68.type

		if var0_68 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_68].activity_id):getVitemNumber(arg0_68.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_69)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_70)
			return Item.New(arg0_70)
		end,
		[DROP_TYPE_VITEM] = function(arg0_71)
			return Item.New(arg0_71)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_72)
			return Equipment.New(arg0_72)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_73)
			return Item.New({
				count = 1,
				id = arg0_73.id,
				extra = arg0_73.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_74)
			return WorldItem.New(arg0_74)
		end
	}

	function var0_0.SubClassDefault(arg0_75)
		assert(false, string.format("drop type %d without subClass", arg0_75.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_76)
			return arg0_76:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_77)
			return arg0_77:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_78)
			return arg0_78:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_79)
			return arg0_79:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_80)
			return arg0_80:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_81)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_82)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_83)
			return arg0_83:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_84)
			return arg0_84:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_85)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_86)
			return arg0_86:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_87)
			return arg0_87:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_88)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_89)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_90)
			return arg0_90:getConfig("rare")
		end
	}

	function var0_0.RarityDefault(arg0_91)
		return arg0_91:getConfig("rarity") or ItemRarity.Gray
	end

	function var0_0.RarityDefaultDorm(arg0_92)
		return arg0_92:getConfig("rarity") or ItemRarity.Purple
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_93)
			local var0_93 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_93:getConfig("resource_type"),
				count = arg0_93:getConfig("resource_num") * arg0_93.count
			})
			local var1_93 = Drop.New({
				type = arg0_93:getConfig("target_type"),
				id = arg0_93:getConfig("target_id")
			})

			var0_93.name = string.format("%s(%s)", var0_93:getName(), var1_93:getName())

			return var0_93
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_94)
			for iter0_94, iter1_94 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_94.id].pt == arg0_94.id then
					return nil, arg0_94
				end
			end

			return arg0_94
		end,
		[DROP_TYPE_OPERATION] = function(arg0_95)
			if arg0_95.id ~= 3 then
				return nil
			end

			return arg0_95
		end,
		[DROP_TYPE_EMOJI] = function(arg0_96)
			return nil, arg0_96
		end,
		[DROP_TYPE_VITEM] = function(arg0_97, arg1_97, arg2_97)
			assert(arg0_97:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_97.id)

			return switch(arg0_97:getConfig("virtual_type"), {
				function()
					if arg0_97:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_97
					end

					return arg0_97
				end,
				[6] = function()
					local var0_99 = arg2_97.taskId
					local var1_99 = getProxy(ActivityProxy)
					local var2_99 = var1_99:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_99 then
						local var3_99 = var2_99.data1KeyValueList[1]

						var3_99[var0_99] = defaultValue(var3_99[var0_99], 0) + arg0_97.count

						var1_99:updateActivity(var2_99)
					end

					return nil, arg0_97
				end,
				[13] = function()
					local var0_100 = arg0_97:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_100))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_100))

						return nil
					elseif SkinCouponActivity.StaticOwnAllSkin() then
						if arg0_97.count > 1 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_100))
						end

						return SkinCouponActivity.StaticGetEquivalentRes(), nil
					else
						return arg0_97, nil
					end
				end,
				[21] = function()
					return nil, arg0_97
				end,
				[28] = function()
					local var0_102 = Drop.New({
						type = arg0_97.type,
						id = arg0_97.id,
						count = math.floor(arg0_97.count / 1000)
					})
					local var1_102 = Drop.New({
						type = arg0_97.type,
						id = arg0_97.id,
						count = arg0_97.count - math.floor(arg0_97.count / 1000)
					})

					return var0_102, var1_102
				end
			}, function()
				return arg0_97
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_104, arg1_104)
			if Ship.isMetaShipByConfigID(arg0_104.id) and Player.isMetaShipNeedToTrans(arg0_104.id) then
				local var0_104 = table.indexof(arg1_104, arg0_104.id, 1)

				if var0_104 then
					table.remove(arg1_104, var0_104)
				else
					local var1_104 = Player.metaShip2Res(arg0_104.id)
					local var2_104 = Drop.New(var1_104[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_104.id, var2_104)

					return arg0_104, var2_104
				end
			end

			return arg0_104
		end,
		[DROP_TYPE_SKIN] = function(arg0_105)
			arg0_105.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_105.id)

			return arg0_105
		end
	}

	function var0_0.TransDefault(arg0_106)
		return arg0_106
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_107)
			local var0_107 = id2res(arg0_107.id)

			assert(var0_107, "res should be defined: " .. arg0_107.id)

			local var1_107 = getProxy(PlayerProxy)
			local var2_107 = var1_107:getData()

			var2_107:addResources({
				[var0_107] = arg0_107.count
			})
			var1_107:updatePlayer(var2_107)
		end,
		[DROP_TYPE_ITEM] = function(arg0_108)
			if arg0_108:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_108 = getProxy(BagProxy):getItemCountById(arg0_108.id)
				local var1_108 = math.min(arg0_108:getConfig("max_num") - var0_108, arg0_108.count)

				if var1_108 > 0 then
					getProxy(BagProxy):addItemById(arg0_108.id, var1_108)
				end
			else
				getProxy(BagProxy):addItemById(arg0_108.id, arg0_108.count, arg0_108.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_109)
			local var0_109 = arg0_109:getSubClass()

			getProxy(BagProxy):addItemById(var0_109.id, var0_109.count, var0_109.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_110)
			getProxy(EquipmentProxy):addEquipmentById(arg0_110.id, arg0_110.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_111)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_112)
			local var0_112 = getProxy(DormProxy)
			local var1_112 = Furniture.New({
				id = arg0_112.id,
				count = arg0_112.count
			})

			if var1_112:isRecordTime() then
				var1_112.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_112:AddFurniture(var1_112)
		end,
		[DROP_TYPE_SKIN] = function(arg0_113)
			local var0_113 = getProxy(ShipSkinProxy)
			local var1_113 = ShipSkin.New({
				id = arg0_113.id
			})

			var0_113:addSkin(var1_113)
		end,
		[DROP_TYPE_VITEM] = function(arg0_114)
			arg0_114 = arg0_114:getSubClass()

			assert(arg0_114:isVirtualItem(), "item type error(virtual item)>>" .. arg0_114.id)
			switch(arg0_114:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_114.id, arg0_114.count)
				end,
				function()
					local var0_116 = getProxy(ActivityProxy)
					local var1_116 = arg0_114:getConfig("link_id")
					local var2_116

					if var1_116 > 0 then
						var2_116 = var0_116:getActivityById(var1_116)
					else
						var2_116 = var0_116:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_116 and not var2_116:isEnd() then
						if not table.contains(var2_116.data1_list, arg0_114.id) then
							table.insert(var2_116.data1_list, arg0_114.id)
						end

						var0_116:updateActivity(var2_116)
					end
				end,
				function()
					local var0_117 = getProxy(ActivityProxy)
					local var1_117 = var0_117:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_117, iter1_117 in ipairs(var1_117) do
						iter1_117.data1 = iter1_117.data1 + arg0_114.count

						local var2_117 = iter1_117:getConfig("config_id")
						local var3_117 = pg.activity_vote[var2_117]

						if var3_117 and var3_117.ticket_id_period == arg0_114.id then
							iter1_117.data3 = iter1_117.data3 + arg0_114.count
						end

						var0_117:updateActivity(iter1_117)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_114.id,
							ptCount = arg0_114.count
						})
					end
				end,
				[4] = function()
					local var0_118 = getProxy(ColoringProxy):getColorItems()

					var0_118[arg0_114.id] = (var0_118[arg0_114.id] or 0) + arg0_114.count
				end,
				[6] = function()
					local var0_119 = getProxy(ActivityProxy)
					local var1_119 = var0_119:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_119 then
						var1_119.data3 = var1_119.data3 + arg0_114.count

						var0_119:updateActivity(var1_119)
					end
				end,
				[7] = function()
					local var0_120 = getProxy(ChapterProxy)

					var0_120:updateRemasterTicketsNum(math.min(var0_120.remasterTickets + arg0_114.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_121 = getProxy(ActivityProxy)
					local var1_121 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_121 then
						var1_121.data1_list[1] = var1_121.data1_list[1] + arg0_114.count

						var0_121:updateActivity(var1_121)
					end
				end,
				[10] = function()
					local var0_122 = getProxy(ActivityProxy)
					local var1_122 = var0_122:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_122 and not var1_122:isEnd() then
						var1_122.data1 = var1_122.data1 + arg0_114.count

						var0_122:updateActivity(var1_122)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_122
						})
					end
				end,
				[11] = function()
					local var0_123 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_123 and not var0_123:isEnd() then
						var0_123.data1 = var0_123.data1 + arg0_114.count
					end
				end,
				[12] = function()
					local var0_124 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_124 and not var0_124:isEnd() then
						var0_124.data1KeyValueList[1][arg0_114.id] = (var0_124.data1KeyValueList[1][arg0_114.id] or 0) + arg0_114.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_114.id)
				end,
				[14] = function()
					local var0_126 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_114.id then
						var0_126:AddSummonPt(arg0_114.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_114.id then
						var0_126:AddSummonPtOld(arg0_114.count)
					end
				end,
				[15] = function()
					local var0_127 = getProxy(ActivityProxy)
					local var1_127 = var0_127:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

					if var1_127 and not var1_127:isEnd() then
						local var2_127 = pg.activity_event_grid[var1_127.data1]

						if arg0_114.id == var2_127.ticket_item then
							var1_127.data2 = var1_127.data2 + arg0_114.count
						elseif arg0_114.id == var2_127.explore_item then
							var1_127.data3 = var1_127.data3 + arg0_114.count
						end
					end

					var0_127:updateActivity(var1_127)
				end,
				[16] = function()
					local var0_128 = getProxy(ActivityProxy)
					local var1_128 = var0_128:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_128, iter1_128 in pairs(var1_128) do
						if iter1_128 and not iter1_128:isEnd() and arg0_114.id == iter1_128:getConfig("config_id") then
							iter1_128.data1 = iter1_128.data1 + arg0_114.count

							var0_128:updateActivity(iter1_128)
						end
					end
				end,
				[20] = function()
					local var0_129 = getProxy(BagProxy)
					local var1_129 = pg.gameset.urpt_chapter_max.description
					local var2_129 = var1_129[1]
					local var3_129 = var1_129[2]
					local var4_129 = var0_129:GetLimitCntById(var2_129)
					local var5_129 = math.min(var3_129 - var4_129, arg0_114.count)

					if var5_129 > 0 then
						var0_129:addItemById(var2_129, var5_129)
						var0_129:AddLimitCnt(var2_129, var5_129)
					end
				end,
				[21] = function()
					local var0_130 = getProxy(ActivityProxy)
					local var1_130 = var0_130:getActivityById(arg0_114:getConfig("link_id"))

					if var1_130 and not var1_130:isEnd() then
						var1_130.data2 = 1

						var0_130:updateActivity(var1_130)
					end
				end,
				[22] = function()
					local var0_131 = getProxy(ActivityProxy)
					local var1_131 = var0_131:getActivityById(arg0_114:getConfig("link_id"))

					if var1_131 and not var1_131:isEnd() then
						var1_131.data1 = var1_131.data1 + arg0_114.count

						var0_131:updateActivity(var1_131)
					end
				end,
				[23] = function()
					local var0_132 = (function()
						for iter0_133, iter1_133 in ipairs(pg.gameset.package_lv.description) do
							if arg0_114.id == iter1_133[1] then
								return iter1_133[2]
							end
						end
					end)()

					assert(var0_132)

					local var1_132 = getProxy(PlayerProxy)
					local var2_132 = var1_132:getData()

					var2_132:addExpToLevel(var0_132)
					var1_132:updatePlayer(var2_132)
				end,
				[24] = function()
					local var0_134 = arg0_114:getConfig("link_id")
					local var1_134 = getProxy(ActivityProxy):getActivityById(var0_134)

					if var1_134 and not var1_134:isEnd() and var1_134:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_134.data2 = var1_134.data2 + arg0_114.count

						getProxy(ActivityProxy):updateActivity(var1_134)
					end
				end,
				[25] = function()
					local var0_135 = getProxy(ActivityProxy)
					local var1_135 = var0_135:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_135 and not var1_135:isEnd() then
						var1_135.data1 = var1_135.data1 - 1

						if not table.contains(var1_135.data1_list, arg0_114.id) then
							table.insert(var1_135.data1_list, arg0_114.id)
						end

						var0_135:updateActivity(var1_135)

						local var2_135 = arg0_114:getConfig("link_id")

						if var2_135 > 0 then
							local var3_135 = var0_135:getActivityById(var2_135)

							if var3_135 and not var3_135:isEnd() then
								var3_135.data1 = var3_135.data1 + 1

								var0_135:updateActivity(var3_135)
							end
						end
					end
				end,
				[26] = function()
					local var0_136 = getProxy(ActivityProxy)
					local var1_136 = Clone(var0_136:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_136 and not var1_136:isEnd() then
						var1_136.data1 = var1_136.data1 + arg0_114.count

						var0_136:updateActivity(var1_136)
					end
				end,
				[27] = function()
					local var0_137 = getProxy(ActivityProxy)
					local var1_137 = Clone(var0_137:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_137 and not var1_137:isEnd() then
						var1_137:AddExp(arg0_114.count)
						var0_137:updateActivity(var1_137)
					end
				end,
				[28] = function()
					local var0_138 = getProxy(ActivityProxy)
					local var1_138 = Clone(var0_138:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_138 and not var1_138:isEnd() then
						var1_138:AddGold(arg0_114.count)
						var0_138:updateActivity(var1_138)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_141 = arg0_114:getConfig("link_id")
					local var1_141 = getProxy(ActivityProxy):getActivityById(var0_141)

					if var1_141 and not var1_141:isEnd() then
						var1_141.data1 = var1_141.data1 + arg0_114.count

						getProxy(ActivityProxy):updateActivity(var1_141)
					end
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_142)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_142.id, arg0_142.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_143)
			local var0_143 = getProxy(BayProxy)
			local var1_143 = var0_143:getShipById(arg0_143.count)

			if var1_143 then
				var1_143:unlockActivityNpc(0)
				var0_143:updateShip(var1_143)
				getProxy(CollectionProxy):flushCollection(var1_143)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_144)
			nowWorld():GetInventoryProxy():AddItem(arg0_144.id, arg0_144.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_145)
			local var0_145 = getProxy(AttireProxy)
			local var1_145 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_145 = IconFrame.New({
				id = arg0_145.id
			})
			local var3_145 = var1_145 + var2_145:getConfig("time_second")

			var2_145:updateData({
				isNew = true,
				end_time = var3_145
			})
			var0_145:addAttireFrame(var2_145)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_145)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_146)
			local var0_146 = getProxy(AttireProxy)
			local var1_146 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_146 = ChatFrame.New({
				id = arg0_146.id
			})
			local var3_146 = var1_146 + var2_146:getConfig("time_second")

			var2_146:updateData({
				isNew = true,
				end_time = var3_146
			})
			var0_146:addAttireFrame(var2_146)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_146)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_147)
			getProxy(EmojiProxy):addNewEmojiID(arg0_147.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_147:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_148)
			nowWorld():GetCollectionProxy():Unlock(arg0_148.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_149)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_149.id):addPT(arg0_149.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_150)
			local var0_150 = arg0_150.id
			local var1_150 = arg0_150.count
			local var2_150 = getProxy(ShipSkinProxy)
			local var3_150 = var2_150:getSkinById(var0_150)

			if var3_150 and var3_150:isExpireType() then
				local var4_150 = var1_150 + var3_150.endTime
				local var5_150 = ShipSkin.New({
					id = var0_150,
					end_time = var4_150
				})

				var2_150:addSkin(var5_150)
			elseif not var3_150 then
				local var6_150 = var1_150 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_150 = ShipSkin.New({
					id = var0_150,
					end_time = var6_150
				})

				var2_150:addSkin(var7_150)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_151)
			local var0_151 = arg0_151.id
			local var1_151 = pg.benefit_buff_template[var0_151]

			assert(var1_151 and var1_151.act_id > 0, "should exist act id")

			local var2_151 = getProxy(ActivityProxy):getActivityById(var1_151.act_id)

			if var2_151 and not var2_151:isEnd() then
				local var3_151 = var1_151.max_time
				local var4_151 = pg.TimeMgr.GetInstance():GetServerTime() + var3_151

				var2_151:AddBuff(ActivityBuff.New(var2_151.id, var0_151, var4_151))
				getProxy(ActivityProxy):updateActivity(var2_151)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_152)
			return
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_153)
			local var0_153 = getProxy(ApartmentProxy)
			local var1_153 = var0_153:getRoom(arg0_153:getConfig("room_id"))

			var1_153:AddFurnitureByID(arg0_153.id)
			var0_153:updateRoom(var1_153)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_154)
			getProxy(ApartmentProxy):changeGiftCount(arg0_154.id, arg0_154.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_155)
			local var0_155 = getProxy(ApartmentProxy)
			local var1_155 = var0_155:getApartment(arg0_155:getConfig("ship_group"))

			var1_155:addSkin(arg0_155.id)
			var0_155:updateApartment(var1_155)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_156)
			local var0_156 = getProxy(LivingAreaCoverProxy)
			local var1_156 = LivingAreaCover.New({
				unlock = true,
				isNew = true,
				id = arg0_156.id
			})

			var0_156:UpdateCover(var1_156)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COVER, var1_156)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataCover(arg0_156.id, 1))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_157)
			local var0_157 = getProxy(AttireProxy)
			local var1_157 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_157 = CombatUIStyle.New({
				id = arg0_157.id
			})

			var2_157:setUnlock()
			var2_157:setNew()
			var0_157:addAttireFrame(var2_157)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_157)
		end
	}

	function var0_0.AddItemDefault(arg0_158)
		if arg0_158.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_158 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_158.type].activity_id)

			if arg0_158.type == DROP_TYPE_RYZA_DROP then
				if var0_158 and not var0_158:isEnd() then
					var0_158:AddItem(AtelierMaterial.New({
						configId = arg0_158.id,
						count = arg0_158.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_158)
				end
			elseif var0_158 and not var0_158:isEnd() then
				var0_158:addVitemNumber(arg0_158.id, arg0_158.count)
				getProxy(ActivityProxy):updateActivity(var0_158)
			end
		else
			print("can not handle this type>>" .. arg0_158.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_159, arg1_159, arg2_159)
			setText(arg2_159, arg0_159:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_160, arg1_160, arg2_160)
			local var0_160 = arg0_160:getConfig("display")

			if arg0_160:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_160 = string.gsub(var0_160, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_160.extra))
			elseif arg0_160:getConfig("combination_display") ~= nil then
				local var1_160 = arg0_160:getConfig("combination_display")

				if var1_160 and #var1_160 > 0 then
					var0_160 = Item.StaticCombinationDisplay(var1_160)
				end
			end

			setText(arg2_160, SwitchSpecialChar(var0_160, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_161, arg1_161, arg2_161)
			setText(arg2_161, arg0_161:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_162, arg1_162, arg2_162)
			local var0_162 = arg0_162:getConfig("skin_id")
			local var1_162, var2_162, var3_162 = ShipWordHelper.GetWordAndCV(var0_162, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_162, var3_162 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_163, arg1_163, arg2_163)
			local var0_163 = arg0_163:getConfig("skin_id")
			local var1_163, var2_163, var3_163 = ShipWordHelper.GetWordAndCV(var0_163, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_163, var3_163 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_164, arg1_164, arg2_164)
			setText(arg2_164, arg1_164.name or arg0_164:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_165, arg1_165, arg2_165)
			local var0_165 = arg0_165:getConfig("desc")

			for iter0_165, iter1_165 in ipairs({
				arg0_165.count
			}) do
				var0_165 = string.gsub(var0_165, "$" .. iter0_165, iter1_165)
			end

			setText(arg2_165, var0_165)
		end,
		[DROP_TYPE_SKIN] = function(arg0_166, arg1_166, arg2_166)
			setText(arg2_166, arg0_166:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_167, arg1_167, arg2_167)
			setText(arg2_167, arg0_167:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_168, arg1_168, arg2_168)
			local var0_168 = arg0_168:getConfig("desc")
			local var1_168 = _.map(arg0_168:getConfig("equip_type"), function(arg0_169)
				return EquipType.Type2Name2(arg0_169)
			end)

			setText(arg2_168, var0_168 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_168, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_170, arg1_170, arg2_170)
			setText(arg2_170, arg0_170:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_171, arg1_171, arg2_171)
			setText(arg2_171, arg0_171:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_172, arg1_172, arg2_172, arg3_172)
			local var0_172 = WorldCollectionProxy.GetCollectionType(arg0_172.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_172, i18n("world_" .. var0_172 .. "_desc", arg0_172:getConfig("name")))
			setText(arg3_172, i18n("world_" .. var0_172 .. "_name", arg0_172:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_173, arg1_173, arg2_173)
			setText(arg2_173, arg0_173:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_174, arg1_174, arg2_174)
			setText(arg2_174, arg0_174:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_175, arg1_175, arg2_175)
			setText(arg2_175, arg0_175:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_176, arg1_176, arg2_176)
			local var0_176 = string.gsub(arg0_176:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_176.count))

			setText(arg2_176, SwitchSpecialChar(var0_176, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_177, arg1_177, arg2_177)
			setText(arg2_177, arg0_177:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_178, arg1_178, arg2_178)
			setText(arg2_178, arg0_178:getConfig("desc"))
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_179, arg1_179, arg2_179)
			setText(arg2_179, arg0_179:getConfig("desc"))
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_180, arg1_180, arg2_180)
			setText(arg2_180, arg0_180:getConfig("desc"))
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_181, arg1_181, arg2_181)
		if arg0_181.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_181, arg0_181:getConfig("display"))
		else
			setText(arg2_181, arg0_181.desc or "")
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_182, arg1_182, arg2_182)
			if arg0_182.id == PlayerConst.ResStoreGold or arg0_182.id == PlayerConst.ResStoreOil then
				arg2_182 = arg2_182 or {}
				arg2_182.frame = "frame_store"
			end

			updateItem(arg1_182, Item.New({
				id = id2ItemId(arg0_182.id)
			}), arg2_182)
		end,
		[DROP_TYPE_ITEM] = function(arg0_183, arg1_183, arg2_183)
			updateItem(arg1_183, arg0_183:getSubClass(), arg2_183)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_184, arg1_184, arg2_184)
			updateEquipment(arg1_184, arg0_184:getSubClass(), arg2_184)
		end,
		[DROP_TYPE_SHIP] = function(arg0_185, arg1_185, arg2_185)
			updateShip(arg1_185, arg0_185.ship, arg2_185)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_186, arg1_186, arg2_186)
			updateShip(arg1_186, arg0_186.ship, arg2_186)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_187, arg1_187, arg2_187)
			updateFurniture(arg1_187, arg0_187, arg2_187)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_188, arg1_188, arg2_188)
			arg2_188.isWorldBuff = arg0_188.isWorldBuff

			updateStrategy(arg1_188, arg0_188, arg2_188)
		end,
		[DROP_TYPE_SKIN] = function(arg0_189, arg1_189, arg2_189)
			arg2_189.isSkin = true
			arg2_189.isNew = arg0_189.isNew

			updateShip(arg1_189, Ship.New({
				configId = tonumber(arg0_189:getConfig("ship_group") .. "1"),
				skin_id = arg0_189.id
			}), arg2_189)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_190, arg1_190, arg2_190)
			local var0_190 = setmetatable({
				count = arg0_190.count
			}, {
				__index = arg0_190:getConfigTable()
			})

			updateEquipmentSkin(arg1_190, var0_190, arg2_190)
		end,
		[DROP_TYPE_VITEM] = function(arg0_191, arg1_191, arg2_191)
			updateItem(arg1_191, Item.New({
				id = arg0_191.id
			}), arg2_191)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_192, arg1_192, arg2_192)
			updateWorldItem(arg1_192, WorldItem.New({
				id = arg0_192.id
			}), arg2_192)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_193, arg1_193, arg2_193)
			updateWorldCollection(arg1_193, arg0_193, arg2_193)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_194, arg1_194, arg2_194)
			updateAttire(arg1_194, AttireConst.TYPE_CHAT_FRAME, arg0_194:getConfigTable(), arg2_194)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_195, arg1_195, arg2_195)
			updateAttire(arg1_195, AttireConst.TYPE_ICON_FRAME, arg0_195:getConfigTable(), arg2_195)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_196, arg1_196, arg2_196)
			updateEmoji(arg1_196, arg0_196:getConfigTable(), arg2_196)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_197, arg1_197, arg2_197)
			arg2_197.count = 1

			updateItem(arg1_197, arg0_197:getSubClass(), arg2_197)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_198, arg1_198, arg2_198)
			updateSpWeapon(arg1_198, SpWeapon.New({
				id = arg0_198.id
			}), arg2_198)
		end,
		[DROP_TYPE_META_PT] = function(arg0_199, arg1_199, arg2_199)
			updateItem(arg1_199, Item.New({
				id = arg0_199:getConfig("id")
			}), arg2_199)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_200, arg1_200, arg2_200)
			arg2_200.isSkin = true
			arg2_200.isTimeLimit = true
			arg2_200.count = 1

			updateShip(arg1_200, Ship.New({
				configId = tonumber(arg0_200:getConfig("ship_group") .. "1"),
				skin_id = arg0_200.id
			}), arg2_200)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_201, arg1_201, arg2_201)
			AtelierMaterial.UpdateRyzaItem(arg1_201, arg0_201.item, arg2_201)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_202, arg1_202, arg2_202)
			WorkBenchItem.UpdateDrop(arg1_202, arg0_202.item, arg2_202)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_203, arg1_203, arg2_203)
			WorkBenchItem.UpdateDrop(arg1_203, WorkBenchItem.New({
				configId = arg0_203.id,
				count = arg0_203.count
			}), arg2_203)
		end,
		[DROP_TYPE_BUFF] = function(arg0_204, arg1_204, arg2_204)
			updateBuff(arg1_204, arg0_204.id, arg2_204)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_205, arg1_205, arg2_205)
			updateCommander(arg1_205, arg0_205, arg2_205)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_206, arg1_206, arg2_206)
			updateDorm3dFurniture(arg1_206, arg0_206, arg2_206)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_207, arg1_207, arg2_207)
			updateDorm3dGift(arg1_207, arg0_207, arg2_207)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_208, arg1_208, arg2_208)
			updateDorm3dSkin(arg1_208, arg0_208, arg2_208)
		end,
		[DROP_TYPE_LIVINGAREA_COVER] = function(arg0_209, arg1_209, arg2_209)
			updateCover(arg1_209, arg0_209, arg2_209)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_210, arg1_210, arg2_210)
			updateAttireCombatUI(arg1_210, AttireConst.TYPE_ICON_FRAME, arg0_210:getConfigTable(), arg2_210)
		end
	}

	function var0_0.UpdateDropDefault(arg0_211, arg1_211, arg2_211)
		warning(string.format("without dropType %d in updateDrop", arg0_211.type))
	end
end

return var0_0
