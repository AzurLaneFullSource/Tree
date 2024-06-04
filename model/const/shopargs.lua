local var0 = class("ShopArgs")

var0.EffecetEquipBagSize = "equip_bag_size"
var0.EffecetShipBagSize = "ship_bag_size"
var0.EffectDromExpPos = "dorm_exp_pos"
var0.EffectDromFixPos = "dorm_fix_pos"
var0.EffectDromFoodMax = "dorm_food_max"
var0.EffectShopStreetFlash = "shop_street_flash"
var0.EffectShopStreetLevel = "shop_street_level"
var0.EffectOilFieldLevel = "oilfield_level"
var0.EffectTradingPortLevel = "tradingport_level"
var0.EffectClassLevel = "class_room_level"
var0.EffectGuildFlash = "guild_store_flash"
var0.EffectDormFloor = "dorm_floor"
var0.EffectSkillPos = "skill_room_pos"
var0.EffectCommanderBagSize = "commander_bag_size"
var0.EffectSpWeaponBagSize = "spweapon_bag_size"
var0.ShoppingStreetUpgrade = "shop_street_upgrade"
var0.BackyardFoodExtend = "backyard_food_extend"
var0.BuyOil = "buy_oil"
var0.ShoppingStreetLimit = "shopping_street"
var0.ArenaShopLimit = "arena_shop"
var0.GiftPackage = "gift_package"
var0.GenShop = "gem_shop"
var0.SkinShop = "skin_shop"
var0.ActivityShop = "activity_shop"
var0.guildShop = "guild_store"
var0.guildShopFlash = "guild_shop_flash"
var0.skillRoomUpgrade = "skill_room_upgrade"
var0.SkinShopTimeLimit = "skin_shop_timelimit"
var0.WorldShop = "world"
var0.WorldCollection = "world_collection_task"
var0.NewServerShop = "new_server_shop"
var0.ShopStreet = 1
var0.MilitaryShop = 2
var0.ShopActivity = 3
var0.ShopGUILD = 4
var0.ShopShamBattle = 5
var0.ShopEscort = 6
var0.ShopFragment = 7
var0.ShopMedal = 8
var0.ShopMiniGame = 9
var0.ShopQuota = 10
var0.DORM_FLOOR_ID = 19
var0.LIMIT_ARGS_META_SHIP_EXISTENCE = 1
var0.LIMIT_ARGS_SALE_START_TIME = 2
var0.LIMIT_ARGS_TRAN_ITEM_WHEN_FULL = 3

function var0.getOilByLevel(arg0)
	return 500 + arg0 * 3
end

return var0
