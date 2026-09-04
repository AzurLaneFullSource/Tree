return {
	{
		banner = "summary",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.SUMMARY
		},
		isShow = function()
			local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

			return var0_1 and not var0_1:isEnd()
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
		banner = "activity_boss",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.ACT_BOSS_BATTLE,
			{
				showAni = true
			}
		},
		isShow = function()
			local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

			return var0_4 and not var0_4:isEnd()
		end,
		isTip = function()
			local var0_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

			if not var0_5 then
				return
			end

			local var1_5 = false

			if var0_5:checkBattleTimeInBossAct() then
				var1_5 = var0_5.data2 ~= 1
			else
				local var2_5 = var0_5:GetBindPtActID()
				local var3_5 = getProxy(ActivityProxy):getActivityById(var2_5)

				if var3_5 then
					var1_5 = ActivityBossPtData.New(var3_5):CanGetAward()
				end
			end

			return var1_5
		end
	},
	{
		banner = "ming_paint",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.COLORING
		},
		isShow = function()
			local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

			return var0_6 and not var0_6:isEnd()
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

			local var0_8 = pg.activity_banner.get_id_list_by_type[GAMEUI_BANNER_12]

			return var0_8 and #var0_8 > 0 and _.any(var0_8, function(arg0_9)
				local var0_9 = pg.activity_banner[arg0_9].time

				return pg.TimeMgr.GetInstance():inTime(var0_9)
			end)
		end,
		isTip = function()
			local var0_10 = pg.gameset.skin_ticket.key_value
			local var1_10 = getProxy(PlayerProxy):getRawData():getResource(var0_10)

			if not var1_10 or not (var1_10 > 0) then
				return false
			end

			local var2_10 = getProxy(ShipSkinProxy)
			local var3_10 = var2_10:GetAllSkins()

			return _.any(var3_10, function(arg0_11)
				return arg0_11:getConfig("genre") == ShopArgs.SkinShopTimeLimit and not var2_10:hasSkin(arg0_11:getSkinId())
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
			local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.BISMARCK_PT_SHOP_ID)

			return var0_12 and not var0_12:isEnd()
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
			local var0_13 = getProxy(ActivityProxy):getActivityById(ActivityConst.BILIBILI_PT_SHOP_ID)

			return var0_13 and not var0_13:isEnd()
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
			local var0_14 = getProxy(ActivityProxy):getActivityById(ActivityConst.FRANCE_RE_BUILD)

			return var0_14 and not var0_14:isEnd()
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
			local var0_15 = getProxy(ActivityProxy):getActivityById(ActivityConst.FRANCE_RE_PT_SHOP)

			return var0_15 and not var0_15:isEnd()
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
			local var0_17 = getProxy(ActivityProxy):getActivityById(ActivityConst.SUMMER_FEAST_ID)

			return var0_17 and not var0_17:isEnd()
		end
	},
	{
		banner = "event_square",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.NEWYEAR_SQUARE
		},
		isShow = function()
			local var0_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.NEWYEAR_ACTIVITY)

			return var0_18 and not var0_18:isEnd()
		end
	},
	{
		banner = "LanternFestival",
		event = ActivityMediator.GO_MINI_GAME,
		data = setmetatable({}, {
			__index = function(arg0_19, arg1_19)
				if arg1_19 == 1 then
					local var0_19 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

					if var0_19 and not var0_19:isEnd() then
						arg0_19[arg1_19] = var0_19:getConfig("config_client").miniGame

						return arg0_19[arg1_19]
					end
				end

				return nil
			end
		}),
		isShow = function()
			local var0_20 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

			return var0_20 and not var0_20:isEnd()
		end,
		isTip = function()
			local var0_21 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

			if var0_21 and not var0_21:isEnd() then
				local var1_21 = getProxy(MiniGameProxy):GetHubByHubId(var0_21:getConfig("config_id"))

				return var1_21.count > 0 and var1_21.usedtime < 7
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
			local var0_22 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
			local var1_22 = _.detect(var0_22, function(arg0_23)
				return arg0_23:getConfig("config_id") == 7
			end)

			return var1_22 and not var1_22:isEnd()
		end,
		isTip = function()
			local var0_24 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
			local var1_24 = _.detect(var0_24, function(arg0_25)
				return arg0_25:getConfig("config_id") == 7
			end)

			if var1_24 and not var1_24:isEnd() then
				local var2_24 = getProxy(MiniGameProxy):GetHubByHubId(var1_24:getConfig("config_id"))

				return var2_24 and var2_24.id == 7 and var2_24.count > 0
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

			local var0_26 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

			return var0_26 and not var0_26:isEnd()
		end,
		isTip = function()
			local var0_27 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

			if var0_27 and not var0_27:isEnd() then
				return var0_27:readyToAchieve()
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
			local var0_28 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

			return var0_28 and not var0_28:isEnd()
		end,
		isTip = function()
			local var0_29 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

			return Activity.IsActivityReady(var0_29)
		end
	},
	{
		banner = "meta_entrance_970710",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.METACHARACTER,
			{
				autoOpenShipConfigID = 9707101
			}
		},
		isShow = function()
			local var0_30 = 970710
			local var1_30 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0_30)

			return var1_30 and var1_30:isInAct()
		end,
		isTip = function()
			local var0_31 = 970710
			local var1_31 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0_31)

			if var1_31:isPassType() then
				return false
			end

			if not var1_31:isShow() then
				return false
			end

			local var2_31 = false

			if var1_31.metaPtData then
				var2_31 = var1_31.metaPtData:CanGetAward()
			end

			if var2_31 == false then
				var2_31 = getProxy(MetaCharacterProxy):getRedTag(var0_31)
			end

			return var2_31
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
			local var0_36 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID)

			return var0_36 and not var0_36:isEnd()
		end,
		isTip = function()
			local var0_37 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID)

			return Activity.IsActivityReady(var0_37)
		end
	},
	{
		banner = "cultivating_plant",
		event = ActivityMediator.OPEN_CULTIVATING_PLANT,
		data = {},
		isShow = function()
			local var0_38 = getProxy(ActivityProxy):getActivityById(ActivityConst.CULTIVATING_PLANT_ID)

			return var0_38 and not var0_38:isEnd()
		end,
		isTip = function()
			return CultivatingPlantTools.NeedShowRedPoint()
		end
	},
	{
		banner = "activity_escapemanor",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.ACTIVITY,
			{
				id = 51073
			}
		},
		isShow = function()
			local var0_40 = getProxy(ActivityProxy):getActivityById(51073)

			return var0_40 and not var0_40:isEnd()
		end,
		isTip = function()
			local var0_41 = getProxy(ActivityProxy):getActivityById(51073)

			return Activity.IsActivityReady(var0_41)
		end
	},
	{
		banner = "activity_auction",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.ACTIVITY,
			{
				id = 970002
			}
		},
		isShow = function()
			local var0_42 = getProxy(ActivityProxy):getActivityById(970002)

			return var0_42 and not var0_42:isEnd()
		end,
		isTip = function()
			local var0_43 = getProxy(ActivityProxy):getActivityById(970002)
			local var1_43 = getProxy(ActivityProxy):getActivityById(970003)

			return Activity.IsActivityReady(var0_43) or Activity.IsActivityReady(var1_43)
		end
	}
}
