return {
	{
		banner = "summary",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.SUMMARY
		},
		isShow = function()
			return
		end
	},
	{
		banner = "build_pray",
		event = ActivityMediator.GO_PRAY_POOL,
		data = {},
		isShow = function()
			local var0_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

			return var0_2 and not var0_2:isEnd()
		end
	},
	{
		banner = "build_bisimai",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.GETBOAT,
			{
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			}
		},
		isShow = function()
			local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILD_BISMARCK_ID)

			return var0_3 and not var0_3:isEnd()
		end
	},
	{
		banner = "ming_paint",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.COLORING
		},
		isShow = function()
			local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

			return var0_4 and not var0_4:isEnd()
		end,
		isTip = function()
			return getProxy(ColoringProxy):CheckTodayTip()
		end
	},
	{
		banner = "limit_skin",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.SKINSHOP,
			{
				mode = NewSkinShopScene.MODE_EXPERIENCE
			}
		},
		isShow = function()
			if LOCK_SKIN_US and pg.gameset.levellimit_skinentrance.key_value >= getProxy(PlayerProxy):getRawData().level then
				return false
			end

			local var0_6 = pg.activity_banner.get_id_list_by_type[GAMEUI_BANNER_12]

			return var0_6 and #var0_6 > 0 and _.any(var0_6, function(arg0_7)
				local var0_7 = pg.activity_banner[arg0_7].time

				return pg.TimeMgr.GetInstance():inTime(var0_7)
			end)
		end,
		isTip = function()
			local var0_8 = pg.gameset.skin_ticket.key_value
			local var1_8 = getProxy(PlayerProxy):getRawData():getResource(var0_8)

			if not var1_8 or not (var1_8 > 0) then
				return false
			end

			local var2_8 = getProxy(ShipSkinProxy)
			local var3_8 = var2_8:GetAllSkins()

			return _.any(var3_8, function(arg0_9)
				return arg0_9:getConfig("genre") == ShopArgs.SkinShopTimeLimit and not var2_8:hasSkin(arg0_9:getSkinId())
			end) and getProxy(SettingsProxy):ShouldTipTimeLimitSkinShop()
		end
	},
	{
		banner = "banai_shop",
		event = ActivityMediator.GO_SHOPS_LAYER,
		data = {
			{
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = ActivityConst.BISMARCK_PT_SHOP_ID
			}
		},
		isShow = function()
			local var0_10 = getProxy(ActivityProxy):getActivityById(ActivityConst.BISMARCK_PT_SHOP_ID)

			return var0_10 and not var0_10:isEnd()
		end
	},
	{
		banner = "bili_shop",
		event = ActivityMediator.GO_SHOPS_LAYER,
		data = {
			{
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = ActivityConst.BILIBILI_PT_SHOP_ID
			}
		},
		isShow = function()
			local var0_11 = getProxy(ActivityProxy):getActivityById(ActivityConst.BILIBILI_PT_SHOP_ID)

			return var0_11 and not var0_11:isEnd()
		end
	},
	{},
	{
		banner = "commom_build",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.GETBOAT,
			{
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			}
		},
		isShow = function()
			local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.FRANCE_RE_BUILD)

			return var0_12 and not var0_12:isEnd()
		end
	},
	{
		banner = "commom_pt_shop",
		event = ActivityMediator.GO_SHOPS_LAYER,
		data = {
			{
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = ActivityConst.FRANCE_RE_PT_SHOP
			}
		},
		isShow = function()
			local var0_13 = getProxy(ActivityProxy):getActivityById(ActivityConst.FRANCE_RE_PT_SHOP)

			return var0_13 and not var0_13:isEnd()
		end
	},
	{
		banner = "commom_skin_shop",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.SKINSHOP
		},
		isShow = function()
			return pg.TimeMgr.GetInstance():inTime({
				{
					{
						2019,
						6,
						27
					},
					{
						0,
						0,
						0
					}
				},
				{
					{
						2019,
						7,
						10
					},
					{
						23,
						59,
						59
					}
				}
			})
		end
	},
	{
		banner = "summer_feast",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.SUMMER_FEAST
		},
		isShow = function()
			local var0_15 = getProxy(ActivityProxy):getActivityById(ActivityConst.SUMMER_FEAST_ID)

			return var0_15 and not var0_15:isEnd()
		end
	},
	{
		banner = "event_square",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.NEWYEAR_SQUARE
		},
		isShow = function()
			local var0_16 = getProxy(ActivityProxy):getActivityById(ActivityConst.NEWYEAR_ACTIVITY)

			return var0_16 and not var0_16:isEnd()
		end
	},
	{
		banner = "LanternFestival",
		event = ActivityMediator.GO_MINI_GAME,
		data = setmetatable({}, {
			__index = function(arg0_17, arg1_17)
				if arg1_17 == 1 then
					local var0_17 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

					if var0_17 and not var0_17:isEnd() then
						arg0_17[arg1_17] = var0_17:getConfig("config_client").miniGame

						return arg0_17[arg1_17]
					end
				end

				return nil
			end
		}),
		isShow = function()
			local var0_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

			return var0_18 and not var0_18:isEnd()
		end,
		isTip = function()
			local var0_19 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

			if var0_19 and not var0_19:isEnd() then
				local var1_19 = getProxy(MiniGameProxy):GetHubByHubId(var0_19:getConfig("config_id"))

				return var1_19.count > 0 and var1_19.usedtime < 7
			end
		end
	},
	{
		banner = "encode_game",
		event = ActivityMediator.GO_DECODE_MINI_GAME,
		data = {
			11
		},
		isShow = function()
			local var0_20 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
			local var1_20 = _.detect(var0_20, function(arg0_21)
				return arg0_21:getConfig("config_id") == 7
			end)

			return var1_20 and not var1_20:isEnd()
		end,
		isTip = function()
			local var0_22 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
			local var1_22 = _.detect(var0_22, function(arg0_23)
				return arg0_23:getConfig("config_id") == 7
			end)

			if var1_22 and not var1_22:isEnd() then
				local var2_22 = getProxy(MiniGameProxy):GetHubByHubId(var1_22:getConfig("config_id"))

				return var2_22 and var2_22.id == 7 and var2_22.count > 0
			end
		end
	},
	{
		banner = "air_fight",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.AIRFORCE_DRAGONEMPERY
		},
		isShow = function()
			do return false end

			local var0_24 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

			return var0_24 and not var0_24:isEnd()
		end,
		isTip = function()
			local var0_25 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

			if var0_25 and not var0_25:isEnd() then
				return var0_25:readyToAchieve()
			end
		end
	},
	{
		banner = "doa_medal",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.DOA2_MEDAL_COLLECTION_SCENE
		},
		isShow = function()
			local var0_26 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

			return var0_26 and not var0_26:isEnd()
		end,
		isTip = function()
			local var0_27 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

			return Activity.IsActivityReady(var0_27)
		end
	},
	{
		banner = "meta_entrance_970708",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.METACHARACTER,
			{
				autoOpenShipConfigID = 9707081
			}
		},
		isShow = function()
			local var0_28 = 970708
			local var1_28 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0_28)

			return var1_28 and var1_28:isInAct()
		end,
		isTip = function()
			local var0_29 = 970708
			local var1_29 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0_29)

			if var1_29:isPassType() then
				return false
			end

			if not var1_29:isShow() then
				return false
			end

			local var2_29 = false

			if var1_29.metaPtData then
				var2_29 = var1_29.metaPtData:CanGetAward()
			end

			if var2_29 == false then
				var2_29 = getProxy(MetaCharacterProxy):getRedTag(var0_29)
			end

			return var2_29
		end
	},
	{
		banner = "activity_permanent",
		event = ActivityMediator.ACTIVITY_PERMANENT,
		data = {},
		isShow = function()
			return not LOCK_PERMANENT_ENTER
		end,
		isTip = function()
			return PlayerPrefs.GetString("permanent_time", "") ~= pg.gameset.permanent_mark.description
		end
	},
	{
		banner = "activity_miniprogram",
		event = ActivityMediator.OPEN_MINI_PROGRAM,
		data = {},
		isShow = function()
			return PLATFORM_CODE == PLATFORM_CH and (PermissionHelper.IsAndroid and LuaHelper.GetCHPackageType() == 1 or PermissionHelper.IsIOS()) and getProxy(ActivityProxy):IsActivityNotEnd(getGameset("WeChat_Mini_Program")[1])
		end,
		isTip = function()
			return false
		end
	},
	{
		banner = "doa_medal",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.OTHERWORLD_BACKHILL
		},
		isShow = function()
			local var0_34 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID)

			return var0_34 and not var0_34:isEnd()
		end,
		isTip = function()
			local var0_35 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID)

			return Activity.IsActivityReady(var0_35)
		end
	}
}
