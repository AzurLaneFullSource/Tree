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

function var0_0.closeView(arg0_21)
	if arg0_21.playing then
		return
	end

	var0_0.super.closeView(arg0_21)
end

function var0_0.didEnter(arg0_22)
	local var0_22 = arg0_22:findTF("OpenBox(Clone)")

	if var0_22 then
		SetActive(var0_22, false)
	end

	onButton(arg0_22, arg0_22._tf:Find("bg"), function()
		arg0_22:closeView()
	end, SFX_CANCEL)
	onButton(arg0_22, arg0_22._tf:Find("window/top/btnBack"), function()
		arg0_22:closeView()
	end, SFX_CANCEL)
	onButton(arg0_22, arg0_22.okBtn, function()
		arg0_22:closeView()
	end, SFX_CONFIRM)
	onButton(arg0_22, arg0_22.useBtn, function()
		arg0_22:emit(ItemInfoMediator.USE_ITEM, arg0_22.itemVO.id, 1)
	end, SFX_CONFIRM)
	onButton(arg0_22, arg0_22.batchUseBtn, function()
		arg0_22:emit(ItemInfoMediator.USE_ITEM, arg0_22.itemVO.id, math.min(arg0_22.itemVO.count, 10))
	end, SFX_CONFIRM)
	onButton(arg0_22, arg0_22.composeBtn, function()
		SetActive(arg0_22.operatePanel, true)
		SetActive(arg0_22.window, false)

		arg0_22.operateMode = var5_0.COMPOSE

		arg0_22:SetOperateCount(1)
	end, SFX_CONFIRM)
	onButton(arg0_22, arg0_22.resolveBtn, function()
		SetActive(arg0_22.operatePanel, true)
		SetActive(arg0_22.window, false)

		arg0_22.operateMode = var5_0.RESOLVE

		arg0_22:SetOperateCount(1)
	end, SFX_PANEL)
	pressPersistTrigger(arg0_22.operateLeftButton, 0.5, function(arg0_30)
		if not arg0_22:UpdateCount(arg0_22.operateCount - 1) then
			arg0_30()

			return
		end

		arg0_22:SetOperateCount(arg0_22.operateCount - 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_22.operateRightButton, 0.5, function(arg0_31)
		if not arg0_22:UpdateCount(arg0_22.operateCount + 1) then
			arg0_31()

			return
		end

		arg0_22:SetOperateCount(arg0_22.operateCount + 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_22, arg0_22.operateMaxButton, function()
		arg0_22:SetOperateCount(arg0_22.operateMax)
	end, SFX_PANEL)
	onInputEndEdit(arg0_22, arg0_22.operateValueInput, function(arg0_33)
		local var0_33 = tonumber(arg0_33) or 1
		local var1_33 = math.min(var3_0, math.min(var0_33, arg0_22.operateMax))
		local var2_33 = math.max(1, var1_33)

		arg0_22:SetOperateCount(var2_33)

		if arg0_33 ~= tostring(var2_33) then
			setInputText(arg0_22.operateValueInput, var2_33)
		end
	end)

	local var1_22 = arg0_22.itemVO:getConfig("type") == Item.EQUIPMENT_BOX_TYPE_5

	setActive(arg0_22.operateValueInput, var1_22)
	setActive(arg0_22.operateValue, not var1_22)
	onButton(arg0_22, arg0_22.operateBtns.Cancel, function()
		SetActive(arg0_22.operatePanel, false)
		SetActive(arg0_22.window, true)

		arg0_22.operateCount = 0
		arg0_22.operateMode = nil
	end, SFX_CANCEL)
	onButton(arg0_22, arg0_22.operateBtns.Confirm, function()
		if arg0_22.operateMode == var5_0.COMPOSE then
			arg0_22:emit(ItemInfoMediator.COMPOSE_ITEM, arg0_22.itemVO.id, arg0_22.operateCount)

			local var0_35 = arg0_22.itemVO:getConfig("compose_number")

			if var0_35 > arg0_22.itemVO.count - arg0_22.operateCount * var0_35 then
				triggerButton(arg0_22.operateBtns.Cancel)
			else
				arg0_22:SetOperateCount(1)
			end
		elseif arg0_22.operateMode == var5_0.USE then
			arg0_22:emit(ItemInfoMediator.USE_ITEM, arg0_22.itemVO.id, arg0_22.operateCount)
		end
	end, SFX_CONFIRM)
	onButton(arg0_22, arg0_22.recycleBtn, function()
		local var0_36 = arg0_22.itemVO:GetPrice() or {
			0,
			0
		}
		local var1_36 = i18n("skin_discount_item_recycle_tip", arg0_22.itemVO:getName(), var0_36[2])

		arg0_22.recycleConfirmationPage:ExecuteAction("Show", {
			content = var1_36,
			itemId = arg0_22.itemVO.id
		})
	end, SFX_CONFIRM)
	onButton(arg0_22, arg0_22.skinShopBtn, function()
		arg0_22:closeView()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end, SFX_CONFIRM)
	onButton(arg0_22, arg0_22.skinExperienceShopBtn, function()
		arg0_22:closeView()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP, {
			mode = NewSkinShopScene.MODE_EXPERIENCE_FOR_ITEM
		})
	end, SFX_CONFIRM)
	onButton(arg0_22, arg0_22.operateBtns.Resolve, function()
		arg0_22:emit(ItemInfoMediator.SELL_BLUEPRINT, Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg0_22.itemVO.id,
			count = arg0_22.operateCount
		}))
	end, SFX_CONFIRM)

	local var2_22 = getProxy(PlayerProxy):getData()
	local var3_22 = GetComponent(arg0_22.keepFateTog, typeof(Toggle))

	arg0_22.keepFateState = not var2_22:GetCommonFlag(SHOW_DONT_KEEP_FATE_ITEM)
	var3_22.isOn = arg0_22.keepFateState

	local function var4_22()
		arg0_22:UpdateBlueprintResolveNum()
		arg0_22:SetOperateCount(1)
	end

	onToggle(arg0_22, arg0_22.keepFateTog, function(arg0_41)
		arg0_22.keepFateState = arg0_41

		if arg0_41 then
			pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		else
			pg.m02:sendNotification(GAME.COMMON_FLAG, {
				flagID = SHOW_DONT_KEEP_FATE_ITEM
			})
		end

		var4_22()
	end)
	var4_22()
end

function var0_0.UpdateCount(arg0_42, arg1_42)
	if arg0_42.operateMode == var5_0.COMPOSE then
		local var0_42 = arg0_42.itemVO:getConfig("target_id")

		if not var0_42 or var0_42 <= 0 then
			return false
		end

		arg1_42 = math.clamp(arg1_42, 1, math.floor(arg0_42.itemVO.count / arg0_42.itemVO:getConfig("compose_number")))

		return arg0_42.operateCount ~= arg1_42
	elseif arg0_42.operateMode == var5_0.RESOLVE then
		arg1_42 = math.clamp(arg1_42, 1, arg0_42.itemVO.count)

		return arg0_42.operateCount ~= arg1_42
	elseif arg0_42.operateMode == var5_0.USE then
		arg1_42 = math.clamp(arg1_42, 1, arg0_42.itemVO.count)

		return arg0_42.operateCount ~= arg1_42
	end
end

function var0_0.SetOperateCount(arg0_43, arg1_43)
	if arg0_43.operateMode == var5_0.COMPOSE then
		local var0_43 = arg0_43.itemVO:getConfig("target_id")

		if not var0_43 or var0_43 <= 0 then
			return
		end

		local var1_43 = arg0_43.itemVO:getConfig("compose_number")

		arg1_43 = math.clamp(arg1_43, 1, math.floor(arg0_43.itemVO.count / var1_43))

		if arg0_43.operateCount ~= arg1_43 then
			arg0_43.operateCount = arg1_43

			arg0_43:UpdateComposeCount()
		end

		local var2_43 = arg0_43.itemVO.count - arg0_43.operateCount * var1_43

		arg0_43:updateItemCount(var2_43)
	elseif arg0_43.operateMode == var5_0.RESOLVE then
		arg1_43 = math.clamp(arg1_43, 0, arg0_43.operateMax)

		if arg0_43.operateCount ~= arg1_43 then
			arg0_43.operateCount = arg1_43

			arg0_43:UpdateResolvePanel()
			arg0_43:updateItemCount(arg0_43.itemVO.count - arg0_43.operateCount)
		end
	elseif arg0_43.operateMode == var5_0.USE then
		arg1_43 = math.clamp(arg1_43, 0, math.min(arg0_43.operateMax, var3_0))

		if arg0_43.operateCount ~= arg1_43 then
			arg0_43.operateCount = arg1_43

			arg0_43:UpdateUsePanel()
			arg0_43:updateItemCount(arg0_43.itemVO.count - arg0_43.operateCount)
		end
	end
end

function var0_0.UpdateComposeCount(arg0_44)
	local var0_44 = arg0_44.operateCount

	setText(arg0_44.operateValue, var0_44)
	setInputText(arg0_44.operateValueInput, var0_44)

	local var1_44 = {}

	table.insert(var1_44, {
		type = DROP_TYPE_ITEM,
		id = arg0_44.itemVO:getConfig("target_id"),
		count = var0_44
	})
	UIItemList.StaticAlign(arg0_44.operateBonusList, arg0_44.operateBonusTpl, #var1_44, function(arg0_45, arg1_45, arg2_45)
		arg1_45 = arg1_45 + 1

		if arg0_45 == UIItemList.EventUpdate then
			local var0_45 = var1_44[arg1_45]

			updateDrop(arg2_45:Find("IconTpl"), var0_45)
			onButton(arg0_44, arg2_45:Find("IconTpl"), function()
				arg0_44:emit(var0_0.ON_DROP, var0_45)
			end, SFX_PANEL)
		end
	end)

	for iter0_44, iter1_44 in pairs(arg0_44.operateBtns) do
		setActive(iter1_44, iter0_44 == "Confirm" or iter0_44 == "Cancel")
	end

	setText(arg0_44.operateCountdesc, i18n("compose_amount_prefix"))
	setActive(arg0_44.keepFateTog, false)
end

function var0_0.UpdateResolvePanel(arg0_47)
	local var0_47 = arg0_47.operateCount

	setText(arg0_47.operateValue, var0_47)
	setInputText(arg0_47.operateValueInput, var0_47)

	local var1_47 = arg0_47.itemVO:getConfig("price")
	local var2_47 = {}

	table.insert(var2_47, {
		type = DROP_TYPE_RESOURCE,
		id = var1_47[1],
		count = var1_47[2] * var0_47
	})
	UIItemList.StaticAlign(arg0_47.operateBonusList, arg0_47.operateBonusTpl, #var2_47, function(arg0_48, arg1_48, arg2_48)
		arg1_48 = arg1_48 + 1

		if arg0_48 == UIItemList.EventUpdate then
			local var0_48 = var2_47[arg1_48]

			updateDrop(arg2_48:Find("IconTpl"), var0_48)
			onButton(arg0_47, arg2_48:Find("IconTpl"), function()
				arg0_47:emit(var0_0.ON_DROP, var0_48)
			end, SFX_PANEL)
		end
	end)

	for iter0_47, iter1_47 in pairs(arg0_47.operateBtns) do
		setActive(iter1_47, iter0_47 == "Resolve" or iter0_47 == "Cancel")
	end

	setText(arg0_47.operateCountdesc, i18n("resolve_amount_prefix"))

	if arg0_47.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		setActive(arg0_47.keepFateTog, false)
	else
		setActive(arg0_47.keepFateTog, true)
	end

	setButtonEnabled(arg0_47.operateBtns.Resolve, var0_47 > 0)
end

function var0_0.UpdateBlueprintResolveNum(arg0_50)
	local var0_50 = arg0_50.itemVO.count

	if arg0_50.itemVO:getConfig("type") == Item.BLUEPRINT_TYPE then
		local var1_50 = getProxy(TechnologyProxy)
		local var2_50 = var1_50:GetBlueprint4Item(arg0_50.itemVO.id)
		local var3_50 = var1_50:getBluePrintById(var2_50)

		if arg0_50.keepFateState then
			var0_50 = arg0_50.itemVO.count - var3_50:getFateMaxLeftOver()
			var0_50 = var0_50 < 0 and 0 or var0_50
		end
	end

	arg0_50.operateMax = var0_50
end

function var0_0.UpdateSpeedUpResolveNum(arg0_51)
	local var0_51 = arg0_51.itemVO.count

	if arg0_51.itemVO:getConfig("type") == Item.TEC_SPEEDUP_TYPE then
		arg0_51.operateMax = var0_51
	end
end

function var0_0.UpdateUsePanel(arg0_52)
	local var0_52 = arg0_52.operateCount

	setText(arg0_52.operateValue, var0_52)
	setInputText(arg0_52.operateValueInput, var0_52)

	local var1_52 = {}

	table.insert(var1_52, {
		type = DROP_TYPE_ITEM,
		id = var4_0,
		count = var0_52
	})
	UIItemList.StaticAlign(arg0_52.operateBonusList, arg0_52.operateBonusTpl, #var1_52, function(arg0_53, arg1_53, arg2_53)
		arg1_53 = arg1_53 + 1

		if arg0_53 == UIItemList.EventUpdate then
			local var0_53 = var1_52[arg1_53]

			updateDrop(arg2_53:Find("IconTpl"), var0_53)
		end
	end)

	for iter0_52, iter1_52 in pairs(arg0_52.operateBtns) do
		setActive(iter1_52, iter0_52 == "Confirm" or iter0_52 == "Cancel")
	end

	setText(arg0_52.operateCountdesc, i18n("use_amount_prefix"))
	setActive(arg0_52.keepFateTog, false)
end

function var0_0.willExit(arg0_54)
	if arg0_54.leftEventTrigger then
		ClearEventTrigger(arg0_54.leftEventTrigger)
	end

	if arg0_54.rightEventTrigger then
		ClearEventTrigger(arg0_54.rightEventTrigger)
	end

	arg0_54:UnOverlayPanel(arg0_54._tf)

	if arg0_54.recycleConfirmationPage then
		arg0_54.recycleConfirmationPage:Destroy()

		arg0_54.recycleConfirmationPage = nil
	end
end

function var0_0.PlayOpenBox(arg0_55, arg1_55, arg2_55)
	if not arg1_55 or arg1_55 == "" then
		arg2_55()

		return
	end

	local var0_55 = {}
	local var1_55 = arg0_55:findTF(arg1_55 .. "(Clone)")

	if var1_55 then
		arg0_55[arg1_55] = go(var1_55)
	end

	if not arg0_55[arg1_55] then
		table.insert(var0_55, function(arg0_56)
			PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(arg1_55), "", true, function(arg0_57)
				arg0_57:SetActive(true)

				arg0_55[arg1_55] = arg0_57

				arg0_56()
			end)
		end)
	end

	seriesAsync(var0_55, function()
		if arg0_55.playing or not arg0_55[arg1_55] then
			return
		end

		arg0_55.playing = true

		arg0_55[arg1_55]:SetActive(true)
		SetActive(arg0_55.window, false)

		local var0_58 = tf(arg0_55[arg1_55])

		var0_58:SetParent(arg0_55._tf, false)
		var0_58:SetAsLastSibling()

		local var1_58 = var0_58:GetComponent("DftAniEvent")

		var1_58:SetTriggerEvent(function(arg0_59)
			arg2_55()
		end)
		var1_58:SetEndEvent(function(arg0_60)
			if arg0_55[arg1_55] then
				SetActive(arg0_55[arg1_55], false)

				arg0_55.playing = false
			end

			arg0_55:closeView()
		end)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_EQUIPMENT_OPEN)
	end)
end

function var0_0.inOutAnim(arg0_61, arg1_61, arg2_61)
	if arg1_61 then
		local var0_61 = arg0_61:findTF("window/bg_decorations"):GetComponent(typeof(Animation))

		var0_61:Stop()
		var0_61:Play("anim_window_bg")

		local var1_61 = arg0_61:findTF("window/top"):GetComponent(typeof(Animation))

		var1_61:Stop()
		var1_61:Play("anim_top")

		local var2_61 = arg0_61:findTF("window"):GetComponent(typeof(Animation))

		var2_61:Stop()
		var2_61:Play("anim_content")

		local var3_61 = arg0_61:findTF("bg"):GetComponent(typeof(Animation))

		var3_61:Stop()
		var3_61:Play("anim_bg_plus")
	end

	arg2_61()
end

return var0_0
