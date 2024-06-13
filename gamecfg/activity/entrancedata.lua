return {
	{
		banner = "summary",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.SUMMARY
		},
		isShow = function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

			return var0 and not var0:isEnd()
		end
	},
	{
		banner = "build_pray",
		event = ActivityMediator.GO_PRAY_POOL,
		data = {},
		isShow = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

			return var0 and not var0:isEnd()
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
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.BUILD_BISMARCK_ID)

			return var0 and not var0:isEnd()
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
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

			return var0 and not var0:isEnd()
		end,
		isTip = function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

			if not var0 then
				return
			end

			local var1 = false

			if var0:checkBattleTimeInBossAct() then
				var1 = var0.data2 ~= 1
			else
				local var2 = var0:GetBindPtActID()
				local var3 = getProxy(ActivityProxy):getActivityById(var2)

				if var3 then
					var1 = ActivityBossPtData.New(var3):CanGetAward()
				end
			end

			return var1
		end
	},
	{
		banner = "ming_paint",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.COLORING
		},
		isShow = function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

			return var0 and not var0:isEnd()
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
			local var0 = pg.activity_banner.get_id_list_by_type[GAMEUI_BANNER_12]

			return var0 and #var0 > 0 and _.any(var0, function(arg0)
				local var0 = pg.activity_banner[arg0].time

				return pg.TimeMgr.GetInstance():inTime(var0)
			end)
		end,
		isTip = function()
			local var0 = pg.gameset.skin_ticket.key_value
			local var1 = getProxy(PlayerProxy):getRawData():getResource(var0)

			if not var1 or not (var1 > 0) then
				return false
			end

			local var2 = getProxy(ShipSkinProxy)
			local var3 = var2:GetAllSkins()

			return _.any(var3, function(arg0)
				return arg0:getConfig("genre") == ShopArgs.SkinShopTimeLimit and not var2:hasSkin(arg0:getSkinId())
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
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.BISMARCK_PT_SHOP_ID)

			return var0 and not var0:isEnd()
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
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.BILIBILI_PT_SHOP_ID)

			return var0 and not var0:isEnd()
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
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FRANCE_RE_BUILD)

			return var0 and not var0:isEnd()
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
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.FRANCE_RE_PT_SHOP)

			return var0 and not var0:isEnd()
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
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SUMMER_FEAST_ID)

			return var0 and not var0:isEnd()
		end
	},
	{
		banner = "event_square",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.NEWYEAR_SQUARE
		},
		isShow = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.NEWYEAR_ACTIVITY)

			return var0 and not var0:isEnd()
		end
	},
	{
		banner = "activity_redpacket",
		event = ActivityMediator.OPEN_RED_PACKET_LAYER,
		data = {},
		isShow = function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_RED_PACKETS)

			return var0 and not var0:isEnd()
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
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

			return var0 and not var0:isEnd()
		end,
		isTip = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

			if var0 and not var0:isEnd() then
				local var1 = getProxy(MiniGameProxy):GetHubByHubId(var0:getConfig("config_id"))

				return var1.count > 0 and var1.usedtime < 7
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
			local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
			local var1 = _.detect(var0, function(arg0)
				return arg0:getConfig("config_id") == 7
			end)

			return var1 and not var1:isEnd()
		end,
		isTip = function()
			local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)
			local var1 = _.detect(var0, function(arg0)
				return arg0:getConfig("config_id") == 7
			end)

			if var1 and not var1:isEnd() then
				local var2 = getProxy(MiniGameProxy):GetHubByHubId(var1:getConfig("config_id"))

				return var2 and var2.id == 7 and var2.count > 0
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
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

			return var0 and not var0:isEnd()
		end,
		isTip = function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE)

			if var0 and not var0:isEnd() then
				local var1 = 0
				local var2 = var0:getConfig("config_client")[1]

				for iter0 = 1, var2 do
					var1 = var1 + (var0:getKVPList(1, iter0) or 0)
				end

				local var3 = pg.TimeMgr.GetInstance()
				local var4 = var3:DiffDay(var0.data1, var3:GetServerTime()) + 1

				return var1 < math.min(var4 * 2, var2 * 3)
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
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

			return var0 and not var0:isEnd()
		end,
		isTip = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

			return Activity.IsActivityReady(var0)
		end
	},
	{
		banner = "meta_entrance_970304",
		event = ActivityMediator.EVENT_GO_SCENE,
		data = {
			SCENE.METACHARACTER,
			{
				autoOpenShipConfigID = 9703041
			}
		},
		isShow = function()
			local var0 = 970304
			local var1 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0)

			return var1 and var1:isInAct()
		end,
		isTip = function()
			local var0 = 970304
			local var1 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0)

			if var1:isPassType() then
				return false
			end

			if not var1:isShow() then
				return false
			end

			local var2 = false

			if var1.metaPtData then
				var2 = var1.metaPtData:CanGetAward()
			end

			if var2 == false then
				var2 = getProxy(MetaCharacterProxy):getRedTag(var0)
			end

			return var2
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
