local var0_0 = class("IslandIllustration", import("model.vo.BaseVO"))

var0_0.TYPES = {
	ITEM = 3,
	CHAR = 1,
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
	arg0_1.starPoints = 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_illustrated_guide
end

function var0_0.bindLinkConfigTable(arg0_3)
	return switch(arg0_3:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			return pg.island_chara_template
		end,
		[var0_0.TYPES.NPC] = function()
			return pg.island_unit_character
		end,
		[var0_0.TYPES.ITEM] = function()
			return pg.island_item_data_template
		end
	})
end

function var0_0.GetLinkConfigID(arg0_7)
	return arg0_7:getConfig("unlock_id")
end

function var0_0.getLinkConfigTable(arg0_8)
	local var0_8 = arg0_8:bindLinkConfigTable()

	assert(var0_8, "should bindLinkConfigTable() first: " .. arg0_8.__cname)

	return var0_8[arg0_8:GetLinkConfigID()]
end

function var0_0.getLinkConfig(arg0_9, arg1_9)
	local var0_9 = arg0_9:getLinkConfigTable()

	assert(var0_9 ~= nil, "LinkConfig missed, type -" .. arg0_9.__cname .. " configId: " .. tostring(arg0_9.configId))

	return var0_9[arg1_9]
end

function var0_0.GetName(arg0_10)
	return switch(arg0_10:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			local var0_11 = arg0_10:getLinkConfig("unit_id")

			return pg.island_unit_character[var0_11].name
		end,
		[var0_0.TYPES.NPC] = function()
			return arg0_10:getLinkConfig("name")
		end,
		[var0_0.TYPES.ITEM] = function()
			return arg0_10:getLinkConfig("name")
		end
	})
end

function var0_0.GetEnName(arg0_14)
	return switch(arg0_14:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			local var0_15 = arg0_14:getLinkConfig("unit_id")

			return pg.island_unit_character[var0_15].english_name
		end,
		[var0_0.TYPES.NPC] = function()
			return arg0_14:getLinkConfig("english_name")
		end,
		[var0_0.TYPES.ITEM] = function()
			return ""
		end
	})
end

function var0_0.GetDesc(arg0_18)
	return switch(arg0_18:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			local var0_19 = arg0_18:getLinkConfig("unit_id")

			return pg.island_unit_character[var0_19].describe_illustrated_guid
		end,
		[var0_0.TYPES.NPC] = function()
			return arg0_18:getLinkConfig("describe_illustrated_guid")
		end,
		[var0_0.TYPES.ITEM] = function()
			return arg0_18:getLinkConfig("desc")
		end
	})
end

function var0_0.GetIcon(arg0_22)
	return switch(arg0_22:getConfig("type"), {
		[var0_0.TYPES.CHAR] = function()
			local var0_23 = arg0_22:GetLinkConfigID()

			return "ShipYardIcon/" .. IslandShip.StaticGetPrefab(var0_23)
		end,
		[var0_0.TYPES.NPC] = function()
			return "island/IslandCharIcon/" .. arg0_22:getLinkConfig("rendering")
		end,
		[var0_0.TYPES.ITEM] = function()
			return "island/" .. arg0_22:getLinkConfig("icon")
		end
	})
end

function var0_0.SetPointData(arg0_26, arg1_26)
	arg0_26.basePoint = arg1_26.base
	arg0_26.levelPoints = 0

	for iter0_26, iter1_26 in ipairs(arg1_26.lv_list) do
		arg0_26.levelPoints = arg0_26.levelPoints + iter1_26.value
	end

	arg0_26.starPoints = 0

	for iter2_26, iter3_26 in ipairs(arg1_26.star_list) do
		arg0_26.starPoints = arg0_26.starPoints + iter3_26.value
	end
end

function var0_0.SetStatus(arg0_27, arg1_27)
	arg0_27.status = arg1_27

	if arg0_27.status == var0_0.STATUS.CAN_UNLOCK then
		arg0_27.isTip = true
	elseif arg0_27.status == var0_0.STATUS.UNLOCK then
		arg0_27.basePoint = arg0_27:getConfig("collect_add")
	end
end

function var0_0.GetStatus(arg0_28)
	return arg0_28.status
end

function var0_0.CheckTip(arg0_29)
	arg0_29.isTip = arg0_29.status == var0_0.STATUS.CAN_UNLOCK
end

function var0_0.IsTip(arg0_30)
	return arg0_30.isTip
end

function var0_0.GetPoints(arg0_31)
	return arg0_31.basePoint + arg0_31.levelPoints + arg0_31.starPoints
end

function var0_0.GetTypeAndLinkId(arg0_32)
	local var0_32 = pg.island_illustrated_guide[arg0_32]

	return var0_32.type, var0_32.unlock_id
end

return var0_0
