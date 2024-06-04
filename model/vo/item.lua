local var0 = class("Item", import(".BaseVO"))

var0.REVERT_EQUIPMENT_ID = 15007
var0.COMMANDER_QUICKLY_TOOL_ID = 20010
var0.QUICK_TASK_PASS_TICKET_ID = 15013
var0.DOA_SELECT_CHAR_ID = 70144
var0.INVISIBLE_TYPE = {
	[0] = true,
	[9] = true
}
var0.PUZZLA_TYPE = 0
var0.EQUIPMENT_BOX_TYPE_5 = 5
var0.LESSON_TYPE = 10
var0.EQUIPMENT_SKIN_BOX = 11
var0.BLUEPRINT_TYPE = 12
var0.ASSIGNED_TYPE = 13
var0.GOLD_BOX_TYPE = 14
var0.OIL_BOX_TYPE = 15
var0.EQUIPMENT_ASSIGNED_TYPE = 16
var0.GIFT_BOX = 17
var0.TEC_SPEEDUP_TYPE = 18
var0.SPECIAL_OPERATION_TICKET = 19
var0.GUILD_OPENABLE = 20
var0.INVITATION_TYPE = 21
var0.EXP_BOOK_TYPE = 22
var0.LOVE_LETTER_TYPE = 23
var0.SPWEAPON_MATERIAL_TYPE = 24
var0.METALESSON_TYPE = 25
var0.SKIN_ASSIGNED_TYPE = 26

function var0.Ctor(arg0, arg1)
	assert(not arg1.type or arg1.type == DROP_TYPE_VITEM or arg1.type == DROP_TYPE_ITEM)

	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.count = arg1.count
	arg0.name = arg1.name
	arg0.extra = arg1.extra

	arg0:InitConfig()
end

function var0.CanOpen(arg0)
	local var0 = arg0:getConfig("type")

	return var0 == var0.EQUIPMENT_BOX_TYPE_5 or var0 == var0.EQUIPMENT_SKIN_BOX or var0 == var0.GOLD_BOX_TYPE or var0 == var0.OIL_BOX_TYPE or var0 == var0.GIFT_BOX or var0 == var0.GUILD_OPENABLE
end

function var0.IsShipExpType(arg0)
	return arg0:getConfig("type") == var0.EXP_BOOK_TYPE
end

function var0.getConfigData(arg0)
	local var0 = {
		pg.item_virtual_data_statistics,
		pg.item_data_statistics
	}
	local var1

	if underscore.any(var0, function(arg0)
		return arg0[arg0] ~= nil
	end) then
		var1 = setmetatable({}, {
			__index = function(arg0, arg1)
				for iter0, iter1 in ipairs(var0) do
					if iter1[arg0] and iter1[arg0][arg1] ~= nil then
						arg0[arg1] = iter1[arg0][arg1]

						return arg0[arg1]
					end
				end
			end
		})
	end

	return var1
end

function var0.InitConfig(arg0)
	arg0.cfg = var0.getConfigData(arg0.configId)

	assert(arg0.cfg, string.format("without item config from id_%d", arg0.id))
end

function var0.getConfigTable(arg0)
	return arg0.cfg
end

function var0.CanInBag(arg0)
	return tobool(pg.item_data_statistics[arg0])
end

function var0.couldSell(arg0)
	return table.getCount(arg0:getConfig("price")) > 0
end

function var0.isEnough(arg0, arg1)
	return arg1 <= arg0.count
end

function var0.consume(arg0, arg1)
	arg0.count = arg0.count - arg1
end

function var0.isDesignDrawing(arg0)
	return arg0:getConfig("type") == 9
end

function var0.isVirtualItem(arg0)
	return arg0:getConfig("type") == 0
end

function var0.isEquipmentSkinBox(arg0)
	return arg0:getConfig("type") == var0.EQUIPMENT_SKIN_BOX
end

function var0.isBluePrintType(arg0)
	return arg0:getConfig("type") == var0.BLUEPRINT_TYPE
end

function var0.isTecSpeedUpType(arg0)
	return arg0:getConfig("type") == var0.TEC_SPEEDUP_TYPE
end

function var0.IsMaxCnt(arg0)
	return arg0:getConfig("max_num") <= arg0.count
end

function var0.IsDoaSelectCharItem(arg0)
	return arg0.id == var0.DOA_SELECT_CHAR_ID
end

function var0.getConfig(arg0, arg1)
	if arg1 == "display" then
		local var0 = var0.super.getConfig(arg0, "combination_display")

		if var0 and #var0 > 0 then
			return arg0:CombinationDisplay(var0)
		end
	end

	return var0.super.getConfig(arg0, arg1)
end

function var0.StaticCombinationDisplay(arg0)
	local var0 = _.map(arg0, function(arg0)
		local var0 = string.format("%0.1f", arg0[2] / 100)
		local var1 = ShipSkin.New({
			id = arg0[1]
		})
		local var2 = ""

		if var1:IsLive2d() then
			var2 = "（<color=#92fc63>" .. i18n("luckybag_skin_islive2d") .. "</color>）"
		elseif var1:IsSpine() then
			var2 = "（<color=#92fc63>" .. i18n("luckybag_skin_isani") .. "</color>）"
		end

		local var3 = i18n("random_skin_list_item_desc_label")
		local var4 = ""

		if var1:ExistReward() then
			var4 = i18n("word_show_extra_reward_at_fudai_dialog", var1:GetRewardListDesc())
		end

		return "\n（<color=#92fc63>" .. var0 .. "%%</color>）" .. var1.shipName .. var3 .. var1.skinName .. var2 .. var4
	end)
	local var1 = table.concat(var0, ";")

	return i18n("skin_gift_desc", var1)
end

function var0.CombinationDisplay(arg0, arg1)
	return var0.StaticCombinationDisplay(arg1)
end

function var0.InTimeLimitSkinAssigned(arg0)
	local var0 = var0.getConfigData(arg0)

	if var0.type ~= var0.SKIN_ASSIGNED_TYPE then
		return false
	end

	local var1 = var0.usage_arg[1]

	return getProxy(ActivityProxy):IsActivityNotEnd(var1)
end

function var0.GetValidSkinList(arg0)
	assert(arg0:getConfig("type") == var0.SKIN_ASSIGNED_TYPE)

	local var0 = arg0:getConfig("usage_arg")

	if Item.InTimeLimitSkinAssigned(arg0.id) then
		return table.mergeArray(var0[2], var0[3], true)
	else
		return underscore.rest(var0[3], 1)
	end
end

function var0.IsAllSkinOwner(arg0)
	assert(arg0:getConfig("type") == var0.SKIN_ASSIGNED_TYPE)

	local var0 = getProxy(ShipSkinProxy)

	return underscore.all(arg0:GetValidSkinList(), function(arg0)
		return var0:hasNonLimitSkin(arg0)
	end)
end

function var0.GetOverflowCheckItems(arg0, arg1)
	arg1 = arg1 or 1

	local var0 = {}

	if arg0:getConfig("usage") == ItemUsage.DROP_TEMPLATE then
		local var1, var2, var3 = unpack(arg0:getConfig("usage_arg"))

		if var2 > 0 then
			table.insert(var0, {
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold,
				count = var2 * arg1
			})
		end

		if var3 > 0 then
			table.insert(var0, {
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResOil,
				count = var3 * arg1
			})
		end
	end

	switch(arg0:getConfig("type"), {
		[Item.EQUIPMENT_BOX_TYPE_5] = function()
			table.insert(var0, {
				type = DROP_TYPE_EQUIP,
				id = EQUIP_OCCUPATION_ID,
				count = arg1
			})
		end,
		[Item.EQUIPMENT_ASSIGNED_TYPE] = function()
			table.insert(var0, {
				type = DROP_TYPE_EQUIP,
				id = EQUIP_OCCUPATION_ID,
				count = arg1
			})
		end
	})
	underscore.map(var0, function(arg0)
		return Drop.New(arg0)
	end)

	return var0
end

function var0.IsSkinShopDiscountType(arg0)
	return arg0:getConfig("usage") == ItemUsage.SKIN_SHOP_DISCOUNT
end

function var0.CanUseForShop(arg0, arg1)
	if arg0:IsSkinShopDiscountType() then
		local var0 = arg0:getConfig("usage_arg")

		if not var0 or type(var0) ~= "table" then
			return false
		end

		local var1 = var0[1] or {}

		return #var1 == 1 and var1[1] == 0 or table.contains(var1, arg1)
	end

	return false
end

function var0.GetConsumeForSkinShopDiscount(arg0, arg1)
	if arg0:IsSkinShopDiscountType() then
		local var0 = pg.item_data_statistics[arg0.configId].usage_arg[2] or 0
		local var1 = Goods.Create({
			shop_id = arg1
		}, Goods.TYPE_SKIN)

		return math.max(0, var1:GetPrice() - var0), var1:getConfig("resource_type")
	else
		return 0
	end
end

function var0.getName(arg0)
	return arg0.name or arg0:getConfig("name")
end

function var0.getIcon(arg0)
	return arg0:getConfig("Icon")
end

return var0
