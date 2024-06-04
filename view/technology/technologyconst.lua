local var0 = class("TechnologyConst")

var0.OPEN_TECHNOLOGY_TREE_SCENE = "TechnologyConst:OPEN_TECHNOLOGY_TREE_SCENE"
var0.OPEN_SHIP_BUFF_DETAIL = "TechnologyConst:OPEN_SHIP_BUFF_DETAIL"
var0.OPEN_TECHNOLOGY_NATION_LAYER = "TechnologyConst:OPEN_TECHNOLOGY_NATION_LAYER"
var0.CLOSE_TECHNOLOGY_NATION_LAYER = "TechnologyConst:CLOSE_TECHNOLOGY_NATION_LAYER"
var0.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION = "TechnologyConst:CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION"
var0.OPEN_ALL_BUFF_DETAIL = "TechnologyConst:OPEN_ALL_BUFF_DETAIL"
var0.UPDATE_REDPOINT_ON_TOP = "TechnologyConst:UPDATE_REDPOINT_ON_TOP"
var0.CLICK_UP_TEC_BTN = "TechnologyConst:CLICK_UP_TEC_BTN"
var0.START_TEC_BTN_SUCCESS = "TechnologyConst:START_TEC_BTN_SUCCESS"
var0.FINISH_UP_TEC = "TechnologyConst:FINISH_UP_TEC"
var0.FINISH_TEC_SUCCESS = "TechnologyConst:FINISH_TEC_SUCCESS"
var0.GOT_TEC_CAMP_AWARD = "TechnologyConst:GOT_TEC_CAMP_AWARD"
var0.GOT_TEC_CAMP_AWARD_ONESTEP = "TechnologyConst:GOT_TEC_CAMP_AWARD_ONESTEP"
var0.SET_TEC_ATTR_ADDITION_FINISH = "TechnologyConst:SET_TEC_ATTR_ADDITION_FINISH"
var0.SHIP_LEVEL_FOR_BUFF = 120
var0.AtlasName = "ui/technologytreeui_atlas"
var0.QUEUE_TOTAL_COUNT = 5
var0.NationOrder = {
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
var0.NationResName = {
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
var0.TECH_NATION_ATTRS = {
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

function var0.GetNationSpriteByIndex(arg0)
	local var0 = GetSpriteFromAtlas(var0.AtlasName, var0.NationResName[arg0] .. "01")
	local var1 = GetSpriteFromAtlas(var0.AtlasName, var0.NationResName[arg0] .. "02")

	return var0, var1
end

var0.TypeOrder = {
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
var0.TypeResName = {
	"type_qvzhu_",
	"type_qingxun_",
	"type_zhongxun_",
	"type_hangmu_",
	"type_zhanlie_",
	"type_qianting_",
	"type_other_",
	"type_all_"
}

function var0.GetTypeSpriteByIndex(arg0)
	local var0 = GetSpriteFromAtlas(var0.AtlasName, var0.TypeResName[arg0] .. "01")
	local var1 = GetSpriteFromAtlas(var0.AtlasName, var0.TypeResName[arg0] .. "02")

	return var0, var1
end

function var0.ClassToGroupIDList()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.fleet_tech_ship_template.all) do
		local var1 = pg.fleet_tech_ship_template[iter1].class

		if var0[var1] then
			table.insert(var0[var1], iter1)
		else
			var0[var1] = {
				iter1
			}
		end
	end

	return var0
end

function var0.GetOrderClassList()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.fleet_tech_ship_class.all) do
		local var1 = pg.fleet_tech_ship_class[iter1].nation

		if var1 ~= Nation.META and var1 ~= Nation.MOT then
			table.insert(var0, iter1)
		end
	end

	local function var2(arg0, arg1)
		local var0 = pg.fleet_tech_ship_class[arg0]
		local var1 = pg.fleet_tech_ship_class[arg1]
		local var2

		if var0.t_level == var1.t_level then
			var2 = var0.t_level_1 > var1.t_level_1
		else
			var2 = var0.t_level > var1.t_level
		end

		return var2
	end

	table.sort(var0, var2)

	return var0
end

var0.MetaClassConfig = nil
var0.MotClassConfig = nil

function var0.CreateMetaClassConfig()
	if var0.MetaClassConfig or var0.MotClassConfig then
		return
	end

	for iter0, iter1 in ipairs(pg.fleet_tech_ship_class.all) do
		local var0 = pg.fleet_tech_ship_class[iter1]
		local var1 = var0.nation

		if var1 == Nation.META then
			if var0.MetaClassConfig == nil then
				var0.MetaClassConfig = {}
			end

			local var2 = var0.t_level
			local var3 = "meta_class_t_level_" .. var2

			if var0.MetaClassConfig[var3] == nil then
				var0.MetaClassConfig[var3] = {}
			end

			if var0.MetaClassConfig[var3].ships == nil then
				var0.MetaClassConfig[var3].ships = {}
			end

			local var4 = i18n(var3)
			local var5 = var0.t_level_1

			if var0.MetaClassConfig[var3].ships[var5] == nil then
				var0.MetaClassConfig[var3].ships[var5] = {}
			end

			if var0.MetaClassConfig[var3].indexList == nil then
				var0.MetaClassConfig[var3].indexList = {}
			end

			if not table.contains(var0.MetaClassConfig[var3].indexList, var5) then
				table.insert(var0.MetaClassConfig[var3].indexList, var5)
			end

			local var6 = var0.MetaClassConfig[var3]

			var6.id = var3
			var6.name = var4
			var6.nation = var1
			var6.t_level = var2

			table.insert(var6.ships[var5], var0.ships[1])
		elseif var1 == Nation.MOT then
			if var0.MotClassConfig == nil then
				var0.MotClassConfig = {}
			end

			local var7 = var0.t_level
			local var8 = "mot_class_t_level_" .. var7

			if var0.MotClassConfig[var8] == nil then
				var0.MotClassConfig[var8] = {}
			end

			if var0.MotClassConfig[var8].ships == nil then
				var0.MotClassConfig[var8].ships = {}
			end

			local var9 = i18n(var8)
			local var10 = var0.t_level_1

			if var0.MotClassConfig[var8].ships[var10] == nil then
				var0.MotClassConfig[var8].ships[var10] = {}
			end

			if var0.MotClassConfig[var8].indexList == nil then
				var0.MotClassConfig[var8].indexList = {}
			end

			if not table.contains(var0.MotClassConfig[var8].indexList, var10) then
				table.insert(var0.MotClassConfig[var8].indexList, var10)
			end

			local var11 = var0.MotClassConfig[var8]

			var11.id = var8
			var11.name = var9
			var11.nation = var1
			var11.t_level = var7

			table.insert(var11.ships[var10], var0.ships[1])
		end
	end

	if var0.MetaClassConfig then
		for iter2, iter3 in pairs(var0.MetaClassConfig) do
			local var12 = iter3.indexList
			local var13 = {}

			for iter4, iter5 in ipairs(var12) do
				_.each(iter3.ships[iter5], function(arg0)
					table.insert(var13, arg0)
				end)
			end

			iter3.ships = var13
		end
	end

	if var0.MotClassConfig then
		for iter6, iter7 in pairs(var0.MotClassConfig) do
			local var14 = iter7.indexList
			local var15 = {}

			for iter8, iter9 in ipairs(var14) do
				_.each(iter7.ships[iter9], function(arg0)
					table.insert(var15, arg0)
				end)
			end

			iter7.ships = var15
		end
	end
end

function var0.GetOrderMetaClassList(arg0)
	local var0 = {}
	local var1 = pg.gameset.meta_tech_sort.description
	local var2 = {}

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in pairs(var0.MetaClassConfig) do
			if iter1 == iter3.t_level then
				table.insert(var2, iter3)

				break
			end
		end
	end

	for iter4, iter5 in ipairs(var2) do
		local var3 = iter5.ships
		local var4

		if not arg0 or #arg0 == 0 then
			var4 = var3
		else
			var4 = _.select(var3, function(arg0)
				local var0 = var0.GetShipTypeByGroupID(arg0)

				return table.contains(arg0, var0)
			end)
		end

		if #var4 > 0 then
			table.insert(var0, iter5.id)
		end
	end

	return var0
end

function var0.GetOrderMotClassList(arg0)
	local var0 = {}
	local var1 = pg.gameset.tech_sort_mot.description
	local var2 = {}

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in pairs(var0.MotClassConfig) do
			if iter1 == iter3.t_level then
				table.insert(var2, iter3)

				break
			end
		end
	end

	for iter4, iter5 in ipairs(var2) do
		local var3 = iter5.ships
		local var4

		if not arg0 or #arg0 == 0 then
			var4 = var3
		else
			var4 = _.select(var3, function(arg0)
				local var0 = var0.GetShipTypeByGroupID(arg0)

				return table.contains(arg0, var0)
			end)
		end

		if #var4 > 0 then
			table.insert(var0, iter5.id)
		end
	end

	return var0
end

function var0.GetMetaClassConfig(arg0, arg1)
	local var0 = var0.MetaClassConfig[arg0]
	local var1 = var0.ships
	local var2

	if not arg1 or #arg1 == 0 then
		var2 = var1
	else
		var2 = _.select(var1, function(arg0)
			local var0 = var0.GetShipTypeByGroupID(arg0)

			return table.contains(arg1, var0)
		end)
	end

	return {
		id = var0.id,
		name = var0.name,
		nation = var0.nation,
		ships = var2
	}
end

function var0.GetMotClassConfig(arg0, arg1)
	local var0 = var0.MotClassConfig[arg0]
	local var1 = var0.ships
	local var2

	if not arg1 or #arg1 == 0 then
		var2 = var1
	else
		var2 = _.select(var1, function(arg0)
			local var0 = var0.GetShipTypeByGroupID(arg0)

			return table.contains(arg1, var0)
		end)
	end

	return {
		id = var0.id,
		name = var0.name,
		nation = var0.nation,
		ships = var2
	}
end

function var0.GetShipTypeByGroupID(arg0)
	local var0 = pg.ship_data_group.get_id_list_by_group_type[arg0][1]

	return pg.ship_data_group[var0].type
end

return var0
