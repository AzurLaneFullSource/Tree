PaintingfilteConst = {}

local var0_0 = PaintingfilteConst

function var0_0.GetStandardTimeConfig(arg0_1)
	local var0_1 = {}

	local function var1_1(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2) do
			if type(iter1_2) == "table" and #iter1_2 == 2 then
				table.insert(var0_1, iter1_2)
			end
		end
	end

	local function var2_1(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3) do
			if type(iter1_3) == "table" and type(iter1_3[1]) == "string" and type(iter1_3[2]) == "table" then
				var1_1(iter1_3)
			end
		end
	end

	if #arg0_1 == 2 and type(arg0_1[1][1]) == "string" and type(arg0_1[2][1]) == "string" then
		var2_1(arg0_1)
	else
		var1_1(arg0_1)
	end

	return var0_1
end

function var0_0.IsTwoTimeCross(arg0_4, arg1_4)
	local var0_4 = pg.TimeMgr.GetInstance()
	local var1_4 = var0_4:parseTimeFromConfig(arg0_4[1])
	local var2_4 = var0_4:parseTimeFromConfig(arg0_4[2])
	local var3_4 = var0_4:parseTimeFromConfig(arg1_4[1])
	local var4_4 = var0_4:parseTimeFromConfig(arg1_4[2])

	if var2_4 <= var3_4 or var4_4 <= var1_4 then
		return false
	else
		return true
	end
end

function var0_0.IsActMatchTime(arg0_5)
	local var0_5 = pg.activity_template[arg0_5]
	local var1_5 = var0_5.type
	local var2_5 = var0_5.time

	if type(var2_5) == "string" and var2_5 == "always" then
		return true
	elseif type(var2_5) == "table" then
		local var3_5 = var0_0.GetStandardTimeConfig(var2_5)
		local var4_5 = var0_0.GetfilteTime()

		if var0_0.IsTwoTimeCross(var4_5, var3_5) then
			return true
		end
	end
end

function var0_0.IsBuildActMatch(arg0_6)
	if pg.activity_template[arg0_6].type == 1 or pg.activity_template[arg0_6].type == 85 then
		return (var0_0.IsActMatchTime(arg0_6))
	else
		return false
	end
end

function var0_0.IsNormalShopMatch(arg0_7)
	local var0_7 = pg.shop_template[arg0_7]
	local var1_7 = var0_7.genre
	local var2_7 = var0_7.time

	if var1_7 == "skin_shop" then
		if type(var2_7) == "string" and var2_7 == "always" then
			return true
		elseif type(var2_7) == "table" then
			local var3_7 = var0_0.GetStandardTimeConfig(var2_7)
			local var4_7 = var0_0.GetfilteTime()

			if var0_0.IsTwoTimeCross(var4_7, var3_7) then
				return true
			end
		end
	end

	return false
end

function var0_0.IsActShopMatch(arg0_8)
	local var0_8 = pg.activity_shop_extra[arg0_8]
	local var1_8 = var0_8.commodity_type
	local var2_8 = var0_8.time

	if var1_8 == DROP_TYPE_SKIN then
		if type(var2_8) == "string" and var2_8 == "always" then
			return true
		elseif type(var2_8) == "table" then
			local var3_8 = var0_0.GetStandardTimeConfig(var2_8)
			local var4_8 = var0_0.GetfilteTime()

			if var0_0.IsTwoTimeCross(var4_8, var3_8) then
				return true
			end
		end
	end

	return false
end

function var0_0.GetfilteTime()
	return pg.painting_filte_config.time
end

function var0_0.GetConstPoolIndexList()
	return pg.painting_filte_config.pool_id_list
end

function var0_0.IsPoolWeightConfigMatch(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg1_11) do
		if arg0_11[iter1_11] > 0 then
			return true
		end
	end

	return false
end

function var0_0.GetBuildActIDList()
	local var0_12 = {}

	for iter0_12, iter1_12 in ipairs(pg.activity_template.all) do
		if var0_0.IsBuildActMatch(iter1_12) then
			table.insert(var0_12, iter1_12)
		end
	end

	return var0_12
end

function var0_0.GetActPoolIndexList()
	local var0_13 = {}
	local var1_13 = var0_0.GetBuildActIDList()

	for iter0_13, iter1_13 in ipairs(var1_13) do
		local var2_13 = pg.activity_template[iter1_13].config_id

		if not table.contains(var0_13, var2_13) then
			table.insert(var0_13, var2_13)
		end
	end

	return var0_13
end

function var0_0.GetShipConfigIDListByPoolList(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(pg.ship_data_create) do
		local var1_14 = iter1_14.weight_group

		if var0_0.IsPoolWeightConfigMatch(var1_14, arg0_14) and not table.contains(var0_14, iter0_14) then
			table.insert(var0_14, iter0_14)
		end
	end

	return var0_14
end

function var0_0.GetLightPoolBlueDestroyerShipConfigIDList(arg0_15, arg1_15, arg2_15)
	arg0_15 = arg0_15 or 2
	arg1_15 = arg1_15 or 3
	arg2_15 = arg2_15 or 1

	local var0_15 = {}

	if type(arg0_15) ~= "number" or type(arg1_15) ~= "number" or type(arg2_15) ~= "number" or type(pg.ship_data_create) ~= "table" or type(pg.ship_data_statistics) ~= "table" then
		return var0_15
	end

	for iter0_15, iter1_15 in pairs(pg.ship_data_create) do
		if type(iter0_15) == "number" and type(iter1_15) == "table" then
			local var1_15 = iter1_15[arg0_15]
			local var2_15 = pg.ship_data_statistics[iter0_15]

			if type(var1_15) == "number" and var1_15 > 0 and type(var2_15) == "table" and var2_15.rarity == arg1_15 and var2_15.type == arg2_15 then
				table.insert(var0_15, iter0_15)
			end
		end
	end

	return var0_15
end

function var0_0.GetActID2MemoryMap()
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(pg.memory_group.all) do
		local var1_16 = pg.memory_group[iter1_16]
		local var2_16 = var1_16.link_event
		local var3_16 = var1_16.memories

		if var2_16 and var2_16 > 0 then
			if not var0_16[var2_16] then
				var0_16[var2_16] = {}
			end

			for iter2_16, iter3_16 in ipairs(var3_16) do
				if not table.contains(var0_16[var2_16], iter3_16) then
					table.insert(var0_16[var2_16], iter3_16)
				end
			end
		end
	end

	return var0_16
end

function var0_0.GetActPoolShipConfigIDList()
	local var0_17 = var0_0.GetActPoolIndexList()

	return var0_0.GetShipConfigIDListByPoolList(var0_17)
end

function var0_0.GetConstPoolShipConfigIDList()
	local var0_18 = var0_0.GetConstPoolIndexList()

	return var0_0.GetShipConfigIDListByPoolList(var0_18)
end

function var0_0.GetCreateExchangeShipConfigIDList()
	local var0_19 = {}
	local var1_19 = {
		10,
		11
	}

	for iter0_19, iter1_19 in ipairs(var1_19) do
		local var2_19 = var0_0.GetBuildActIDList()

		for iter2_19, iter3_19 in ipairs(var2_19) do
			if pg.ship_data_create_exchange[iter3_19] then
				for iter4_19, iter5_19 in ipairs(pg.ship_data_create_exchange[iter3_19].exchange_ship_id) do
					if not table.contains(var0_19, iter5_19) then
						table.insert(var0_19, iter5_19)
					end
				end
			end
		end
	end

	return var0_19
end

function var0_0.GetNPCShipConfigIDList()
	local var0_20 = {}

	for iter0_20, iter1_20 in ipairs(getGameset("act_npc_ship_id")[2]) do
		if var0_0.IsActMatchTime(iter1_20) then
			local var1_20 = pg.activity_template[iter1_20].config_data[1]
			local var2_20 = pg.task_data_template[var1_20].award_display[1][2]

			table.insert(var0_20, var2_20)
		end
	end

	return var0_20
end

function var0_0.GetSkinIDFromNormalShopID(arg0_21)
	local var0_21 = pg.shop_template[arg0_21].effect_args

	assert(#var0_21 == 1, "shop_template的effect_args字段,元素个数大于1,ID:", arg0_21)

	return var0_21[1]
end

function var0_0.GetNormalShopSkinIDList()
	local var0_22 = {}

	for iter0_22, iter1_22 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		if var0_0.IsNormalShopMatch(iter1_22) then
			local var1_22 = var0_0.GetSkinIDFromNormalShopID(iter1_22)

			if not table.contains(var0_22, var1_22) then
				table.insert(var0_22, var1_22)
			end

			if ShipSkin.IsChangeSkin(var1_22) then
				local var2_22 = ShipSkin.GetAllChangeSkinIds(var1_22)

				for iter2_22, iter3_22 in ipairs(var2_22) do
					if not table.contains(var0_22, iter3_22) then
						table.insert(var0_22, iter3_22)
					end
				end
			end
		end
	end

	warning("普通商店皮肤个数" .. #var0_22)

	return var0_22
end

function var0_0.GetSkinIDFromActShopID(arg0_23)
	return pg.activity_shop_extra[arg0_23].commodity_id
end

function var0_0.GetActShopSkinIDList()
	local var0_24 = {}

	for iter0_24, iter1_24 in ipairs(pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]) do
		if var0_0.IsActShopMatch(iter1_24) then
			local var1_24 = var0_0.GetSkinIDFromActShopID(iter1_24)

			if not table.contains(var0_24, var1_24) then
				table.insert(var0_24, var1_24)
			end

			if ShipSkin.IsChangeSkin(var1_24) then
				local var2_24 = ShipSkin.GetAllChangeSkinIds(var1_24)

				for iter2_24, iter3_24 in ipairs(var2_24) do
					if not table.contains(var0_24, iter3_24) then
						table.insert(var0_24, iter3_24)
					end
				end
			end
		end
	end

	warning("活动商店皮肤个数" .. #var0_24)

	return var0_24
end

local function var1_0(arg0_25, arg1_25)
	arg1_25 = string.lower(arg1_25)

	local var0_25 = pg.painting_filte_map[arg1_25].res_list

	for iter0_25, iter1_25 in ipairs(var0_25) do
		if not table.contains(arg0_25, iter1_25) then
			table.insert(arg0_25, iter1_25)
		end
	end
end

local function var2_0(arg0_26, arg1_26)
	local var0_26 = ShipGroup.getDefaultSkin(arg1_26).painting

	var1_0(arg0_26, var0_26)
end

local function var3_0(arg0_27, arg1_27)
	local var0_27 = {
		configId = arg1_27
	}
	local var1_27 = Ship.getGroupId(var0_27)

	var2_0(arg0_27, var1_27)
end

local function var4_0(arg0_28, arg1_28)
	local var0_28 = pg.ship_skin_template[arg1_28].painting

	var1_0(arg0_28, var0_28)
end

function SpecialFilteForChange()
	local var0_29 = {}

	local function var1_29(arg0_30)
		for iter0_30, iter1_30 in ipairs(arg0_30) do
			var3_0(var0_29, iter1_30)
		end
	end

	local function var2_29(arg0_31)
		for iter0_31, iter1_31 in ipairs(arg0_31) do
			var4_0(var0_29, iter1_31)
		end
	end

	if pg.painting_filte_config.current_act_pool == 1 then
		local var3_29 = PaintingfilteConst.GetActPoolShipConfigIDList()

		var1_29(var3_29)
	end

	local var4_29 = PaintingfilteConst.GetConstPoolShipConfigIDList()

	var1_29(var4_29)

	local var5_29 = PaintingfilteConst.GetLightPoolBlueDestroyerShipConfigIDList()

	var1_29(var5_29)

	local var6_29 = PaintingfilteConst.GetNPCShipConfigIDList()

	var1_29(var6_29)

	local var7_29 = PaintingfilteConst.GetCreateExchangeShipConfigIDList()

	var1_29(var7_29)

	if pg.painting_filte_config.current_sale_skin == 1 then
		local var8_29 = PaintingfilteConst.GetNormalShopSkinIDList()

		warning("normalShopSkinIDList:" .. #var8_29)
		var2_29(var8_29)

		local var9_29 = PaintingfilteConst.GetActShopSkinIDList()

		warning("actShopSkinIDList:" .. #var9_29)
		var2_29(var9_29)
	end

	for iter0_29, iter1_29 in ipairs(pg.secretary_special_ship.all) do
		local var10_29 = pg.secretary_special_ship[iter1_29].prefab

		var1_0(var0_29, var10_29)
	end

	return table.concat(var0_29, ";")
end

function SpecialFilteForConst()
	local var0_32 = {}

	local function var1_32(arg0_33)
		for iter0_33, iter1_33 in ipairs(arg0_33) do
			var2_0(var0_32, iter1_33)
		end
	end

	local function var2_32(arg0_34)
		for iter0_34, iter1_34 in ipairs(arg0_34) do
			var4_0(var0_32, iter1_34)
		end
	end

	local var3_32 = pg.painting_filte_config.skin_id_list

	var2_32(var3_32)

	return table.concat(var0_32, ";")
end

function SpecialFilterForWorldStory(arg0_35)
	local var0_35 = arg0_35:ToTable()

	return pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var0_35)
end

function SpecialFilteForActStory()
	local var0_36 = PaintingfilteConst.GetActID2MemoryMap()
	local var1_36 = PaintingfilteConst.GetfilteTime()
	local var2_36 = {}

	for iter0_36, iter1_36 in ipairs(pg.activity_template.all) do
		if var0_36[iter1_36] and PaintingfilteConst.IsActMatchTime(iter1_36) then
			for iter2_36, iter3_36 in ipairs(var0_36[iter1_36]) do
				table.insert(var2_36, iter3_36)
			end
		end
	end

	local var3_36 = {}

	for iter4_36, iter5_36 in ipairs(var2_36) do
		local var4_36 = pg.memory_template[iter5_36]

		for iter6_36, iter7_36 in ipairs(var4_36.unlock_pre) do
			table.insert(var3_36, iter7_36)
		end
	end

	return pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var3_36)
end

function SpecialFilteForShopSkinPrefab()
	local var0_37 = {}

	for iter0_37, iter1_37 in ipairs(pg.activity_template.all) do
		local var1_37 = pg.activity_template[iter1_37]

		if PaintingfilteConst.IsActMatchTime(iter1_37) and var1_37.config_client and type(var1_37.config_client) == "table" and var1_37.config_client.painting then
			if type(var1_37.config_client.painting) == "string" then
				table.insert(var0_37, var1_37.config_client.painting)
			end

			if type(var1_37.config_client.painting) == "table" then
				for iter2_37, iter3_37 in ipairs(var1_37.config_client.painting) do
					table.insert(var0_37, iter3_37)
				end
			end
		end
	end

	return table.concat(var0_37, ";")
end

PLATFORM_CH = 1
PLATFORM_JP = 2
PLATFORM_KR = 3
PLATFORM_US = 4
PLATFORM_CHT = 5

function SetPlatform(arg0_38)
	if arg0_38 == "zh" then
		PLATFORM_CODE = PLATFORM_CH
	elseif arg0_38 == "jp" then
		PLATFORM_CODE = PLATFORM_JP
	elseif arg0_38 == "us" then
		PLATFORM_CODE = PLATFORM_US
	elseif arg0_38 == "tw" then
		PLATFORM_CODE = PLATFORM_CHT
	elseif arg0_38 == "kr" then
		PLATFORM_CODE = PLATFORM_KR
	else
		return false
	end

	return true
end

UnGamePlayState = true
