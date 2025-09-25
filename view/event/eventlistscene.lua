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

function var0_0.init(arg0_2)
	function arg0_2.dispatch(...)
		arg0_2:emit(...)
	end

	arg0_2.blurPanel = arg0_2:findTF("blur_panel")
	arg0_2.lay = arg0_2.blurPanel:Find("adapt/left_length")
	arg0_2.topPanel = arg0_2:findTF("blur_panel/adapt/top").gameObject
	arg0_2.btnBack = arg0_2:findTF("blur_panel/adapt/top/back_btn").gameObject
	arg0_2.topLeft = arg0_2:findTF("blur_panel/adapt/top/topLeftBg$")
	arg0_2.topLeftBg = arg0_2:findTF("blur_panel/adapt/top/topLeftBg$").gameObject
	arg0_2.labelShipNums = arg0_2:findTF("blur_panel/adapt/top/topLeftBg$/labelShipNums$"):GetComponent("Text")
	arg0_2.mask = arg0_2:findTF("mask$"):GetComponent("Image")
	arg0_2.scrollItem = EventListItem.New(arg0_2:findTF("blur_panel/scrollItem").gameObject, arg0_2.dispatch)

	arg0_2.scrollItem.go:SetActive(false)

	arg0_2.detailPanel = EventDetailPanel.New(arg0_2:findTF("detailPanel").gameObject, arg0_2.dispatch)

	arg0_2.detailPanel.go:SetActive(false)

	arg0_2.scrollRectObj = arg0_2:findTF("scrollRect$")
	arg0_2.scrollRect = arg0_2.scrollRectObj:GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_4)
		arg0_2:onInitItem(arg0_4)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_5, arg1_5)
		arg0_2:onUpdateItem(arg0_5, arg1_5)
	end

	function arg0_2.scrollRect.onReturnItem(arg0_6, arg1_6)
		arg0_2:onReturnItem(arg0_6, arg1_6)
	end

	arg0_2.scrollItems = {}
	arg0_2.selectedItem = nil
	arg0_2.rawLayouts = {}

	setImageAlpha(arg0_2.mask, 0)

	arg0_2.scrollRect.decelerationRate = 0.07
	arg0_2.listEmptyTF = arg0_2:findTF("empty")

	setActive(arg0_2.listEmptyTF, false)

	arg0_2.listEmptyTxt = arg0_2:findTF("Text", arg0_2.listEmptyTF)

	setText(arg0_2.listEmptyTxt, i18n("list_empty_tip_eventui"))
end

local var2_0 = {
	"daily",
	"urgency"
}

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.btnBack, function()
		if arg0_7.selectedItem then
			arg0_7:easeOut(function()
				arg0_7:emit(var0_0.ON_BACK)
			end)
		else
			arg0_7:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	setActive(arg0_7:findTF("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_7:findTF("stamp"), false)
	end

	onButton(arg0_7, arg0_7:findTF("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(9)
	end, SFX_CONFIRM)

	arg0_7.toggles = {}
	arg0_7.toggleIndex = -1

	for iter0_7, iter1_7 in ipairs(var2_0) do
		arg0_7.toggles[iter0_7] = arg0_7.lay:Find("frame/scroll_rect/tagRoot/" .. iter1_7 .. "_btn")

		onToggle(arg0_7, arg0_7.toggles[iter0_7], function(arg0_11)
			local var0_11 = arg0_7.toggleIndex == -1

			if arg0_11 and arg0_7.toggleIndex ~= iter0_7 then
				arg0_7.toggleIndex = iter0_7

				if arg0_7.selectedItem then
					pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.blurPanel, arg0_7._tf)

					local var1_11 = arg0_7.scrollRect.content
					local var2_11 = var1_11.childCount
					local var3_11 = 1000000

					for iter0_11 = 0, var2_11 - 1 do
						local var4_11 = var1_11:GetChild(iter0_11)

						if var4_11 == arg0_7.selectedItem.tr then
							var3_11 = iter0_11
						elseif var3_11 < iter0_11 then
							var4_11:GetComponent(typeof(LayoutElement)).ignoreLayout = arg0_7.rawLayouts[var4_11] or false
						end
					end

					arg0_7.rawLayouts = {}

					arg0_7.mask.gameObject:SetActive(false)
					arg0_7.scrollItem.go:SetActive(false)
					arg0_7.detailPanel.go:SetActive(false)

					arg0_7.scrollRect.enabled = true
					arg0_7.selectedItem = nil
					arg0_7.contextData.selectedEventId = nil
				end

				arg0_7.contextData.index = iter0_7

				arg0_7:Flush(not var0_11)
			end
		end)
	end

	local var0_7 = arg0_7.contextData.index or 1

	triggerToggle(arg0_7.toggles[var0_7], true)

	local function var1_7()
		if arg0_7.scrollItem.event:GetState() == EventInfo.StateFinish then
			arg0_7.dispatch(EventConst.EVENT_FINISH, arg0_7.scrollItem.event)
		else
			arg0_7:easeOut()
		end
	end

	onButton(arg0_7, arg0_7.scrollItem.bgNormal, var1_7, SFX_PANEL)
	onButton(arg0_7, arg0_7.scrollItem.bgEmergence, var1_7, SFX_PANEL)
	onButton(arg0_7, arg0_7.mask.gameObject, function()
		arg0_7:easeOut()
	end, SFX_CANCEL)
	arg0_7:ctimer()
	arg0_7:updateBtnTip()
end

function var0_0.onBackPressed(arg0_14)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_14.btnBack)
end

function var0_0.setEventList(arg0_15, arg1_15)
	arg0_15.eventList = arg1_15
end

function var0_0.updateAll(arg0_16)
	if arg0_16.selectedItem then
		local var0_16 = underscore.detect(arg0_16.eventList, function(arg0_17)
			return arg0_17.id == arg0_16.selectedItem.event.id
		end)

		if var0_16 then
			local var1_16 = getProxy(EventProxy)

			arg0_16.labelShipNums.text = var1_16.maxFleetNums - var1_16:countBusyFleetNums() .. "/" .. var1_16.maxFleetNums

			arg0_16.scrollItem:Update(arg0_16.selectedItem.index, var0_16)
			arg0_16.detailPanel:Update(arg0_16.selectedItem.index, var0_16)
		else
			arg0_16:easeOut()
		end

		arg0_16.invalide = true
	else
		arg0_16:Flush()
	end

	arg0_16:updateBtnTip()
end

function var0_0.Flush(arg0_18, arg1_18)
	arg1_18 = false

	local var0_18 = getProxy(EventProxy)

	if var0_18:checkZeroHourEvent() then
		arg0_18.dispatch(EventConst.EVENT_FLUSH_ALL)

		return
	elseif var2_0[arg0_18.contextData.index] == "urgency" and var0_18:checkNightEvent() then
		arg0_18.dispatch(EventConst.EVENT_FLUSH_ALL)

		return
	end

	if not arg1_18 then
		arg0_18.labelShipNums.text = var0_18.maxFleetNums - var0_18:countBusyFleetNums() .. "/" .. var0_18.maxFleetNums

		if arg0_18.contextData.selectedEventId then
			pg.UIMgr.GetInstance():LoadingOn()
			seriesAsync({
				function(arg0_19)
					if arg0_18.scrollRect.isStart then
						arg0_19()
					else
						arg0_18.scrollRect.onStart = arg0_19
					end
				end,
				function(arg0_20)
					local var0_20 = arg0_18.contextData.selectedEventId
					local var1_20 = 1

					for iter0_20, iter1_20 in ipairs(arg0_18.filterEventList) do
						if iter1_20.id == var0_20 then
							var1_20 = iter0_20

							break
						end
					end

					local var2_20 = arg0_18.scrollRect:HeadIndexToValue(var1_20 - 1)

					arg0_18.scrollRect:ScrollTo(var2_20)

					for iter2_20, iter3_20 in pairs(arg0_18.scrollItems) do
						if iter3_20.event and iter3_20.event.id == var0_20 then
							arg0_18.selectedItem = iter3_20

							arg0_18:showDetail()

							break
						end
					end

					arg0_20()
				end
			}, function()
				pg.UIMgr.GetInstance():LoadingOff()
			end)
		end
	end

	arg0_18:filter()
	arg0_18.scrollRect:SetTotalCount(#arg0_18.filterEventList, arg1_18 and 0 or arg0_18.scrollRect.value)
	setActive(arg0_18.listEmptyTF, #arg0_18.filterEventList <= 0)
end

function var0_0.filter(arg0_22)
	arg0_22.filterEventList = {}

	local var0_22 = var1_0[arg0_22.contextData.index]

	for iter0_22, iter1_22 in ipairs(arg0_22.eventList) do
		for iter2_22, iter3_22 in ipairs(var0_22) do
			if iter1_22.template.type == iter3_22 then
				table.insert(arg0_22.filterEventList, iter1_22)

				break
			end
		end
	end

	table.sort(arg0_22.filterEventList, CompareFuncs({
		function(arg0_23)
			return arg0_23:IsActivityType() and 0 or 1
		end,
		function(arg0_24)
			return -arg0_24:GetState()
		end,
		function(arg0_25)
			return arg0_25.template.type == 3 and 0 or 1
		end,
		function(arg0_26)
			return arg0_26.overTime == 0 and 0 or 1
		end,
		function(arg0_27)
			return arg0_27.id
		end
	}))
end

function var0_0.onInitItem(arg0_28, arg1_28)
	local var0_28 = EventListItem.New(arg1_28, arg0_28.dispatch)

	local function var1_28()
		if var0_28.event:GetState() == EventInfo.StateFinish then
			arg0_28.dispatch(EventConst.EVENT_FINISH, var0_28.event)
		else
			arg0_28:easeIn(var0_28)
		end
	end

	onButton(arg0_28, var0_28.bgNormal, var1_28, SFX_PANEL)
	onButton(arg0_28, var0_28.bgEmergence, var1_28, SFX_PANEL)

	arg0_28.scrollItems[arg1_28] = var0_28
end

function var0_0.onUpdateItem(arg0_30, arg1_30, arg2_30)
	GetComponent(tf(arg2_30), "CanvasGroup").alpha = 1

	local var0_30 = arg0_30.scrollItems[arg2_30]

	if not var0_30 then
		arg0_30:onInitItem(arg2_30)

		var0_30 = arg0_30.scrollItems[arg2_30]
	end

	local var1_30 = arg0_30.filterEventList[arg1_30 + 1]

	if var1_30 then
		var0_30:Update(arg1_30, var1_30)
		var0_30:UpdateTime()
	end
end

function var0_0.onReturnItem(arg0_31, arg1_31, arg2_31)
	if arg0_31.scrollItems and arg0_31.scrollItems[arg2_31] then
		arg0_31.scrollItems[arg2_31]:Clear()
	end
end

function var0_0.easeIn(arg0_32, arg1_32)
	if not arg0_32.easing then
		arg0_32.easing = true
		arg0_32.selectedItem = arg1_32

		arg0_32:setOpEnabled(false)
		arg0_32:easeInDetail(function()
			pg.UIMgr.GetInstance():BlurPanel(arg0_32.blurPanel)

			arg0_32.easing = false

			arg0_32:setOpEnabled(true)
		end)
	end
end

function var0_0.easeOut(arg0_34, arg1_34)
	if not arg0_34.easing then
		arg0_34.easing = true

		arg0_34:setOpEnabled(false)
		arg0_34:easeOutDetail(function()
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_34.blurPanel, arg0_34._tf)

			arg0_34.easing = false
			arg0_34.selectedItem = nil
			arg0_34.contextData.selectedEventId = nil

			arg0_34:setOpEnabled(true)

			if arg0_34.invalide then
				arg0_34.invalide = false

				arg0_34:Flush()
			end

			if arg1_34 then
				arg1_34()
			end
		end)
	end
end

function var0_0.easeInDetail(arg0_36, arg1_36)
	local var0_36 = 0.3
	local var1_36 = 0.3

	arg0_36.mask.gameObject:SetActive(true)

	arg0_36.scrollRect.enabled = false

	local var2_36 = arg0_36.scrollRect.transform
	local var3_36 = arg0_36.scrollRect.content
	local var4_36 = var2_36.rect.yMax
	local var5_36 = var0_36 * math.abs(var4_36 - var3_36.localPosition.y - arg0_36.selectedItem.tr.localPosition.y) / var2_36.rect.height
	local var6_36 = arg0_36.scrollRect.value
	local var7_36 = arg0_36.scrollRect:HeadIndexToValue(arg0_36.selectedItem.index)

	LeanTween.value(var3_36.gameObject, var6_36, var7_36, var5_36):setEase(LeanTweenType.easeInOutCirc):setOnUpdate(System.Action_float(function(arg0_37)
		arg0_36.scrollRect:SetNormalizedPosition(arg0_37, 1)
	end)):setOnComplete(System.Action(function()
		local var0_38 = arg0_36.scrollItem.tr.localPosition

		var0_38.y = var4_36 + var2_36.localPosition.y
		arg0_36.scrollItem.tr.localPosition = var0_38

		arg0_36.scrollItem.go:SetActive(true)
		arg0_36.scrollItem:Update(arg0_36.selectedItem.index, arg0_36.selectedItem.event)
		arg0_36.scrollItem:UpdateTime()

		local var1_38 = -347
		local var2_38 = arg0_36.detailPanel.tr

		var2_38:SetParent(arg0_36.scrollItem:findTF("maskDetail"), true)

		var2_38.localPosition = Vector3.zero

		arg0_36.detailPanel.go:SetActive(true)
		arg0_36.detailPanel:Update(arg0_36.selectedItem.index, arg0_36.selectedItem.event)

		arg0_36.contextData.selectedEventId = arg0_36.selectedItem.event.id

		shiftPanel(arg0_36.detailPanel.go, nil, -155, var1_36, 0, true):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg1_36))

		local var3_38 = var3_36.childCount
		local var4_38 = 100000
		local var5_38 = {}

		for iter0_38 = 0, var3_38 - 1 do
			local var6_38 = var3_36:GetChild(iter0_38)

			if var6_38 == arg0_36.selectedItem.tr then
				var4_38 = iter0_38
			elseif var4_38 < iter0_38 then
				table.insert(var5_38, var6_38)
			end
		end

		arg0_36.rawLayouts = {}

		for iter1_38, iter2_38 in ipairs(var5_38) do
			local var7_38 = iter2_38:GetComponent(typeof(LayoutElement))

			arg0_36.rawLayouts[iter2_38] = var7_38.ignoreLayout
			var7_38.ignoreLayout = true

			shiftPanel(iter2_38, nil, iter2_38.localPosition.y + var1_38, var1_36, 0, true):setEase(LeanTweenType.easeInOutCirc)
		end
	end))
end

function var0_0.easeOutDetail(arg0_39, arg1_39)
	local var0_39 = 0.2
	local var1_39 = 268
	local var2_39 = arg0_39.scrollRect.content
	local var3_39 = var2_39.childCount
	local var4_39 = 100000
	local var5_39 = {}

	for iter0_39 = 0, var3_39 - 1 do
		local var6_39 = var2_39:GetChild(iter0_39)

		if var6_39 == arg0_39.selectedItem.tr then
			var4_39 = iter0_39
		elseif var4_39 < iter0_39 then
			table.insert(var5_39, var6_39)
		end
	end

	for iter1_39, iter2_39 in ipairs(var5_39) do
		shiftPanel(iter2_39, nil, iter2_39.localPosition.y + var1_39, var0_39, 0, true):setEase(LeanTweenType.easeInOutCirc)
	end

	shiftPanel(arg0_39.detailPanel.go, nil, 129, var0_39, 0, true):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(function()
		for iter0_40, iter1_40 in ipairs(var5_39) do
			iter1_40:GetComponent(typeof(LayoutElement)).ignoreLayout = arg0_39.rawLayouts[iter1_40] or false
		end

		arg0_39.rawLayouts = {}

		arg0_39.mask.gameObject:SetActive(false)
		arg0_39.scrollItem.go:SetActive(false)
		arg0_39.detailPanel.go:SetActive(false)

		arg0_39.scrollRect.enabled = true

		arg1_39()
	end))
end

function var0_0.showDetail(arg0_41)
	arg0_41.scrollRect.enabled = false

	arg0_41.mask.gameObject:SetActive(true)

	local var0_41 = arg0_41.scrollRect.transform
	local var1_41 = arg0_41.scrollRect.content
	local var2_41 = arg0_41.scrollItem.tr.localPosition

	var2_41.y = var0_41.rect.yMax + var0_41.localPosition.y
	arg0_41.scrollItem.tr.localPosition = var2_41

	arg0_41.scrollItem.go:SetActive(true)
	arg0_41.scrollItem:Update(arg0_41.selectedItem.index, arg0_41.selectedItem.event)
	arg0_41.scrollItem:UpdateTime()

	local var3_41 = -347
	local var4_41 = arg0_41.detailPanel.tr

	var4_41:SetParent(arg0_41.scrollItem:findTF("maskDetail"), true)

	var4_41.anchoredPosition = Vector3.New(-1, -155, 0)

	arg0_41.detailPanel.go:SetActive(true)
	arg0_41.detailPanel:Update(arg0_41.selectedItem.index, arg0_41.selectedItem.event)

	arg0_41.contextData.selectedEventId = arg0_41.selectedItem.event.id

	local var5_41 = var1_41.childCount
	local var6_41 = 100000

	arg0_41.rawLayouts = {}

	for iter0_41 = 0, var5_41 - 1 do
		local var7_41 = var1_41:GetChild(iter0_41)
		local var8_41 = var7_41:GetComponent(typeof(LayoutElement))

		if var8_41.ignoreLayout or not var7_41.gameObject.activeSelf then
			arg0_41.rawLayouts[var7_41] = var8_41.ignoreLayout
		elseif var7_41 == arg0_41.selectedItem.tr then
			var6_41 = iter0_41
		elseif var6_41 < iter0_41 then
			arg0_41.rawLayouts[var7_41] = var8_41.ignoreLayout
			var8_41.ignoreLayout = true
			var7_41.localPosition = var7_41.localPosition + Vector3.New(-1, var3_41, 0)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_41.blurPanel)
end

function var0_0.ctimer(arg0_42)
	local var0_42 = 1

	arg0_42.timer = Timer.New(function()
		if arg0_42.selectedItem then
			arg0_42.scrollItem:UpdateTime()
		end

		local var0_43 = pg.TimeMgr.GetInstance()
		local var1_43 = var0_43:GetServerTime()

		if var0_43:STimeDescS(var1_43, "%Y/%m/%d") ~= var0_43:STimeDescS(var1_43 - 1, "%Y/%m/%d") then
			arg0_42.dispatch(EventConst.EVENT_FLUSH_ALL)

			return
		end

		local var2_43 = false

		for iter0_43, iter1_43 in pairs(arg0_42.scrollItems) do
			if iter1_43.go.name ~= "-1" then
				iter1_43:UpdateTime()

				local var3_43 = iter1_43.event:GetCountDownTime()

				if var3_43 and var3_43 < 0 then
					var2_43 = true
				end
			end
		end

		if var2_43 then
			arg0_42.dispatch(EventConst.EVENT_LIST_UPDATE)
		end
	end, var0_42, -1, true)

	arg0_42.timer:Start()
end

function var0_0.ktimer(arg0_44)
	if arg0_44.timer then
		arg0_44.timer:Stop()

		arg0_44.timer = nil
	end
end

function var0_0.setOpEnabled(arg0_45, arg1_45)
	_.each(arg0_45.toggles, function(arg0_46)
		setToggleEnabled(arg0_46, arg1_45)
	end)
	setButtonEnabled(arg0_45.btnBack, arg1_45)
end

function var0_0.updateBtnTip(arg0_47)
	local var0_47 = {
		false,
		getProxy(EventProxy):checkNightEvent()
	}

	for iter0_47, iter1_47 in ipairs(arg0_47.eventList) do
		if iter1_47:GetState() == EventInfo.StateFinish then
			var0_47[iter1_47.template.type] = true
		end
	end

	for iter2_47, iter3_47 in ipairs(arg0_47.toggles) do
		setActive(findTF(iter3_47, "tip"), var0_47[iter2_47])
	end
end

function var0_0.willExit(arg0_48)
	if arg0_48.tweens then
		cancelTweens(arg0_48.tweens)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_48.blurPanel, arg0_48._tf)
	arg0_48:ktimer()

	for iter0_48, iter1_48 in pairs(arg0_48.scrollItems) do
		iter1_48:Clear()
	end

	arg0_48.scrollItem:Clear()
	arg0_48.detailPanel:Clear()
end

return var0_0
