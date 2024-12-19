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
		},
		recycleBtn = {
			"recycle_btn",
			i18n("recycle_btn_label")
		},
		skinShopBtn = {
			"skin_shop_btn",
			i18n("go_skinshop_btn_label")
		},
		skinExperienceShopBtn = {
			"skin_experience_shop_btn",
			i18n("go_skinexperienceshop_btn_label")
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
	arg0_2.recycleConfirmationPage = ItemRecycleConfirmationPage.New(pg.UIMgr.GetInstance().OverlayMain)

	arg0_2.recycleConfirmationPage:SetCallback(function()
		setActive(arg0_2._tf, false)
	end, function()
		setActive(arg0_2._tf, true)
	end)
end

function var0_0.getButton(arg0_6, arg1_6, arg2_6)
	arg0_6[arg1_6] = arg0_6[arg1_6] or cloneTplTo(arg2_6, arg0_6.btnContent)

	setActive(arg0_6[arg1_6], true)

	return arg0_6[arg1_6]
end

function var0_0.setDrop(arg0_7, arg1_7)
	if arg1_7.type == DROP_TYPE_SHIP then
		arg0_7:setItemInfo(arg1_7, arg0_7.itemTF)
	elseif arg1_7.type == DROP_TYPE_ITEM then
		arg1_7.count = getProxy(BagProxy):getItemCountById(arg1_7.id)

		arg0_7:setItem(arg1_7)
	else
		assert(false, "do not support current kind of type: " .. arg1_7.type)
	end
end

function var0_0.setItemInfo(arg0_8, arg1_8, arg2_8)
	updateDrop(arg2_8:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = arg1_8
	}))
	UpdateOwnDisplay(arg2_8:Find("left/own"), arg1_8)
	RegisterDetailButton(arg0_8, arg2_8:Find("left/detail"), arg1_8)
	setText(arg2_8:Find("display_panel/name_container/name/Text"), arg1_8:getConfig("name"))
	setText(arg2_8:Find("display_panel/desc/Text"), arg1_8.desc)

	local var0_8 = arg2_8:Find("display_panel/name_container/shiptype")

	setActive(var0_8, arg1_8.type == DROP_TYPE_SHIP)

	if arg1_8.type == DROP_TYPE_SHIP then
		GetImageSpriteFromAtlasAsync("shiptype", shipType2print(arg1_8:getConfig("type")), var0_8, false)
	end
end

function var0_0.updateItemCount(arg0_9, arg1_9)
	arg0_9.countTF.text = arg1_9
end

function var0_0.setItem(arg0_10, arg1_10)
	arg0_10:setItemInfo(arg1_10, arg0_10.itemTF)

	arg0_10.itemVO = arg1_10:getSubClass()

	if not Item.CanInBag(arg0_10.itemVO.id) then
		return
	end

	local var0_10 = arg0_10.itemVO:getConfig("compose_number")

	if var0_10 > 0 and var0_10 <= arg0_10.itemVO.count then
		arg0_10:setItemInfo(arg1_10, arg0_10.operatePanel:Find("item"))

		arg0_10.operateMax = arg0_10.itemVO.count / var0_10

		setActive(arg0_10.composeBtn, true)
	end

	if arg0_10.itemVO:getConfig("usage") == ItemUsage.SOS then
		setText(arg0_10.useBtn:Find("text"), 1)
		setActive(arg0_10.useBtn, true)
	end

	local var1_10 = arg0_10.itemVO:getConfig("type")

	if Item.IsLoveLetterCheckItem(arg0_10.itemVO.id) then
		local var2_10 = arg0_10.itemVO.extra or pg.loveletter_2018_2021[arg0_10.itemVO.id].ship_group_id
		local var3_10 = arg0_10:getButton("checkMail", arg0_10.blueBtn)

		setText(var3_10:Find("pic"), i18n("loveletter_recover_bottom1"))
		onButton(arg0_10, var3_10, function()
			arg0_10:emit(ItemInfoMediator.CHECK_LOVE_LETTER_MAIL, arg0_10.itemVO.id, var2_10)
		end, SFX_CONFIRM)

		local var4_10 = arg0_10:getButton("repairMail", arg0_10.yellowBtn)

		setText(var4_10:Find("pic"), i18n("loveletter_recover_bottom2"))

		local var5_10 = getProxy(BagProxy):GetLoveLetterRepairInfo(arg0_10.itemVO.id .. "_" .. var2_10)

		onButton(arg0_10, var4_10, function()
			if not var5_10 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_recover_tip1"))
			elseif #var5_10 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_recover_tip3"))
			elseif #var5_10 == 1 then
				local var0_12 = var5_10[1]

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					delayConfirm = 3,
					content = i18n("loveletter_recover_text1", var0_12, ShipGroup.New({
						id = var2_10
					}):getName()),
					onYes = function()
						arg0_10:emit(ItemInfoMediator.REPAIR_LOVE_LETTER_MAIL, arg0_10.itemVO.id, var0_12, var2_10)
					end
				})
			else
				table.sort(var5_10)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideYes = true,
					content = i18n("loveletter_recover_text2", ShipGroup.New({
						id = var2_10
					}):getName()),
					custom = underscore.map(var5_10, function(arg0_14)
						return {
							delayButton = 3,
							text = i18n("loveletter_recover_bottom3", arg0_14),
							sound = SFX_CONFIRM,
							onCallback = function()
								arg0_10:emit(ItemInfoMediator.REPAIR_LOVE_LETTER_MAIL, arg0_10.itemVO.id, arg0_14, var2_10)
							end,
							btnType = pg.MsgboxMgr.BUTTON_YELLOW
						}
					end)
				})
			end
		end, SFX_PANEL)
		setGray(var4_10, not var5_10 or #var5_10 == 0)
	elseif arg0_10.itemVO:CanOpen() then
		setText(arg0_10.useBtn:Find("text"), 1)
		setActive(arg0_10.useBtn, true)

		if arg0_10.itemVO.count > 1 then
			setText(arg0_10.batchUseBtn:Find("text"), math.min(arg0_10.itemVO.count, 10))
			setActive(arg0_10.batchUseBtn, true)
		end
	elseif var1_10 == Item.BLUEPRINT_TYPE then
		local var6_10 = getProxy(TechnologyProxy)
		local var7_10 = var6_10:GetBlueprint4Item(arg0_10.itemVO.id)

		if not LOCK_FRAGMENT_SHOP and var7_10 and var6_10:getBluePrintById(var7_10):isMaxLevel() then
			setActive(arg0_10.resolveBtn, true)
			arg0_10:UpdateBlueprintResolveNum()
		end

		arg0_10:setItemInfo(arg1_10, arg0_10.operatePanel:Find("item"))
		setActive(arg0_10.okBtn, true)
	elseif var1_10 == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0_10.resolveBtn, true)
		arg0_10:UpdateSpeedUpResolveNum()
		arg0_10:setItemInfo(arg1_10, arg0_10.operatePanel:Find("item"))
		setActive(arg0_10.okBtn, true)
	elseif var1_10 == Item.LOVE_LETTER_TYPE then
		local var8_10 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER)

		setActive(arg0_10.loveRepairBtn, var8_10 and not var8_10:isEnd() and var8_10.data1 > 0 and arg0_10.itemVO.extra == 31201)
		onButton(arg0_10, arg0_10.loveRepairBtn, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("loveletter_exchange_confirm"),
				onYes = function()
					arg0_10:emit(ItemInfoMediator.EXCHANGE_LOVE_LETTER_ITEM, var8_10.id)
				end
			})
		end, SFX_PANEL)
		setActive(arg0_10.okBtn, true)
	elseif var1_10 == Item.METALESSON_TYPE then
		setActive(arg0_10.metaskillBtn, true)
		onButton(arg0_10, arg0_10.metaskillBtn, function()
			arg0_10:closeView()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER)
		end, SFX_PANEL)
		setActive(arg0_10.okBtn, true)
	elseif var1_10 == Item.SKIN_ASSIGNED_TYPE then
		setActive(arg0_10.useOneBtn, arg0_10.contextData.confirmCall)
		onButton(arg0_10, arg0_10.useOneBtn, function()
			arg0_10.contextData.confirmCall()
			arg0_10:closeView()
		end, SFX_PANEL)
		setActive(arg0_10.okBtn, true)
	elseif arg0_10.itemVO:IsExclusiveDiscountType() then
		setActive(arg0_10.recycleBtn, true)
		setActive(arg0_10.skinShopBtn, true)
	elseif arg0_10.itemVO:IsSkinExperienceType() then
		setActive(arg0_10.skinExperienceShopBtn, true)
	else
		setActive(arg0_10.okBtn, true)
	end
end

function var0_0.closeView(arg0_20)
	if arg0_20.playing then
		return
	end

	var0_0.super.closeView(arg0_20)
end

function var0_0.didEnter(arg0_21)
	local var0_21 = arg0_21:findTF("OpenBox(Clone)")

	if var0_21 then
		SetActive(var0_21, false)
	end

	onButton(arg0_21, arg0_21._tf:Find("bg"), function()
		arg0_21:closeView()
	end, SFX_CANCEL)
	onButton(arg0_21, arg0_21._tf:Find("window/top/btnBack"), function()
		arg0_21:closeView()
	end, SFX_CANCEL)
	onButton(arg0_21, arg0_21.okBtn, function()
		arg0_21:closeView()
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21.useBtn, function()
		arg0_21:emit(ItemInfoMediator.USE_ITEM, arg0_21.itemVO.id, 1)
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21.batchUseBtn, function()
		arg0_21:emit(ItemInfoMediator.USE_ITEM, arg0_21.itemVO.id, math.min(arg0_21.itemVO.count, 10))
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21.composeBtn, function()
		SetActive(arg0_21.operatePanel, true)
		SetActive(arg0_21.window, false)

		arg0_21.operateMode = var3_0.COMPOSE

		arg0_21:SetOperateCount(1)
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21.resolveBtn, function()
		SetActive(arg0_21.operatePanel, true)
		SetActive(arg0_21.window, false)

		arg0_21.operateMode = var3_0.RESOLVE

		arg0_21:SetOperateCount(1)
	end, SFX_PANEL)
	pressPersistTrigger(arg0_21.operateLeftButton, 0.5, function(arg0_29)
		if not arg0_21:UpdateCount(arg0_21.operateCount - 1) then
			arg0_29()

			return
		end

		arg0_21:SetOperateCount(arg0_21.operateCount - 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_21.operateRightButton, 0.5, function(arg0_30)
		if not arg0_21:UpdateCount(arg0_21.operateCount + 1) then
			arg0_30()

			return
		end

		arg0_21:SetOperateCount(arg0_21.operateCount + 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_21, arg0_21.operateMaxButton, function()
		arg0_21:SetOperateCount(arg0_21.operateMax)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.operateBtns.Cancel, function()
		SetActive(arg0_21.operatePanel, false)
		SetActive(arg0_21.window, true)
	end, SFX_CANCEL)
	onButton(arg0_21, arg0_21.operateBtns.Confirm, function()
		arg0_21:emit(ItemInfoMediator.COMPOSE_ITEM, arg0_21.itemVO.id, arg0_21.operateCount)

		local var0_33 = arg0_21.itemVO:getConfig("compose_number")

		if var0_33 > arg0_21.itemVO.count - arg0_21.operateCount * var0_33 then
			triggerButton(arg0_21.operateBtns.Cancel)
		else
			arg0_21:SetOperateCount(1)
		end
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21.recycleBtn, function()
		local var0_34 = arg0_21.itemVO:GetPrice() or {
			0,
			0
		}
		local var1_34 = i18n("skin_discount_item_recycle_tip", arg0_21.itemVO:getName(), var0_34[2])

		arg0_21.recycleConfirmationPage:ExecuteAction("Show", {
			content = var1_34,
			itemId = arg0_21.itemVO.id
		})
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21.skinShopBtn, function()
		arg0_21:closeView()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21.skinExperienceShopBtn, function()
		arg0_21:closeView()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP, {
			mode = NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM
		})
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21.operateBtns.Resolve, function()
		arg0_21:emit(ItemInfoMediator.SELL_BLUEPRINT, Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg0_21.itemVO.id,
			count = arg0_21.operateCount
		}))
	end, SFX_CONFIRM)

	local var1_21 = getProxy(PlayerProxy):getData()
	local var2_21 = GetComponent(arg0_21.keepFateTog, typeof(Toggle))

	arg0_21.keepFateState = not var1_21:GetCommonFlag(SHOW_DONT_KEEP_FATE_ITEM)
	var2_21.isOn = arg0_21.keepFateState

	local function var3_21()
		arg0_21:UpdateBlueprintResolveNum()
		arg0_21:SetOperateCount(1)
	end

	onToggle(arg0_21, arg0_21.keepFateTog, function(arg0_39)
		arg0_21.keepFateState = arg0_39

		if arg0_39 then
			pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		else
			pg.m02:sendNotification(GAME.COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		end

		var3_21()
	end)
	var3_21()
end

function var0_0.UpdateCount(arg0_40, arg1_40)
	if arg0_40.operateMode == var3_0.COMPOSE then
		local var0_40 = arg0_40.itemVO:getConfig("target_id")

		if not var0_40 or var0_40 <= 0 then
			return false
		end

		arg1_40 = math.clamp(arg1_40, 1, math.floor(arg0_40.itemVO.count / arg0_40.itemVO:getConfig("compose_number")))

		return arg0_40.operateCount ~= arg1_40
	elseif arg0_40.operateMode == var3_0.RESOLVE then
		arg1_40 = math.clamp(arg1_40, 1, arg0_40.itemVO.count)

		return arg0_40.operateCount ~= arg1_40
	end
end

function var0_0.SetOperateCount(arg0_41, arg1_41)
	if arg0_41.operateMode == var3_0.COMPOSE then
		local var0_41 = arg0_41.itemVO:getConfig("target_id")

		if not var0_41 or var0_41 <= 0 then
			return
		end

		local var1_41 = arg0_41.itemVO:getConfig("compose_number")

		arg1_41 = math.clamp(arg1_41, 1, math.floor(arg0_41.itemVO.count / var1_41))

		if arg0_41.operateCount ~= arg1_41 then
			arg0_41.operateCount = arg1_41

			arg0_41:UpdateComposeCount()
		end

		local var2_41 = arg0_41.itemVO.count - arg0_41.operateCount * var1_41

		arg0_41:updateItemCount(var2_41)
	elseif arg0_41.operateMode == var3_0.RESOLVE then
		arg1_41 = math.clamp(arg1_41, 0, arg0_41.operateMax)

		if arg0_41.operateCount ~= arg1_41 then
			arg0_41.operateCount = arg1_41

			arg0_41:UpdateResolvePanel()
			arg0_41:updateItemCount(arg0_41.itemVO.count - arg0_41.operateCount)
		end
	end
end

function var0_0.UpdateComposeCount(arg0_42)
	local var0_42 = arg0_42.operateCount

	setText(arg0_42.operateValue, var0_42)

	local var1_42 = {}

	table.insert(var1_42, {
		type = DROP_TYPE_ITEM,
		id = arg0_42.itemVO:getConfig("target_id"),
		count = var0_42
	})
	UIItemList.StaticAlign(arg0_42.operateBonusList, arg0_42.operateBonusTpl, #var1_42, function(arg0_43, arg1_43, arg2_43)
		arg1_43 = arg1_43 + 1

		if arg0_43 == UIItemList.EventUpdate then
			local var0_43 = var1_42[arg1_43]

			updateDrop(arg2_43:Find("IconTpl"), var0_43)
			onButton(arg0_42, arg2_43:Find("IconTpl"), function()
				arg0_42:emit(var0_0.ON_DROP, var0_43)
			end, SFX_PANEL)
		end
	end)

	for iter0_42, iter1_42 in pairs(arg0_42.operateBtns) do
		setActive(iter1_42, iter0_42 == "Confirm" or iter0_42 == "Cancel")
	end

	setText(arg0_42.operateCountdesc, i18n("compose_amount_prefix"))
	setActive(arg0_42.keepFateTog, false)
end

function var0_0.UpdateResolvePanel(arg0_45)
	local var0_45 = arg0_45.operateCount

	setText(arg0_45.operateValue, var0_45)

	local var1_45 = arg0_45.itemVO:getConfig("price")
	local var2_45 = {}

	table.insert(var2_45, {
		type = DROP_TYPE_RESOURCE,
		id = var1_45[1],
		count = var1_45[2] * var0_45
	})
	UIItemList.StaticAlign(arg0_45.operateBonusList, arg0_45.operateBonusTpl, #var2_45, function(arg0_46, arg1_46, arg2_46)
		arg1_46 = arg1_46 + 1

		if arg0_46 == UIItemList.EventUpdate then
			local var0_46 = var2_45[arg1_46]

			updateDrop(arg2_46:Find("IconTpl"), var0_46)
			onButton(arg0_45, arg2_46:Find("IconTpl"), function()
				arg0_45:emit(var0_0.ON_DROP, var0_46)
			end, SFX_PANEL)
		end
	end)

	for iter0_45, iter1_45 in pairs(arg0_45.operateBtns) do
		setActive(iter1_45, iter0_45 == "Resolve" or iter0_45 == "Cancel")
	end

	setText(arg0_45.operateCountdesc, i18n("resolve_amount_prefix"))

	if arg0_45.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0_45.keepFateTog, false)
	else
		setActive(arg0_45.keepFateTog, true)
	end

	setButtonEnabled(arg0_45.operateBtns.Resolve, var0_45 > 0)
end

function var0_0.UpdateBlueprintResolveNum(arg0_48)
	local var0_48 = arg0_48.itemVO.count

	if arg0_48.itemVO:getConfig("type") == Item.BLUEPRINT_TYPE then
		local var1_48 = getProxy(TechnologyProxy)
		local var2_48 = var1_48:GetBlueprint4Item(arg0_48.itemVO.id)
		local var3_48 = var1_48:getBluePrintById(var2_48)

		if arg0_48.keepFateState then
			var0_48 = arg0_48.itemVO.count - var3_48:getFateMaxLeftOver()
			var0_48 = var0_48 < 0 and 0 or var0_48
		end
	end

	arg0_48.operateMax = var0_48
end

function var0_0.UpdateSpeedUpResolveNum(arg0_49)
	local var0_49 = arg0_49.itemVO.count

	if arg0_49.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		arg0_49.operateMax = var0_49
	end
end

function var0_0.willExit(arg0_50)
	if arg0_50.leftEventTrigger then
		ClearEventTrigger(arg0_50.leftEventTrigger)
	end

	if arg0_50.rightEventTrigger then
		ClearEventTrigger(arg0_50.rightEventTrigger)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_50._tf)

	if arg0_50.recycleConfirmationPage then
		arg0_50.recycleConfirmationPage:Destroy()

		arg0_50.recycleConfirmationPage = nil
	end
end

function var0_0.PlayOpenBox(arg0_51, arg1_51, arg2_51)
	if not arg1_51 or arg1_51 == "" then
		arg2_51()

		return
	end

	local var0_51 = {}
	local var1_51 = arg0_51:findTF(arg1_51 .. "(Clone)")

	if var1_51 then
		arg0_51[arg1_51] = go(var1_51)
	end

	if not arg0_51[arg1_51] then
		table.insert(var0_51, function(arg0_52)
			PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1_51), "", true, function(arg0_53)
				arg0_53:SetActive(true)

				arg0_51[arg1_51] = arg0_53

				arg0_52()
			end)
		end)
	end

	seriesAsync(var0_51, function()
		if arg0_51.playing or not arg0_51[arg1_51] then
			return
		end

		arg0_51.playing = true

		arg0_51[arg1_51]:SetActive(true)
		SetActive(arg0_51.window, false)

		local var0_54 = tf(arg0_51[arg1_51])

		var0_54:SetParent(arg0_51._tf, false)
		var0_54:SetAsLastSibling()

		local var1_54 = var0_54:GetComponent("DftAniEvent")

		var1_54:SetTriggerEvent(function(arg0_55)
			arg2_51()
		end)
		var1_54:SetEndEvent(function(arg0_56)
			if arg0_51[arg1_51] then
				SetActive(arg0_51[arg1_51], false)

				arg0_51.playing = false
			end

			arg0_51:closeView()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end)
end

function var0_0.inOutAnim(arg0_57, arg1_57, arg2_57)
	if arg1_57 then
		local var0_57 = arg0_57:findTF("window/bg_decorations"):GetComponent(typeof(Animation))

		var0_57:Stop()
		var0_57:Play("anim_window_bg")

		local var1_57 = arg0_57:findTF("window/top"):GetComponent(typeof(Animation))

		var1_57:Stop()
		var1_57:Play("anim_top")

		local var2_57 = arg0_57:findTF("window"):GetComponent(typeof(Animation))

		var2_57:Stop()
		var2_57:Play("anim_content")

		local var3_57 = arg0_57:findTF("bg"):GetComponent(typeof(Animation))

		var3_57:Stop()
		var3_57:Play("anim_bg_plus")
	end

	arg2_57()
end

return var0_0
