EventConst = require("view/event/EventConst")
EventListItem = require("view/event/EventListItem")
EventDetailPanel = require("view/event/EventDetailPanel")

local var0_0 = class("EventListScene", import("..base.BaseUI"))
local var1_0 = {
	{
		0,
		1,
		3,
		4,
		6
	},
	{
		2,
		5
	}
}

function var0_0.getUIName(arg0_1)
	return "EventUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"shiptype",
		"ui/iconcolorful"
	}

	local function var1_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	local function var2_2(arg0_4)
		if not arg0_4 or not arg0_4.type or not arg0_4.id then
			return
		end

		local var0_4 = Drop.Create({
			arg0_4.type,
			arg0_4.id,
			arg0_4.nums or arg0_4.count or 1
		})

		var1_2(var0_4:getIcon())
		var1_2(var0_4:getDefaultIcon())
	end

	local var3_2 = getProxy(EventProxy):getEventList() or {}
	local var4_2 = getProxy(BayProxy)

	for iter0_2, iter1_2 in ipairs(var3_2) do
		var1_2("eventtype/" .. iter1_2.template.icon)

		for iter2_2, iter3_2 in ipairs(iter1_2.template.drop_display or {}) do
			var2_2(iter3_2)
		end

		var2_2(iter1_2.template.special_drop)

		for iter4_2, iter5_2 in ipairs(iter1_2.shipIds or {}) do
			local var5_2 = var4_2:RawGetShipById(iter5_2)

			if var5_2 then
				var1_2("SquareIcon/" .. var5_2:getPainting())
			end
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_5)
	function arg0_5.dispatch(...)
		arg0_5:emit(...)
	end

	arg0_5.blurPanel = arg0_5._tf:Find("blur_panel")
	arg0_5.lay = arg0_5.blurPanel:Find("adapt/left_length")
	arg0_5.topPanel = arg0_5._tf:Find("blur_panel/adapt/top").gameObject
	arg0_5.btnBack = arg0_5._tf:Find("blur_panel/adapt/top/back_btn").gameObject
	arg0_5.topLeft = arg0_5._tf:Find("blur_panel/adapt/top/topLeftBg$")
	arg0_5.topLeftBg = arg0_5._tf:Find("blur_panel/adapt/top/topLeftBg$").gameObject
	arg0_5.labelShipNums = arg0_5._tf:Find("blur_panel/adapt/top/topLeftBg$/labelShipNums$"):GetComponent("Text")
	arg0_5.mask = arg0_5._tf:Find("mask$"):GetComponent("Image")
	arg0_5.scrollItem = EventListItem.New(arg0_5._tf:Find("blur_panel/scrollItem").gameObject, arg0_5.dispatch)

	arg0_5.scrollItem.go:SetActive(false)

	arg0_5.detailPanel = EventDetailPanel.New(arg0_5._tf:Find("detailPanel").gameObject, arg0_5.dispatch)

	arg0_5.detailPanel.go:SetActive(false)

	arg0_5.scrollRectObj = arg0_5._tf:Find("scrollRect$")
	arg0_5.scrollRect = arg0_5.scrollRectObj:GetComponent("LScrollRect")

	function arg0_5.scrollRect.onInitItem(arg0_7)
		arg0_5:onInitItem(arg0_7)
	end

	function arg0_5.scrollRect.onUpdateItem(arg0_8, arg1_8)
		arg0_5:onUpdateItem(arg0_8, arg1_8)
	end

	function arg0_5.scrollRect.onReturnItem(arg0_9, arg1_9)
		arg0_5:onReturnItem(arg0_9, arg1_9)
	end

	arg0_5.scrollItems = {}
	arg0_5.selectedItem = nil
	arg0_5.rawLayouts = {}

	setImageAlpha(arg0_5.mask, 0)

	arg0_5.scrollRect.decelerationRate = 0.07
	arg0_5.listEmptyTF = arg0_5._tf:Find("empty")

	setActive(arg0_5.listEmptyTF, false)

	arg0_5.listEmptyTxt = arg0_5.listEmptyTF:Find("Text")

	setText(arg0_5.listEmptyTxt, i18n("list_empty_tip_eventui"))
end

local var2_0 = {
	"daily",
	"urgency"
}

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.btnBack, function()
		if arg0_10.selectedItem then
			arg0_10:easeOut(function()
				arg0_10:emit(var0_0.ON_BACK)
			end)
		else
			arg0_10:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	setActive(arg0_10._tf:Find("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_10._tf:Find("stamp"), false)
	end

	onButton(arg0_10, arg0_10._tf:Find("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(9)
	end, SFX_CONFIRM)

	arg0_10.toggles = {}
	arg0_10.toggleIndex = -1

	for iter0_10, iter1_10 in ipairs(var2_0) do
		arg0_10.toggles[iter0_10] = arg0_10.lay:Find("frame/scroll_rect/tagRoot/" .. iter1_10 .. "_btn")

		onToggle(arg0_10, arg0_10.toggles[iter0_10], function(arg0_14)
			local var0_14 = arg0_10.toggleIndex == -1

			if arg0_14 and arg0_10.toggleIndex ~= iter0_10 then
				arg0_10.toggleIndex = iter0_10

				if arg0_10.selectedItem then
					pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10.blurPanel, arg0_10._tf)

					local var1_14 = arg0_10.scrollRect.content
					local var2_14 = var1_14.childCount
					local var3_14 = 1000000

					for iter0_14 = 0, var2_14 - 1 do
						local var4_14 = var1_14:GetChild(iter0_14)

						if var4_14 == arg0_10.selectedItem.tr then
							var3_14 = iter0_14
						elseif var3_14 < iter0_14 then
							var4_14:GetComponent(typeof(LayoutElement)).ignoreLayout = arg0_10.rawLayouts[var4_14] or false
						end
					end

					arg0_10.rawLayouts = {}

					arg0_10.mask.gameObject:SetActive(false)
					arg0_10.scrollItem.go:SetActive(false)
					arg0_10.detailPanel.go:SetActive(false)

					arg0_10.scrollRect.enabled = true
					arg0_10.selectedItem = nil
					arg0_10.contextData.selectedEventId = nil
				end

				arg0_10.contextData.index = iter0_10

				arg0_10:Flush(not var0_14)
			end
		end)
	end

	local var0_10 = arg0_10.contextData.index or 1

	triggerToggle(arg0_10.toggles[var0_10], true)

	local function var1_10()
		if arg0_10.scrollItem.event:GetState() == EventInfo.StateFinish then
			arg0_10.dispatch(EventConst.EVENT_FINISH, arg0_10.scrollItem.event)
		else
			arg0_10:easeOut()
		end
	end

	onButton(arg0_10, arg0_10.scrollItem.bgNormal, var1_10, SFX_PANEL)
	onButton(arg0_10, arg0_10.scrollItem.bgEmergence, var1_10, SFX_PANEL)
	onButton(arg0_10, arg0_10.mask.gameObject, function()
		arg0_10:easeOut()
	end, SFX_CANCEL)
	arg0_10:ctimer()
	arg0_10:updateBtnTip()
end

function var0_0.onBackPressed(arg0_17)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_17.btnBack)
end

function var0_0.setEventList(arg0_18, arg1_18)
	arg0_18.eventList = arg1_18
end

function var0_0.updateAll(arg0_19)
	if arg0_19.selectedItem then
		local var0_19 = underscore.detect(arg0_19.eventList, function(arg0_20)
			return arg0_20.id == arg0_19.selectedItem.event.id
		end)

		if var0_19 then
			local var1_19 = getProxy(EventProxy)

			arg0_19.labelShipNums.text = var1_19.maxFleetNums - var1_19:countBusyFleetNums() .. "/" .. var1_19.maxFleetNums

			arg0_19.scrollItem:Update(arg0_19.selectedItem.index, var0_19)
			arg0_19.detailPanel:Update(arg0_19.selectedItem.index, var0_19)
		else
			arg0_19:easeOut()
		end

		arg0_19.invalide = true
	else
		arg0_19:Flush()
	end

	arg0_19:updateBtnTip()
end

function var0_0.Flush(arg0_21, arg1_21)
	arg1_21 = false

	local var0_21 = getProxy(EventProxy)

	if var0_21:checkZeroHourEvent() then
		arg0_21.dispatch(EventConst.EVENT_FLUSH_ALL)

		return
	elseif var2_0[arg0_21.contextData.index] == "urgency" and var0_21:checkNightEvent() then
		arg0_21.dispatch(EventConst.EVENT_FLUSH_ALL)

		return
	end

	if not arg1_21 then
		arg0_21.labelShipNums.text = var0_21.maxFleetNums - var0_21:countBusyFleetNums() .. "/" .. var0_21.maxFleetNums

		if arg0_21.contextData.selectedEventId then
			pg.UIMgr.GetInstance():LoadingOn()
			seriesAsync({
				function(arg0_22)
					if arg0_21.scrollRect.isStart then
						arg0_22()
					else
						arg0_21.scrollRect.onStart = arg0_22
					end
				end,
				function(arg0_23)
					local var0_23 = arg0_21.contextData.selectedEventId
					local var1_23 = 1

					for iter0_23, iter1_23 in ipairs(arg0_21.filterEventList) do
						if iter1_23.id == var0_23 then
							var1_23 = iter0_23

							break
						end
					end

					local var2_23 = arg0_21.scrollRect:HeadIndexToValue(var1_23 - 1)

					arg0_21.scrollRect:ScrollTo(var2_23)

					for iter2_23, iter3_23 in pairs(arg0_21.scrollItems) do
						if iter3_23.event and iter3_23.event.id == var0_23 then
							arg0_21.selectedItem = iter3_23

							arg0_21:showDetail()

							break
						end
					end

					arg0_23()
				end
			}, function()
				pg.UIMgr.GetInstance():LoadingOff()
			end)
		end
	end

	arg0_21:filter()
	arg0_21.scrollRect:SetTotalCount(#arg0_21.filterEventList, arg1_21 and 0 or arg0_21.scrollRect.value)
	setActive(arg0_21.listEmptyTF, #arg0_21.filterEventList <= 0)
end

function var0_0.filter(arg0_25)
	arg0_25.filterEventList = {}

	local var0_25 = var1_0[arg0_25.contextData.index]

	for iter0_25, iter1_25 in ipairs(arg0_25.eventList) do
		for iter2_25, iter3_25 in ipairs(var0_25) do
			if iter1_25.template.type == iter3_25 then
				table.insert(arg0_25.filterEventList, iter1_25)

				break
			end
		end
	end

	table.sort(arg0_25.filterEventList, CompareFuncs({
		function(arg0_26)
			return arg0_26:IsActivityType() and 0 or 1
		end,
		function(arg0_27)
			return -arg0_27:GetState()
		end,
		function(arg0_28)
			return arg0_28.template.type == 3 and 0 or 1
		end,
		function(arg0_29)
			return arg0_29.overTime == 0 and 0 or 1
		end,
		function(arg0_30)
			return arg0_30.id
		end
	}))
end

function var0_0.onInitItem(arg0_31, arg1_31)
	local var0_31 = EventListItem.New(arg1_31, arg0_31.dispatch)

	local function var1_31()
		if var0_31.event:GetState() == EventInfo.StateFinish then
			arg0_31.dispatch(EventConst.EVENT_FINISH, var0_31.event)
		else
			arg0_31:easeIn(var0_31)
		end
	end

	onButton(arg0_31, var0_31.bgNormal, var1_31, SFX_PANEL)
	onButton(arg0_31, var0_31.bgEmergence, var1_31, SFX_PANEL)

	arg0_31.scrollItems[arg1_31] = var0_31
end

function var0_0.onUpdateItem(arg0_33, arg1_33, arg2_33)
	GetComponent(tf(arg2_33), "CanvasGroup").alpha = 1

	local var0_33 = arg0_33.scrollItems[arg2_33]

	if not var0_33 then
		arg0_33:onInitItem(arg2_33)

		var0_33 = arg0_33.scrollItems[arg2_33]
	end

	local var1_33 = arg0_33.filterEventList[arg1_33 + 1]

	if var1_33 then
		var0_33:Update(arg1_33, var1_33)
		var0_33:UpdateTime()
	end
end

function var0_0.onReturnItem(arg0_34, arg1_34, arg2_34)
	if arg0_34.scrollItems and arg0_34.scrollItems[arg2_34] then
		arg0_34.scrollItems[arg2_34]:Clear()
	end
end

function var0_0.easeIn(arg0_35, arg1_35)
	if not arg0_35.easing then
		arg0_35.easing = true
		arg0_35.selectedItem = arg1_35

		arg0_35:setOpEnabled(false)
		arg0_35:easeInDetail(function()
			pg.UIMgr.GetInstance():BlurPanel(arg0_35.blurPanel)

			arg0_35.easing = false

			arg0_35:setOpEnabled(true)
		end)
	end
end

function var0_0.easeOut(arg0_37, arg1_37)
	if not arg0_37.easing then
		arg0_37.easing = true

		arg0_37:setOpEnabled(false)
		arg0_37:easeOutDetail(function()
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_37.blurPanel, arg0_37._tf)

			arg0_37.easing = false
			arg0_37.selectedItem = nil
			arg0_37.contextData.selectedEventId = nil

			arg0_37:setOpEnabled(true)

			if arg0_37.invalide then
				arg0_37.invalide = false

				arg0_37:Flush()
			end

			if arg1_37 then
				arg1_37()
			end
		end)
	end
end

function var0_0.easeInDetail(arg0_39, arg1_39)
	local var0_39 = 0.3
	local var1_39 = 0.3

	arg0_39.mask.gameObject:SetActive(true)

	arg0_39.scrollRect.enabled = false

	local var2_39 = arg0_39.scrollRect.transform
	local var3_39 = arg0_39.scrollRect.content
	local var4_39 = var2_39.rect.yMax
	local var5_39 = var0_39 * math.abs(var4_39 - var3_39.localPosition.y - arg0_39.selectedItem.tr.localPosition.y) / var2_39.rect.height
	local var6_39 = arg0_39.scrollRect.value
	local var7_39 = arg0_39.scrollRect:HeadIndexToValue(arg0_39.selectedItem.index)

	LeanTween.value(var3_39.gameObject, var6_39, var7_39, var5_39):setEase(LeanTweenType.easeInOutCirc):setOnUpdate(System.Action_float(function(arg0_40)
		arg0_39.scrollRect:SetNormalizedPosition(arg0_40, 1)
	end)):setOnComplete(System.Action(function()
		local var0_41 = arg0_39.scrollItem.tr.localPosition

		var0_41.y = var4_39 + var2_39.localPosition.y
		arg0_39.scrollItem.tr.localPosition = var0_41

		arg0_39.scrollItem.go:SetActive(true)
		arg0_39.scrollItem:Update(arg0_39.selectedItem.index, arg0_39.selectedItem.event)
		arg0_39.scrollItem:UpdateTime()

		local var1_41 = -347
		local var2_41 = arg0_39.detailPanel.tr

		var2_41:SetParent(arg0_39.scrollItem.tr:Find("maskDetail"), true)

		var2_41.localPosition = Vector3.zero

		arg0_39.detailPanel.go:SetActive(true)
		arg0_39.detailPanel:Update(arg0_39.selectedItem.index, arg0_39.selectedItem.event)

		arg0_39.contextData.selectedEventId = arg0_39.selectedItem.event.id

		shiftPanel(arg0_39.detailPanel.go, nil, -155, var1_39, 0, true):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg1_39))

		local var3_41 = var3_39.childCount
		local var4_41 = 100000
		local var5_41 = {}

		for iter0_41 = 0, var3_41 - 1 do
			local var6_41 = var3_39:GetChild(iter0_41)

			if var6_41 == arg0_39.selectedItem.tr then
				var4_41 = iter0_41
			elseif var4_41 < iter0_41 then
				table.insert(var5_41, var6_41)
			end
		end

		arg0_39.rawLayouts = {}

		for iter1_41, iter2_41 in ipairs(var5_41) do
			local var7_41 = iter2_41:GetComponent(typeof(LayoutElement))

			arg0_39.rawLayouts[iter2_41] = var7_41.ignoreLayout
			var7_41.ignoreLayout = true

			shiftPanel(iter2_41, nil, iter2_41.localPosition.y + var1_41, var1_39, 0, true):setEase(LeanTweenType.easeInOutCirc)
		end
	end))
end

function var0_0.easeOutDetail(arg0_42, arg1_42)
	local var0_42 = 0.2
	local var1_42 = 268
	local var2_42 = arg0_42.scrollRect.content
	local var3_42 = var2_42.childCount
	local var4_42 = 100000
	local var5_42 = {}

	for iter0_42 = 0, var3_42 - 1 do
		local var6_42 = var2_42:GetChild(iter0_42)

		if var6_42 == arg0_42.selectedItem.tr then
			var4_42 = iter0_42
		elseif var4_42 < iter0_42 then
			table.insert(var5_42, var6_42)
		end
	end

	for iter1_42, iter2_42 in ipairs(var5_42) do
		shiftPanel(iter2_42, nil, iter2_42.localPosition.y + var1_42, var0_42, 0, true):setEase(LeanTweenType.easeInOutCirc)
	end

	shiftPanel(arg0_42.detailPanel.go, nil, 129, var0_42, 0, true):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(function()
		for iter0_43, iter1_43 in ipairs(var5_42) do
			iter1_43:GetComponent(typeof(LayoutElement)).ignoreLayout = arg0_42.rawLayouts[iter1_43] or false
		end

		arg0_42.rawLayouts = {}

		arg0_42.mask.gameObject:SetActive(false)
		arg0_42.scrollItem.go:SetActive(false)
		arg0_42.detailPanel.go:SetActive(false)

		arg0_42.scrollRect.enabled = true

		arg1_42()
	end))
end

function var0_0.showDetail(arg0_44)
	arg0_44.scrollRect.enabled = false

	arg0_44.mask.gameObject:SetActive(true)

	local var0_44 = arg0_44.scrollRect.transform
	local var1_44 = arg0_44.scrollRect.content
	local var2_44 = arg0_44.scrollItem.tr.localPosition

	var2_44.y = var0_44.rect.yMax + var0_44.localPosition.y
	arg0_44.scrollItem.tr.localPosition = var2_44

	arg0_44.scrollItem.go:SetActive(true)
	arg0_44.scrollItem:Update(arg0_44.selectedItem.index, arg0_44.selectedItem.event)
	arg0_44.scrollItem:UpdateTime()

	local var3_44 = -347
	local var4_44 = arg0_44.detailPanel.tr

	var4_44:SetParent(arg0_44.scrollItem.tr:Find("maskDetail"), true)

	var4_44.anchoredPosition = Vector3.New(-1, -155, 0)

	arg0_44.detailPanel.go:SetActive(true)
	arg0_44.detailPanel:Update(arg0_44.selectedItem.index, arg0_44.selectedItem.event)

	arg0_44.contextData.selectedEventId = arg0_44.selectedItem.event.id

	local var5_44 = var1_44.childCount
	local var6_44 = 100000

	arg0_44.rawLayouts = {}

	for iter0_44 = 0, var5_44 - 1 do
		local var7_44 = var1_44:GetChild(iter0_44)
		local var8_44 = var7_44:GetComponent(typeof(LayoutElement))

		if var8_44.ignoreLayout or not var7_44.gameObject.activeSelf then
			arg0_44.rawLayouts[var7_44] = var8_44.ignoreLayout
		elseif var7_44 == arg0_44.selectedItem.tr then
			var6_44 = iter0_44
		elseif var6_44 < iter0_44 then
			arg0_44.rawLayouts[var7_44] = var8_44.ignoreLayout
			var8_44.ignoreLayout = true
			var7_44.localPosition = var7_44.localPosition + Vector3.New(-1, var3_44, 0)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_44.blurPanel)
end

function var0_0.ctimer(arg0_45)
	local var0_45 = 1

	arg0_45.timer = Timer.New(function()
		if arg0_45.selectedItem then
			arg0_45.scrollItem:UpdateTime()
		end

		local var0_46 = pg.TimeMgr.GetInstance()
		local var1_46 = var0_46:GetServerTime()

		if var0_46:STimeDescS(var1_46, "%Y/%m/%d") ~= var0_46:STimeDescS(var1_46 - 1, "%Y/%m/%d") then
			arg0_45.dispatch(EventConst.EVENT_FLUSH_ALL)

			return
		end

		local var2_46 = false

		for iter0_46, iter1_46 in pairs(arg0_45.scrollItems) do
			if iter1_46.go.name ~= "-1" then
				iter1_46:UpdateTime()

				local var3_46 = iter1_46.event:GetCountDownTime()

				if var3_46 and var3_46 < 0 then
					var2_46 = true
				end
			end
		end

		if var2_46 then
			arg0_45.dispatch(EventConst.EVENT_LIST_UPDATE)
		end
	end, var0_45, -1, true)

	arg0_45.timer:Start()
end

function var0_0.ktimer(arg0_47)
	if arg0_47.timer then
		arg0_47.timer:Stop()

		arg0_47.timer = nil
	end
end

function var0_0.setOpEnabled(arg0_48, arg1_48)
	_.each(arg0_48.toggles, function(arg0_49)
		setToggleEnabled(arg0_49, arg1_48)
	end)
	setButtonEnabled(arg0_48.btnBack, arg1_48)
end

function var0_0.updateBtnTip(arg0_50)
	local var0_50 = {
		false,
		getProxy(EventProxy):checkNightEvent()
	}

	for iter0_50, iter1_50 in ipairs(arg0_50.eventList) do
		if iter1_50:GetState() == EventInfo.StateFinish then
			var0_50[iter1_50.template.type] = true
		end
	end

	for iter2_50, iter3_50 in ipairs(arg0_50.toggles) do
		setActive(findTF(iter3_50, "tip"), var0_50[iter2_50])
	end
end

function var0_0.willExit(arg0_51)
	if arg0_51.tweens then
		cancelTweens(arg0_51.tweens)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_51.blurPanel, arg0_51._tf)
	arg0_51:ktimer()

	for iter0_51, iter1_51 in pairs(arg0_51.scrollItems) do
		iter1_51:Clear()
	end

	arg0_51.scrollItem:Clear()
	arg0_51.detailPanel:Clear()
end

return var0_0
