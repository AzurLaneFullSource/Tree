local var0_0 = class("BossRushDALCollabScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BossRushDALCollabUI"
end

function var0_0.getAtalsName(arg0_2)
	return "ui/BossRushDALCollabUI_atlas"
end

function var0_0.getResource(arg0_3)
	local var0_3 = var0_0.super.getResource(arg0_3)

	table.insert(var0_3, arg0_3:getAtalsName())

	return var0_3
end

function var0_0.ResUISettings(arg0_4)
	return true
end

function var0_0.Ctor(arg0_5)
	var0_0.super.Ctor(arg0_5)

	arg0_5.loader = AutoLoader.New()
end

function var0_0.preload(arg0_6, arg1_6)
	existCall(arg1_6)
	arg0_6.loader:LoadBundle(arg0_6:getAtalsName())
end

function var0_0.OverlayComponent(arg0_7, arg1_7)
	if arg1_7 then
		arg0_7:OverlayPanel(arg0_7.top)
		arg0_7:OverlayPanel(arg0_7.right)
		arg0_7:OverlayPanel(arg0_7.pt)
		arg0_7:OverlayPanel(arg0_7.battleNodes)
	else
		arg0_7:UnOverlayPanel(arg0_7.top, arg0_7._tf)
		arg0_7:UnOverlayPanel(arg0_7.right, arg0_7._tf)
		arg0_7:UnOverlayPanel(arg0_7.pt, arg0_7._tf)
		arg0_7:UnOverlayPanel(arg0_7.battleNodes, arg0_7._tf)
	end
end

function var0_0.init(arg0_8)
	arg0_8.top = arg0_8._tf:Find("Top")
	arg0_8.map = arg0_8._tf:Find("Map")
	arg0_8.right = arg0_8._tf:Find("Right")
	arg0_8.pt = arg0_8._tf:Find("PT")
	arg0_8.battleNodes = arg0_8._tf:Find("Battle")
	arg0_8.seriesNodes = _.map(_.range(arg0_8._tf:Find("Battle/Nodes").childCount), function(arg0_9)
		return arg0_8._tf:Find("Battle/Nodes"):GetChild(arg0_9 - 1)
	end)

	table.Foreach(arg0_8.seriesNodes, function(arg0_10, arg1_10)
		local var0_10 = arg1_10:Find("ship")
		local var1_10 = var0_10:GetComponent(typeof(Animation))

		var0_10:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			if var1_10:IsPlaying("anim_BossRushDALCollabUI_ship_out") then
				setActive(arg0_8._currentShip, true)
				setActive(arg0_8._currentShip:Find("vx_teleport_1"), true)
				setActive(var0_10:Find("vx_teleport_2"), false)
				arg0_8:playAnima(arg0_8._currentShip, "anim_BossRushDALCollabUI_ship_in")
				setActive(var0_10, false)
			elseif var1_10:IsPlaying("anim_BossRushDALCollabUI_ship_in") then
				if arg0_8._openSeriesData then
					arg0_8.stageView:ExecuteAction("SetData", arg0_8._openSeriesData)
					arg0_8.stageView:ExecuteAction("Show")

					arg0_8.battleNodes:GetComponent(typeof(CanvasGroup)).interactable = true
					arg0_8._openSeriesData = nil
				end

				setActive(var0_10:Find("vx_teleport_1"), false)

				arg0_8._lastShip = var0_10
			end
		end)
	end)

	arg0_8.maps = {}

	for iter0_8 = 1, 6 do
		arg0_8.maps[iter0_8] = arg0_8._tf:Find("Map/map_" .. iter0_8)
	end

	arg0_8.shiftMap = arg0_8._tf:Find("Map/Map_1")
	arg0_8.shiftMapList = {}

	for iter1_8 = 1, 6 do
		arg0_8.shiftMapList[iter1_8] = arg0_8.shiftMap:Find("map_" .. iter1_8)
	end

	arg0_8.mapAnima = arg0_8._tf:Find("Map"):GetComponent(typeof(Animation))
	arg0_8.mapDftEvt = arg0_8._tf:Find("Map"):GetComponent(typeof(DftAniEvent))
	arg0_8.mapFX = arg0_8._tf:Find("Map/state_fx")
	arg0_8.upgradeBtn = arg0_8._tf:Find("Right/Upgrade")
	arg0_8.shopBtn = arg0_8._tf:Find("Right/Store")
	arg0_8.ptLabel = arg0_8._tf:Find("PT/pt_text/icon")
	arg0_8.ptIcon = arg0_8._tf:Find("PT/pt_text/icon/Image")
	arg0_8.ptCount = arg0_8._tf:Find("PT/pt_text/Text")

	setText(arg0_8.ptLabel, i18n("pt_count_tip"))

	arg0_8.ActionSequence = {}
	arg0_8.upgradeView = BossRushDALUpgradeView.New(arg0_8._tf, arg0_8.event, arg0_8.contextData)

	arg0_8.upgradeView:RegisterView(arg0_8)

	arg0_8.stageView = BossRushDALCollabStageView.New(arg0_8._tf, arg0_8.event, arg0_8.contextData)
end

function var0_0.SetUpgradeActvity(arg0_12, arg1_12)
	arg0_12.upgradeView:SetData(arg1_12)
end

function var0_0.SetActivity(arg0_13, arg1_13)
	arg0_13.activity = arg1_13
end

function var0_0.SetPTActivity(arg0_14, arg1_14)
	arg0_14.ptActivity = arg1_14
end

function var0_0.onBackPressed(arg0_15)
	if arg0_15.upgradeView:isShowing() then
		arg0_15.upgradeView:Hide()
	elseif arg0_15.stageView:isShowing() then
		arg0_15.stageView:Hide()
	else
		var0_0.super.onBackPressed(arg0_15)
	end
end

function var0_0.didEnter(arg0_16)
	onButton(arg0_16, arg0_16.top:Find("back_btn"), function()
		arg0_16:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16.top:Find("option"), function()
		arg0_16:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.upgradeBtn, function()
		arg0_16.upgradeView:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.top:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = {
				{
					info = i18n("dal_chapter_tip")
				}
			}
		})
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.shopBtn, function()
		local var0_21 = arg0_16.activity:getConfig("config_client").shopID
		local var1_21 = getProxy(ActivityProxy):getActivityById(var0_21)

		if not var1_21 or var1_21:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_16:emit(BossRushDALCollabMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = var1_21 and var1_21.id
		})
	end, SFX_PANEL)
	arg0_16:PlayBGM()
	arg0_16:playAnima(arg0_16._tf, "anim_BossRushDALCollabUI_in")
	arg0_16:OverlayComponent(true)
end

function var0_0.getBGM(arg0_22)
	local var0_22 = pg.voice_bgm[arg0_22.__cname]

	if not var0_22 then
		return nil
	end

	return var0_22.bgm
end

function var0_0.UpdateView(arg0_23)
	setActive(arg0_23.battleNodes, true)
	arg0_23:UpdateBattle()
	arg0_23:UpdateMap()
	arg0_23:updateActivityRes()
end

function var0_0.playAnima(arg0_24, arg1_24, arg2_24, arg3_24)
	arg1_24:GetComponent(typeof(Animation)):Play(arg2_24)

	if arg3_24 then
		arg1_24:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			arg3_24()
		end)
	end
end

function var0_0.PlayMapShiftAnima(arg0_26, arg1_26, arg2_26, arg3_26)
	for iter0_26, iter1_26 in pairs(arg0_26.maps) do
		local var0_26 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter0_26 .. arg2_26)

		setImageSprite(iter1_26, var0_26, true)
	end

	for iter2_26, iter3_26 in pairs(arg0_26.shiftMapList) do
		local var1_26 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter2_26 .. arg1_26)

		setImageSprite(iter3_26, var1_26, true)
	end

	setActive(arg0_26.shiftMap, true)
	arg0_26.mapAnima:Play("anim_BossRushDALCollabUI_Map")
end

function var0_0.updateActivityRes(arg0_27)
	setText(arg0_27.ptCount, "x" .. arg0_27.ptActivity.data1)
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = tonumber(arg0_27.ptActivity:getConfig("config_id"))
	}):getIcon(), "", arg0_27.ptIcon, true)
end

function var0_0.UpdateMap(arg0_28)
	local var0_28 = arg0_28.activity
	local var1_28 = var0_28:GetCollabSeriesDataList()
	local var2_28 = var1_28[6]

	if var2_28:IsPass() and var2_28:GetDefeated(arg0_28.activity) then
		setActive(arg0_28.mapFX:Find("state_3"), true)
		setActive(arg0_28.mapFX:Find("state_4"), true)
		setActive(arg0_28.mapFX:Find("state_4/6_3"), true)

		for iter0_28, iter1_28 in pairs(arg0_28.maps) do
			if iter0_28 ~= 1 and iter0_28 ~= 6 then
				setActive(arg0_28.mapFX:Find("state_4/" .. iter0_28), false)
			end

			setActive(iter1_28, true)

			local var3_28 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter0_28)

			setImageSprite(iter1_28, var3_28, true)
		end
	elseif var2_28:IsPlayerUnlock(var0_28) and (not var2_28:IsPass() or not var2_28:GetDefeated(arg0_28.activity)) then
		setActive(arg0_28.mapFX:Find("state_4"), true)

		for iter2_28, iter3_28 in pairs(arg0_28.maps) do
			setActive(iter3_28, true)

			if iter2_28 == 6 then
				local var4_28

				if var2_28:GetBossHpRate() > 0.5 then
					var4_28 = "_1"

					setActive(arg0_28.mapFX:Find("state_4/6_1"), true)
				else
					setActive(arg0_28.mapFX:Find("state_4/6_2"), true)

					var4_28 = "_2"
				end

				local var5_28 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter2_28 .. var4_28)

				setImageSprite(iter3_28, var5_28, true)
			else
				local var6_28 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter2_28 .. "_3")

				setImageSprite(iter3_28, var6_28, true)
			end
		end
	else
		setActive(arg0_28.mapFX:Find("state_2"), true)
		setActive(arg0_28.mapFX:Find("state_1"), true)
		setActive(arg0_28.mapFX:Find("state_3"), true)

		for iter4_28, iter5_28 in pairs(arg0_28.maps) do
			if iter4_28 == 6 then
				setActive(iter5_28, false)
			else
				setActive(iter5_28, true)

				local var7_28 = var1_28[iter4_28]
				local var8_28 = var7_28:GetDefeated(arg0_28.activity)
				local var9_28
				local var10_28 = not var8_28 and "_1" or var7_28:GetBossTimeStamp() ~= 0 and "" or var7_28:GetBossHpRate() > 0.5 and "_1" or "_2"
				local var11_28 = GetSpriteFromAtlas("ui/dalcollabbossrushsceneui_atlas", "map_" .. iter4_28 .. var10_28)

				setImageSprite(iter5_28, var11_28, true)

				if iter4_28 ~= 1 then
					if var10_28 == "" then
						setActive(arg0_28.mapFX:Find("state_3/" .. iter4_28), true)
					elseif var10_28 == "_1" then
						setActive(arg0_28.mapFX:Find("state_1/" .. iter4_28), true)
					elseif var10_28 == "_2" then
						setActive(arg0_28.mapFX:Find("state_2/" .. iter4_28), true)
					end
				end
			end
		end
	end
end

function var0_0.UpdateBattle(arg0_29)
	local var0_29 = arg0_29.activity
	local var1_29 = var0_29:GetActiveSeriesIds()
	local var2_29 = arg0_29.activity:GetCollabSeriesDataList()
	local var3_29 = {}

	for iter0_29, iter1_29 in pairs(var2_29) do
		table.insert(var3_29, iter1_29)
	end

	table.sort(var3_29, function(arg0_30, arg1_30)
		return arg0_30:GetTrafficPerH() > arg1_30:GetTrafficPerH()
	end)
	table.Foreach(arg0_29.seriesNodes, function(arg0_31, arg1_31)
		local var0_31 = var1_29[arg0_31]
		local var1_31 = var0_29:GetCollabSeriesData(var0_31)
		local var2_31 = var1_31:IsPlayerUnlock(var0_29)
		local var3_31 = var1_31:IsPass()
		local var4_31 = var1_31:GetDefeated(arg0_29.activity)

		if var0_31 == 6 and not var2_31 then
			setActive(arg1_31, false)
		end

		setActive(arg1_31:Find("lock"), not var2_31)
		setActive(arg1_31:Find("clear"), var2_31 and var3_31 and var4_31)
		setActive(arg1_31:Find("active"), var2_31 and (not var3_31 or not var4_31))

		local var5_31 = table.indexof(var3_29, var1_31)

		if not var2_31 then
			setText(arg1_31:Find("lock/name"), var1_31:GetSeriesCode())
		elseif var1_31:IsPass() and var4_31 then
			setText(arg1_31:Find("clear/current/name/text"), var1_31:GetSeriesCode())
			setText(arg1_31:Find("clear/common/name"), var1_31:GetSeriesCode())
			setActive(arg1_31:Find("clear/common"), true)
			setActive(arg1_31:Find("clear/current"), false)
		else
			setText(arg1_31:Find("active/current/name/text"), var1_31:GetSeriesCode())
			setText(arg1_31:Find("active/common/name"), var1_31:GetSeriesCode())

			local var6_31 = var1_31:GetBossHpRate() * 100 .. "%"

			setText(arg1_31:Find("active/common/value"), var1_31:IsPass() and "HOLD" or var6_31)
			setText(arg1_31:Find("active/current/value"), var1_31:IsPass() and "HOLD" or var6_31)
			setActive(arg1_31:Find("active/common"), true)
			setActive(arg1_31:Find("active/current"), false)

			arg1_31:Find("active/current/progress"):GetComponent(typeof(Image)).fillAmount = var1_31:IsPass() and 1 or var1_31:GetBossHpRate()
		end

		local function var7_31(arg0_32)
			if var5_31 > 3 then
				setActive(arg0_32, false)
			else
				setActive(arg0_32, true)

				local var0_32 = _.map(_.range(arg0_32.childCount), function(arg0_33)
					return arg0_32:GetChild(arg0_33 - 1)
				end)

				table.Foreach(var0_32, function(arg0_34, arg1_34)
					setActive(arg1_34, arg0_34 <= 4 - var5_31)
				end)
			end
		end

		var7_31(arg1_31:Find("active/common/bullets"))
		var7_31(arg1_31:Find("clear/common/bullets"))
		onButton(arg0_29, arg1_31, function()
			if not var2_31 then
				local var0_35 = var1_31:GetPreSeriesId()
				local var1_35 = ""
				local var2_35 = 1
				local var3_35 = var1_31:GetPreSeriesId()
				local var4_35 = CollabrateBossRushSeriesData.New({
					id = var3_35[var2_35]
				}):GetSeriesCode()

				while var2_35 < #var3_35 do
					var2_35 = var2_35 + 1

					local var5_35 = CollabrateBossRushSeriesData.New({
						id = var3_35[var2_35]
					})

					var4_35 = var4_35 .. "、" .. var5_35:GetSeriesCode()
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("series_enemy_unlock", var4_35))

				return
			end

			local function var6_35()
				arg0_29._openSeriesData = var1_31

				PlayerPrefs.SetInt("DAL_ship_position", arg0_31)

				if not arg0_29:updateShipPosition() then
					arg0_29.stageView:ExecuteAction("SetData", var1_31)
					arg0_29.stageView:ExecuteAction("Show")

					arg0_29.battleNodes:GetComponent(typeof(CanvasGroup)).interactable = true
				end
			end

			local var7_35 = var1_31:GetInitStory()

			if var7_35 then
				arg0_29:PlayStory(var7_35, var6_35)
			else
				var6_35()
			end
		end, SFX_PANEL)
	end)
	arg0_29:updateShipPosition()
	arg0_29:addbubbleMsgBoxList({
		function(arg0_37)
			arg0_29:checkAllStory()
			arg0_37()
		end,
		function(arg0_38)
			local var0_38 = arg0_29.activity:getConfig("config_client").first_story
			local var1_38 = arg0_29.activity:getConfig("config_client").first_guide

			if first_guide then
				local function var2_38()
					pg.SystemGuideMgr.GetInstance():PlayByGuideId(var1_38, nil, arg0_38)
				end

				arg0_29:PlayStory(var0_38, var2_38)
			else
				arg0_29:PlayStory(var0_38, arg0_38)
			end
		end
	})
end

function var0_0.updateCurrent(arg0_40, arg1_40)
	table.Foreach(arg0_40.seriesNodes, function(arg0_41, arg1_41)
		setActive(arg1_41:Find("clear/common"), arg1_40 ~= arg1_41)
		setActive(arg1_41:Find("clear/current"), arg1_40 == arg1_41)
		setActive(arg1_41:Find("active/common"), arg1_40 ~= arg1_41)
		setActive(arg1_41:Find("active/current"), arg1_40 == arg1_41)

		if arg1_40 == arg1_41 then
			arg0_40:playAnima(arg1_40, "anim_BossRushDALCollabUI_battle_in")
		end
	end)
end

function var0_0.updateShipPosition(arg0_42)
	local var0_42 = PlayerPrefs.GetInt("DAL_ship_position", 1)
	local var1_42 = arg0_42.activity:GetActiveSeriesIds()

	table.Foreach(arg0_42.seriesNodes, function(arg0_43, arg1_43)
		local var0_43 = var1_42[arg0_43]
		local var1_43 = arg1_43:Find("ship")

		var1_43:GetComponent(typeof(Animation)):Stop()

		if var0_42 == var0_43 then
			arg0_42:updateCurrent(arg1_43)

			arg0_42._currentShip = var1_43
		elseif var1_43 ~= arg0_42._lastShip then
			setActive(arg1_43:Find("ship"), false)
		end
	end)

	if arg0_42._lastShip then
		if arg0_42._lastShip ~= arg0_42._currentShip then
			arg0_42:playAnima(arg0_42._lastShip, "anim_BossRushDALCollabUI_ship_out")
			setActive(arg0_42._lastShip:Find("vx_teleport_2"), true)

			arg0_42.battleNodes:GetComponent(typeof(CanvasGroup)).interactable = false
		end
	else
		setActive(arg0_42._currentShip, true)
		setActive(arg0_42._currentShip:Find("vx_teleport_1"), true)
		arg0_42:playAnima(arg0_42._currentShip, "anim_BossRushDALCollabUI_ship_in")
	end

	return arg0_42._lastShip ~= arg0_42._currentShip
end

function var0_0.checkAllStory(arg0_44)
	local var0_44 = arg0_44.activity:GetCollabSeriesDataList()
	local var1_44 = {}

	for iter0_44, iter1_44 in pairs(var0_44) do
		if table.contains(arg0_44.activity:GetPassCounts(), iter0_44) then
			local var2_44 = iter1_44:GetStorys()

			for iter2_44, iter3_44 in ipairs(var2_44) do
				table.insert(var1_44, iter3_44)
			end
		end
	end

	local var3_44 = 1

	local function var4_44()
		var3_44 = var3_44 + 1

		local var0_45 = var1_44[var3_44]
		local var1_45
		local var2_45 = arg0_44.activity:getConfig("config_client").storys_unlock_story

		if var0_45 == nil and var2_45 then
			local var3_45 = pg.NewStoryMgr.GetInstance()

			var1_45 = true

			for iter0_45, iter1_45 in ipairs(var2_45[2]) do
				var1_45 = var1_45 and var3_45:IsPlayed(iter1_45)
			end

			var1_45 = var1_45 and not var3_45:IsPlayed(var2_45[1])
		end

		if var1_45 then
			local function var4_45()
				setActive(arg0_44.shiftMap:Find("map_6"), false)
				arg0_44:PlayMapShiftAnima("", "_3")
			end

			arg0_44:PlayStory(var2_45[1], var4_45)
		else
			arg0_44:PlayStory(var0_45, var4_44)
		end
	end

	arg0_44:PlayStory(var1_44[var3_44], var4_44)
end

function var0_0.GetFinalStoryName(arg0_47)
	local var0_47 = arg0_47.activity:GetCollabSeriesDataList()[6]
	local var1_47 = Clone(var0_47:getConfig("story_worldboss"))

	table.sort(var1_47, function(arg0_48, arg1_48)
		return arg0_48[2] < arg1_48[2]
	end)

	return var1_47[1][1]
end

function var0_0.PlayStory(arg0_49, arg1_49, arg2_49)
	if not arg1_49 then
		return
	end

	local var0_49 = pg.NewStoryMgr.GetInstance()

	if var0_49:IsPlayed(arg1_49) then
		return existCall(arg2_49)
	end

	if arg1_49 == arg0_49:GetFinalStoryName() then
		local function var1_49()
			arg0_49:PlayMapShiftAnima("_3", "")
		end

		var0_49:Play(arg1_49, var1_49)
	else
		var0_49:Play(arg1_49, arg2_49)
	end
end

function var0_0.UpdateTasks(arg0_51, arg1_51)
	if _.any(arg1_51, function(arg0_52)
		return arg0_51.storyTask and arg0_51.storyTask.id == arg0_52
	end) then
		arg0_51.storyTask.submitTime = 1

		arg0_51:UpdateView()
	end
end

function var0_0.addbubbleMsgBoxList(arg0_53, arg1_53)
	local var0_53 = #arg0_53.ActionSequence == 0

	table.insertto(arg0_53.ActionSequence, arg1_53)

	if not var0_53 then
		return
	end

	arg0_53:resumeBubble()
end

function var0_0.addbubbleMsgBox(arg0_54, arg1_54)
	local var0_54 = #arg0_54.ActionSequence == 0

	table.insert(arg0_54.ActionSequence, arg1_54)

	if not var0_54 then
		return
	end

	arg0_54:resumeBubble()
end

function var0_0.resumeBubble(arg0_55)
	if #arg0_55.ActionSequence == 0 then
		return
	end

	local var0_55

	local function var1_55()
		local var0_56 = arg0_55.ActionSequence[1]

		if var0_56 then
			var0_56(function()
				table.remove(arg0_55.ActionSequence, 1)
				var1_55()
			end)
		end
	end

	var1_55()
end

function var0_0.CleanBubbleMsgbox(arg0_58)
	table.clean(arg0_58.ActionSequence)
end

function var0_0.willExit(arg0_59)
	arg0_59:OverlayComponent(false)
	arg0_59.stageView:Destroy()
	arg0_59.upgradeView:Destroy()
	arg0_59.loader:Clear()
	var0_0.super.willExit(arg0_59)
end

return var0_0
