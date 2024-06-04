local var0 = class("BackyardFeedExtendPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "BackYardFeedExtendPanel"
end

function var0.OnLoaded(arg0)
	arg0.icon = arg0._tf:Find("frame/tip/icon"):GetComponent(typeof(Image))
	arg0.consume = arg0._tf:Find("frame/tip/Text"):GetComponent(typeof(Text))
	arg0.desc = arg0._tf:Find("frame/desc"):GetComponent(typeof(Text))
	arg0.addBtn = arg0._tf:Find("frame/confirm")
	arg0.cancelBtn = arg0._tf:Find("frame/cancel")
	arg0.closeBtn = arg0._tf:Find("frame/close")
	arg0._parentTF = arg0._tf.parent

	setText(arg0.cancelBtn:Find("Text"), i18n("word_cancel"))
	setText(arg0.addBtn:Find("Text"), i18n("word_ok"))
	setText(arg0._tf:Find("frame/tip"), i18n("backyard_food_shop_tip"))
	setText(arg0._tf:Find("frame/title"), i18n("words_information"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)

	local var0 = pg.shop_template[arg1]
	local var1 = var0.resource_type
	local var2 = var0.resource_num

	LoadSpriteAtlasAsync("props/" .. id2res(var1), "", function(arg0)
		arg0.icon.sprite = arg0
		tf(arg0.icon.gameObject).sizeDelta = Vector2(50, 50)
	end)

	arg0.consume.text = var2
	arg0.desc.text = i18n("backyard_backyardGranaryLayer_foodMaxIncreaseNotice", arg2, arg2 + var0.num)

	onButton(arg0, arg0.addBtn, function()
		arg0:Extend({
			resType = var1,
			resCount = var2,
			shopId = arg1
		})
	end, SFX_CONFIRM)
end

function var0.Extend(arg0, arg1)
	if getProxy(PlayerProxy):getRawData()[id2res(arg1.resType)] < arg1.resCount then
		if arg1.resType == 4 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_error_entendFail"))
		end
	else
		arg0:emit(BackyardFeedMediator.EXTEND, arg1.shopId, 1)
	end

	arg0:Hide()
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
