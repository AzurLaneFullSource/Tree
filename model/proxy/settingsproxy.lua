local var0 = class("SettingsProxy", pm.Proxy)

function var0.onRegister(arg0)
	arg0._isBgmEnble = PlayerPrefs.GetInt("ShipSkinBGM", 1) > 0
	arg0._ShowBg = PlayerPrefs.GetInt("disableBG", 1) > 0
	arg0._ShowLive2d = PlayerPrefs.GetInt("disableLive2d", 1) > 0
	arg0._selectedShipId = PlayerPrefs.GetInt("playerShipId")
	arg0._backyardFoodRemind = PlayerPrefs.GetString("backyardRemind")
	arg0._userAgreement = PlayerPrefs.GetInt("userAgreement", 0)
	arg0._showMaxLevelHelp = PlayerPrefs.GetInt("maxLevelHelp", 0) > 0
	arg0._nextTipAutoBattleTime = PlayerPrefs.GetInt("AutoBattleTip", 0)
	arg0._setFlagShip = PlayerPrefs.GetInt("setFlagShip", 0) > 0
	arg0._setFlagShipForSkinAtlas = PlayerPrefs.GetInt("setFlagShipforskinatlas", 0) > 0
	arg0._screenRatio = PlayerPrefs.GetFloat("SetScreenRatio", ADAPT_TARGET)
	arg0.storyAutoPlayCode = PlayerPrefs.GetInt("story_autoplay_flag", 0)
	NotchAdapt.CheckNotchRatio = arg0._screenRatio
	arg0._nextTipActBossTime = PlayerPrefs.GetInt("ActBossTipLastTime", 0)

	if GetZeroTime() <= arg0._nextTipActBossTime then
		arg0.nextTipActBossExchangeTicket = PlayerPrefs.GetInt("ActBossTip", 0)
	end

	arg0:resetEquipSceneIndex()

	arg0._isShowCollectionHelp = PlayerPrefs.GetInt("collection_Help", 0) > 0
	arg0.showMainSceneWordTip = PlayerPrefs.GetInt("main_scene_word_toggle", 1) > 0
	arg0.lastRequestVersionTime = nil
	arg0.worldBossFlag = {}
	arg0.worldFlag = {}
end

function var0.SetWorldBossFlag(arg0, arg1, arg2)
	if arg0.worldBossFlag[arg1] ~= arg2 then
		arg0.worldBossFlag[arg1] = arg2

		PlayerPrefs.SetInt("worldBossFlag" .. arg1, arg2 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0.GetWorldBossFlag(arg0, arg1)
	if not arg0.worldBossFlag[arg1] then
		arg0.worldBossFlag[arg1] = PlayerPrefs.GetInt("worldBossFlag" .. arg1, 1) > 0
	end

	return arg0.worldBossFlag[arg1]
end

function var0.SetWorldFlag(arg0, arg1, arg2)
	if arg0.worldFlag[arg1] ~= arg2 then
		arg0.worldFlag[arg1] = arg2

		PlayerPrefs.SetInt("world_flag_" .. arg1, arg2 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0.GetWorldFlag(arg0, arg1)
	if not arg0.worldFlag[arg1] then
		arg0.worldFlag[arg1] = PlayerPrefs.GetInt("world_flag_" .. arg1, 0) > 0
	end

	return arg0.worldFlag[arg1]
end

function var0.GetDockYardLockBtnFlag(arg0)
	if not arg0.dockYardLockFlag then
		local var0 = getProxy(PlayerProxy):getRawData().id

		arg0.dockYardLockFlag = PlayerPrefs.GetInt("DockYardLockFlag" .. var0, 0) > 0
	end

	return arg0.dockYardLockFlag
end

function var0.SetDockYardLockBtnFlag(arg0, arg1)
	if arg0.dockYardLockFlag ~= arg1 then
		local var0 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("DockYardLockFlag" .. var0, arg1 and 1 or 0)
		PlayerPrefs.Save()

		arg0.dockYardLockFlag = arg1
	end
end

function var0.GetDockYardLevelBtnFlag(arg0)
	if not arg0.dockYardLevelFlag then
		local var0 = getProxy(PlayerProxy):getRawData().id

		arg0.dockYardLevelFlag = PlayerPrefs.GetInt("DockYardLevelFlag" .. var0, 0) > 0
	end

	return arg0.dockYardLevelFlag
end

function var0.SetDockYardLevelBtnFlag(arg0, arg1)
	if arg0.dockYardLevelFlag ~= arg1 then
		local var0 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("DockYardLevelFlag" .. var0, arg1 and 1 or 0)
		PlayerPrefs.Save()

		arg0.dockYardLevelFlag = arg1
	end
end

function var0.IsShowCollectionHelp(arg0)
	return arg0._isShowCollectionHelp
end

function var0.SetCollectionHelpFlag(arg0, arg1)
	if arg0._isShowCollectionHelp ~= arg1 then
		arg0._isShowCollectionHelp = arg1

		PlayerPrefs.SetInt("collection_Help", arg1 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0.IsBGMEnable(arg0)
	return arg0._isBgmEnble
end

function var0.SetBgmFlag(arg0, arg1)
	if arg0._isBgmEnble ~= arg1 then
		arg0._isBgmEnble = arg1

		PlayerPrefs.SetInt("ShipSkinBGM", arg1 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0.getSkinPosSetting(arg0, arg1)
	local var0 = arg1:GetRecordPosKey()
	local var1 = arg0:GetCurrMainUIStyleKeyForSkinShop()

	if PlayerPrefs.HasKey(var1 .. tostring(var0) .. "_scale") then
		local var2 = PlayerPrefs.GetFloat(var1 .. tostring(var0) .. "_x", 0)
		local var3 = PlayerPrefs.GetFloat(var1 .. tostring(var0) .. "_y", 0)
		local var4 = PlayerPrefs.GetFloat(var1 .. tostring(var0) .. "_scale", 1)

		return var2, var3, var4
	else
		return nil
	end
end

function var0.setSkinPosSetting(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:GetRecordPosKey()
	local var1 = arg0:GetCurrMainUIStyleKeyForSkinShop()

	PlayerPrefs.SetFloat(var1 .. tostring(var0) .. "_x", arg2)
	PlayerPrefs.SetFloat(var1 .. tostring(var0) .. "_y", arg3)
	PlayerPrefs.SetFloat(var1 .. tostring(var0) .. "_scale", arg4)
	PlayerPrefs.Save()
end

function var0.GetCurrMainUIStyleKeyForSkinShop(arg0)
	local var0 = arg0:GetMainSceneThemeStyle()

	if var0 == NewMainScene.THEME_CLASSIC then
		return ""
	else
		return var0
	end
end

function var0.resetSkinPosSetting(arg0, arg1)
	local var0 = arg1:GetRecordPosKey()

	PlayerPrefs.DeleteKey(tostring(var0) .. "_x")
	PlayerPrefs.DeleteKey(tostring(var0) .. "_y")
	PlayerPrefs.DeleteKey(tostring(var0) .. "_scale")
	PlayerPrefs.Save()
end

function var0.getCharacterSetting(arg0, arg1, arg2)
	return PlayerPrefs.GetInt(tostring(arg1) .. "_" .. arg2, 1) > 0
end

function var0.setCharacterSetting(arg0, arg1, arg2, arg3)
	PlayerPrefs.SetInt(tostring(arg1) .. "_" .. arg2, arg3 and 1 or 0)
	PlayerPrefs.Save()
end

function var0.getCurrentSecretaryIndex(arg0)
	local var0 = PlayerPrefs.GetInt("currentSecretaryIndex", 1)

	if var0 > PlayerVitaeShipsPage.GetAllUnlockSlotCnt() then
		arg0:setCurrentSecretaryIndex(1)

		return 1
	else
		return PlayerVitaeShipsPage.GetSlotIndexList()[var0]
	end
end

function var0.rotateCurrentSecretaryIndex(arg0)
	local function var0()
		return getProxy(PlayerProxy):getRawData():ExistEducateChar() and getProxy(SettingsProxy):GetFlagShipDisplayMode() ~= FlAG_SHIP_DISPLAY_ONLY_SHIP
	end

	local var1 = PlayerPrefs.GetInt("currentSecretaryIndex", 1)
	local var2 = PlayerVitaeShipsPage.GetAllUnlockSlotCnt()
	local var3 = var1 + 1

	if var2 < var3 or var3 == PlayerVitaeShipsPage.EDUCATE_CHAR_SLOT_ID and not var0() then
		var3 = 1
	end

	arg0:setCurrentSecretaryIndex(var3)
	pg.m02:sendNotification(GAME.ROTATE_PAINTING_INDEX)
end

function var0.setCurrentSecretaryIndex(arg0, arg1)
	PlayerPrefs.SetInt("currentSecretaryIndex", arg1)
	PlayerPrefs.Save()
end

function var0.SetFlagShip(arg0, arg1)
	if arg0._setFlagShip ~= arg1 then
		arg0._setFlagShip = arg1

		PlayerPrefs.SetInt("setFlagShip", arg1 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0.GetSetFlagShip(arg0)
	return arg0._setFlagShip
end

function var0.SetFlagShipForSkinAtlas(arg0, arg1)
	if arg0._setFlagShipForSkinAtlas ~= arg1 then
		arg0._setFlagShipForSkinAtlas = arg1

		PlayerPrefs.SetInt("setFlagShipforskinatlas", arg1 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0.GetSetFlagShipForSkinAtlas(arg0)
	return arg0._setFlagShipForSkinAtlas
end

function var0.CheckNeedUserAgreement(arg0)
	if PLATFORM_CODE == PLATFORM_KR then
		return false
	elseif PLATFORM_CODE == PLATFORM_CH then
		return false
	else
		return arg0:GetUserAgreementFlag() > arg0._userAgreement
	end
end

function var0.GetUserAgreementFlag(arg0)
	local var0 = USER_AGREEMENT_FLAG_DEFAULT

	if PLATFORM_CODE == PLATFORM_CHT then
		var0 = USER_AGREEMENT_FLAG_TW
	end

	return var0
end

function var0.SetUserAgreement(arg0)
	if arg0:CheckNeedUserAgreement() then
		local var0 = arg0:GetUserAgreementFlag()

		PlayerPrefs.SetInt("userAgreement", var0)
		PlayerPrefs.Save()

		arg0._userAgreement = var0
	end
end

function var0.IsLive2dEnable(arg0)
	return arg0._ShowLive2d
end

function var0.IsBGEnable(arg0)
	return arg0._ShowBg
end

function var0.SetSelectedShipId(arg0, arg1)
	if arg0._selectedShipId ~= arg1 then
		arg0._selectedShipId = arg1

		PlayerPrefs.SetInt("playerShipId", arg1)
		PlayerPrefs.Save()
	end
end

function var0.GetSelectedShipId(arg0)
	return arg0._selectedShipId
end

function var0.setEquipSceneIndex(arg0, arg1)
	arg0._equipSceneIndex = arg1
end

function var0.getEquipSceneIndex(arg0)
	return arg0._equipSceneIndex
end

function var0.resetEquipSceneIndex(arg0)
	arg0._equipSceneIndex = StoreHouseConst.WARP_TO_MATERIAL
end

function var0.setActivityLayerIndex(arg0, arg1)
	arg0._activityLayerIndex = arg1
end

function var0.getActivityLayerIndex(arg0)
	return arg0._activityLayerIndex
end

function var0.resetActivityLayerIndex(arg0)
	arg0._activityLayerIndex = 1
end

function var0.setBackyardRemind(arg0)
	local var0 = GetZeroTime()

	if arg0._backyardFoodRemind ~= tostring(var0) then
		PlayerPrefs.SetString("backyardRemind", var0)
		PlayerPrefs.Save()

		arg0._backyardFoodRemind = var0
	end
end

function var0.getBackyardRemind(arg0)
	if not arg0._backyardFoodRemind or arg0._backyardFoodRemind == "" then
		return 0
	else
		return tonumber(arg0._backyardFoodRemind)
	end
end

function var0.getMaxLevelHelp(arg0)
	return arg0._showMaxLevelHelp
end

function var0.setMaxLevelHelp(arg0, arg1)
	if arg0._showMaxLevelHelp ~= arg1 then
		arg0._showMaxLevelHelp = arg1

		PlayerPrefs.SetInt("maxLevelHelp", arg1 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0.setStopBuildSpeedupRemind(arg0)
	arg0.isStopBuildSpeedupReamind = true
end

function var0.getStopBuildSpeedupRemind(arg0)
	return arg0.isStopBuildSpeedupReamind
end

function var0.checkReadHelp(arg0, arg1)
	if not getProxy(PlayerProxy):getData() then
		return true
	end

	if arg1 == "help_backyard" then
		return true
	elseif pg.SeriesGuideMgr.GetInstance():isEnd() then
		local var0 = PlayerPrefs.GetInt(arg1, 0)

		return PlayerPrefs.GetInt(arg1, 0) > 0
	end

	return true
end

function var0.recordReadHelp(arg0, arg1)
	PlayerPrefs.SetInt(arg1, 1)
	PlayerPrefs.Save()
end

function var0.clearAllReadHelp(arg0)
	PlayerPrefs.DeleteKey("tactics_lesson_system_introduce")
	PlayerPrefs.DeleteKey("help_shipinfo_equip")
	PlayerPrefs.DeleteKey("help_shipinfo_detail")
	PlayerPrefs.DeleteKey("help_shipinfo_intensify")
	PlayerPrefs.DeleteKey("help_shipinfo_upgrate")
	PlayerPrefs.DeleteKey("help_backyard")
	PlayerPrefs.DeleteKey("has_entered_class")
	PlayerPrefs.DeleteKey("help_commander_info")
	PlayerPrefs.DeleteKey("help_commander_play")
	PlayerPrefs.DeleteKey("help_commander_ability")
end

function var0.setAutoBattleTip(arg0)
	local var0 = GetZeroTime()

	arg0._nextTipAutoBattleTime = var0

	PlayerPrefs.SetInt("AutoBattleTip", var0)
	PlayerPrefs.Save()
end

function var0.isTipAutoBattle(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0._nextTipAutoBattleTime
end

function var0.setActBossExchangeTicketTip(arg0, arg1)
	if arg0.nextTipActBossExchangeTicket == arg1 then
		return
	end

	arg0.nextTipActBossExchangeTicket = arg1

	local var0 = GetZeroTime()

	if var0 > arg0._nextTipActBossTime then
		arg0._nextTipActBossTime = var0

		PlayerPrefs.SetInt("ActBossTipLastTime", var0)
	end

	PlayerPrefs.SetInt("ActBossTip", arg1)
	PlayerPrefs.Save()
end

function var0.isTipActBossExchangeTicket(arg0)
	if pg.TimeMgr.GetInstance():GetServerTime() > arg0._nextTipActBossTime then
		return nil
	end

	return arg0.nextTipActBossExchangeTicket
end

function var0.SetScreenRatio(arg0, arg1)
	if arg0._screenRatio ~= arg1 then
		arg0._screenRatio = arg1

		PlayerPrefs.SetFloat("SetScreenRatio", arg1)
		PlayerPrefs.Save()
	end
end

function var0.GetScreenRatio(arg0)
	return arg0._screenRatio
end

function var0.CheckLargeScreen(arg0)
	return Screen.width / Screen.height > 2
end

function var0.IsShowBeatMonseterNianCurtain(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	return pg.TimeMgr.GetInstance():GetServerTime() > tonumber(PlayerPrefs.GetString("HitMonsterNianLayer2020" .. var0.id, "0"))
end

function var0.SetBeatMonseterNianFlag(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetString("HitMonsterNianLayer2020" .. var0.id, GetZeroTime())
	PlayerPrefs.Save()
end

function var0.ShouldShowEventActHelp(arg0)
	if not arg0.actEventFlag then
		local var0 = getProxy(PlayerProxy):getRawData().id

		arg0.actEventFlag = PlayerPrefs.GetInt("event_act_help1" .. var0, 0) > 0
	end

	return not arg0.actEventFlag
end

function var0.MarkEventActHelpFlag(arg0)
	if not arg0.actEventFlag then
		arg0.actEventFlag = true

		local var0 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("event_act_help1" .. var0, 1)
		PlayerPrefs.Save()
	end
end

function var0.SetStorySpeed(arg0, arg1)
	arg0.storySpeed = arg1

	local var0

	if getProxy(PlayerProxy) then
		var0 = getProxy(PlayerProxy):getRawData().id
	else
		var0 = 1
	end

	PlayerPrefs.SetInt("story_speed_flag" .. var0, arg1)
	PlayerPrefs.Save()
end

function var0.GetStorySpeed(arg0)
	if not arg0.storySpeed then
		local var0

		if getProxy(PlayerProxy) then
			var0 = getProxy(PlayerProxy):getRawData().id
		else
			var0 = 1
		end

		arg0.storySpeed = PlayerPrefs.GetInt("story_speed_flag" .. var0, 0)
	end

	return arg0.storySpeed
end

function var0.GetStoryAutoPlayFlag(arg0)
	return arg0.storyAutoPlayCode > 0
end

function var0.SetStoryAutoPlayFlag(arg0, arg1)
	if arg0.storyAutoPlayCode ~= arg1 then
		PlayerPrefs.SetInt("story_autoplay_flag", arg1)
		PlayerPrefs.Save()

		arg0.storyAutoPlayCode = arg1
	end
end

function var0.GetPaintingDownloadPrefs(arg0)
	return PlayerPrefs.GetInt("Painting_Download_Prefs", 0)
end

function var0.SetPaintingDownloadPrefs(arg0, arg1)
	PlayerPrefs.SetInt("Painting_Download_Prefs", arg1)
end

function var0.ShouldShipMainSceneWord(arg0)
	return arg0.showMainSceneWordTip
end

function var0.SaveMainSceneWordFlag(arg0, arg1)
	if arg0.showMainSceneWordTip ~= arg1 then
		arg0.showMainSceneWordTip = arg1

		PlayerPrefs.SetInt("main_scene_word_toggle", arg1 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0.RecordFrameRate(arg0)
	if not arg0.originalFrameRate then
		arg0.originalFrameRate = Application.targetFrameRate
	end
end

function var0.RestoreFrameRate(arg0)
	if arg0.originalFrameRate then
		Application.targetFrameRate = arg0.originalFrameRate
		arg0.originalFrameRate = nil
	end
end

function var0.ResetTimeLimitSkinShopTip(arg0)
	arg0.isTipLimitSkinShop = PlayerPrefs.GetInt("tipLimitSkinShopTime_", 0) <= pg.TimeMgr.GetInstance():GetServerTime()

	if arg0.isTipLimitSkinShop then
		arg0.nextTipLimitSkinShopTime = GetZeroTime()
	end
end

function var0.ShouldTipTimeLimitSkinShop(arg0)
	return arg0.isTipLimitSkinShop
end

function var0.SetNextTipTimeLimitSkinShop(arg0)
	if arg0.isTipLimitSkinShop and arg0.nextTipLimitSkinShopTime then
		PlayerPrefs.SetInt("tipLimitSkinShopTime_", arg0.nextTipLimitSkinShopTime)
		PlayerPrefs.Save()

		arg0.nextTipLimitSkinShopTime = nil
		arg0.isTipLimitSkinShop = false
	end
end

function var0.WorldBossProgressTipFlag(arg0, arg1)
	if arg0.WorldBossProgressTipValue ~= arg1 then
		arg0.WorldBossProgressTipValue = arg1

		PlayerPrefs.SetString("_WorldBossProgressTipFlag_", arg1)
		PlayerPrefs.Save()
	end
end

function var0.GetWorldBossProgressTipFlag(arg0)
	if not arg0.WorldBossProgressTipValue then
		local var0 = pg.gameset.joint_boss_ticket.description
		local var1 = var0[1] + var0[2]
		local var2 = var0[1] .. "&" .. var1
		local var3 = PlayerPrefs.GetString("_WorldBossProgressTipFlag_", var2)

		arg0.WorldBossProgressTipValue = var3

		return var3
	else
		return arg0.WorldBossProgressTipValue
	end
end

function var0.GetWorldBossProgressTipTable(arg0)
	local var0 = arg0:GetWorldBossProgressTipFlag()

	if not var0 or var0 == "" then
		return {}
	end

	return string.split(var0, "&")
end

function var0.GetChatFlag(arg0)
	if not arg0.chatFlag then
		local var0 = {
			ChatConst.ChannelWorld,
			ChatConst.ChannelPublic,
			ChatConst.ChannelFriend
		}

		if getProxy(GuildProxy):getRawData() then
			table.insert(var0, ChatConst.ChannelGuild)
		end

		arg0.chatFlag = PlayerPrefs.GetInt("chat__setting", IndexConst.Flags2Bits(var0))
	end

	return arg0.chatFlag
end

function var0.SetChatFlag(arg0, arg1)
	if arg0.chatFlag ~= arg1 then
		arg0.chatFlag = arg1

		PlayerPrefs.SetInt("chat__setting", arg1)
		PlayerPrefs.Save()
	end
end

function var0.IsShowActivityMapSPTip()
	local var0 = getProxy(PlayerProxy):getRawData()

	return pg.TimeMgr.GetInstance():GetServerTime() > PlayerPrefs.GetInt("ActivityMapSPTip" .. var0.id, 0)
end

function var0.SetActivityMapSPTip()
	local var0 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetInt("ActivityMapSPTip" .. var0.id, GetZeroTime())
	PlayerPrefs.Save()
end

function var0.IsTipNewTheme(arg0)
	local var0 = pg.backyard_theme_template
	local var1 = var0.all[#var0.all]
	local var2 = var0[var1].ids[1]
	local var3 = pg.furniture_shop_template[var2]
	local var4 = getProxy(PlayerProxy):getRawData().id
	local var5 = PlayerPrefs.GetInt(var4 .. "IsTipNewTheme" .. var1, 0) == 0

	if var3 and var3.new == 1 and pg.TimeMgr.GetInstance():inTime(var3.time) and var5 then
		arg0.lastThemeId = var1
	else
		arg0.lastThemeId = nil
	end

	return arg0.lastThemeId ~= nil
end

function var0.UpdateNewThemeValue(arg0)
	if arg0.lastThemeId then
		local var0 = arg0.lastThemeId
		local var1 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt(var1 .. "IsTipNewTheme" .. var0, 1)
		PlayerPrefs.Save()
	end
end

function var0.GetNewGemFurnitureLocalCache(arg0)
	if not arg0.cacheGemFuruitures then
		arg0.cacheGemFuruitures = {}

		local var0 = getProxy(PlayerProxy):getRawData().id
		local var1 = PlayerPrefs.GetString(var0 .. "IsTipNewGenFurniture")

		if var1 ~= "" then
			local var2 = string.split(var1, "#")

			for iter0, iter1 in ipairs(var2) do
				arg0.cacheGemFuruitures[tonumber(iter1)] = true
			end
		end
	end

	return arg0.cacheGemFuruitures
end

function var0.IsTipNewGemFurniture(arg0)
	local var0 = arg0:GetNewGemFurnitureLocalCache()
	local var1 = getProxy(DormProxy):GetTag7Furnitures()

	if _.any(var1, function(arg0)
		return pg.furniture_shop_template[arg0].new == 1 and not var0[arg0]
	end) then
		arg0.newGemFurniture = var1
	else
		arg0.newGemFurniture = nil
	end

	return arg0.newGemFurniture ~= nil
end

function var0.UpdateNewGemFurnitureValue(arg0)
	if arg0.newGemFurniture then
		for iter0, iter1 in pairs(arg0.newGemFurniture) do
			arg0.cacheGemFuruitures[iter1] = true
		end

		local var0 = table.concat(arg0.newGemFurniture, "#")
		local var1 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString(var1 .. "IsTipNewGenFurniture", var0)
		PlayerPrefs.Save()
	end
end

function var0.GetRandomFlagShipList(arg0)
	if arg0.randomFlagShipList then
		return arg0.randomFlagShipList
	end

	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = PlayerPrefs.GetString("RandomFlagShipList" .. var0, "")
	local var2 = string.split(var1, "#")

	arg0.randomFlagShipList = _.map(var2, function(arg0)
		return tonumber(arg0)
	end)

	return arg0.randomFlagShipList
end

function var0.IsRandomFlagShip(arg0, arg1)
	if not arg0.randomFlagShipMap then
		arg0.randomFlagShipMap = {}

		for iter0, iter1 in ipairs(arg0:GetRandomFlagShipList()) do
			arg0.randomFlagShipMap[iter1] = true
		end
	end

	return arg0.randomFlagShipMap[arg1] == true
end

function var0.IsOpenRandomFlagShip(arg0)
	local var0 = arg0:GetRandomFlagShipList()
	local var1 = getProxy(BayProxy)

	return #var0 > 0 and _.any(var0, function(arg0)
		return var1:RawGetShipById(arg0) ~= nil
	end)
end

function var0.UpdateRandomFlagShipList(arg0, arg1)
	arg0.randomFlagShipMap = nil
	arg0.randomFlagShipList = arg1

	local var0 = table.concat(arg1, "#")
	local var1 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("RandomFlagShipList" .. var1, var0)
	PlayerPrefs.Save()
end

function var0.GetPrevRandomFlagShipTime(arg0)
	if arg0.prevRandomFlagShipTime then
		return arg0.prevRandomFlagShipTime
	end

	local var0 = getProxy(PlayerProxy):getRawData().id

	arg0.prevRandomFlagShipTime = PlayerPrefs.GetInt("RandomFlagShipTime" .. var0, 0)

	return arg0.prevRandomFlagShipTime
end

function var0.SetPrevRandomFlagShipTime(arg0, arg1)
	if arg0.prevRandomFlagShipTime == arg1 then
		return
	end

	arg0.prevRandomFlagShipTime = arg1

	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("RandomFlagShipTime" .. var0, arg1)
	PlayerPrefs.Save()
end

function var0.GetFlagShipDisplayMode(arg0)
	if not arg0.flagShipDisplayMode then
		local var0 = getProxy(PlayerProxy):getRawData().id

		arg0.flagShipDisplayMode = PlayerPrefs.GetInt("flag-ship-display-mode" .. var0, FlAG_SHIP_DISPLAY_ALL)
	end

	return arg0.flagShipDisplayMode
end

function var0.SetFlagShipDisplayMode(arg0, arg1)
	if arg0.flagShipDisplayMode ~= arg1 then
		arg0.flagShipDisplayMode = arg1

		local var0 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("flag-ship-display-mode" .. var0, arg1)
		PlayerPrefs.Save()
	end
end

function var0.RecordContinuousOperationAutoSubStatus(arg0, arg1)
	if arg1 then
		return
	end

	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("AutoBotCOFlag" .. var0, 1)
	PlayerPrefs.Save()
end

function var0.ResetContinuousOperationAutoSub(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id

	if PlayerPrefs.GetInt("AutoBotCOFlag" .. var0, 0) == 0 then
		return
	end

	pg.m02:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = true,
		system = SYSTEM_ACT_BOSS
	})
	PlayerPrefs.SetInt("AutoBotCOFlag" .. var0, 0)
	PlayerPrefs.Save()
end

function var0.SetWorkbenchDailyTip(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = GetZeroTime()

	PlayerPrefs.SetInt("WorkbenchDailyTip" .. var0, var1)
	PlayerPrefs.Save()
end

function var0.IsTipWorkbenchDaily(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id

	return pg.TimeMgr.GetInstance():GetServerTime() > PlayerPrefs.GetInt("WorkbenchDailyTip" .. var0, 0)
end

function var0.IsDisplayResultPainting(arg0)
	local var0 = PlayerPrefs.HasKey(BATTLERESULT_SKIP_DISPAY_PAINTING)
	local var1 = false

	if var0 then
		var1 = PlayerPrefs.GetInt(BATTLERESULT_SKIP_DISPAY_PAINTING) <= 0

		PlayerPrefs.DeleteKey(BATTLERESULT_SKIP_DISPAY_PAINTING)
		PlayerPrefs.SetInt(BATTLERESULT_DISPAY_PAINTING, var1 and 1 or 0)
		PlayerPrefs.Save()
	else
		var1 = PlayerPrefs.GetInt(BATTLERESULT_DISPAY_PAINTING, 0) >= 1
	end

	return var1
end

function var0.IsDisplayCommanderCatCustomName(arg0)
	if not arg0.customFlag then
		local var0 = getProxy(PlayerProxy):getRawData().id

		arg0.customFlag = PlayerPrefs.GetInt("DisplayCommanderCatCustomName" .. var0, 0) == 0
	end

	return arg0.customFlag
end

function var0.SetDisplayCommanderCatCustomName(arg0, arg1)
	if arg1 == arg0.customFlag then
		return
	end

	arg0.customFlag = arg1

	local var0 = arg0.customFlag and 0 or 1
	local var1 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("DisplayCommanderCatCustomName" .. var1, var0)
	PlayerPrefs.Save()
end

function var0.GetCommanderQuicklyToolRarityConfig(arg0)
	if not arg0.quicklyToolRarityConfig then
		local var0 = getProxy(PlayerProxy):getRawData().id
		local var1 = PlayerPrefs.GetString("CommanderQuicklyToolRarityConfig" .. var0, "1#1#1")
		local var2 = string.split(var1, "#")

		arg0.quicklyToolRarityConfig = _.map(var2, function(arg0)
			return tonumber(arg0) == 1
		end)
	end

	return arg0.quicklyToolRarityConfig
end

function var0.SaveCommanderQuicklyToolRarityConfig(arg0, arg1)
	local var0 = false

	for iter0, iter1 in ipairs(arg0.quicklyToolRarityConfig) do
		if arg1[iter0] ~= iter1 then
			var0 = true

			break
		end
	end

	if var0 then
		arg0.quicklyToolRarityConfig = arg1

		local var1 = _.map(arg0.quicklyToolRarityConfig, function(arg0)
			return arg0 and "1" or "0"
		end)
		local var2 = table.concat(var1, "#")
		local var3 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("CommanderQuicklyToolRarityConfig" .. var3, var2)
		PlayerPrefs.Save()
	end
end

function var0.GetCommanderLockFlagRarityConfig(arg0)
	if not arg0.lockFlagRarityConfig then
		local var0 = getProxy(PlayerProxy):getRawData().id
		local var1 = PlayerPrefs.GetString("CommanderLockFlagRarityConfig_" .. var0, "1#0#0")
		local var2 = string.split(var1, "#")

		arg0.lockFlagRarityConfig = _.map(var2, function(arg0)
			return tonumber(arg0) == 1
		end)
	end

	return arg0.lockFlagRarityConfig
end

function var0.SaveCommanderLockFlagRarityConfig(arg0, arg1)
	local var0 = false

	for iter0, iter1 in ipairs(arg0.lockFlagRarityConfig) do
		if arg1[iter0] ~= iter1 then
			var0 = true

			break
		end
	end

	if var0 then
		arg0.lockFlagRarityConfig = arg1

		local var1 = _.map(arg0.lockFlagRarityConfig, function(arg0)
			return arg0 and "1" or "0"
		end)
		local var2 = table.concat(var1, "#")
		local var3 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("CommanderLockFlagRarityConfig_" .. var3, var2)
		PlayerPrefs.Save()
	end
end

function var0.GetCommanderLockFlagTalentConfig(arg0)
	if not arg0.lockFlagTalentConfig then
		local var0 = getProxy(PlayerProxy):getRawData().id
		local var1 = PlayerPrefs.GetString("CommanderLockFlagTalentConfig" .. var0, "")
		local var2 = {}

		if var1 == "" then
			for iter0, iter1 in ipairs(CommanderCatUtil.GetAllTalentNames()) do
				var2[iter1.id] = true
			end
		else
			for iter2, iter3 in ipairs(string.split(var1, "#")) do
				local var3 = string.split(iter3, "*")

				if #var3 == 2 then
					var2[tonumber(var3[1])] = tonumber(var3[2]) == 1
				end
			end
		end

		arg0.lockFlagTalentConfig = var2
	end

	return arg0.lockFlagTalentConfig
end

function var0.SaveCommanderLockFlagTalentConfig(arg0, arg1)
	arg0.lockFlagTalentConfig = arg1

	local var0 = {}

	for iter0, iter1 in pairs(arg1) do
		table.insert(var0, iter0 .. "*" .. (iter1 and "1" or "0"))
	end

	local var1 = table.concat(var0, "#")
	local var2 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("CommanderLockFlagTalentConfig" .. var2, var1)
	PlayerPrefs.Save()
end

function var0.GetMainPaintingVariantFlag(arg0, arg1)
	if not arg0.mainPaintingVariantFlag then
		arg0.mainPaintingVariantFlag = {}
	end

	if not arg0.mainPaintingVariantFlag[arg1] then
		local var0 = getProxy(PlayerProxy):getRawData().id
		local var1 = PlayerPrefs.GetInt(arg1 .. "_mainMeshImagePainting_ex_" .. var0, 0)

		arg0.mainPaintingVariantFlag[arg1] = var1
	end

	return arg0.mainPaintingVariantFlag[arg1]
end

function var0.SwitchMainPaintingVariantFlag(arg0, arg1)
	local var0 = 1 - arg0:GetMainPaintingVariantFlag(arg1)

	arg0.mainPaintingVariantFlag[arg1] = var0

	local var1 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(arg1 .. "_mainMeshImagePainting_ex_" .. var1, var0)
	PlayerPrefs.Save()
end

function var0.IsTipDay(arg0, arg1, arg2, arg3)
	local var0 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0 .. "educate_char_" .. arg1 .. arg2 .. arg3, 0) == 1
end

function var0.RecordTipDay(arg0, arg1, arg2, arg3)
	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0 .. "educate_char_" .. arg1 .. arg2 .. arg3, 1)
	PlayerPrefs.Save()
end

function var0.UpdateEducateCharTip(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = getProxy(EducateProxy):GetSecretaryIDs()
	local var2 = {}

	for iter0, iter1 in ipairs(arg1) do
		var2[iter1] = true
	end

	for iter2, iter3 in ipairs(var1) do
		if var2[iter3] ~= true then
			PlayerPrefs.SetInt(var0 .. "educate_char_tip" .. iter3, 1)
			PlayerPrefs.Save()
		end
	end

	arg0:RefillEducateCharTipList()
end

function var0.RefillEducateCharTipList(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id

	arg0.educateCharTipList = {}

	if LOCK_EDUCATE_SYSTEM then
		return
	end

	local var1 = getProxy(EducateProxy):GetSecretaryIDs()

	for iter0, iter1 in ipairs(var1 or {}) do
		if PlayerPrefs.GetInt(var0 .. "educate_char_tip" .. iter1, 0) == 1 then
			table.insert(arg0.educateCharTipList, iter1)
		end
	end
end

function var0.ShouldEducateCharTip(arg0)
	if not arg0.educateCharTipList or #arg0.educateCharTipList == 0 then
		arg0:RefillEducateCharTipList()
	end

	return #arg0.educateCharTipList > 0
end

function var0._ShouldEducateCharTip(arg0, arg1)
	if not arg0.educateCharTipList or #arg0.educateCharTipList == 0 then
		arg0:RefillEducateCharTipList()
	end

	if table.contains(arg0.educateCharTipList, arg1) then
		return true
	end

	return false
end

function var0.ClearEducateCharTip(arg0, arg1)
	if not arg0:_ShouldEducateCharTip(arg1) then
		return false
	end

	table.removebyvalue(arg0.educateCharTipList, arg1)

	local var0 = getProxy(PlayerProxy):getRawData().id .. "educate_char_tip" .. arg1

	if PlayerPrefs.HasKey(var0) then
		PlayerPrefs.DeleteKey(var0)
		PlayerPrefs.Save()
	end

	pg.m02:sendNotification(GAME.CLEAR_EDUCATE_TIP, {
		id = arg1
	})

	return true
end

function var0.GetMainSceneThemeStyle(arg0)
	if PlayerPrefs.GetInt(USAGE_NEW_MAINUI, 1) == 1 then
		return NewMainScene.THEME_MELLOW
	else
		return NewMainScene.THEME_CLASSIC
	end
end

function var0.IsMellowStyle(arg0)
	local var0 = arg0:GetMainSceneThemeStyle()

	return NewMainScene.THEME_MELLOW == var0
end

function var0.GetMainSceneScreenSleepTime(arg0)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		return SleepTimeout.SystemSetting
	end

	local var0 = pg.settings_other_template[20].name

	if PlayerPrefs.GetInt(var0, 1) == 1 then
		return SleepTimeout.NeverSleep
	else
		return SleepTimeout.SystemSetting
	end
end

function var0.ShowL2dResetInMainScene(arg0)
	local var0 = pg.settings_other_template[21].name

	return PlayerPrefs.GetInt(var0, 0) == 1
end

function var0.Reset(arg0)
	arg0:resetEquipSceneIndex()
	arg0:resetActivityLayerIndex()

	arg0.isStopBuildSpeedupReamind = false

	arg0:RestoreFrameRate()

	arg0.randomFlagShipList = nil
	arg0.prevRandomFlagShipTime = nil
	arg0.randomFlagShipMap = nil
	arg0.educateCharTipList = {}
end

return var0
