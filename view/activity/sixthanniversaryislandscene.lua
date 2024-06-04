local var0 = class("SixthAnniversaryIslandScene", import("..base.BaseUI"))

var0.optionsPath = {
	"top/btn_home"
}
var0.SHOP = "SixthAnniversaryIslandScene.SHOP"

function var0.getUIName(arg0)
	return "SixthAnniversaryIslandUI"
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.setNodeIds(arg0, arg1)
	arg0.ids = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1

	setText(arg0.rtResPanel:Find("tpl/Text"), arg0.player:getResById(350) or 0)
end

function var0.setResDrop(arg0, arg1, arg2)
	arg0.resDrop = arg1
	arg0.resDailyNumber = arg2

	setText(arg0.rtResPanel:Find("tpl_2/Text"), arg1.count or 0)
end

function var0.init(arg0)
	arg0.rtTop = arg0._tf:Find("top")

	pg.UIMgr.GetInstance():OverlayPanel(arg0.rtTop)

	arg0.effectObjs = {}
	arg0.proxy = getProxy(IslandProxy)

	local var0 = pg.TimeMgr.GetInstance()
	local var1 = arg0._tf:Find("map/content")

	arg0.nodeItemList = UIItemList.New(var1, var1:Find("node"))

	arg0.nodeItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.ids[arg1]
			local var1 = arg0.proxy:GetNode(var0)

			arg2.name = var1.id

			local var2, var3 = unpack(var1:getConfig("address"))

			setAnchoredPosition(arg2, {
				x = var2,
				y = var3
			})

			local var4 = var1:getConfig("type")

			eachChild(arg2:Find("main/type"), function(arg0)
				setActive(arg0, arg0.name == tostring(var4))
			end)
			setLocalScale(arg2, Vector3(0, 0, 1))
			setActive(arg2:Find("name"), var1:getConfig("icon_name") ~= "")
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.selectId = var0
					arg0.contextData.lastNodeId = var0
				end
			end)
			setActive(arg2:Find("click"), true)
			onButton(arg0, arg2:Find("click"), function()
				local var0 = arg0.proxy:GetNode(var0)

				triggerToggle(arg2, var0:CanToggleOn())

				if var0:CanTrigger() then
					arg0.isAutoPlayStory = false

					arg0:triggerNode(var0)
				elseif var0:IsRefresh() and var0:IsCompleted() then
					local var1 = var0:GetNextTime(0, 0, 0) - var0:GetServerTime()
					local var2 = 3
					local var3

					var3 = Timer.New(function()
						if arg0.exited then
							var3:Stop()

							var3 = nil
						end

						if var2 == 0 then
							setActive(arg2:Find("main/time"), false)
						else
							setText(arg2:Find("main/time/Text"), i18n("islandnode_tips1") .. var0:DescCDTime(var1))

							var1 = var1 - 1
							var2 = var2 - 1
						end
					end, 1, 3)

					var3.func()
					var3:Start()
					setActive(arg2:Find("main/time"), true)
				end
			end, SFX_CONFIRM)
			arg0:refreshNode(var0)
		end
	end)

	local var2 = arg0.rtTop:Find("panel/content/mask/scroll_rect")

	arg0.panelItemList = UIItemList.New(var2, var2:Find("tpl"))

	arg0.panelItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.proxy:GetNode(arg0.dailyIds[arg1])

			arg2.name = var0.id

			GetImageSpriteFromAtlasAsync("ui/sixthanniversaryislandui_atlas", var0:getConfig("icon"), arg2:Find("Image"))
			setActive(arg2:Find("mask"), not var0:RedDotHint())
			onButton(arg0, arg2, function()
				arg0:focus(var0.id, LeanTweenType.easeInOutSine)
			end, SFX_PANEL)
		end
	end)
	triggerToggle(arg0.rtTop:Find("panel/toggle"), false)

	local var3 = arg0._tf:Find("top/focus")

	arg0.floatItemList = UIItemList.New(var3, var3:Find("main_mark"))

	arg0.floatItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			arg2.name = arg0.mainIds[arg1]

			onButton(arg0, arg2, function()
				arg0:focus(arg0.mainIds[arg1], LeanTweenType.easeInOutSine)
			end, SFX_PANEL)
		end
	end)

	arg0.rtResPanel = arg0.rtTop:Find("res")
	arg0.rtMap = arg0._tf:Find("map")

	arg0.rtMap:GetComponent(typeof(ScrollRect)).onValueChanged:AddListener(function()
		arg0:onDragFunction()
	end)

	local var4, var5, var6 = getSizeRate()

	arg0.delta = Vector2(var5 - 100, var6 - 100) / 2
	arg0.extendLimit = Vector2(arg0.rtMap.rect.width - arg0._tf.rect.width, arg0.rtMap.rect.height - arg0._tf.rect.height) / 2
	arg0.displayDic = {}

	onButton(arg0, arg0.rtTop:Find("btn_back"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	setActive(arg0.rtTop:Find("btn_now"), false)
	onButton(arg0, arg0.rtTop:Find("btns/btn_shop"), function()
		arg0:emit(SixthAnniversaryIslandMediator.GO_SHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.rtTop:Find("btns/btn_note"), function()
		arg0:emit(SixthAnniversaryIslandMediator.OPEN_NOTE)
	end, SFX_PANEL)
	onButton(arg0, arg0.rtTop:Find("btns/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("island_help")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.rtResPanel:Find("tpl"), function()
		arg0:emit(SixthAnniversaryIslandMediator.OPEN_RES, {
			id = 350,
			type = 1
		}, "")
	end, SFX_PANEL)
	onButton(arg0, arg0.rtResPanel:Find("tpl_2"), function()
		arg0:emit(SixthAnniversaryIslandMediator.OPEN_RES, Clone(arg0.resDrop), i18n("island_game_limit_help", arg0.resDailyNumber))
	end, SFX_PANEL)
end

function var0.onDragFunction(arg0)
	if not var0.screenPoints then
		var0.screenPoints = {
			Vector2(-arg0.delta.x, arg0.delta.y),
			Vector2(arg0.delta.x, arg0.delta.y),
			Vector2(arg0.delta.x, -arg0.delta.y),
			Vector2(-arg0.delta.x, -arg0.delta.y)
		}
	end

	for iter0, iter1 in ipairs(arg0.mainIds) do
		local var0 = arg0.nodeItemList.container:Find(iter1)
		local var1 = arg0._tf:InverseTransformPoint(var0.position)
		local var2

		for iter2, iter3 in ipairs(var0.screenPoints) do
			local var3 = var0.screenPoints[iter2 % 4 + 1]
			local var4, var5, var6 = LineLine(Vector2.zero, Vector2(var1.x, var1.y), iter3, var3)

			if var4 then
				var2 = var1 * var5

				break
			end
		end

		local var7 = arg0.floatItemList.container:Find(iter1)
		local var8 = var7:GetComponent(typeof(CanvasGroup))

		var8.interactable = tobool(var2)
		var8.blocksRaycasts = tobool(var2)
		var8.alpha = tobool(var2) and 1 or 0

		if var2 then
			setAnchoredPosition(var7, var2 * (1 - 50 / var2:Magnitude()))

			local var9 = math.rad2Deg * math.atan2(var2.y, var2.x) - 45

			setLocalEulerAngles(var7:Find("arrow"), {
				z = var9
			})
			setLocalEulerAngles(var7:Find("arrow_shadow"), {
				z = var9
			})
		end
	end
end

function var0.focus(arg0, arg1, arg2, arg3)
	local var0 = arg0.nodeItemList.container:Find(arg1)

	if not arg3 then
		triggerToggle(var0, arg0.proxy:GetNode(arg1):CanToggleOn())
	end

	local var1 = var0.anchoredPosition * -1

	var1.x = math.clamp(var1.x, -arg0.extendLimit.x, arg0.extendLimit.x)
	var1.y = math.clamp(var1.y, -arg0.extendLimit.y, arg0.extendLimit.y)

	if arg0.twFocusId then
		LeanTween.cancel(arg0.twFocusId)

		arg0.twFocusId = nil
	end

	if arg2 then
		local var2 = {}

		table.insert(var2, function(arg0)
			SetCompomentEnabled(arg0.rtMap, typeof(ScrollRect), false)

			local var0 = (arg0.rtMap.anchoredPosition - var1).magnitude
			local var1 = var0 > 0 and var0 / (40 * math.sqrt(var0)) or 0

			arg0.twFocusId = LeanTween.move(arg0.rtMap, Vector3(var1.x, var1.y), var1):setEase(arg2):setOnUpdate(System.Action_float(function(arg0)
				arg0:onDragFunction()
			end)):setOnComplete(System.Action(arg0)).uniqueId
		end)
		seriesAsync(var2, function()
			SetCompomentEnabled(arg0.rtMap, typeof(ScrollRect), true)
		end)
	else
		arg0.rtMap.anchoredPosition = var1

		arg0:onDragFunction()
	end
end

function var0.triggerNode(arg0, arg1)
	local var0 = getProxy(IslandProxy):GetNode(arg1)

	if var0:IsNew() then
		arg0:emit(SixthAnniversaryIslandMediator.MARK_NODE_AFTER_NEW, arg1)
	end

	if var0:IsCompleted() then
		if var0:getConfig("type") == 5 then
			arg0:emit(SixthAnniversaryIslandMediator.INTO_ENTRANCE, var0:getConfig("params")[1])
		end
	else
		arg0:triggerEvent(var0)
	end
end

function var0.triggerEvent(arg0, arg1)
	assert(arg1.eventId and arg1.eventId ~= 0)

	local var0 = IslandEvent.New({
		id = arg1.eventId
	})

	switch(var0:getConfig("type"), {
		[3] = function()
			local var0 = {}
			local var1 = var0:getConfig("story")

			if var1 and var1 ~= "" then
				table.insert(var0, function(arg0)
					if arg0.isAutoPlayStory then
						pg.NewStoryMgr.GetInstance():ForceAutoPlay(var1, arg0)
					else
						pg.NewStoryMgr.GetInstance():ForceManualPlay(var1, arg0)
					end
				end)
				table.insert(var0, function(arg0, arg1, arg2, arg3)
					arg0.isAutoPlayStory = arg3

					arg0(arg2)
				end)
			end

			seriesAsync(var0, function(arg0)
				arg0:emit(SixthAnniversaryIslandMediator.OPEN_QTE_GAME, var0:getConfig("params")[1], function(arg0)
					arg0:emit(SixthAnniversaryIslandMediator.TRIGGER_NODE_EVENT, arg1.id, arg0 or 0)
				end)
			end)
		end
	}, function()
		local var0 = {}
		local var1 = var0:getConfig("story")

		if var1 and var1 ~= "" then
			table.insert(var0, function(arg0)
				if arg0.isAutoPlayStory then
					pg.NewStoryMgr.GetInstance():ForceAutoPlay(var1, arg0, true)
				else
					pg.NewStoryMgr.GetInstance():ForceManualPlay(var1, arg0, true)
				end
			end)
			table.insert(var0, function(arg0, arg1, arg2, arg3)
				arg0.isAutoPlayStory = arg3

				arg0(arg2)
			end)
		end

		seriesAsync(var0, function(arg0)
			arg0:emit(SixthAnniversaryIslandMediator.TRIGGER_NODE_EVENT, arg1.id, arg0 or 0)
		end)
	end)
end

function var0.afterTriggerEvent(arg0, arg1)
	local var0 = arg0.proxy:GetNode(arg1)

	if var0:IsCompleted() then
		underscore.each(arg0.ids, function(arg0)
			arg0:refreshNode(arg0)
		end)
		arg0:refreshDailyPanel()
	else
		arg0:refreshNode(arg1)
	end

	if var0:CanTrigger() then
		triggerToggle(arg0.nodeItemList.container:Find(arg1), var0:CanToggleOn())
		arg0:triggerNode(arg1)
	end
end

function var0.refreshNode(arg0, arg1)
	local var0 = arg0.nodeItemList.container:Find(arg1)
	local var1 = getProxy(IslandProxy):GetNode(arg1)
	local var2 = var1:IsVisual()

	setActive(var0:Find("click"), var2)

	local var3 = var2 and var1:GetScale() or 0
	local var4 = Vector3(var3, var3, 1)

	if var0.localScale ~= var4 then
		LeanTween.cancel(var0)
		LeanTween.scale(var0, var4, 0.3):setEase(LeanTweenType.easeInOutSine)
	end

	if var2 and not arg0.displayDic[arg1] then
		arg0.displayDic[arg1] = true

		local var5 = var1:getConfig("icon")

		if var5 == "" then
			SetCompomentEnabled(var0:Find("main"), typeof(Image), false)
			SetCompomentEnabled(var0:Find("selected_back/light"), typeof(Image), false)
		else
			GetSpriteFromAtlasAsync("ui/sixthanniversaryislandui_atlas", var5, function(arg0)
				setImageSprite(var0:Find("main"), arg0)
				setImageSprite(var0:Find("main/mask"), arg0)
			end)
			GetImageSpriteFromAtlasAsync("ui/sixthanniversaryislandui_atlas", var5 .. "_light", var0:Find("selected_back/light"))
		end

		if var1:getConfig("icon_name") ~= "" then
			GetImageSpriteFromAtlasAsync("ui/sixthanniversaryislandui_atlas", var1:getConfig("icon_name"), var0:Find("name/Image"), true)
		end

		local var6 = var1:GetEffectName()

		if var6 ~= "" then
			pg.PoolMgr.GetInstance():GetUI(var6, true, function(arg0)
				table.insert(arg0.effectObjs, {
					name = var6,
					go = arg0
				})
				setParent(arg0, var0:Find("click"), false)
			end)
		end
	end

	setActive(var0:Find("main/type"), var1:RedDotHint())

	local var7 = var1:IsRefresh() and var1:IsCompleted()

	setActive(var0:Find("name"), not var7 and not var1:IsTreasure())
	setActive(var0:Find("main/mask"), var7)
	setActive(var0:Find("main/time"), false)
	setActive(var0:Find("main/new"), var1:IsNew())

	local var8 = GetOrAddComponent(var0:Find("main"), typeof("LOutLine"))

	ReflectionHelp.RefSetField(typeof("LOutLine"), "OutlineWidth", var8, var7 and 0 or 3)
	ReflectionHelp.RefCallMethod(typeof("LOutLine"), "_Refresh", var8)
	triggerToggle(var0, arg0.selectId == arg1 and var1:CanToggleOn())
end

function var0.refreshDailyPanel(arg0)
	arg0.dailyIds = underscore.select(arg0.ids, function(arg0)
		local var0 = arg0.proxy:GetNode(arg0)

		return (var0:IsRefresh() or var0:IsFlowerField()) and var0:IsVisual()
	end)

	arg0.panelItemList:align(#arg0.dailyIds)

	arg0.mainIds = underscore.select(arg0.ids, function(arg0)
		local var0 = arg0.proxy:GetNode(arg0)

		return var0:IsMain() and var0:IsVisual()
	end)

	arg0.floatItemList:align(#arg0.mainIds)
	arg0:onDragFunction()
end

function var0.focusList(arg0, arg1, arg2, arg3)
	for iter0, iter1 in ipairs(arg1) do
		if arg0.proxy:GetNode(iter1):IsVisual() then
			arg0:focus(iter1, arg2, arg3)

			return true
		end
	end

	return false
end

function var0.didEnter(arg0)
	arg0.nodeItemList:align(#arg0.ids)
	arg0:refreshDailyPanel()
	arg0:updateTaskTip()

	local var0 = {}

	if arg0.contextData.nodeIds and #arg0.contextData.nodeIds > 0 then
		table.insert(var0, function(arg0)
			if not arg0:focusList(arg0.contextData.nodeIds) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("islandnode_tips8"))
				arg0()
			end

			arg0.contextData.nodeIds = nil
		end)
	elseif arg0.contextData.checkMain then
		table.insert(var0, function(arg0)
			local var0 = getProxy(IslandProxy)
			local var1 = underscore.filter(underscore.map(arg0.ids, function(arg0)
				return var0:GetNode(arg0)
			end), function(arg0)
				return arg0:IsMain() and not arg0:IsCompleted()
			end)
			local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetTotalBuildingLevel()

			if #var1 > 0 and underscore.all(var1, function(arg0)
				return not arg0:IsUnlock() and arg0:getConfig("open_need")[1] > var2
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("islandnode_tips9"))
			end

			arg0()
		end)
	end

	arg0.contextData.checkMain = nil

	local var1 = {
		1001,
		1002,
		1003,
		1004,
		1005
	}

	if arg0.contextData.lastNodeId then
		table.insert(var1, 1, arg0.contextData.lastNodeId)
	end

	table.insert(var0, function(arg0)
		if not arg0:focusList(var1) then
			arg0()
		end
	end)
	seriesAsync(var0, function()
		arg0:focusList({
			1050,
			1051,
			1052,
			1053
		}, nil, true)
	end)

	local var2 = "HAIDAORICHANG2"

	pg.NewStoryMgr.GetInstance():Play(var2, function()
		if arg0.contextData.wraps then
			switch(arg0.contextData.wraps, {
				[var0.SHOP] = function()
					arg0:emit(SixthAnniversaryIslandMediator.GO_SHOP)
				end
			})

			arg0.contextData.wraps = nil
		end
	end)
end

function var0.updateTaskTip(arg0)
	setActive(arg0.rtTop:Find("btns/btn_note/tip"), getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.ISLAND_TASK_ID))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.rtTop, arg0._tf)
	arg0.rtMap:GetComponent(typeof(ScrollRect)).onValueChanged:RemoveAllListeners()

	local var0 = pg.PoolMgr.GetInstance()

	for iter0, iter1 in ipairs(arg0.effectObjs) do
		var0:ReturnUI(iter1.name, iter1.go)
	end
end

return var0
