local var0_0 = class("ChargeTipWindow", import("view.base.BaseSubView"))

var0_0.TYPE_MONTH_CARD = "MonthCard"
var0_0.TYPE_GIFTPACKAGE = "GiftPackage"
var0_0.TYPE_CURSING = "Crusing"

function var0_0.getUIName(arg0_1)
	return "ChargeTipUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.container = arg0_2:findTF("frame/window")
	arg0_2.closeBtn = arg0_2:findTF("frame/top/btnBack")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm")

	setText(arg0_2:findTF("frame/top/title"), i18n("words_information"))
	setText(arg0_2.confirmBtn:Find("Text"), i18n("msgbox_text_confirm"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.window = {}
end

local function var1_0(arg0_4)
	local var0_4 = arg0_4:getConfig("extra_service")

	if var0_4 == Goods.MONTH_CARD then
		return var0_0.TYPE_MONTH_CARD
	elseif var0_4 == Goods.ITEM_BOX then
		return var0_0.TYPE_GIFTPACKAGE
	elseif var0_4 == Goods.PASS_ITEM then
		return var0_0.TYPE_CURSING
	end
end

function var0_0.Show(arg0_5, arg1_5)
	assert(arg1_5:isChargeType())
	var0_0.super.Show(arg0_5)

	arg0_5.chargeCommodity = arg1_5

	local var0_5 = var1_0(arg1_5)

	if not var0_5 then
		arg0_5:Hide()

		return
	end

	seriesAsync({
		function(arg0_6)
			arg0_5:LoadWindow(var0_5, arg0_6)
		end,
		function(arg0_7)
			arg0_5:UpdateWindow(var0_5, arg0_7)
		end
	}, function()
		arg0_5:RegisterEvent()
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.LoadWindow(arg0_9, arg1_9, arg2_9)
	if arg0_9.window[arg1_9] then
		arg2_9()

		return
	end

	ResourceMgr.Inst:getAssetAsync("ui/" .. arg1_9 .. "TipWindow", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_10)
		arg0_9.window[arg1_9] = Object.Instantiate(arg0_10, arg0_9.container).transform

		arg2_9()
	end), true, true)
end

function var0_0.UpdateWindow(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.window[arg1_11]

	setActive(var0_11, true)

	local var1_11 = arg0_11["Update" .. arg1_11]

	if var1_11 then
		var1_11(arg0_11, var0_11)
	end

	arg2_11()
end

local function var2_0(arg0_12, arg1_12)
	local var0_12 = UIItemList.New(arg0_12:Find("awards"), arg0_12:Find("awards/award"))

	var0_12:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg1_12[arg1_13 + 1]
			local var1_13 = {
				type = var0_13[1],
				id = var0_13[2],
				count = var0_13[3]
			}

			updateDrop(arg2_13, var1_13)
		end
	end)
	var0_12:align(#arg1_12)
end

function var0_0.UpdateMonthCard(arg0_14, arg1_14)
	setText(arg1_14:Find("title/label/txt"), i18n("chargetip_monthcard_1"))

	local var0_14 = arg0_14.chargeCommodity:getConfig("gem") + arg0_14.chargeCommodity:getConfig("extra_gem")

	setText(arg1_14:Find("title/Text"), "X" .. var0_14)
	setText(arg1_14:Find("sub_title"), i18n("chargetip_monthcard_2"))

	local var1_14 = arg0_14.chargeCommodity:getConfig("display")

	var2_0(arg1_14, var1_14)
	setAnchoredPosition(arg0_14.confirmBtn, {
		y = -540
	})
end

function var0_0.UpdateGiftPackage(arg0_15, arg1_15)
	setText(arg1_15:Find("title"), i18n("chargetip_giftpackage"))

	local var0_15 = arg0_15.chargeCommodity:GetDropItem()
	local var1_15 = UIItemList.New(arg1_15:Find("list/content"), arg1_15:Find("list/content/award"))

	var1_15:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16 + 1]
			local var1_16 = {
				type = var0_16[1],
				id = var0_16[2],
				count = var0_16[3]
			}

			updateDrop(arg2_16, var1_16)
		end
	end)
	var1_15:align(#var0_15)
	setActive(arg1_15:Find("icon"), false)
	setAnchoredPosition(arg0_15.confirmBtn, {
		y = -550
	})
end

function var0_0.UpdateCrusing(arg0_17, arg1_17)
	setText(arg1_17:Find("title"), i18n("chargetip_crusing"))
	setText(arg1_17:Find("sub_title"), i18n("charge_tip_crusing_label"))

	local var0_17 = arg0_17.chargeCommodity:getConfig("display")

	var2_0(arg1_17, var0_17)
	setAnchoredPosition(arg0_17.confirmBtn, {
		y = -550
	})
end

function var0_0.RegisterEvent(arg0_18)
	onButton(arg0_18, arg0_18._tf, function()
		arg0_18:Hide()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.closeBtn, function()
		arg0_18:Hide()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.confirmBtn, function()
		arg0_18:Hide()
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_22)
	var0_0.super.Hide(arg0_22)
	removeOnButton(arg0_22._tf)
	removeOnButton(arg0_22.closeBtn)
	removeOnButton(arg0_22.confirmBtn)

	for iter0_22, iter1_22 in pairs(arg0_22.window) do
		if not IsNil(iter1_22) then
			setActive(iter1_22, false)
		end
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_22._tf, arg0_22._parentTf)
end

function var0_0.OnDestroy(arg0_23)
	if arg0_23:isShowing() then
		arg0_23:Hide()
	end

	for iter0_23, iter1_23 in pairs(arg0_23.window) do
		if not IsNil(iter1_23) then
			Object.Destroy(iter1_23.gameObject)
		end
	end

	arg0_23.window = {}
end

return var0_0
