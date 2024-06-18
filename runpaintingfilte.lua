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

function var0_0.GetActID2MemoryMap()
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(pg.memory_group.all) do
		local var1_15 = pg.memory_group[iter1_15]
		local var2_15 = var1_15.link_event
		local var3_15 = var1_15.memories

		if var2_15 and var2_15 > 0 then
			if not var0_15[var2_15] then
				var0_15[var2_15] = {}
			end

			for iter2_15, iter3_15 in ipairs(var3_15) do
				if not table.contains(var0_15[var2_15], iter3_15) then
					table.insert(var0_15[var2_15], iter3_15)
				end
			end
		end
	end

	return var0_15
end

function var0_0.GetActPoolShipConfigIDList()
	local var0_16 = var0_0.GetActPoolIndexList()

	return var0_0.GetShipConfigIDListByPoolList(var0_16)
end

function var0_0.GetConstPoolShipConfigIDList()
	local var0_17 = var0_0.GetConstPoolIndexList()

	return var0_0.GetShipConfigIDListByPoolList(var0_17)
end

function var0_0.GetCreateExchangeShipConfigIDList()
	local var0_18 = {}
	local var1_18 = {
		10,
		11
	}

	for iter0_18, iter1_18 in ipairs(var1_18) do
		local var2_18 = var0_0.GetBuildActIDList()

		for iter2_18, iter3_18 in ipairs(var2_18) do
			if pg.ship_data_create_exchange[iter3_18] then
				for iter4_18, iter5_18 in ipairs(pg.ship_data_create_exchange[iter3_18].exchange_ship_id) do
					if not table.contains(var0_18, iter5_18) then
						table.insert(var0_18, iter5_18)
					end
				end
			end
		end
	end

	return var0_18
end

function var0_0.GetNPCShipConfigIDList()
	local var0_19 = {}
	local var1_19 = pg.activity_const.ACT_NPC_SHIP_ID.act_id

	if var1_19 and IsNumber(var1_19) and var0_0.IsActMatchTime(var1_19) then
		local var2_19 = pg.activity_template[var1_19].config_data[1]
		local var3_19 = pg.task_data_template[var2_19].award_display[1][2]

		table.insert(var0_19, var3_19)
	end

	return var0_19
end

function var0_0.GetSkinIDFromNormalShopID(arg0_20)
	local var0_20 = pg.shop_template[arg0_20].effect_args

	assert(#var0_20 == 1, "shop_template的effect_args字段,元素个数大于1,ID:", arg0_20)

	return var0_20[1]
end

function var0_0.GetNormalShopSkinIDList()
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		if var0_0.IsNormalShopMatch(iter1_21) then
			local var1_21 = var0_0.GetSkinIDFromNormalShopID(iter1_21)

			if not table.contains(var0_21, var1_21) then
				table.insert(var0_21, var1_21)
			end
		end
	end

	warning("普通商店皮肤个数" .. #var0_21)

	return var0_21
end

function var0_0.GetSkinIDFromActShopID(arg0_22)
	return pg.activity_shop_extra[arg0_22].commodity_id
end

function var0_0.GetActShopSkinIDList()
	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]) do
		if var0_0.IsActShopMatch(iter1_23) then
			local var1_23 = var0_0.GetSkinIDFromActShopID(iter1_23)

			if not table.contains(var0_23, var1_23) then
				table.insert(var0_23, var1_23)
			end
		end
	end

	warning("活动商店皮肤个数" .. #var0_23)

	return var0_23
end

local function var1_0(arg0_24, arg1_24)
	arg1_24 = string.lower(arg1_24)

	local var0_24 = pg.painting_filte_map[arg1_24].res_list

	for iter0_24, iter1_24 in ipairs(var0_24) do
		if not table.contains(arg0_24, iter1_24) then
			table.insert(arg0_24, iter1_24)
		end
	end
end

local function var2_0(arg0_25, arg1_25)
	local var0_25 = ShipGroup.getDefaultSkin(arg1_25).painting

	var1_0(arg0_25, var0_25)
end

local function var3_0(arg0_26, arg1_26)
	local var0_26 = {
		configId = arg1_26
	}
	local var1_26 = Ship.getGroupId(var0_26)

	var2_0(arg0_26, var1_26)
end

local function var4_0(arg0_27, arg1_27)
	local var0_27 = pg.ship_skin_template[arg1_27].painting

	var1_0(arg0_27, var0_27)
end

function SpecialFilteForChange()
	local var0_28 = {}

	local function var1_28(arg0_29)
		for iter0_29, iter1_29 in ipairs(arg0_29) do
			var3_0(var0_28, iter1_29)
		end
	end

	local function var2_28(arg0_30)
		for iter0_30, iter1_30 in ipairs(arg0_30) do
			var4_0(var0_28, iter1_30)
		end
	end

	if pg.painting_filte_config.current_act_pool == 1 then
		local var3_28 = PaintingfilteConst.GetActPoolShipConfigIDList()

		var1_28(var3_28)
	end

	local var4_28 = PaintingfilteConst.GetConstPoolShipConfigIDList()

	var1_28(var4_28)

	local var5_28 = PaintingfilteConst.GetNPCShipConfigIDList()

	var1_28(var5_28)

	local var6_28 = PaintingfilteConst.GetCreateExchangeShipConfigIDList()

	var1_28(var6_28)

	if pg.painting_filte_config.current_sale_skin == 1 then
		local var7_28 = PaintingfilteConst.GetNormalShopSkinIDList()

		warning("normalShopSkinIDList:" .. #var7_28)
		var2_28(var7_28)

		local var8_28 = PaintingfilteConst.GetActShopSkinIDList()

		warning("actShopSkinIDList:" .. #var8_28)
		var2_28(var8_28)
	end

	for iter0_28, iter1_28 in ipairs(pg.secretary_special_ship.all) do
		local var9_28 = pg.secretary_special_ship[iter1_28].prefab

		var1_0(var0_28, var9_28)
	end

	return table.concat(var0_28, ";")
end

function SpecialFilteForConst()
	local var0_31 = {}

	local function var1_31(arg0_32)
		for iter0_32, iter1_32 in ipairs(arg0_32) do
			var2_0(var0_31, iter1_32)
		end
	end

	local function var2_31(arg0_33)
		for iter0_33, iter1_33 in ipairs(arg0_33) do
			var4_0(var0_31, iter1_33)
		end
	end

	local var3_31 = pg.painting_filte_config.skin_id_list

	var2_31(var3_31)

	return table.concat(var0_31, ";")
end

function SpecialFilterForWorldStory(arg0_34)
	local var0_34 = {}

	for iter0_34 = arg0_34.Length, 1, -1 do
		table.insert(var0_34, arg0_34[iter0_34 - 1])
	end

	return pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var0_34)
end

function SpecialFilteForActStory()
	local var0_35 = PaintingfilteConst.GetActID2MemoryMap()
	local var1_35 = PaintingfilteConst.GetfilteTime()
	local var2_35 = {}

	for iter0_35, iter1_35 in ipairs(pg.activity_template.all) do
		if var0_35[iter1_35] and PaintingfilteConst.IsActMatchTime(iter1_35) then
			for iter2_35, iter3_35 in ipairs(var0_35[iter1_35]) do
				table.insert(var2_35, iter3_35)
			end
		end
	end

	local var3_35 = {}

	for iter4_35, iter5_35 in ipairs(var2_35) do
		local var4_35 = pg.memory_template[iter5_35]

		table.insert(var3_35, var4_35.story)
	end

	return pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var3_35)
end

PLATFORM_CH = 1
PLATFORM_JP = 2
PLATFORM_KR = 3
PLATFORM_US = 4
PLATFORM_CHT = 5

function SetPlatform(arg0_36)
	if arg0_36 == "zh" then
		PLATFORM_CODE = PLATFORM_CH
	elseif arg0_36 == "jp" then
		PLATFORM_CODE = PLATFORM_JP
	elseif arg0_36 == "us" then
		PLATFORM_CODE = PLATFORM_US
	elseif arg0_36 == "tw" then
		PLATFORM_CODE = PLATFORM_CHT
	elseif arg0_36 == "kr" then
		PLATFORM_CODE = PLATFORM_KR
	else
		return false
	end

	return true
end

UnGamePlayState = true
