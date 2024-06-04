local var0 = class("ChargeTipWindow", import("view.base.BaseSubView"))

var0.TYPE_MONTH_CARD = "MonthCard"
var0.TYPE_GIFTPACKAGE = "GiftPackage"
var0.TYPE_CURSING = "Crusing"

function var0.getUIName(arg0)
	return "ChargeTipUI"
end

function var0.OnLoaded(arg0)
	arg0.container = arg0:findTF("frame/window")
	arg0.closeBtn = arg0:findTF("frame/top/btnBack")
	arg0.confirmBtn = arg0:findTF("frame/confirm")

	setText(arg0:findTF("frame/top/title"), i18n("words_information"))
	setText(arg0.confirmBtn:Find("Text"), i18n("msgbox_text_confirm"))
end

function var0.OnInit(arg0)
	arg0.window = {}
end

local function var1(arg0)
	local var0 = arg0:getConfig("extra_service")

	if var0 == Goods.MONTH_CARD then
		return var0.TYPE_MONTH_CARD
	elseif var0 == Goods.ITEM_BOX then
		return var0.TYPE_GIFTPACKAGE
	elseif var0 == Goods.PASS_ITEM then
		return var0.TYPE_CURSING
	end
end

function var0.Show(arg0, arg1)
	assert(arg1:isChargeType())
	var0.super.Show(arg0)

	arg0.chargeCommodity = arg1

	local var0 = var1(arg1)

	if not var0 then
		arg0:Hide()

		return
	end

	seriesAsync({
		function(arg0)
			arg0:LoadWindow(var0, arg0)
		end,
		function(arg0)
			arg0:UpdateWindow(var0, arg0)
		end
	}, function()
		arg0:RegisterEvent()
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.LoadWindow(arg0, arg1, arg2)
	if arg0.window[arg1] then
		arg2()

		return
	end

	ResourceMgr.Inst:getAssetAsync("ui/" .. arg1 .. "TipWindow", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		arg0.window[arg1] = Object.Instantiate(arg0, arg0.container).transform

		arg2()
	end), true, true)
end

function var0.UpdateWindow(arg0, arg1, arg2)
	local var0 = arg0.window[arg1]

	setActive(var0, true)

	local var1 = arg0["Update" .. arg1]

	if var1 then
		var1(arg0, var0)
	end

	arg2()
end

local function var2(arg0, arg1)
	local var0 = UIItemList.New(arg0:Find("awards"), arg0:Find("awards/award"))

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
		end
	end)
	var0:align(#arg1)
end

function var0.UpdateMonthCard(arg0, arg1)
	setText(arg1:Find("title/label/txt"), i18n("chargetip_monthcard_1"))

	local var0 = arg0.chargeCommodity:getConfig("gem") + arg0.chargeCommodity:getConfig("extra_gem")

	setText(arg1:Find("title/Text"), "X" .. var0)
	setText(arg1:Find("sub_title"), i18n("chargetip_monthcard_2"))

	local var1 = arg0.chargeCommodity:getConfig("display")

	var2(arg1, var1)
	setAnchoredPosition(arg0.confirmBtn, {
		y = -540
	})
end

function var0.UpdateGiftPackage(arg0, arg1)
	setText(arg1:Find("title"), i18n("chargetip_giftpackage"))

	local var0 = arg0.chargeCommodity:GetDropItem()
	local var1 = UIItemList.New(arg1:Find("list/content"), arg1:Find("list/content/award"))

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
		end
	end)
	var1:align(#var0)
	setActive(arg1:Find("icon"), false)
	setAnchoredPosition(arg0.confirmBtn, {
		y = -550
	})
end

function var0.UpdateCrusing(arg0, arg1)
	setText(arg1:Find("title"), i18n("chargetip_crusing"))
	setText(arg1:Find("sub_title"), i18n("charge_tip_crusing_label"))

	local var0 = arg0.chargeCommodity:getConfig("display")

	var2(arg1, var0)
	setAnchoredPosition(arg0.confirmBtn, {
		y = -550
	})
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	removeOnButton(arg0._tf)
	removeOnButton(arg0.closeBtn)
	removeOnButton(arg0.confirmBtn)

	for iter0, iter1 in pairs(arg0.window) do
		if not IsNil(iter1) then
			setActive(iter1, false)
		end
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end

	for iter0, iter1 in pairs(arg0.window) do
		if not IsNil(iter1) then
			Object.Destroy(iter1.gameObject)
		end
	end

	arg0.window = {}
end

return var0
