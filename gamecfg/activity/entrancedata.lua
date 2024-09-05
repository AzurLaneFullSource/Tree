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
		banner = "activity_redpacket",
		event = ActivityMediator.OPEN_RED_PACKET_LAYER,
		data = {},
		isShow = function()
			local var0_19 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

			return var0_19 and not var0_19:isEnd()
		end,
		isTip = function()
			return RedPacketLayer.isShowRedPoint()
		end
	},
	{
		banner = "LanternFestival",
		event = ActivityMediator.GO_MINI_GAME,
		data = {
			MainLanternFestivalBtn.LANTERNFESTIVAL_MINIGAME_ID
		},
		isShow = function()
			local var0_21 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

			return var0_21 and not var0_21:isEnd()
		end,
		isTip = function()
			local var0_22 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

			if var0_22 and not var0_22:isEnd() then
				local var1_22 = getProxy(MiniGameProxy):GetHubByHubId(var0_22:getConfig("config_id"))

				return var1_22.count > 0 and var1_22.usedtime < 7
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
			local var0_23 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
			local var1_23 = _.detect(var0_23, function(arg0_24)
				return arg0_24:getConfig("config_id") == 7
			end)

			return var1_23 and not var1_23:isEnd()
		end,
		isTip = function()
			local var0_25 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
			local var1_25 = _.detect(var0_25, function(arg0_26)
				return arg0_26:getConfig("config_id") == 7
			end)

			if var1_25 and not var1_25:isEnd() then
				local var2_25 = getProxy(MiniGameProxy):GetHubByHubId(var1_25:getConfig("config_id"))

				return var2_25 and var2_25.id == 7 and var2_25.count > 0
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
			local var0_27 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

			return var0_27 and not var0_27:isEnd()
		end,
		isTip = function()
			local var0_28 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

			if var0_28 and not var0_28:isEnd() then
				local var1_28 = 0
				local var2_28 = var0_28:getConfig("config_client")[1]

				for iter0_28 = 1, var2_28 do
					var1_28 = var1_28 + (var0_28:getKVPList(1, iter0_28) or 0)
				end

				local var3_28 = pg.TimeMgr.GetInstance()
				local var4_28 = var3_28:DiffDay(var0_28.data1, var3_28:GetServerTime()) + 1

				return var1_28 < math.min(var4_28 * 2, var2_28 * 3)
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
			local var0_29 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

			return var0_29 and not var0_29:isEnd()
		end,
		isTip = function()
			local var0_30 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

			return Activity.IsActivityReady(var0_30)
		end
	},
	{
		banner = "meta_entrance_970506",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.METACHARACTER,
			{
				autoOpenShipConfigID = 9705061
			}
		},
		isShow = function()
			local var0_31 = 970506
			local var1_31 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0_31)

			return var1_31 and var1_31:isInAct()
		end,
		isTip = function()
			local var0_32 = 970506
			local var1_32 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0_32)

			if var1_32:isPassType() then
				return false
			end

			if not var1_32:isShow() then
				return false
			end

			local var2_32 = false

			if var1_32.metaPtData then
				var2_32 = var1_32.metaPtData:CanGetAward()
			end

			if var2_32 == false then
				var2_32 = getProxy(MetaCharacterProxy):getRedTag(var0_32)
			end

			return var2_32
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
	}
}
