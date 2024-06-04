EventConst = require("view/event/EventConst")
EventListItem = require("view/event/EventListItem")
EventDetailPanel = require("view/event/EventDetailPanel")

local var0 = class("EventListScene", import("..base.BaseUI"))
local var1 = {
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

function var0.getUIName(arg0)
	return "EventUI"
end

function var0.init(arg0)
	function arg0.dispatch(...)
		arg0:emit(...)
	end

	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.lay = arg0.blurPanel:Find("adapt/left_length")
	arg0.topPanel = arg0:findTF("blur_panel/adapt/top").gameObject
	arg0.btnBack = arg0:findTF("blur_panel/adapt/top/back_btn").gameObject
	arg0.topLeft = arg0:findTF("blur_panel/adapt/top/topLeftBg$")
	arg0.topLeftBg = arg0:findTF("blur_panel/adapt/top/topLeftBg$").gameObject
	arg0.labelShipNums = arg0:findTF("blur_panel/adapt/top/topLeftBg$/labelShipNums$"):GetComponent("Text")
	arg0.mask = arg0:findTF("mask$"):GetComponent("Image")
	arg0.scrollItem = EventListItem.New(arg0:findTF("blur_panel/scrollItem").gameObject, arg0.dispatch)

	arg0.scrollItem.go:SetActive(false)

	arg0.detailPanel = EventDetailPanel.New(arg0:findTF("detailPanel").gameObject, arg0.dispatch)

	arg0.detailPanel.go:SetActive(false)

	arg0.scrollRectObj = arg0:findTF("scrollRect$")
	arg0.scrollRect = arg0.scrollRectObj:GetComponent("LScrollRect")

	function arg0.scrollRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	function arg0.scrollRect.onReturnItem(arg0, arg1)
		arg0:onReturnItem(arg0, arg1)
	end

	arg0.scrollItems = {}
	arg0.selectedItem = nil
	arg0.rawLayouts = {}

	setImageAlpha(arg0.mask, 0)

	arg0.scrollRect.decelerationRate = 0.07
	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)

	setText(arg0.listEmptyTxt, i18n("list_empty_tip_eventui"))
end

local var2 = {
	"daily",
	"urgency"
}

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnBack, function()
		if arg0.selectedItem then
			arg0:easeOut(function()
				arg0:emit(var0.ON_BACK)
			end)
		else
			arg0:emit(var0.ON_BACK)
		end
	end, SFX_CANCEL)
	setActive(arg0:findTF("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0:findTF("stamp"), false)
	end

	onButton(arg0, arg0:findTF("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(9)
	end, SFX_CONFIRM)

	arg0.toggles = {}
	arg0.toggleIndex = -1

	for iter0, iter1 in ipairs(var2) do
		arg0.toggles[iter0] = arg0.lay:Find("frame/scroll_rect/tagRoot/" .. iter1 .. "_btn")

		onToggle(arg0, arg0.toggles[iter0], function(arg0)
			local var0 = arg0.toggleIndex == -1

			if arg0 and arg0.toggleIndex ~= iter0 then
				arg0.toggleIndex = iter0

				if arg0.selectedItem then
					pg.UIMgr.GetInstance():UnblurPanel(arg0.blurPanel, arg0._tf)

					local var1 = arg0.scrollRect.content
					local var2 = var1.childCount
					local var3 = 1000000

					for iter0 = 0, var2 - 1 do
						local var4 = var1:GetChild(iter0)

						if var4 == arg0.selectedItem.tr then
							var3 = iter0
						elseif var3 < iter0 then
							var4:GetComponent(typeof(LayoutElement)).ignoreLayout = arg0.rawLayouts[var4] or false
						end
					end

					arg0.rawLayouts = {}

					arg0.mask.gameObject:SetActive(false)
					arg0.scrollItem.go:SetActive(false)
					arg0.detailPanel.go:SetActive(false)

					arg0.scrollRect.enabled = true
					arg0.selectedItem = nil
				end

				arg0.contextData.index = iter0

				arg0:Flush(not var0)
			end
		end)
	end

	local var0 = arg0.contextData.index or 1

	triggerToggle(arg0.toggles[var0], true)

	local function var1()
		if arg0.scrollItem.event.state == EventInfo.StateFinish then
			arg0.dispatch(EventConst.EVENT_FINISH, arg0.scrollItem.event)
		else
			arg0:easeOut()
		end
	end

	onButton(arg0, arg0.scrollItem.bgNormal, var1, SFX_PANEL)
	onButton(arg0, arg0.scrollItem.bgEmergence, var1, SFX_PANEL)
	onButton(arg0, arg0.mask.gameObject, function()
		arg0:easeOut()
	end, SFX_CANCEL)
	arg0:ctimer()
	arg0:updateBtnTip()
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0.btnBack)
end

function var0.updateAll(arg0, arg1, arg2, arg3)
	arg0.eventProxy = arg1

	if arg2 then
		if arg0.selectedItem then
			local var0 = arg0.selectedItem.event.id

			if arg0.eventProxy:findInfoById(var0) then
				arg0:updateOne(var0)
			else
				arg0:easeOut()
			end

			if not arg3 then
				arg0.invalide = true
			end
		else
			arg0:Flush()
		end

		arg0:updateBtnTip()
	end
end

function var0.updateOne(arg0, arg1)
	arg0.labelShipNums.text = arg0.eventProxy.maxFleetNums - arg0.eventProxy.busyFleetNums .. "/" .. arg0.eventProxy.maxFleetNums

	for iter0, iter1 in pairs(arg0.scrollItems) do
		if iter1.event and iter1.event.id == arg1 then
			iter1:Flush()

			break
		end
	end

	if arg0.selectedItem then
		if arg0.scrollItem.event and arg0.scrollItem.event.id == arg1 then
			arg0.scrollItem:Flush()
			arg0.scrollItem:UpdateTime()
		end

		if arg0.detailPanel.event and arg0.detailPanel.event.id == arg1 then
			arg0.detailPanel:Flush()
		end
	end

	arg0:updateBtnTip()
end

function var0.Flush(arg0, arg1)
	arg1 = false

	if var2[arg0.contextData.index] == "urgency" and arg0.eventProxy:checkNightEvent() then
		arg0.dispatch(EventConst.EVENT_FLUSH_NIGHT)

		return
	end

	if not arg1 then
		arg0.labelShipNums.text = arg0.eventProxy.maxFleetNums - arg0.eventProxy.busyFleetNums .. "/" .. arg0.eventProxy.maxFleetNums

		if arg0.eventProxy.selectedEvent then
			local function var0()
				local var0 = arg0.eventProxy.selectedEvent.id
				local var1 = 1

				for iter0, iter1 in ipairs(arg0.eventList) do
					if iter1.id == var0 then
						var1 = iter0

						break
					end
				end

				local var2 = arg0.scrollRect:HeadIndexToValue(var1 - 1)

				arg0.scrollRect:ScrollTo(var2)

				for iter2, iter3 in pairs(arg0.scrollItems) do
					if iter3.event and iter3.event.id == var0 then
						arg0.selectedItem = iter3

						arg0:showDetail()

						break
					end
				end

				arg0.eventProxy.selectedEvent = nil

				pg.UIMgr.GetInstance():LoadingOff()
			end

			if arg0.scrollRect.isStart then
				var0()
			else
				arg0.scrollRect.onStart = var0

				pg.UIMgr.GetInstance():LoadingOn()
			end
		end
	end

	arg0:filter()
	arg0.scrollRect:SetTotalCount(#arg0.eventList, arg1 and 0 or arg0.scrollRect.value)
	setActive(arg0.listEmptyTF, #arg0.eventList <= 0)
end

function var0.filter(arg0)
	arg0.eventList = {}

	local var0 = var1[arg0.contextData.index]

	for iter0, iter1 in ipairs(arg0.eventProxy.eventList) do
		for iter2, iter3 in ipairs(var0) do
			if iter1.template.type == iter3 then
				table.insert(arg0.eventList, iter1)

				break
			end
		end
	end

	arg0.eventList = _.sort(arg0.eventList, function(arg0, arg1)
		local var0 = arg0:IsActivityType() and 1 or 0
		local var1 = arg1:IsActivityType() and 1 or 0

		if var0 == var1 then
			if arg0.state ~= arg1.state then
				return arg0.state > arg1.state
			end

			if arg0.template.type == 3 and arg1.template.type ~= 3 then
				return true
			end

			if arg0.template.type ~= 3 and arg1.template.type == 3 then
				return false
			end

			return arg0.id < arg1.id
		else
			return var1 < var0
		end
	end)
end

function var0.onInitItem(arg0, arg1)
	local var0 = EventListItem.New(arg1, arg0.dispatch)

	local function var1()
		if var0.event.state == EventInfo.StateFinish then
			arg0.dispatch(EventConst.EVENT_FINISH, var0.event)
		else
			arg0:easeIn(var0)
		end
	end

	onButton(arg0, var0.bgNormal, var1, SFX_PANEL)
	onButton(arg0, var0.bgEmergence, var1, SFX_PANEL)

	arg0.scrollItems[arg1] = var0
end

function var0.onUpdateItem(arg0, arg1, arg2)
	GetComponent(tf(arg2), "CanvasGroup").alpha = 1

	local var0 = arg0.scrollItems[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.scrollItems[arg2]
	end

	local var1 = arg0.eventList[arg1 + 1]

	if var1 then
		var0:Update(arg1, var1)
		var0:UpdateTime()
	end
end

function var0.onReturnItem(arg0, arg1, arg2)
	if arg0.scrollItems and arg0.scrollItems[arg2] then
		arg0.scrollItems[arg2]:Clear()
	end
end

function var0.easeIn(arg0, arg1)
	if not arg0.easing then
		arg0.easing = true
		arg0.selectedItem = arg1

		arg0:setOpEnabled(false)
		arg0:easeInDetail(function()
			pg.UIMgr.GetInstance():BlurPanel(arg0.blurPanel)

			arg0.easing = false

			arg0:setOpEnabled(true)
		end)
	end
end

function var0.easeOut(arg0, arg1)
	if not arg0.easing then
		arg0.easing = true

		arg0:setOpEnabled(false)
		arg0:easeOutDetail(function()
			pg.UIMgr.GetInstance():UnblurPanel(arg0.blurPanel, arg0._tf)

			arg0.easing = false
			arg0.selectedItem = nil

			arg0:setOpEnabled(true)

			if arg0.invalide then
				arg0.invalide = false

				arg0:Flush()
			end

			if arg1 then
				arg1()
			end
		end)
	end
end

function var0.easeInDetail(arg0, arg1)
	local var0 = 0.3
	local var1 = 0.3

	arg0.mask.gameObject:SetActive(true)

	arg0.scrollRect.enabled = false

	local var2 = arg0.scrollRect.transform
	local var3 = arg0.scrollRect.content
	local var4 = var2.rect.yMax
	local var5 = var0 * math.abs(var4 - var3.localPosition.y - arg0.selectedItem.tr.localPosition.y) / var2.rect.height
	local var6 = arg0.scrollRect.value
	local var7 = arg0.scrollRect:HeadIndexToValue(arg0.selectedItem.index)

	LeanTween.value(var3.gameObject, var6, var7, var5):setEase(LeanTweenType.easeInOutCirc):setOnUpdate(System.Action_float(function(arg0)
		arg0.scrollRect:SetNormalizedPosition(arg0, 1)
	end)):setOnComplete(System.Action(function()
		local var0 = arg0.scrollItem.tr.localPosition

		var0.y = var4 + var2.localPosition.y
		arg0.scrollItem.tr.localPosition = var0

		arg0.scrollItem.go:SetActive(true)
		arg0.scrollItem:Update(arg0.selectedItem.index, arg0.selectedItem.event)
		arg0.scrollItem:UpdateTime()

		local var1 = -347
		local var2 = arg0.detailPanel.tr

		var2:SetParent(arg0.scrollItem:findTF("maskDetail"), true)

		var2.localPosition = Vector3.zero

		arg0.detailPanel.go:SetActive(true)
		arg0.detailPanel:Update(arg0.selectedItem.index, arg0.selectedItem.event)
		shiftPanel(arg0.detailPanel.go, nil, -155, var1, 0, true):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg1))

		local var3 = var3.childCount
		local var4 = 100000
		local var5 = {}

		for iter0 = 0, var3 - 1 do
			local var6 = var3:GetChild(iter0)

			if var6 == arg0.selectedItem.tr then
				var4 = iter0
			elseif var4 < iter0 then
				table.insert(var5, var6)
			end
		end

		arg0.rawLayouts = {}

		for iter1, iter2 in ipairs(var5) do
			local var7 = iter2:GetComponent(typeof(LayoutElement))

			arg0.rawLayouts[iter2] = var7.ignoreLayout
			var7.ignoreLayout = true

			shiftPanel(iter2, nil, iter2.localPosition.y + var1, var1, 0, true):setEase(LeanTweenType.easeInOutCirc)
		end
	end))
end

function var0.easeOutDetail(arg0, arg1)
	local var0 = 0.2
	local var1 = 268
	local var2 = arg0.scrollRect.content
	local var3 = var2.childCount
	local var4 = 100000
	local var5 = {}

	for iter0 = 0, var3 - 1 do
		local var6 = var2:GetChild(iter0)

		if var6 == arg0.selectedItem.tr then
			var4 = iter0
		elseif var4 < iter0 then
			table.insert(var5, var6)
		end
	end

	for iter1, iter2 in ipairs(var5) do
		shiftPanel(iter2, nil, iter2.localPosition.y + var1, var0, 0, true):setEase(LeanTweenType.easeInOutCirc)
	end

	shiftPanel(arg0.detailPanel.go, nil, 129, var0, 0, true):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(function()
		for iter0, iter1 in ipairs(var5) do
			iter1:GetComponent(typeof(LayoutElement)).ignoreLayout = arg0.rawLayouts[iter1] or false
		end

		arg0.rawLayouts = {}

		arg0.mask.gameObject:SetActive(false)
		arg0.scrollItem.go:SetActive(false)
		arg0.detailPanel.go:SetActive(false)

		arg0.scrollRect.enabled = true

		arg1()
	end))
end

function var0.showDetail(arg0)
	arg0.scrollRect.enabled = false

	arg0.mask.gameObject:SetActive(true)

	local var0 = arg0.scrollRect.transform
	local var1 = arg0.scrollRect.content
	local var2 = arg0.scrollItem.tr.localPosition

	var2.y = var0.rect.yMax + var0.localPosition.y
	arg0.scrollItem.tr.localPosition = var2

	arg0.scrollItem.go:SetActive(true)
	arg0.scrollItem:Update(arg0.selectedItem.index, arg0.selectedItem.event)
	arg0.scrollItem:UpdateTime()

	local var3 = -347
	local var4 = arg0.detailPanel.tr

	var4:SetParent(arg0.scrollItem:findTF("maskDetail"), true)

	var4.anchoredPosition = Vector3.New(-1, -155, 0)

	arg0.detailPanel.go:SetActive(true)
	arg0.detailPanel:Update(arg0.selectedItem.index, arg0.selectedItem.event)

	local var5 = var1.childCount
	local var6 = 100000

	arg0.rawLayouts = {}

	for iter0 = 0, var5 - 1 do
		local var7 = var1:GetChild(iter0)
		local var8 = var7:GetComponent(typeof(LayoutElement))

		if var8.ignoreLayout or not var7.gameObject.activeSelf then
			arg0.rawLayouts[var7] = var8.ignoreLayout
		elseif var7 == arg0.selectedItem.tr then
			var6 = iter0
		elseif var6 < iter0 then
			arg0.rawLayouts[var7] = var8.ignoreLayout
			var8.ignoreLayout = true
			var7.localPosition = var7.localPosition + Vector3.New(-1, var3, 0)
		end
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0.blurPanel)
end

function var0.ctimer(arg0)
	local var0 = 1

	arg0.timer = Timer.New(function()
		if arg0.selectedItem then
			arg0.scrollItem:UpdateTime()
		end

		local var0 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1 = false

		for iter0, iter1 in pairs(arg0.scrollItems) do
			if iter1.go.name ~= "-1" then
				iter1:UpdateTime()

				local var2 = iter1.event:GetCountDownTime()

				if var2 and var2 < 0 then
					local var3, var4 = arg0.eventProxy:findInfoById(iter1.event.id)

					table.remove(arg0.eventProxy.eventList, var4)

					var1 = true
				end
			end
		end

		if var1 then
			arg0.dispatch(EventConst.EVENT_LIST_UPDATE)
		end
	end, var0, -1, true)

	arg0.timer:Start()
end

function var0.ktimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.setOpEnabled(arg0, arg1)
	_.each(arg0.toggles, function(arg0)
		setToggleEnabled(arg0, arg1)
	end)
	setButtonEnabled(arg0.btnBack, arg1)
end

function var0.updateBtnTip(arg0)
	local var0 = {
		false,
		arg0.eventProxy:checkNightEvent()
	}

	for iter0, iter1 in ipairs(arg0.eventProxy.eventList) do
		if iter1.state == EventInfo.StateFinish then
			var0[iter1.template.type] = true
		end
	end

	for iter2, iter3 in ipairs(arg0.toggles) do
		setActive(findTF(iter3, "tip"), var0[iter2])
	end
end

function var0.willExit(arg0)
	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0.blurPanel, arg0._tf)
	arg0:ktimer()

	for iter0, iter1 in pairs(arg0.scrollItems) do
		iter1:Clear()
	end

	arg0.scrollItem:Clear()
	arg0.detailPanel:Clear()
end

return var0
