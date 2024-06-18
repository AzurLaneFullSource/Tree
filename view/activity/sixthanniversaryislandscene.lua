local var0_0 = class("SixthAnniversaryIslandScene", import("..base.BaseUI"))

var0_0.optionsPath = {
	"top/btn_home"
}
var0_0.SHOP = "SixthAnniversaryIslandScene.SHOP"

function var0_0.getUIName(arg0_1)
	return "SixthAnniversaryIslandUI"
end

function var0_0.setActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
end

function var0_0.setNodeIds(arg0_3, arg1_3)
	arg0_3.ids = arg1_3
end

function var0_0.setPlayer(arg0_4, arg1_4)
	arg0_4.player = arg1_4

	setText(arg0_4.rtResPanel:Find("tpl/Text"), arg0_4.player:getResById(350) or 0)
end

function var0_0.setResDrop(arg0_5, arg1_5, arg2_5)
	arg0_5.resDrop = arg1_5
	arg0_5.resDailyNumber = arg2_5

	setText(arg0_5.rtResPanel:Find("tpl_2/Text"), arg1_5.count or 0)
end

function var0_0.init(arg0_6)
	arg0_6.rtTop = arg0_6._tf:Find("top")

	pg.UIMgr.GetInstance():OverlayPanel(arg0_6.rtTop)

	arg0_6.effectObjs = {}
	arg0_6.proxy = getProxy(IslandProxy)

	local var0_6 = pg.TimeMgr.GetInstance()
	local var1_6 = arg0_6._tf:Find("map/content")

	arg0_6.nodeItemList = UIItemList.New(var1_6, var1_6:Find("node"))

	arg0_6.nodeItemList:make(function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg0_6.ids[arg1_7]
			local var1_7 = arg0_6.proxy:GetNode(var0_7)

			arg2_7.name = var1_7.id

			local var2_7, var3_7 = unpack(var1_7:getConfig("address"))

			setAnchoredPosition(arg2_7, {
				x = var2_7,
				y = var3_7
			})

			local var4_7 = var1_7:getConfig("type")

			eachChild(arg2_7:Find("main/type"), function(arg0_8)
				setActive(arg0_8, arg0_8.name == tostring(var4_7))
			end)
			setLocalScale(arg2_7, Vector3(0, 0, 1))
			setActive(arg2_7:Find("name"), var1_7:getConfig("icon_name") ~= "")
			onToggle(arg0_6, arg2_7, function(arg0_9)
				if arg0_9 then
					arg0_6.selectId = var0_7
					arg0_6.contextData.lastNodeId = var0_7
				end
			end)
			setActive(arg2_7:Find("click"), true)
			onButton(arg0_6, arg2_7:Find("click"), function()
				local var0_10 = arg0_6.proxy:GetNode(var0_7)

				triggerToggle(arg2_7, var0_10:CanToggleOn())

				if var0_10:CanTrigger() then
					arg0_6.isAutoPlayStory = false

					arg0_6:triggerNode(var0_7)
				elseif var0_10:IsRefresh() and var0_10:IsCompleted() then
					local var1_10 = var0_6:GetNextTime(0, 0, 0) - var0_6:GetServerTime()
					local var2_10 = 3
					local var3_10

					var3_10 = Timer.New(function()
						if arg0_6.exited then
							var3_10:Stop()

							var3_10 = nil
						end

						if var2_10 == 0 then
							setActive(arg2_7:Find("main/time"), false)
						else
							setText(arg2_7:Find("main/time/Text"), i18n("islandnode_tips1") .. var0_6:DescCDTime(var1_10))

							var1_10 = var1_10 - 1
							var2_10 = var2_10 - 1
						end
					end, 1, 3)

					var3_10.func()
					var3_10:Start()
					setActive(arg2_7:Find("main/time"), true)
				end
			end, SFX_CONFIRM)
			arg0_6:refreshNode(var0_7)
		end
	end)

	local var2_6 = arg0_6.rtTop:Find("panel/content/mask/scroll_rect")

	arg0_6.panelItemList = UIItemList.New(var2_6, var2_6:Find("tpl"))

	arg0_6.panelItemList:make(function(arg0_12, arg1_12, arg2_12)
		arg1_12 = arg1_12 + 1

		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_6.proxy:GetNode(arg0_6.dailyIds[arg1_12])

			arg2_12.name = var0_12.id

			GetImageSpriteFromAtlasAsync("ui/sixthanniversaryislandui_atlas", var0_12:getConfig("icon"), arg2_12:Find("Image"))
			setActive(arg2_12:Find("mask"), not var0_12:RedDotHint())
			onButton(arg0_6, arg2_12, function()
				arg0_6:focus(var0_12.id, LeanTweenType.easeInOutSine)
			end, SFX_PANEL)
		end
	end)
	triggerToggle(arg0_6.rtTop:Find("panel/toggle"), false)

	local var3_6 = arg0_6._tf:Find("top/focus")

	arg0_6.floatItemList = UIItemList.New(var3_6, var3_6:Find("main_mark"))

	arg0_6.floatItemList:make(function(arg0_14, arg1_14, arg2_14)
		arg1_14 = arg1_14 + 1

		if arg0_14 == UIItemList.EventUpdate then
			arg2_14.name = arg0_6.mainIds[arg1_14]

			onButton(arg0_6, arg2_14, function()
				arg0_6:focus(arg0_6.mainIds[arg1_14], LeanTweenType.easeInOutSine)
			end, SFX_PANEL)
		end
	end)

	arg0_6.rtResPanel = arg0_6.rtTop:Find("res")
	arg0_6.rtMap = arg0_6._tf:Find("map")

	arg0_6.rtMap:GetComponent(typeof(ScrollRect)).onValueChanged:AddListener(function()
		arg0_6:onDragFunction()
	end)

	local var4_6, var5_6, var6_6 = getSizeRate()

	arg0_6.delta = Vector2(var5_6 - 100, var6_6 - 100) / 2
	arg0_6.extendLimit = Vector2(arg0_6.rtMap.rect.width - arg0_6._tf.rect.width, arg0_6.rtMap.rect.height - arg0_6._tf.rect.height) / 2
	arg0_6.displayDic = {}

	onButton(arg0_6, arg0_6.rtTop:Find("btn_back"), function()
		arg0_6:closeView()
	end, SFX_CANCEL)
	setActive(arg0_6.rtTop:Find("btn_now"), false)
	onButton(arg0_6, arg0_6.rtTop:Find("btns/btn_shop"), function()
		arg0_6:emit(SixthAnniversaryIslandMediator.GO_SHOP)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rtTop:Find("btns/btn_note"), function()
		arg0_6:emit(SixthAnniversaryIslandMediator.OPEN_NOTE)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rtTop:Find("btns/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("island_help")
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rtResPanel:Find("tpl"), function()
		arg0_6:emit(SixthAnniversaryIslandMediator.OPEN_RES, {
			id = 350,
			type = 1
		}, "")
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rtResPanel:Find("tpl_2"), function()
		arg0_6:emit(SixthAnniversaryIslandMediator.OPEN_RES, Clone(arg0_6.resDrop), i18n("island_game_limit_help", arg0_6.resDailyNumber))
	end, SFX_PANEL)
end

function var0_0.onDragFunction(arg0_23)
	if not var0_0.screenPoints then
		var0_0.screenPoints = {
			Vector2(-arg0_23.delta.x, arg0_23.delta.y),
			Vector2(arg0_23.delta.x, arg0_23.delta.y),
			Vector2(arg0_23.delta.x, -arg0_23.delta.y),
			Vector2(-arg0_23.delta.x, -arg0_23.delta.y)
		}
	end

	for iter0_23, iter1_23 in ipairs(arg0_23.mainIds) do
		local var0_23 = arg0_23.nodeItemList.container:Find(iter1_23)
		local var1_23 = arg0_23._tf:InverseTransformPoint(var0_23.position)
		local var2_23

		for iter2_23, iter3_23 in ipairs(var0_0.screenPoints) do
			local var3_23 = var0_0.screenPoints[iter2_23 % 4 + 1]
			local var4_23, var5_23, var6_23 = LineLine(Vector2.zero, Vector2(var1_23.x, var1_23.y), iter3_23, var3_23)

			if var4_23 then
				var2_23 = var1_23 * var5_23

				break
			end
		end

		local var7_23 = arg0_23.floatItemList.container:Find(iter1_23)
		local var8_23 = var7_23:GetComponent(typeof(CanvasGroup))

		var8_23.interactable = tobool(var2_23)
		var8_23.blocksRaycasts = tobool(var2_23)
		var8_23.alpha = tobool(var2_23) and 1 or 0

		if var2_23 then
			setAnchoredPosition(var7_23, var2_23 * (1 - 50 / var2_23:Magnitude()))

			local var9_23 = math.rad2Deg * math.atan2(var2_23.y, var2_23.x) - 45

			setLocalEulerAngles(var7_23:Find("arrow"), {
				z = var9_23
			})
			setLocalEulerAngles(var7_23:Find("arrow_shadow"), {
				z = var9_23
			})
		end
	end
end

function var0_0.focus(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg0_24.nodeItemList.container:Find(arg1_24)

	if not arg3_24 then
		triggerToggle(var0_24, arg0_24.proxy:GetNode(arg1_24):CanToggleOn())
	end

	local var1_24 = var0_24.anchoredPosition * -1

	var1_24.x = math.clamp(var1_24.x, -arg0_24.extendLimit.x, arg0_24.extendLimit.x)
	var1_24.y = math.clamp(var1_24.y, -arg0_24.extendLimit.y, arg0_24.extendLimit.y)

	if arg0_24.twFocusId then
		LeanTween.cancel(arg0_24.twFocusId)

		arg0_24.twFocusId = nil
	end

	if arg2_24 then
		local var2_24 = {}

		table.insert(var2_24, function(arg0_25)
			SetCompomentEnabled(arg0_24.rtMap, typeof(ScrollRect), false)

			local var0_25 = (arg0_24.rtMap.anchoredPosition - var1_24).magnitude
			local var1_25 = var0_25 > 0 and var0_25 / (40 * math.sqrt(var0_25)) or 0

			arg0_24.twFocusId = LeanTween.move(arg0_24.rtMap, Vector3(var1_24.x, var1_24.y), var1_25):setEase(arg2_24):setOnUpdate(System.Action_float(function(arg0_26)
				arg0_24:onDragFunction()
			end)):setOnComplete(System.Action(arg0_25)).uniqueId
		end)
		seriesAsync(var2_24, function()
			SetCompomentEnabled(arg0_24.rtMap, typeof(ScrollRect), true)
		end)
	else
		arg0_24.rtMap.anchoredPosition = var1_24

		arg0_24:onDragFunction()
	end
end

function var0_0.triggerNode(arg0_28, arg1_28)
	local var0_28 = getProxy(IslandProxy):GetNode(arg1_28)

	if var0_28:IsNew() then
		arg0_28:emit(SixthAnniversaryIslandMediator.MARK_NODE_AFTER_NEW, arg1_28)
	end

	if var0_28:IsCompleted() then
		if var0_28:getConfig("type") == 5 then
			arg0_28:emit(SixthAnniversaryIslandMediator.INTO_ENTRANCE, var0_28:getConfig("params")[1])
		end
	else
		arg0_28:triggerEvent(var0_28)
	end
end

function var0_0.triggerEvent(arg0_29, arg1_29)
	assert(arg1_29.eventId and arg1_29.eventId ~= 0)

	local var0_29 = IslandEvent.New({
		id = arg1_29.eventId
	})

	switch(var0_29:getConfig("type"), {
		[3] = function()
			local var0_30 = {}
			local var1_30 = var0_29:getConfig("story")

			if var1_30 and var1_30 ~= "" then
				table.insert(var0_30, function(arg0_31)
					if arg0_29.isAutoPlayStory then
						pg.NewStoryMgr.GetInstance():ForceAutoPlay(var1_30, arg0_31)
					else
						pg.NewStoryMgr.GetInstance():ForceManualPlay(var1_30, arg0_31)
					end
				end)
				table.insert(var0_30, function(arg0_32, arg1_32, arg2_32, arg3_32)
					arg0_29.isAutoPlayStory = arg3_32

					arg0_32(arg2_32)
				end)
			end

			seriesAsync(var0_30, function(arg0_33)
				arg0_29:emit(SixthAnniversaryIslandMediator.OPEN_QTE_GAME, var0_29:getConfig("params")[1], function(arg0_34)
					arg0_29:emit(SixthAnniversaryIslandMediator.TRIGGER_NODE_EVENT, arg1_29.id, arg0_34 or 0)
				end)
			end)
		end
	}, function()
		local var0_35 = {}
		local var1_35 = var0_29:getConfig("story")

		if var1_35 and var1_35 ~= "" then
			table.insert(var0_35, function(arg0_36)
				if arg0_29.isAutoPlayStory then
					pg.NewStoryMgr.GetInstance():ForceAutoPlay(var1_35, arg0_36, true)
				else
					pg.NewStoryMgr.GetInstance():ForceManualPlay(var1_35, arg0_36, true)
				end
			end)
			table.insert(var0_35, function(arg0_37, arg1_37, arg2_37, arg3_37)
				arg0_29.isAutoPlayStory = arg3_37

				arg0_37(arg2_37)
			end)
		end

		seriesAsync(var0_35, function(arg0_38)
			arg0_29:emit(SixthAnniversaryIslandMediator.TRIGGER_NODE_EVENT, arg1_29.id, arg0_38 or 0)
		end)
	end)
end

function var0_0.afterTriggerEvent(arg0_39, arg1_39)
	local var0_39 = arg0_39.proxy:GetNode(arg1_39)

	if var0_39:IsCompleted() then
		underscore.each(arg0_39.ids, function(arg0_40)
			arg0_39:refreshNode(arg0_40)
		end)
		arg0_39:refreshDailyPanel()
	else
		arg0_39:refreshNode(arg1_39)
	end

	if var0_39:CanTrigger() then
		triggerToggle(arg0_39.nodeItemList.container:Find(arg1_39), var0_39:CanToggleOn())
		arg0_39:triggerNode(arg1_39)
	end
end

function var0_0.refreshNode(arg0_41, arg1_41)
	local var0_41 = arg0_41.nodeItemList.container:Find(arg1_41)
	local var1_41 = getProxy(IslandProxy):GetNode(arg1_41)
	local var2_41 = var1_41:IsVisual()

	setActive(var0_41:Find("click"), var2_41)

	local var3_41 = var2_41 and var1_41:GetScale() or 0
	local var4_41 = Vector3(var3_41, var3_41, 1)

	if var0_41.localScale ~= var4_41 then
		LeanTween.cancel(var0_41)
		LeanTween.scale(var0_41, var4_41, 0.3):setEase(LeanTweenType.easeInOutSine)
	end

	if var2_41 and not arg0_41.displayDic[arg1_41] then
		arg0_41.displayDic[arg1_41] = true

		local var5_41 = var1_41:getConfig("icon")

		if var5_41 == "" then
			SetCompomentEnabled(var0_41:Find("main"), typeof(Image), false)
			SetCompomentEnabled(var0_41:Find("selected_back/light"), typeof(Image), false)
		else
			GetSpriteFromAtlasAsync("ui/sixthanniversaryislandui_atlas", var5_41, function(arg0_42)
				setImageSprite(var0_41:Find("main"), arg0_42)
				setImageSprite(var0_41:Find("main/mask"), arg0_42)
			end)
			GetImageSpriteFromAtlasAsync("ui/sixthanniversaryislandui_atlas", var5_41 .. "_light", var0_41:Find("selected_back/light"))
		end

		if var1_41:getConfig("icon_name") ~= "" then
			GetImageSpriteFromAtlasAsync("ui/sixthanniversaryislandui_atlas", var1_41:getConfig("icon_name"), var0_41:Find("name/Image"), true)
		end

		local var6_41 = var1_41:GetEffectName()

		if var6_41 ~= "" then
			pg.PoolMgr.GetInstance():GetUI(var6_41, true, function(arg0_43)
				table.insert(arg0_41.effectObjs, {
					name = var6_41,
					go = arg0_43
				})
				setParent(arg0_43, var0_41:Find("click"), false)
			end)
		end
	end

	setActive(var0_41:Find("main/type"), var1_41:RedDotHint())

	local var7_41 = var1_41:IsRefresh() and var1_41:IsCompleted()

	setActive(var0_41:Find("name"), not var7_41 and not var1_41:IsTreasure())
	setActive(var0_41:Find("main/mask"), var7_41)
	setActive(var0_41:Find("main/time"), false)
	setActive(var0_41:Find("main/new"), var1_41:IsNew())

	local var8_41 = GetOrAddComponent(var0_41:Find("main"), typeof("LOutLine"))

	ReflectionHelp.RefSetField(typeof("LOutLine"), "OutlineWidth", var8_41, var7_41 and 0 or 3)
	ReflectionHelp.RefCallMethod(typeof("LOutLine"), "_Refresh", var8_41)
	triggerToggle(var0_41, arg0_41.selectId == arg1_41 and var1_41:CanToggleOn())
end

function var0_0.refreshDailyPanel(arg0_44)
	arg0_44.dailyIds = underscore.select(arg0_44.ids, function(arg0_45)
		local var0_45 = arg0_44.proxy:GetNode(arg0_45)

		return (var0_45:IsRefresh() or var0_45:IsFlowerField()) and var0_45:IsVisual()
	end)

	arg0_44.panelItemList:align(#arg0_44.dailyIds)

	arg0_44.mainIds = underscore.select(arg0_44.ids, function(arg0_46)
		local var0_46 = arg0_44.proxy:GetNode(arg0_46)

		return var0_46:IsMain() and var0_46:IsVisual()
	end)

	arg0_44.floatItemList:align(#arg0_44.mainIds)
	arg0_44:onDragFunction()
end

function var0_0.focusList(arg0_47, arg1_47, arg2_47, arg3_47)
	for iter0_47, iter1_47 in ipairs(arg1_47) do
		if arg0_47.proxy:GetNode(iter1_47):IsVisual() then
			arg0_47:focus(iter1_47, arg2_47, arg3_47)

			return true
		end
	end

	return false
end

function var0_0.didEnter(arg0_48)
	arg0_48.nodeItemList:align(#arg0_48.ids)
	arg0_48:refreshDailyPanel()
	arg0_48:updateTaskTip()

	local var0_48 = {}

	if arg0_48.contextData.nodeIds and #arg0_48.contextData.nodeIds > 0 then
		table.insert(var0_48, function(arg0_49)
			if not arg0_48:focusList(arg0_48.contextData.nodeIds) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("islandnode_tips8"))
				arg0_49()
			end

			arg0_48.contextData.nodeIds = nil
		end)
	elseif arg0_48.contextData.checkMain then
		table.insert(var0_48, function(arg0_50)
			local var0_50 = getProxy(IslandProxy)
			local var1_50 = underscore.filter(underscore.map(arg0_48.ids, function(arg0_51)
				return var0_50:GetNode(arg0_51)
			end), function(arg0_52)
				return arg0_52:IsMain() and not arg0_52:IsCompleted()
			end)
			local var2_50 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetTotalBuildingLevel()

			if #var1_50 > 0 and underscore.all(var1_50, function(arg0_53)
				return not arg0_53:IsUnlock() and arg0_53:getConfig("open_need")[1] > var2_50
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("islandnode_tips9"))
			end

			arg0_50()
		end)
	end

	arg0_48.contextData.checkMain = nil

	local var1_48 = {
		1001,
		1002,
		1003,
		1004,
		1005
	}

	if arg0_48.contextData.lastNodeId then
		table.insert(var1_48, 1, arg0_48.contextData.lastNodeId)
	end

	table.insert(var0_48, function(arg0_54)
		if not arg0_48:focusList(var1_48) then
			arg0_54()
		end
	end)
	seriesAsync(var0_48, function()
		arg0_48:focusList({
			1050,
			1051,
			1052,
			1053
		}, nil, true)
	end)

	local var2_48 = "HAIDAORICHANG2"

	pg.NewStoryMgr.GetInstance():Play(var2_48, function()
		if arg0_48.contextData.wraps then
			switch(arg0_48.contextData.wraps, {
				[var0_0.SHOP] = function()
					arg0_48:emit(SixthAnniversaryIslandMediator.GO_SHOP)
				end
			})

			arg0_48.contextData.wraps = nil
		end
	end)
end

function var0_0.updateTaskTip(arg0_58)
	setActive(arg0_58.rtTop:Find("btns/btn_note/tip"), getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.ISLAND_TASK_ID))
end

function var0_0.willExit(arg0_59)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_59.rtTop, arg0_59._tf)
	arg0_59.rtMap:GetComponent(typeof(ScrollRect)).onValueChanged:RemoveAllListeners()

	local var0_59 = pg.PoolMgr.GetInstance()

	for iter0_59, iter1_59 in ipairs(arg0_59.effectObjs) do
		var0_59:ReturnUI(iter1_59.name, iter1_59.go)
	end
end

return var0_0
