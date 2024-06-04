local var0 = class("ItemInfoLayer", import("..base.BaseUI"))
local var1 = 5
local var2 = 11
local var3 = {
	RESOLVE = 2,
	COMPOSE = 1
}

function var0.getUIName(arg0)
	return "ItemInfoUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = arg0:getWeightFromData()
	})

	arg0.window = arg0:findTF("window")

	setText(arg0.window:Find("top/bg/infomation/title"), i18n("words_information"))

	arg0.btnContent = arg0.window:Find("actions")
	arg0.okBtn = arg0.btnContent:Find("ok_button")

	setText(arg0.okBtn:Find("pic"), i18n("msgbox_text_confirm"))

	arg0.useBtn = arg0.btnContent:Find("use_button")
	arg0.batchUseBtn = arg0.btnContent:Find("batch_use_button")
	arg0.useOneBtn = arg0.btnContent:Find("use_one_button")
	arg0.composeBtn = arg0.btnContent:Find("compose_button")
	arg0.resolveBtn = arg0.btnContent:Find("resolve_button")

	setText(arg0.resolveBtn:Find("pic"), i18n("msgbox_text_analyse"))

	arg0.loveRepairBtn = arg0.btnContent:Find("love_lettle_repair_button")

	setText(arg0.loveRepairBtn:Find("pic"), i18n("loveletter_exchange_button"))

	arg0.metaskillBtn = arg0.btnContent:Find("metaskill_use_btn")

	setText(arg0.metaskillBtn:Find("pic"), i18n("msgbox_text_use"))

	arg0.itemTF = arg0.window:Find("item")
	arg0.operatePanel = arg0:findTF("operate")
	arg0.countTF = arg0.operatePanel:Find("item/left/own/Text"):GetComponent(typeof(Text))
	arg0.keepFateTog = arg0.operatePanel:Find("got/keep_tog")

	setText(arg0.keepFateTog:Find("label"), i18n("keep_fate_tip"))

	arg0.operateBtns = {}
	arg0.operateBtns.Confirm = arg0.operatePanel:Find("actions/confirm_button")
	arg0.operateBtns.Cancel = arg0.operatePanel:Find("actions/cancel_button")
	arg0.operateBtns.Resolve = arg0.operatePanel:Find("actions/resolve_button")

	setText(arg0.operateBtns.Confirm:Find("label"), i18n("msgbox_text_confirm"))
	setText(arg0.operateBtns.Cancel:Find("label"), i18n("msgbox_text_cancel"))
	setText(arg0.operateBtns.Resolve:Find("label"), i18n("msgbox_text_analyse"))
	SetActive(arg0.operatePanel, false)
	SetActive(arg0.window, true)

	arg0.operateMode = nil
	arg0.operateBonusList = arg0.operatePanel:Find("got/panel_bg/list")
	arg0.operateBonusTpl = arg0.operatePanel:Find("got/panel_bg/list/item")
	arg0.operateCountdesc = arg0.operatePanel:Find("count/image_text")
	arg0.operateValue = arg0.operatePanel:Find("count/number_panel/value")
	arg0.operateLeftButton = arg0.operatePanel:Find("count/number_panel/left")
	arg0.operateRightButton = arg0.operatePanel:Find("count/number_panel/right")
	arg0.operateMaxButton = arg0.operatePanel:Find("count/max")
end

function var0.setDrop(arg0, arg1)
	if arg1.type == DROP_TYPE_SHIP then
		arg0:setItemInfo(arg1, arg0.itemTF)
	elseif arg1.type == DROP_TYPE_ITEM then
		arg1.count = getProxy(BagProxy):getItemCountById(arg1.id)

		arg0:setItem(arg1)
	else
		assert(false, "do not support current kind of type: " .. arg1.type)
	end
end

function var0.setItemInfo(arg0, arg1, arg2)
	updateDrop(arg2:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = arg1
	}))
	UpdateOwnDisplay(arg2:Find("left/own"), arg1)
	RegisterDetailButton(arg0, arg2:Find("left/detail"), arg1)
	setText(arg2:Find("display_panel/name_container/name/Text"), arg1:getConfig("name"))
	setText(arg2:Find("display_panel/desc/Text"), arg1.desc)

	local var0 = arg2:Find("display_panel/name_container/shiptype")

	setActive(var0, arg1.type == DROP_TYPE_SHIP)

	if arg1.type == DROP_TYPE_SHIP then
		GetImageSpriteFromAtlasAsync("shiptype", shipType2print(arg1:getConfig("type")), var0, false)
	end
end

function var0.updateItemCount(arg0, arg1)
	arg0.countTF.text = arg1
end

function var0.setItem(arg0, arg1)
	arg0:setItemInfo(arg1, arg0.itemTF)

	arg0.itemVO = arg1:getSubClass()

	eachChild(arg0.btnContent, function(arg0)
		setActive(arg0, arg0 == arg0.okBtn)
	end)

	if not Item.CanInBag(arg0.itemVO.id) then
		return
	end

	local var0 = arg0.itemVO:getConfig("compose_number")

	if var0 > 0 and var0 <= arg0.itemVO.count then
		arg0:setItemInfo(arg1, arg0.operatePanel:Find("item"))

		arg0.operateMax = arg0.itemVO.count / var0

		setActive(arg0.composeBtn, true)
		setActive(arg0.okBtn, false)
	end

	if arg0.itemVO:getConfig("usage") == ItemUsage.SOS then
		setText(arg0.useBtn:Find("text"), 1)
		setActive(arg0.useBtn, true)
		setActive(arg0.okBtn, false)
	end

	local var1 = arg0.itemVO:getConfig("type")

	if arg0.itemVO:CanOpen() then
		setText(arg0.useBtn:Find("text"), 1)
		setActive(arg0.useBtn, true)

		if arg0.itemVO.count > 1 then
			setText(arg0.batchUseBtn:Find("text"), math.min(arg0.itemVO.count, 10))
			setActive(arg0.batchUseBtn, true)
		end

		setActive(arg0.okBtn, false)
	elseif var1 == Item.BLUEPRINT_TYPE then
		local var2 = getProxy(TechnologyProxy)
		local var3 = var2:GetBlueprint4Item(arg0.itemVO.id)

		if not LOCK_FRAGMENT_SHOP and var3 and var2:getBluePrintById(var3):isMaxLevel() then
			setActive(arg0.resolveBtn, true)
			arg0:UpdateBlueprintResolveNum()
		end

		arg0:setItemInfo(arg1, arg0.operatePanel:Find("item"))
	elseif var1 == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0.resolveBtn, true)
		arg0:UpdateSpeedUpResolveNum()
		arg0:setItemInfo(arg1, arg0.operatePanel:Find("item"))
	elseif var1 == Item.LOVE_LETTER_TYPE then
		local var4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER)

		setActive(arg0.loveRepairBtn, var4 and not var4:isEnd() and var4.data1 > 0 and arg0.itemVO.extra == 31201)
		onButton(arg0, arg0.loveRepairBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("loveletter_exchange_confirm"),
				onYes = function()
					arg0:emit(ItemInfoMediator.EXCHANGE_LOVE_LETTER_ITEM, var4.id)
				end
			})
		end, SFX_PANEL)
	elseif var1 == Item.METALESSON_TYPE then
		setActive(arg0.metaskillBtn, true)
		onButton(arg0, arg0.metaskillBtn, function()
			arg0:closeView()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER)
		end, SFX_PANEL)
	elseif var1 == Item.SKIN_ASSIGNED_TYPE then
		setActive(arg0.useOneBtn, arg0.contextData.confirmCall)
		onButton(arg0, arg0.useOneBtn, function()
			arg0.contextData.confirmCall()
			arg0:closeView()
		end, SFX_PANEL)
	end
end

function var0.closeView(arg0)
	if arg0.playing then
		return
	end

	var0.super.closeView(arg0)
end

function var0.didEnter(arg0)
	local var0 = arg0:findTF("OpenBox(Clone)")

	if var0 then
		SetActive(var0, false)
	end

	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("window/top/btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.okBtn, function()
		arg0:closeView()
	end, SFX_CONFIRM)
	onButton(arg0, arg0.useBtn, function()
		arg0:emit(ItemInfoMediator.USE_ITEM, arg0.itemVO.id, 1)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.batchUseBtn, function()
		arg0:emit(ItemInfoMediator.USE_ITEM, arg0.itemVO.id, math.min(arg0.itemVO.count, 10))
	end, SFX_CONFIRM)
	onButton(arg0, arg0.composeBtn, function()
		SetActive(arg0.operatePanel, true)
		SetActive(arg0.window, false)

		arg0.operateMode = var3.COMPOSE

		arg0:SetOperateCount(1)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.resolveBtn, function()
		SetActive(arg0.operatePanel, true)
		SetActive(arg0.window, false)

		arg0.operateMode = var3.RESOLVE

		arg0:SetOperateCount(1)
	end, SFX_PANEL)
	pressPersistTrigger(arg0.operateLeftButton, 0.5, function(arg0)
		if not arg0:UpdateCount(arg0.operateCount - 1) then
			arg0()

			return
		end

		arg0:SetOperateCount(arg0.operateCount - 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0.operateRightButton, 0.5, function(arg0)
		if not arg0:UpdateCount(arg0.operateCount + 1) then
			arg0()

			return
		end

		arg0:SetOperateCount(arg0.operateCount + 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, arg0.operateMaxButton, function()
		arg0:SetOperateCount(arg0.operateMax)
	end, SFX_PANEL)
	onButton(arg0, arg0.operateBtns.Cancel, function()
		SetActive(arg0.operatePanel, false)
		SetActive(arg0.window, true)
	end, SFX_CANCEL)
	onButton(arg0, arg0.operateBtns.Confirm, function()
		arg0:emit(ItemInfoMediator.COMPOSE_ITEM, arg0.itemVO.id, arg0.operateCount)

		local var0 = arg0.itemVO:getConfig("compose_number")

		if var0 > arg0.itemVO.count - arg0.operateCount * var0 then
			triggerButton(arg0.operateBtns.Cancel)
		else
			arg0:SetOperateCount(1)
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0.operateBtns.Resolve, function()
		arg0:emit(ItemInfoMediator.SELL_BLUEPRINT, Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg0.itemVO.id,
			count = arg0.operateCount
		}))
	end, SFX_CONFIRM)

	local var1 = getProxy(PlayerProxy):getData()
	local var2 = GetComponent(arg0.keepFateTog, typeof(Toggle))

	arg0.keepFateState = not var1:GetCommonFlag(SHOW_DONT_KEEP_FATE_ITEM)
	var2.isOn = arg0.keepFateState

	local function var3()
		arg0:UpdateBlueprintResolveNum()
		arg0:SetOperateCount(1)
	end

	onToggle(arg0, arg0.keepFateTog, function(arg0)
		arg0.keepFateState = arg0

		if arg0 then
			pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		else
			pg.m02:sendNotification(GAME.COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		end

		var3()
	end)
	var3()
end

function var0.UpdateCount(arg0, arg1)
	if arg0.operateMode == var3.COMPOSE then
		local var0 = arg0.itemVO:getConfig("target_id")

		if not var0 or var0 <= 0 then
			return false
		end

		arg1 = math.clamp(arg1, 1, math.floor(arg0.itemVO.count / arg0.itemVO:getConfig("compose_number")))

		return arg0.operateCount ~= arg1
	elseif arg0.operateMode == var3.RESOLVE then
		arg1 = math.clamp(arg1, 1, arg0.itemVO.count)

		return arg0.operateCount ~= arg1
	end
end

function var0.SetOperateCount(arg0, arg1)
	if arg0.operateMode == var3.COMPOSE then
		local var0 = arg0.itemVO:getConfig("target_id")

		if not var0 or var0 <= 0 then
			return
		end

		local var1 = arg0.itemVO:getConfig("compose_number")

		arg1 = math.clamp(arg1, 1, math.floor(arg0.itemVO.count / var1))

		if arg0.operateCount ~= arg1 then
			arg0.operateCount = arg1

			arg0:UpdateComposeCount()
		end

		local var2 = arg0.itemVO.count - arg0.operateCount * var1

		arg0:updateItemCount(var2)
	elseif arg0.operateMode == var3.RESOLVE then
		arg1 = math.clamp(arg1, 0, arg0.operateMax)

		if arg0.operateCount ~= arg1 then
			arg0.operateCount = arg1

			arg0:UpdateResolvePanel()
			arg0:updateItemCount(arg0.itemVO.count - arg0.operateCount)
		end
	end
end

function var0.UpdateComposeCount(arg0)
	local var0 = arg0.operateCount

	setText(arg0.operateValue, var0)

	local var1 = {}

	table.insert(var1, {
		type = DROP_TYPE_ITEM,
		id = arg0.itemVO:getConfig("target_id"),
		count = var0
	})
	UIItemList.StaticAlign(arg0.operateBonusList, arg0.operateBonusTpl, #var1, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1]

			updateDrop(arg2:Find("IconTpl"), var0)
			onButton(arg0, arg2:Find("IconTpl"), function()
				arg0:emit(var0.ON_DROP, var0)
			end, SFX_PANEL)
		end
	end)

	for iter0, iter1 in pairs(arg0.operateBtns) do
		setActive(iter1, iter0 == "Confirm" or iter0 == "Cancel")
	end

	setText(arg0.operateCountdesc, i18n("compose_amount_prefix"))
	setActive(arg0.keepFateTog, false)
end

function var0.UpdateResolvePanel(arg0)
	local var0 = arg0.operateCount

	setText(arg0.operateValue, var0)

	local var1 = arg0.itemVO:getConfig("price")
	local var2 = {}

	table.insert(var2, {
		type = DROP_TYPE_RESOURCE,
		id = var1[1],
		count = var1[2] * var0
	})
	UIItemList.StaticAlign(arg0.operateBonusList, arg0.operateBonusTpl, #var2, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1]

			updateDrop(arg2:Find("IconTpl"), var0)
			onButton(arg0, arg2:Find("IconTpl"), function()
				arg0:emit(var0.ON_DROP, var0)
			end, SFX_PANEL)
		end
	end)

	for iter0, iter1 in pairs(arg0.operateBtns) do
		setActive(iter1, iter0 == "Resolve" or iter0 == "Cancel")
	end

	setText(arg0.operateCountdesc, i18n("resolve_amount_prefix"))

	if arg0.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0.keepFateTog, false)
	else
		setActive(arg0.keepFateTog, true)
	end

	setButtonEnabled(arg0.operateBtns.Resolve, var0 > 0)
end

function var0.UpdateBlueprintResolveNum(arg0)
	local var0 = arg0.itemVO.count

	if arg0.itemVO:getConfig("type") == Item.BLUEPRINT_TYPE then
		local var1 = getProxy(TechnologyProxy)
		local var2 = var1:GetBlueprint4Item(arg0.itemVO.id)
		local var3 = var1:getBluePrintById(var2)

		if arg0.keepFateState then
			var0 = arg0.itemVO.count - var3:getFateMaxLeftOver()
			var0 = var0 < 0 and 0 or var0
		end
	end

	arg0.operateMax = var0
end

function var0.UpdateSpeedUpResolveNum(arg0)
	local var0 = arg0.itemVO.count

	if arg0.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		arg0.operateMax = var0
	end
end

function var0.willExit(arg0)
	if arg0.leftEventTrigger then
		ClearEventTrigger(arg0.leftEventTrigger)
	end

	if arg0.rightEventTrigger then
		ClearEventTrigger(arg0.rightEventTrigger)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.PlayOpenBox(arg0, arg1, arg2)
	if not arg1 or arg1 == "" then
		arg2()

		return
	end

	local var0 = {}
	local var1 = arg0:findTF(arg1 .. "(Clone)")

	if var1 then
		arg0[arg1] = go(var1)
	end

	if not arg0[arg1] then
		table.insert(var0, function(arg0)
			PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1), "", true, function(arg0)
				arg0:SetActive(true)

				arg0[arg1] = arg0

				arg0()
			end)
		end)
	end

	seriesAsync(var0, function()
		if arg0.playing or not arg0[arg1] then
			return
		end

		arg0.playing = true

		arg0[arg1]:SetActive(true)
		SetActive(arg0.window, false)

		local var0 = tf(arg0[arg1])

		var0:SetParent(arg0._tf, false)
		var0:SetAsLastSibling()

		local var1 = var0:GetComponent("DftAniEvent")

		var1:SetTriggerEvent(function(arg0)
			arg2()
		end)
		var1:SetEndEvent(function(arg0)
			if arg0[arg1] then
				SetActive(arg0[arg1], false)

				arg0.playing = false
			end

			arg0:closeView()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end)
end

return var0
