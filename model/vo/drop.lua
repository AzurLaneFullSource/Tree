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
		end
	}

	function var0_0.ConfigDefault(arg0_45)
		local var0_45 = arg0_45.type

		if var0_45 > DROP_TYPE_USE_ACTIVITY_DROP then
			local var1_45 = pg.activity_drop_type[var0_45].relevance

			return var1_45 and pg[var1_45][arg0_45.id]
		end
	end

	var0_0.CountCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_46)
			return getProxy(PlayerProxy):getRawData():getResById(arg0_46.id), true
		end,
		[DROP_TYPE_ITEM] = function(arg0_47)
			local var0_47 = getProxy(BagProxy):getItemCountById(arg0_47.id)

			if arg0_47:getConfig("type") == Item.LOVE_LETTER_TYPE then
				return math.min(var0_47, 1), true
			else
				return var0_47, true
			end
		end,
		[DROP_TYPE_EQUIP] = function(arg0_48)
			local var0_48 = arg0_48:getConfig("group")

			assert(pg.equip_data_template.get_id_list_by_group[var0_48], "equip groupId not exist")

			local var1_48 = pg.equip_data_template.get_id_list_by_group[var0_48]

			return underscore.reduce(var1_48, 0, function(arg0_49, arg1_49)
				local var0_49 = getProxy(EquipmentProxy):getEquipmentById(arg1_49)

				return arg0_49 + (var0_49 and var0_49.count or 0) + getProxy(BayProxy):GetEquipCountInShips(arg1_49)
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_50)
			return getProxy(BayProxy):getConfigShipCount(arg0_50.id)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_51)
			return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(arg0_51.id)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_52)
			return arg0_52.count, tobool(arg0_52.count)
		end,
		[DROP_TYPE_SKIN] = function(arg0_53)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_53.id)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_54)
			return getProxy(ShipSkinProxy):getSkinCountById(arg0_54.id)
		end,
		[DROP_TYPE_VITEM] = function(arg0_55)
			if arg0_55:getConfig("virtual_type") == 22 then
				local var0_55 = getProxy(ActivityProxy):getActivityById(arg0_55:getConfig("link_id"))

				return var0_55 and var0_55.data1 or 0, true
			end
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_56)
			local var0_56 = getProxy(EquipmentProxy):getEquipmnentSkinById(arg0_56.id)

			return (var0_56 and var0_56.count or 0) + getProxy(BayProxy):GetEquipSkinCountInShips(arg0_56.id)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_57)
			local var0_57 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_57.type].activity_id):GetItemById(arg0_57.id)

			return var0_57 and var0_57.count or 0
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_58)
			local var0_58 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_58.id)

			return var0_58 and (not var0_58:expiredType() or not not var0_58:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_59)
			local var0_59 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_CHAT_FRAME, arg0_59.id)

			return var0_59 and (not var0_59:expiredType() or not not var0_59:isExpired()) and 1 or 0
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_60)
			local var0_60 = nowWorld()

			if var0_60.type ~= World.TypeFull then
				assert(false)

				return 0, false
			else
				return var0_60:GetInventoryProxy():GetItemCount(arg0_60.id), false
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_61)
			return getProxy(CommanderProxy):GetSameConfigIdCommanderCount(arg0_61.id)
		end
	}

	function var0_0.CountDefault(arg0_62)
		local var0_62 = arg0_62.type

		if var0_62 > DROP_TYPE_USE_ACTIVITY_DROP then
			return getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[var0_62].activity_id):getVitemNumber(arg0_62.id)
		else
			return 0, false
		end
	end

	var0_0.SubClassCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_63)
			return
		end,
		[DROP_TYPE_ITEM] = function(arg0_64)
			return Item.New(arg0_64)
		end,
		[DROP_TYPE_VITEM] = function(arg0_65)
			return Item.New(arg0_65)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_66)
			return Equipment.New(arg0_66)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_67)
			return Item.New({
				count = 1,
				id = arg0_67.id,
				extra = arg0_67.count
			})
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_68)
			return WorldItem.New(arg0_68)
		end
	}

	function var0_0.SubClassDefault(arg0_69)
		assert(false, string.format("drop type %d without subClass", arg0_69.type))
	end

	var0_0.RarityCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_70)
			return arg0_70:getConfig("rarity")
		end,
		[DROP_TYPE_ITEM] = function(arg0_71)
			return arg0_71:getConfig("rarity")
		end,
		[DROP_TYPE_EQUIP] = function(arg0_72)
			return arg0_72:getConfig("rarity") - 1
		end,
		[DROP_TYPE_SHIP] = function(arg0_73)
			return arg0_73:getConfig("rarity") - 1
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_74)
			return arg0_74:getConfig("rarity")
		end,
		[DROP_TYPE_SKIN] = function(arg0_75)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_76)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_VITEM] = function(arg0_77)
			return arg0_77:getConfig("rarity")
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_78)
			return arg0_78:getConfig("rarity")
		end,
		[DROP_TYPE_BUFF] = function(arg0_79)
			return ItemRarity.Purple
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_80)
			return arg0_80:getConfig("rarity") - 1
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_81)
			return arg0_81:getConfig("rarity")
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_82)
			return ItemRarity.Gold
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_83)
			return ItemRarity.Gold
		end
	}

	function var0_0.RarityDefault(arg0_84)
		return 1
	end

	var0_0.TransCase = {
		[DROP_TYPE_TRANS_ITEM] = function(arg0_85)
			local var0_85 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_85:getConfig("resource_type"),
				count = arg0_85:getConfig("resource_num") * arg0_85.count
			})
			local var1_85 = Drop.New({
				type = arg0_85:getConfig("target_type"),
				id = arg0_85:getConfig("target_id")
			})

			var0_85.name = string.format("%s(%s)", var0_85:getName(), var1_85:getName())

			return var0_85
		end,
		[DROP_TYPE_RESOURCE] = function(arg0_86)
			for iter0_86, iter1_86 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
				if pg.battlepass_event_pt[iter1_86.id].pt == arg0_86.id then
					return nil, arg0_86
				end
			end

			return arg0_86
		end,
		[DROP_TYPE_OPERATION] = function(arg0_87)
			if arg0_87.id ~= 3 then
				return nil
			end

			return arg0_87
		end,
		[DROP_TYPE_VITEM] = function(arg0_88, arg1_88, arg2_88)
			assert(arg0_88:getConfig("type") == 0, "item type error:must be virtual type from " .. arg0_88.id)

			return switch(arg0_88:getConfig("virtual_type"), {
				function()
					if arg0_88:getConfig("link_id") == ActivityConst.LINLK_DUNHUANG_ACT then
						return nil, arg0_88
					end

					return arg0_88
				end,
				[6] = function()
					local var0_90 = arg2_88.taskId
					local var1_90 = getProxy(ActivityProxy)
					local var2_90 = var1_90:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var2_90 then
						local var3_90 = var2_90.data1KeyValueList[1]

						var3_90[var0_90] = defaultValue(var3_90[var0_90], 0) + arg0_88.count

						var1_90:updateActivity(var2_90)
					end

					return nil, arg0_88
				end,
				[13] = function()
					local var0_91 = arg0_88:getName()

					if not SkinCouponActivity.StaticExistActivity() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_timeout_tip", var0_91))

						return nil
					elseif SkinCouponActivity.StaticOwnMaxCntSkinCoupon() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_91))

						return nil
					elseif SkinCouponActivity.StaticOwnAllSkin() then
						if arg0_88.count > 1 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("coupon_repeat_tip", var0_91))
						end

						return SkinCouponActivity.StaticGetEquivalentRes(), nil
					else
						return arg0_88, nil
					end
				end,
				[21] = function()
					return nil, arg0_88
				end,
				[28] = function()
					local var0_93 = Drop.New({
						type = arg0_88.type,
						id = arg0_88.id,
						count = math.floor(arg0_88.count / 1000)
					})
					local var1_93 = Drop.New({
						type = arg0_88.type,
						id = arg0_88.id,
						count = arg0_88.count - math.floor(arg0_88.count / 1000)
					})

					return var0_93, var1_93
				end
			}, function()
				return arg0_88
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_95, arg1_95)
			if Ship.isMetaShipByConfigID(arg0_95.id) and Player.isMetaShipNeedToTrans(arg0_95.id) then
				local var0_95 = table.indexof(arg1_95, arg0_95.id, 1)

				if var0_95 then
					table.remove(arg1_95, var0_95)
				else
					local var1_95 = Player.metaShip2Res(arg0_95.id)
					local var2_95 = Drop.New(var1_95[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_95.id, var2_95)

					return arg0_95, var2_95
				end
			end

			return arg0_95
		end,
		[DROP_TYPE_SKIN] = function(arg0_96)
			arg0_96.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_96.id)

			return arg0_96
		end
	}

	function var0_0.TransDefault(arg0_97)
		return arg0_97
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_98)
			local var0_98 = id2res(arg0_98.id)

			assert(var0_98, "res should be defined: " .. arg0_98.id)

			local var1_98 = getProxy(PlayerProxy)
			local var2_98 = var1_98:getData()

			var2_98:addResources({
				[var0_98] = arg0_98.count
			})
			var1_98:updatePlayer(var2_98)
		end,
		[DROP_TYPE_ITEM] = function(arg0_99)
			if arg0_99:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_99 = getProxy(BagProxy):getItemCountById(arg0_99.id)
				local var1_99 = math.min(arg0_99:getConfig("max_num") - var0_99, arg0_99.count)

				if var1_99 > 0 then
					getProxy(BagProxy):addItemById(arg0_99.id, var1_99)
				end
			else
				getProxy(BagProxy):addItemById(arg0_99.id, arg0_99.count, arg0_99.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_100)
			local var0_100 = arg0_100:getSubClass()

			getProxy(BagProxy):addItemById(var0_100.id, var0_100.count, var0_100.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_101)
			getProxy(EquipmentProxy):addEquipmentById(arg0_101.id, arg0_101.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_102)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_103)
			local var0_103 = getProxy(DormProxy)
			local var1_103 = Furniture.New({
				id = arg0_103.id,
				count = arg0_103.count
			})

			if var1_103:isRecordTime() then
				var1_103.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_103:AddFurniture(var1_103)
		end,
		[DROP_TYPE_SKIN] = function(arg0_104)
			local var0_104 = getProxy(ShipSkinProxy)
			local var1_104 = ShipSkin.New({
				id = arg0_104.id
			})

			var0_104:addSkin(var1_104)
		end,
		[DROP_TYPE_VITEM] = function(arg0_105)
			arg0_105 = arg0_105:getSubClass()

			assert(arg0_105:isVirtualItem(), "item type error(virtual item)>>" .. arg0_105.id)
			switch(arg0_105:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_105.id, arg0_105.count)
				end,
				function()
					local var0_107 = getProxy(ActivityProxy)
					local var1_107 = arg0_105:getConfig("link_id")
					local var2_107

					if var1_107 > 0 then
						var2_107 = var0_107:getActivityById(var1_107)
					else
						var2_107 = var0_107:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_107 and not var2_107:isEnd() then
						if not table.contains(var2_107.data1_list, arg0_105.id) then
							table.insert(var2_107.data1_list, arg0_105.id)
						end

						var0_107:updateActivity(var2_107)
					end
				end,
				function()
					local var0_108 = getProxy(ActivityProxy)
					local var1_108 = var0_108:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_108, iter1_108 in ipairs(var1_108) do
						iter1_108.data1 = iter1_108.data1 + arg0_105.count

						local var2_108 = iter1_108:getConfig("config_id")
						local var3_108 = pg.activity_vote[var2_108]

						if var3_108 and var3_108.ticket_id_period == arg0_105.id then
							iter1_108.data3 = iter1_108.data3 + arg0_105.count
						end

						var0_108:updateActivity(iter1_108)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_105.id,
							ptCount = arg0_105.count
						})
					end
				end,
				[4] = function()
					local var0_109 = getProxy(ColoringProxy):getColorItems()

					var0_109[arg0_105.id] = (var0_109[arg0_105.id] or 0) + arg0_105.count
				end,
				[6] = function()
					local var0_110 = getProxy(ActivityProxy)
					local var1_110 = var0_110:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_110 then
						var1_110.data3 = var1_110.data3 + arg0_105.count

						var0_110:updateActivity(var1_110)
					end
				end,
				[7] = function()
					local var0_111 = getProxy(ChapterProxy)

					var0_111:updateRemasterTicketsNum(math.min(var0_111.remasterTickets + arg0_105.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_112 = getProxy(ActivityProxy)
					local var1_112 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_112 then
						var1_112.data1_list[1] = var1_112.data1_list[1] + arg0_105.count

						var0_112:updateActivity(var1_112)
					end
				end,
				[10] = function()
					local var0_113 = getProxy(ActivityProxy)
					local var1_113 = var0_113:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_113 and not var1_113:isEnd() then
						var1_113.data1 = var1_113.data1 + arg0_105.count

						var0_113:updateActivity(var1_113)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_113
						})
					end
				end,
				[11] = function()
					local var0_114 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_114 and not var0_114:isEnd() then
						var0_114.data1 = var0_114.data1 + arg0_105.count
					end
				end,
				[12] = function()
					local var0_115 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_115 and not var0_115:isEnd() then
						var0_115.data1KeyValueList[1][arg0_105.id] = (var0_115.data1KeyValueList[1][arg0_105.id] or 0) + arg0_105.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_105.id)
				end,
				[14] = function()
					local var0_117 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_105.id then
						var0_117:AddSummonPt(arg0_105.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_105.id then
						var0_117:AddSummonPtOld(arg0_105.count)
					end
				end,
				[15] = function()
					local var0_118 = getProxy(ActivityProxy)
					local var1_118 = var0_118:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

					if var1_118 and not var1_118:isEnd() then
						local var2_118 = pg.activity_event_grid[var1_118.data1]

						if arg0_105.id == var2_118.ticket_item then
							var1_118.data2 = var1_118.data2 + arg0_105.count
						elseif arg0_105.id == var2_118.explore_item then
							var1_118.data3 = var1_118.data3 + arg0_105.count
						end
					end

					var0_118:updateActivity(var1_118)
				end,
				[16] = function()
					local var0_119 = getProxy(ActivityProxy)
					local var1_119 = var0_119:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_119, iter1_119 in pairs(var1_119) do
						if iter1_119 and not iter1_119:isEnd() and arg0_105.id == iter1_119:getConfig("config_id") then
							iter1_119.data1 = iter1_119.data1 + arg0_105.count

							var0_119:updateActivity(iter1_119)
						end
					end
				end,
				[20] = function()
					local var0_120 = getProxy(BagProxy)
					local var1_120 = pg.gameset.urpt_chapter_max.description
					local var2_120 = var1_120[1]
					local var3_120 = var1_120[2]
					local var4_120 = var0_120:GetLimitCntById(var2_120)
					local var5_120 = math.min(var3_120 - var4_120, arg0_105.count)

					if var5_120 > 0 then
						var0_120:addItemById(var2_120, var5_120)
						var0_120:AddLimitCnt(var2_120, var5_120)
					end
				end,
				[21] = function()
					local var0_121 = getProxy(ActivityProxy)
					local var1_121 = var0_121:getActivityById(arg0_105:getConfig("link_id"))

					if var1_121 and not var1_121:isEnd() then
						var1_121.data2 = 1

						var0_121:updateActivity(var1_121)
					end
				end,
				[22] = function()
					local var0_122 = getProxy(ActivityProxy)
					local var1_122 = var0_122:getActivityById(arg0_105:getConfig("link_id"))

					if var1_122 and not var1_122:isEnd() then
						var1_122.data1 = var1_122.data1 + arg0_105.count

						var0_122:updateActivity(var1_122)
					end
				end,
				[23] = function()
					local var0_123 = (function()
						for iter0_124, iter1_124 in ipairs(pg.gameset.package_lv.description) do
							if arg0_105.id == iter1_124[1] then
								return iter1_124[2]
							end
						end
					end)()

					assert(var0_123)

					local var1_123 = getProxy(PlayerProxy)
					local var2_123 = var1_123:getData()

					var2_123:addExpToLevel(var0_123)
					var1_123:updatePlayer(var2_123)
				end,
				[24] = function()
					local var0_125 = arg0_105:getConfig("link_id")
					local var1_125 = getProxy(ActivityProxy):getActivityById(var0_125)

					if var1_125 and not var1_125:isEnd() and var1_125:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_125.data2 = var1_125.data2 + arg0_105.count

						getProxy(ActivityProxy):updateActivity(var1_125)
					end
				end,
				[25] = function()
					local var0_126 = getProxy(ActivityProxy)
					local var1_126 = var0_126:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_126 and not var1_126:isEnd() then
						var1_126.data1 = var1_126.data1 - 1

						if not table.contains(var1_126.data1_list, arg0_105.id) then
							table.insert(var1_126.data1_list, arg0_105.id)
						end

						var0_126:updateActivity(var1_126)

						local var2_126 = arg0_105:getConfig("link_id")

						if var2_126 > 0 then
							local var3_126 = var0_126:getActivityById(var2_126)

							if var3_126 and not var3_126:isEnd() then
								var3_126.data1 = var3_126.data1 + 1

								var0_126:updateActivity(var3_126)
							end
						end
					end
				end,
				[26] = function()
					local var0_127 = getProxy(ActivityProxy)
					local var1_127 = Clone(var0_127:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_127 and not var1_127:isEnd() then
						var1_127.data1 = var1_127.data1 + arg0_105.count

						var0_127:updateActivity(var1_127)
					end
				end,
				[27] = function()
					local var0_128 = getProxy(ActivityProxy)
					local var1_128 = Clone(var0_128:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_128 and not var1_128:isEnd() then
						var1_128:AddExp(arg0_105.count)
						var0_128:updateActivity(var1_128)
					end
				end,
				[28] = function()
					local var0_129 = getProxy(ActivityProxy)
					local var1_129 = Clone(var0_129:getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN))

					if var1_129 and not var1_129:isEnd() then
						var1_129:AddGold(arg0_105.count)
						var0_129:updateActivity(var1_129)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end,
				[101] = function()
					local var0_132 = arg0_105:getConfig("link_id")
					local var1_132 = getProxy(ActivityProxy):getActivityById(var0_132)

					if var1_132 and not var1_132:isEnd() then
						var1_132.data1 = var1_132.data1 + arg0_105.count

						getProxy(ActivityProxy):updateActivity(var1_132)
					end
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_133)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_133.id, arg0_133.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_134)
			local var0_134 = getProxy(BayProxy)
			local var1_134 = var0_134:getShipById(arg0_134.count)

			if var1_134 then
				var1_134:unlockActivityNpc(0)
				var0_134:updateShip(var1_134)
				getProxy(CollectionProxy):flushCollection(var1_134)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_135)
			nowWorld():GetInventoryProxy():AddItem(arg0_135.id, arg0_135.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_136)
			local var0_136 = getProxy(AttireProxy)
			local var1_136 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_136 = IconFrame.New({
				id = arg0_136.id
			})
			local var3_136 = var1_136 + var2_136:getConfig("time_second")

			var2_136:updateData({
				isNew = true,
				end_time = var3_136
			})
			var0_136:addAttireFrame(var2_136)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_136)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_137)
			local var0_137 = getProxy(AttireProxy)
			local var1_137 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_137 = ChatFrame.New({
				id = arg0_137.id
			})
			local var3_137 = var1_137 + var2_137:getConfig("time_second")

			var2_137:updateData({
				isNew = true,
				end_time = var3_137
			})
			var0_137:addAttireFrame(var2_137)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_137)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_138)
			getProxy(EmojiProxy):addNewEmojiID(arg0_138.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_138:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_139)
			nowWorld():GetCollectionProxy():Unlock(arg0_139.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_140)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_140.id):addPT(arg0_140.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_141)
			local var0_141 = arg0_141.id
			local var1_141 = arg0_141.count
			local var2_141 = getProxy(ShipSkinProxy)
			local var3_141 = var2_141:getSkinById(var0_141)

			if var3_141 and var3_141:isExpireType() then
				local var4_141 = var1_141 + var3_141.endTime
				local var5_141 = ShipSkin.New({
					id = var0_141,
					end_time = var4_141
				})

				var2_141:addSkin(var5_141)
			elseif not var3_141 then
				local var6_141 = var1_141 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_141 = ShipSkin.New({
					id = var0_141,
					end_time = var6_141
				})

				var2_141:addSkin(var7_141)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_142)
			local var0_142 = arg0_142.id
			local var1_142 = pg.benefit_buff_template[var0_142]

			assert(var1_142 and var1_142.act_id > 0, "should exist act id")

			local var2_142 = getProxy(ActivityProxy):getActivityById(var1_142.act_id)

			if var2_142 and not var2_142:isEnd() then
				local var3_142 = var1_142.max_time
				local var4_142 = pg.TimeMgr.GetInstance():GetServerTime() + var3_142

				var2_142:AddBuff(ActivityBuff.New(var2_142.id, var0_142, var4_142))
				getProxy(ActivityProxy):updateActivity(var2_142)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_143)
			return
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_144)
			getProxy(ApartmentProxy):changeGiftCount(arg0_144.id, arg0_144.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_145)
			local var0_145 = getProxy(ApartmentProxy)
			local var1_145 = var0_145:getApartment(arg0_145:getConfig("ship_group"))

			var1_145:addSkin(arg0_145.id)
			var0_145:updateApartment(var1_145)
		end
	}

	function var0_0.AddItemDefault(arg0_146)
		if arg0_146.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_146 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_146.type].activity_id)

			if arg0_146.type == DROP_TYPE_RYZA_DROP then
				if var0_146 and not var0_146:isEnd() then
					var0_146:AddItem(AtelierMaterial.New({
						configId = arg0_146.id,
						count = arg0_146.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_146)
				end
			elseif var0_146 and not var0_146:isEnd() then
				var0_146:addVitemNumber(arg0_146.id, arg0_146.count)
				getProxy(ActivityProxy):updateActivity(var0_146)
			end
		else
			print("can not handle this type>>" .. arg0_146.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_147, arg1_147, arg2_147)
			setText(arg2_147, arg0_147:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_148, arg1_148, arg2_148)
			local var0_148 = arg0_148:getConfig("display")

			if arg0_148:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_148 = string.gsub(var0_148, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_148.extra))
			elseif arg0_148:getConfig("combination_display") ~= nil then
				local var1_148 = arg0_148:getConfig("combination_display")

				if var1_148 and #var1_148 > 0 then
					var0_148 = Item.StaticCombinationDisplay(var1_148)
				end
			end

			setText(arg2_148, SwitchSpecialChar(var0_148, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_149, arg1_149, arg2_149)
			setText(arg2_149, arg0_149:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_150, arg1_150, arg2_150)
			local var0_150 = arg0_150:getConfig("skin_id")
			local var1_150, var2_150, var3_150 = ShipWordHelper.GetWordAndCV(var0_150, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_150, var3_150 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_151, arg1_151, arg2_151)
			local var0_151 = arg0_151:getConfig("skin_id")
			local var1_151, var2_151, var3_151 = ShipWordHelper.GetWordAndCV(var0_151, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_151, var3_151 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_152, arg1_152, arg2_152)
			setText(arg2_152, arg1_152.name or arg0_152:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_153, arg1_153, arg2_153)
			local var0_153 = arg0_153:getConfig("desc")

			for iter0_153, iter1_153 in ipairs({
				arg0_153.count
			}) do
				var0_153 = string.gsub(var0_153, "$" .. iter0_153, iter1_153)
			end

			setText(arg2_153, var0_153)
		end,
		[DROP_TYPE_SKIN] = function(arg0_154, arg1_154, arg2_154)
			setText(arg2_154, arg0_154:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_155, arg1_155, arg2_155)
			setText(arg2_155, arg0_155:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_156, arg1_156, arg2_156)
			local var0_156 = arg0_156:getConfig("desc")
			local var1_156 = _.map(arg0_156:getConfig("equip_type"), function(arg0_157)
				return EquipType.Type2Name2(arg0_157)
			end)

			setText(arg2_156, var0_156 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_156, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_158, arg1_158, arg2_158)
			setText(arg2_158, arg0_158:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_159, arg1_159, arg2_159)
			setText(arg2_159, arg0_159:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_160, arg1_160, arg2_160, arg3_160)
			local var0_160 = WorldCollectionProxy.GetCollectionType(arg0_160.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_160, i18n("world_" .. var0_160 .. "_desc", arg0_160:getConfig("name")))
			setText(arg3_160, i18n("world_" .. var0_160 .. "_name", arg0_160:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_161, arg1_161, arg2_161)
			setText(arg2_161, arg0_161:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_162, arg1_162, arg2_162)
			setText(arg2_162, arg0_162:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_163, arg1_163, arg2_163)
			setText(arg2_163, arg0_163:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_164, arg1_164, arg2_164)
			local var0_164 = string.gsub(arg0_164:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_164.count))

			setText(arg2_164, SwitchSpecialChar(var0_164, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_165, arg1_165, arg2_165)
			setText(arg2_165, arg0_165:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_166, arg1_166, arg2_166)
			setText(arg2_166, arg0_166:getConfig("desc"))
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_167, arg1_167, arg2_167)
			setText(arg2_167, "")
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_168, arg1_168, arg2_168)
		if arg0_168.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_168, arg0_168:getConfig("display"))
		else
			assert(false, "can not handle this type>>" .. arg0_168.type)
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_169, arg1_169, arg2_169)
			if arg0_169.id == PlayerConst.ResStoreGold or arg0_169.id == PlayerConst.ResStoreOil then
				arg2_169 = arg2_169 or {}
				arg2_169.frame = "frame_store"
			end

			updateItem(arg1_169, Item.New({
				id = id2ItemId(arg0_169.id)
			}), arg2_169)
		end,
		[DROP_TYPE_ITEM] = function(arg0_170, arg1_170, arg2_170)
			updateItem(arg1_170, arg0_170:getSubClass(), arg2_170)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_171, arg1_171, arg2_171)
			updateEquipment(arg1_171, arg0_171:getSubClass(), arg2_171)
		end,
		[DROP_TYPE_SHIP] = function(arg0_172, arg1_172, arg2_172)
			updateShip(arg1_172, arg0_172.ship, arg2_172)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_173, arg1_173, arg2_173)
			updateShip(arg1_173, arg0_173.ship, arg2_173)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_174, arg1_174, arg2_174)
			updateFurniture(arg1_174, arg0_174, arg2_174)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_175, arg1_175, arg2_175)
			arg2_175.isWorldBuff = arg0_175.isWorldBuff

			updateStrategy(arg1_175, arg0_175, arg2_175)
		end,
		[DROP_TYPE_SKIN] = function(arg0_176, arg1_176, arg2_176)
			arg2_176.isSkin = true
			arg2_176.isNew = arg0_176.isNew

			updateShip(arg1_176, Ship.New({
				configId = tonumber(arg0_176:getConfig("ship_group") .. "1"),
				skin_id = arg0_176.id
			}), arg2_176)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_177, arg1_177, arg2_177)
			local var0_177 = setmetatable({
				count = arg0_177.count
			}, {
				__index = arg0_177:getConfigTable()
			})

			updateEquipmentSkin(arg1_177, var0_177, arg2_177)
		end,
		[DROP_TYPE_VITEM] = function(arg0_178, arg1_178, arg2_178)
			updateItem(arg1_178, Item.New({
				id = arg0_178.id
			}), arg2_178)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_179, arg1_179, arg2_179)
			updateWorldItem(arg1_179, WorldItem.New({
				id = arg0_179.id
			}), arg2_179)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_180, arg1_180, arg2_180)
			updateWorldCollection(arg1_180, arg0_180, arg2_180)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_181, arg1_181, arg2_181)
			updateAttire(arg1_181, AttireConst.TYPE_CHAT_FRAME, arg0_181:getConfigTable(), arg2_181)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_182, arg1_182, arg2_182)
			updateAttire(arg1_182, AttireConst.TYPE_ICON_FRAME, arg0_182:getConfigTable(), arg2_182)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_183, arg1_183, arg2_183)
			updateEmoji(arg1_183, arg0_183:getConfigTable(), arg2_183)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_184, arg1_184, arg2_184)
			arg2_184.count = 1

			updateItem(arg1_184, arg0_184:getSubClass(), arg2_184)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_185, arg1_185, arg2_185)
			updateSpWeapon(arg1_185, SpWeapon.New({
				id = arg0_185.id
			}), arg2_185)
		end,
		[DROP_TYPE_META_PT] = function(arg0_186, arg1_186, arg2_186)
			updateItem(arg1_186, Item.New({
				id = arg0_186:getConfig("id")
			}), arg2_186)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_187, arg1_187, arg2_187)
			arg2_187.isSkin = true
			arg2_187.isTimeLimit = true
			arg2_187.count = 1

			updateShip(arg1_187, Ship.New({
				configId = tonumber(arg0_187:getConfig("ship_group") .. "1"),
				skin_id = arg0_187.id
			}), arg2_187)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_188, arg1_188, arg2_188)
			AtelierMaterial.UpdateRyzaItem(arg1_188, arg0_188.item, arg2_188)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_189, arg1_189, arg2_189)
			WorkBenchItem.UpdateDrop(arg1_189, arg0_189.item, arg2_189)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_190, arg1_190, arg2_190)
			WorkBenchItem.UpdateDrop(arg1_190, WorkBenchItem.New({
				configId = arg0_190.id,
				count = arg0_190.count
			}), arg2_190)
		end,
		[DROP_TYPE_BUFF] = function(arg0_191, arg1_191, arg2_191)
			updateBuff(arg1_191, arg0_191.id, arg2_191)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_192, arg1_192, arg2_192)
			updateCommander(arg1_192, arg0_192, arg2_192)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_193, arg1_193, arg2_193)
			updateDorm3dFurniture(arg1_193, arg0_193, arg2_193)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_194, arg1_194, arg2_194)
			updateDorm3dGift(arg1_194, arg0_194, arg2_194)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_195, arg1_195, arg2_195)
			updateDorm3dSkin(arg1_195, arg0_195, arg2_195)
		end
	}

	function var0_0.UpdateDropDefault(arg0_196, arg1_196, arg2_196)
		warning(string.format("without dropType %d in updateDrop", arg0_196.type))
	end
end

return var0_0
