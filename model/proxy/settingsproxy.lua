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

function var0_0.IsEnableMainMusicPlayer(arg0_14)
	return true
end

function var0_0.getSkinPosSetting(arg0_15, arg1_15)
	local var0_15 = arg1_15:GetRecordPosKey()
	local var1_15 = arg0_15:GetCurrMainUIStyleKeyForSkinShop()

	if PlayerPrefs.HasKey(var1_15 .. tostring(var0_15) .. "_scale") then
		local var2_15 = PlayerPrefs.GetFloat(var1_15 .. tostring(var0_15) .. "_x", 0)
		local var3_15 = PlayerPrefs.GetFloat(var1_15 .. tostring(var0_15) .. "_y", 0)
		local var4_15 = PlayerPrefs.GetFloat(var1_15 .. tostring(var0_15) .. "_scale", 1)

		return var2_15, var3_15, var4_15
	else
		return nil
	end
end

function var0_0.setSkinPosSetting(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	local var0_16 = arg1_16:GetRecordPosKey()
	local var1_16 = arg0_16:GetCurrMainUIStyleKeyForSkinShop()

	PlayerPrefs.SetFloat(var1_16 .. tostring(var0_16) .. "_x", arg2_16)
	PlayerPrefs.SetFloat(var1_16 .. tostring(var0_16) .. "_y", arg3_16)
	PlayerPrefs.SetFloat(var1_16 .. tostring(var0_16) .. "_scale", arg4_16)
	PlayerPrefs.Save()
end

function var0_0.setSkinScaleSetting(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	local var0_17 = arg1_17:GetRecordPosKey()
	local var1_17 = tostring(var0_17) .. arg2_17 .. "_" .. arg3_17 .. "_part_scale"

	PlayerPrefs.SetFloat(tostring(var0_17) .. arg2_17 .. "_" .. arg3_17 .. "_part_scale", arg4_17)
end

function var0_0.getSkinScaleSetting(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18
	local var1_18 = arg1_18:GetRecordPosKey()
	local var2_18 = tostring(var1_18) .. arg2_18 .. "_" .. arg3_18 .. "_part_scale"

	if PlayerPrefs.HasKey(var2_18) then
		var0_18 = PlayerPrefs.GetFloat(var2_18, 1)
	else
		return 1
	end

	return var0_18
end

function var0_0.GetCurrMainUIStyleKeyForSkinShop(arg0_19)
	local var0_19 = arg0_19:GetMainSceneThemeStyle()

	if var0_19 == NewMainScene.THEME_CLASSIC then
		return ""
	else
		return var0_19
	end
end

function var0_0.resetSkinPosSetting(arg0_20, arg1_20)
	local var0_20 = arg1_20:GetRecordPosKey()

	PlayerPrefs.DeleteKey(tostring(var0_20) .. "_x")
	PlayerPrefs.DeleteKey(tostring(var0_20) .. "_y")
	PlayerPrefs.DeleteKey(tostring(var0_20) .. "_scale")
	PlayerPrefs.Save()
end

function var0_0.getCharacterSetting(arg0_21, arg1_21, arg2_21)
	return PlayerPrefs.GetInt(tostring(arg1_21) .. "_" .. arg2_21, 1) > 0
end

function var0_0.setCharacterSetting(arg0_22, arg1_22, arg2_22, arg3_22)
	PlayerPrefs.SetInt(tostring(arg1_22) .. "_" .. arg2_22, arg3_22 and 1 or 0)
	PlayerPrefs.Save()
end

function var0_0.getCurrentSecretaryIndex(arg0_23)
	local var0_23 = PlayerPrefs.GetInt("currentSecretaryIndex", 1)

	if var0_23 > PlayerVitaeShipsPage.GetAllUnlockSlotCnt() then
		arg0_23:setCurrentSecretaryIndex(1)

		return 1
	else
		return PlayerVitaeShipsPage.GetSlotIndexList()[var0_23]
	end
end

function var0_0.rotateCurrentSecretaryIndex(arg0_24)
	local function var0_24()
		return getProxy(PlayerProxy):getRawData():ExistEducateChar() and getProxy(SettingsProxy):GetFlagShipDisplayMode() ~= FlAG_SHIP_DISPLAY_ONLY_SHIP
	end

	local var1_24 = PlayerPrefs.GetInt("currentSecretaryIndex", 1)
	local var2_24 = PlayerVitaeShipsPage.GetAllUnlockSlotCnt()
	local var3_24 = var1_24 + 1

	if var2_24 < var3_24 or var3_24 == PlayerVitaeShipsPage.EDUCATE_CHAR_SLOT_ID and not var0_24() then
		var3_24 = 1
	end

	arg0_24:setCurrentSecretaryIndex(var3_24)
	pg.m02:sendNotification(GAME.ROTATE_PAINTING_INDEX)
end

function var0_0.setCurrentSecretaryIndex(arg0_26, arg1_26)
	PlayerPrefs.SetInt("currentSecretaryIndex", arg1_26)
	PlayerPrefs.Save()
end

function var0_0.SetFlagShip(arg0_27, arg1_27)
	if arg0_27._setFlagShip ~= arg1_27 then
		arg0_27._setFlagShip = arg1_27

		PlayerPrefs.SetInt("setFlagShip", arg1_27 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.GetSetFlagShip(arg0_28)
	return arg0_28._setFlagShip
end

function var0_0.SetFlagShipForSkinAtlas(arg0_29, arg1_29)
	if arg0_29._setFlagShipForSkinAtlas ~= arg1_29 then
		arg0_29._setFlagShipForSkinAtlas = arg1_29

		PlayerPrefs.SetInt("setFlagShipforskinatlas", arg1_29 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.GetSetFlagShipForSkinAtlas(arg0_30)
	return arg0_30._setFlagShipForSkinAtlas
end

function var0_0.CheckNeedUserAgreement(arg0_31)
	if PLATFORM_CODE == PLATFORM_KR then
		return false
	elseif PLATFORM_CODE == PLATFORM_CH then
		return false
	elseif PLATFORM_CODE == PLATFORM_JP then
		return false
	else
		return arg0_31:GetUserAgreementFlag() > arg0_31._userAgreement
	end
end

function var0_0.GetUserAgreementFlag(arg0_32)
	local var0_32 = USER_AGREEMENT_FLAG_DEFAULT

	if PLATFORM_CODE == PLATFORM_CHT then
		var0_32 = USER_AGREEMENT_FLAG_TW
	end

	return var0_32
end

function var0_0.SetUserAgreement(arg0_33)
	if arg0_33:CheckNeedUserAgreement() then
		local var0_33 = arg0_33:GetUserAgreementFlag()

		PlayerPrefs.SetInt("userAgreement", var0_33)
		PlayerPrefs.Save()

		arg0_33._userAgreement = var0_33
	end
end

function var0_0.IsLive2dEnable(arg0_34)
	return arg0_34._ShowLive2d
end

function var0_0.IsBGEnable(arg0_35)
	return arg0_35._ShowBg
end

function var0_0.SetSelectedShipId(arg0_36, arg1_36)
	if arg0_36._selectedShipId ~= arg1_36 then
		arg0_36._selectedShipId = arg1_36

		PlayerPrefs.SetInt("playerShipId", arg1_36)
		PlayerPrefs.Save()
	end
end

function var0_0.GetSelectedShipId(arg0_37)
	return arg0_37._selectedShipId
end

function var0_0.setEquipSceneIndex(arg0_38, arg1_38)
	arg0_38._equipSceneIndex = arg1_38
end

function var0_0.getEquipSceneIndex(arg0_39)
	return arg0_39._equipSceneIndex
end

function var0_0.resetEquipSceneIndex(arg0_40)
	arg0_40._equipSceneIndex = StoreHouseConst.WARP_TO_MATERIAL
end

function var0_0.setActivityLayerIndex(arg0_41, arg1_41)
	arg0_41._activityLayerIndex = arg1_41
end

function var0_0.getActivityLayerIndex(arg0_42)
	return arg0_42._activityLayerIndex
end

function var0_0.resetActivityLayerIndex(arg0_43)
	arg0_43._activityLayerIndex = 1
end

function var0_0.setBackyardRemind(arg0_44)
	local var0_44 = GetZeroTime()

	if arg0_44._backyardFoodRemind ~= tostring(var0_44) then
		PlayerPrefs.SetString("backyardRemind", var0_44)
		PlayerPrefs.Save()

		arg0_44._backyardFoodRemind = var0_44
	end
end

function var0_0.getBackyardRemind(arg0_45)
	if not arg0_45._backyardFoodRemind or arg0_45._backyardFoodRemind == "" then
		return 0
	else
		return tonumber(arg0_45._backyardFoodRemind)
	end
end

function var0_0.getMaxLevelHelp(arg0_46)
	return arg0_46._showMaxLevelHelp
end

function var0_0.setMaxLevelHelp(arg0_47, arg1_47)
	if arg0_47._showMaxLevelHelp ~= arg1_47 then
		arg0_47._showMaxLevelHelp = arg1_47

		PlayerPrefs.SetInt("maxLevelHelp", arg1_47 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.setStopBuildSpeedupRemind(arg0_48)
	arg0_48.isStopBuildSpeedupReamind = true
end

function var0_0.getStopBuildSpeedupRemind(arg0_49)
	return arg0_49.isStopBuildSpeedupReamind
end

function var0_0.checkReadHelp(arg0_50, arg1_50)
	if not getProxy(PlayerProxy):getData() then
		return true
	end

	if arg1_50 == "help_backyard" then
		return true
	elseif pg.SeriesGuideMgr.GetInstance():isEnd() then
		local var0_50 = PlayerPrefs.GetInt(arg1_50, 0)

		return PlayerPrefs.GetInt(arg1_50, 0) > 0
	end

	return true
end

function var0_0.recordReadHelp(arg0_51, arg1_51)
	PlayerPrefs.SetInt(arg1_51, 1)
	PlayerPrefs.Save()
end

function var0_0.clearAllReadHelp(arg0_52)
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

function var0_0.setAutoBattleTip(arg0_53)
	local var0_53 = GetZeroTime()

	arg0_53._nextTipAutoBattleTime = var0_53

	PlayerPrefs.SetInt("AutoBattleTip", var0_53)
	PlayerPrefs.Save()
end

function var0_0.isTipAutoBattle(arg0_54)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_54._nextTipAutoBattleTime
end

function var0_0.setActBossExchangeTicketTip(arg0_55, arg1_55)
	if arg0_55.nextTipActBossExchangeTicket == arg1_55 then
		return
	end

	arg0_55.nextTipActBossExchangeTicket = arg1_55

	local var0_55 = GetZeroTime()

	if var0_55 > arg0_55._nextTipActBossTime then
		arg0_55._nextTipActBossTime = var0_55

		PlayerPrefs.SetInt("ActBossTipLastTime", var0_55)
	end

	PlayerPrefs.SetInt("ActBossTip", arg1_55)
	PlayerPrefs.Save()
end

function var0_0.isTipActBossExchangeTicket(arg0_56)
	if pg.TimeMgr.GetInstance():GetServerTime() > arg0_56._nextTipActBossTime then
		return nil
	end

	return arg0_56.nextTipActBossExchangeTicket
end

function var0_0.SetScreenRatio(arg0_57, arg1_57)
	if arg0_57._screenRatio ~= arg1_57 then
		arg0_57._screenRatio = arg1_57

		PlayerPrefs.SetFloat("SetScreenRatio", arg1_57)
		PlayerPrefs.Save()
	end
end

function var0_0.GetScreenRatio(arg0_58)
	return arg0_58._screenRatio
end

function var0_0.CheckLargeScreen(arg0_59)
	return Screen.width / Screen.height > 2
end

function var0_0.IsShowBeatMonseterNianCurtain(arg0_60)
	local var0_60 = getProxy(PlayerProxy):getRawData()

	return pg.TimeMgr.GetInstance():GetServerTime() > tonumber(PlayerPrefs.GetString("HitMonsterNianLayer2020" .. var0_60.id, "0"))
end

function var0_0.SetBeatMonseterNianFlag(arg0_61)
	local var0_61 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetString("HitMonsterNianLayer2020" .. var0_61.id, GetZeroTime())
	PlayerPrefs.Save()
end

function var0_0.ShouldShowEventActHelp(arg0_62)
	if not arg0_62.actEventFlag then
		local var0_62 = getProxy(PlayerProxy):getRawData().id

		arg0_62.actEventFlag = PlayerPrefs.GetInt("event_act_help1" .. var0_62, 0) > 0
	end

	return not arg0_62.actEventFlag
end

function var0_0.MarkEventActHelpFlag(arg0_63)
	if not arg0_63.actEventFlag then
		arg0_63.actEventFlag = true

		local var0_63 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("event_act_help1" .. var0_63, 1)
		PlayerPrefs.Save()
	end
end

function var0_0.SetStorySpeed(arg0_64, arg1_64)
	arg0_64.storySpeed = arg1_64

	local var0_64

	if getProxy(PlayerProxy) then
		var0_64 = getProxy(PlayerProxy):getRawData().id
	else
		var0_64 = 1
	end

	PlayerPrefs.SetInt("story_speed_flag" .. var0_64, arg1_64)
	PlayerPrefs.Save()
end

function var0_0.GetStorySpeed(arg0_65)
	if not arg0_65.storySpeed then
		local var0_65

		if getProxy(PlayerProxy) then
			var0_65 = getProxy(PlayerProxy):getRawData().id
		else
			var0_65 = 1
		end

		arg0_65.storySpeed = PlayerPrefs.GetInt("story_speed_flag" .. var0_65, 0)
	end

	return arg0_65.storySpeed
end

function var0_0.GetStoryAutoPlayFlag(arg0_66)
	return arg0_66.storyAutoPlayCode > 0
end

function var0_0.SetStoryAutoPlayFlag(arg0_67, arg1_67)
	if arg0_67.storyAutoPlayCode ~= arg1_67 then
		PlayerPrefs.SetInt("story_autoplay_flag", arg1_67)
		PlayerPrefs.Save()

		arg0_67.storyAutoPlayCode = arg1_67
	end
end

function var0_0.GetPaintingDownloadPrefs(arg0_68)
	return PlayerPrefs.GetInt("Painting_Download_Prefs", 0)
end

function var0_0.SetPaintingDownloadPrefs(arg0_69, arg1_69)
	PlayerPrefs.SetInt("Painting_Download_Prefs", arg1_69)
end

function var0_0.ShouldShipMainSceneWord(arg0_70)
	return arg0_70.showMainSceneWordTip
end

function var0_0.SaveMainSceneWordFlag(arg0_71, arg1_71)
	if arg0_71.showMainSceneWordTip ~= arg1_71 then
		arg0_71.showMainSceneWordTip = arg1_71

		PlayerPrefs.SetInt("main_scene_word_toggle", arg1_71 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.RecordFrameRate(arg0_72)
	if not arg0_72.originalFrameRate then
		arg0_72.originalFrameRate = Application.targetFrameRate
	end
end

function var0_0.RestoreFrameRate(arg0_73)
	if arg0_73.originalFrameRate then
		Application.targetFrameRate = arg0_73.originalFrameRate
		arg0_73.originalFrameRate = nil
	end
end

function var0_0.ResetTimeLimitSkinShopTip(arg0_74)
	arg0_74.isTipLimitSkinShop = PlayerPrefs.GetInt("tipLimitSkinShopTime_", 0) <= pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_74.isTipLimitSkinShop then
		arg0_74.nextTipLimitSkinShopTime = GetZeroTime()
	end
end

function var0_0.ShouldTipTimeLimitSkinShop(arg0_75)
	return arg0_75.isTipLimitSkinShop
end

function var0_0.SetNextTipTimeLimitSkinShop(arg0_76)
	if arg0_76.isTipLimitSkinShop and arg0_76.nextTipLimitSkinShopTime then
		PlayerPrefs.SetInt("tipLimitSkinShopTime_", arg0_76.nextTipLimitSkinShopTime)
		PlayerPrefs.Save()

		arg0_76.nextTipLimitSkinShopTime = nil
		arg0_76.isTipLimitSkinShop = false
	end
end

function var0_0.WorldBossProgressTipFlag(arg0_77, arg1_77)
	if arg0_77.WorldBossProgressTipValue ~= arg1_77 then
		arg0_77.WorldBossProgressTipValue = arg1_77

		PlayerPrefs.SetString("_WorldBossProgressTipFlag_", arg1_77)
		PlayerPrefs.Save()
	end
end

function var0_0.GetWorldBossProgressTipFlag(arg0_78)
	if not arg0_78.WorldBossProgressTipValue then
		local var0_78 = pg.gameset.joint_boss_ticket.description
		local var1_78 = var0_78[1] + var0_78[2]
		local var2_78 = var0_78[1] .. "&" .. var1_78
		local var3_78 = PlayerPrefs.GetString("_WorldBossProgressTipFlag_", var2_78)

		arg0_78.WorldBossProgressTipValue = var3_78

		return var3_78
	else
		return arg0_78.WorldBossProgressTipValue
	end
end

function var0_0.GetWorldBossProgressTipTable(arg0_79)
	local var0_79 = arg0_79:GetWorldBossProgressTipFlag()

	if not var0_79 or var0_79 == "" then
		return {}
	end

	return string.split(var0_79, "&")
end

function var0_0.GetChatFlag(arg0_80)
	if not arg0_80.chatFlag then
		local var0_80 = {
			ChatConst.ChannelWorld,
			ChatConst.ChannelPublic,
			ChatConst.ChannelFriend
		}

		if getProxy(GuildProxy):getRawData() then
			table.insert(var0_80, ChatConst.ChannelGuild)
		end

		arg0_80.chatFlag = PlayerPrefs.GetInt("chat__setting", IndexConst.Flags2Bits(var0_80))
	end

	return arg0_80.chatFlag
end

function var0_0.SetChatFlag(arg0_81, arg1_81)
	if arg0_81.chatFlag ~= arg1_81 then
		arg0_81.chatFlag = arg1_81

		PlayerPrefs.SetInt("chat__setting", arg1_81)
		PlayerPrefs.Save()
	end
end

function var0_0.IsShowActivityMapSPTip()
	local var0_82 = getProxy(PlayerProxy):getRawData()

	return pg.TimeMgr.GetInstance():GetServerTime() > PlayerPrefs.GetInt("ActivityMapSPTip" .. var0_82.id, 0)
end

function var0_0.SetActivityMapSPTip()
	local var0_83 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetInt("ActivityMapSPTip" .. var0_83.id, GetZeroTime())
	PlayerPrefs.Save()
end

function var0_0.IsTipNewTheme(arg0_84)
	local var0_84 = pg.backyard_theme_template
	local var1_84 = var0_84.all[#var0_84.all]
	local var2_84 = var0_84[var1_84].ids[1]
	local var3_84 = pg.furniture_shop_template[var2_84]
	local var4_84 = getProxy(PlayerProxy):getRawData().id
	local var5_84 = PlayerPrefs.GetInt(var4_84 .. "IsTipNewTheme" .. var1_84, 0) == 0

	if var3_84 and var3_84.new == 1 and pg.TimeMgr.GetInstance():inTime(var3_84.time) and var5_84 then
		arg0_84.lastThemeId = var1_84
	else
		arg0_84.lastThemeId = nil
	end

	return arg0_84.lastThemeId ~= nil
end

function var0_0.UpdateNewThemeValue(arg0_85)
	if arg0_85.lastThemeId then
		local var0_85 = arg0_85.lastThemeId
		local var1_85 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt(var1_85 .. "IsTipNewTheme" .. var0_85, 1)
		PlayerPrefs.Save()
	end
end

function var0_0.GetNewGemFurnitureLocalCache(arg0_86)
	if not arg0_86.cacheGemFuruitures then
		arg0_86.cacheGemFuruitures = {}

		local var0_86 = getProxy(PlayerProxy):getRawData().id
		local var1_86 = PlayerPrefs.GetString(var0_86 .. "IsTipNewGenFurniture")

		if var1_86 ~= "" then
			local var2_86 = string.split(var1_86, "#")

			for iter0_86, iter1_86 in ipairs(var2_86) do
				arg0_86.cacheGemFuruitures[tonumber(iter1_86)] = true
			end
		end
	end

	return arg0_86.cacheGemFuruitures
end

function var0_0.IsTipNewGemFurniture(arg0_87)
	local var0_87 = arg0_87:GetNewGemFurnitureLocalCache()
	local var1_87 = getProxy(DormProxy):GetTag7Furnitures()

	if _.any(var1_87, function(arg0_88)
		return pg.furniture_shop_template[arg0_88].new == 1 and not var0_87[arg0_88]
	end) then
		arg0_87.newGemFurniture = var1_87
	else
		arg0_87.newGemFurniture = nil
	end

	return arg0_87.newGemFurniture ~= nil
end

function var0_0.UpdateNewGemFurnitureValue(arg0_89)
	if arg0_89.newGemFurniture then
		for iter0_89, iter1_89 in pairs(arg0_89.newGemFurniture) do
			arg0_89.cacheGemFuruitures[iter1_89] = true
		end

		local var0_89 = table.concat(arg0_89.newGemFurniture, "#")
		local var1_89 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString(var1_89 .. "IsTipNewGenFurniture", var0_89)
		PlayerPrefs.Save()
	end
end

function var0_0.GetRandomFlagShipList(arg0_90)
	if arg0_90.randomFlagShipList then
		return arg0_90.randomFlagShipList
	end

	local var0_90 = getProxy(PlayerProxy):getRawData().id
	local var1_90 = PlayerPrefs.GetString("RandomFlagShipList" .. var0_90, "")
	local var2_90 = string.split(var1_90, "#")

	arg0_90.randomFlagShipList = _.map(var2_90, function(arg0_91)
		return tonumber(arg0_91)
	end)

	return arg0_90.randomFlagShipList
end

function var0_0.IsRandomFlagShip(arg0_92, arg1_92)
	if not arg0_92.randomFlagShipMap then
		arg0_92.randomFlagShipMap = {}

		for iter0_92, iter1_92 in ipairs(arg0_92:GetRandomFlagShipList()) do
			arg0_92.randomFlagShipMap[iter1_92] = true
		end
	end

	return arg0_92.randomFlagShipMap[arg1_92] == true
end

function var0_0.IsOpenRandomFlagShip(arg0_93)
	local var0_93 = arg0_93:GetRandomFlagShipList()
	local var1_93 = getProxy(BayProxy)

	return #var0_93 > 0 and _.any(var0_93, function(arg0_94)
		return var1_93:RawGetShipById(arg0_94) ~= nil
	end)
end

function var0_0.UpdateRandomFlagShipList(arg0_95, arg1_95)
	arg0_95.randomFlagShipMap = nil
	arg0_95.randomFlagShipList = arg1_95

	local var0_95 = table.concat(arg1_95, "#")
	local var1_95 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("RandomFlagShipList" .. var1_95, var0_95)
	PlayerPrefs.Save()
end

function var0_0.GetPrevRandomFlagShipTime(arg0_96)
	if arg0_96.prevRandomFlagShipTime then
		return arg0_96.prevRandomFlagShipTime
	end

	local var0_96 = getProxy(PlayerProxy):getRawData().id

	arg0_96.prevRandomFlagShipTime = PlayerPrefs.GetInt("RandomFlagShipTime" .. var0_96, 0)

	return arg0_96.prevRandomFlagShipTime
end

function var0_0.SetPrevRandomFlagShipTime(arg0_97, arg1_97)
	if arg0_97.prevRandomFlagShipTime == arg1_97 then
		return
	end

	arg0_97.prevRandomFlagShipTime = arg1_97

	local var0_97 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("RandomFlagShipTime" .. var0_97, arg1_97)
	PlayerPrefs.Save()
end

function var0_0.GetFlagShipDisplayMode(arg0_98)
	if not arg0_98.flagShipDisplayMode then
		local var0_98 = getProxy(PlayerProxy):getRawData().id

		arg0_98.flagShipDisplayMode = PlayerPrefs.GetInt("flag-ship-display-mode" .. var0_98, FlAG_SHIP_DISPLAY_ALL)
	end

	return arg0_98.flagShipDisplayMode
end

function var0_0.SetFlagShipDisplayMode(arg0_99, arg1_99)
	if arg0_99.flagShipDisplayMode ~= arg1_99 then
		arg0_99.flagShipDisplayMode = arg1_99

		local var0_99 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("flag-ship-display-mode" .. var0_99, arg1_99)
		PlayerPrefs.Save()
	end
end

function var0_0.RecordContinuousOperationAutoSubStatus(arg0_100, arg1_100)
	if arg1_100 then
		return
	end

	local var0_100 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("AutoBotCOFlag" .. var0_100, 1)
	PlayerPrefs.Save()
end

function var0_0.ResetContinuousOperationAutoSub(arg0_101)
	local var0_101 = getProxy(PlayerProxy):getRawData().id

	if PlayerPrefs.GetInt("AutoBotCOFlag" .. var0_101, 0) == 0 then
		return
	end

	pg.m02:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = true,
		system = SYSTEM_ACT_BOSS
	})
	PlayerPrefs.SetInt("AutoBotCOFlag" .. var0_101, 0)
	PlayerPrefs.Save()
end

function var0_0.SetWorkbenchDailyTip(arg0_102)
	local var0_102 = getProxy(PlayerProxy):getRawData().id
	local var1_102 = GetZeroTime()

	PlayerPrefs.SetInt("WorkbenchDailyTip" .. var0_102, var1_102)
	PlayerPrefs.Save()
end

function var0_0.IsTipWorkbenchDaily(arg0_103)
	local var0_103 = getProxy(PlayerProxy):getRawData().id

	return pg.TimeMgr.GetInstance():GetServerTime() > PlayerPrefs.GetInt("WorkbenchDailyTip" .. var0_103, 0)
end

function var0_0.IsDisplayResultPainting(arg0_104)
	local var0_104 = PlayerPrefs.HasKey(BATTLERESULT_SKIP_DISPAY_PAINTING)
	local var1_104 = false

	if var0_104 then
		var1_104 = PlayerPrefs.GetInt(BATTLERESULT_SKIP_DISPAY_PAINTING) <= 0

		PlayerPrefs.DeleteKey(BATTLERESULT_SKIP_DISPAY_PAINTING)
		PlayerPrefs.SetInt(BATTLERESULT_DISPAY_PAINTING, var1_104 and 1 or 0)
		PlayerPrefs.Save()
	else
		var1_104 = PlayerPrefs.GetInt(BATTLERESULT_DISPAY_PAINTING, 0) >= 1
	end

	return var1_104
end

function var0_0.IsDisplayCommanderCatCustomName(arg0_105)
	if not arg0_105.customFlag then
		local var0_105 = getProxy(PlayerProxy):getRawData().id

		arg0_105.customFlag = PlayerPrefs.GetInt("DisplayCommanderCatCustomName" .. var0_105, 0) == 0
	end

	return arg0_105.customFlag
end

function var0_0.SetDisplayCommanderCatCustomName(arg0_106, arg1_106)
	if arg1_106 == arg0_106.customFlag then
		return
	end

	arg0_106.customFlag = arg1_106

	local var0_106 = arg0_106.customFlag and 0 or 1
	local var1_106 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("DisplayCommanderCatCustomName" .. var1_106, var0_106)
	PlayerPrefs.Save()
end

function var0_0.GetCommanderQuicklyToolRarityConfig(arg0_107)
	if not arg0_107.quicklyToolRarityConfig then
		local var0_107 = getProxy(PlayerProxy):getRawData().id
		local var1_107 = PlayerPrefs.GetString("CommanderQuicklyToolRarityConfig" .. var0_107, "1#1#1")
		local var2_107 = string.split(var1_107, "#")

		arg0_107.quicklyToolRarityConfig = _.map(var2_107, function(arg0_108)
			return tonumber(arg0_108) == 1
		end)
	end

	return arg0_107.quicklyToolRarityConfig
end

function var0_0.SaveCommanderQuicklyToolRarityConfig(arg0_109, arg1_109)
	local var0_109 = false

	for iter0_109, iter1_109 in ipairs(arg0_109.quicklyToolRarityConfig) do
		if arg1_109[iter0_109] ~= iter1_109 then
			var0_109 = true

			break
		end
	end

	if var0_109 then
		arg0_109.quicklyToolRarityConfig = arg1_109

		local var1_109 = _.map(arg0_109.quicklyToolRarityConfig, function(arg0_110)
			return arg0_110 and "1" or "0"
		end)
		local var2_109 = table.concat(var1_109, "#")
		local var3_109 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("CommanderQuicklyToolRarityConfig" .. var3_109, var2_109)
		PlayerPrefs.Save()
	end
end

function var0_0.GetCommanderLockFlagRarityConfig(arg0_111)
	if not arg0_111.lockFlagRarityConfig then
		local var0_111 = getProxy(PlayerProxy):getRawData().id
		local var1_111 = PlayerPrefs.GetString("CommanderLockFlagRarityConfig_" .. var0_111, "1#0#0")
		local var2_111 = string.split(var1_111, "#")

		arg0_111.lockFlagRarityConfig = _.map(var2_111, function(arg0_112)
			return tonumber(arg0_112) == 1
		end)
	end

	return arg0_111.lockFlagRarityConfig
end

function var0_0.SaveCommanderLockFlagRarityConfig(arg0_113, arg1_113)
	local var0_113 = false

	for iter0_113, iter1_113 in ipairs(arg0_113.lockFlagRarityConfig) do
		if arg1_113[iter0_113] ~= iter1_113 then
			var0_113 = true

			break
		end
	end

	if var0_113 then
		arg0_113.lockFlagRarityConfig = arg1_113

		local var1_113 = _.map(arg0_113.lockFlagRarityConfig, function(arg0_114)
			return arg0_114 and "1" or "0"
		end)
		local var2_113 = table.concat(var1_113, "#")
		local var3_113 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("CommanderLockFlagRarityConfig_" .. var3_113, var2_113)
		PlayerPrefs.Save()
	end
end

function var0_0.GetCommanderLockFlagTalentConfig(arg0_115)
	if not arg0_115.lockFlagTalentConfig then
		local var0_115 = getProxy(PlayerProxy):getRawData().id
		local var1_115 = PlayerPrefs.GetString("CommanderLockFlagTalentConfig" .. var0_115, "")
		local var2_115 = {}

		if var1_115 == "" then
			for iter0_115, iter1_115 in ipairs(CommanderCatUtil.GetAllTalentNames()) do
				var2_115[iter1_115.id] = true
			end
		else
			for iter2_115, iter3_115 in ipairs(string.split(var1_115, "#")) do
				local var3_115 = string.split(iter3_115, "*")

				if #var3_115 == 2 then
					var2_115[tonumber(var3_115[1])] = tonumber(var3_115[2]) == 1
				end
			end
		end

		arg0_115.lockFlagTalentConfig = var2_115
	end

	return arg0_115.lockFlagTalentConfig
end

function var0_0.SaveCommanderLockFlagTalentConfig(arg0_116, arg1_116)
	arg0_116.lockFlagTalentConfig = arg1_116

	local var0_116 = {}

	for iter0_116, iter1_116 in pairs(arg1_116) do
		table.insert(var0_116, iter0_116 .. "*" .. (iter1_116 and "1" or "0"))
	end

	local var1_116 = table.concat(var0_116, "#")
	local var2_116 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("CommanderLockFlagTalentConfig" .. var2_116, var1_116)
	PlayerPrefs.Save()
end

function var0_0.GetMainPaintingVariantFlag(arg0_117, arg1_117)
	if not arg0_117.mainPaintingVariantFlag then
		arg0_117.mainPaintingVariantFlag = {}
	end

	if not arg0_117.mainPaintingVariantFlag[arg1_117] then
		local var0_117 = getProxy(PlayerProxy):getRawData().id
		local var1_117 = PlayerPrefs.GetInt(arg1_117 .. "_mainMeshImagePainting_ex_" .. var0_117, 0)

		arg0_117.mainPaintingVariantFlag[arg1_117] = var1_117
	end

	return arg0_117.mainPaintingVariantFlag[arg1_117]
end

function var0_0.SwitchMainPaintingVariantFlag(arg0_118, arg1_118)
	local var0_118 = 1 - arg0_118:GetMainPaintingVariantFlag(arg1_118)

	arg0_118.mainPaintingVariantFlag[arg1_118] = var0_118

	local var1_118 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(arg1_118 .. "_mainMeshImagePainting_ex_" .. var1_118, var0_118)
	PlayerPrefs.Save()
end

function var0_0.IsTipDay(arg0_119, arg1_119, arg2_119, arg3_119)
	local var0_119 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_119 .. "educate_char_" .. arg1_119 .. arg2_119 .. arg3_119, 0) == 1
end

function var0_0.RecordTipDay(arg0_120, arg1_120, arg2_120, arg3_120)
	local var0_120 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_120 .. "educate_char_" .. arg1_120 .. arg2_120 .. arg3_120, 1)
	PlayerPrefs.Save()
end

function var0_0.UpdateEducateCharTip(arg0_121, arg1_121)
	local var0_121 = getProxy(PlayerProxy):getRawData().id
	local var1_121 = NewEducateHelper.GetAllUnlockSecretaryIds()
	local var2_121 = {}

	for iter0_121, iter1_121 in ipairs(arg1_121 or {}) do
		var2_121[iter1_121] = true
	end

	for iter2_121, iter3_121 in ipairs(var1_121 or {}) do
		local var3_121 = var0_121 .. "educate_char_tip" .. iter3_121

		if var2_121[iter3_121] ~= true then
			PlayerPrefs.SetInt(var3_121, 1)
			PlayerPrefs.Save()
		end
	end

	arg0_121:RefillEducateCharTipList()
end

function var0_0.RefillEducateCharTipList(arg0_122)
	local var0_122 = getProxy(PlayerProxy):getRawData().id

	arg0_122.educateCharTipList = {}

	if LOCK_EDUCATE_SYSTEM then
		return
	end

	local var1_122 = NewEducateHelper.GetAllUnlockSecretaryIds()

	for iter0_122, iter1_122 in ipairs(var1_122 or {}) do
		if PlayerPrefs.GetInt(var0_122 .. "educate_char_tip" .. iter1_122, 0) == 1 then
			table.insert(arg0_122.educateCharTipList, iter1_122)
		end
	end
end

function var0_0.ShouldEducateCharTip(arg0_123)
	if NewEducateHelper.GetEducateCharSlotMaxCnt() == 0 then
		return false
	end

	if not arg0_123.educateCharTipList or #arg0_123.educateCharTipList == 0 then
		arg0_123:RefillEducateCharTipList()
	end

	return _.any(arg0_123.educateCharTipList, function(arg0_124)
		return NewEducateHelper.IsUnlockDefaultShip(arg0_124)
	end)
end

function var0_0._ShouldEducateCharTip(arg0_125, arg1_125)
	if not arg0_125.educateCharTipList or #arg0_125.educateCharTipList == 0 then
		arg0_125:RefillEducateCharTipList()
	end

	if table.contains(arg0_125.educateCharTipList, arg1_125) and NewEducateHelper.IsUnlockDefaultShip(arg1_125) then
		return true
	end

	return false
end

function var0_0.ClearEducateCharTip(arg0_126, arg1_126)
	if not arg0_126:_ShouldEducateCharTip(arg1_126) then
		return false
	end

	table.removebyvalue(arg0_126.educateCharTipList, arg1_126)

	local var0_126 = getProxy(PlayerProxy):getRawData().id .. "educate_char_tip" .. arg1_126

	if PlayerPrefs.HasKey(var0_126) then
		PlayerPrefs.DeleteKey(var0_126)
		PlayerPrefs.Save()
	end

	pg.m02:sendNotification(GAME.CLEAR_EDUCATE_TIP, {
		id = arg1_126
	})

	return true
end

function var0_0.GetMainSceneThemeStyle(arg0_127)
	if PlayerPrefs.GetInt(USAGE_NEW_MAINUI, 1) == 1 then
		return NewMainScene.THEME_MELLOW
	else
		return NewMainScene.THEME_CLASSIC
	end
end

function var0_0.IsMellowStyle(arg0_128)
	local var0_128 = arg0_128:GetMainSceneThemeStyle()

	return NewMainScene.THEME_MELLOW == var0_128
end

function var0_0.GetMainSceneScreenSleepTime(arg0_129)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		return SleepTimeout.SystemSetting
	end

	local var0_129 = pg.settings_other_template[20].name

	if PlayerPrefs.GetInt(var0_129, 1) == 1 then
		return SleepTimeout.NeverSleep
	else
		return SleepTimeout.SystemSetting
	end
end

function var0_0.ShowL2dResetInMainScene(arg0_130)
	local var0_130 = pg.settings_other_template[21].name

	return PlayerPrefs.GetInt(var0_130, 0) == 1
end

function var0_0.Reset(arg0_131)
	arg0_131:resetEquipSceneIndex()
	arg0_131:resetActivityLayerIndex()

	arg0_131.isStopBuildSpeedupReamind = false

	arg0_131:RestoreFrameRate()

	arg0_131.randomFlagShipList = nil
	arg0_131.prevRandomFlagShipTime = nil
	arg0_131.randomFlagShipMap = nil
	arg0_131.educateCharTipList = {}
end

return var0_0
