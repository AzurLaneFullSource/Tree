local var0_0 = {}

ChargeScene.TYPE_DIAMOND = 1
ChargeScene.TYPE_GIFT = 2
ChargeScene.TYPE_ITEM = 3
ChargeScene.TYPE_PICK = 4
var0_0.CATEGORY_ACTIVITY = 1
var0_0.CATEGORY_MONTH = 2
var0_0.CATEGORY_SUPPLY = 3
var0_0.SHOP_TYPE = {
	SUPPLY = "supply",
	CHARGE = "charge",
	SKIN = "skin"
}
var0_0.SHOP_ID = {
	GIFT = 2,
	ACTIVITY = 7,
	DIAMOND = 1,
	ITEM = 3,
	SUPPLY = 6,
	PICK = 4,
	MONTH = 5
}
var0_0.SHOP_LIST = {
	[var0_0.SHOP_TYPE.CHARGE] = {
		[ChargeScene.TYPE_DIAMOND] = 1,
		[ChargeScene.TYPE_GIFT] = 2,
		[ChargeScene.TYPE_ITEM] = 3,
		[ChargeScene.TYPE_PICK] = 4
	},
	[var0_0.SHOP_TYPE.SUPPLY] = {
		[var0_0.CATEGORY_MONTH] = 5,
		[var0_0.CATEGORY_SUPPLY] = 6,
		[var0_0.CATEGORY_ACTIVITY] = 7
	}
}
var0_0.TYPE_ACTIVITY = 1
var0_0.TYPE_SHOP_STREET = 2
var0_0.TYPE_MILITARY_SHOP = 3
var0_0.TYPE_QUOTA = 4
var0_0.TYPE_SHAM_SHOP = 5
var0_0.TYPE_FRAGMENT = 6
var0_0.TYPE_GUILD = 7
var0_0.TYPE_MEDAL = 8
var0_0.TYPE_META = 9
var0_0.TYPE_MINI_GAME = 10
var0_0.SUPPLY_SHOP_LIST = {
	[var0_0.CATEGORY_MONTH] = {
		var0_0.TYPE_QUOTA,
		var0_0.TYPE_SHAM_SHOP,
		var0_0.TYPE_MEDAL,
		var0_0.TYPE_FRAGMENT
	},
	[var0_0.CATEGORY_SUPPLY] = {
		var0_0.TYPE_SHOP_STREET,
		var0_0.TYPE_MILITARY_SHOP,
		var0_0.TYPE_GUILD,
		var0_0.TYPE_META,
		var0_0.TYPE_MINI_GAME
	},
	[var0_0.CATEGORY_ACTIVITY] = {
		var0_0.TYPE_ACTIVITY
	}
}
var0_0.SHOP_NAME_LIST = {
	activity = {
		var0_0.CATEGORY_ACTIVITY
	},
	shopstreet = {
		var0_0.CATEGORY_SUPPLY,
		var0_0.TYPE_SHOP_STREET
	},
	supplies = {
		var0_0.CATEGORY_SUPPLY,
		var0_0.TYPE_MILITARY_SHOP
	},
	guild = {
		var0_0.CATEGORY_SUPPLY,
		var0_0.TYPE_GUILD
	},
	meta = {
		var0_0.CATEGORY_SUPPLY,
		var0_0.TYPE_META
	},
	minigame = {
		var0_0.CATEGORY_SUPPLY,
		var0_0.TYPE_MINI_GAME
	},
	quota = {
		var0_0.CATEGORY_MONTH,
		var0_0.TYPE_QUOTA
	},
	sham = {
		var0_0.CATEGORY_MONTH,
		var0_0.TYPE_SHAM_SHOP
	},
	medal = {
		var0_0.CATEGORY_MONTH,
		var0_0.TYPE_MEDAL
	},
	fragment = {
		var0_0.CATEGORY_MONTH,
		var0_0.TYPE_FRAGMENT
	}
}
var0_0.TYPE2NAME = {
	[var0_0.TYPE_ACTIVITY] = "activity_shop_title",
	[var0_0.TYPE_SHOP_STREET] = "street_shop_title",
	[var0_0.TYPE_MILITARY_SHOP] = "military_shop_title",
	[var0_0.TYPE_QUOTA] = "quota_shop_title1",
	[var0_0.TYPE_SHAM_SHOP] = "sham_shop_title",
	[var0_0.TYPE_FRAGMENT] = "fragment_shop_title",
	[var0_0.TYPE_GUILD] = "guild_shop_title",
	[var0_0.TYPE_MEDAL] = "medal_shop_title",
	[var0_0.TYPE_META] = "meta_shop_title",
	[var0_0.TYPE_MINI_GAME] = "mini_game_shop_title"
}
var0_0.NEW_SKIN_SHOP_ID = 1
var0_0.PERMANANT_SKIN_SHOP_ID = 2

return var0_0
