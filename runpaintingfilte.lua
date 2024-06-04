PaintingfilteConst = {}

local var0 = PaintingfilteConst

function var0.GetStandardTimeConfig(arg0)
	local var0 = {}

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if type(iter1) == "table" and #iter1 == 2 then
				table.insert(var0, iter1)
			end
		end
	end

	local function var2(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if type(iter1) == "table" and type(iter1[1]) == "string" and type(iter1[2]) == "table" then
				var1(iter1)
			end
		end
	end

	if #arg0 == 2 and type(arg0[1][1]) == "string" and type(arg0[2][1]) == "string" then
		var2(arg0)
	else
		var1(arg0)
	end

	return var0
end

function var0.IsTwoTimeCross(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:parseTimeFromConfig(arg0[1])
	local var2 = var0:parseTimeFromConfig(arg0[2])
	local var3 = var0:parseTimeFromConfig(arg1[1])
	local var4 = var0:parseTimeFromConfig(arg1[2])

	if var2 <= var3 or var4 <= var1 then
		return false
	else
		return true
	end
end

function var0.IsActMatchTime(arg0)
	local var0 = pg.activity_template[arg0]
	local var1 = var0.type
	local var2 = var0.time

	if type(var2) == "string" and var2 == "always" then
		return true
	elseif type(var2) == "table" then
		local var3 = var0.GetStandardTimeConfig(var2)
		local var4 = var0.GetfilteTime()

		if var0.IsTwoTimeCross(var4, var3) then
			return true
		end
	end
end

function var0.IsBuildActMatch(arg0)
	if pg.activity_template[arg0].type == 1 or pg.activity_template[arg0].type == 85 then
		return (var0.IsActMatchTime(arg0))
	else
		return false
	end
end

function var0.IsNormalShopMatch(arg0)
	local var0 = pg.shop_template[arg0]
	local var1 = var0.genre
	local var2 = var0.time

	if var1 == "skin_shop" then
		if type(var2) == "string" and var2 == "always" then
			return true
		elseif type(var2) == "table" then
			local var3 = var0.GetStandardTimeConfig(var2)
			local var4 = var0.GetfilteTime()

			if var0.IsTwoTimeCross(var4, var3) then
				return true
			end
		end
	end

	return false
end

function var0.IsActShopMatch(arg0)
	local var0 = pg.activity_shop_extra[arg0]
	local var1 = var0.commodity_type
	local var2 = var0.time

	if var1 == DROP_TYPE_SKIN then
		if type(var2) == "string" and var2 == "always" then
			return true
		elseif type(var2) == "table" then
			local var3 = var0.GetStandardTimeConfig(var2)
			local var4 = var0.GetfilteTime()

			if var0.IsTwoTimeCross(var4, var3) then
				return true
			end
		end
	end

	return false
end

function var0.GetfilteTime()
	return pg.painting_filte_config.time
end

function var0.GetConstPoolIndexList()
	return pg.painting_filte_config.pool_id_list
end

function var0.IsPoolWeightConfigMatch(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		if arg0[iter1] > 0 then
			return true
		end
	end

	return false
end

function var0.GetBuildActIDList()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.activity_template.all) do
		if var0.IsBuildActMatch(iter1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetActPoolIndexList()
	local var0 = {}
	local var1 = var0.GetBuildActIDList()

	for iter0, iter1 in ipairs(var1) do
		local var2 = pg.activity_template[iter1].config_id

		if not table.contains(var0, var2) then
			table.insert(var0, var2)
		end
	end

	return var0
end

function var0.GetShipConfigIDListByPoolList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(pg.ship_data_create) do
		local var1 = iter1.weight_group

		if var0.IsPoolWeightConfigMatch(var1, arg0) and not table.contains(var0, iter0) then
			table.insert(var0, iter0)
		end
	end

	return var0
end

function var0.GetActID2MemoryMap()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.memory_group.all) do
		local var1 = pg.memory_group[iter1]
		local var2 = var1.link_event
		local var3 = var1.memories

		if var2 and var2 > 0 then
			if not var0[var2] then
				var0[var2] = {}
			end

			for iter2, iter3 in ipairs(var3) do
				if not table.contains(var0[var2], iter3) then
					table.insert(var0[var2], iter3)
				end
			end
		end
	end

	return var0
end

function var0.GetActPoolShipConfigIDList()
	local var0 = var0.GetActPoolIndexList()

	return var0.GetShipConfigIDListByPoolList(var0)
end

function var0.GetConstPoolShipConfigIDList()
	local var0 = var0.GetConstPoolIndexList()

	return var0.GetShipConfigIDListByPoolList(var0)
end

function var0.GetCreateExchangeShipConfigIDList()
	local var0 = {}
	local var1 = {
		10,
		11
	}

	for iter0, iter1 in ipairs(var1) do
		local var2 = var0.GetBuildActIDList()

		for iter2, iter3 in ipairs(var2) do
			if pg.ship_data_create_exchange[iter3] then
				for iter4, iter5 in ipairs(pg.ship_data_create_exchange[iter3].exchange_ship_id) do
					if not table.contains(var0, iter5) then
						table.insert(var0, iter5)
					end
				end
			end
		end
	end

	return var0
end

function var0.GetNPCShipConfigIDList()
	local var0 = {}
	local var1 = pg.activity_const.ACT_NPC_SHIP_ID.act_id

	if var1 and IsNumber(var1) and var0.IsActMatchTime(var1) then
		local var2 = pg.activity_template[var1].config_data[1]
		local var3 = pg.task_data_template[var2].award_display[1][2]

		table.insert(var0, var3)
	end

	return var0
end

function var0.GetSkinIDFromNormalShopID(arg0)
	local var0 = pg.shop_template[arg0].effect_args

	assert(#var0 == 1, "shop_template的effect_args字段,元素个数大于1,ID:", arg0)

	return var0[1]
end

function var0.GetNormalShopSkinIDList()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		if var0.IsNormalShopMatch(iter1) then
			local var1 = var0.GetSkinIDFromNormalShopID(iter1)

			if not table.contains(var0, var1) then
				table.insert(var0, var1)
			end
		end
	end

	warning("普通商店皮肤个数" .. #var0)

	return var0
end

function var0.GetSkinIDFromActShopID(arg0)
	return pg.activity_shop_extra[arg0].commodity_id
end

function var0.GetActShopSkinIDList()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]) do
		if var0.IsActShopMatch(iter1) then
			local var1 = var0.GetSkinIDFromActShopID(iter1)

			if not table.contains(var0, var1) then
				table.insert(var0, var1)
			end
		end
	end

	warning("活动商店皮肤个数" .. #var0)

	return var0
end

local function var1(arg0, arg1)
	arg1 = string.lower(arg1)

	local var0 = pg.painting_filte_map[arg1].res_list

	for iter0, iter1 in ipairs(var0) do
		if not table.contains(arg0, iter1) then
			table.insert(arg0, iter1)
		end
	end
end

local function var2(arg0, arg1)
	local var0 = ShipGroup.getDefaultSkin(arg1).painting

	var1(arg0, var0)
end

local function var3(arg0, arg1)
	local var0 = {
		configId = arg1
	}
	local var1 = Ship.getGroupId(var0)

	var2(arg0, var1)
end

local function var4(arg0, arg1)
	local var0 = pg.ship_skin_template[arg1].painting

	var1(arg0, var0)
end

function SpecialFilteForChange()
	local var0 = {}

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg0) do
			var3(var0, iter1)
		end
	end

	local function var2(arg0)
		for iter0, iter1 in ipairs(arg0) do
			var4(var0, iter1)
		end
	end

	if pg.painting_filte_config.current_act_pool == 1 then
		local var3 = PaintingfilteConst.GetActPoolShipConfigIDList()

		var1(var3)
	end

	local var4 = PaintingfilteConst.GetConstPoolShipConfigIDList()

	var1(var4)

	local var5 = PaintingfilteConst.GetNPCShipConfigIDList()

	var1(var5)

	local var6 = PaintingfilteConst.GetCreateExchangeShipConfigIDList()

	var1(var6)

	if pg.painting_filte_config.current_sale_skin == 1 then
		local var7 = PaintingfilteConst.GetNormalShopSkinIDList()

		warning("normalShopSkinIDList:" .. #var7)
		var2(var7)

		local var8 = PaintingfilteConst.GetActShopSkinIDList()

		warning("actShopSkinIDList:" .. #var8)
		var2(var8)
	end

	for iter0, iter1 in ipairs(pg.secretary_special_ship.all) do
		local var9 = pg.secretary_special_ship[iter1].prefab

		var1(var0, var9)
	end

	return table.concat(var0, ";")
end

function SpecialFilteForConst()
	local var0 = {}

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg0) do
			var2(var0, iter1)
		end
	end

	local function var2(arg0)
		for iter0, iter1 in ipairs(arg0) do
			var4(var0, iter1)
		end
	end

	local var3 = pg.painting_filte_config.skin_id_list

	var2(var3)

	return table.concat(var0, ";")
end

function SpecialFilterForWorldStory(arg0)
	local var0 = {}

	for iter0 = arg0.Length, 1, -1 do
		table.insert(var0, arg0[iter0 - 1])
	end

	return pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var0)
end

function SpecialFilteForActStory()
	local var0 = PaintingfilteConst.GetActID2MemoryMap()
	local var1 = PaintingfilteConst.GetfilteTime()
	local var2 = {}

	for iter0, iter1 in ipairs(pg.activity_template.all) do
		if var0[iter1] and PaintingfilteConst.IsActMatchTime(iter1) then
			for iter2, iter3 in ipairs(var0[iter1]) do
				table.insert(var2, iter3)
			end
		end
	end

	local var3 = {}

	for iter4, iter5 in ipairs(var2) do
		local var4 = pg.memory_template[iter5]

		table.insert(var3, var4.story)
	end

	return pg.NewStoryMgr.GetInstance():GetStoryPaintingsByNameList(var3)
end

PLATFORM_CH = 1
PLATFORM_JP = 2
PLATFORM_KR = 3
PLATFORM_US = 4
PLATFORM_CHT = 5

function SetPlatform(arg0)
	if arg0 == "zh" then
		PLATFORM_CODE = PLATFORM_CH
	elseif arg0 == "jp" then
		PLATFORM_CODE = PLATFORM_JP
	elseif arg0 == "us" then
		PLATFORM_CODE = PLATFORM_US
	elseif arg0 == "tw" then
		PLATFORM_CODE = PLATFORM_CHT
	elseif arg0 == "kr" then
		PLATFORM_CODE = PLATFORM_KR
	else
		return false
	end

	return true
end

UnGamePlayState = true
