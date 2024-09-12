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
		[DROP_TYPE_VITEM] = function(arg0_91, arg1_91, arg2_91)
			assert(arg0_91:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_91.id)

			return switch(arg0_91:getConfig("virtual_type"), {
				function()
					if arg0_91:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_91
					end

					return arg0_91
				end,
				[6] = function()
					local var0_93 = arg2_91.taskId
					local var1_93 = getProxy(ActivityProxy)
					local var2_93 = var1_93:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_93 then
						local var3_93 = var2_93.data1KeyValueList[1]

						var3_93[var0_93] = defaultValue(var3_93[var0_93], 0) + arg0_91.count

						var1_93:updateActivity(var2_93)
					end

					return nil, arg0_91
				end,
				[13] = function()
					local var0_94 = arg0_91:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_94))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_94))

						return nil
					elseif SkinCouponActivity.StaticOwnAllSkin() then
						if arg0_91.count > 1 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_94))
						end

						return SkinCouponActivity.StaticGetEquivalentRes(), nil
					else
						return arg0_91, nil
					end
				end,
				[21] = function()
					return nil, arg0_91
				end,
				[28] = function()
					local var0_96 = Drop.New({
						type = arg0_91.type,
						id = arg0_91.id,
						count = math.floor(arg0_91.count / 1000)
					})
					local var1_96 = Drop.New({
						type = arg0_91.type,
						id = arg0_91.id,
						count = arg0_91.count - math.floor(arg0_91.count / 1000)
					})

					return var0_96, var1_96
				end
			}, function()
				return arg0_91
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_98, arg1_98)
			if Ship.isMetaShipByConfigID(arg0_98.id) and Player.isMetaShipNeedToTrans(arg0_98.id) then
				local var0_98 = table.indexof(arg1_98, arg0_98.id, 1)

				if var0_98 then
					table.remove(arg1_98, var0_98)
				else
					local var1_98 = Player.metaShip2Res(arg0_98.id)
					local var2_98 = Drop.New(var1_98[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_98.id, var2_98)

					return arg0_98, var2_98
				end
			end

			return arg0_98
		end,
		[DROP_TYPE_SKIN] = function(arg0_99)
			arg0_99.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_99.id)

			return arg0_99
		end
	}

	function var0_0.TransDefault(arg0_100)
		return arg0_100
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_101)
			local var0_101 = id2res(arg0_101.id)

			assert(var0_101, "res should be defined: " .. arg0_101.id)

			local var1_101 = getProxy(PlayerProxy)
			local var2_101 = var1_101:getData()

			var2_101:addResources({
				[var0_101] = arg0_101.count
			})
			var1_101:updatePlayer(var2_101)
		end,
		[DROP_TYPE_ITEM] = function(arg0_102)
			if arg0_102:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_102 = getProxy(BagProxy):getItemCountById(arg0_102.id)
				local var1_102 = math.min(arg0_102:getConfig("max_num") - var0_102, arg0_102.count)

				if var1_102 > 0 then
					getProxy(BagProxy):addItemById(arg0_102.id, var1_102)
				end
			else
				getProxy(BagProxy):addItemById(arg0_102.id, arg0_102.count, arg0_102.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_103)
			local var0_103 = arg0_103:getSubClass()

			getProxy(BagProxy):addItemById(var0_103.id, var0_103.count, var0_103.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_104)
			getProxy(EquipmentProxy):addEquipmentById(arg0_104.id, arg0_104.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_105)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_106)
			local var0_106 = getProxy(DormProxy)
			local var1_106 = Furniture.New({
				id = arg0_106.id,
				count = arg0_106.count
			})

			if var1_106:isRecordTime() then
				var1_106.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_106:AddFurniture(var1_106)
		end,
		[DROP_TYPE_SKIN] = function(arg0_107)
			local var0_107 = getProxy(ShipSkinProxy)
			local var1_107 = ShipSkin.New({
				id = arg0_107.id
			})

			var0_107:addSkin(var1_107)
		end,
		[DROP_TYPE_VITEM] = function(arg0_108)
			arg0_108 = arg0_108:getSubClass()

			assert(arg0_108:isVirtualItem(), "item type error(virtual item)>>" .. arg0_108.id)
			switch(arg0_108:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_108.id, arg0_108.count)
				end,
				function()
					local var0_110 = getProxy(ActivityProxy)
					local var1_110 = arg0_108:getConfig("link_id")
					local var2_110

					if var1_110 > 0 then
						var2_110 = var0_110:getActivityById(var1_110)
					else
						var2_110 = var0_110:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_110 and not var2_110:isEnd() then
						if not table.contains(var2_110.data1_list, arg0_108.id) then
							table.insert(var2_110.data1_list, arg0_108.id)
						end

						var0_110:updateActivity(var2_110)
					end
				end,
				function()
					local var0_111 = getProxy(ActivityProxy)
					local var1_111 = var0_111:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_111, iter1_111 in ipairs(var1_111) do
						iter1_111.data1 = iter1_111.data1 + arg0_108.count

						local var2_111 = iter1_111:getConfig("config_id")
						local var3_111 = pg.activity_vote[var2_111]

						if var3_111 and var3_111.ticket_id_period == arg0_108.id then
							iter1_111.data3 = iter1_111.data3 + arg0_108.count
						end

						var0_111:updateActivity(iter1_111)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_108.id,
							ptCount = arg0_108.count
						})
					end
				end,
				[4] = function()
					local var0_112 = getProxy(ColoringProxy):getColorItems()

					var0_112[arg0_108.id] = (var0_112[arg0_108.id] or 0) + arg0_108.count
				end,
				[6] = function()
					local var0_113 = getProxy(ActivityProxy)
					local var1_113 = var0_113:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_113 then
						var1_113.data3 = var1_113.data3 + arg0_108.count

						var0_113:updateActivity(var1_113)
					end
				end,
				[7] = function()
					local var0_114 = getProxy(ChapterProxy)

					var0_114:updateRemasterTicketsNum(math.min(var0_114.remasterTickets + arg0_108.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_115 = getProxy(ActivityProxy)
					local var1_115 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_115 then
						var1_115.data1_list[1] = var1_115.data1_list[1] + arg0_108.count

						var0_115:updateActivity(var1_115)
					end
				end,
				[10] = function()
					local var0_116 = getProxy(ActivityProxy)
					local var1_116 = var0_116:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_116 and not var1_116:isEnd() then
						var1_116.data1 = var1_116.data1 + arg0_108.count

						var0_116:updateActivity(var1_116)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_116
						})
					end
				end,
				[11] = function()
					local var0_117 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_117 and not var0_117:isEnd() then
						var0_117.data1 = var0_117.data1 + arg0_108.count
					end
				end,
				[12] = function()
					local var0_118 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_118 and not var0_118:isEnd() then
						var0_118.data1KeyValueList[1][arg0_108.id] = (var0_118.data1KeyValueList[1][arg0_108.id] or 0) + arg0_108.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_108.id)
				end,
				[14] = function()
					local var0_120 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_108.id then
						var0_120:AddSummonPt(arg0_108.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_108.id then
						var0_120:AddSummonPtOld(arg0_108.count)
					end
				end,
				[15] = function()
					local var0_121 = getProxy(ActivityProxy)
					local var1_121 = var0_121:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

					if var1_121 and not var1_121:isEnd() then
						local var2_121 = pg.activity_event_grid[var1_121.data1]

						if arg0_108.id == var2_121.ticket_item then
							var1_121.data2 = var1_121.data2 + arg0_108.count
						elseif arg0_108.id == var2_121.explore_item then
							var1_121.data3 = var1_121.data3 + arg0_108.count
						end
					end

					var0_121:updateActivity(var1_121)
				end,
				[16] = function()
					local var0_122 = getProxy(ActivityProxy)
					local var1_122 = var0_122:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_122, iter1_122 in pairs(var1_122) do
						if iter1_122 and not iter1_122:isEnd() and arg0_108.id == iter1_122:getConfig("config_id") then
							iter1_122.data1 = iter1_122.data1 + arg0_108.count

							var0_122:updateActivity(iter1_122)
						end
					end
				end,
				[20] = function()
					local var0_123 = getProxy(BagProxy)
					local var1_123 = pg.gameset.urpt_chapter_max.description
					local var2_123 = var1_123[1]
					local var3_123 = var1_123[2]
					local var4_123 = var0_123:GetLimitCntById(var2_123)
					local var5_123 = math.min(var3_123 - var4_123, arg0_108.count)

					if var5_123 > 0 then
						var0_123:addItemById(var2_123, var5_123)
						var0_123:AddLimitCnt(var2_123, var5_123)
					end
				end,
				[21] = function()
					local var0_124 = getProxy(ActivityProxy)
					local var1_124 = var0_124:getActivityById(arg0_108:getConfig("link_id"))

					if var1_124 and not var1_124:isEnd() then
						var1_124.data2 = 1

						var0_124:updateActivity(var1_124)
					end
				end,
				[22] = function()
					local var0_125 = getProxy(ActivityProxy)
					local var1_125 = var0_125:getActivityById(arg0_108:getConfig("link_id"))

					if var1_125 and not var1_125:isEnd() then
						var1_125.data1 = var1_125.data1 + arg0_108.count

						var0_125:updateActivity(var1_125)
					end
				end,
				[23] = function()
					local var0_126 = (function()
						for iter0_127, iter1_127 in ipairs(pg.gameset.package_lv.description) do
							if arg0_108.id == iter1_127[1] then
								return iter1_127[2]
							end
						end
					end)()

					assert(var0_126)

					local var1_126 = getProxy(PlayerProxy)
					local var2_126 = var1_126:getData()

					var2_126:addExpToLevel(var0_126)
					var1_126:updatePlayer(var2_126)
				end,
				[24] = function()
					local var0_128 = arg0_108:getConfig("link_id")
					local var1_128 = getProxy(ActivityProxy):getActivityById(var0_128)

					if var1_128 and not var1_128:isEnd() and var1_128:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_128.data2 = var1_128.data2 + arg0_108.count

						getProxy(ActivityProxy):updateActivity(var1_128)
					end
				end,
				[25] = function()
					local var0_129 = getProxy(ActivityProxy)
					local var1_129 = var0_129:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_129 and not var1_129:isEnd() then
						var1_129.data1 = var1_129.data1 - 1

						if not table.contains(var1_129.data1_list, arg0_108.id) then
							table.insert(var1_129.data1_list, arg0_108.id)
						end

						var0_129:updateActivity(var1_129)

						local var2_129 = arg0_108:getConfig("link_id")

						if var2_129 > 0 then
							local var3_129 = var0_129:getActivityById(var2_129)

							if var3_129 and not var3_129:isEnd() then
								var3_129.data1 = var3_129.data1 + 1

								var0_129:updateActivity(var3_129)
							end
						end
					end
				end,
				[26] = function()
					local var0_130 = getProxy(ActivityProxy)
					local var1_130 = Clone(var0_130:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_130 and not var1_130:isEnd() then
						var1_130.data1 = var1_130.data1 + arg0_108.count

						var0_130:updateActivity(var1_130)
					end
				end,
				[27] = function()
					local var0_131 = getProxy(ActivityProxy)
					local var1_131 = Clone(var0_131:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_131 and not var1_131:isEnd() then
						var1_131:AddExp(arg0_108.count)
						var0_131:updateActivity(var1_131)
					end
				end,
				[28] = function()
					local var0_132 = getProxy(ActivityProxy)
					local var1_132 = Clone(var0_132:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_132 and not var1_132:isEnd() then
						var1_132:AddGold(arg0_108.count)
						var0_132:updateActivity(var1_132)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_135 = arg0_108:getConfig("link_id")
					local var1_135 = getProxy(ActivityProxy):getActivityById(var0_135)

					if var1_135 and not var1_135:isEnd() then
						var1_135.data1 = var1_135.data1 + arg0_108.count

						getProxy(ActivityProxy):updateActivity(var1_135)
					end
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_136)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_136.id, arg0_136.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_137)
			local var0_137 = getProxy(BayProxy)
			local var1_137 = var0_137:getShipById(arg0_137.count)

			if var1_137 then
				var1_137:unlockActivityNpc(0)
				var0_137:updateShip(var1_137)
				getProxy(CollectionProxy):flushCollection(var1_137)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_138)
			nowWorld():GetInventoryProxy():AddItem(arg0_138.id, arg0_138.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_139)
			local var0_139 = getProxy(AttireProxy)
			local var1_139 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_139 = IconFrame.New({
				id = arg0_139.id
			})
			local var3_139 = var1_139 + var2_139:getConfig("time_second")

			var2_139:updateData({
				isNew = true,
				end_time = var3_139
			})
			var0_139:addAttireFrame(var2_139)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_139)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_140)
			local var0_140 = getProxy(AttireProxy)
			local var1_140 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_140 = ChatFrame.New({
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
		[DROP_TYPE_EMOJI] = function(arg0_141)
			getProxy(EmojiProxy):addNewEmojiID(arg0_141.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_141:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_142)
			nowWorld():GetCollectionProxy():Unlock(arg0_142.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_143)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_143.id):addPT(arg0_143.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_144)
			local var0_144 = arg0_144.id
			local var1_144 = arg0_144.count
			local var2_144 = getProxy(ShipSkinProxy)
			local var3_144 = var2_144:getSkinById(var0_144)

			if var3_144 and var3_144:isExpireType() then
				local var4_144 = var1_144 + var3_144.endTime
				local var5_144 = ShipSkin.New({
					id = var0_144,
					end_time = var4_144
				})

				var2_144:addSkin(var5_144)
			elseif not var3_144 then
				local var6_144 = var1_144 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_144 = ShipSkin.New({
					id = var0_144,
					end_time = var6_144
				})

				var2_144:addSkin(var7_144)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_145)
			local var0_145 = arg0_145.id
			local var1_145 = pg.benefit_buff_template[var0_145]

			assert(var1_145 and var1_145.act_id > 0, "should exist act id")

			local var2_145 = getProxy(ActivityProxy):getActivityById(var1_145.act_id)

			if var2_145 and not var2_145:isEnd() then
				local var3_145 = var1_145.max_time
				local var4_145 = pg.TimeMgr.GetInstance():GetServerTime() + var3_145

				var2_145:AddBuff(ActivityBuff.New(var2_145.id, var0_145, var4_145))
				getProxy(ActivityProxy):updateActivity(var2_145)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_146)
			return
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_147)
			getProxy(ApartmentProxy):changeGiftCount(arg0_147.id, arg0_147.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_148)
			local var0_148 = getProxy(ApartmentProxy)
			local var1_148 = var0_148:getApartment(arg0_148:getConfig("ship_group"))

			var1_148:addSkin(arg0_148.id)
			var0_148:updateApartment(var1_148)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_149)
			local var0_149 = getProxy(AttireProxy)
			local var1_149 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_149 = CombatUIStyle.New({
				id = arg0_149.id
			})

			var2_149:setUnlock()
			var2_149:setNew()
			var0_149:addAttireFrame(var2_149)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_COMBAT_UI, var2_149)
		end
	}

	function var0_0.AddItemDefault(arg0_150)
		if arg0_150.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_150 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_150.type].activity_id)

			if arg0_150.type == DROP_TYPE_RYZA_DROP then
				if var0_150 and not var0_150:isEnd() then
					var0_150:AddItem(AtelierMaterial.New({
						configId = arg0_150.id,
						count = arg0_150.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_150)
				end
			elseif var0_150 and not var0_150:isEnd() then
				var0_150:addVitemNumber(arg0_150.id, arg0_150.count)
				getProxy(ActivityProxy):updateActivity(var0_150)
			end
		else
			print("can not handle this type>>" .. arg0_150.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_151, arg1_151, arg2_151)
			setText(arg2_151, arg0_151:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_152, arg1_152, arg2_152)
			local var0_152 = arg0_152:getConfig("display")

			if arg0_152:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_152 = string.gsub(var0_152, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_152.extra))
			elseif arg0_152:getConfig("combination_display") ~= nil then
				local var1_152 = arg0_152:getConfig("combination_display")

				if var1_152 and #var1_152 > 0 then
					var0_152 = Item.StaticCombinationDisplay(var1_152)
				end
			end

			setText(arg2_152, SwitchSpecialChar(var0_152, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_153, arg1_153, arg2_153)
			setText(arg2_153, arg0_153:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_154, arg1_154, arg2_154)
			local var0_154 = arg0_154:getConfig("skin_id")
			local var1_154, var2_154, var3_154 = ShipWordHelper.GetWordAndCV(var0_154, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_154, var3_154 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_155, arg1_155, arg2_155)
			local var0_155 = arg0_155:getConfig("skin_id")
			local var1_155, var2_155, var3_155 = ShipWordHelper.GetWordAndCV(var0_155, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_155, var3_155 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_156, arg1_156, arg2_156)
			setText(arg2_156, arg1_156.name or arg0_156:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_157, arg1_157, arg2_157)
			local var0_157 = arg0_157:getConfig("desc")

			for iter0_157, iter1_157 in ipairs({
				arg0_157.count
			}) do
				var0_157 = string.gsub(var0_157, "$" .. iter0_157, iter1_157)
			end

			setText(arg2_157, var0_157)
		end,
		[DROP_TYPE_SKIN] = function(arg0_158, arg1_158, arg2_158)
			setText(arg2_158, arg0_158:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_159, arg1_159, arg2_159)
			setText(arg2_159, arg0_159:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_160, arg1_160, arg2_160)
			local var0_160 = arg0_160:getConfig("desc")
			local var1_160 = _.map(arg0_160:getConfig("equip_type"), function(arg0_161)
				return EquipType.Type2Name2(arg0_161)
			end)

			setText(arg2_160, var0_160 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_160, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_162, arg1_162, arg2_162)
			setText(arg2_162, arg0_162:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_163, arg1_163, arg2_163)
			setText(arg2_163, arg0_163:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_164, arg1_164, arg2_164, arg3_164)
			local var0_164 = WorldCollectionProxy.GetCollectionType(arg0_164.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_164, i18n("world_" .. var0_164 .. "_desc", arg0_164:getConfig("name")))
			setText(arg3_164, i18n("world_" .. var0_164 .. "_name", arg0_164:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_165, arg1_165, arg2_165)
			setText(arg2_165, arg0_165:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_166, arg1_166, arg2_166)
			setText(arg2_166, arg0_166:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_167, arg1_167, arg2_167)
			setText(arg2_167, arg0_167:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_168, arg1_168, arg2_168)
			local var0_168 = string.gsub(arg0_168:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_168.count))

			setText(arg2_168, SwitchSpecialChar(var0_168, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_169, arg1_169, arg2_169)
			setText(arg2_169, arg0_169:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_170, arg1_170, arg2_170)
			setText(arg2_170, arg0_170:getConfig("desc"))
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_171, arg1_171, arg2_171)
			setText(arg2_171, "")
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_172, arg1_172, arg2_172)
			setText(arg2_172, arg0_172:getConfig("desc"))
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_173, arg1_173, arg2_173)
		if arg0_173.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_173, arg0_173:getConfig("display"))
		else
			assert(false, "can not handle this type>>" .. arg0_173.type)
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_174, arg1_174, arg2_174)
			if arg0_174.id == PlayerConst.ResStoreGold or arg0_174.id == PlayerConst.ResStoreOil then
				arg2_174 = arg2_174 or {}
				arg2_174.frame = "frame_store"
			end

			updateItem(arg1_174, Item.New({
				id = id2ItemId(arg0_174.id)
			}), arg2_174)
		end,
		[DROP_TYPE_ITEM] = function(arg0_175, arg1_175, arg2_175)
			updateItem(arg1_175, arg0_175:getSubClass(), arg2_175)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_176, arg1_176, arg2_176)
			updateEquipment(arg1_176, arg0_176:getSubClass(), arg2_176)
		end,
		[DROP_TYPE_SHIP] = function(arg0_177, arg1_177, arg2_177)
			updateShip(arg1_177, arg0_177.ship, arg2_177)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_178, arg1_178, arg2_178)
			updateShip(arg1_178, arg0_178.ship, arg2_178)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_179, arg1_179, arg2_179)
			updateFurniture(arg1_179, arg0_179, arg2_179)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_180, arg1_180, arg2_180)
			arg2_180.isWorldBuff = arg0_180.isWorldBuff

			updateStrategy(arg1_180, arg0_180, arg2_180)
		end,
		[DROP_TYPE_SKIN] = function(arg0_181, arg1_181, arg2_181)
			arg2_181.isSkin = true
			arg2_181.isNew = arg0_181.isNew

			updateShip(arg1_181, Ship.New({
				configId = tonumber(arg0_181:getConfig("ship_group") .. "1"),
				skin_id = arg0_181.id
			}), arg2_181)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_182, arg1_182, arg2_182)
			local var0_182 = setmetatable({
				count = arg0_182.count
			}, {
				__index = arg0_182:getConfigTable()
			})

			updateEquipmentSkin(arg1_182, var0_182, arg2_182)
		end,
		[DROP_TYPE_VITEM] = function(arg0_183, arg1_183, arg2_183)
			updateItem(arg1_183, Item.New({
				id = arg0_183.id
			}), arg2_183)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_184, arg1_184, arg2_184)
			updateWorldItem(arg1_184, WorldItem.New({
				id = arg0_184.id
			}), arg2_184)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_185, arg1_185, arg2_185)
			updateWorldCollection(arg1_185, arg0_185, arg2_185)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_186, arg1_186, arg2_186)
			updateAttire(arg1_186, AttireConst.TYPE_CHAT_FRAME, arg0_186:getConfigTable(), arg2_186)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_187, arg1_187, arg2_187)
			updateAttire(arg1_187, AttireConst.TYPE_ICON_FRAME, arg0_187:getConfigTable(), arg2_187)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_188, arg1_188, arg2_188)
			updateEmoji(arg1_188, arg0_188:getConfigTable(), arg2_188)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_189, arg1_189, arg2_189)
			arg2_189.count = 1

			updateItem(arg1_189, arg0_189:getSubClass(), arg2_189)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_190, arg1_190, arg2_190)
			updateSpWeapon(arg1_190, SpWeapon.New({
				id = arg0_190.id
			}), arg2_190)
		end,
		[DROP_TYPE_META_PT] = function(arg0_191, arg1_191, arg2_191)
			updateItem(arg1_191, Item.New({
				id = arg0_191:getConfig("id")
			}), arg2_191)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_192, arg1_192, arg2_192)
			arg2_192.isSkin = true
			arg2_192.isTimeLimit = true
			arg2_192.count = 1

			updateShip(arg1_192, Ship.New({
				configId = tonumber(arg0_192:getConfig("ship_group") .. "1"),
				skin_id = arg0_192.id
			}), arg2_192)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_193, arg1_193, arg2_193)
			AtelierMaterial.UpdateRyzaItem(arg1_193, arg0_193.item, arg2_193)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_194, arg1_194, arg2_194)
			WorkBenchItem.UpdateDrop(arg1_194, arg0_194.item, arg2_194)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_195, arg1_195, arg2_195)
			WorkBenchItem.UpdateDrop(arg1_195, WorkBenchItem.New({
				configId = arg0_195.id,
				count = arg0_195.count
			}), arg2_195)
		end,
		[DROP_TYPE_BUFF] = function(arg0_196, arg1_196, arg2_196)
			updateBuff(arg1_196, arg0_196.id, arg2_196)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_197, arg1_197, arg2_197)
			updateCommander(arg1_197, arg0_197, arg2_197)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_198, arg1_198, arg2_198)
			updateDorm3dFurniture(arg1_198, arg0_198, arg2_198)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_199, arg1_199, arg2_199)
			updateDorm3dGift(arg1_199, arg0_199, arg2_199)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_200, arg1_200, arg2_200)
			updateDorm3dSkin(arg1_200, arg0_200, arg2_200)
		end,
		[DROP_TYPE_COMBAT_UI_STYLE] = function(arg0_201, arg1_201, arg2_201)
			updateAttireCombatUI(arg1_201, AttireConst.TYPE_ICON_FRAME, arg0_201:getConfigTable(), arg2_201)
		end
	}

	function var0_0.UpdateDropDefault(arg0_202, arg1_202, arg2_202)
		warning(string.format("without dropType %d in updateDrop", arg0_202.type))
	end
end

return var0_0
