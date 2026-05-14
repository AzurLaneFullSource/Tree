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
	arg0_1._setFlagRandom = PlayerPrefs.GetInt("setFlagRandom", 0) > 0
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

function var0_0.SetFlagRandom(arg0_31, arg1_31)
	if arg0_31._setFlagRandom ~= arg1_31 then
		arg0_31._setFlagRandom = arg1_31

		PlayerPrefs.SetInt("setFlagRandom", arg1_31 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.GetFlagRandom(arg0_32)
	return arg0_32._setFlagRandom
end

function var0_0.CheckNeedUserAgreement(arg0_33)
	if PLATFORM_CODE == PLATFORM_KR then
		return false
	elseif PLATFORM_CODE == PLATFORM_CH then
		return false
	elseif PLATFORM_CODE == PLATFORM_JP then
		return false
	else
		return arg0_33:GetUserAgreementFlag() > arg0_33._userAgreement
	end
end

function var0_0.GetUserAgreementFlag(arg0_34)
	local var0_34 = USER_AGREEMENT_FLAG_DEFAULT

	if PLATFORM_CODE == PLATFORM_CHT then
		var0_34 = USER_AGREEMENT_FLAG_TW
	end

	return var0_34
end

function var0_0.SetUserAgreement(arg0_35)
	if arg0_35:CheckNeedUserAgreement() then
		local var0_35 = arg0_35:GetUserAgreementFlag()

		PlayerPrefs.SetInt("userAgreement", var0_35)
		PlayerPrefs.Save()

		arg0_35._userAgreement = var0_35
	end
end

function var0_0.IsLive2dEnable(arg0_36)
	return arg0_36._ShowLive2d
end

function var0_0.IsBGEnable(arg0_37)
	return arg0_37._ShowBg
end

function var0_0.SetSelectedShipId(arg0_38, arg1_38)
	if arg0_38._selectedShipId ~= arg1_38 then
		arg0_38._selectedShipId = arg1_38

		PlayerPrefs.SetInt("playerShipId", arg1_38)
		PlayerPrefs.Save()
	end
end

function var0_0.GetSelectedShipId(arg0_39)
	return arg0_39._selectedShipId
end

function var0_0.setEquipSceneIndex(arg0_40, arg1_40)
	arg0_40._equipSceneIndex = arg1_40
end

function var0_0.getEquipSceneIndex(arg0_41)
	return arg0_41._equipSceneIndex
end

function var0_0.resetEquipSceneIndex(arg0_42)
	arg0_42._equipSceneIndex = StoreHouseConst.WARP_TO_MATERIAL
end

function var0_0.setActivityLayerIndex(arg0_43, arg1_43)
	arg0_43._activityLayerIndex = arg1_43
end

function var0_0.getActivityLayerIndex(arg0_44)
	return arg0_44._activityLayerIndex
end

function var0_0.resetActivityLayerIndex(arg0_45)
	arg0_45._activityLayerIndex = 1
end

function var0_0.setBackyardRemind(arg0_46)
	local var0_46 = GetZeroTime()

	if arg0_46._backyardFoodRemind ~= tostring(var0_46) then
		PlayerPrefs.SetString("backyardRemind", var0_46)
		PlayerPrefs.Save()

		arg0_46._backyardFoodRemind = var0_46
	end
end

function var0_0.getBackyardRemind(arg0_47)
	if not arg0_47._backyardFoodRemind or arg0_47._backyardFoodRemind == "" then
		return 0
	else
		return tonumber(arg0_47._backyardFoodRemind)
	end
end

function var0_0.getMaxLevelHelp(arg0_48)
	return arg0_48._showMaxLevelHelp
end

function var0_0.setMaxLevelHelp(arg0_49, arg1_49)
	if arg0_49._showMaxLevelHelp ~= arg1_49 then
		arg0_49._showMaxLevelHelp = arg1_49

		PlayerPrefs.SetInt("maxLevelHelp", arg1_49 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.setStopBuildSpeedupRemind(arg0_50)
	arg0_50.isStopBuildSpeedupReamind = true
end

function var0_0.getStopBuildSpeedupRemind(arg0_51)
	return arg0_51.isStopBuildSpeedupReamind
end

function var0_0.checkReadHelp(arg0_52, arg1_52)
	if not getProxy(PlayerProxy):getData() then
		return true
	end

	if arg1_52 == "help_backyard" then
		return true
	elseif pg.SeriesGuideMgr.GetInstance():isEnd() then
		local var0_52 = PlayerPrefs.GetInt(arg1_52, 0)

		return PlayerPrefs.GetInt(arg1_52, 0) > 0
	end

	return true
end

function var0_0.recordReadHelp(arg0_53, arg1_53)
	PlayerPrefs.SetInt(arg1_53, 1)
	PlayerPrefs.Save()
end

function var0_0.clearAllReadHelp(arg0_54)
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
	PlayerPrefs.DeleteKey("loveactivity_help_tips")
end

function var0_0.setAutoBattleTip(arg0_55)
	local var0_55 = GetZeroTime()

	arg0_55._nextTipAutoBattleTime = var0_55

	PlayerPrefs.SetInt("AutoBattleTip", var0_55)
	PlayerPrefs.Save()
end

function var0_0.isTipAutoBattle(arg0_56)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_56._nextTipAutoBattleTime
end

function var0_0.setActBossExchangeTicketTip(arg0_57, arg1_57)
	if arg0_57.nextTipActBossExchangeTicket == arg1_57 then
		return
	end

	arg0_57.nextTipActBossExchangeTicket = arg1_57

	local var0_57 = GetZeroTime()

	if var0_57 > arg0_57._nextTipActBossTime then
		arg0_57._nextTipActBossTime = var0_57

		PlayerPrefs.SetInt("ActBossTipLastTime", var0_57)
	end

	PlayerPrefs.SetInt("ActBossTip", arg1_57)
	PlayerPrefs.Save()
end

function var0_0.isTipActBossExchangeTicket(arg0_58)
	if pg.TimeMgr.GetInstance():GetServerTime() > arg0_58._nextTipActBossTime then
		return nil
	end

	return arg0_58.nextTipActBossExchangeTicket
end

function var0_0.SetScreenRatio(arg0_59, arg1_59)
	if arg0_59._screenRatio ~= arg1_59 then
		arg0_59._screenRatio = arg1_59

		PlayerPrefs.SetFloat("SetScreenRatio", arg1_59)
		PlayerPrefs.Save()
	end
end

function var0_0.GetScreenRatio(arg0_60)
	return arg0_60._screenRatio
end

function var0_0.CheckLargeScreen(arg0_61)
	return Screen.width / Screen.height > 2
end

function var0_0.IsShowBeatMonseterNianCurtain(arg0_62)
	local var0_62 = getProxy(PlayerProxy):getRawData()

	return pg.TimeMgr.GetInstance():GetServerTime() > tonumber(PlayerPrefs.GetString("HitMonsterNianLayer2020" .. var0_62.id, "0"))
end

function var0_0.SetBeatMonseterNianFlag(arg0_63)
	local var0_63 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetString("HitMonsterNianLayer2020" .. var0_63.id, GetZeroTime())
	PlayerPrefs.Save()
end

function var0_0.ShouldShowEventActHelp(arg0_64)
	if not arg0_64.actEventFlag then
		local var0_64 = getProxy(PlayerProxy):getRawData().id

		arg0_64.actEventFlag = PlayerPrefs.GetInt("event_act_help1" .. var0_64, 0) > 0
	end

	return not arg0_64.actEventFlag
end

function var0_0.MarkEventActHelpFlag(arg0_65)
	if not arg0_65.actEventFlag then
		arg0_65.actEventFlag = true

		local var0_65 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("event_act_help1" .. var0_65, 1)
		PlayerPrefs.Save()
	end
end

function var0_0.SetStorySpeed(arg0_66, arg1_66)
	arg0_66.storySpeed = arg1_66

	local var0_66

	if getProxy(PlayerProxy) then
		var0_66 = getProxy(PlayerProxy):getRawData().id
	else
		var0_66 = 1
	end

	PlayerPrefs.SetInt("story_speed_flag" .. var0_66, arg1_66)
	PlayerPrefs.Save()
end

function var0_0.GetStorySpeed(arg0_67)
	if not arg0_67.storySpeed then
		local var0_67

		if getProxy(PlayerProxy) then
			var0_67 = getProxy(PlayerProxy):getRawData().id
		else
			var0_67 = 1
		end

		arg0_67.storySpeed = PlayerPrefs.GetInt("story_speed_flag" .. var0_67, 0)
	end

	return arg0_67.storySpeed
end

function var0_0.GetStoryAutoPlayFlag(arg0_68)
	return arg0_68.storyAutoPlayCode > 0
end

function var0_0.SetStoryAutoPlayFlag(arg0_69, arg1_69)
	if arg0_69.storyAutoPlayCode ~= arg1_69 then
		PlayerPrefs.SetInt("story_autoplay_flag", arg1_69)
		PlayerPrefs.Save()

		arg0_69.storyAutoPlayCode = arg1_69
	end
end

function var0_0.GetPaintingDownloadPrefs(arg0_70)
	return PlayerPrefs.GetInt("Painting_Download_Prefs", 0)
end

function var0_0.SetPaintingDownloadPrefs(arg0_71, arg1_71)
	PlayerPrefs.SetInt("Painting_Download_Prefs", arg1_71)
end

function var0_0.ShouldShipMainSceneWord(arg0_72)
	return arg0_72.showMainSceneWordTip
end

function var0_0.SaveMainSceneWordFlag(arg0_73, arg1_73)
	if arg0_73.showMainSceneWordTip ~= arg1_73 then
		arg0_73.showMainSceneWordTip = arg1_73

		PlayerPrefs.SetInt("main_scene_word_toggle", arg1_73 and 1 or 0)
		PlayerPrefs.Save()
	end
end

function var0_0.RecordFrameRate(arg0_74)
	if not arg0_74.originalFrameRate then
		arg0_74.originalFrameRate = Application.targetFrameRate
	end
end

function var0_0.RestoreFrameRate(arg0_75)
	if arg0_75.originalFrameRate then
		Application.targetFrameRate = arg0_75.originalFrameRate
		arg0_75.originalFrameRate = nil
	end
end

function var0_0.ResetTimeLimitSkinShopTip(arg0_76)
	arg0_76.isTipLimitSkinShop = PlayerPrefs.GetInt("tipLimitSkinShopTime_", 0) <= pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_76.isTipLimitSkinShop then
		arg0_76.nextTipLimitSkinShopTime = GetZeroTime()
	end
end

function var0_0.ShouldTipTimeLimitSkinShop(arg0_77)
	return arg0_77.isTipLimitSkinShop
end

function var0_0.SetNextTipTimeLimitSkinShop(arg0_78)
	if arg0_78.isTipLimitSkinShop and arg0_78.nextTipLimitSkinShopTime then
		PlayerPrefs.SetInt("tipLimitSkinShopTime_", arg0_78.nextTipLimitSkinShopTime)
		PlayerPrefs.Save()

		arg0_78.nextTipLimitSkinShopTime = nil
		arg0_78.isTipLimitSkinShop = false
	end
end

function var0_0.WorldBossProgressTipFlag(arg0_79, arg1_79)
	if arg0_79.WorldBossProgressTipValue ~= arg1_79 then
		arg0_79.WorldBossProgressTipValue = arg1_79

		PlayerPrefs.SetString("_WorldBossProgressTipFlag_", arg1_79)
		PlayerPrefs.Save()
	end
end

function var0_0.GetWorldBossProgressTipFlag(arg0_80)
	if not arg0_80.WorldBossProgressTipValue then
		local var0_80 = pg.gameset.joint_boss_ticket.description
		local var1_80 = var0_80[1] + var0_80[2]
		local var2_80 = var0_80[1] .. "&" .. var1_80
		local var3_80 = PlayerPrefs.GetString("_WorldBossProgressTipFlag_", var2_80)

		arg0_80.WorldBossProgressTipValue = var3_80

		return var3_80
	else
		return arg0_80.WorldBossProgressTipValue
	end
end

function var0_0.GetWorldBossProgressTipTable(arg0_81)
	local var0_81 = arg0_81:GetWorldBossProgressTipFlag()

	if not var0_81 or var0_81 == "" then
		return {}
	end

	return string.split(var0_81, "&")
end

function var0_0.GetChatFlag(arg0_82)
	if not arg0_82.chatFlag then
		local var0_82 = {
			ChatConst.ChannelWorld,
			ChatConst.ChannelPublic,
			ChatConst.ChannelFriend
		}

		if getProxy(GuildProxy):getRawData() then
			table.insert(var0_82, ChatConst.ChannelGuild)
		end

		arg0_82.chatFlag = PlayerPrefs.GetInt("chat__setting", IndexConst.Flags2Bits(var0_82))
	end

	return arg0_82.chatFlag
end

function var0_0.SetChatFlag(arg0_83, arg1_83)
	if arg0_83.chatFlag ~= arg1_83 then
		arg0_83.chatFlag = arg1_83

		PlayerPrefs.SetInt("chat__setting", arg1_83)
		PlayerPrefs.Save()
	end
end

function var0_0.IsShowActivityMapSPTip()
	local var0_84 = getProxy(PlayerProxy):getRawData()

	return pg.TimeMgr.GetInstance():GetServerTime() > PlayerPrefs.GetInt("ActivityMapSPTip" .. var0_84.id, 0)
end

function var0_0.SetActivityMapSPTip()
	local var0_85 = getProxy(PlayerProxy):getRawData()

	PlayerPrefs.SetInt("ActivityMapSPTip" .. var0_85.id, GetZeroTime())
	PlayerPrefs.Save()
end

function var0_0.IsTipNewTheme(arg0_86)
	local var0_86 = pg.backyard_theme_template
	local var1_86 = var0_86.all[#var0_86.all]
	local var2_86 = var0_86[var1_86].ids[1]
	local var3_86 = pg.furniture_shop_template[var2_86]
	local var4_86 = getProxy(PlayerProxy):getRawData().id
	local var5_86 = PlayerPrefs.GetInt(var4_86 .. "IsTipNewTheme" .. var1_86, 0) == 0

	if var3_86 and var3_86.new == 1 and pg.TimeMgr.GetInstance():inTime(var3_86.time) and var5_86 then
		arg0_86.lastThemeId = var1_86
	else
		arg0_86.lastThemeId = nil
	end

	return arg0_86.lastThemeId ~= nil
end

function var0_0.UpdateNewThemeValue(arg0_87)
	if arg0_87.lastThemeId then
		local var0_87 = arg0_87.lastThemeId
		local var1_87 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt(var1_87 .. "IsTipNewTheme" .. var0_87, 1)
		PlayerPrefs.Save()
	end
end

function var0_0.GetNewGemFurnitureLocalCache(arg0_88)
	if not arg0_88.cacheGemFuruitures then
		arg0_88.cacheGemFuruitures = {}

		local var0_88 = getProxy(PlayerProxy):getRawData().id
		local var1_88 = PlayerPrefs.GetString(var0_88 .. "IsTipNewGenFurniture")

		if var1_88 ~= "" then
			local var2_88 = string.split(var1_88, "#")

			for iter0_88, iter1_88 in ipairs(var2_88) do
				arg0_88.cacheGemFuruitures[tonumber(iter1_88)] = true
			end
		end
	end

	return arg0_88.cacheGemFuruitures
end

function var0_0.IsTipNewGemFurniture(arg0_89)
	local var0_89 = arg0_89:GetNewGemFurnitureLocalCache()
	local var1_89 = getProxy(DormProxy):GetTag7Furnitures()

	if _.any(var1_89, function(arg0_90)
		return pg.furniture_shop_template[arg0_90].new == 1 and not var0_89[arg0_90]
	end) then
		arg0_89.newGemFurniture = var1_89
	else
		arg0_89.newGemFurniture = nil
	end

	return arg0_89.newGemFurniture ~= nil
end

function var0_0.UpdateNewGemFurnitureValue(arg0_91)
	if arg0_91.newGemFurniture then
		for iter0_91, iter1_91 in pairs(arg0_91.newGemFurniture) do
			arg0_91.cacheGemFuruitures[iter1_91] = true
		end

		local var0_91 = table.concat(arg0_91.newGemFurniture, "#")
		local var1_91 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString(var1_91 .. "IsTipNewGenFurniture", var0_91)
		PlayerPrefs.Save()
	end
end

function var0_0.GetRandomFlagShipList(arg0_92)
	if arg0_92.randomFlagShipList then
		return arg0_92.randomFlagShipList
	end

	local var0_92 = getProxy(PlayerProxy):getRawData().id
	local var1_92 = PlayerPrefs.GetString("RandomFlagShipList" .. var0_92, "")

	if var1_92 == "" then
		arg0_92.randomFlagShipList = {}
	else
		arg0_92.randomFlagShipList = string.split(var1_92, "#")
	end

	return arg0_92.randomFlagShipList
end

function var0_0.IsRandomFlagShip(arg0_93, arg1_93)
	if not arg0_93.randomFlagShipMap then
		arg0_93.randomFlagShipMap = {}

		for iter0_93, iter1_93 in ipairs(arg0_93:GetRandomFlagShipList()) do
			arg0_93.randomFlagShipMap[iter1_93] = true
		end
	end

	return arg0_93.randomFlagShipMap[arg1_93] == true
end

function var0_0.IsOpenRandomFlagShip(arg0_94)
	local var0_94 = arg0_94:GetRandomFlagShipList()
	local var1_94 = getProxy(BayProxy)

	return #var0_94 > 0 and _.any(var0_94, function(arg0_95)
		local var0_95, var1_95 = ShipPhantom.UnpackMark(arg0_95)

		return var1_94:RawGetShipById(var0_95) ~= nil
	end)
end

function var0_0.UpdateRandomFlagShipList(arg0_96, arg1_96)
	arg0_96.randomFlagShipMap = nil
	arg0_96.randomFlagShipList = arg1_96

	for iter0_96, iter1_96 in ipairs(arg1_96) do
		local var0_96 = getProxy(BayProxy):GetShipPhantom(iter1_96)

		if var0_96 and var0_96.phantomId > 0 then
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPhantom(var0_96:getSkinId()))
		end
	end

	local var1_96 = table.concat(arg1_96, "#")
	local var2_96 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("RandomFlagShipList" .. var2_96, var1_96)
	PlayerPrefs.Save()
end

function var0_0.GetPrevRandomFlagShipTime(arg0_97)
	if arg0_97.prevRandomFlagShipTime then
		return arg0_97.prevRandomFlagShipTime
	end

	local var0_97 = getProxy(PlayerProxy):getRawData().id

	arg0_97.prevRandomFlagShipTime = PlayerPrefs.GetInt("RandomFlagShipTime" .. var0_97, 0)

	return arg0_97.prevRandomFlagShipTime
end

function var0_0.SetPrevRandomFlagShipTime(arg0_98, arg1_98)
	if arg0_98.prevRandomFlagShipTime == arg1_98 then
		return
	end

	arg0_98.prevRandomFlagShipTime = arg1_98

	local var0_98 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("RandomFlagShipTime" .. var0_98, arg1_98)
	PlayerPrefs.Save()
end

function var0_0.GetFlagShipDisplayMode(arg0_99)
	if not arg0_99.flagShipDisplayMode then
		local var0_99 = getProxy(PlayerProxy):getRawData().id

		arg0_99.flagShipDisplayMode = PlayerPrefs.GetInt("flag-ship-display-mode" .. var0_99, FlAG_SHIP_DISPLAY_ALL)
	end

	return arg0_99.flagShipDisplayMode
end

function var0_0.SetFlagShipDisplayMode(arg0_100, arg1_100)
	if arg0_100.flagShipDisplayMode ~= arg1_100 then
		arg0_100.flagShipDisplayMode = arg1_100

		local var0_100 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetInt("flag-ship-display-mode" .. var0_100, arg1_100)
		PlayerPrefs.Save()
	end
end

function var0_0.RecordContinuousOperationAutoSubStatus(arg0_101, arg1_101)
	if arg1_101 then
		return
	end

	local var0_101 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("AutoBotCOFlag" .. var0_101, 1)
	PlayerPrefs.Save()
end

function var0_0.ResetContinuousOperationAutoSub(arg0_102)
	local var0_102 = getProxy(PlayerProxy):getRawData().id

	if PlayerPrefs.GetInt("AutoBotCOFlag" .. var0_102, 0) == 0 then
		return
	end

	pg.m02:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = true,
		system = SYSTEM_ACT_BOSS
	})
	PlayerPrefs.SetInt("AutoBotCOFlag" .. var0_102, 0)
	PlayerPrefs.Save()
end

function var0_0.SetWorkbenchDailyTip(arg0_103)
	local var0_103 = getProxy(PlayerProxy):getRawData().id
	local var1_103 = GetZeroTime()

	PlayerPrefs.SetInt("WorkbenchDailyTip" .. var0_103, var1_103)
	PlayerPrefs.Save()
end

function var0_0.IsTipWorkbenchDaily(arg0_104)
	local var0_104 = getProxy(PlayerProxy):getRawData().id

	return pg.TimeMgr.GetInstance():GetServerTime() > PlayerPrefs.GetInt("WorkbenchDailyTip" .. var0_104, 0)
end

function var0_0.IsDisplayResultPainting(arg0_105)
	local var0_105 = PlayerPrefs.HasKey(BATTLERESULT_SKIP_DISPAY_PAINTING)
	local var1_105 = false

	if var0_105 then
		var1_105 = PlayerPrefs.GetInt(BATTLERESULT_SKIP_DISPAY_PAINTING) <= 0

		PlayerPrefs.DeleteKey(BATTLERESULT_SKIP_DISPAY_PAINTING)
		PlayerPrefs.SetInt(BATTLERESULT_DISPAY_PAINTING, var1_105 and 1 or 0)
		PlayerPrefs.Save()
	else
		var1_105 = PlayerPrefs.GetInt(BATTLERESULT_DISPAY_PAINTING, 0) >= 1
	end

	return var1_105
end

function var0_0.IsDisplayCommanderCatCustomName(arg0_106)
	if not arg0_106.customFlag then
		local var0_106 = getProxy(PlayerProxy):getRawData().id

		arg0_106.customFlag = PlayerPrefs.GetInt("DisplayCommanderCatCustomName" .. var0_106, 0) == 0
	end

	return arg0_106.customFlag
end

function var0_0.SetDisplayCommanderCatCustomName(arg0_107, arg1_107)
	if arg1_107 == arg0_107.customFlag then
		return
	end

	arg0_107.customFlag = arg1_107

	local var0_107 = arg0_107.customFlag and 0 or 1
	local var1_107 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("DisplayCommanderCatCustomName" .. var1_107, var0_107)
	PlayerPrefs.Save()
end

function var0_0.GetCommanderQuicklyToolRarityConfig(arg0_108)
	if not arg0_108.quicklyToolRarityConfig then
		local var0_108 = getProxy(PlayerProxy):getRawData().id
		local var1_108 = PlayerPrefs.GetString("CommanderQuicklyToolRarityConfig" .. var0_108, "1#1#1")
		local var2_108 = string.split(var1_108, "#")

		arg0_108.quicklyToolRarityConfig = _.map(var2_108, function(arg0_109)
			return tonumber(arg0_109) == 1
		end)
	end

	return arg0_108.quicklyToolRarityConfig
end

function var0_0.SaveCommanderQuicklyToolRarityConfig(arg0_110, arg1_110)
	local var0_110 = false

	for iter0_110, iter1_110 in ipairs(arg0_110.quicklyToolRarityConfig) do
		if arg1_110[iter0_110] ~= iter1_110 then
			var0_110 = true

			break
		end
	end

	if var0_110 then
		arg0_110.quicklyToolRarityConfig = arg1_110

		local var1_110 = _.map(arg0_110.quicklyToolRarityConfig, function(arg0_111)
			return arg0_111 and "1" or "0"
		end)
		local var2_110 = table.concat(var1_110, "#")
		local var3_110 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("CommanderQuicklyToolRarityConfig" .. var3_110, var2_110)
		PlayerPrefs.Save()
	end
end

function var0_0.GetCommanderLockFlagRarityConfig(arg0_112)
	if not arg0_112.lockFlagRarityConfig then
		local var0_112 = getProxy(PlayerProxy):getRawData().id
		local var1_112 = PlayerPrefs.GetString("CommanderLockFlagRarityConfig_" .. var0_112, "1#0#0")
		local var2_112 = string.split(var1_112, "#")

		arg0_112.lockFlagRarityConfig = _.map(var2_112, function(arg0_113)
			return tonumber(arg0_113) == 1
		end)
	end

	return arg0_112.lockFlagRarityConfig
end

function var0_0.SaveCommanderLockFlagRarityConfig(arg0_114, arg1_114)
	local var0_114 = false

	for iter0_114, iter1_114 in ipairs(arg0_114.lockFlagRarityConfig) do
		if arg1_114[iter0_114] ~= iter1_114 then
			var0_114 = true

			break
		end
	end

	if var0_114 then
		arg0_114.lockFlagRarityConfig = arg1_114

		local var1_114 = _.map(arg0_114.lockFlagRarityConfig, function(arg0_115)
			return arg0_115 and "1" or "0"
		end)
		local var2_114 = table.concat(var1_114, "#")
		local var3_114 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("CommanderLockFlagRarityConfig_" .. var3_114, var2_114)
		PlayerPrefs.Save()
	end
end

function var0_0.GetCommanderLockFlagTalentConfig(arg0_116)
	if not arg0_116.lockFlagTalentConfig then
		local var0_116 = getProxy(PlayerProxy):getRawData().id
		local var1_116 = PlayerPrefs.GetString("CommanderLockFlagTalentConfig" .. var0_116, "")
		local var2_116 = {}

		if var1_116 == "" then
			for iter0_116, iter1_116 in ipairs(CommanderCatUtil.GetAllTalentNames()) do
				var2_116[iter1_116.id] = true
			end
		else
			for iter2_116, iter3_116 in ipairs(string.split(var1_116, "#")) do
				local var3_116 = string.split(iter3_116, "*")

				if #var3_116 == 2 then
					var2_116[tonumber(var3_116[1])] = tonumber(var3_116[2]) == 1
				end
			end
		end

		arg0_116.lockFlagTalentConfig = var2_116
	end

	return arg0_116.lockFlagTalentConfig
end

function var0_0.SaveCommanderLockFlagTalentConfig(arg0_117, arg1_117)
	arg0_117.lockFlagTalentConfig = arg1_117

	local var0_117 = {}

	for iter0_117, iter1_117 in pairs(arg1_117) do
		table.insert(var0_117, iter0_117 .. "*" .. (iter1_117 and "1" or "0"))
	end

	local var1_117 = table.concat(var0_117, "#")
	local var2_117 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("CommanderLockFlagTalentConfig" .. var2_117, var1_117)
	PlayerPrefs.Save()
end

function var0_0.GetMainPaintingVariantFlag(arg0_118, arg1_118)
	if not arg0_118.mainPaintingVariantFlag then
		arg0_118.mainPaintingVariantFlag = {}
	end

	if not arg0_118.mainPaintingVariantFlag[arg1_118] then
		local var0_118 = getProxy(PlayerProxy):getRawData().id
		local var1_118 = PlayerPrefs.GetInt(arg1_118 .. "_mainMeshImagePainting_ex_" .. var0_118, 0)

		arg0_118.mainPaintingVariantFlag[arg1_118] = var1_118
	end

	return arg0_118.mainPaintingVariantFlag[arg1_118]
end

function var0_0.SwitchMainPaintingVariantFlag(arg0_119, arg1_119)
	local var0_119 = 1 - arg0_119:GetMainPaintingVariantFlag(arg1_119)

	arg0_119.mainPaintingVariantFlag[arg1_119] = var0_119

	local var1_119 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(arg1_119 .. "_mainMeshImagePainting_ex_" .. var1_119, var0_119)
	PlayerPrefs.Save()
end

function var0_0.IsTipDay(arg0_120, arg1_120, arg2_120, arg3_120)
	local var0_120 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_120 .. "educate_char_" .. arg1_120 .. arg2_120 .. arg3_120, 0) == 1
end

function var0_0.RecordTipDay(arg0_121, arg1_121, arg2_121, arg3_121)
	local var0_121 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_121 .. "educate_char_" .. arg1_121 .. arg2_121 .. arg3_121, 1)
	PlayerPrefs.Save()
end

function var0_0.UpdateEducateCharTip(arg0_122, arg1_122)
	local var0_122 = getProxy(PlayerProxy):getRawData().id
	local var1_122 = NewEducateHelper.GetAllUnlockSecretaryIds()
	local var2_122 = {}

	for iter0_122, iter1_122 in ipairs(arg1_122 or {}) do
		var2_122[iter1_122] = true
	end

	for iter2_122, iter3_122 in ipairs(var1_122 or {}) do
		local var3_122 = var0_122 .. "educate_char_tip" .. iter3_122

		if var2_122[iter3_122] ~= true then
			PlayerPrefs.SetInt(var3_122, 1)
			PlayerPrefs.Save()
		end
	end

	arg0_122:RefillEducateCharTipList()
end

function var0_0.RefillEducateCharTipList(arg0_123)
	local var0_123 = getProxy(PlayerProxy):getRawData().id

	arg0_123.educateCharTipList = {}

	if LOCK_EDUCATE_SYSTEM then
		return
	end

	local var1_123 = NewEducateHelper.GetAllUnlockSecretaryIds()

	for iter0_123, iter1_123 in ipairs(var1_123 or {}) do
		if PlayerPrefs.GetInt(var0_123 .. "educate_char_tip" .. iter1_123, 0) == 1 then
			table.insert(arg0_123.educateCharTipList, iter1_123)
		end
	end
end

function var0_0.ShouldEducateCharTip(arg0_124)
	if NewEducateHelper.GetEducateCharSlotMaxCnt() == 0 then
		return false
	end

	if not arg0_124.educateCharTipList or #arg0_124.educateCharTipList == 0 then
		arg0_124:RefillEducateCharTipList()
	end

	return _.any(arg0_124.educateCharTipList, function(arg0_125)
		return NewEducateHelper.IsUnlockDefaultShip(arg0_125)
	end)
end

function var0_0._ShouldEducateCharTip(arg0_126, arg1_126)
	if not arg0_126.educateCharTipList or #arg0_126.educateCharTipList == 0 then
		arg0_126:RefillEducateCharTipList()
	end

	if table.contains(arg0_126.educateCharTipList, arg1_126) and NewEducateHelper.IsUnlockDefaultShip(arg1_126) then
		return true
	end

	return false
end

function var0_0.ClearEducateCharTip(arg0_127, arg1_127)
	if not arg0_127:_ShouldEducateCharTip(arg1_127) then
		return false
	end

	table.removebyvalue(arg0_127.educateCharTipList, arg1_127)

	local var0_127 = getProxy(PlayerProxy):getRawData().id .. "educate_char_tip" .. arg1_127

	if PlayerPrefs.HasKey(var0_127) then
		PlayerPrefs.DeleteKey(var0_127)
		PlayerPrefs.Save()
	end

	pg.m02:sendNotification(GAME.CLEAR_EDUCATE_TIP, {
		id = arg1_127
	})

	return true
end

function var0_0.GetMainSceneThemeStyle(arg0_128)
	if PlayerPrefs.GetInt(USAGE_NEW_MAINUI, 1) == 1 then
		return NewMainScene.THEME_MELLOW
	else
		return NewMainScene.THEME_CLASSIC
	end
end

function var0_0.IsMellowStyle(arg0_129)
	local var0_129 = arg0_129:GetMainSceneThemeStyle()

	return NewMainScene.THEME_MELLOW == var0_129
end

function var0_0.GetMainSceneScreenSleepTime(arg0_130)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		return SleepTimeout.SystemSetting
	end

	local var0_130 = pg.settings_other_template[20]

	if PlayerPrefs.GetInt(_G[var0_130.name], var0_130.default) == 1 then
		return SleepTimeout.NeverSleep
	else
		return SleepTimeout.SystemSetting
	end
end

function var0_0.ShowL2dResetInMainScene(arg0_131)
	local var0_131 = pg.settings_other_template[21]

	return PlayerPrefs.GetInt(_G[var0_131.name], var0_131.default) == 1
end

function var0_0.GetRecommendLowEnerySkipEnable(arg0_132)
	local var0_132 = pg.settings_other_template[25]

	return PlayerPrefs.GetInt(_G[var0_132.name], var0_132.default) == 1
end

local var1_0 = "ISLAND_REST_EVENT"

function var0_0.ShouldTipIslandRestEvet(arg0_133)
	local var0_133 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var1_0 .. var0_133, 0) < pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.RecordIslandRestEvet(arg0_134)
	local var0_134 = GetZeroTime()
	local var1_134 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var1_0 .. var1_134, var0_134)
	PlayerPrefs.Save()
end

function var0_0.Reset(arg0_135)
	arg0_135:resetEquipSceneIndex()
	arg0_135:resetActivityLayerIndex()

	arg0_135.isStopBuildSpeedupReamind = false

	arg0_135:RestoreFrameRate()

	arg0_135.randomFlagShipList = nil
	arg0_135.prevRandomFlagShipTime = nil
	arg0_135.randomFlagShipMap = nil
	arg0_135.educateCharTipList = {}
end

function var0_0.IsExchangeCodeActive()
	return getGameset("exchangecode_ios_on")[1] == 1
end

return var0_0
