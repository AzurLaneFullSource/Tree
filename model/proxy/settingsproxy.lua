local var0_0 = class("SettingsProxy", pm.Proxy)

function var0_0.onRegister(arg0_1)
	arg0_1._isBgmEnble = PlayerPrefs.GetInt("ShipSkinBGM", 1) > 0
	arg0_1._ShowBg = PlayerPrefs.GetInt("disableBG", 1) > 0
	arg0_1._ShowLive2d = PlayerPrefs.GetInt("disableLive2d", 1) > 0
	arg0_1._selectedShipId = PlayerPrefs.GetInt("playerShipId")
	arg0_1._backyardFoodRemind = PlayerPrefs.GetString("backyardRemind")
	arg0_1._userAgreement = PlayerPrefs.GetInt("userAgreement", 0)
	arg0_1._showMaxLevelHelp = PlayerPrefs.GetInt("maxLevelHelp", 0) > 0
	arg0_1._nextTipAutoBattleTime = PlayerPrefs.GetInt("AutoBattleTip", 0)
	arg0_1._setFlagShip = PlayerPrefs.GetInt("setFlagShip", 0) > 0
	arg0_1._setFlagShipForSkinAtlas = PlayerPrefs.GetInt("setFlagShipforskinatlas", 0) > 0
	arg0_1._screenRatio = PlayerPrefs.GetFloat("SetScreenRatio", ADAPT_TARGET)
	arg0_1.storyAutoPlayCode = PlayerPrefs.GetInt("story_autoplay_flag", 0)
	NotchAdapt.CheckNotchRatio = arg0_1._screenRatio
	arg0_1._nextTipActBossTime = PlayerPrefs.GetInt("ActBossTipLastTime", 0)

	if GetZeroTime() <= arg0_1._nextTipActBossTime then
		arg0_1.nextTipActBossExchangeTicket = PlayerPrefs.GetInt("ActBossTip", 0)
	end

	arg0_1:resetEquipSceneIndex()

	arg0_1._isShowCollectionHelp = PlayerPrefs.GetInt("collection_Help", 0) > 0
	arg0_1.showMainSceneWordTip = PlayerPrefs.GetInt("main_scene_word_toggle", 1) > 0
	arg0_1.lastRequestVersionTime = nil
	arg0_1.worldBossFlag = {}
	arg0_1.worldFlag = {}
end

function var0_0.SetWorldBossFlag(arg0_2, arg1_2, arg2_2)
	if arg0_2.worldBossFlag[arg1_2] ~= arg2_2 then
		arg0_2.worldBossFlag[arg1_2] = arg2_2

		PlayerPrefs.SetInt("worldBossFlag" .. arg1_2, arg2_2 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.GetWorldBossFlag(arg0_3, arg1_3)
	if not arg0_3.worldBossFlag[arg1_3] then
		arg0_3.worldBossFlag[arg1_3] = PlayerPrefs.GetInt("worldBossFlag" .. arg1_3, 1) > 0
	end

	return arg0_3.worldBossFlag[arg1_3]
end

function var0_0.SetWorldFlag(arg0_4, arg1_4, arg2_4)
	if arg0_4.worldFlag[arg1_4] ~= arg2_4 then
		arg0_4.worldFlag[arg1_4] = arg2_4

		PlayerPrefs.SetInt("world_flag_" .. arg1_4, arg2_4 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.GetWorldFlag(arg0_5, arg1_5)
	if not arg0_5.worldFlag[arg1_5] then
		arg0_5.worldFlag[arg1_5] = PlayerPrefs.GetInt("world_flag_" .. arg1_5, 0) > 0
	end

	return arg0_5.worldFlag[arg1_5]
end

function var0_0.GetDockYardLockBtnFlag(arg0_6)
	if not arg0_6.dockYardLockFlag then
		local var0_6 = getProxy(PlayerProxy):getRawData().id

		arg0_6.dockYardLockFlag = PlayerPrefs.GetInt("DockYardLockFlag" .. var0_6, 0) > 0
	end

	return arg0_6.dockYardLockFlag
end

function var0_0.SetDockYardLockBtnFlag(arg0_7, arg1_7)
	if arg0_7.dockYardLockFlag ~= arg1_7 then
		local var0_7 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("DockYardLockFlag" .. var0_7, arg1_7 and 1 or 0)
		PlayerPrefs.Save()

		arg0_7.dockYardLockFlag = arg1_7
	end
end

function var0_0.GetDockYardLevelBtnFlag(arg0_8)
	if not arg0_8.dockYardLevelFlag then
		local var0_8 = getProxy(PlayerProxy):getRawData().id

		arg0_8.dockYardLevelFlag = PlayerPrefs.GetInt("DockYardLevelFlag" .. var0_8, 0) > 0
	end

	return arg0_8.dockYardLevelFlag
end

function var0_0.SetDockYardLevelBtnFlag(arg0_9, arg1_9)
	if arg0_9.dockYardLevelFlag ~= arg1_9 then
		local var0_9 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("DockYardLevelFlag" .. var0_9, arg1_9 and 1 or 0)
		PlayerPrefs.Save()

		arg0_9.dockYardLevelFlag = arg1_9
	end
end

function var0_0.IsShowCollectionHelp(arg0_10)
	return arg0_10._isShowCollectionHelp
end

function var0_0.SetCollectionHelpFlag(arg0_11, arg1_11)
	if arg0_11._isShowCollectionHelp ~= arg1_11 then
		arg0_11._isShowCollectionHelp = arg1_11

		PlayerPrefs.SetInt("collection_Help", arg1_11 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.IsBGMEnable(arg0_12)
	return arg0_12._isBgmEnble
end

function var0_0.SetBgmFlag(arg0_13, arg1_13)
	if arg0_13._isBgmEnble ~= arg1_13 then
		arg0_13._isBgmEnble = arg1_13

		PlayerPrefs.SetInt("ShipSkinBGM", arg1_13 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.getSkinPosSetting(arg0_14, arg1_14)
	local var0_14 = arg1_14:GetRecordPosKey()
	local var1_14 = arg0_14:GetCurrMainUIStyleKeyForSkinShop()

	if PlayerPrefs.HasKey(var1_14 .. tostring(var0_14) .. "_scale") then
		local var2_14 = PlayerPrefs.GetFloat(var1_14 .. tostring(var0_14) .. "_x", 0)
		local var3_14 = PlayerPrefs.GetFloat(var1_14 .. tostring(var0_14) .. "_y", 0)
		local var4_14 = PlayerPrefs.GetFloat(var1_14 .. tostring(var0_14) .. "_scale", 1)

		return var2_14, var3_14, var4_14
	else
		return nil
	end
end

function var0_0.setSkinPosSetting(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = arg1_15:GetRecordPosKey()
	local var1_15 = arg0_15:GetCurrMainUIStyleKeyForSkinShop()

	PlayerPrefs.SetFloat(var1_15 .. tostring(var0_15) .. "_x", arg2_15)
	PlayerPrefs.SetFloat(var1_15 .. tostring(var0_15) .. "_y", arg3_15)
	PlayerPrefs.SetFloat(var1_15 .. tostring(var0_15) .. "_scale", arg4_15)
	PlayerPrefs.Save()
end

function var0_0.GetCurrMainUIStyleKeyForSkinShop(arg0_16)
	local var0_16 = arg0_16:GetMainSceneThemeStyle()

	if var0_16 == NewMainScene.THEME_CLASSIC then
		return ""
	else
		return var0_16
	end
end

function var0_0.resetSkinPosSetting(arg0_17, arg1_17)
	local var0_17 = arg1_17:GetRecordPosKey()

	PlayerPrefs.DeleteKey(tostring(var0_17) .. "_x")
	PlayerPrefs.DeleteKey(tostring(var0_17) .. "_y")
	PlayerPrefs.DeleteKey(tostring(var0_17) .. "_scale")
	PlayerPrefs.Save()
end

function var0_0.getCharacterSetting(arg0_18, arg1_18, arg2_18)
	return PlayerPrefs.GetInt(tostring(arg1_18) .. "_" .. arg2_18, 1) > 0
end

function var0_0.setCharacterSetting(arg0_19, arg1_19, arg2_19, arg3_19)
	PlayerPrefs.SetInt(tostring(arg1_19) .. "_" .. arg2_19, arg3_19 and 1 or 0)
	PlayerPrefs.Save()
end

function var0_0.getCurrentSecretaryIndex(arg0_20)
	local var0_20 = PlayerPrefs.GetInt("currentSecretaryIndex", 1)

	if var0_20 > PlayerVitaeShipsPage.GetAllUnlockSlotCnt() then
		arg0_20:setCurrentSecretaryIndex(1)

		return 1
	else
		return PlayerVitaeShipsPage.GetSlotIndexList()[var0_20]
	end
end

function var0_0.rotateCurrentSecretaryIndex(arg0_21)
	local function var0_21()
		return getProxy(PlayerProxy):getRawData():ExistEducateChar() and getProxy(SettingsProxy):GetFlagShipDisplayMode() ~= FlAG_SHIP_DISPLAY_ONLY_SHIP
	end

	local var1_21 = PlayerPrefs.GetInt("currentSecretaryIndex", 1)
	local var2_21 = PlayerVitaeShipsPage.GetAllUnlockSlotCnt()
	local var3_21 = var1_21 + 1

	if var2_21 < var3_21 or var3_21 == PlayerVitaeShipsPage.EDUCATE_CHAR_SLOT_ID and not var0_21() then
		var3_21 = 1
	end

	arg0_21:setCurrentSecretaryIndex(var3_21)
	pg.m02:sendNotification(GAME.ROTATE_PAINTING_INDEX)
end

function var0_0.setCurrentSecretaryIndex(arg0_23, arg1_23)
	PlayerPrefs.SetInt("currentSecretaryIndex", arg1_23)
	PlayerPrefs.Save()
end

function var0_0.SetFlagShip(arg0_24, arg1_24)
	if arg0_24._setFlagShip ~= arg1_24 then
		arg0_24._setFlagShip = arg1_24

		PlayerPrefs.SetInt("setFlagShip", arg1_24 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.GetSetFlagShip(arg0_25)
	return arg0_25._setFlagShip
end

function var0_0.SetFlagShipForSkinAtlas(arg0_26, arg1_26)
	if arg0_26._setFlagShipForSkinAtlas ~= arg1_26 then
		arg0_26._setFlagShipForSkinAtlas = arg1_26

		PlayerPrefs.SetInt("setFlagShipforskinatlas", arg1_26 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.GetSetFlagShipForSkinAtlas(arg0_27)
	return arg0_27._setFlagShipForSkinAtlas
end

function var0_0.CheckNeedUserAgreement(arg0_28)
	if PLATFORM_CODE == PLATFORM_KR then
		return false
	elseif PLATFORM_CODE == PLATFORM_CH then
		return false
	else
		return arg0_28:GetUserAgreementFlag() > arg0_28._userAgreement
	end
end

function var0_0.GetUserAgreementFlag(arg0_29)
	local var0_29 = USER_AGREEMENT_FLAG_DEFAULT

	if PLATFORM_CODE == PLATFORM_CHT then
		var0_29 = USER_AGREEMENT_FLAG_TW
	end

	return var0_29
end

function var0_0.SetUserAgreement(arg0_30)
	if arg0_30:CheckNeedUserAgreement() then
		local var0_30 = arg0_30:GetUserAgreementFlag()

		PlayerPrefs.SetInt("userAgreement", var0_30)
		PlayerPrefs.Save()

		arg0_30._userAgreement = var0_30
	end
end

function var0_0.IsLive2dEnable(arg0_31)
	return arg0_31._ShowLive2d
end

function var0_0.IsBGEnable(arg0_32)
	return arg0_32._ShowBg
end

function var0_0.SetSelectedShipId(arg0_33, arg1_33)
	if arg0_33._selectedShipId ~= arg1_33 then
		arg0_33._selectedShipId = arg1_33

		PlayerPrefs.SetInt("playerShipId", arg1_33)
		PlayerPrefs.Save()
	end
end

function var0_0.GetSelectedShipId(arg0_34)
	return arg0_34._selectedShipId
end

function var0_0.setEquipSceneIndex(arg0_35, arg1_35)
	arg0_35._equipSceneIndex = arg1_35
end

function var0_0.getEquipSceneIndex(arg0_36)
	return arg0_36._equipSceneIndex
end

function var0_0.resetEquipSceneIndex(arg0_37)
	arg0_37._equipSceneIndex = StoreHouseConst.WARP_TO_MATERIAL
end

function var0_0.setActivityLayerIndex(arg0_38, arg1_38)
	arg0_38._activityLayerIndex = arg1_38
end

function var0_0.getActivityLayerIndex(arg0_39)
	return arg0_39._activityLayerIndex
end

function var0_0.resetActivityLayerIndex(arg0_40)
	arg0_40._activityLayerIndex = 1
end

function var0_0.setBackyardRemind(arg0_41)
	local var0_41 = GetZeroTime()

	if arg0_41._backyardFoodRemind ~= tostring(var0_41) then
		PlayerPrefs.SetString("backyardRemind", var0_41)
		PlayerPrefs.Save()

		arg0_41._backyardFoodRemind = var0_41
	end
end

function var0_0.getBackyardRemind(arg0_42)
	if not arg0_42._backyardFoodRemind or arg0_42._backyardFoodRemind == "" then
		return 0
	else
		return tonumber(arg0_42._backyardFoodRemind)
	end
end

function var0_0.getMaxLevelHelp(arg0_43)
	return arg0_43._showMaxLevelHelp
end

function var0_0.setMaxLevelHelp(arg0_44, arg1_44)
	if arg0_44._showMaxLevelHelp ~= arg1_44 then
		arg0_44._showMaxLevelHelp = arg1_44

		PlayerPrefs.SetInt("maxLevelHelp", arg1_44 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.setStopBuildSpeedupRemind(arg0_45)
	arg0_45.isStopBuildSpeedupReamind = true
end

function var0_0.getStopBuildSpeedupRemind(arg0_46)
	return arg0_46.isStopBuildSpeedupReamind
end

function var0_0.checkReadHelp(arg0_47, arg1_47)
	if not getProxy(PlayerProxy):getData() then
		return true
	end

	if arg1_47 == "help_backyard" then
		return true
	elseif pg.SeriesGuideMgr.GetInstance():isEnd() then
		local var0_47 = PlayerPrefs.GetInt(arg1_47, 0)

		return PlayerPrefs.GetInt(arg1_47, 0) > 0
	end

	return true
end

function var0_0.recordReadHelp(arg0_48, arg1_48)
	PlayerPrefs.SetInt(arg1_48, 1)
	PlayerPrefs.Save()
end

function var0_0.clearAllReadHelp(arg0_49)
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

function var0_0.setAutoBattleTip(arg0_50)
	local var0_50 = GetZeroTime()

	arg0_50._nextTipAutoBattleTime = var0_50

	PlayerPrefs.SetInt("AutoBattleTip", var0_50)
	PlayerPrefs.Save()
end

function var0_0.isTipAutoBattle(arg0_51)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_51._nextTipAutoBattleTime
end

function var0_0.setActBossExchangeTicketTip(arg0_52, arg1_52)
	if arg0_52.nextTipActBossExchangeTicket == arg1_52 then
		return
	end

	arg0_52.nextTipActBossExchangeTicket = arg1_52

	local var0_52 = GetZeroTime()

	if var0_52 > arg0_52._nextTipActBossTime then
		arg0_52._nextTipActBossTime = var0_52

		PlayerPrefs.SetInt("ActBossTipLastTime", var0_52)
	end

	PlayerPrefs.SetInt("ActBossTip", arg1_52)
	PlayerPrefs.Save()
end

function var0_0.isTipActBossExchangeTicket(arg0_53)
	if pg.TimeMgr.GetInstance():GetServerTime() > arg0_53._nextTipActBossTime then
		return nil
	end

	return arg0_53.nextTipActBossExchangeTicket
end

function var0_0.SetScreenRatio(arg0_54, arg1_54)
	if arg0_54._screenRatio ~= arg1_54 then
		arg0_54._screenRatio = arg1_54

		PlayerPrefs.SetFloat("SetScreenRatio", arg1_54)
		PlayerPrefs.Save()
	end
end

function var0_0.GetScreenRatio(arg0_55)
	return arg0_55._screenRatio
end

function var0_0.CheckLargeScreen(arg0_56)
	return Screen.width / Screen.height > 2
end

function var0_0.IsShowBeatMonseterNianCurtain(arg0_57)
	local var0_57 = getProxy(PlayerProxy):getRawData()

	return pg.TimeMgr.GetInstance():GetServerTime() > tonumber(PlayerPrefs.GetString("HitMonsterNianLayer2020" .. var0_57.id, "0"))
end

function var0_0.SetBeatMonseterNianFlag(arg0_58)
	local var0_58 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetString("HitMonsterNianLayer2020" .. var0_58.id, GetZeroTime())
	PlayerPrefs.Save()
end

function var0_0.ShouldShowEventActHelp(arg0_59)
	if not arg0_59.actEventFlag then
		local var0_59 = getProxy(PlayerProxy):getRawData().id

		arg0_59.actEventFlag = PlayerPrefs.GetInt("event_act_help1" .. var0_59, 0) > 0
	end

	return not arg0_59.actEventFlag
end

function var0_0.MarkEventActHelpFlag(arg0_60)
	if not arg0_60.actEventFlag then
		arg0_60.actEventFlag = true

		local var0_60 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("event_act_help1" .. var0_60, 1)
		PlayerPrefs.Save()
	end
end

function var0_0.SetStorySpeed(arg0_61, arg1_61)
	arg0_61.storySpeed = arg1_61

	local var0_61

	if getProxy(PlayerProxy) then
		var0_61 = getProxy(PlayerProxy):getRawData().id
	else
		var0_61 = 1
	end

	PlayerPrefs.SetInt("story_speed_flag" .. var0_61, arg1_61)
	PlayerPrefs.Save()
end

function var0_0.GetStorySpeed(arg0_62)
	if not arg0_62.storySpeed then
		local var0_62

		if getProxy(PlayerProxy) then
			var0_62 = getProxy(PlayerProxy):getRawData().id
		else
			var0_62 = 1
		end

		arg0_62.storySpeed = PlayerPrefs.GetInt("story_speed_flag" .. var0_62, 0)
	end

	return arg0_62.storySpeed
end

function var0_0.GetStoryAutoPlayFlag(arg0_63)
	return arg0_63.storyAutoPlayCode > 0
end

function var0_0.SetStoryAutoPlayFlag(arg0_64, arg1_64)
	if arg0_64.storyAutoPlayCode ~= arg1_64 then
		PlayerPrefs.SetInt("story_autoplay_flag", arg1_64)
		PlayerPrefs.Save()

		arg0_64.storyAutoPlayCode = arg1_64
	end
end

function var0_0.GetPaintingDownloadPrefs(arg0_65)
	return PlayerPrefs.GetInt("Painting_Download_Prefs", 0)
end

function var0_0.SetPaintingDownloadPrefs(arg0_66, arg1_66)
	PlayerPrefs.SetInt("Painting_Download_Prefs", arg1_66)
end

function var0_0.ShouldShipMainSceneWord(arg0_67)
	return arg0_67.showMainSceneWordTip
end

function var0_0.SaveMainSceneWordFlag(arg0_68, arg1_68)
	if arg0_68.showMainSceneWordTip ~= arg1_68 then
		arg0_68.showMainSceneWordTip = arg1_68

		PlayerPrefs.SetInt("main_scene_word_toggle", arg1_68 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.RecordFrameRate(arg0_69)
	if not arg0_69.originalFrameRate then
		arg0_69.originalFrameRate = Application.targetFrameRate
	end
end

function var0_0.RestoreFrameRate(arg0_70)
	if arg0_70.originalFrameRate then
		Application.targetFrameRate = arg0_70.originalFrameRate
		arg0_70.originalFrameRate = nil
	end
end

function var0_0.ResetTimeLimitSkinShopTip(arg0_71)
	arg0_71.isTipLimitSkinShop = PlayerPrefs.GetInt("tipLimitSkinShopTime_", 0) <= pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_71.isTipLimitSkinShop then
		arg0_71.nextTipLimitSkinShopTime = GetZeroTime()
	end
end

function var0_0.ShouldTipTimeLimitSkinShop(arg0_72)
	return arg0_72.isTipLimitSkinShop
end

function var0_0.SetNextTipTimeLimitSkinShop(arg0_73)
	if arg0_73.isTipLimitSkinShop and arg0_73.nextTipLimitSkinShopTime then
		PlayerPrefs.SetInt("tipLimitSkinShopTime_", arg0_73.nextTipLimitSkinShopTime)
		PlayerPrefs.Save()

		arg0_73.nextTipLimitSkinShopTime = nil
		arg0_73.isTipLimitSkinShop = false
	end
end

function var0_0.WorldBossProgressTipFlag(arg0_74, arg1_74)
	if arg0_74.WorldBossProgressTipValue ~= arg1_74 then
		arg0_74.WorldBossProgressTipValue = arg1_74

		PlayerPrefs.SetString("_WorldBossProgressTipFlag_", arg1_74)
		PlayerPrefs.Save()
	end
end

function var0_0.GetWorldBossProgressTipFlag(arg0_75)
	if not arg0_75.WorldBossProgressTipValue then
		local var0_75 = pg.gameset.joint_boss_ticket.description
		local var1_75 = var0_75[1] + var0_75[2]
		local var2_75 = var0_75[1] .. "&" .. var1_75
		local var3_75 = PlayerPrefs.GetString("_WorldBossProgressTipFlag_", var2_75)

		arg0_75.WorldBossProgressTipValue = var3_75

		return var3_75
	else
		return arg0_75.WorldBossProgressTipValue
	end
end

function var0_0.GetWorldBossProgressTipTable(arg0_76)
	local var0_76 = arg0_76:GetWorldBossProgressTipFlag()

	if not var0_76 or var0_76 == "" then
		return {}
	end

	return string.split(var0_76, "&")
end

function var0_0.GetChatFlag(arg0_77)
	if not arg0_77.chatFlag then
		local var0_77 = {
			ChatConst.ChannelWorld,
			ChatConst.ChannelPublic,
			ChatConst.ChannelFriend
		}

		if getProxy(GuildProxy):getRawData() then
			table.insert(var0_77, ChatConst.ChannelGuild)
		end

		arg0_77.chatFlag = PlayerPrefs.GetInt("chat__setting", IndexConst.Flags2Bits(var0_77))
	end

	return arg0_77.chatFlag
end

function var0_0.SetChatFlag(arg0_78, arg1_78)
	if arg0_78.chatFlag ~= arg1_78 then
		arg0_78.chatFlag = arg1_78

		PlayerPrefs.SetInt("chat__setting", arg1_78)
		PlayerPrefs.Save()
	end
end

function var0_0.IsShowActivityMapSPTip()
	local var0_79 = getProxy(PlayerProxy):getRawData()

	return pg.TimeMgr.GetInstance():GetServerTime() > PlayerPrefs.GetInt("ActivityMapSPTip" .. var0_79.id, 0)
end

function var0_0.SetActivityMapSPTip()
	local var0_80 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetInt("ActivityMapSPTip" .. var0_80.id, GetZeroTime())
	PlayerPrefs.Save()
end

function var0_0.IsTipNewTheme(arg0_81)
	local var0_81 = pg.backyard_theme_template
	local var1_81 = var0_81.all[#var0_81.all]
	local var2_81 = var0_81[var1_81].ids[1]
	local var3_81 = pg.furniture_shop_template[var2_81]
	local var4_81 = getProxy(PlayerProxy):getRawData().id
	local var5_81 = PlayerPrefs.GetInt(var4_81 .. "IsTipNewTheme" .. var1_81, 0) == 0

	if var3_81 and var3_81.new == 1 and pg.TimeMgr.GetInstance():inTime(var3_81.time) and var5_81 then
		arg0_81.lastThemeId = var1_81
	else
		arg0_81.lastThemeId = nil
	end

	return arg0_81.lastThemeId ~= nil
end

function var0_0.UpdateNewThemeValue(arg0_82)
	if arg0_82.lastThemeId then
		local var0_82 = arg0_82.lastThemeId
		local var1_82 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt(var1_82 .. "IsTipNewTheme" .. var0_82, 1)
		PlayerPrefs.Save()
	end
end

function var0_0.GetNewGemFurnitureLocalCache(arg0_83)
	if not arg0_83.cacheGemFuruitures then
		arg0_83.cacheGemFuruitures = {}

		local var0_83 = getProxy(PlayerProxy):getRawData().id
		local var1_83 = PlayerPrefs.GetString(var0_83 .. "IsTipNewGenFurniture")

		if var1_83 ~= "" then
			local var2_83 = string.split(var1_83, "#")

			for iter0_83, iter1_83 in ipairs(var2_83) do
				arg0_83.cacheGemFuruitures[tonumber(iter1_83)] = true
			end
		end
	end

	return arg0_83.cacheGemFuruitures
end

function var0_0.IsTipNewGemFurniture(arg0_84)
	local var0_84 = arg0_84:GetNewGemFurnitureLocalCache()
	local var1_84 = getProxy(DormProxy):GetTag7Furnitures()

	if _.any(var1_84, function(arg0_85)
		return pg.furniture_shop_template[arg0_85].new == 1 and not var0_84[arg0_85]
	end) then
		arg0_84.newGemFurniture = var1_84
	else
		arg0_84.newGemFurniture = nil
	end

	return arg0_84.newGemFurniture ~= nil
end

function var0_0.UpdateNewGemFurnitureValue(arg0_86)
	if arg0_86.newGemFurniture then
		for iter0_86, iter1_86 in pairs(arg0_86.newGemFurniture) do
			arg0_86.cacheGemFuruitures[iter1_86] = true
		end

		local var0_86 = table.concat(arg0_86.newGemFurniture, "#")
		local var1_86 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString(var1_86 .. "IsTipNewGenFurniture", var0_86)
		PlayerPrefs.Save()
	end
end

function var0_0.GetRandomFlagShipList(arg0_87)
	if arg0_87.randomFlagShipList then
		return arg0_87.randomFlagShipList
	end

	local var0_87 = getProxy(PlayerProxy):getRawData().id
	local var1_87 = PlayerPrefs.GetString("RandomFlagShipList" .. var0_87, "")
	local var2_87 = string.split(var1_87, "#")

	arg0_87.randomFlagShipList = _.map(var2_87, function(arg0_88)
		return tonumber(arg0_88)
	end)

	return arg0_87.randomFlagShipList
end

function var0_0.IsRandomFlagShip(arg0_89, arg1_89)
	if not arg0_89.randomFlagShipMap then
		arg0_89.randomFlagShipMap = {}

		for iter0_89, iter1_89 in ipairs(arg0_89:GetRandomFlagShipList()) do
			arg0_89.randomFlagShipMap[iter1_89] = true
		end
	end

	return arg0_89.randomFlagShipMap[arg1_89] == true
end

function var0_0.IsOpenRandomFlagShip(arg0_90)
	local var0_90 = arg0_90:GetRandomFlagShipList()
	local var1_90 = getProxy(BayProxy)

	return #var0_90 > 0 and _.any(var0_90, function(arg0_91)
		return var1_90:RawGetShipById(arg0_91) ~= nil
	end)
end

function var0_0.UpdateRandomFlagShipList(arg0_92, arg1_92)
	arg0_92.randomFlagShipMap = nil
	arg0_92.randomFlagShipList = arg1_92

	local var0_92 = table.concat(arg1_92, "#")
	local var1_92 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("RandomFlagShipList" .. var1_92, var0_92)
	PlayerPrefs.Save()
end

function var0_0.GetPrevRandomFlagShipTime(arg0_93)
	if arg0_93.prevRandomFlagShipTime then
		return arg0_93.prevRandomFlagShipTime
	end

	local var0_93 = getProxy(PlayerProxy):getRawData().id

	arg0_93.prevRandomFlagShipTime = PlayerPrefs.GetInt("RandomFlagShipTime" .. var0_93, 0)

	return arg0_93.prevRandomFlagShipTime
end

function var0_0.SetPrevRandomFlagShipTime(arg0_94, arg1_94)
	if arg0_94.prevRandomFlagShipTime == arg1_94 then
		return
	end

	arg0_94.prevRandomFlagShipTime = arg1_94

	local var0_94 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("RandomFlagShipTime" .. var0_94, arg1_94)
	PlayerPrefs.Save()
end

function var0_0.GetFlagShipDisplayMode(arg0_95)
	if not arg0_95.flagShipDisplayMode then
		local var0_95 = getProxy(PlayerProxy):getRawData().id

		arg0_95.flagShipDisplayMode = PlayerPrefs.GetInt("flag-ship-display-mode" .. var0_95, FlAG_SHIP_DISPLAY_ALL)
	end

	return arg0_95.flagShipDisplayMode
end

function var0_0.SetFlagShipDisplayMode(arg0_96, arg1_96)
	if arg0_96.flagShipDisplayMode ~= arg1_96 then
		arg0_96.flagShipDisplayMode = arg1_96

		local var0_96 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("flag-ship-display-mode" .. var0_96, arg1_96)
		PlayerPrefs.Save()
	end
end

function var0_0.RecordContinuousOperationAutoSubStatus(arg0_97, arg1_97)
	if arg1_97 then
		return
	end

	local var0_97 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("AutoBotCOFlag" .. var0_97, 1)
	PlayerPrefs.Save()
end

function var0_0.ResetContinuousOperationAutoSub(arg0_98)
	local var0_98 = getProxy(PlayerProxy):getRawData().id

	if PlayerPrefs.GetInt("AutoBotCOFlag" .. var0_98, 0) == 0 then
		return
	end

	pg.m02:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = true,
		system = SYSTEM_ACT_BOSS
	})
	PlayerPrefs.SetInt("AutoBotCOFlag" .. var0_98, 0)
	PlayerPrefs.Save()
end

function var0_0.SetWorkbenchDailyTip(arg0_99)
	local var0_99 = getProxy(PlayerProxy):getRawData().id
	local var1_99 = GetZeroTime()

	PlayerPrefs.SetInt("WorkbenchDailyTip" .. var0_99, var1_99)
	PlayerPrefs.Save()
end

function var0_0.IsTipWorkbenchDaily(arg0_100)
	local var0_100 = getProxy(PlayerProxy):getRawData().id

	return pg.TimeMgr.GetInstance():GetServerTime() > PlayerPrefs.GetInt("WorkbenchDailyTip" .. var0_100, 0)
end

function var0_0.IsDisplayResultPainting(arg0_101)
	local var0_101 = PlayerPrefs.HasKey(BATTLERESULT_SKIP_DISPAY_PAINTING)
	local var1_101 = false

	if var0_101 then
		var1_101 = PlayerPrefs.GetInt(BATTLERESULT_SKIP_DISPAY_PAINTING) <= 0

		PlayerPrefs.DeleteKey(BATTLERESULT_SKIP_DISPAY_PAINTING)
		PlayerPrefs.SetInt(BATTLERESULT_DISPAY_PAINTING, var1_101 and 1 or 0)
		PlayerPrefs.Save()
	else
		var1_101 = PlayerPrefs.GetInt(BATTLERESULT_DISPAY_PAINTING, 0) >= 1
	end

	return var1_101
end

function var0_0.IsDisplayCommanderCatCustomName(arg0_102)
	if not arg0_102.customFlag then
		local var0_102 = getProxy(PlayerProxy):getRawData().id

		arg0_102.customFlag = PlayerPrefs.GetInt("DisplayCommanderCatCustomName" .. var0_102, 0) == 0
	end

	return arg0_102.customFlag
end

function var0_0.SetDisplayCommanderCatCustomName(arg0_103, arg1_103)
	if arg1_103 == arg0_103.customFlag then
		return
	end

	arg0_103.customFlag = arg1_103

	local var0_103 = arg0_103.customFlag and 0 or 1
	local var1_103 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("DisplayCommanderCatCustomName" .. var1_103, var0_103)
	PlayerPrefs.Save()
end

function var0_0.GetCommanderQuicklyToolRarityConfig(arg0_104)
	if not arg0_104.quicklyToolRarityConfig then
		local var0_104 = getProxy(PlayerProxy):getRawData().id
		local var1_104 = PlayerPrefs.GetString("CommanderQuicklyToolRarityConfig" .. var0_104, "1#1#1")
		local var2_104 = string.split(var1_104, "#")

		arg0_104.quicklyToolRarityConfig = _.map(var2_104, function(arg0_105)
			return tonumber(arg0_105) == 1
		end)
	end

	return arg0_104.quicklyToolRarityConfig
end

function var0_0.SaveCommanderQuicklyToolRarityConfig(arg0_106, arg1_106)
	local var0_106 = false

	for iter0_106, iter1_106 in ipairs(arg0_106.quicklyToolRarityConfig) do
		if arg1_106[iter0_106] ~= iter1_106 then
			var0_106 = true

			break
		end
	end

	if var0_106 then
		arg0_106.quicklyToolRarityConfig = arg1_106

		local var1_106 = _.map(arg0_106.quicklyToolRarityConfig, function(arg0_107)
			return arg0_107 and "1" or "0"
		end)
		local var2_106 = table.concat(var1_106, "#")
		local var3_106 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("CommanderQuicklyToolRarityConfig" .. var3_106, var2_106)
		PlayerPrefs.Save()
	end
end

function var0_0.GetCommanderLockFlagRarityConfig(arg0_108)
	if not arg0_108.lockFlagRarityConfig then
		local var0_108 = getProxy(PlayerProxy):getRawData().id
		local var1_108 = PlayerPrefs.GetString("CommanderLockFlagRarityConfig_" .. var0_108, "1#0#0")
		local var2_108 = string.split(var1_108, "#")

		arg0_108.lockFlagRarityConfig = _.map(var2_108, function(arg0_109)
			return tonumber(arg0_109) == 1
		end)
	end

	return arg0_108.lockFlagRarityConfig
end

function var0_0.SaveCommanderLockFlagRarityConfig(arg0_110, arg1_110)
	local var0_110 = false

	for iter0_110, iter1_110 in ipairs(arg0_110.lockFlagRarityConfig) do
		if arg1_110[iter0_110] ~= iter1_110 then
			var0_110 = true

			break
		end
	end

	if var0_110 then
		arg0_110.lockFlagRarityConfig = arg1_110

		local var1_110 = _.map(arg0_110.lockFlagRarityConfig, function(arg0_111)
			return arg0_111 and "1" or "0"
		end)
		local var2_110 = table.concat(var1_110, "#")
		local var3_110 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("CommanderLockFlagRarityConfig_" .. var3_110, var2_110)
		PlayerPrefs.Save()
	end
end

function var0_0.GetCommanderLockFlagTalentConfig(arg0_112)
	if not arg0_112.lockFlagTalentConfig then
		local var0_112 = getProxy(PlayerProxy):getRawData().id
		local var1_112 = PlayerPrefs.GetString("CommanderLockFlagTalentConfig" .. var0_112, "")
		local var2_112 = {}

		if var1_112 == "" then
			for iter0_112, iter1_112 in ipairs(CommanderCatUtil.GetAllTalentNames()) do
				var2_112[iter1_112.id] = true
			end
		else
			for iter2_112, iter3_112 in ipairs(string.split(var1_112, "#")) do
				local var3_112 = string.split(iter3_112, "*")

				if #var3_112 == 2 then
					var2_112[tonumber(var3_112[1])] = tonumber(var3_112[2]) == 1
				end
			end
		end

		arg0_112.lockFlagTalentConfig = var2_112
	end

	return arg0_112.lockFlagTalentConfig
end

function var0_0.SaveCommanderLockFlagTalentConfig(arg0_113, arg1_113)
	arg0_113.lockFlagTalentConfig = arg1_113

	local var0_113 = {}

	for iter0_113, iter1_113 in pairs(arg1_113) do
		table.insert(var0_113, iter0_113 .. "*" .. (iter1_113 and "1" or "0"))
	end

	local var1_113 = table.concat(var0_113, "#")
	local var2_113 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("CommanderLockFlagTalentConfig" .. var2_113, var1_113)
	PlayerPrefs.Save()
end

function var0_0.GetMainPaintingVariantFlag(arg0_114, arg1_114)
	if not arg0_114.mainPaintingVariantFlag then
		arg0_114.mainPaintingVariantFlag = {}
	end

	if not arg0_114.mainPaintingVariantFlag[arg1_114] then
		local var0_114 = getProxy(PlayerProxy):getRawData().id
		local var1_114 = PlayerPrefs.GetInt(arg1_114 .. "_mainMeshImagePainting_ex_" .. var0_114, 0)

		arg0_114.mainPaintingVariantFlag[arg1_114] = var1_114
	end

	return arg0_114.mainPaintingVariantFlag[arg1_114]
end

function var0_0.SwitchMainPaintingVariantFlag(arg0_115, arg1_115)
	local var0_115 = 1 - arg0_115:GetMainPaintingVariantFlag(arg1_115)

	arg0_115.mainPaintingVariantFlag[arg1_115] = var0_115

	local var1_115 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(arg1_115 .. "_mainMeshImagePainting_ex_" .. var1_115, var0_115)
	PlayerPrefs.Save()
end

function var0_0.IsTipDay(arg0_116, arg1_116, arg2_116, arg3_116)
	local var0_116 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_116 .. "educate_char_" .. arg1_116 .. arg2_116 .. arg3_116, 0) == 1
end

function var0_0.RecordTipDay(arg0_117, arg1_117, arg2_117, arg3_117)
	local var0_117 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_117 .. "educate_char_" .. arg1_117 .. arg2_117 .. arg3_117, 1)
	PlayerPrefs.Save()
end

function var0_0.UpdateEducateCharTip(arg0_118, arg1_118)
	local var0_118 = getProxy(PlayerProxy):getRawData().id
	local var1_118 = getProxy(EducateProxy):GetSecretaryIDs()
	local var2_118 = {}

	for iter0_118, iter1_118 in ipairs(arg1_118) do
		var2_118[iter1_118] = true
	end

	for iter2_118, iter3_118 in ipairs(var1_118) do
		if var2_118[iter3_118] ~= true then
			PlayerPrefs.SetInt(var0_118 .. "educate_char_tip" .. iter3_118, 1)
			PlayerPrefs.Save()
		end
	end

	arg0_118:RefillEducateCharTipList()
end

function var0_0.RefillEducateCharTipList(arg0_119)
	local var0_119 = getProxy(PlayerProxy):getRawData().id

	arg0_119.educateCharTipList = {}

	if LOCK_EDUCATE_SYSTEM then
		return
	end

	local var1_119 = getProxy(EducateProxy):GetSecretaryIDs()

	for iter0_119, iter1_119 in ipairs(var1_119 or {}) do
		if PlayerPrefs.GetInt(var0_119 .. "educate_char_tip" .. iter1_119, 0) == 1 then
			table.insert(arg0_119.educateCharTipList, iter1_119)
		end
	end
end

function var0_0.ShouldEducateCharTip(arg0_120)
	if not arg0_120.educateCharTipList or #arg0_120.educateCharTipList == 0 then
		arg0_120:RefillEducateCharTipList()
	end

	return #arg0_120.educateCharTipList > 0
end

function var0_0._ShouldEducateCharTip(arg0_121, arg1_121)
	if not arg0_121.educateCharTipList or #arg0_121.educateCharTipList == 0 then
		arg0_121:RefillEducateCharTipList()
	end

	if table.contains(arg0_121.educateCharTipList, arg1_121) then
		return true
	end

	return false
end

function var0_0.ClearEducateCharTip(arg0_122, arg1_122)
	if not arg0_122:_ShouldEducateCharTip(arg1_122) then
		return false
	end

	table.removebyvalue(arg0_122.educateCharTipList, arg1_122)

	local var0_122 = getProxy(PlayerProxy):getRawData().id .. "educate_char_tip" .. arg1_122

	if PlayerPrefs.HasKey(var0_122) then
		PlayerPrefs.DeleteKey(var0_122)
		PlayerPrefs.Save()
	end

	pg.m02:sendNotification(GAME.CLEAR_EDUCATE_TIP, {
		id = arg1_122
	})

	return true
end

function var0_0.GetMainSceneThemeStyle(arg0_123)
	if PlayerPrefs.GetInt(USAGE_NEW_MAINUI, 1) == 1 then
		return NewMainScene.THEME_MELLOW
	else
		return NewMainScene.THEME_CLASSIC
	end
end

function var0_0.IsMellowStyle(arg0_124)
	local var0_124 = arg0_124:GetMainSceneThemeStyle()

	return NewMainScene.THEME_MELLOW == var0_124
end

function var0_0.GetMainSceneScreenSleepTime(arg0_125)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		return SleepTimeout.SystemSetting
	end

	local var0_125 = pg.settings_other_template[20].name

	if PlayerPrefs.GetInt(var0_125, 1) == 1 then
		return SleepTimeout.NeverSleep
	else
		return SleepTimeout.SystemSetting
	end
end

function var0_0.ShowL2dResetInMainScene(arg0_126)
	local var0_126 = pg.settings_other_template[21].name

	return PlayerPrefs.GetInt(var0_126, 0) == 1
end

function var0_0.Reset(arg0_127)
	arg0_127:resetEquipSceneIndex()
	arg0_127:resetActivityLayerIndex()

	arg0_127.isStopBuildSpeedupReamind = false

	arg0_127:RestoreFrameRate()

	arg0_127.randomFlagShipList = nil
	arg0_127.prevRandomFlagShipTime = nil
	arg0_127.randomFlagShipMap = nil
	arg0_127.educateCharTipList = {}
end

return var0_0
