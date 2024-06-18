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
					pg.UIMgr.GetInstance():UnblurPanel(arg0_7.blurPanel, arg0_7._tf)

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
				end

				arg0_7.contextData.index = iter0_7

				arg0_7:Flush(not var0_11)
			end
		end)
	end

	local var0_7 = arg0_7.contextData.index or 1

	triggerToggle(arg0_7.toggles[var0_7], true)

	local function var1_7()
		if arg0_7.scrollItem.event.state == EventInfo.StateFinish then
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

function var0_0.updateAll(arg0_15, arg1_15, arg2_15, arg3_15)
	arg0_15.eventProxy = arg1_15

	if arg2_15 then
		if arg0_15.selectedItem then
			local var0_15 = arg0_15.selectedItem.event.id

			if arg0_15.eventProxy:findInfoById(var0_15) then
				arg0_15:updateOne(var0_15)
			else
				arg0_15:easeOut()
			end

			if not arg3_15 then
				arg0_15.invalide = true
			end
		else
			arg0_15:Flush()
		end

		arg0_15:updateBtnTip()
	end
end

function var0_0.updateOne(arg0_16, arg1_16)
	arg0_16.labelShipNums.text = arg0_16.eventProxy.maxFleetNums - arg0_16.eventProxy.busyFleetNums .. "/" .. arg0_16.eventProxy.maxFleetNums

	for iter0_16, iter1_16 in pairs(arg0_16.scrollItems) do
		if iter1_16.event and iter1_16.event.id == arg1_16 then
			iter1_16:Flush()

			break
		end
	end

	if arg0_16.selectedItem then
		if arg0_16.scrollItem.event and arg0_16.scrollItem.event.id == arg1_16 then
			arg0_16.scrollItem:Flush()
			arg0_16.scrollItem:UpdateTime()
		end

		if arg0_16.detailPanel.event and arg0_16.detailPanel.event.id == arg1_16 then
			arg0_16.detailPanel:Flush()
		end
	end

	arg0_16:updateBtnTip()
end

function var0_0.Flush(arg0_17, arg1_17)
	arg1_17 = false

	if var2_0[arg0_17.contextData.index] == "urgency" and arg0_17.eventProxy:checkNightEvent() then
		arg0_17.dispatch(EventConst.EVENT_FLUSH_NIGHT)

		return
	end

	if not arg1_17 then
		arg0_17.labelShipNums.text = arg0_17.eventProxy.maxFleetNums - arg0_17.eventProxy.busyFleetNums .. "/" .. arg0_17.eventProxy.maxFleetNums

		if arg0_17.eventProxy.selectedEvent then
			local function var0_17()
				local var0_18 = arg0_17.eventProxy.selectedEvent.id
				local var1_18 = 1

				for iter0_18, iter1_18 in ipairs(arg0_17.eventList) do
					if iter1_18.id == var0_18 then
						var1_18 = iter0_18

						break
					end
				end

				local var2_18 = arg0_17.scrollRect:HeadIndexToValue(var1_18 - 1)

				arg0_17.scrollRect:ScrollTo(var2_18)

				for iter2_18, iter3_18 in pairs(arg0_17.scrollItems) do
					if iter3_18.event and iter3_18.event.id == var0_18 then
						arg0_17.selectedItem = iter3_18

						arg0_17:showDetail()

						break
					end
				end

				arg0_17.eventProxy.selectedEvent = nil

				pg.UIMgr.GetInstance():LoadingOff()
			end

			if arg0_17.scrollRect.isStart then
				var0_17()
			else
				arg0_17.scrollRect.onStart = var0_17

				pg.UIMgr.GetInstance():LoadingOn()
			end
		end
	end

	arg0_17:filter()
	arg0_17.scrollRect:SetTotalCount(#arg0_17.eventList, arg1_17 and 0 or arg0_17.scrollRect.value)
	setActive(arg0_17.listEmptyTF, #arg0_17.eventList <= 0)
end

function var0_0.filter(arg0_19)
	arg0_19.eventList = {}

	local var0_19 = var1_0[arg0_19.contextData.index]

	for iter0_19, iter1_19 in ipairs(arg0_19.eventProxy.eventList) do
		for iter2_19, iter3_19 in ipairs(var0_19) do
			if iter1_19.template.type == iter3_19 then
				table.insert(arg0_19.eventList, iter1_19)

				break
			end
		end
	end

	arg0_19.eventList = _.sort(arg0_19.eventList, function(arg0_20, arg1_20)
		local var0_20 = arg0_20:IsActivityType() and 1 or 0
		local var1_20 = arg1_20:IsActivityType() and 1 or 0

		if var0_20 == var1_20 then
			if arg0_20.state ~= arg1_20.state then
				return arg0_20.state > arg1_20.state
			end

			if arg0_20.template.type == 3 and arg1_20.template.type ~= 3 then
				return true
			end

			if arg0_20.template.type ~= 3 and arg1_20.template.type == 3 then
				return false
			end

			return arg0_20.id < arg1_20.id
		else
			return var1_20 < var0_20
		end
	end)
end

function var0_0.onInitItem(arg0_21, arg1_21)
	local var0_21 = EventListItem.New(arg1_21, arg0_21.dispatch)

	local function var1_21()
		if var0_21.event.state == EventInfo.StateFinish then
			arg0_21.dispatch(EventConst.EVENT_FINISH, var0_21.event)
		else
			arg0_21:easeIn(var0_21)
		end
	end

	onButton(arg0_21, var0_21.bgNormal, var1_21, SFX_PANEL)
	onButton(arg0_21, var0_21.bgEmergence, var1_21, SFX_PANEL)

	arg0_21.scrollItems[arg1_21] = var0_21
end

function var0_0.onUpdateItem(arg0_23, arg1_23, arg2_23)
	GetComponent(tf(arg2_23), "CanvasGroup").alpha = 1

	local var0_23 = arg0_23.scrollItems[arg2_23]

	if not var0_23 then
		arg0_23:onInitItem(arg2_23)

		var0_23 = arg0_23.scrollItems[arg2_23]
	end

	local var1_23 = arg0_23.eventList[arg1_23 + 1]

	if var1_23 then
		var0_23:Update(arg1_23, var1_23)
		var0_23:UpdateTime()
	end
end

function var0_0.onReturnItem(arg0_24, arg1_24, arg2_24)
	if arg0_24.scrollItems and arg0_24.scrollItems[arg2_24] then
		arg0_24.scrollItems[arg2_24]:Clear()
	end
end

function var0_0.easeIn(arg0_25, arg1_25)
	if not arg0_25.easing then
		arg0_25.easing = true
		arg0_25.selectedItem = arg1_25

		arg0_25:setOpEnabled(false)
		arg0_25:easeInDetail(function()
			pg.UIMgr.GetInstance():BlurPanel(arg0_25.blurPanel)

			arg0_25.easing = false

			arg0_25:setOpEnabled(true)
		end)
	end
end

function var0_0.easeOut(arg0_27, arg1_27)
	if not arg0_27.easing then
		arg0_27.easing = true

		arg0_27:setOpEnabled(false)
		arg0_27:easeOutDetail(function()
			pg.UIMgr.GetInstance():UnblurPanel(arg0_27.blurPanel, arg0_27._tf)

			arg0_27.easing = false
			arg0_27.selectedItem = nil

			arg0_27:setOpEnabled(true)

			if arg0_27.invalide then
				arg0_27.invalide = false

				arg0_27:Flush()
			end

			if arg1_27 then
				arg1_27()
			end
		end)
	end
end

function var0_0.easeInDetail(arg0_29, arg1_29)
	local var0_29 = 0.3
	local var1_29 = 0.3

	arg0_29.mask.gameObject:SetActive(true)

	arg0_29.scrollRect.enabled = false

	local var2_29 = arg0_29.scrollRect.transform
	local var3_29 = arg0_29.scrollRect.content
	local var4_29 = var2_29.rect.yMax
	local var5_29 = var0_29 * math.abs(var4_29 - var3_29.localPosition.y - arg0_29.selectedItem.tr.localPosition.y) / var2_29.rect.height
	local var6_29 = arg0_29.scrollRect.value
	local var7_29 = arg0_29.scrollRect:HeadIndexToValue(arg0_29.selectedItem.index)

	LeanTween.value(var3_29.gameObject, var6_29, var7_29, var5_29):setEase(LeanTweenType.easeInOutCirc):setOnUpdate(System.Action_float(function(arg0_30)
		arg0_29.scrollRect:SetNormalizedPosition(arg0_30, 1)
	end)):setOnComplete(System.Action(function()
		local var0_31 = arg0_29.scrollItem.tr.localPosition

		var0_31.y = var4_29 + var2_29.localPosition.y
		arg0_29.scrollItem.tr.localPosition = var0_31

		arg0_29.scrollItem.go:SetActive(true)
		arg0_29.scrollItem:Update(arg0_29.selectedItem.index, arg0_29.selectedItem.event)
		arg0_29.scrollItem:UpdateTime()

		local var1_31 = -347
		local var2_31 = arg0_29.detailPanel.tr

		var2_31:SetParent(arg0_29.scrollItem:findTF("maskDetail"), true)

		var2_31.localPosition = Vector3.zero

		arg0_29.detailPanel.go:SetActive(true)
		arg0_29.detailPanel:Update(arg0_29.selectedItem.index, arg0_29.selectedItem.event)
		shiftPanel(arg0_29.detailPanel.go, nil, -155, var1_29, 0, true):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg1_29))

		local var3_31 = var3_29.childCount
		local var4_31 = 100000
		local var5_31 = {}

		for iter0_31 = 0, var3_31 - 1 do
			local var6_31 = var3_29:GetChild(iter0_31)

			if var6_31 == arg0_29.selectedItem.tr then
				var4_31 = iter0_31
			elseif var4_31 < iter0_31 then
				table.insert(var5_31, var6_31)
			end
		end

		arg0_29.rawLayouts = {}

		for iter1_31, iter2_31 in ipairs(var5_31) do
			local var7_31 = iter2_31:GetComponent(typeof(LayoutElement))

			arg0_29.rawLayouts[iter2_31] = var7_31.ignoreLayout
			var7_31.ignoreLayout = true

			shiftPanel(iter2_31, nil, iter2_31.localPosition.y + var1_31, var1_29, 0, true):setEase(LeanTweenType.easeInOutCirc)
		end
	end))
end

function var0_0.easeOutDetail(arg0_32, arg1_32)
	local var0_32 = 0.2
	local var1_32 = 268
	local var2_32 = arg0_32.scrollRect.content
	local var3_32 = var2_32.childCount
	local var4_32 = 100000
	local var5_32 = {}

	for iter0_32 = 0, var3_32 - 1 do
		local var6_32 = var2_32:GetChild(iter0_32)

		if var6_32 == arg0_32.selectedItem.tr then
			var4_32 = iter0_32
		elseif var4_32 < iter0_32 then
			table.insert(var5_32, var6_32)
		end
	end

	for iter1_32, iter2_32 in ipairs(var5_32) do
		shiftPanel(iter2_32, nil, iter2_32.localPosition.y + var1_32, var0_32, 0, true):setEase(LeanTweenType.easeInOutCirc)
	end

	shiftPanel(arg0_32.detailPanel.go, nil, 129, var0_32, 0, true):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(function()
		for iter0_33, iter1_33 in ipairs(var5_32) do
			iter1_33:GetComponent(typeof(LayoutElement)).ignoreLayout = arg0_32.rawLayouts[iter1_33] or false
		end

		arg0_32.rawLayouts = {}

		arg0_32.mask.gameObject:SetActive(false)
		arg0_32.scrollItem.go:SetActive(false)
		arg0_32.detailPanel.go:SetActive(false)

		arg0_32.scrollRect.enabled = true

		arg1_32()
	end))
end

function var0_0.showDetail(arg0_34)
	arg0_34.scrollRect.enabled = false

	arg0_34.mask.gameObject:SetActive(true)

	local var0_34 = arg0_34.scrollRect.transform
	local var1_34 = arg0_34.scrollRect.content
	local var2_34 = arg0_34.scrollItem.tr.localPosition

	var2_34.y = var0_34.rect.yMax + var0_34.localPosition.y
	arg0_34.scrollItem.tr.localPosition = var2_34

	arg0_34.scrollItem.go:SetActive(true)
	arg0_34.scrollItem:Update(arg0_34.selectedItem.index, arg0_34.selectedItem.event)
	arg0_34.scrollItem:UpdateTime()

	local var3_34 = -347
	local var4_34 = arg0_34.detailPanel.tr

	var4_34:SetParent(arg0_34.scrollItem:findTF("maskDetail"), true)

	var4_34.anchoredPosition = Vector3.New(-1, -155, 0)

	arg0_34.detailPanel.go:SetActive(true)
	arg0_34.detailPanel:Update(arg0_34.selectedItem.index, arg0_34.selectedItem.event)

	local var5_34 = var1_34.childCount
	local var6_34 = 100000

	arg0_34.rawLayouts = {}

	for iter0_34 = 0, var5_34 - 1 do
		local var7_34 = var1_34:GetChild(iter0_34)
		local var8_34 = var7_34:GetComponent(typeof(LayoutElement))

		if var8_34.ignoreLayout or not var7_34.gameObject.activeSelf then
			arg0_34.rawLayouts[var7_34] = var8_34.ignoreLayout
		elseif var7_34 == arg0_34.selectedItem.tr then
			var6_34 = iter0_34
		elseif var6_34 < iter0_34 then
			arg0_34.rawLayouts[var7_34] = var8_34.ignoreLayout
			var8_34.ignoreLayout = true
			var7_34.localPosition = var7_34.localPosition + Vector3.New(-1, var3_34, 0)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_34.blurPanel)
end

function var0_0.ctimer(arg0_35)
	local var0_35 = 1

	arg0_35.timer = Timer.New(function()
		if arg0_35.selectedItem then
			arg0_35.scrollItem:UpdateTime()
		end

		local var0_36 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_36 = false

		for iter0_36, iter1_36 in pairs(arg0_35.scrollItems) do
			if iter1_36.go.name ~= "-1" then
				iter1_36:UpdateTime()

				local var2_36 = iter1_36.event:GetCountDownTime()

				if var2_36 and var2_36 < 0 then
					local var3_36, var4_36 = arg0_35.eventProxy:findInfoById(iter1_36.event.id)

					table.remove(arg0_35.eventProxy.eventList, var4_36)

					var1_36 = true
				end
			end
		end

		if var1_36 then
			arg0_35.dispatch(EventConst.EVENT_LIST_UPDATE)
		end
	end, var0_35, -1, true)

	arg0_35.timer:Start()
end

function var0_0.ktimer(arg0_37)
	if arg0_37.timer then
		arg0_37.timer:Stop()

		arg0_37.timer = nil
	end
end

function var0_0.setOpEnabled(arg0_38, arg1_38)
	_.each(arg0_38.toggles, function(arg0_39)
		setToggleEnabled(arg0_39, arg1_38)
	end)
	setButtonEnabled(arg0_38.btnBack, arg1_38)
end

function var0_0.updateBtnTip(arg0_40)
	local var0_40 = {
		false,
		arg0_40.eventProxy:checkNightEvent()
	}

	for iter0_40, iter1_40 in ipairs(arg0_40.eventProxy.eventList) do
		if iter1_40.state == EventInfo.StateFinish then
			var0_40[iter1_40.template.type] = true
		end
	end

	for iter2_40, iter3_40 in ipairs(arg0_40.toggles) do
		setActive(findTF(iter3_40, "tip"), var0_40[iter2_40])
	end
end

function var0_0.willExit(arg0_41)
	if arg0_41.tweens then
		cancelTweens(arg0_41.tweens)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_41.blurPanel, arg0_41._tf)
	arg0_41:ktimer()

	for iter0_41, iter1_41 in pairs(arg0_41.scrollItems) do
		iter1_41:Clear()
	end

	arg0_41.scrollItem:Clear()
	arg0_41.detailPanel:Clear()
end

return var0_0
