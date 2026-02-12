local var0_0 = class("ItemInfoLayer", import("..base.BaseUI"))
local var1_0 = 5
local var2_0 = 11
local var3_0 = 100
local var4_0 = 53996
local var5_0 = {
	RESOLVE = 2,
	USE = 3,
	COMPOSE = 1
}

function var0_0.getUIName(arg0_1)
	return "ItemInfoUI"
end

function var0_0.init(arg0_2)
	arg0_2:BlurPanel(arg0_2._tf)

	arg0_2.window = arg0_2._tf:Find("window")

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
	arg0_2.operatePanel = arg0_2._tf:Find("operate")
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
	arg0_2.operateValueInput = arg0_2.operatePanel:Find("count/number_panel/InputField")
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
	elseif arg0_10.itemVO:getConfig("type") == Item.EQUIPMENT_BOX_TYPE_5 then
		arg0_10:setItemInfo(arg1_10, arg0_10.operatePanel:Find("item"))
		setActive(arg0_10.useOneBtn, true)
		onButton(arg0_10, arg0_10.useOneBtn, function()
			SetActive(arg0_10.operatePanel, true)
			SetActive(arg0_10.window, false)

			arg0_10.operateMode = var5_0.USE

			arg0_10:SetOperateCount(1)
		end, SFX_PANEL)
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
		setActive(arg0_10.loveRepairBtn, false)
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

function var0_0.closeView(arg0_19)
	if arg0_19.playing then
		return
	end

	var0_0.super.closeView(arg0_19)
end

function var0_0.didEnter(arg0_20)
	local var0_20 = arg0_20._tf:Find("OpenBox(Clone)")

	if var0_20 then
		SetActive(var0_20, false)
	end

	onButton(arg0_20, arg0_20._tf:Find("bg"), function()
		arg0_20:closeView()
	end, SFX_CANCEL)
	onButton(arg0_20, arg0_20._tf:Find("window/top/btnBack"), function()
		arg0_20:closeView()
	end, SFX_CANCEL)
	onButton(arg0_20, arg0_20.okBtn, function()
		arg0_20:closeView()
	end, SFX_CONFIRM)
	onButton(arg0_20, arg0_20.useBtn, function()
		arg0_20:emit(ItemInfoMediator.USE_ITEM, arg0_20.itemVO.id, 1)
	end, SFX_CONFIRM)
	onButton(arg0_20, arg0_20.batchUseBtn, function()
		arg0_20:emit(ItemInfoMediator.USE_ITEM, arg0_20.itemVO.id, math.min(arg0_20.itemVO.count, 10))
	end, SFX_CONFIRM)
	onButton(arg0_20, arg0_20.composeBtn, function()
		SetActive(arg0_20.operatePanel, true)
		SetActive(arg0_20.window, false)

		arg0_20.operateMode = var5_0.COMPOSE

		arg0_20:SetOperateCount(1)
	end, SFX_CONFIRM)
	onButton(arg0_20, arg0_20.resolveBtn, function()
		SetActive(arg0_20.operatePanel, true)
		SetActive(arg0_20.window, false)

		arg0_20.operateMode = var5_0.RESOLVE

		arg0_20:SetOperateCount(1)
	end, SFX_PANEL)
	pressPersistTrigger(arg0_20.operateLeftButton, 0.5, function(arg0_28)
		if not arg0_20:UpdateCount(arg0_20.operateCount - 1) then
			arg0_28()

			return
		end

		arg0_20:SetOperateCount(arg0_20.operateCount - 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_20.operateRightButton, 0.5, function(arg0_29)
		if not arg0_20:UpdateCount(arg0_20.operateCount + 1) then
			arg0_29()

			return
		end

		arg0_20:SetOperateCount(arg0_20.operateCount + 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_20, arg0_20.operateMaxButton, function()
		arg0_20:SetOperateCount(arg0_20.operateMax)
	end, SFX_PANEL)
	onInputEndEdit(arg0_20, arg0_20.operateValueInput, function(arg0_31)
		local var0_31 = tonumber(arg0_31) or 1
		local var1_31 = math.min(var3_0, math.min(var0_31, arg0_20.operateMax))
		local var2_31 = math.max(1, var1_31)

		arg0_20:SetOperateCount(var2_31)

		if arg0_31 ~= tostring(var2_31) then
			setInputText(arg0_20.operateValueInput, var2_31)
		end
	end)

	local var1_20 = arg0_20.itemVO:getConfig("type") == Item.EQUIPMENT_BOX_TYPE_5

	setActive(arg0_20.operateValueInput, var1_20)
	setActive(arg0_20.operateValue, not var1_20)
	onButton(arg0_20, arg0_20.operateBtns.Cancel, function()
		SetActive(arg0_20.operatePanel, false)
		SetActive(arg0_20.window, true)

		arg0_20.operateCount = 0
		arg0_20.operateMode = nil
	end, SFX_CANCEL)
	onButton(arg0_20, arg0_20.operateBtns.Confirm, function()
		if arg0_20.operateMode == var5_0.COMPOSE then
			arg0_20:emit(ItemInfoMediator.COMPOSE_ITEM, arg0_20.itemVO.id, arg0_20.operateCount)

			local var0_33 = arg0_20.itemVO:getConfig("compose_number")

			if var0_33 > arg0_20.itemVO.count - arg0_20.operateCount * var0_33 then
				triggerButton(arg0_20.operateBtns.Cancel)
			else
				arg0_20:SetOperateCount(1)
			end
		elseif arg0_20.operateMode == var5_0.USE then
			arg0_20:emit(ItemInfoMediator.USE_ITEM, arg0_20.itemVO.id, arg0_20.operateCount)
		end
	end, SFX_CONFIRM)
	onButton(arg0_20, arg0_20.recycleBtn, function()
		local var0_34 = arg0_20.itemVO:GetPrice() or {
			0,
			0
		}
		local var1_34 = i18n("skin_discount_item_recycle_tip", arg0_20.itemVO:getName(), var0_34[2])

		arg0_20.recycleConfirmationPage:ExecuteAction("Show", {
			content = var1_34,
			itemId = arg0_20.itemVO.id
		})
	end, SFX_CONFIRM)
	onButton(arg0_20, arg0_20.skinShopBtn, function()
		arg0_20:closeView()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end, SFX_CONFIRM)
	onButton(arg0_20, arg0_20.skinExperienceShopBtn, function()
		arg0_20:closeView()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP, {
			mode = NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM
		})
	end, SFX_CONFIRM)
	onButton(arg0_20, arg0_20.operateBtns.Resolve, function()
		arg0_20:emit(ItemInfoMediator.SELL_BLUEPRINT, Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg0_20.itemVO.id,
			count = arg0_20.operateCount
		}))
	end, SFX_CONFIRM)

	local var2_20 = getProxy(PlayerProxy):getData()
	local var3_20 = GetComponent(arg0_20.keepFateTog, typeof(Toggle))

	arg0_20.keepFateState = not var2_20:GetCommonFlag(SHOW_DONT_KEEP_FATE_ITEM)
	var3_20.isOn = arg0_20.keepFateState

	local function var4_20()
		arg0_20:UpdateBlueprintResolveNum()
		arg0_20:SetOperateCount(1)
	end

	onToggle(arg0_20, arg0_20.keepFateTog, function(arg0_39)
		arg0_20.keepFateState = arg0_39

		if arg0_39 then
			pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		else
			pg.m02:sendNotification(GAME.COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		end

		var4_20()
	end)
	var4_20()
end

function var0_0.UpdateCount(arg0_40, arg1_40)
	if arg0_40.operateMode == var5_0.COMPOSE then
		local var0_40 = arg0_40.itemVO:getConfig("target_id")

		if not var0_40 or var0_40 <= 0 then
			return false
		end

		arg1_40 = math.clamp(arg1_40, 1, math.floor(arg0_40.itemVO.count / arg0_40.itemVO:getConfig("compose_number")))

		return arg0_40.operateCount ~= arg1_40
	elseif arg0_40.operateMode == var5_0.RESOLVE then
		arg1_40 = math.clamp(arg1_40, 1, arg0_40.itemVO.count)

		return arg0_40.operateCount ~= arg1_40
	elseif arg0_40.operateMode == var5_0.USE then
		arg1_40 = math.clamp(arg1_40, 1, arg0_40.itemVO.count)

		return arg0_40.operateCount ~= arg1_40
	end
end

function var0_0.SetOperateCount(arg0_41, arg1_41)
	if arg0_41.operateMode == var5_0.COMPOSE then
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
	elseif arg0_41.operateMode == var5_0.RESOLVE then
		arg1_41 = math.clamp(arg1_41, 0, arg0_41.operateMax)

		if arg0_41.operateCount ~= arg1_41 then
			arg0_41.operateCount = arg1_41

			arg0_41:UpdateResolvePanel()
			arg0_41:updateItemCount(arg0_41.itemVO.count - arg0_41.operateCount)
		end
	elseif arg0_41.operateMode == var5_0.USE then
		arg1_41 = math.clamp(arg1_41, 0, math.min(arg0_41.operateMax, var3_0))

		if arg0_41.operateCount ~= arg1_41 then
			arg0_41.operateCount = arg1_41

			arg0_41:UpdateUsePanel()
			arg0_41:updateItemCount(arg0_41.itemVO.count - arg0_41.operateCount)
		end
	end
end

function var0_0.UpdateComposeCount(arg0_42)
	local var0_42 = arg0_42.operateCount

	setText(arg0_42.operateValue, var0_42)
	setInputText(arg0_42.operateValueInput, var0_42)

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
	setInputText(arg0_45.operateValueInput, var0_45)

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

function var0_0.UpdateUsePanel(arg0_50)
	local var0_50 = arg0_50.operateCount

	setText(arg0_50.operateValue, var0_50)
	setInputText(arg0_50.operateValueInput, var0_50)

	local var1_50 = {}

	table.insert(var1_50, {
		type = DROP_TYPE_ITEM,
		id = var4_0,
		count = var0_50
	})
	UIItemList.StaticAlign(arg0_50.operateBonusList, arg0_50.operateBonusTpl, #var1_50, function(arg0_51, arg1_51, arg2_51)
		arg1_51 = arg1_51 + 1

		if arg0_51 == UIItemList.EventUpdate then
			local var0_51 = var1_50[arg1_51]

			updateDrop(arg2_51:Find("IconTpl"), var0_51)
		end
	end)

	for iter0_50, iter1_50 in pairs(arg0_50.operateBtns) do
		setActive(iter1_50, iter0_50 == "Confirm" or iter0_50 == "Cancel")
	end

	setText(arg0_50.operateCountdesc, i18n("use_amount_prefix"))
	setActive(arg0_50.keepFateTog, false)
end

function var0_0.willExit(arg0_52)
	if arg0_52.leftEventTrigger then
		ClearEventTrigger(arg0_52.leftEventTrigger)
	end

	if arg0_52.rightEventTrigger then
		ClearEventTrigger(arg0_52.rightEventTrigger)
	end

	arg0_52:UnOverlayPanel(arg0_52._tf)

	if arg0_52.recycleConfirmationPage then
		arg0_52.recycleConfirmationPage:Destroy()

		arg0_52.recycleConfirmationPage = nil
	end
end

function var0_0.PlayOpenBox(arg0_53, arg1_53, arg2_53)
	if not arg1_53 or arg1_53 == "" then
		arg2_53()

		return
	end

	local var0_53 = {}
	local var1_53 = arg0_53._tf:Find(arg1_53 .. "(Clone)")

	if var1_53 then
		arg0_53[arg1_53] = go(var1_53)
	end

	if not arg0_53[arg1_53] then
		table.insert(var0_53, function(arg0_54)
			PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1_53), "", true, function(arg0_55)
				arg0_55:SetActive(true)

				arg0_53[arg1_53] = arg0_55

				arg0_54()
			end)
		end)
	end

	seriesAsync(var0_53, function()
		if arg0_53.playing or not arg0_53[arg1_53] then
			return
		end

		arg0_53.playing = true

		arg0_53[arg1_53]:SetActive(true)
		SetActive(arg0_53.window, false)

		local var0_56 = tf(arg0_53[arg1_53])

		var0_56:SetParent(arg0_53._tf, false)
		var0_56:SetAsLastSibling()

		local var1_56 = var0_56:GetComponent("DftAniEvent")

		var1_56:SetTriggerEvent(function(arg0_57)
			arg2_53()
		end)
		var1_56:SetEndEvent(function(arg0_58)
			if arg0_53[arg1_53] then
				SetActive(arg0_53[arg1_53], false)

				arg0_53.playing = false
			end

			arg0_53:closeView()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end)
end

function var0_0.inOutAnim(arg0_59, arg1_59, arg2_59)
	if arg1_59 then
		local var0_59 = arg0_59._tf:Find("window/bg_decorations"):GetComponent(typeof(Animation))

		var0_59:Stop()
		var0_59:Play("anim_window_bg")

		local var1_59 = arg0_59._tf:Find("window/top"):GetComponent(typeof(Animation))

		var1_59:Stop()
		var1_59:Play("anim_top")

		local var2_59 = arg0_59._tf:Find("window"):GetComponent(typeof(Animation))

		var2_59:Stop()
		var2_59:Play("anim_content")

		local var3_59 = arg0_59._tf:Find("bg"):GetComponent(typeof(Animation))

		var3_59:Stop()
		var3_59:Play("anim_bg_plus")
	end

	arg2_59()
end

return var0_0
