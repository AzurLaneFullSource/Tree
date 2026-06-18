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

	local var0_4 = arg0_4:getMaps()
	local var1_4 = {}

	if arg0_4.contextData.map:isRemaster() then
		local var2_4 = arg0_4.contextData.map:getRemaster()

		var1_4 = pg.re_map_template[var2_4].drop_gain
	end

	setActive(arg0_4.sceneParent.eventContainer, #var1_4 <= 0 and #var0_4 <= 1)

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
	local var4_8 = arg0_8:getMaps()

	if #var4_8 > 1 then
		UIItemList.StaticAlign(arg0_8.mapSwitchList, arg0_8.mapSwitchList:GetChild(0), #var4_8, function(arg0_9, arg1_9, arg2_9)
			if arg0_9 ~= UIItemList.EventUpdate then
				return
			end

			local var0_9 = var4_8[arg1_9 + 1]
			local var1_9 = var0_9:getMapType()

			setActive(arg2_9:Find("Unselect"), var0_9.id ~= var3_8.id)
			setActive(arg2_9:Find("Selected"), var0_9.id == var3_8.id)

			local var2_9
			local var3_9 = var0_9:getConfig("map_name")

			if #(var3_9 or "") > 0 then
				var2_9 = i18n(var3_9)
			elseif var1_9 == Map.ACT_EXTRA then
				if var0_9:getChapters()[1]:IsSpChapter() then
					var2_9 = i18n("levelscene_mapselect_sp")
				else
					var2_9 = i18n("levelscene_mapselect_ex")
				end
			else
				local var4_9 = var0_9.id % 10

				assert(var4_9 == 1 or var4_9 == 2)

				var2_9 = i18n("levelscene_mapselect_part" .. var4_9)
			end

			if var1_9 == Map.ACT_EXTRA then
				local var5_9 = var0_9:getChapters()[1]

				if var5_9:IsSpChapter() then
					local var6_9 = pg.expedition_data_by_map[var5_9:getConfig("map")].on_activity

					setActive(arg2_9:Find("Tip"), var0_9.id ~= var3_8.id and getProxy(ChapterProxy):IsActivitySPChapterActive(var6_9) and SettingsProxy.IsShowActivityMapSPTip())
				end
			end

			setText(arg2_9:Find("Unselect/Text"), var2_9)
			setText(arg2_9:Find("Selected/Text"), var2_9)

			local var7_9, var8_9 = var0_9:isUnlock()
			local var9_9 = getProxy(PlayerProxy):getRawData().id
			local var10_9

			if var7_9 then
				var10_9 = PlayerPrefs.GetInt("MapFirstUnlock" .. var0_9.id .. "_" .. var9_9, 0) == 0
			end

			setActive(arg2_9:Find("Unselect/Lock"), not var7_9 or var10_9)
			onButton(arg0_8, arg2_9, function()
				if var0_9.id == var3_8.id then
					return
				end

				if var7_9 then
					arg0_8:emit(LevelUIConst.SET_MAP, var0_9.id)
				else
					pg.TipsMgr.GetInstance():ShowTips(var8_9)
				end
			end, SFX_PANEL)
		end)
	else
		setActive(arg0_8._tf:Find("Battle/MapItems"), false)
	end

	local var5_8 = var3_8:getConfig("type")

	setActive(arg0_8.sceneParent.actExtraRank, var5_8 == Map.ACT_EXTRA and _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK), function(arg0_11)
		if not arg0_11 or arg0_11:isEnd() then
			return
		end

		local var0_11 = arg0_11:getConfig("config_data")[1]

		return _.any(var3_8:getChapters(), function(arg0_12)
			if not arg0_12:IsEXChapter() then
				return false
			end

			return table.contains(arg0_12:getConfig("boss_expedition_id"), var0_11)
		end)
	end))
	setActive(arg0_8.sceneParent.actExchangeShopBtn, not ActivityConst.HIDE_PT_PANELS and not inRemasterMap and arg0_8.sceneParent:IsActShopActive())

	local var6_8 = arg0_8.contextData.map and getProxy(ActivityProxy):getActivityById(arg0_8.contextData.map:getConfig("on_activity")) or nil
	local var7_8 = var6_8 and not var6_8:isEnd() and var6_8:GetConfigClientSetting("PTID")

	arg0_8.sceneParent:updatePtActivity(underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_13)
		return arg0_13:getConfig("config_id") == var7_8
	end))
	setActive(arg0_8.sceneParent.ptTotal, not ActivityConst.HIDE_PT_PANELS and not inRemasterMap and var2_8 and arg0_8.sceneParent.ptActivity and not arg0_8.sceneParent.ptActivity:isEnd() and var0_8)
	arg0_8.sceneParent:updateCountDown()
end

function var0_0.PlayEnterAnim(arg0_14)
	local var0_14 = arg0_14.contextData.map
	local var1_14 = arg0_14:getMaps()

	if #var1_14 > 1 then
		UIItemList.StaticAlign(arg0_14.mapSwitchList, arg0_14.mapSwitchList:GetChild(0), #var1_14, function(arg0_15, arg1_15, arg2_15)
			if arg0_15 ~= UIItemList.EventUpdate then
				return
			end

			local var0_15 = var1_14[arg1_15 + 1]
			local var1_15, var2_15 = var0_15:isUnlock()
			local var3_15 = getProxy(PlayerProxy):getRawData().id
			local var4_15

			if var1_15 then
				var4_15 = PlayerPrefs.GetInt("MapFirstUnlock" .. var0_15.id .. "_" .. var3_15, 0) == 0
			end

			setActive(arg2_15:Find("Unselect/Lock"), not var1_15 or var4_15)

			if var4_15 then
				quickPlayAnimation(arg2_15:Find("Unselect"), "anim_spfullui_unlock")
				PlayerPrefs.SetInt("MapFirstUnlock" .. var0_15.id .. "_" .. var3_15, 1)
			end
		end)
	else
		setActive(arg0_14._tf:Find("Battle/MapItems"), false)
	end
end

function var0_0.getMaps(arg0_16)
	local var0_16 = arg0_16.contextData.map
	local var1_16 = var0_16:isRemaster()
	local var2_16

	if var1_16 then
		var2_16 = getProxy(ChapterProxy):getRemasterMaps(var0_16.remasterId)
	else
		var2_16 = getProxy(ChapterProxy):getMapsByActivities(var0_16:getConfig("on_activity"))
	end

	return (_.select(var2_16, function(arg0_17)
		return arg0_17:getMapType() ~= Map.ACTIVITY_HARD
	end))
end

return var0_0
