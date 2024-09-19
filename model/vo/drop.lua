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
	return arg0_7:getConfig("icon")
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

function var0_0.DropTrans(arg0_13, ...)
	return switch(arg0_13.type, var0_0.TransCase, var0_0.TransDefault, arg0_13, ...)
end

function var0_0.AddItemOperation(arg0_14)
	return switch(arg0_14.type, var0_0.AddItemCase, var0_0.AddItemDefault, arg0_14)
end

function var0_0.MsgboxIntroSet(arg0_15, ...)
	return switch(arg0_15.type, var0_0.MsgboxIntroCase, var0_0.MsgboxIntroDefault, arg0_15, ...)
end

function var0_0.UpdateDropTpl(arg0_16, ...)
	return switch(arg0_16.type, var0_0.UpdateDropCase, var0_0.UpdateDropDefault, arg0_16, ...)
end

function var0_0.InitSwitch()
	var0_0.inited = true
	var0_0.ConfigCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_18)
			local var0_18 = Item.getConfigData(id2ItemId(arg0_18.id))

			arg0_18.desc = var0_18.display

			return var0_18
		end,
		[DROP_TYPE_ITEM] = function(arg0_19)
			local var0_19 = Item.getConfigData(arg0_19.id)

			arg0_19.desc = var0_19.display

			if var0_19.type == Item.LOVE_LETTER_TYPE then
				arg0_19.desc = string.gsub(arg0_19.desc, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_19.extra))
			end

			return var0_19
		end,
		[DROP_TYPE_VITEM] = function(arg0_20)
			local var0_20 = Item.getConfigData(arg0_20.id)

			arg0_20.desc = var0_20.display

			return var0_20
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_21)
			local var0_21 = Item.getConfigData(arg0_21.id)

			arg0_21.desc = string.gsub(var0_21.display, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_21.count))

			return var0_21
		end,
		[DROP_TYPE_EQUIP] = function(arg0_22)
			local var0_22 = Equipment.getConfigData(arg0_22.id)

			arg0_22.desc = var0_22.descrip

			return var0_22
		end,
		[DROP_TYPE_SHIP] = function(arg0_23)
			local var0_23 = pg.ship_data_statistics[arg0_23.id]
			local var1_23, var2_23, var3_23 = ShipWordHelper.GetWordAndCV(var0_23.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_23.desc = var3_23 or i18n("ship_drop_desc_default")
			arg0_23.ship = Ship.New({
				configId = arg0_23.id,
				skin_id = arg0_23.skinId,
				propose = arg0_23.propose
			})
			arg0_23.ship.remoulded = arg0_23.remoulded
			arg0_23.ship.virgin = arg0_23.virgin

			return var0_23
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_24)
			local var0_24 = pg.furniture_data_template[arg0_24.id]

			arg0_24.desc = var0_24.describe

			return var0_24
		end,
		[DROP_TYPE_SKIN] = function(arg0_25)
			local var0_25 = pg.ship_skin_template[arg0_25.id]
			local var1_25, var2_25, var3_25 = ShipWordHelper.GetWordAndCV(arg0_25.id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_25.desc = var3_25

			return var0_25
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_26)
			local var0_26 = pg.ship_skin_template[arg0_26.id]
			local var1_26, var2_26, var3_26 = ShipWordHelper.GetWordAndCV(arg0_26.id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_26.desc = var3_26

			return var0_26
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_27)
			local var0_27 = pg.equip_skin_template[arg0_27.id]

			arg0_27.desc = var0_27.desc

			return var0_27
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_28)
			local var0_28 = pg.world_item_data_template[arg0_28.id]

			arg0_28.desc = var0_28.display

			return var0_28
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_29)
			return pg.item_data_frame[arg0_29.id]
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_30)
			return pg.item_data_chat[arg0_30.id]
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_31)
			local var0_31 = pg.spweapon_data_statistics[arg0_31.id]

			arg0_31.desc = var0_31.descrip

			return var0_31
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_32)
			local var0_32 = pg.activity_ryza_item[arg0_32.id]

			arg0_32.item = AtelierMaterial.New({
				configId = arg0_32.id
			})
			arg0_32.desc = arg0_32.item:GetDesc()

			return var0_32
		end,
		[DROP_TYPE_OPERATION] = function(arg0_33)
			arg0_33.ship = getProxy(BayProxy):getShipById(arg0_33.count)

			local var0_33 = pg.ship_data_statistics[arg0_33.ship.configId]
			local var1_33, var2_33, var3_33 = ShipWordHelper.GetWordAndCV(var0_33.skin_id, ShipWordHelper.WORD_TYPE_DROP)

			arg0_33.desc = var3_33 or i18n("ship_drop_desc_default")

			return var0_33
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_34)
			return arg0_34.isWorldBuff and pg.world_SLGbuff_data[arg0_34.id] or pg.strategy_data_template[arg0_34.id]
		end,
		[DROP_TYPE_EMOJI] = function(arg0_35)
			local var0_35 = pg.emoji_template[arg0_35.id]

			arg0_35.name = var0_35.item_name
			arg0_35.desc = var0_35.item_desc

			return var0_35
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_36)
			local var0_36 = WorldCollectionProxy.GetCollectionTemplate(arg0_36.id)

			arg0_36.desc = var0_36.name

			return var0_36
		end,
		[DROP_TYPE_META_PT] = function(arg0_37)
			local var0_37 = pg.ship_strengthen_meta[arg0_37.id]
			local var1_37 = Item.getConfigData(var0_37.itemid)

			arg0_37.desc = var1_37.display

			return var1_37
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_38)
			local var0_38 = pg.activity_workbench_item[arg0_38.id]

			arg0_38.item = WorkBenchItem.New({
				configId = arg0_38.id
			})
			arg0_38.desc = arg0_38.item:GetDesc()

			return var0_38
		end,
		[DROP_TYPE_BUFF] = function(arg0_39)
			local var0_39 = pg.benefit_buff_template[arg0_39.id]

			arg0_39.desc = var0_39.desc

			return var0_39
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_40)
			local var0_40 = pg.commander_data_template[arg0_40.id]

			arg0_40.desc = ""

			return var0_40
		end,
		[DROP_TYPE_TRANS_ITEM] = function(arg0_41)
			return pg.drop_data_restore[arg0_41.id]
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_42)
			local var0_42 = pg.dorm3d_furniture_template[arg0_42.id]

			arg0_42.desc = var0_42.desc

			return var0_42
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_43)
			local var0_43 = pg.dorm3d_gift[arg0_43.id]

			arg0_43.desc = ""

			return var0_43
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_44)
			local var0_44 = pg.dorm3d_resource[arg0_44.id]

			arg0_44.desc = ""

			return var0_44
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_45)
			return pg.item_data_battleui[arg0_45.id]
		end
	}

	function var0_0.ConfigDefault(arg0_46)
		local var0_46 = arg0_46.type

		if var0_46 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_46 = pg.activity_drop_type[var0_46].relevance

			return var1_46 and pg[var1_46][arg0_46.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_47)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_47.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_48)
			local var0_48 = getProxy(BagProxy):getItemCountById(arg0_48.id)

			if arg0_48:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_48, 1), true
			else
				return var0_48, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_49)
			local var0_49 = arg0_49:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_49], "equip groupId not exist")

			local var1_49 = pg.equip_data_template.get_id_list_by_group[var0_49]

			return underscore.reduce(var1_49, 0, function(arg0_50, arg1_50)
				local var0_50 = getProxy(EquipmentProxy):getEquipmentById(arg1_50)

				return arg0_50 + (var0_50 and var0_50.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_50)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_51)
			return getProxy(BayProxy):getConfigShipCount(arg0_51.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_52)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_52.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_53)
			return arg0_53.count, tobool(arg0_53.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_54)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_54.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_55)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_55.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_56)
			if arg0_56:getConfig("virtual_type") == 22 then
				local var0_56 = getProxy(ActivityProxy):getActivityById(arg0_56:getConfig("link_id"))

				return var0_56 and var0_56.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_57)
			local var0_57 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_57.id)

			return (var0_57 and var0_57.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_57.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_58)
			local var0_58 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_58.type].activity_id):GetItemById(arg0_58.id)

			return var0_58 and var0_58.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_59)
			local var0_59 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_59.id)

			return var0_59 and (not var0_59:expiredType() or not not var0_59:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_60)
			local var0_60 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_60.id)

			return var0_60 and (not var0_60:expiredType() or not not var0_60:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_61)
			local var0_61 = nowWorld()

			if var0_61.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_61:GetInventoryProxy():GetItemCount(arg0_61.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_62)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_62.id)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_63)
			local var0_63 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_COMBAT_UI_STYLE, arg0_63.id)

			return 1
		end
	}

	function var0_0.CountDefault(arg0_64)
		local var0_64 = arg0_64.type

		if var0_64 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_64].activity_id):getVitemNumber(arg0_64.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_65)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_66)
			return Item.New(arg0_66)
		end,
		[DROP_TYPE_VITEM] = function(arg0_67)
			return Item.New(arg0_67)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_68)
			return Equipment.New(arg0_68)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_69)
			return Item.New({
				count = 1,
				id = arg0_69.id,
				extra = arg0_69.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_70)
			return WorldItem.New(arg0_70)
		end
	}

	function var0_0.SubClassDefault(arg0_71)
		assert(false, string.format("drop type %d without subClass", arg0_71.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_72)
			return arg0_72:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_73)
			return arg0_73:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_74)
			return arg0_74:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_75)
			return arg0_75:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_76)
			return arg0_76:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_77)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_78)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_79)
			return arg0_79:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_80)
			return arg0_80:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_81)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_82)
			return arg0_82:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_83)
			return arg0_83:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_84)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_85)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_86)
			return arg0_86:getConfig("rare")
		end
	}

	function var0_0.RarityDefault(arg0_87)
		return 1
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_88)
			local var0_88 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_88:getConfig("resource_type"),
				count = arg0_88:getConfig("resource_num") * arg0_88.count
			})
			local var1_88 = Drop.New({
				type = arg0_88:getConfig("target_type"),
				id = arg0_88:getConfig("target_id")
			})

			var0_88.name = string.format("%s(%s)", var0_88:getName(), var1_88:getName())

			return var0_88
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_89)
			for iter0_89, iter1_89 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_89.id].pt == arg0_89.id then
					return nil, arg0_89
				end
			end

			return arg0_89
		end,
		[DROP_TYPE_OPERATION] = function(arg0_90)
			if arg0_90.id ~= 3 then
				return nil
			end

			return arg0_90
		end,
		[DROP_TYPE_EMOJI] = function(arg0_91)
			return nil, arg0_91
		end,
		[DROP_TYPE_VITEM] = function(arg0_92, arg1_92, arg2_92)
			assert(arg0_92:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_92.id)

			return switch(arg0_92:getConfig("virtual_type"), {
				function()
					if arg0_92:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_92
					end

					return arg0_92
				end,
				[6] = function()
					local var0_94 = arg2_92.taskId
					local var1_94 = getProxy(ActivityProxy)
					local var2_94 = var1_94:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_94 then
						local var3_94 = var2_94.data1KeyValueList[1]

						var3_94[var0_94] = defaultValue(var3_94[var0_94], 0) + arg0_92.count

						var1_94:updateActivity(var2_94)
					end

					return nil, arg0_92
				end,
				[13] = function()
					local var0_95 = arg0_92:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_95))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_95))

						return nil
					elseif SkinCouponActivity.StaticOwnAllSkin() then
						if arg0_92.count > 1 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_95))
						end

						return SkinCouponActivity.StaticGetEquivalentRes(), nil
					else
						return arg0_92, nil
					end
				end,
				[21] = function()
					return nil, arg0_92
				end,
				[28] = function()
					local var0_97 = Drop.New({
						type = arg0_92.type,
						id = arg0_92.id,
						count = math.floor(arg0_92.count / 1000)
					})
					local var1_97 = Drop.New({
						type = arg0_92.type,
						id = arg0_92.id,
						count = arg0_92.count - math.floor(arg0_92.count / 1000)
					})

					return var0_97, var1_97
				end
			}, function()
				return arg0_92
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_99, arg1_99)
			if Ship.isMetaShipByConfigID(arg0_99.id) and Player.isMetaShipNeedToTrans(arg0_99.id) then
				local var0_99 = table.indexof(arg1_99, arg0_99.id, 1)

				if var0_99 then
					table.remove(arg1_99, var0_99)
				else
					local var1_99 = Player.metaShip2Res(arg0_99.id)
					local var2_99 = Drop.New(var1_99[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_99.id, var2_99)

					return arg0_99, var2_99
				end
			end

			return arg0_99
		end,
		[DROP_TYPE_SKIN] = function(arg0_100)
			arg0_100.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_100.id)

			return arg0_100
		end
	}

	function var0_0.TransDefault(arg0_101)
		return arg0_101
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_102)
			local var0_102 = id2res(arg0_102.id)

			assert(var0_102, "res should be defined: " .. arg0_102.id)

			local var1_102 = getProxy(PlayerProxy)
			local var2_102 = var1_102:getData()

			var2_102:addResources({
				[var0_102] = arg0_102.count
			})
			var1_102:updatePlayer(var2_102)
		end,
		[DROP_TYPE_ITEM] = function(arg0_103)
			if arg0_103:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_103 = getProxy(BagProxy):getItemCountById(arg0_103.id)
				local var1_103 = math.min(arg0_103:getConfig("max_num") - var0_103, arg0_103.count)

				if var1_103 > 0 then
					getProxy(BagProxy):addItemById(arg0_103.id, var1_103)
				end
			else
				getProxy(BagProxy):addItemById(arg0_103.id, arg0_103.count, arg0_103.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_104)
			local var0_104 = arg0_104:getSubClass()

			getProxy(BagProxy):addItemById(var0_104.id, var0_104.count, var0_104.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_105)
			getProxy(EquipmentProxy):addEquipmentById(arg0_105.id, arg0_105.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_106)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_107)
			local var0_107 = getProxy(DormProxy)
			local var1_107 = Furniture.New({
				id = arg0_107.id,
				count = arg0_107.count
			})

			if var1_107:isRecordTime() then
				var1_107.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_107:AddFurniture(var1_107)
		end,
		[DROP_TYPE_SKIN] = function(arg0_108)
			local var0_108 = getProxy(ShipSkinProxy)
			local var1_108 = ShipSkin.New({
				id = arg0_108.id
			})

			var0_108:addSkin(var1_108)
		end,
		[DROP_TYPE_VITEM] = function(arg0_109)
			arg0_109 = arg0_109:getSubClass()

			assert(arg0_109:isVirtualItem(), "item type error(virtual item)>>" .. arg0_109.id)
			switch(arg0_109:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_109.id, arg0_109.count)
				end,
				function()
					local var0_111 = getProxy(ActivityProxy)
					local var1_111 = arg0_109:getConfig("link_id")
					local var2_111

					if var1_111 > 0 then
						var2_111 = var0_111:getActivityById(var1_111)
					else
						var2_111 = var0_111:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_111 and not var2_111:isEnd() then
						if not table.contains(var2_111.data1_list, arg0_109.id) then
							table.insert(var2_111.data1_list, arg0_109.id)
						end

						var0_111:updateActivity(var2_111)
					end
				end,
				function()
					local var0_112 = getProxy(ActivityProxy)
					local var1_112 = var0_112:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_112, iter1_112 in ipairs(var1_112) do
						iter1_112.data1 = iter1_112.data1 + arg0_109.count

						local var2_112 = iter1_112:getConfig("config_id")
						local var3_112 = pg.activity_vote[var2_112]

						if var3_112 and var3_112.ticket_id_period == arg0_109.id then
							iter1_112.data3 = iter1_112.data3 + arg0_109.count
						end

						var0_112:updateActivity(iter1_112)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_109.id,
							ptCount = arg0_109.count
						})
					end
				end,
				[4] = function()
					local var0_113 = getProxy(ColoringProxy):getColorItems()

					var0_113[arg0_109.id] = (var0_113[arg0_109.id] or 0) + arg0_109.count
				end,
				[6] = function()
					local var0_114 = getProxy(ActivityProxy)
					local var1_114 = var0_114:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_114 then
						var1_114.data3 = var1_114.data3 + arg0_109.count

						var0_114:updateActivity(var1_114)
					end
				end,
				[7] = function()
					local var0_115 = getProxy(ChapterProxy)

					var0_115:updateRemasterTicketsNum(math.min(var0_115.remasterTickets + arg0_109.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_116 = getProxy(ActivityProxy)
					local var1_116 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_116 then
						var1_116.data1_list[1] = var1_116.data1_list[1] + arg0_109.count

						var0_116:updateActivity(var1_116)
					end
				end,
				[10] = function()
					local var0_117 = getProxy(ActivityProxy)
					local var1_117 = var0_117:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_117 and not var1_117:isEnd() then
						var1_117.data1 = var1_117.data1 + arg0_109.count

						var0_117:updateActivity(var1_117)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_117
						})
					end
				end,
				[11] = function()
					local var0_118 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_118 and not var0_118:isEnd() then
						var0_118.data1 = var0_118.data1 + arg0_109.count
					end
				end,
				[12] = function()
					local var0_119 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_119 and not var0_119:isEnd() then
						var0_119.data1KeyValueList[1][arg0_109.id] = (var0_119.data1KeyValueList[1][arg0_109.id] or 0) + arg0_109.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_109.id)
				end,
				[14] = function()
					local var0_121 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_109.id then
						var0_121:AddSummonPt(arg0_109.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_109.id then
						var0_121:AddSummonPtOld(arg0_109.count)
					end
				end,
				[15] = function()
					local var0_122 = getProxy(ActivityProxy)
					local var1_122 = var0_122:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

					if var1_122 and not var1_122:isEnd() then
						local var2_122 = pg.activity_event_grid[var1_122.data1]

						if arg0_109.id == var2_122.ticket_item then
							var1_122.data2 = var1_122.data2 + arg0_109.count
						elseif arg0_109.id == var2_122.explore_item then
							var1_122.data3 = var1_122.data3 + arg0_109.count
						end
					end

					var0_122:updateActivity(var1_122)
				end,
				[16] = function()
					local var0_123 = getProxy(ActivityProxy)
					local var1_123 = var0_123:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_123, iter1_123 in pairs(var1_123) do
						if iter1_123 and not iter1_123:isEnd() and arg0_109.id == iter1_123:getConfig("config_id") then
							iter1_123.data1 = iter1_123.data1 + arg0_109.count

							var0_123:updateActivity(iter1_123)
						end
					end
				end,
				[20] = function()
					local var0_124 = getProxy(BagProxy)
					local var1_124 = pg.gameset.urpt_chapter_max.description
					local var2_124 = var1_124[1]
					local var3_124 = var1_124[2]
					local var4_124 = var0_124:GetLimitCntById(var2_124)
					local var5_124 = math.min(var3_124 - var4_124, arg0_109.count)

					if var5_124 > 0 then
						var0_124:addItemById(var2_124, var5_124)
						var0_124:AddLimitCnt(var2_124, var5_124)
					end
				end,
				[21] = function()
					local var0_125 = getProxy(ActivityProxy)
					local var1_125 = var0_125:getActivityById(arg0_109:getConfig("link_id"))

					if var1_125 and not var1_125:isEnd() then
						var1_125.data2 = 1

						var0_125:updateActivity(var1_125)
					end
				end,
				[22] = function()
					local var0_126 = getProxy(ActivityProxy)
					local var1_126 = var0_126:getActivityById(arg0_109:getConfig("link_id"))

					if var1_126 and not var1_126:isEnd() then
						var1_126.data1 = var1_126.data1 + arg0_109.count

						var0_126:updateActivity(var1_126)
					end
				end,
				[23] = function()
					local var0_127 = (function()
						for iter0_128, iter1_128 in ipairs(pg.gameset.package_lv.description) do
							if arg0_109.id == iter1_128[1] then
								return iter1_128[2]
							end
						end
					end)()

					assert(var0_127)

					local var1_127 = getProxy(PlayerProxy)
					local var2_127 = var1_127:getData()

					var2_127:addExpToLevel(var0_127)
					var1_127:updatePlayer(var2_127)
				end,
				[24] = function()
					local var0_129 = arg0_109:getConfig("link_id")
					local var1_129 = getProxy(ActivityProxy):getActivityById(var0_129)

					if var1_129 and not var1_129:isEnd() and var1_129:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_129.data2 = var1_129.data2 + arg0_109.count

						getProxy(ActivityProxy):updateActivity(var1_129)
					end
				end,
				[25] = function()
					local var0_130 = getProxy(ActivityProxy)
					local var1_130 = var0_130:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_130 and not var1_130:isEnd() then
						var1_130.data1 = var1_130.data1 - 1

						if not table.contains(var1_130.data1_list, arg0_109.id) then
							table.insert(var1_130.data1_list, arg0_109.id)
						end

						var0_130:updateActivity(var1_130)

						local var2_130 = arg0_109:getConfig("link_id")

						if var2_130 > 0 then
							local var3_130 = var0_130:getActivityById(var2_130)

							if var3_130 and not var3_130:isEnd() then
								var3_130.data1 = var3_130.data1 + 1

								var0_130:updateActivity(var3_130)
							end
						end
					end
				end,
				[26] = function()
					local var0_131 = getProxy(ActivityProxy)
					local var1_131 = Clone(var0_131:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_131 and not var1_131:isEnd() then
						var1_131.data1 = var1_131.data1 + arg0_109.count

						var0_131:updateActivity(var1_131)
					end
				end,
				[27] = function()
					local var0_132 = getProxy(ActivityProxy)
					local var1_132 = Clone(var0_132:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_132 and not var1_132:isEnd() then
						var1_132:AddExp(arg0_109.count)
						var0_132:updateActivity(var1_132)
					end
				end,
				[28] = function()
					local var0_133 = getProxy(ActivityProxy)
					local var1_133 = Clone(var0_133:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_133 and not var1_133:isEnd() then
						var1_133:AddGold(arg0_109.count)
						var0_133:updateActivity(var1_133)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_136 = arg0_109:getConfig("link_id")
					local var1_136 = getProxy(ActivityProxy):getActivityById(var0_136)

					if var1_136 and not var1_136:isEnd() then
						var1_136.data1 = var1_136.data1 + arg0_109.count

						getProxy(ActivityProxy):updateActivity(var1_136)
					end
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_137)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_137.id, arg0_137.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_138)
			local var0_138 = getProxy(BayProxy)
			local var1_138 = var0_138:getShipById(arg0_138.count)

			if var1_138 then
				var1_138:unlockActivityNpc(0)
				var0_138:updateShip(var1_138)
				getProxy(CollectionProxy):flushCollection(var1_138)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_139)
			nowWorld():GetInventoryProxy():AddItem(arg0_139.id, arg0_139.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_140)
			local var0_140 = getProxy(AttireProxy)
			local var1_140 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_140 = IconFrame.New({
				id = arg0_140.id
			})
			local var3_140 = var1_140 + var2_140:getConfig("time_second")

			var2_140:updateData({
				isNew = true,
				end_time = var3_140
			})
			var0_140:addAttireFrame(var2_140)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_140)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_141)
			local var0_141 = getProxy(AttireProxy)
			local var1_141 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_141 = ChatFrame.New({
				id = arg0_141.id
			})
			local var3_141 = var1_141 + var2_141:getConfig("time_second")

			var2_141:updateData({
				isNew = true,
				end_time = var3_141
			})
			var0_141:addAttireFrame(var2_141)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_141)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_142)
			getProxy(EmojiProxy):addNewEmojiID(arg0_142.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_142:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_143)
			nowWorld():GetCollectionProxy():Unlock(arg0_143.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_144)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_144.id):addPT(arg0_144.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_145)
			local var0_145 = arg0_145.id
			local var1_145 = arg0_145.count
			local var2_145 = getProxy(ShipSkinProxy)
			local var3_145 = var2_145:getSkinById(var0_145)

			if var3_145 and var3_145:isExpireType() then
				local var4_145 = var1_145 + var3_145.endTime
				local var5_145 = ShipSkin.New({
					id = var0_145,
					end_time = var4_145
				})

				var2_145:addSkin(var5_145)
			elseif not var3_145 then
				local var6_145 = var1_145 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_145 = ShipSkin.New({
					id = var0_145,
					end_time = var6_145
				})

				var2_145:addSkin(var7_145)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_146)
			local var0_146 = arg0_146.id
			local var1_146 = pg.benefit_buff_template[var0_146]

			assert(var1_146 and var1_146.act_id > 0, "should exist act id")

			local var2_146 = getProxy(ActivityProxy):getActivityById(var1_146.act_id)

			if var2_146 and not var2_146:isEnd() then
				local var3_146 = var1_146.max_time
				local var4_146 = pg.TimeMgr.GetInstance():GetServerTime() + var3_146

				var2_146:AddBuff(ActivityBuff.New(var2_146.id, var0_146, var4_146))
				getProxy(ActivityProxy):updateActivity(var2_146)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_147)
			return
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_148)
			getProxy(ApartmentProxy):changeGiftCount(arg0_148.id, arg0_148.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_149)
			local var0_149 = getProxy(ApartmentProxy)
			local var1_149 = var0_149:getApartment(arg0_149:getConfig("ship_group"))

			var1_149:addSkin(arg0_149.id)
			var0_149:updateApartment(var1_149)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_150)
			local var0_150 = getProxy(AttireProxy)
			local var1_150 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_150 = CombatUIStyle.New({
				id = arg0_150.id
			})

			var2_150:setUnlock()
			var2_150:setNew()
			var0_150:addAttireFrame(var2_150)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_150)
		end
	}

	function var0_0.AddItemDefault(arg0_151)
		if arg0_151.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_151 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_151.type].activity_id)

			if arg0_151.type == DROP_TYPE_RYZA_DROP then
				if var0_151 and not var0_151:isEnd() then
					var0_151:AddItem(AtelierMaterial.New({
						configId = arg0_151.id,
						count = arg0_151.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_151)
				end
			elseif var0_151 and not var0_151:isEnd() then
				var0_151:addVitemNumber(arg0_151.id, arg0_151.count)
				getProxy(ActivityProxy):updateActivity(var0_151)
			end
		else
			print("can not handle this type>>" .. arg0_151.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_152, arg1_152, arg2_152)
			setText(arg2_152, arg0_152:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_153, arg1_153, arg2_153)
			local var0_153 = arg0_153:getConfig("display")

			if arg0_153:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_153 = string.gsub(var0_153, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_153.extra))
			elseif arg0_153:getConfig("combination_display") ~= nil then
				local var1_153 = arg0_153:getConfig("combination_display")

				if var1_153 and #var1_153 > 0 then
					var0_153 = Item.StaticCombinationDisplay(var1_153)
				end
			end

			setText(arg2_153, SwitchSpecialChar(var0_153, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_154, arg1_154, arg2_154)
			setText(arg2_154, arg0_154:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_155, arg1_155, arg2_155)
			local var0_155 = arg0_155:getConfig("skin_id")
			local var1_155, var2_155, var3_155 = ShipWordHelper.GetWordAndCV(var0_155, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_155, var3_155 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_156, arg1_156, arg2_156)
			local var0_156 = arg0_156:getConfig("skin_id")
			local var1_156, var2_156, var3_156 = ShipWordHelper.GetWordAndCV(var0_156, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_156, var3_156 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_157, arg1_157, arg2_157)
			setText(arg2_157, arg1_157.name or arg0_157:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_158, arg1_158, arg2_158)
			local var0_158 = arg0_158:getConfig("desc")

			for iter0_158, iter1_158 in ipairs({
				arg0_158.count
			}) do
				var0_158 = string.gsub(var0_158, "$" .. iter0_158, iter1_158)
			end

			setText(arg2_158, var0_158)
		end,
		[DROP_TYPE_SKIN] = function(arg0_159, arg1_159, arg2_159)
			setText(arg2_159, arg0_159:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_160, arg1_160, arg2_160)
			setText(arg2_160, arg0_160:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_161, arg1_161, arg2_161)
			local var0_161 = arg0_161:getConfig("desc")
			local var1_161 = _.map(arg0_161:getConfig("equip_type"), function(arg0_162)
				return EquipType.Type2Name2(arg0_162)
			end)

			setText(arg2_161, var0_161 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_161, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_163, arg1_163, arg2_163)
			setText(arg2_163, arg0_163:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_164, arg1_164, arg2_164)
			setText(arg2_164, arg0_164:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_165, arg1_165, arg2_165, arg3_165)
			local var0_165 = WorldCollectionProxy.GetCollectionType(arg0_165.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_165, i18n("world_" .. var0_165 .. "_desc", arg0_165:getConfig("name")))
			setText(arg3_165, i18n("world_" .. var0_165 .. "_name", arg0_165:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_166, arg1_166, arg2_166)
			setText(arg2_166, arg0_166:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_167, arg1_167, arg2_167)
			setText(arg2_167, arg0_167:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_168, arg1_168, arg2_168)
			setText(arg2_168, arg0_168:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_169, arg1_169, arg2_169)
			local var0_169 = string.gsub(arg0_169:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_169.count))

			setText(arg2_169, SwitchSpecialChar(var0_169, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_170, arg1_170, arg2_170)
			setText(arg2_170, arg0_170:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_171, arg1_171, arg2_171)
			setText(arg2_171, arg0_171:getConfig("desc"))
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_172, arg1_172, arg2_172)
			setText(arg2_172, "")
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_173, arg1_173, arg2_173)
			setText(arg2_173, arg0_173:getConfig("desc"))
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_174, arg1_174, arg2_174)
		if arg0_174.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_174, arg0_174:getConfig("display"))
		else
			assert(false, "can not handle this type>>" .. arg0_174.type)
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_175, arg1_175, arg2_175)
			if arg0_175.id == PlayerConst.ResStoreGold or arg0_175.id == PlayerConst.ResStoreOil then
				arg2_175 = arg2_175 or {}
				arg2_175.frame = "frame_store"
			end

			updateItem(arg1_175, Item.New({
				id = id2ItemId(arg0_175.id)
			}), arg2_175)
		end,
		[DROP_TYPE_ITEM] = function(arg0_176, arg1_176, arg2_176)
			updateItem(arg1_176, arg0_176:getSubClass(), arg2_176)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_177, arg1_177, arg2_177)
			updateEquipment(arg1_177, arg0_177:getSubClass(), arg2_177)
		end,
		[DROP_TYPE_SHIP] = function(arg0_178, arg1_178, arg2_178)
			updateShip(arg1_178, arg0_178.ship, arg2_178)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_179, arg1_179, arg2_179)
			updateShip(arg1_179, arg0_179.ship, arg2_179)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_180, arg1_180, arg2_180)
			updateFurniture(arg1_180, arg0_180, arg2_180)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_181, arg1_181, arg2_181)
			arg2_181.isWorldBuff = arg0_181.isWorldBuff

			updateStrategy(arg1_181, arg0_181, arg2_181)
		end,
		[DROP_TYPE_SKIN] = function(arg0_182, arg1_182, arg2_182)
			arg2_182.isSkin = true
			arg2_182.isNew = arg0_182.isNew

			updateShip(arg1_182, Ship.New({
				configId = tonumber(arg0_182:getConfig("ship_group") .. "1"),
				skin_id = arg0_182.id
			}), arg2_182)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_183, arg1_183, arg2_183)
			local var0_183 = setmetatable({
				count = arg0_183.count
			}, {
				__index = arg0_183:getConfigTable()
			})

			updateEquipmentSkin(arg1_183, var0_183, arg2_183)
		end,
		[DROP_TYPE_VITEM] = function(arg0_184, arg1_184, arg2_184)
			updateItem(arg1_184, Item.New({
				id = arg0_184.id
			}), arg2_184)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_185, arg1_185, arg2_185)
			updateWorldItem(arg1_185, WorldItem.New({
				id = arg0_185.id
			}), arg2_185)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_186, arg1_186, arg2_186)
			updateWorldCollection(arg1_186, arg0_186, arg2_186)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_187, arg1_187, arg2_187)
			updateAttire(arg1_187, AttireConst.TYPE_CHAT_FRAME, arg0_187:getConfigTable(), arg2_187)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_188, arg1_188, arg2_188)
			updateAttire(arg1_188, AttireConst.TYPE_ICON_FRAME, arg0_188:getConfigTable(), arg2_188)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_189, arg1_189, arg2_189)
			updateEmoji(arg1_189, arg0_189:getConfigTable(), arg2_189)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_190, arg1_190, arg2_190)
			arg2_190.count = 1

			updateItem(arg1_190, arg0_190:getSubClass(), arg2_190)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_191, arg1_191, arg2_191)
			updateSpWeapon(arg1_191, SpWeapon.New({
				id = arg0_191.id
			}), arg2_191)
		end,
		[DROP_TYPE_META_PT] = function(arg0_192, arg1_192, arg2_192)
			updateItem(arg1_192, Item.New({
				id = arg0_192:getConfig("id")
			}), arg2_192)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_193, arg1_193, arg2_193)
			arg2_193.isSkin = true
			arg2_193.isTimeLimit = true
			arg2_193.count = 1

			updateShip(arg1_193, Ship.New({
				configId = tonumber(arg0_193:getConfig("ship_group") .. "1"),
				skin_id = arg0_193.id
			}), arg2_193)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_194, arg1_194, arg2_194)
			AtelierMaterial.UpdateRyzaItem(arg1_194, arg0_194.item, arg2_194)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_195, arg1_195, arg2_195)
			WorkBenchItem.UpdateDrop(arg1_195, arg0_195.item, arg2_195)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_196, arg1_196, arg2_196)
			WorkBenchItem.UpdateDrop(arg1_196, WorkBenchItem.New({
				configId = arg0_196.id,
				count = arg0_196.count
			}), arg2_196)
		end,
		[DROP_TYPE_BUFF] = function(arg0_197, arg1_197, arg2_197)
			updateBuff(arg1_197, arg0_197.id, arg2_197)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_198, arg1_198, arg2_198)
			updateCommander(arg1_198, arg0_198, arg2_198)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_199, arg1_199, arg2_199)
			updateDorm3dFurniture(arg1_199, arg0_199, arg2_199)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_200, arg1_200, arg2_200)
			updateDorm3dGift(arg1_200, arg0_200, arg2_200)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_201, arg1_201, arg2_201)
			updateDorm3dSkin(arg1_201, arg0_201, arg2_201)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_202, arg1_202, arg2_202)
			updateAttireCombatUI(arg1_202, AttireConst.TYPE_ICON_FRAME, arg0_202:getConfigTable(), arg2_202)
		end
	}

	function var0_0.UpdateDropDefault(arg0_203, arg1_203, arg2_203)
		warning(string.format("without dropType %d in updateDrop", arg0_203.type))
	end
end

return var0_0
