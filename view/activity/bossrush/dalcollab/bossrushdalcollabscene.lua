local var0_0 = class("BossRushDALCollabScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BossRushDALCollabUI"
end

function var0_0.GetAtalsName(arg0_2)
	return "ui/BossRushDALCollabUI_atlas"
end

function var0_0.ResUISettings(arg0_3)
	return true
end

function var0_0.Ctor(arg0_4)
	var0_0.super.Ctor(arg0_4)

	arg0_4.loader = AutoLoader.New()
end

function var0_0.preload(arg0_5, arg1_5)
	existCall(arg1_5)
	arg0_5.loader:LoadBundle(arg0_5:GetAtalsName())
end

function var0_0.OverlayComponent(arg0_6, arg1_6)
	if arg1_6 then
		arg0_6:OverlayPanel(arg0_6.top)
		arg0_6:OverlayPanel(arg0_6.right)
		arg0_6:OverlayPanel(arg0_6.pt)
		arg0_6:OverlayPanel(arg0_6.battleNodes)
	else
		arg0_6:UnOverlayPanel(arg0_6.top, arg0_6._tf)
		arg0_6:UnOverlayPanel(arg0_6.right, arg0_6._tf)
		arg0_6:UnOverlayPanel(arg0_6.pt, arg0_6._tf)
		arg0_6:UnOverlayPanel(arg0_6.battleNodes, arg0_6._tf)
	end
end

function var0_0.init(arg0_7)
	arg0_7.top = arg0_7._tf:Find("Top")
	arg0_7.map = arg0_7._tf:Find("Map")
	arg0_7.right = arg0_7._tf:Find("Right")
	arg0_7.pt = arg0_7._tf:Find("PT")
	arg0_7.battleNodes = arg0_7._tf:Find("Battle")
	arg0_7.seriesNodes = _.map(_.range(arg0_7._tf:Find("Battle/Nodes").childCount), function(arg0_8)
		return arg0_7._tf:Find("Battle/Nodes"):GetChild(arg0_8 - 1)
	end)

	table.Foreach(arg0_7.seriesNodes, function(arg0_9, arg1_9)
		local var0_9 = arg1_9:Find("ship")
		local var1_9 = var0_9:GetComponent(typeof(Animation))

		var0_9:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			if var1_9:IsPlaying("anim_BossRushDALCollabUI_ship_out") then
				setActive(arg0_7._currentShip, true)
				setActive(arg0_7._currentShip:Find("vx_teleport_1"), true)
				setActive(var0_9:Find("vx_teleport_2"), false)
				arg0_7:playAnima(arg0_7._currentShip, "anim_BossRushDALCollabUI_ship_in")
				setActive(var0_9, false)
			elseif var1_9:IsPlaying("anim_BossRushDALCollabUI_ship_in") then
				if arg0_7._openSeriesData then
					arg0_7.stageView:ExecuteAction("SetData", arg0_7._openSeriesData)
					arg0_7.stageView:ExecuteAction("Show")

					arg0_7.battleNodes:GetComponent(typeof(CanvasGroup)).interactable = true
					arg0_7._openSeriesData = nil
				end

				setActive(var0_9:Find("vx_teleport_1"), false)

				arg0_7._lastShip = var0_9
			end
		end)
	end)

	arg0_7.maps = {}

	for iter0_7 = 1, 6 do
		arg0_7.maps[iter0_7] = arg0_7._tf:Find("Map/map_" .. iter0_7)
	end

	arg0_7.shiftMap = arg0_7._tf:Find("Map/Map_1")
	arg0_7.shiftMapList = {}

	for iter1_7 = 1, 6 do
		arg0_7.shiftMapList[iter1_7] = arg0_7.shiftMap:Find("map_" .. iter1_7)
	end

	arg0_7.mapAnima = arg0_7._tf:Find("Map"):GetComponent(typeof(Animation))
	arg0_7.mapDftEvt = arg0_7._tf:Find("Map"):GetComponent(typeof(DftAniEvent))
	arg0_7.mapFX = arg0_7._tf:Find("Map/state_fx")
	arg0_7.upgradeBtn = arg0_7._tf:Find("Right/Upgrade")
	arg0_7.shopBtn = arg0_7._tf:Find("Right/Store")
	arg0_7.ptLabel = arg0_7._tf:Find("PT/pt_text/icon")
	arg0_7.ptIcon = arg0_7._tf:Find("PT/pt_text/icon/Image")
	arg0_7.ptCount = arg0_7._tf:Find("PT/pt_text/Text")

	setText(arg0_7.ptLabel, i18n("pt_count_tip"))

	arg0_7.ActionSequence = {}
	arg0_7.upgradeView = BossRushDALUpgradeView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)

	arg0_7.upgradeView:RegisterView(arg0_7)

	arg0_7.stageView = BossRushDALCollabStageView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)
end

function var0_0.SetUpgradeActvity(arg0_11, arg1_11)
	arg0_11.upgradeView:SetData(arg1_11)
end

function var0_0.SetActivity(arg0_12, arg1_12)
	arg0_12.activity = arg1_12
end

function var0_0.SetPTActivity(arg0_13, arg1_13)
	arg0_13.ptActivity = arg1_13
end

function var0_0.onBackPressed(arg0_14)
	if arg0_14.upgradeView:isShowing() then
		arg0_14.upgradeView:Hide()
	elseif arg0_14.stageView:isShowing() then
		arg0_14.stageView:Hide()
	else
		var0_0.super.onBackPressed(arg0_14)
	end
end

function var0_0.didEnter(arg0_15)
	onButton(arg0_15, arg0_15.top:Find("back_btn"), function()
		arg0_15:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_15, arg0_15.top:Find("option"), function()
		arg0_15:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.upgradeBtn, function()
		arg0_15.upgradeView:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.top:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = {
				{
					info = i18n("dal_chapter_tip")
				}
			}
		})
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.shopBtn, function()
		local var0_20 = arg0_15.activity:getConfig("config_client").shopID
		local var1_20 = getProxy(ActivityProxy):getActivityById(var0_20)

		if not var1_20 or var1_20:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_15:emit(BossRushDALCollabMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = var1_20 and var1_20.id
		})
	end, SFX_PANEL)
	arg0_15:PlayBGM()
	arg0_15:playAnima(arg0_15._tf, "anim_BossRushDALCollabUI_in")
	arg0_15:OverlayComponent(true)
end

function var0_0.getBGM(arg0_21)
	local var0_21 = pg.voice_bgm[arg0_21.__cname]

	if not var0_21 then
		return nil
	end

	return var0_21.bgm
end

function var0_0.UpdateView(arg0_22)
	setActive(arg0_22.battleNodes, true)
	arg0_22:UpdateBattle()
	arg0_22:UpdateMap()
	arg0_22:updateActivityRes()
end

function var0_0.playAnima(arg0_23, arg1_23, arg2_23, arg3_23)
	arg1_23:GetComponent(typeof(Animation)):Play(arg2_23)

	if arg3_23 then
		arg1_23:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			arg3_23()
		end)
	end
end

function var0_0.PlayMapShiftAnima(arg0_25, arg1_25, arg2_25, arg3_25)
	for iter0_25, iter1_25 in pairs(arg0_25.maps) do
		local var0_25 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter0_25 .. arg2_25)

		setImageSprite(iter1_25, var0_25, true)
	end

	for iter2_25, iter3_25 in pairs(arg0_25.shiftMapList) do
		local var1_25 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter2_25 .. arg1_25)

		setImageSprite(iter3_25, var1_25, true)
	end

	setActive(arg0_25.shiftMap, true)
	arg0_25.mapAnima:Play("anim_BossRushDALCollabUI_Map")
end

function var0_0.updateActivityRes(arg0_26)
	setText(arg0_26.ptCount, "x" .. arg0_26.ptActivity.data1)
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = tonumber(arg0_26.ptActivity:getConfig("config_id"))
	}):getIcon(), "", arg0_26.ptIcon, true)
end

function var0_0.UpdateMap(arg0_27)
	local var0_27 = arg0_27.activity
	local var1_27 = var0_27:GetCollabSeriesDataList()
	local var2_27 = var1_27[6]

	if var2_27:IsPass() and var2_27:GetDefeated(arg0_27.activity) then
		setActive(arg0_27.mapFX:Find("state_3"), true)
		setActive(arg0_27.mapFX:Find("state_4"), true)
		setActive(arg0_27.mapFX:Find("state_4/6_3"), true)

		for iter0_27, iter1_27 in pairs(arg0_27.maps) do
			if iter0_27 ~= 1 and iter0_27 ~= 6 then
				setActive(arg0_27.mapFX:Find("state_4/" .. iter0_27), false)
			end

			setActive(iter1_27, true)

			local var3_27 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter0_27)

			setImageSprite(iter1_27, var3_27, true)
		end
	elseif var2_27:IsPlayerUnlock(var0_27) and (not var2_27:IsPass() or not var2_27:GetDefeated(arg0_27.activity)) then
		setActive(arg0_27.mapFX:Find("state_4"), true)

		for iter2_27, iter3_27 in pairs(arg0_27.maps) do
			setActive(iter3_27, true)

			if iter2_27 == 6 then
				local var4_27

				if var2_27:GetBossHpRate() > 0.5 then
					var4_27 = "_1"

					setActive(arg0_27.mapFX:Find("state_4/6_1"), true)
				else
					setActive(arg0_27.mapFX:Find("state_4/6_2"), true)

					var4_27 = "_2"
				end

				local var5_27 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter2_27 .. var4_27)

				setImageSprite(iter3_27, var5_27, true)
			else
				local var6_27 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter2_27 .. "_3")

				setImageSprite(iter3_27, var6_27, true)
			end
		end
	else
		setActive(arg0_27.mapFX:Find("state_2"), true)
		setActive(arg0_27.mapFX:Find("state_1"), true)
		setActive(arg0_27.mapFX:Find("state_3"), true)

		for iter4_27, iter5_27 in pairs(arg0_27.maps) do
			if iter4_27 == 6 then
				setActive(iter5_27, false)
			else
				setActive(iter5_27, true)

				local var7_27 = var1_27[iter4_27]
				local var8_27 = var7_27:GetDefeated(arg0_27.activity)
				local var9_27
				local var10_27 = not var8_27 and "_1" or var7_27:GetBossTimeStamp() ~= 0 and "" or var7_27:GetBossHpRate() > 0.5 and "_1" or "_2"
				local var11_27 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter4_27 .. var10_27)

				setImageSprite(iter5_27, var11_27, true)

				if iter4_27 ~= 1 then
					if var10_27 == "" then
						setActive(arg0_27.mapFX:Find("state_3/" .. iter4_27), true)
					elseif var10_27 == "_1" then
						setActive(arg0_27.mapFX:Find("state_1/" .. iter4_27), true)
					elseif var10_27 == "_2" then
						setActive(arg0_27.mapFX:Find("state_2/" .. iter4_27), true)
					end
				end
			end
		end
	end
end

function var0_0.UpdateBattle(arg0_28)
	local var0_28 = arg0_28.activity
	local var1_28 = var0_28:GetActiveSeriesIds()
	local var2_28 = arg0_28.activity:GetCollabSeriesDataList()
	local var3_28 = {}

	for iter0_28, iter1_28 in pairs(var2_28) do
		table.insert(var3_28, iter1_28)
	end

	table.sort(var3_28, function(arg0_29, arg1_29)
		return arg0_29:GetTrafficPerH() > arg1_29:GetTrafficPerH()
	end)
	table.Foreach(arg0_28.seriesNodes, function(arg0_30, arg1_30)
		local var0_30 = var1_28[arg0_30]
		local var1_30 = var0_28:GetCollabSeriesData(var0_30)
		local var2_30 = var1_30:IsPlayerUnlock(var0_28)
		local var3_30 = var1_30:IsPass()
		local var4_30 = var1_30:GetDefeated(arg0_28.activity)

		if var0_30 == 6 and not var2_30 then
			setActive(arg1_30, false)
		end

		setActive(arg1_30:Find("lock"), not var2_30)
		setActive(arg1_30:Find("clear"), var2_30 and var3_30 and var4_30)
		setActive(arg1_30:Find("active"), var2_30 and (not var3_30 or not var4_30))

		local var5_30 = table.indexof(var3_28, var1_30)

		if not var2_30 then
			setText(arg1_30:Find("lock/name"), var1_30:GetSeriesCode())
		elseif var1_30:IsPass() and var4_30 then
			setText(arg1_30:Find("clear/current/name/text"), var1_30:GetSeriesCode())
			setText(arg1_30:Find("clear/common/name"), var1_30:GetSeriesCode())
			setActive(arg1_30:Find("clear/common"), true)
			setActive(arg1_30:Find("clear/current"), false)
		else
			setText(arg1_30:Find("active/current/name/text"), var1_30:GetSeriesCode())
			setText(arg1_30:Find("active/common/name"), var1_30:GetSeriesCode())

			local var6_30 = var1_30:GetBossHpRate() * 100 .. "%"

			setText(arg1_30:Find("active/common/value"), var1_30:IsPass() and "HOLD" or var6_30)
			setText(arg1_30:Find("active/current/value"), var1_30:IsPass() and "HOLD" or var6_30)
			setActive(arg1_30:Find("active/common"), true)
			setActive(arg1_30:Find("active/current"), false)

			arg1_30:Find("active/current/progress"):GetComponent(typeof(Image)).fillAmount = var1_30:IsPass() and 1 or var1_30:GetBossHpRate()
		end

		local function var7_30(arg0_31)
			if var5_30 > 3 then
				setActive(arg0_31, false)
			else
				setActive(arg0_31, true)

				local var0_31 = _.map(_.range(arg0_31.childCount), function(arg0_32)
					return arg0_31:GetChild(arg0_32 - 1)
				end)

				table.Foreach(var0_31, function(arg0_33, arg1_33)
					setActive(arg1_33, arg0_33 <= 4 - var5_30)
				end)
			end
		end

		var7_30(arg1_30:Find("active/common/bullets"))
		var7_30(arg1_30:Find("clear/common/bullets"))
		onButton(arg0_28, arg1_30, function()
			if not var2_30 then
				local var0_34 = var1_30:GetPreSeriesId()
				local var1_34 = ""
				local var2_34 = 1
				local var3_34 = var1_30:GetPreSeriesId()
				local var4_34 = CollabrateBossRushSeriesData.New({
					id = var3_34[var2_34]
				}):GetSeriesCode()

				while var2_34 < #var3_34 do
					var2_34 = var2_34 + 1

					local var5_34 = CollabrateBossRushSeriesData.New({
						id = var3_34[var2_34]
					})

					var4_34 = var4_34 .. "、" .. var5_34:GetSeriesCode()
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var4_34))

				return
			end

			local function var6_34()
				arg0_28._openSeriesData = var1_30

				PlayerPrefs.SetInt("DAL_ship_position", arg0_30)

				if not arg0_28:updateShipPosition() then
					arg0_28.stageView:ExecuteAction("SetData", var1_30)
					arg0_28.stageView:ExecuteAction("Show")

					arg0_28.battleNodes:GetComponent(typeof(CanvasGroup)).interactable = true
				end
			end

			local var7_34 = var1_30:GetInitStory()

			if var7_34 then
				arg0_28:PlayStory(var7_34, var6_34)
			else
				var6_34()
			end
		end, SFX_PANEL)
	end)
	arg0_28:updateShipPosition()
	arg0_28:addbubbleMsgBoxList({
		function(arg0_36)
			arg0_28:checkAllStory()
			arg0_36()
		end,
		function(arg0_37)
			local var0_37 = arg0_28.activity:getConfig("config_client").first_story
			local var1_37 = arg0_28.activity:getConfig("config_client").first_guide

			if first_guide then
				local function var2_37()
					pg.SystemGuideMgr.GetInstance():PlayByGuideId(var1_37, nil, arg0_37)
				end

				arg0_28:PlayStory(var0_37, var2_37)
			else
				arg0_28:PlayStory(var0_37, arg0_37)
			end
		end
	})
end

function var0_0.updateCurrent(arg0_39, arg1_39)
	table.Foreach(arg0_39.seriesNodes, function(arg0_40, arg1_40)
		setActive(arg1_40:Find("clear/common"), arg1_39 ~= arg1_40)
		setActive(arg1_40:Find("clear/current"), arg1_39 == arg1_40)
		setActive(arg1_40:Find("active/common"), arg1_39 ~= arg1_40)
		setActive(arg1_40:Find("active/current"), arg1_39 == arg1_40)

		if arg1_39 == arg1_40 then
			arg0_39:playAnima(arg1_39, "anim_BossRushDALCollabUI_battle_in")
		end
	end)
end

function var0_0.updateShipPosition(arg0_41)
	local var0_41 = PlayerPrefs.GetInt("DAL_ship_position", 1)
	local var1_41 = arg0_41.activity:GetActiveSeriesIds()

	table.Foreach(arg0_41.seriesNodes, function(arg0_42, arg1_42)
		local var0_42 = var1_41[arg0_42]
		local var1_42 = arg1_42:Find("ship")

		var1_42:GetComponent(typeof(Animation)):Stop()

		if var0_41 == var0_42 then
			arg0_41:updateCurrent(arg1_42)

			arg0_41._currentShip = var1_42
		elseif var1_42 ~= arg0_41._lastShip then
			setActive(arg1_42:Find("ship"), false)
		end
	end)

	if arg0_41._lastShip then
		if arg0_41._lastShip ~= arg0_41._currentShip then
			arg0_41:playAnima(arg0_41._lastShip, "anim_BossRushDALCollabUI_ship_out")
			setActive(arg0_41._lastShip:Find("vx_teleport_2"), true)

			arg0_41.battleNodes:GetComponent(typeof(CanvasGroup)).interactable = false
		end
	else
		setActive(arg0_41._currentShip, true)
		setActive(arg0_41._currentShip:Find("vx_teleport_1"), true)
		arg0_41:playAnima(arg0_41._currentShip, "anim_BossRushDALCollabUI_ship_in")
	end

	return arg0_41._lastShip ~= arg0_41._currentShip
end

function var0_0.checkAllStory(arg0_43)
	local var0_43 = arg0_43.activity:GetCollabSeriesDataList()
	local var1_43 = {}

	for iter0_43, iter1_43 in pairs(var0_43) do
		if table.contains(arg0_43.activity:GetPassCounts(), iter0_43) then
			local var2_43 = iter1_43:GetStorys()

			for iter2_43, iter3_43 in ipairs(var2_43) do
				table.insert(var1_43, iter3_43)
			end
		end
	end

	local var3_43 = 1

	local function var4_43()
		var3_43 = var3_43 + 1

		local var0_44 = var1_43[var3_43]
		local var1_44
		local var2_44 = arg0_43.activity:getConfig("config_client").storys_unlock_story

		if var0_44 == nil and var2_44 then
			local var3_44 = pg.NewStoryMgr.GetInstance()

			var1_44 = true

			for iter0_44, iter1_44 in ipairs(var2_44[2]) do
				var1_44 = var1_44 and var3_44:IsPlayed(iter1_44)
			end

			var1_44 = var1_44 and not var3_44:IsPlayed(var2_44[1])
		end

		if var1_44 then
			local function var4_44()
				setActive(arg0_43.shiftMap:Find("map_6"), false)
				arg0_43:PlayMapShiftAnima("", "_3")
			end

			arg0_43:PlayStory(var2_44[1], var4_44)
		else
			arg0_43:PlayStory(var0_44, var4_43)
		end
	end

	arg0_43:PlayStory(var1_43[var3_43], var4_43)
end

function var0_0.GetFinalStoryName(arg0_46)
	local var0_46 = arg0_46.activity:GetCollabSeriesDataList()[6]
	local var1_46 = Clone(var0_46:getConfig("story_worldboss"))

	table.sort(var1_46, function(arg0_47, arg1_47)
		return arg0_47[2] < arg1_47[2]
	end)

	return var1_46[1][1]
end

function var0_0.PlayStory(arg0_48, arg1_48, arg2_48)
	if not arg1_48 then
		return
	end

	local var0_48 = pg.NewStoryMgr.GetInstance()

	if var0_48:IsPlayed(arg1_48) then
		return existCall(arg2_48)
	end

	if arg1_48 == arg0_48:GetFinalStoryName() then
		local function var1_48()
			arg0_48:PlayMapShiftAnima("_3", "")
		end

		var0_48:Play(arg1_48, var1_48)
	else
		var0_48:Play(arg1_48, arg2_48)
	end
end

function var0_0.UpdateTasks(arg0_50, arg1_50)
	if _.any(arg1_50, function(arg0_51)
		return arg0_50.storyTask and arg0_50.storyTask.id == arg0_51
	end) then
		arg0_50.storyTask.submitTime = 1

		arg0_50:UpdateView()
	end
end

function var0_0.addbubbleMsgBoxList(arg0_52, arg1_52)
	local var0_52 = #arg0_52.ActionSequence == 0

	table.insertto(arg0_52.ActionSequence, arg1_52)

	if not var0_52 then
		return
	end

	arg0_52:resumeBubble()
end

function var0_0.addbubbleMsgBox(arg0_53, arg1_53)
	local var0_53 = #arg0_53.ActionSequence == 0

	table.insert(arg0_53.ActionSequence, arg1_53)

	if not var0_53 then
		return
	end

	arg0_53:resumeBubble()
end

function var0_0.resumeBubble(arg0_54)
	if #arg0_54.ActionSequence == 0 then
		return
	end

	local var0_54

	local function var1_54()
		local var0_55 = arg0_54.ActionSequence[1]

		if var0_55 then
			var0_55(function()
				table.remove(arg0_54.ActionSequence, 1)
				var1_54()
			end)
		end
	end

	var1_54()
end

function var0_0.CleanBubbleMsgbox(arg0_57)
	table.clean(arg0_57.ActionSequence)
end

function var0_0.willExit(arg0_58)
	arg0_58:OverlayComponent(false)
	arg0_58.stageView:Destroy()
	arg0_58.upgradeView:Destroy()
	arg0_58.loader:Clear()
	var0_0.super.willExit(arg0_58)
end

return var0_0
