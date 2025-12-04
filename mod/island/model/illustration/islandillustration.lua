local var0_0 = class("IslandIllustration", import("model.vo.BaseVO"))

var0_0.TYPES = {
	ITEM = 3,
	CHAR = 1,
	FISH = 4,
	NPC = 2
}
var0_0.STATUS = {
	CAN_UNLOCK = 2,
	LOCK = 1,
	UNLOCK = 3
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg1_1
	arg0_1.status = var0_0.STATUS.LOCK
	arg0_1.isTip = false
	arg0_1.basePoint = 0
	arg0_1.levelPoints = 0
	arg0_1.levelPointGotData = {}
	arg0_1.starPoints = 0
	arg0_1.starPointGotData = {}

	arg0_1:InitConfigData()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_illustrated_guide
end

function var0_0.InitConfigData(arg0_3)
	return
end

function var0_0.bindLinkConfigTable(arg0_4)
	return switch(arg0_4:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			return pg.island_chara_template
		end,
		[var0_0.TYPES.NPC] = function()
			return pg.island_unit_character
		end,
		[var0_0.TYPES.ITEM] = function()
			return pg.island_item_data_template
		end,
		[var0_0.TYPES.FISH] = function()
			return pg.island_fish
		end
	})
end

function var0_0.GetLinkConfigID(arg0_9)
	return arg0_9:getConfig("unlock_id")
end

function var0_0.getLinkConfigTable(arg0_10)
	local var0_10 = arg0_10:bindLinkConfigTable()

	assert(var0_10, "should bindLinkConfigTable() first: " .. arg0_10.__cname)

	return var0_10[arg0_10:GetLinkConfigID()]
end

function var0_0.getLinkConfig(arg0_11, arg1_11)
	local var0_11 = arg0_11:getLinkConfigTable()

	assert(var0_11 ~= nil, "LinkConfig missed, type -" .. arg0_11.__cname .. " configId: " .. tostring(arg0_11.configId))

	return var0_11[arg1_11]
end

function var0_0.GetName(arg0_12)
	return switch(arg0_12:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			local var0_13 = arg0_12:getLinkConfig("unit_id")

			return pg.island_unit_character[var0_13].name
		end,
		[var0_0.TYPES.NPC] = function()
			return arg0_12:getLinkConfig("name")
		end,
		[var0_0.TYPES.ITEM] = function()
			return arg0_12:getLinkConfig("name")
		end,
		[var0_0.TYPES.FISH] = function()
			return arg0_12:getLinkConfig("name")
		end
	})
end

function var0_0.GetEnName(arg0_17)
	return switch(arg0_17:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			local var0_18 = arg0_17:getLinkConfig("unit_id")

			return pg.island_unit_character[var0_18].english_name
		end,
		[var0_0.TYPES.NPC] = function()
			return arg0_17:getLinkConfig("english_name")
		end,
		[var0_0.TYPES.ITEM] = function()
			return ""
		end,
		[var0_0.TYPES.FISH] = function()
			return ""
		end
	})
end

function var0_0.GetDesc(arg0_22)
	return switch(arg0_22:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			local var0_23 = arg0_22:getLinkConfig("unit_id")

			return pg.island_unit_character[var0_23].describe_illustrated_guid
		end,
		[var0_0.TYPES.NPC] = function()
			return arg0_22:getLinkConfig("describe_illustrated_guid")
		end,
		[var0_0.TYPES.ITEM] = function()
			return arg0_22:getLinkConfig("desc")
		end,
		[var0_0.TYPES.FISH] = function()
			local var0_26 = arg0_22:getLinkConfig("item_id")

			return pg.island_item_data_template[var0_26].desc
		end
	})
end

function var0_0.GetIcon(arg0_27)
	return switch(arg0_27:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			local var0_28 = arg0_27:GetLinkConfigID()

			return "ShipYardIcon/" .. IslandShip.StaticGetPrefab(var0_28)
		end,
		[var0_0.TYPES.NPC] = function()
			return "island/IslandCharIcon/" .. arg0_27:getLinkConfig("rendering")
		end,
		[var0_0.TYPES.ITEM] = function()
			return "island/" .. arg0_27:getLinkConfig("icon")
		end,
		[var0_0.TYPES.FISH] = function()
			local var0_31 = arg0_27:getLinkConfig("item_id")

			return "island/" .. pg.island_item_data_template[var0_31].icon
		end
	})
end

function var0_0.SetPointData(arg0_32, arg1_32)
	arg0_32.basePoint = arg1_32.base
	arg0_32.levelPoints = 0
	arg0_32.levelPointGotData = {}

	for iter0_32, iter1_32 in ipairs(arg1_32.lv_list) do
		arg0_32.levelPoints = arg0_32.levelPoints + iter1_32.value
		arg0_32.levelPointGotData[iter1_32.lv] = iter1_32.value
	end

	arg0_32.starPoints = 0
	arg0_32.starPointGotData = {}

	for iter2_32, iter3_32 in ipairs(arg1_32.star_list) do
		arg0_32.starPoints = arg0_32.starPoints + iter3_32.value
		arg0_32.starPointGotData[iter3_32.lv] = iter3_32.value
	end
end

function var0_0.SetStatus(arg0_33, arg1_33)
	arg0_33.status = arg1_33

	if arg0_33.status == var0_0.STATUS.CAN_UNLOCK then
		arg0_33.isTip = true
	elseif arg0_33.status == var0_0.STATUS.UNLOCK then
		arg0_33.basePoint = arg0_33:getConfig("collect_add")
	end
end

function var0_0.GetStatus(arg0_34)
	return arg0_34.status
end

function var0_0.CheckTip(arg0_35)
	arg0_35.isTip = arg0_35.status == var0_0.STATUS.CAN_UNLOCK
end

function var0_0.IsTip(arg0_36)
	return arg0_36.isTip
end

function var0_0.GetPoints(arg0_37)
	return arg0_37.basePoint + arg0_37.levelPoints + arg0_37.starPoints
end

function var0_0.GetTypeAndLinkId(arg0_38)
	local var0_38 = pg.island_illustrated_guide[arg0_38]

	return var0_38.type, var0_38.unlock_id
end

return var0_0
