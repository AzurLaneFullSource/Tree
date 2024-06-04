local var0 = class("Goods", import(".BaseVO"))

var0.TYPE_SHOPSTREET = 1
var0.TYPE_MILITARY = 2
var0.TYPE_CHARGE = 3
var0.TYPE_GIFT_PACKAGE = 4
var0.TYPE_SKIN = 6
var0.TYPE_ACTIVITY = 7
var0.TYPE_ACTIVITY_EXTRA = 8
var0.TYPE_GUILD = 9
var0.TYPE_SHAM_BATTLE = 10
var0.TYPE_ESCORT = 11
var0.TYPE_FRAGMENT = 12
var0.TYPE_WORLD = 13
var0.TYPE_FRAGMENT_NORMAL = 14
var0.TYPE_NEW_SERVER = 15
var0.TYPE_MINI_GAME = 16
var0.TYPE_QUOTA = 17
var0.TYPE_WORLD_NSHOP = 18
var0.GEM = 0
var0.GIFT_BOX = 1
var0.MONTH_CARD = 2
var0.ITEM_BOX = 3
var0.PASS_ITEM = 4
var0.EQUIP_BAG_SIZE_ITEM = 59100
var0.SHIP_BAG_SIZE_ITEM = 59101
var0.COMMANDER_BAG_SIZE_ITEM = 59114
var0.SPWEAPON_BAG_SIZE_ITEM = 59360
var0.Tec_Ship_Gift_Type = 3
var0.Tec_Ship_Gift_Arg = {
	High = 1,
	Up = 3,
	Show = 0,
	Normal = 2
}
var0.CUR_PACKET_ID = 138

function var0.Ctor(arg0)
	assert(false, "does not call this function, use Create instead")
end

local var1 = {
	[var0.TYPE_CHARGE] = function(arg0, arg1)
		return ChargeCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_ACTIVITY] = function(arg0, arg1)
		return ActivityCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_SHAM_BATTLE] = function(arg0, arg1)
		return ActivityCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_FRAGMENT] = function(arg0, arg1)
		return ActivityCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_FRAGMENT_NORMAL] = function(arg0, arg1)
		return ActivityCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_ESCORT] = function(arg0, arg1)
		return ActivityCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_ACTIVITY_EXTRA] = function(arg0, arg1)
		return ActivityExtraCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_MINI_GAME] = function(arg0, arg1)
		return MiniGameGoods.New(arg0, arg1)
	end,
	[var0.TYPE_QUOTA] = function(arg0, arg1)
		return QuotaCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_ESCORT] = function(arg0, arg1)
		return ActivityCommodity.New(arg0, arg1)
	end,
	[var0.TYPE_WORLD_NSHOP] = function(arg0, arg1)
		return WorldNShopCommodity.New(arg0, arg1)
	end
}

function var0.Create(arg0, arg1)
	return switch(arg1, var1, function(arg0, arg1)
		return CommonCommodity.New(arg0, arg1)
	end, arg0, arg1)
end

function var0.ExistFurniture(arg0)
	return pg.shop_furniture_relation[arg0] ~= nil
end

function var0.Id2FurnitureId(arg0)
	return pg.shop_furniture_relation[arg0].fur_id
end

function var0.FurnitureId2Id(arg0)
	local var0 = pg.shop_furniture_relation.get_id_list_by_fur_id[arg0]

	return var0 and var0[1]
end

function var0.GetFurnitureConfig(arg0)
	return pg.shop_furniture_relation[arg0]
end

function var0.Id2ShipSkinId(arg0)
	return pg.shop_template[arg0].effect_args[1]
end

return var0
