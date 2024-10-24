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
	local var0_8 = arg0_8.contextData.map
	local var1_8 = var0_8:isRemaster()
	local var2_8

	if var1_8 then
		var2_8 = getProxy(ChapterProxy):getRemasterMaps(var0_8.remasterId)
	else
		var2_8 = getProxy(ChapterProxy):getMapsByActivities()
	end

	local var3_8 = _.select(var2_8, function(arg0_9)
		return arg0_9:getMapType() ~= Map.ACTIVITY_HARD
	end)

	UIItemList.StaticAlign(arg0_8.mapSwitchList, arg0_8.mapSwitchList:GetChild(0), #var3_8, function(arg0_10, arg1_10, arg2_10)
		if arg0_10 ~= UIItemList.EventUpdate then
			return
		end

		local var0_10 = var3_8[arg1_10 + 1]
		local var1_10 = var0_10:getMapType()

		setActive(arg2_10:Find("Unselect"), var0_10.id ~= var0_8.id)
		setActive(arg2_10:Find("Selected"), var0_10.id == var0_8.id)
		setActive(arg2_10:Find("Tip"), false)

		local var2_10

		if var1_10 == Map.ACT_EXTRA then
			if var0_10:getChapters()[1]:IsSpChapter() then
				var2_10 = i18n("levelscene_mapselect_sp")

				setActive(arg2_10:Find("Tip"), var0_10.id ~= var0_8.id and getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip())
			else
				var2_10 = i18n("levelscene_mapselect_ex")
			end
		else
			local var3_10 = var0_10.id % 10

			assert(var3_10 == 1 or var3_10 == 2)

			var2_10 = i18n("levelscene_mapselect_part" .. var3_10)
		end

		setText(arg2_10:Find("Unselect/Text"), var2_10)
		setText(arg2_10:Find("Selected/Text"), var2_10)

		local var4_10, var5_10 = var0_10:isUnlock()
		local var6_10 = getProxy(PlayerProxy):getRawData().id
		local var7_10

		if var4_10 then
			var7_10 = PlayerPrefs.GetInt("MapFirstUnlock" .. var0_10.id .. "_" .. var6_10, 0) == 0
		end

		setActive(arg2_10:Find("Unselect/Lock"), not var4_10 or var7_10)
		onButton(arg0_8, arg2_10, function()
			if var0_10.id == var0_8.id then
				return
			end

			if var4_10 then
				arg0_8:emit(LevelUIConst.SET_MAP, var0_10.id)
			else
				pg.TipsMgr.GetInstance():ShowTips(var5_10)
			end
		end, SFX_PANEL)
	end)

	local var4_8 = var0_8:getConfig("type")

	setActive(arg0_8.sceneParent.actExtraRank, var4_8 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_12)
		if not arg0_12 or arg0_12:isEnd() then
			return
		end

		local var0_12 = arg0_12:getConfig("config_data")[1]

		return _.any(var0_8:getChapters(), function(arg0_13)
			return arg0_13:IsEXChapter() and arg0_13:getConfig("boss_expedition_id") == var0_12
		end)
	end))
	setActive(arg0_8.sceneParent.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not var1_8 and arg0_8.sceneParent:IsActShopActive())
	setActive(arg0_8.sceneParent.ptTotal, not ActivityConst.HIDE_PT_PANELS and not var1_8 and arg0_8.sceneParent.ptActivity and not arg0_8.sceneParent.ptActivity:isEnd())
	arg0_8.sceneParent:updateActivityRes()
	arg0_8.sceneParent:updateCountDown()
end

function var0_0.PlayEnterAnim(arg0_14)
	local var0_14 = arg0_14.contextData.map
	local var1_14 = var0_14:isRemaster()
	local var2_14

	if var1_14 then
		var2_14 = getProxy(ChapterProxy):getRemasterMaps(var0_14.remasterId)
	else
		var2_14 = getProxy(ChapterProxy):getMapsByActivities()
	end

	local var3_14 = _.select(var2_14, function(arg0_15)
		return arg0_15:getMapType() ~= Map.ACTIVITY_HARD
	end)

	UIItemList.StaticAlign(arg0_14.mapSwitchList, arg0_14.mapSwitchList:GetChild(0), #var3_14, function(arg0_16, arg1_16, arg2_16)
		if arg0_16 ~= UIItemList.EventUpdate then
			return
		end

		local var0_16 = var3_14[arg1_16 + 1]
		local var1_16, var2_16 = var0_16:isUnlock()
		local var3_16 = getProxy(PlayerProxy):getRawData().id
		local var4_16

		if var1_16 then
			var4_16 = PlayerPrefs.GetInt("MapFirstUnlock" .. var0_16.id .. "_" .. var3_16, 0) == 0
		end

		setActive(arg2_16:Find("Unselect/Lock"), not var1_16 or var4_16)

		if var4_16 then
			quickPlayAnimation(arg2_16:Find("Unselect"), "anim_spfullui_unlock")
			PlayerPrefs.SetInt("MapFirstUnlock" .. var0_16.id .. "_" .. var3_16, 1)
		end
	end)
end

return var0_0
