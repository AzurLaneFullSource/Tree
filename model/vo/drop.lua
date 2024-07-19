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
				end
			}, function()
				return arg0_88
			end)
		end,
		[DROP_TYPE_SHIP] = function(arg0_94, arg1_94)
			if Ship.isMetaShipByConfigID(arg0_94.id) and Player.isMetaShipNeedToTrans(arg0_94.id) then
				local var0_94 = table.indexof(arg1_94, arg0_94.id, 1)

				if var0_94 then
					table.remove(arg1_94, var0_94)
				else
					local var1_94 = Player.metaShip2Res(arg0_94.id)
					local var2_94 = Drop.New(var1_94[1])

					getProxy(BayProxy):addMetaTransItemMap(arg0_94.id, var2_94)

					return arg0_94, var2_94
				end
			end

			return arg0_94
		end,
		[DROP_TYPE_SKIN] = function(arg0_95)
			arg0_95.isNew = not getProxy(ShipSkinProxy):hasOldNonLimitSkin(arg0_95.id)

			return arg0_95
		end
	}

	function var0_0.TransDefault(arg0_96)
		return arg0_96
	end

	var0_0.AddItemCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_97)
			local var0_97 = id2res(arg0_97.id)

			assert(var0_97, "res should be defined: " .. arg0_97.id)

			local var1_97 = getProxy(PlayerProxy)
			local var2_97 = var1_97:getData()

			var2_97:addResources({
				[var0_97] = arg0_97.count
			})
			var1_97:updatePlayer(var2_97)
		end,
		[DROP_TYPE_ITEM] = function(arg0_98)
			if arg0_98:getConfig("type") == Item.EXP_BOOK_TYPE then
				local var0_98 = getProxy(BagProxy):getItemCountById(arg0_98.id)
				local var1_98 = math.min(arg0_98:getConfig("max_num") - var0_98, arg0_98.count)

				if var1_98 > 0 then
					getProxy(BagProxy):addItemById(arg0_98.id, var1_98)
				end
			else
				getProxy(BagProxy):addItemById(arg0_98.id, arg0_98.count, arg0_98.extra)
			end
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_99)
			local var0_99 = arg0_99:getSubClass()

			getProxy(BagProxy):addItemById(var0_99.id, var0_99.count, var0_99.extra)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_100)
			getProxy(EquipmentProxy):addEquipmentById(arg0_100.id, arg0_100.count)
		end,
		[DROP_TYPE_SHIP] = function(arg0_101)
			return
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_102)
			local var0_102 = getProxy(DormProxy)
			local var1_102 = Furniture.New({
				id = arg0_102.id,
				count = arg0_102.count
			})

			if var1_102:isRecordTime() then
				var1_102.date = pg.TimeMgr.GetInstance():GetServerTime()
			end

			var0_102:AddFurniture(var1_102)
		end,
		[DROP_TYPE_SKIN] = function(arg0_103)
			local var0_103 = getProxy(ShipSkinProxy)
			local var1_103 = ShipSkin.New({
				id = arg0_103.id
			})

			var0_103:addSkin(var1_103)
		end,
		[DROP_TYPE_VITEM] = function(arg0_104)
			arg0_104 = arg0_104:getSubClass()

			assert(arg0_104:isVirtualItem(), "item type error(virtual item)>>" .. arg0_104.id)
			switch(arg0_104:getConfig("virtual_type"), {
				[0] = function()
					getProxy(ActivityProxy):addVitemById(arg0_104.id, arg0_104.count)
				end,
				function()
					local var0_106 = getProxy(ActivityProxy)
					local var1_106 = arg0_104:getConfig("link_id")
					local var2_106

					if var1_106 > 0 then
						var2_106 = var0_106:getActivityById(var1_106)
					else
						var2_106 = var0_106:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
					end

					if var2_106 and not var2_106:isEnd() then
						if not table.contains(var2_106.data1_list, arg0_104.id) then
							table.insert(var2_106.data1_list, arg0_104.id)
						end

						var0_106:updateActivity(var2_106)
					end
				end,
				function()
					local var0_107 = getProxy(ActivityProxy)
					local var1_107 = var0_107:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

					for iter0_107, iter1_107 in ipairs(var1_107) do
						iter1_107.data1 = iter1_107.data1 + arg0_104.count

						local var2_107 = iter1_107:getConfig("config_id")
						local var3_107 = pg.activity_vote[var2_107]

						if var3_107 and var3_107.ticket_id_period == arg0_104.id then
							iter1_107.data3 = iter1_107.data3 + arg0_104.count
						end

						var0_107:updateActivity(iter1_107)
						pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_VOTE, {
							ptId = arg0_104.id,
							ptCount = arg0_104.count
						})
					end
				end,
				[4] = function()
					local var0_108 = getProxy(ColoringProxy):getColorItems()

					var0_108[arg0_104.id] = (var0_108[arg0_104.id] or 0) + arg0_104.count
				end,
				[6] = function()
					local var0_109 = getProxy(ActivityProxy)
					local var1_109 = var0_109:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX)

					if var1_109 then
						var1_109.data3 = var1_109.data3 + arg0_104.count

						var0_109:updateActivity(var1_109)
					end
				end,
				[7] = function()
					local var0_110 = getProxy(ChapterProxy)

					var0_110:updateRemasterTicketsNum(math.min(var0_110.remasterTickets + arg0_104.count, pg.gameset.reactivity_ticket_max.key_value))
				end,
				[9] = function()
					local var0_111 = getProxy(ActivityProxy)
					local var1_111 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

					if var1_111 then
						var1_111.data1_list[1] = var1_111.data1_list[1] + arg0_104.count

						var0_111:updateActivity(var1_111)
					end
				end,
				[10] = function()
					local var0_112 = getProxy(ActivityProxy)
					local var1_112 = var0_112:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

					if var1_112 and not var1_112:isEnd() then
						var1_112.data1 = var1_112.data1 + arg0_104.count

						var0_112:updateActivity(var1_112)
						pg.m02:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
							activity = var1_112
						})
					end
				end,
				[11] = function()
					local var0_113 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

					if var0_113 and not var0_113:isEnd() then
						var0_113.data1 = var0_113.data1 + arg0_104.count
					end
				end,
				[12] = function()
					local var0_114 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

					if var0_114 and not var0_114:isEnd() then
						var0_114.data1KeyValueList[1][arg0_104.id] = (var0_114.data1KeyValueList[1][arg0_104.id] or 0) + arg0_104.count
					end
				end,
				[13] = function()
					SkinCouponActivity.AddSkinCoupon(arg0_104.id)
				end,
				[14] = function()
					local var0_116 = nowWorld():GetBossProxy()

					if WorldBossConst.WORLD_BOSS_ITEM_ID == arg0_104.id then
						var0_116:AddSummonPt(arg0_104.count)
					elseif WorldBossConst.WORLD_PAST_BOSS_ITEM_ID == arg0_104.id then
						var0_116:AddSummonPtOld(arg0_104.count)
					end
				end,
				[15] = function()
					local var0_117 = getProxy(ActivityProxy)
					local var1_117 = var0_117:getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

					if var1_117 and not var1_117:isEnd() then
						local var2_117 = pg.activity_event_grid[var1_117.data1]

						if arg0_104.id == var2_117.ticket_item then
							var1_117.data2 = var1_117.data2 + arg0_104.count
						elseif arg0_104.id == var2_117.explore_item then
							var1_117.data3 = var1_117.data3 + arg0_104.count
						end
					end

					var0_117:updateActivity(var1_117)
				end,
				[16] = function()
					local var0_118 = getProxy(ActivityProxy)
					local var1_118 = var0_118:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS)

					for iter0_118, iter1_118 in pairs(var1_118) do
						if iter1_118 and not iter1_118:isEnd() and arg0_104.id == iter1_118:getConfig("config_id") then
							iter1_118.data1 = iter1_118.data1 + arg0_104.count

							var0_118:updateActivity(iter1_118)
						end
					end
				end,
				[20] = function()
					local var0_119 = getProxy(BagProxy)
					local var1_119 = pg.gameset.urpt_chapter_max.description
					local var2_119 = var1_119[1]
					local var3_119 = var1_119[2]
					local var4_119 = var0_119:GetLimitCntById(var2_119)
					local var5_119 = math.min(var3_119 - var4_119, arg0_104.count)

					if var5_119 > 0 then
						var0_119:addItemById(var2_119, var5_119)
						var0_119:AddLimitCnt(var2_119, var5_119)
					end
				end,
				[21] = function()
					local var0_120 = getProxy(ActivityProxy)
					local var1_120 = var0_120:getActivityById(arg0_104:getConfig("link_id"))

					if var1_120 and not var1_120:isEnd() then
						var1_120.data2 = 1

						var0_120:updateActivity(var1_120)
					end
				end,
				[22] = function()
					local var0_121 = getProxy(ActivityProxy)
					local var1_121 = var0_121:getActivityById(arg0_104:getConfig("link_id"))

					if var1_121 and not var1_121:isEnd() then
						var1_121.data1 = var1_121.data1 + arg0_104.count

						var0_121:updateActivity(var1_121)
					end
				end,
				[23] = function()
					local var0_122 = (function()
						for iter0_123, iter1_123 in ipairs(pg.gameset.package_lv.description) do
							if arg0_104.id == iter1_123[1] then
								return iter1_123[2]
							end
						end
					end)()

					assert(var0_122)

					local var1_122 = getProxy(PlayerProxy)
					local var2_122 = var1_122:getData()

					var2_122:addExpToLevel(var0_122)
					var1_122:updatePlayer(var2_122)
				end,
				[24] = function()
					local var0_124 = arg0_104:getConfig("link_id")
					local var1_124 = getProxy(ActivityProxy):getActivityById(var0_124)

					if var1_124 and not var1_124:isEnd() and var1_124:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING then
						var1_124.data2 = var1_124.data2 + arg0_104.count

						getProxy(ActivityProxy):updateActivity(var1_124)
					end
				end,
				[25] = function()
					local var0_125 = getProxy(ActivityProxy)
					local var1_125 = var0_125:getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

					if var1_125 and not var1_125:isEnd() then
						var1_125.data1 = var1_125.data1 - 1

						if not table.contains(var1_125.data1_list, arg0_104.id) then
							table.insert(var1_125.data1_list, arg0_104.id)
						end

						var0_125:updateActivity(var1_125)

						local var2_125 = arg0_104:getConfig("link_id")

						if var2_125 > 0 then
							local var3_125 = var0_125:getActivityById(var2_125)

							if var3_125 and not var3_125:isEnd() then
								var3_125.data1 = var3_125.data1 + 1

								var0_125:updateActivity(var3_125)
							end
						end
					end
				end,
				[26] = function()
					local var0_126 = getProxy(ActivityProxy)
					local var1_126 = Clone(var0_126:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING))

					if var1_126 and not var1_126:isEnd() then
						var1_126.data1 = var1_126.data1 + arg0_104.count

						var0_126:updateActivity(var1_126)
					end
				end,
				[99] = function()
					return
				end,
				[100] = function()
					return
				end
			})
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_129)
			getProxy(EquipmentProxy):addEquipmentSkin(arg0_129.id, arg0_129.count)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_130)
			local var0_130 = getProxy(BayProxy)
			local var1_130 = var0_130:getShipById(arg0_130.count)

			if var1_130 then
				var1_130:unlockActivityNpc(0)
				var0_130:updateShip(var1_130)
				getProxy(CollectionProxy):flushCollection(var1_130)
			end
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_131)
			nowWorld():GetInventoryProxy():AddItem(arg0_131.id, arg0_131.count)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_132)
			local var0_132 = getProxy(AttireProxy)
			local var1_132 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_132 = IconFrame.New({
				id = arg0_132.id
			})
			local var3_132 = var1_132 + var2_132:getConfig("time_second")

			var2_132:updateData({
				isNew = true,
				end_time = var3_132
			})
			var0_132:addAttireFrame(var2_132)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_132)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_133)
			local var0_133 = getProxy(AttireProxy)
			local var1_133 = pg.TimeMgr.GetInstance():GetServerTime()
			local var2_133 = ChatFrame.New({
				id = arg0_133.id
			})
			local var3_133 = var1_133 + var2_133:getConfig("time_second")

			var2_133:updateData({
				isNew = true,
				end_time = var3_133
			})
			var0_133:addAttireFrame(var2_133)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_ATTIRE, var2_133)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_134)
			getProxy(EmojiProxy):addNewEmojiID(arg0_134.id)
			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_EMOJI, arg0_134:getConfigTable())
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_135)
			nowWorld():GetCollectionProxy():Unlock(arg0_135.id)
		end,
		[DROP_TYPE_META_PT] = function(arg0_136)
			getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_136.id):addPT(arg0_136.count)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_137)
			local var0_137 = arg0_137.id
			local var1_137 = arg0_137.count
			local var2_137 = getProxy(ShipSkinProxy)
			local var3_137 = var2_137:getSkinById(var0_137)

			if var3_137 and var3_137:isExpireType() then
				local var4_137 = var1_137 + var3_137.endTime
				local var5_137 = ShipSkin.New({
					id = var0_137,
					end_time = var4_137
				})

				var2_137:addSkin(var5_137)
			elseif not var3_137 then
				local var6_137 = var1_137 + pg.TimeMgr.GetInstance():GetServerTime()
				local var7_137 = ShipSkin.New({
					id = var0_137,
					end_time = var6_137
				})

				var2_137:addSkin(var7_137)
			end
		end,
		[DROP_TYPE_BUFF] = function(arg0_138)
			local var0_138 = arg0_138.id
			local var1_138 = pg.benefit_buff_template[var0_138]

			assert(var1_138 and var1_138.act_id > 0, "should exist act id")

			local var2_138 = getProxy(ActivityProxy):getActivityById(var1_138.act_id)

			if var2_138 and not var2_138:isEnd() then
				local var3_138 = var1_138.max_time
				local var4_138 = pg.TimeMgr.GetInstance():GetServerTime() + var3_138

				var2_138:AddBuff(ActivityBuff.New(var2_138.id, var0_138, var4_138))
				getProxy(ActivityProxy):updateActivity(var2_138)
			end
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_139)
			return
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_140)
			getProxy(ApartmentProxy):changeGiftCount(arg0_140.id, arg0_140.count)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_141)
			local var0_141 = getProxy(ApartmentProxy)
			local var1_141 = var0_141:getApartment(arg0_141:getConfig("ship_group"))

			var1_141:addSkin(arg0_141.id)
			var0_141:updateApartment(var1_141)
		end
	}

	function var0_0.AddItemDefault(arg0_142)
		if arg0_142.type > DROP_TYPE_USE_ACTIVITY_DROP then
			local var0_142 = getProxy(ActivityProxy):getActivityById(pg.activity_drop_type[arg0_142.type].activity_id)

			if arg0_142.type == DROP_TYPE_RYZA_DROP then
				if var0_142 and not var0_142:isEnd() then
					var0_142:AddItem(AtelierMaterial.New({
						configId = arg0_142.id,
						count = arg0_142.count
					}))
					getProxy(ActivityProxy):updateActivity(var0_142)
				end
			elseif var0_142 and not var0_142:isEnd() then
				var0_142:addVitemNumber(arg0_142.id, arg0_142.count)
				getProxy(ActivityProxy):updateActivity(var0_142)
			end
		else
			print("can not handle this type>>" .. arg0_142.type)
		end
	end

	var0_0.MsgboxIntroCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_143, arg1_143, arg2_143)
			setText(arg2_143, arg0_143:getConfig("display"))
		end,
		[DROP_TYPE_ITEM] = function(arg0_144, arg1_144, arg2_144)
			local var0_144 = arg0_144:getConfig("display")

			if arg0_144:getConfig("type") == Item.LOVE_LETTER_TYPE then
				var0_144 = string.gsub(var0_144, "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_144.extra))
			elseif arg0_144:getConfig("combination_display") ~= nil then
				local var1_144 = arg0_144:getConfig("combination_display")

				if var1_144 and #var1_144 > 0 then
					var0_144 = Item.StaticCombinationDisplay(var1_144)
				end
			end

			setText(arg2_144, SwitchSpecialChar(var0_144, true))
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_145, arg1_145, arg2_145)
			setText(arg2_145, arg0_145:getConfig("describe"))
		end,
		[DROP_TYPE_SHIP] = function(arg0_146, arg1_146, arg2_146)
			local var0_146 = arg0_146:getConfig("skin_id")
			local var1_146, var2_146, var3_146 = ShipWordHelper.GetWordAndCV(var0_146, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_146, var3_146 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_OPERATION] = function(arg0_147, arg1_147, arg2_147)
			local var0_147 = arg0_147:getConfig("skin_id")
			local var1_147, var2_147, var3_147 = ShipWordHelper.GetWordAndCV(var0_147, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

			setText(arg2_147, var3_147 or i18n("ship_drop_desc_default"))
		end,
		[DROP_TYPE_EQUIP] = function(arg0_148, arg1_148, arg2_148)
			setText(arg2_148, arg1_148.name or arg0_148:getConfig("name") or "")
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_149, arg1_149, arg2_149)
			local var0_149 = arg0_149:getConfig("desc")

			for iter0_149, iter1_149 in ipairs({
				arg0_149.count
			}) do
				var0_149 = string.gsub(var0_149, "$" .. iter0_149, iter1_149)
			end

			setText(arg2_149, var0_149)
		end,
		[DROP_TYPE_SKIN] = function(arg0_150, arg1_150, arg2_150)
			setText(arg2_150, arg0_150:getConfig("desc"))
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_151, arg1_151, arg2_151)
			setText(arg2_151, arg0_151:getConfig("desc"))
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_152, arg1_152, arg2_152)
			local var0_152 = arg0_152:getConfig("desc")
			local var1_152 = _.map(arg0_152:getConfig("equip_type"), function(arg0_153)
				return EquipType.Type2Name2(arg0_153)
			end)

			setText(arg2_152, var0_152 .. "\n\n" .. i18n("word_fit") .. ": " .. table.concat(var1_152, ","))
		end,
		[DROP_TYPE_VITEM] = function(arg0_154, arg1_154, arg2_154)
			setText(arg2_154, arg0_154:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_155, arg1_155, arg2_155)
			setText(arg2_155, arg0_155:getConfig("display"))
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_156, arg1_156, arg2_156, arg3_156)
			local var0_156 = WorldCollectionProxy.GetCollectionType(arg0_156.id) == WorldCollectionProxy.WorldCollectionType.FILE and "file" or "record"

			setText(arg2_156, i18n("world_" .. var0_156 .. "_desc", arg0_156:getConfig("name")))
			setText(arg3_156, i18n("world_" .. var0_156 .. "_name", arg0_156:getConfig("name")))
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_157, arg1_157, arg2_157)
			setText(arg2_157, arg0_157:getConfig("desc"))
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_158, arg1_158, arg2_158)
			setText(arg2_158, arg0_158:getConfig("desc"))
		end,
		[DROP_TYPE_EMOJI] = function(arg0_159, arg1_159, arg2_159)
			setText(arg2_159, arg0_159:getConfig("item_desc"))
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_160, arg1_160, arg2_160)
			local var0_160 = string.gsub(arg0_160:getConfig("display"), "$1", ShipGroup.getDefaultShipNameByGroupID(arg0_160.count))

			setText(arg2_160, SwitchSpecialChar(var0_160, true))
		end,
		[DROP_TYPE_META_PT] = function(arg0_161, arg1_161, arg2_161)
			setText(arg2_161, arg0_161:getConfig("display"))
		end,
		[DROP_TYPE_BUFF] = function(arg0_162, arg1_162, arg2_162)
			setText(arg2_162, arg0_162:getConfig("desc"))
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_163, arg1_163, arg2_163)
			setText(arg2_163, "")
		end
	}

	function var0_0.MsgboxIntroDefault(arg0_164, arg1_164, arg2_164)
		if arg0_164.type > DROP_TYPE_USE_ACTIVITY_DROP then
			setText(arg2_164, arg0_164:getConfig("display"))
		else
			assert(false, "can not handle this type>>" .. arg0_164.type)
		end
	end

	var0_0.UpdateDropCase = {
		[DROP_TYPE_RESOURCE] = function(arg0_165, arg1_165, arg2_165)
			if arg0_165.id == PlayerConst.ResStoreGold or arg0_165.id == PlayerConst.ResStoreOil then
				arg2_165 = arg2_165 or {}
				arg2_165.frame = "frame_store"
			end

			updateItem(arg1_165, Item.New({
				id = id2ItemId(arg0_165.id)
			}), arg2_165)
		end,
		[DROP_TYPE_ITEM] = function(arg0_166, arg1_166, arg2_166)
			updateItem(arg1_166, arg0_166:getSubClass(), arg2_166)
		end,
		[DROP_TYPE_EQUIP] = function(arg0_167, arg1_167, arg2_167)
			updateEquipment(arg1_167, arg0_167:getSubClass(), arg2_167)
		end,
		[DROP_TYPE_SHIP] = function(arg0_168, arg1_168, arg2_168)
			updateShip(arg1_168, arg0_168.ship, arg2_168)
		end,
		[DROP_TYPE_OPERATION] = function(arg0_169, arg1_169, arg2_169)
			updateShip(arg1_169, arg0_169.ship, arg2_169)
		end,
		[DROP_TYPE_FURNITURE] = function(arg0_170, arg1_170, arg2_170)
			updateFurniture(arg1_170, arg0_170, arg2_170)
		end,
		[DROP_TYPE_STRATEGY] = function(arg0_171, arg1_171, arg2_171)
			arg2_171.isWorldBuff = arg0_171.isWorldBuff

			updateStrategy(arg1_171, arg0_171, arg2_171)
		end,
		[DROP_TYPE_SKIN] = function(arg0_172, arg1_172, arg2_172)
			arg2_172.isSkin = true
			arg2_172.isNew = arg0_172.isNew

			updateShip(arg1_172, Ship.New({
				configId = tonumber(arg0_172:getConfig("ship_group") .. "1"),
				skin_id = arg0_172.id
			}), arg2_172)
		end,
		[DROP_TYPE_EQUIPMENT_SKIN] = function(arg0_173, arg1_173, arg2_173)
			local var0_173 = setmetatable({
				count = arg0_173.count
			}, {
				__index = arg0_173:getConfigTable()
			})

			updateEquipmentSkin(arg1_173, var0_173, arg2_173)
		end,
		[DROP_TYPE_VITEM] = function(arg0_174, arg1_174, arg2_174)
			updateItem(arg1_174, Item.New({
				id = arg0_174.id
			}), arg2_174)
		end,
		[DROP_TYPE_WORLD_ITEM] = function(arg0_175, arg1_175, arg2_175)
			updateWorldItem(arg1_175, WorldItem.New({
				id = arg0_175.id
			}), arg2_175)
		end,
		[DROP_TYPE_WORLD_COLLECTION] = function(arg0_176, arg1_176, arg2_176)
			updateWorldCollection(arg1_176, arg0_176, arg2_176)
		end,
		[DROP_TYPE_CHAT_FRAME] = function(arg0_177, arg1_177, arg2_177)
			updateAttire(arg1_177, AttireConst.TYPE_CHAT_FRAME, arg0_177:getConfigTable(), arg2_177)
		end,
		[DROP_TYPE_ICON_FRAME] = function(arg0_178, arg1_178, arg2_178)
			updateAttire(arg1_178, AttireConst.TYPE_ICON_FRAME, arg0_178:getConfigTable(), arg2_178)
		end,
		[DROP_TYPE_EMOJI] = function(arg0_179, arg1_179, arg2_179)
			updateEmoji(arg1_179, arg0_179:getConfigTable(), arg2_179)
		end,
		[DROP_TYPE_LOVE_LETTER] = function(arg0_180, arg1_180, arg2_180)
			arg2_180.count = 1

			updateItem(arg1_180, arg0_180:getSubClass(), arg2_180)
		end,
		[DROP_TYPE_SPWEAPON] = function(arg0_181, arg1_181, arg2_181)
			updateSpWeapon(arg1_181, SpWeapon.New({
				id = arg0_181.id
			}), arg2_181)
		end,
		[DROP_TYPE_META_PT] = function(arg0_182, arg1_182, arg2_182)
			updateItem(arg1_182, Item.New({
				id = arg0_182:getConfig("id")
			}), arg2_182)
		end,
		[DROP_TYPE_SKIN_TIMELIMIT] = function(arg0_183, arg1_183, arg2_183)
			arg2_183.isSkin = true
			arg2_183.isTimeLimit = true
			arg2_183.count = 1

			updateShip(arg1_183, Ship.New({
				configId = tonumber(arg0_183:getConfig("ship_group") .. "1"),
				skin_id = arg0_183.id
			}), arg2_183)
		end,
		[DROP_TYPE_RYZA_DROP] = function(arg0_184, arg1_184, arg2_184)
			AtelierMaterial.UpdateRyzaItem(arg1_184, arg0_184.item, arg2_184)
		end,
		[DROP_TYPE_WORKBENCH_DROP] = function(arg0_185, arg1_185, arg2_185)
			WorkBenchItem.UpdateDrop(arg1_185, arg0_185.item, arg2_185)
		end,
		[DROP_TYPE_FEAST_DROP] = function(arg0_186, arg1_186, arg2_186)
			WorkBenchItem.UpdateDrop(arg1_186, WorkBenchItem.New({
				configId = arg0_186.id,
				count = arg0_186.count
			}), arg2_186)
		end,
		[DROP_TYPE_BUFF] = function(arg0_187, arg1_187, arg2_187)
			updateBuff(arg1_187, arg0_187.id, arg2_187)
		end,
		[DROP_TYPE_COMMANDER_CAT] = function(arg0_188, arg1_188, arg2_188)
			updateCommander(arg1_188, arg0_188, arg2_188)
		end,
		[DROP_TYPE_DORM3D_FURNITURE] = function(arg0_189, arg1_189, arg2_189)
			updateDorm3dFurniture(arg1_189, arg0_189, arg2_189)
		end,
		[DROP_TYPE_DORM3D_GIFT] = function(arg0_190, arg1_190, arg2_190)
			updateDorm3dGift(arg1_190, arg0_190, arg2_190)
		end,
		[DROP_TYPE_DORM3D_SKIN] = function(arg0_191, arg1_191, arg2_191)
			updateDorm3dSkin(arg1_191, arg0_191, arg2_191)
		end
	}

	function var0_0.UpdateDropDefault(arg0_192, arg1_192, arg2_192)
		warning(string.format("without dropType %d in updateDrop", arg0_192.type))
	end
end

return var0_0
