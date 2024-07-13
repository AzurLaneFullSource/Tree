local var0_0 = class("TechnologyConst")

var0_0.OPEN_TECHNOLOGY_TREE_SCENE = "TechnologyConst:OPEN_TECHNOLOGY_TREE_SCENE"
var0_0.OPEN_SHIP_BUFF_DETAIL = "TechnologyConst:OPEN_SHIP_BUFF_DETAIL"
var0_0.OPEN_TECHNOLOGY_NATION_LAYER = "TechnologyConst:OPEN_TECHNOLOGY_NATION_LAYER"
var0_0.CLOSE_TECHNOLOGY_NATION_LAYER = "TechnologyConst:CLOSE_TECHNOLOGY_NATION_LAYER"
var0_0.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION = "TechnologyConst:CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION"
var0_0.OPEN_ALL_BUFF_DETAIL = "TechnologyConst:OPEN_ALL_BUFF_DETAIL"
var0_0.UPDATE_REDPOINT_ON_TOP = "TechnologyConst:UPDATE_REDPOINT_ON_TOP"
var0_0.CLICK_UP_TEC_BTN = "TechnologyConst:CLICK_UP_TEC_BTN"
var0_0.START_TEC_BTN_SUCCESS = "TechnologyConst:START_TEC_BTN_SUCCESS"
var0_0.FINISH_UP_TEC = "TechnologyConst:FINISH_UP_TEC"
var0_0.FINISH_TEC_SUCCESS = "TechnologyConst:FINISH_TEC_SUCCESS"
var0_0.GOT_TEC_CAMP_AWARD = "TechnologyConst:GOT_TEC_CAMP_AWARD"
var0_0.GOT_TEC_CAMP_AWARD_ONESTEP = "TechnologyConst:GOT_TEC_CAMP_AWARD_ONESTEP"
var0_0.SET_TEC_ATTR_ADDITION_FINISH = "TechnologyConst:SET_TEC_ATTR_ADDITION_FINISH"
var0_0.SHIP_LEVEL_FOR_BUFF = 120
var0_0.AtlasName = "ui/technologytreeui_atlas"
var0_0.QUEUE_TOTAL_COUNT = 5
var0_0.NationOrder = {
	Nation.US,
	Nation.EN,
	Nation.JP,
	Nation.DE,
	Nation.CN,
	Nation.SN,
	Nation.FF,
	Nation.MNF,
	Nation.ITA
}
var0_0.NationResName = {
	"nation_all_",
	"nation_baiying_",
	"nation_huangjia_",
	"nation_chongying_",
	"nation_tiexue_",
	"nation_donghuang_",
	"nation_beilian_",
	"nation_ziyou_",
	"nation_weixi_",
	"nation_sading_"
}
var0_0.TECH_NATION_ATTRS = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.Reload,
	AttributeType.Armor,
	AttributeType.Hit,
	AttributeType.Dodge,
	AttributeType.Speed,
	AttributeType.Luck,
	AttributeType.AntiSub
}

function var0_0.GetNationSpriteByIndex(arg0_1)
	local var0_1 = GetSpriteFromAtlas(var0_0.AtlasName, var0_0.NationResName[arg0_1] .. "01")
	local var1_1 = GetSpriteFromAtlas(var0_0.AtlasName, var0_0.NationResName[arg0_1] .. "02")

	return var0_1, var1_1
end

var0_0.TypeOrder = {
	{
		ShipType.QuZhu
	},
	{
		ShipType.QingXun
	},
	{
		ShipType.ZhongXun,
		ShipType.ChaoXun
	},
	{
		ShipType.QingHang,
		ShipType.ZhengHang
	},
	{
		ShipType.ZhanXun,
		ShipType.ZhanLie
	},
	{
		ShipType.QianTing,
		ShipType.QianMu
	},
	{
		ShipType.WeiXiu,
		ShipType.ZhongPao,
		ShipType.Yunshu,
		ShipType.HangZhan,
		ShipType.FengFanS,
		ShipType.FengFanV,
		ShipType.FengFanM
	}
}
var0_0.TypeResName = {
	"type_qvzhu_",
	"type_qingxun_",
	"type_zhongxun_",
	"type_hangmu_",
	"type_zhanlie_",
	"type_qianting_",
	"type_other_",
	"type_all_"
}

function var0_0.GetTypeSpriteByIndex(arg0_2)
	local var0_2 = GetSpriteFromAtlas(var0_0.AtlasName, var0_0.TypeResName[arg0_2] .. "01")
	local var1_2 = GetSpriteFromAtlas(var0_0.AtlasName, var0_0.TypeResName[arg0_2] .. "02")

	return var0_2, var1_2
end

function var0_0.ClassToGroupIDList()
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(pg.fleet_tech_ship_template.all) do
		local var1_3 = pg.fleet_tech_ship_template[iter1_3].class

		if var0_3[var1_3] then
			table.insert(var0_3[var1_3], iter1_3)
		else
			var0_3[var1_3] = {
				iter1_3
			}
		end
	end

	return var0_3
end

function var0_0.GetOrderClassList()
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(pg.fleet_tech_ship_class.all) do
		local var1_4 = pg.fleet_tech_ship_class[iter1_4].nation

		if var1_4 ~= Nation.META and var1_4 ~= Nation.MOT then
			table.insert(var0_4, iter1_4)
		end
	end

	local function var2_4(arg0_5, arg1_5)
		local var0_5 = pg.fleet_tech_ship_class[arg0_5]
		local var1_5 = pg.fleet_tech_ship_class[arg1_5]
		local var2_5

		if var0_5.t_level == var1_5.t_level then
			var2_5 = var0_5.t_level_1 > var1_5.t_level_1
		else
			var2_5 = var0_5.t_level > var1_5.t_level
		end

		return var2_5
	end

	table.sort(var0_4, var2_4)

	return var0_4
end

var0_0.MetaClassConfig = nil
var0_0.MotClassConfig = nil

function var0_0.CreateMetaClassConfig()
	if var0_0.MetaClassConfig or var0_0.MotClassConfig then
		return
	end

	for iter0_6, iter1_6 in ipairs(pg.fleet_tech_ship_class.all) do
		local var0_6 = pg.fleet_tech_ship_class[iter1_6]
		local var1_6 = var0_6.nation

		if var1_6 == Nation.META then
			if var0_0.MetaClassConfig == nil then
				var0_0.MetaClassConfig = {}
			end

			local var2_6 = var0_6.t_level
			local var3_6 = "meta_class_t_level_" .. var2_6

			if var0_0.MetaClassConfig[var3_6] == nil then
				var0_0.MetaClassConfig[var3_6] = {}
			end

			if var0_0.MetaClassConfig[var3_6].ships == nil then
				var0_0.MetaClassConfig[var3_6].ships = {}
			end

			local var4_6 = i18n(var3_6)
			local var5_6 = var0_6.t_level_1

			if var0_0.MetaClassConfig[var3_6].ships[var5_6] == nil then
				var0_0.MetaClassConfig[var3_6].ships[var5_6] = {}
			end

			if var0_0.MetaClassConfig[var3_6].indexList == nil then
				var0_0.MetaClassConfig[var3_6].indexList = {}
			end

			if not table.contains(var0_0.MetaClassConfig[var3_6].indexList, var5_6) then
				table.insert(var0_0.MetaClassConfig[var3_6].indexList, var5_6)
			end

			local var6_6 = var0_0.MetaClassConfig[var3_6]

			var6_6.id = var3_6
			var6_6.name = var4_6
			var6_6.nation = var1_6
			var6_6.t_level = var2_6

			table.insert(var6_6.ships[var5_6], var0_6.ships[1])
		elseif var1_6 == Nation.MOT then
			if var0_0.MotClassConfig == nil then
				var0_0.MotClassConfig = {}
			end

			local var7_6 = var0_6.t_level
			local var8_6 = "mot_class_t_level_" .. var7_6

			if var0_0.MotClassConfig[var8_6] == nil then
				var0_0.MotClassConfig[var8_6] = {}
			end

			if var0_0.MotClassConfig[var8_6].ships == nil then
				var0_0.MotClassConfig[var8_6].ships = {}
			end

			local var9_6 = i18n(var8_6)
			local var10_6 = var0_6.t_level_1

			if var0_0.MotClassConfig[var8_6].ships[var10_6] == nil then
				var0_0.MotClassConfig[var8_6].ships[var10_6] = {}
			end

			if var0_0.MotClassConfig[var8_6].indexList == nil then
				var0_0.MotClassConfig[var8_6].indexList = {}
			end

			if not table.contains(var0_0.MotClassConfig[var8_6].indexList, var10_6) then
				table.insert(var0_0.MotClassConfig[var8_6].indexList, var10_6)
			end

			local var11_6 = var0_0.MotClassConfig[var8_6]

			var11_6.id = var8_6
			var11_6.name = var9_6
			var11_6.nation = var1_6
			var11_6.t_level = var7_6

			table.insert(var11_6.ships[var10_6], var0_6.ships[1])
		end
	end

	if var0_0.MetaClassConfig then
		for iter2_6, iter3_6 in pairs(var0_0.MetaClassConfig) do
			local var12_6 = iter3_6.indexList
			local var13_6 = {}

			for iter4_6, iter5_6 in ipairs(var12_6) do
				_.each(iter3_6.ships[iter5_6], function(arg0_7)
					table.insert(var13_6, arg0_7)
				end)
			end

			iter3_6.ships = var13_6
		end
	end

	if var0_0.MotClassConfig then
		for iter6_6, iter7_6 in pairs(var0_0.MotClassConfig) do
			local var14_6 = iter7_6.indexList
			local var15_6 = {}

			for iter8_6, iter9_6 in ipairs(var14_6) do
				_.each(iter7_6.ships[iter9_6], function(arg0_8)
					table.insert(var15_6, arg0_8)
				end)
			end

			iter7_6.ships = var15_6
		end
	end
end

function var0_0.GetOrderMetaClassList(arg0_9)
	local var0_9 = {}
	local var1_9 = pg.gameset.meta_tech_sort.description
	local var2_9 = {}

	for iter0_9, iter1_9 in ipairs(var1_9) do
		for iter2_9, iter3_9 in pairs(var0_0.MetaClassConfig) do
			if iter1_9 == iter3_9.t_level then
				table.insert(var2_9, iter3_9)

				break
			end
		end
	end

	for iter4_9, iter5_9 in ipairs(var2_9) do
		local var3_9 = iter5_9.ships
		local var4_9

		if not arg0_9 or #arg0_9 == 0 then
			var4_9 = var3_9
		else
			var4_9 = _.select(var3_9, function(arg0_10)
				local var0_10 = var0_0.GetShipTypeByGroupID(arg0_10)

				return table.contains(arg0_9, var0_10)
			end)
		end

		if #var4_9 > 0 then
			table.insert(var0_9, iter5_9.id)
		end
	end

	return var0_9
end

function var0_0.GetOrderMotClassList(arg0_11)
	local var0_11 = {}
	local var1_11 = pg.gameset.tech_sort_mot.description
	local var2_11 = {}

	for iter0_11, iter1_11 in ipairs(var1_11) do
		for iter2_11, iter3_11 in pairs(var0_0.MotClassConfig) do
			if iter1_11 == iter3_11.t_level then
				table.insert(var2_11, iter3_11)

				break
			end
		end
	end

	for iter4_11, iter5_11 in ipairs(var2_11) do
		local var3_11 = iter5_11.ships
		local var4_11

		if not arg0_11 or #arg0_11 == 0 then
			var4_11 = var3_11
		else
			var4_11 = _.select(var3_11, function(arg0_12)
				local var0_12 = var0_0.GetShipTypeByGroupID(arg0_12)

				return table.contains(arg0_11, var0_12)
			end)
		end

		if #var4_11 > 0 then
			table.insert(var0_11, iter5_11.id)
		end
	end

	return var0_11
end

function var0_0.GetMetaClassConfig(arg0_13, arg1_13)
	local var0_13 = var0_0.MetaClassConfig[arg0_13]
	local var1_13 = var0_13.ships
	local var2_13

	if not arg1_13 or #arg1_13 == 0 then
		var2_13 = var1_13
	else
		var2_13 = _.select(var1_13, function(arg0_14)
			local var0_14 = var0_0.GetShipTypeByGroupID(arg0_14)

			return table.contains(arg1_13, var0_14)
		end)
	end

	return {
		id = var0_13.id,
		name = var0_13.name,
		nation = var0_13.nation,
		ships = var2_13
	}
end

function var0_0.GetMotClassConfig(arg0_15, arg1_15)
	local var0_15 = var0_0.MotClassConfig[arg0_15]
	local var1_15 = var0_15.ships
	local var2_15

	if not arg1_15 or #arg1_15 == 0 then
		var2_15 = var1_15
	else
		var2_15 = _.select(var1_15, function(arg0_16)
			local var0_16 = var0_0.GetShipTypeByGroupID(arg0_16)

			return table.contains(arg1_15, var0_16)
		end)
	end

	return {
		id = var0_15.id,
		name = var0_15.name,
		nation = var0_15.nation,
		ships = var2_15
	}
end

function var0_0.GetShipTypeByGroupID(arg0_17)
	local var0_17 = pg.ship_data_group.get_id_list_by_group_type[arg0_17][1]

	return pg.ship_data_group[var0_17].type
end

return var0_0
