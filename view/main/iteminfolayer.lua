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

	eachChild(arg0_2.btnContent, function(arg0_3)
		setActive(arg0_3, false)
	end)

	for iter0_2, iter1_2 in pairs({
		okBtn = {
			"ok_button",
			i18n("msgbox_text_confirm")
		},
		useBtn = {
			"use_button"
		},
		batchUseBtn = {
			"batch_use_button"
		},
		useOneBtn = {
			"use_one_button"
		},
		composeBtn = {
			"compose_button"
		},
		resolveBtn = {
			"resolve_button",
			i18n("msgbox_text_analyse")
		},
		loveRepairBtn = {
			"love_lettle_repair_button",
			i18n("loveletter_exchange_button")
		},
		metaskillBtn = {
			"metaskill_use_btn",
			i18n("msgbox_text_use")
		},
		blueBtn = {
			"blue_btn"
		},
		yellowBtn = {
			"yellow_btn"
		}
	}) do
		local var0_2, var1_2 = unpack(iter1_2)

		arg0_2[iter0_2] = arg0_2.btnContent:Find(var0_2)

		if var1_2 then
			setText(arg0_2[iter0_2]:Find("pic"), var1_2)
		end
	end

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

function var0_0.getButton(arg0_4, arg1_4, arg2_4)
	arg0_4[arg1_4] = arg0_4[arg1_4] or cloneTplTo(arg2_4, arg0_4.btnContent)

	setActive(arg0_4[arg1_4], true)

	return arg0_4[arg1_4]
end

function var0_0.setDrop(arg0_5, arg1_5)
	if arg1_5.type == DROP_TYPE_SHIP then
		arg0_5:setItemInfo(arg1_5, arg0_5.itemTF)
	elseif arg1_5.type == DROP_TYPE_ITEM then
		arg1_5.count = getProxy(BagProxy):getItemCountById(arg1_5.id)

		arg0_5:setItem(arg1_5)
	else
		assert(false, "do not support current kind of type: " .. arg1_5.type)
	end
end

function var0_0.setItemInfo(arg0_6, arg1_6, arg2_6)
	updateDrop(arg2_6:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = arg1_6
	}))
	UpdateOwnDisplay(arg2_6:Find("left/own"), arg1_6)
	RegisterDetailButton(arg0_6, arg2_6:Find("left/detail"), arg1_6)
	setText(arg2_6:Find("display_panel/name_container/name/Text"), arg1_6:getConfig("name"))
	setText(arg2_6:Find("display_panel/desc/Text"), arg1_6.desc)

	local var0_6 = arg2_6:Find("display_panel/name_container/shiptype")

	setActive(var0_6, arg1_6.type == DROP_TYPE_SHIP)

	if arg1_6.type == DROP_TYPE_SHIP then
		GetImageSpriteFromAtlasAsync("shiptype", shipType2print(arg1_6:getConfig("type")), var0_6, false)
	end
end

function var0_0.updateItemCount(arg0_7, arg1_7)
	arg0_7.countTF.text = arg1_7
end

function var0_0.setItem(arg0_8, arg1_8)
	arg0_8:setItemInfo(arg1_8, arg0_8.itemTF)

	arg0_8.itemVO = arg1_8:getSubClass()

	if not Item.CanInBag(arg0_8.itemVO.id) then
		return
	end

	local var0_8 = arg0_8.itemVO:getConfig("compose_number")

	if var0_8 > 0 and var0_8 <= arg0_8.itemVO.count then
		arg0_8:setItemInfo(arg1_8, arg0_8.operatePanel:Find("item"))

		arg0_8.operateMax = arg0_8.itemVO.count / var0_8

		setActive(arg0_8.composeBtn, true)
	end

	if arg0_8.itemVO:getConfig("usage") == ItemUsage.SOS then
		setText(arg0_8.useBtn:Find("text"), 1)
		setActive(arg0_8.useBtn, true)
	end

	local var1_8 = arg0_8.itemVO:getConfig("type")

	if Item.IsLoveLetterCheckItem(arg0_8.itemVO.id) then
		local var2_8 = arg0_8.itemVO.extra or pg.loveletter_2018_2021[arg0_8.itemVO.id].ship_group_id
		local var3_8 = arg0_8:getButton("checkMail", arg0_8.blueBtn)

		setText(var3_8:Find("pic"), i18n("loveletter_recover_bottom1"))
		onButton(arg0_8, var3_8, function()
			arg0_8:emit(ItemInfoMediator.CHECK_LOVE_LETTER_MAIL, arg0_8.itemVO.id, var2_8)
		end, SFX_CONFIRM)

		local var4_8 = arg0_8:getButton("repairMail", arg0_8.yellowBtn)

		setText(var4_8:Find("pic"), i18n("loveletter_recover_bottom2"))

		local var5_8 = getProxy(BagProxy):GetLoveLetterRepairInfo(arg0_8.itemVO.id .. "_" .. var2_8)

		onButton(arg0_8, var4_8, function()
			if not var5_8 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_recover_tip1"))
			elseif #var5_8 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_recover_tip3"))
			elseif #var5_8 == 1 then
				local var0_10 = var5_8[1]

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					delayConfirm = 3,
					content = i18n("loveletter_recover_text1", var0_10, ShipGroup.New({
						id = var2_8
					}):getName()),
					onYes = function()
						arg0_8:emit(ItemInfoMediator.REPAIR_LOVE_LETTER_MAIL, arg0_8.itemVO.id, var0_10, var2_8)
					end
				})
			else
				table.sort(var5_8)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideYes = true,
					content = i18n("loveletter_recover_text2", ShipGroup.New({
						id = var2_8
					}):getName()),
					custom = underscore.map(var5_8, function(arg0_12)
						return {
							delayButton = 3,
							text = i18n("loveletter_recover_bottom3", arg0_12),
							sound = SFX_CONFIRM,
							onCallback = function()
								arg0_8:emit(ItemInfoMediator.REPAIR_LOVE_LETTER_MAIL, arg0_8.itemVO.id, arg0_12, var2_8)
							end,
							btnType = pg.MsgboxMgr.BUTTON_YELLOW
						}
					end)
				})
			end
		end, SFX_PANEL)
		setGray(var4_8, not var5_8 or #var5_8 == 0)
	elseif arg0_8.itemVO:CanOpen() then
		setText(arg0_8.useBtn:Find("text"), 1)
		setActive(arg0_8.useBtn, true)

		if arg0_8.itemVO.count > 1 then
			setText(arg0_8.batchUseBtn:Find("text"), math.min(arg0_8.itemVO.count, 10))
			setActive(arg0_8.batchUseBtn, true)
		end
	elseif var1_8 == Item.BLUEPRINT_TYPE then
		local var6_8 = getProxy(TechnologyProxy)
		local var7_8 = var6_8:GetBlueprint4Item(arg0_8.itemVO.id)

		if not LOCK_FRAGMENT_SHOP and var7_8 and var6_8:getBluePrintById(var7_8):isMaxLevel() then
			setActive(arg0_8.resolveBtn, true)
			arg0_8:UpdateBlueprintResolveNum()
		end

		arg0_8:setItemInfo(arg1_8, arg0_8.operatePanel:Find("item"))
		setActive(arg0_8.okBtn, true)
	elseif var1_8 == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0_8.resolveBtn, true)
		arg0_8:UpdateSpeedUpResolveNum()
		arg0_8:setItemInfo(arg1_8, arg0_8.operatePanel:Find("item"))
		setActive(arg0_8.okBtn, true)
	elseif var1_8 == Item.LOVE_LETTER_TYPE then
		local var8_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER)

		setActive(arg0_8.loveRepairBtn, var8_8 and not var8_8:isEnd() and var8_8.data1 > 0 and arg0_8.itemVO.extra == 31201)
		onButton(arg0_8, arg0_8.loveRepairBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("loveletter_exchange_confirm"),
				onYes = function()
					arg0_8:emit(ItemInfoMediator.EXCHANGE_LOVE_LETTER_ITEM, var8_8.id)
				end
			})
		end, SFX_PANEL)
		setActive(arg0_8.okBtn, true)
	elseif var1_8 == Item.METALESSON_TYPE then
		setActive(arg0_8.metaskillBtn, true)
		onButton(arg0_8, arg0_8.metaskillBtn, function()
			arg0_8:closeView()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER)
		end, SFX_PANEL)
		setActive(arg0_8.okBtn, true)
	elseif var1_8 == Item.SKIN_ASSIGNED_TYPE then
		setActive(arg0_8.useOneBtn, arg0_8.contextData.confirmCall)
		onButton(arg0_8, arg0_8.useOneBtn, function()
			arg0_8.contextData.confirmCall()
			arg0_8:closeView()
		end, SFX_PANEL)
		setActive(arg0_8.okBtn, true)
	end
end

function var0_0.closeView(arg0_18)
	if arg0_18.playing then
		return
	end

	var0_0.super.closeView(arg0_18)
end

function var0_0.didEnter(arg0_19)
	local var0_19 = arg0_19:findTF("OpenBox(Clone)")

	if var0_19 then
		SetActive(var0_19, false)
	end

	onButton(arg0_19, arg0_19._tf:Find("bg"), function()
		arg0_19:closeView()
	end, SFX_CANCEL)
	onButton(arg0_19, arg0_19._tf:Find("window/top/btnBack"), function()
		arg0_19:closeView()
	end, SFX_CANCEL)
	onButton(arg0_19, arg0_19.okBtn, function()
		arg0_19:closeView()
	end, SFX_CONFIRM)
	onButton(arg0_19, arg0_19.useBtn, function()
		arg0_19:emit(ItemInfoMediator.USE_ITEM, arg0_19.itemVO.id, 1)
	end, SFX_CONFIRM)
	onButton(arg0_19, arg0_19.batchUseBtn, function()
		arg0_19:emit(ItemInfoMediator.USE_ITEM, arg0_19.itemVO.id, math.min(arg0_19.itemVO.count, 10))
	end, SFX_CONFIRM)
	onButton(arg0_19, arg0_19.composeBtn, function()
		SetActive(arg0_19.operatePanel, true)
		SetActive(arg0_19.window, false)

		arg0_19.operateMode = var3_0.COMPOSE

		arg0_19:SetOperateCount(1)
	end, SFX_CONFIRM)
	onButton(arg0_19, arg0_19.resolveBtn, function()
		SetActive(arg0_19.operatePanel, true)
		SetActive(arg0_19.window, false)

		arg0_19.operateMode = var3_0.RESOLVE

		arg0_19:SetOperateCount(1)
	end, SFX_PANEL)
	pressPersistTrigger(arg0_19.operateLeftButton, 0.5, function(arg0_27)
		if not arg0_19:UpdateCount(arg0_19.operateCount - 1) then
			arg0_27()

			return
		end

		arg0_19:SetOperateCount(arg0_19.operateCount - 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_19.operateRightButton, 0.5, function(arg0_28)
		if not arg0_19:UpdateCount(arg0_19.operateCount + 1) then
			arg0_28()

			return
		end

		arg0_19:SetOperateCount(arg0_19.operateCount + 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_19, arg0_19.operateMaxButton, function()
		arg0_19:SetOperateCount(arg0_19.operateMax)
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.operateBtns.Cancel, function()
		SetActive(arg0_19.operatePanel, false)
		SetActive(arg0_19.window, true)
	end, SFX_CANCEL)
	onButton(arg0_19, arg0_19.operateBtns.Confirm, function()
		arg0_19:emit(ItemInfoMediator.COMPOSE_ITEM, arg0_19.itemVO.id, arg0_19.operateCount)

		local var0_31 = arg0_19.itemVO:getConfig("compose_number")

		if var0_31 > arg0_19.itemVO.count - arg0_19.operateCount * var0_31 then
			triggerButton(arg0_19.operateBtns.Cancel)
		else
			arg0_19:SetOperateCount(1)
		end
	end, SFX_CONFIRM)
	onButton(arg0_19, arg0_19.operateBtns.Resolve, function()
		arg0_19:emit(ItemInfoMediator.SELL_BLUEPRINT, Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg0_19.itemVO.id,
			count = arg0_19.operateCount
		}))
	end, SFX_CONFIRM)

	local var1_19 = getProxy(PlayerProxy):getData()
	local var2_19 = GetComponent(arg0_19.keepFateTog, typeof(Toggle))

	arg0_19.keepFateState = not var1_19:GetCommonFlag(SHOW_DONT_KEEP_FATE_ITEM)
	var2_19.isOn = arg0_19.keepFateState

	local function var3_19()
		arg0_19:UpdateBlueprintResolveNum()
		arg0_19:SetOperateCount(1)
	end

	onToggle(arg0_19, arg0_19.keepFateTog, function(arg0_34)
		arg0_19.keepFateState = arg0_34

		if arg0_34 then
			pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		else
			pg.m02:sendNotification(GAME.COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		end

		var3_19()
	end)
	var3_19()
end

function var0_0.UpdateCount(arg0_35, arg1_35)
	if arg0_35.operateMode == var3_0.COMPOSE then
		local var0_35 = arg0_35.itemVO:getConfig("target_id")

		if not var0_35 or var0_35 <= 0 then
			return false
		end

		arg1_35 = math.clamp(arg1_35, 1, math.floor(arg0_35.itemVO.count / arg0_35.itemVO:getConfig("compose_number")))

		return arg0_35.operateCount ~= arg1_35
	elseif arg0_35.operateMode == var3_0.RESOLVE then
		arg1_35 = math.clamp(arg1_35, 1, arg0_35.itemVO.count)

		return arg0_35.operateCount ~= arg1_35
	end
end

function var0_0.SetOperateCount(arg0_36, arg1_36)
	if arg0_36.operateMode == var3_0.COMPOSE then
		local var0_36 = arg0_36.itemVO:getConfig("target_id")

		if not var0_36 or var0_36 <= 0 then
			return
		end

		local var1_36 = arg0_36.itemVO:getConfig("compose_number")

		arg1_36 = math.clamp(arg1_36, 1, math.floor(arg0_36.itemVO.count / var1_36))

		if arg0_36.operateCount ~= arg1_36 then
			arg0_36.operateCount = arg1_36

			arg0_36:UpdateComposeCount()
		end

		local var2_36 = arg0_36.itemVO.count - arg0_36.operateCount * var1_36

		arg0_36:updateItemCount(var2_36)
	elseif arg0_36.operateMode == var3_0.RESOLVE then
		arg1_36 = math.clamp(arg1_36, 0, arg0_36.operateMax)

		if arg0_36.operateCount ~= arg1_36 then
			arg0_36.operateCount = arg1_36

			arg0_36:UpdateResolvePanel()
			arg0_36:updateItemCount(arg0_36.itemVO.count - arg0_36.operateCount)
		end
	end
end

function var0_0.UpdateComposeCount(arg0_37)
	local var0_37 = arg0_37.operateCount

	setText(arg0_37.operateValue, var0_37)

	local var1_37 = {}

	table.insert(var1_37, {
		type = DROP_TYPE_ITEM,
		id = arg0_37.itemVO:getConfig("target_id"),
		count = var0_37
	})
	UIItemList.StaticAlign(arg0_37.operateBonusList, arg0_37.operateBonusTpl, #var1_37, function(arg0_38, arg1_38, arg2_38)
		arg1_38 = arg1_38 + 1

		if arg0_38 == UIItemList.EventUpdate then
			local var0_38 = var1_37[arg1_38]

			updateDrop(arg2_38:Find("IconTpl"), var0_38)
			onButton(arg0_37, arg2_38:Find("IconTpl"), function()
				arg0_37:emit(var0_0.ON_DROP, var0_38)
			end, SFX_PANEL)
		end
	end)

	for iter0_37, iter1_37 in pairs(arg0_37.operateBtns) do
		setActive(iter1_37, iter0_37 == "Confirm" or iter0_37 == "Cancel")
	end

	setText(arg0_37.operateCountdesc, i18n("compose_amount_prefix"))
	setActive(arg0_37.keepFateTog, false)
end

function var0_0.UpdateResolvePanel(arg0_40)
	local var0_40 = arg0_40.operateCount

	setText(arg0_40.operateValue, var0_40)

	local var1_40 = arg0_40.itemVO:getConfig("price")
	local var2_40 = {}

	table.insert(var2_40, {
		type = DROP_TYPE_RESOURCE,
		id = var1_40[1],
		count = var1_40[2] * var0_40
	})
	UIItemList.StaticAlign(arg0_40.operateBonusList, arg0_40.operateBonusTpl, #var2_40, function(arg0_41, arg1_41, arg2_41)
		arg1_41 = arg1_41 + 1

		if arg0_41 == UIItemList.EventUpdate then
			local var0_41 = var2_40[arg1_41]

			updateDrop(arg2_41:Find("IconTpl"), var0_41)
			onButton(arg0_40, arg2_41:Find("IconTpl"), function()
				arg0_40:emit(var0_0.ON_DROP, var0_41)
			end, SFX_PANEL)
		end
	end)

	for iter0_40, iter1_40 in pairs(arg0_40.operateBtns) do
		setActive(iter1_40, iter0_40 == "Resolve" or iter0_40 == "Cancel")
	end

	setText(arg0_40.operateCountdesc, i18n("resolve_amount_prefix"))

	if arg0_40.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0_40.keepFateTog, false)
	else
		setActive(arg0_40.keepFateTog, true)
	end

	setButtonEnabled(arg0_40.operateBtns.Resolve, var0_40 > 0)
end

function var0_0.UpdateBlueprintResolveNum(arg0_43)
	local var0_43 = arg0_43.itemVO.count

	if arg0_43.itemVO:getConfig("type") == Item.BLUEPRINT_TYPE then
		local var1_43 = getProxy(TechnologyProxy)
		local var2_43 = var1_43:GetBlueprint4Item(arg0_43.itemVO.id)
		local var3_43 = var1_43:getBluePrintById(var2_43)

		if arg0_43.keepFateState then
			var0_43 = arg0_43.itemVO.count - var3_43:getFateMaxLeftOver()
			var0_43 = var0_43 < 0 and 0 or var0_43
		end
	end

	arg0_43.operateMax = var0_43
end

function var0_0.UpdateSpeedUpResolveNum(arg0_44)
	local var0_44 = arg0_44.itemVO.count

	if arg0_44.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		arg0_44.operateMax = var0_44
	end
end

function var0_0.willExit(arg0_45)
	if arg0_45.leftEventTrigger then
		ClearEventTrigger(arg0_45.leftEventTrigger)
	end

	if arg0_45.rightEventTrigger then
		ClearEventTrigger(arg0_45.rightEventTrigger)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_45._tf)
end

function var0_0.PlayOpenBox(arg0_46, arg1_46, arg2_46)
	if not arg1_46 or arg1_46 == "" then
		arg2_46()

		return
	end

	local var0_46 = {}
	local var1_46 = arg0_46:findTF(arg1_46 .. "(Clone)")

	if var1_46 then
		arg0_46[arg1_46] = go(var1_46)
	end

	if not arg0_46[arg1_46] then
		table.insert(var0_46, function(arg0_47)
			PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1_46), "", true, function(arg0_48)
				arg0_48:SetActive(true)

				arg0_46[arg1_46] = arg0_48

				arg0_47()
			end)
		end)
	end

	seriesAsync(var0_46, function()
		if arg0_46.playing or not arg0_46[arg1_46] then
			return
		end

		arg0_46.playing = true

		arg0_46[arg1_46]:SetActive(true)
		SetActive(arg0_46.window, false)

		local var0_49 = tf(arg0_46[arg1_46])

		var0_49:SetParent(arg0_46._tf, false)
		var0_49:SetAsLastSibling()

		local var1_49 = var0_49:GetComponent("DftAniEvent")

		var1_49:SetTriggerEvent(function(arg0_50)
			arg2_46()
		end)
		var1_49:SetEndEvent(function(arg0_51)
			if arg0_46[arg1_46] then
				SetActive(arg0_46[arg1_46], false)

				arg0_46.playing = false
			end

			arg0_46:closeView()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end)
end

return var0_0
