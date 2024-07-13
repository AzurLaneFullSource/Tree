local var0_0 = class("ItemInfoLayer", import("..base.BaseUI"))
local var1_0 = 5
local var2_0 = 11
local var3_0 = {
	RESOLVE = 2,
	COMPOSE = 1
}

function var0_0.getUIName(arg0_1)
	return "ItemInfoUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = arg0_2:getWeightFromData()
	})

	arg0_2.window = arg0_2:findTF("window")

	setText(arg0_2.window:Find("top/bg/infomation/title"), i18n("words_information"))

	arg0_2.btnContent = arg0_2.window:Find("actions")
	arg0_2.okBtn = arg0_2.btnContent:Find("ok_button")

	setText(arg0_2.okBtn:Find("pic"), i18n("msgbox_text_confirm"))

	arg0_2.useBtn = arg0_2.btnContent:Find("use_button")
	arg0_2.batchUseBtn = arg0_2.btnContent:Find("batch_use_button")
	arg0_2.useOneBtn = arg0_2.btnContent:Find("use_one_button")
	arg0_2.composeBtn = arg0_2.btnContent:Find("compose_button")
	arg0_2.resolveBtn = arg0_2.btnContent:Find("resolve_button")

	setText(arg0_2.resolveBtn:Find("pic"), i18n("msgbox_text_analyse"))

	arg0_2.loveRepairBtn = arg0_2.btnContent:Find("love_lettle_repair_button")

	setText(arg0_2.loveRepairBtn:Find("pic"), i18n("loveletter_exchange_button"))

	arg0_2.metaskillBtn = arg0_2.btnContent:Find("metaskill_use_btn")

	setText(arg0_2.metaskillBtn:Find("pic"), i18n("msgbox_text_use"))

	arg0_2.itemTF = arg0_2.window:Find("item")
	arg0_2.operatePanel = arg0_2:findTF("operate")
	arg0_2.countTF = arg0_2.operatePanel:Find("item/left/own/Text"):GetComponent(typeof(Text))
	arg0_2.keepFateTog = arg0_2.operatePanel:Find("got/keep_tog")

	setText(arg0_2.keepFateTog:Find("label"), i18n("keep_fate_tip"))

	arg0_2.operateBtns = {}
	arg0_2.operateBtns.Confirm = arg0_2.operatePanel:Find("actions/confirm_button")
	arg0_2.operateBtns.Cancel = arg0_2.operatePanel:Find("actions/cancel_button")
	arg0_2.operateBtns.Resolve = arg0_2.operatePanel:Find("actions/resolve_button")

	setText(arg0_2.operateBtns.Confirm:Find("label"), i18n("msgbox_text_confirm"))
	setText(arg0_2.operateBtns.Cancel:Find("label"), i18n("msgbox_text_cancel"))
	setText(arg0_2.operateBtns.Resolve:Find("label"), i18n("msgbox_text_analyse"))
	SetActive(arg0_2.operatePanel, false)
	SetActive(arg0_2.window, true)

	arg0_2.operateMode = nil
	arg0_2.operateBonusList = arg0_2.operatePanel:Find("got/panel_bg/list")
	arg0_2.operateBonusTpl = arg0_2.operatePanel:Find("got/panel_bg/list/item")
	arg0_2.operateCountdesc = arg0_2.operatePanel:Find("count/image_text")
	arg0_2.operateValue = arg0_2.operatePanel:Find("count/number_panel/value")
	arg0_2.operateLeftButton = arg0_2.operatePanel:Find("count/number_panel/left")
	arg0_2.operateRightButton = arg0_2.operatePanel:Find("count/number_panel/right")
	arg0_2.operateMaxButton = arg0_2.operatePanel:Find("count/max")
end

function var0_0.setDrop(arg0_3, arg1_3)
	if arg1_3.type == DROP_TYPE_SHIP then
		arg0_3:setItemInfo(arg1_3, arg0_3.itemTF)
	elseif arg1_3.type == DROP_TYPE_ITEM then
		arg1_3.count = getProxy(BagProxy):getItemCountById(arg1_3.id)

		arg0_3:setItem(arg1_3)
	else
		assert(false, "do not support current kind of type: " .. arg1_3.type)
	end
end

function var0_0.setItemInfo(arg0_4, arg1_4, arg2_4)
	updateDrop(arg2_4:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = arg1_4
	}))
	UpdateOwnDisplay(arg2_4:Find("left/own"), arg1_4)
	RegisterDetailButton(arg0_4, arg2_4:Find("left/detail"), arg1_4)
	setText(arg2_4:Find("display_panel/name_container/name/Text"), arg1_4:getConfig("name"))
	setText(arg2_4:Find("display_panel/desc/Text"), arg1_4.desc)

	local var0_4 = arg2_4:Find("display_panel/name_container/shiptype")

	setActive(var0_4, arg1_4.type == DROP_TYPE_SHIP)

	if arg1_4.type == DROP_TYPE_SHIP then
		GetImageSpriteFromAtlasAsync("shiptype", shipType2print(arg1_4:getConfig("type")), var0_4, false)
	end
end

function var0_0.updateItemCount(arg0_5, arg1_5)
	arg0_5.countTF.text = arg1_5
end

function var0_0.setItem(arg0_6, arg1_6)
	arg0_6:setItemInfo(arg1_6, arg0_6.itemTF)

	arg0_6.itemVO = arg1_6:getSubClass()

	eachChild(arg0_6.btnContent, function(arg0_7)
		setActive(arg0_7, arg0_7 == arg0_6.okBtn)
	end)

	if not Item.CanInBag(arg0_6.itemVO.id) then
		return
	end

	local var0_6 = arg0_6.itemVO:getConfig("compose_number")

	if var0_6 > 0 and var0_6 <= arg0_6.itemVO.count then
		arg0_6:setItemInfo(arg1_6, arg0_6.operatePanel:Find("item"))

		arg0_6.operateMax = arg0_6.itemVO.count / var0_6

		setActive(arg0_6.composeBtn, true)
		setActive(arg0_6.okBtn, false)
	end

	if arg0_6.itemVO:getConfig("usage") == ItemUsage.SOS then
		setText(arg0_6.useBtn:Find("text"), 1)
		setActive(arg0_6.useBtn, true)
		setActive(arg0_6.okBtn, false)
	end

	local var1_6 = arg0_6.itemVO:getConfig("type")

	if arg0_6.itemVO:CanOpen() then
		setText(arg0_6.useBtn:Find("text"), 1)
		setActive(arg0_6.useBtn, true)

		if arg0_6.itemVO.count > 1 then
			setText(arg0_6.batchUseBtn:Find("text"), math.min(arg0_6.itemVO.count, 10))
			setActive(arg0_6.batchUseBtn, true)
		end

		setActive(arg0_6.okBtn, false)
	elseif var1_6 == Item.BLUEPRINT_TYPE then
		local var2_6 = getProxy(TechnologyProxy)
		local var3_6 = var2_6:GetBlueprint4Item(arg0_6.itemVO.id)

		if not LOCK_FRAGMENT_SHOP and var3_6 and var2_6:getBluePrintById(var3_6):isMaxLevel() then
			setActive(arg0_6.resolveBtn, true)
			arg0_6:UpdateBlueprintResolveNum()
		end

		arg0_6:setItemInfo(arg1_6, arg0_6.operatePanel:Find("item"))
	elseif var1_6 == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0_6.resolveBtn, true)
		arg0_6:UpdateSpeedUpResolveNum()
		arg0_6:setItemInfo(arg1_6, arg0_6.operatePanel:Find("item"))
	elseif var1_6 == Item.LOVE_LETTER_TYPE then
		local var4_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER)

		setActive(arg0_6.loveRepairBtn, var4_6 and not var4_6:isEnd() and var4_6.data1 > 0 and arg0_6.itemVO.extra == 31201)
		onButton(arg0_6, arg0_6.loveRepairBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("loveletter_exchange_confirm"),
				onYes = function()
					arg0_6:emit(ItemInfoMediator.EXCHANGE_LOVE_LETTER_ITEM, var4_6.id)
				end
			})
		end, SFX_PANEL)
	elseif var1_6 == Item.METALESSON_TYPE then
		setActive(arg0_6.metaskillBtn, true)
		onButton(arg0_6, arg0_6.metaskillBtn, function()
			arg0_6:closeView()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER)
		end, SFX_PANEL)
	elseif var1_6 == Item.SKIN_ASSIGNED_TYPE then
		setActive(arg0_6.useOneBtn, arg0_6.contextData.confirmCall)
		onButton(arg0_6, arg0_6.useOneBtn, function()
			arg0_6.contextData.confirmCall()
			arg0_6:closeView()
		end, SFX_PANEL)
	end
end

function var0_0.closeView(arg0_12)
	if arg0_12.playing then
		return
	end

	var0_0.super.closeView(arg0_12)
end

function var0_0.didEnter(arg0_13)
	local var0_13 = arg0_13:findTF("OpenBox(Clone)")

	if var0_13 then
		SetActive(var0_13, false)
	end

	onButton(arg0_13, arg0_13._tf:Find("bg"), function()
		arg0_13:closeView()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13._tf:Find("window/top/btnBack"), function()
		arg0_13:closeView()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.okBtn, function()
		arg0_13:closeView()
	end, SFX_CONFIRM)
	onButton(arg0_13, arg0_13.useBtn, function()
		arg0_13:emit(ItemInfoMediator.USE_ITEM, arg0_13.itemVO.id, 1)
	end, SFX_CONFIRM)
	onButton(arg0_13, arg0_13.batchUseBtn, function()
		arg0_13:emit(ItemInfoMediator.USE_ITEM, arg0_13.itemVO.id, math.min(arg0_13.itemVO.count, 10))
	end, SFX_CONFIRM)
	onButton(arg0_13, arg0_13.composeBtn, function()
		SetActive(arg0_13.operatePanel, true)
		SetActive(arg0_13.window, false)

		arg0_13.operateMode = var3_0.COMPOSE

		arg0_13:SetOperateCount(1)
	end, SFX_CONFIRM)
	onButton(arg0_13, arg0_13.resolveBtn, function()
		SetActive(arg0_13.operatePanel, true)
		SetActive(arg0_13.window, false)

		arg0_13.operateMode = var3_0.RESOLVE

		arg0_13:SetOperateCount(1)
	end, SFX_PANEL)
	pressPersistTrigger(arg0_13.operateLeftButton, 0.5, function(arg0_21)
		if not arg0_13:UpdateCount(arg0_13.operateCount - 1) then
			arg0_21()

			return
		end

		arg0_13:SetOperateCount(arg0_13.operateCount - 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_13.operateRightButton, 0.5, function(arg0_22)
		if not arg0_13:UpdateCount(arg0_13.operateCount + 1) then
			arg0_22()

			return
		end

		arg0_13:SetOperateCount(arg0_13.operateCount + 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_13, arg0_13.operateMaxButton, function()
		arg0_13:SetOperateCount(arg0_13.operateMax)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.operateBtns.Cancel, function()
		SetActive(arg0_13.operatePanel, false)
		SetActive(arg0_13.window, true)
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.operateBtns.Confirm, function()
		arg0_13:emit(ItemInfoMediator.COMPOSE_ITEM, arg0_13.itemVO.id, arg0_13.operateCount)

		local var0_25 = arg0_13.itemVO:getConfig("compose_number")

		if var0_25 > arg0_13.itemVO.count - arg0_13.operateCount * var0_25 then
			triggerButton(arg0_13.operateBtns.Cancel)
		else
			arg0_13:SetOperateCount(1)
		end
	end, SFX_CONFIRM)
	onButton(arg0_13, arg0_13.operateBtns.Resolve, function()
		arg0_13:emit(ItemInfoMediator.SELL_BLUEPRINT, Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg0_13.itemVO.id,
			count = arg0_13.operateCount
		}))
	end, SFX_CONFIRM)

	local var1_13 = getProxy(PlayerProxy):getData()
	local var2_13 = GetComponent(arg0_13.keepFateTog, typeof(Toggle))

	arg0_13.keepFateState = not var1_13:GetCommonFlag(SHOW_DONT_KEEP_FATE_ITEM)
	var2_13.isOn = arg0_13.keepFateState

	local function var3_13()
		arg0_13:UpdateBlueprintResolveNum()
		arg0_13:SetOperateCount(1)
	end

	onToggle(arg0_13, arg0_13.keepFateTog, function(arg0_28)
		arg0_13.keepFateState = arg0_28

		if arg0_28 then
			pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		else
			pg.m02:sendNotification(GAME.COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		end

		var3_13()
	end)
	var3_13()
end

function var0_0.UpdateCount(arg0_29, arg1_29)
	if arg0_29.operateMode == var3_0.COMPOSE then
		local var0_29 = arg0_29.itemVO:getConfig("target_id")

		if not var0_29 or var0_29 <= 0 then
			return false
		end

		arg1_29 = math.clamp(arg1_29, 1, math.floor(arg0_29.itemVO.count / arg0_29.itemVO:getConfig("compose_number")))

		return arg0_29.operateCount ~= arg1_29
	elseif arg0_29.operateMode == var3_0.RESOLVE then
		arg1_29 = math.clamp(arg1_29, 1, arg0_29.itemVO.count)

		return arg0_29.operateCount ~= arg1_29
	end
end

function var0_0.SetOperateCount(arg0_30, arg1_30)
	if arg0_30.operateMode == var3_0.COMPOSE then
		local var0_30 = arg0_30.itemVO:getConfig("target_id")

		if not var0_30 or var0_30 <= 0 then
			return
		end

		local var1_30 = arg0_30.itemVO:getConfig("compose_number")

		arg1_30 = math.clamp(arg1_30, 1, math.floor(arg0_30.itemVO.count / var1_30))

		if arg0_30.operateCount ~= arg1_30 then
			arg0_30.operateCount = arg1_30

			arg0_30:UpdateComposeCount()
		end

		local var2_30 = arg0_30.itemVO.count - arg0_30.operateCount * var1_30

		arg0_30:updateItemCount(var2_30)
	elseif arg0_30.operateMode == var3_0.RESOLVE then
		arg1_30 = math.clamp(arg1_30, 0, arg0_30.operateMax)

		if arg0_30.operateCount ~= arg1_30 then
			arg0_30.operateCount = arg1_30

			arg0_30:UpdateResolvePanel()
			arg0_30:updateItemCount(arg0_30.itemVO.count - arg0_30.operateCount)
		end
	end
end

function var0_0.UpdateComposeCount(arg0_31)
	local var0_31 = arg0_31.operateCount

	setText(arg0_31.operateValue, var0_31)

	local var1_31 = {}

	table.insert(var1_31, {
		type = DROP_TYPE_ITEM,
		id = arg0_31.itemVO:getConfig("target_id"),
		count = var0_31
	})
	UIItemList.StaticAlign(arg0_31.operateBonusList, arg0_31.operateBonusTpl, #var1_31, function(arg0_32, arg1_32, arg2_32)
		arg1_32 = arg1_32 + 1

		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = var1_31[arg1_32]

			updateDrop(arg2_32:Find("IconTpl"), var0_32)
			onButton(arg0_31, arg2_32:Find("IconTpl"), function()
				arg0_31:emit(var0_0.ON_DROP, var0_32)
			end, SFX_PANEL)
		end
	end)

	for iter0_31, iter1_31 in pairs(arg0_31.operateBtns) do
		setActive(iter1_31, iter0_31 == "Confirm" or iter0_31 == "Cancel")
	end

	setText(arg0_31.operateCountdesc, i18n("compose_amount_prefix"))
	setActive(arg0_31.keepFateTog, false)
end

function var0_0.UpdateResolvePanel(arg0_34)
	local var0_34 = arg0_34.operateCount

	setText(arg0_34.operateValue, var0_34)

	local var1_34 = arg0_34.itemVO:getConfig("price")
	local var2_34 = {}

	table.insert(var2_34, {
		type = DROP_TYPE_RESOURCE,
		id = var1_34[1],
		count = var1_34[2] * var0_34
	})
	UIItemList.StaticAlign(arg0_34.operateBonusList, arg0_34.operateBonusTpl, #var2_34, function(arg0_35, arg1_35, arg2_35)
		arg1_35 = arg1_35 + 1

		if arg0_35 == UIItemList.EventUpdate then
			local var0_35 = var2_34[arg1_35]

			updateDrop(arg2_35:Find("IconTpl"), var0_35)
			onButton(arg0_34, arg2_35:Find("IconTpl"), function()
				arg0_34:emit(var0_0.ON_DROP, var0_35)
			end, SFX_PANEL)
		end
	end)

	for iter0_34, iter1_34 in pairs(arg0_34.operateBtns) do
		setActive(iter1_34, iter0_34 == "Resolve" or iter0_34 == "Cancel")
	end

	setText(arg0_34.operateCountdesc, i18n("resolve_amount_prefix"))

	if arg0_34.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0_34.keepFateTog, false)
	else
		setActive(arg0_34.keepFateTog, true)
	end

	setButtonEnabled(arg0_34.operateBtns.Resolve, var0_34 > 0)
end

function var0_0.UpdateBlueprintResolveNum(arg0_37)
	local var0_37 = arg0_37.itemVO.count

	if arg0_37.itemVO:getConfig("type") == Item.BLUEPRINT_TYPE then
		local var1_37 = getProxy(TechnologyProxy)
		local var2_37 = var1_37:GetBlueprint4Item(arg0_37.itemVO.id)
		local var3_37 = var1_37:getBluePrintById(var2_37)

		if arg0_37.keepFateState then
			var0_37 = arg0_37.itemVO.count - var3_37:getFateMaxLeftOver()
			var0_37 = var0_37 < 0 and 0 or var0_37
		end
	end

	arg0_37.operateMax = var0_37
end

function var0_0.UpdateSpeedUpResolveNum(arg0_38)
	local var0_38 = arg0_38.itemVO.count

	if arg0_38.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		arg0_38.operateMax = var0_38
	end
end

function var0_0.willExit(arg0_39)
	if arg0_39.leftEventTrigger then
		ClearEventTrigger(arg0_39.leftEventTrigger)
	end

	if arg0_39.rightEventTrigger then
		ClearEventTrigger(arg0_39.rightEventTrigger)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_39._tf)
end

function var0_0.PlayOpenBox(arg0_40, arg1_40, arg2_40)
	if not arg1_40 or arg1_40 == "" then
		arg2_40()

		return
	end

	local var0_40 = {}
	local var1_40 = arg0_40:findTF(arg1_40 .. "(Clone)")

	if var1_40 then
		arg0_40[arg1_40] = go(var1_40)
	end

	if not arg0_40[arg1_40] then
		table.insert(var0_40, function(arg0_41)
			PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1_40), "", true, function(arg0_42)
				arg0_42:SetActive(true)

				arg0_40[arg1_40] = arg0_42

				arg0_41()
			end)
		end)
	end

	seriesAsync(var0_40, function()
		if arg0_40.playing or not arg0_40[arg1_40] then
			return
		end

		arg0_40.playing = true

		arg0_40[arg1_40]:SetActive(true)
		SetActive(arg0_40.window, false)

		local var0_43 = tf(arg0_40[arg1_40])

		var0_43:SetParent(arg0_40._tf, false)
		var0_43:SetAsLastSibling()

		local var1_43 = var0_43:GetComponent("DftAniEvent")

		var1_43:SetTriggerEvent(function(arg0_44)
			arg2_40()
		end)
		var1_43:SetEndEvent(function(arg0_45)
			if arg0_40[arg1_40] then
				SetActive(arg0_40[arg1_40], false)

				arg0_40.playing = false
			end

			arg0_40:closeView()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end)
end

return var0_0
