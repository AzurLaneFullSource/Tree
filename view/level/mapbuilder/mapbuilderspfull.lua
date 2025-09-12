local var0_0 = class("MapBuilderSPFull", import(".MapBuilderSP"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPESPFULL
end

function var0_0.getUIName(arg0_2)
	return "LevelSelectSPFullUI"
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)

	arg0_3.progressText = arg0_3._tf:Find("Story/Desc/Digit")
	arg0_3.mapSwitchList = arg0_3._tf:Find("Battle/MapItems/List")
end

function var0_0.UpdateButtons(arg0_4)
	var0_0.super.UpdateButtons(arg0_4)

	if arg0_4.contextData.displayMode == var0_0.DISPLAY.BATTLE then
		arg0_4:UpdateSwitchMapButtons()
	else
		arg0_4.sceneParent:HideBtns()
	end
end

function var0_0.OnHide(arg0_5)
	arg0_5.sceneParent:HideBtns()
	var0_0.super.OnHide(arg0_5)
end

function var0_0.UpdateBattle(arg0_6)
	local var0_6 = getProxy(ChapterProxy)
	local var1_6 = arg0_6.displayChapterIDs
	local var2_6 = {}

	for iter0_6, iter1_6 in ipairs(var1_6) do
		local var3_6 = var0_6:getChapterById(iter1_6)

		if var3_6:isUnlock() or var3_6:activeAlways() then
			table.insert(var2_6, var3_6)
		end
	end

	table.clear(arg0_6.chapterTFsById)
	UIItemList.StaticAlign(arg0_6.itemHolder, arg0_6.chapterTpl, #var2_6, function(arg0_7, arg1_7, arg2_7)
		if arg0_7 ~= UIItemList.EventUpdate then
			return
		end

		local var0_7 = var2_6[arg1_7 + 1]

		arg0_6:UpdateMapItem(arg2_7, var0_7)

		arg2_7.name = "Chapter_" .. var0_7.id
		arg0_6.chapterTFsById[var0_7.id] = arg2_7
	end)
end

function var0_0.UpdateSwitchMapButtons(arg0_8)
	local var0_8 = arg0_8.contextData.displayMode == var0_0.DISPLAY.BATTLE
	local var1_8, var2_8 = arg0_8.contextData.map:isActivity()
	local var3_8 = arg0_8.contextData.map
	local var4_8 = var3_8:isRemaster()
	local var5_8

	if var4_8 then
		var5_8 = getProxy(ChapterProxy):getRemasterMaps(var3_8.remasterId)
	else
		var5_8 = getProxy(ChapterProxy):getMapsByActivities(var3_8:getConfig("on_activity"))
	end

	local var6_8 = _.select(var5_8, function(arg0_9)
		return arg0_9:getMapType() ~= Map.ACTIVITY_HARD
	end)

	UIItemList.StaticAlign(arg0_8.mapSwitchList, arg0_8.mapSwitchList:GetChild(0), #var6_8, function(arg0_10, arg1_10, arg2_10)
		if arg0_10 ~= UIItemList.EventUpdate then
			return
		end

		local var0_10 = var6_8[arg1_10 + 1]
		local var1_10 = var0_10:getMapType()

		setActive(arg2_10:Find("Unselect"), var0_10.id ~= var3_8.id)
		setActive(arg2_10:Find("Selected"), var0_10.id == var3_8.id)

		local var2_10
		local var3_10 = var0_10:getConfig("map_name")

		if #(var3_10 or "") > 0 then
			var2_10 = i18n(var3_10)
		elseif var1_10 == Map.ACT_EXTRA then
			if var0_10:getChapters()[1]:IsSpChapter() then
				var2_10 = i18n("levelscene_mapselect_sp")
			else
				var2_10 = i18n("levelscene_mapselect_ex")
			end
		else
			local var4_10 = var0_10.id % 10

			assert(var4_10 == 1 or var4_10 == 2)

			var2_10 = i18n("levelscene_mapselect_part" .. var4_10)
		end

		if var1_10 == Map.ACT_EXTRA then
			local var5_10 = var0_10:getChapters()[1]

			if var5_10:IsSpChapter() then
				local var6_10 = pg.expedition_data_by_map[var5_10:getConfig("map")].on_activity

				setActive(arg2_10:Find("Tip"), var0_10.id ~= var3_8.id and getProxy(ChapterProxy):IsActivitySPChapterActive(var6_10) and SettingsProxy.IsShowActivityMapSPTip())
			end
		end

		setText(arg2_10:Find("Unselect/Text"), var2_10)
		setText(arg2_10:Find("Selected/Text"), var2_10)

		local var7_10, var8_10 = var0_10:isUnlock()
		local var9_10 = getProxy(PlayerProxy):getRawData().id
		local var10_10

		if var7_10 then
			var10_10 = PlayerPrefs.GetInt("MapFirstUnlock" .. var0_10.id .. "_" .. var9_10, 0) == 0
		end

		setActive(arg2_10:Find("Unselect/Lock"), not var7_10 or var10_10)
		onButton(arg0_8, arg2_10, function()
			if var0_10.id == var3_8.id then
				return
			end

			if var7_10 then
				arg0_8:emit(LevelUIConst.SET_MAP, var0_10.id)
			else
				pg.TipsMgr.GetInstance():ShowTips(var8_10)
			end
		end, SFX_PANEL)
	end)

	local var7_8 = var3_8:getConfig("type")

	setActive(arg0_8.sceneParent.actExtraRank, var7_8 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_12)
		if not arg0_12 or arg0_12:isEnd() then
			return
		end

		local var0_12 = arg0_12:getConfig("config_data")[1]

		return _.any(var3_8:getChapters(), function(arg0_13)
			if not arg0_13:IsEXChapter() then
				return false
			end

			return table.contains(arg0_13:getConfig("boss_expedition_id"), var0_12)
		end)
	end))
	setActive(arg0_8.sceneParent.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var4_8 and arg0_8.sceneParent:IsActShopActive())

	local var8_8 = arg0_8.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_8.contextData.map:getConfig("on_activity")) or nil
	local var9_8 = var8_8 and not var8_8:isEnd() and var8_8:GetConfigClientSetting("PTID")

	arg0_8.sceneParent:updatePtActivity(underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_14)
		return arg0_14:getConfig("config_id") == var9_8
	end))
	setActive(arg0_8.sceneParent.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var4_8 and var2_8 and arg0_8.sceneParent.ptActivity and not arg0_8.sceneParent.ptActivity:isEnd() and var0_8)
	arg0_8.sceneParent:updateCountDown()
end

function var0_0.PlayEnterAnim(arg0_15)
	local var0_15 = arg0_15.contextData.map
	local var1_15 = var0_15:isRemaster()
	local var2_15

	if var1_15 then
		var2_15 = getProxy(ChapterProxy):getRemasterMaps(var0_15.remasterId)
	else
		var2_15 = getProxy(ChapterProxy):getMapsByActivities(var0_15:getConfig("on_activity"))
	end

	local var3_15 = _.select(var2_15, function(arg0_16)
		return arg0_16:getMapType() ~= Map.ACTIVITY_HARD
	end)

	UIItemList.StaticAlign(arg0_15.mapSwitchList, arg0_15.mapSwitchList:GetChild(0), #var3_15, function(arg0_17, arg1_17, arg2_17)
		if arg0_17 ~= UIItemList.EventUpdate then
			return
		end

		local var0_17 = var3_15[arg1_17 + 1]
		local var1_17, var2_17 = var0_17:isUnlock()
		local var3_17 = getProxy(PlayerProxy):getRawData().id
		local var4_17

		if var1_17 then
			var4_17 = PlayerPrefs.GetInt("MapFirstUnlock" .. var0_17.id .. "_" .. var3_17, 0) == 0
		end

		setActive(arg2_17:Find("Unselect/Lock"), not var1_17 or var4_17)

		if var4_17 then
			quickPlayAnimation(arg2_17:Find("Unselect"), "anim_spfullui_unlock")
			PlayerPrefs.SetInt("MapFirstUnlock" .. var0_17.id .. "_" .. var3_17, 1)
		end
	end)
end

return var0_0
