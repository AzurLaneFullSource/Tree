local var0_0 = class("BackyardFeedExtendPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BackYardFeedExtendPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.icon = arg0_2._tf:Find("frame/tip/icon"):GetComponent(typeof(Image))
	arg0_2.consume = arg0_2._tf:Find("frame/tip/Text"):GetComponent(typeof(Text))
	arg0_2.desc = arg0_2._tf:Find("frame/desc"):GetComponent(typeof(Text))
	arg0_2.addBtn = arg0_2._tf:Find("frame/confirm")
	arg0_2.cancelBtn = arg0_2._tf:Find("frame/cancel")
	arg0_2.closeBtn = arg0_2._tf:Find("frame/close")
	arg0_2._parentTF = arg0_2._tf.parent

	setText(arg0_2.cancelBtn:Find("Text"), i18n("word_cancel"))
	setText(arg0_2.addBtn:Find("Text"), i18n("word_ok"))
	setText(arg0_2._tf:Find("frame/tip"), i18n("backyard_food_shop_tip"))
	setText(arg0_2._tf:Find("frame/title"), i18n("words_information"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7, arg2_7)
	var0_0.super.Show(arg0_7)

	local var0_7 = pg.shop_template[arg1_7]
	local var1_7 = var0_7.resource_type
	local var2_7 = var0_7.resource_num

	LoadSpriteAtlasAsync("props/" .. id2res(var1_7), "", function(arg0_8)
		arg0_7.icon.sprite = arg0_8
		tf(arg0_7.icon.gameObject).sizeDelta = Vector2(50, 50)
	end)

	arg0_7.consume.text = var2_7
	arg0_7.desc.text = i18n("backyard_backyardGranaryLayer_foodMaxIncreaseNotice", arg2_7, arg2_7 + var0_7.num)

	onButton(arg0_7, arg0_7.addBtn, function()
		arg0_7:Extend({
			resType = var1_7,
			resCount = var2_7,
			shopId = arg1_7
		})
	end, SFX_CONFIRM)
end

function var0_0.Extend(arg0_10, arg1_10)
	if getProxy(PlayerProxy):getRawData()[id2res(arg1_10.resType)] < arg1_10.resCount then
		if arg1_10.resType == 4 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_error_entendFail"))
		end
	else
		arg0_10:emit(BackyardFeedMediator.EXTEND, arg1_10.shopId, 1)
	end

	arg0_10:Hide()
end

function var0_0.Hide(arg0_11)
	var0_0.super.Hide(arg0_11)
end

function var0_0.OnDestroy(arg0_12)
	arg0_12:Hide()
end

return var0_0
