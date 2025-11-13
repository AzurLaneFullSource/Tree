local var0_0 = class("PSSSkinMagazinePage", import("view.activity.CorePage.CorSkinMagazineTemplatePage"))

var0_0.EXPAND_WIDTH = 975
var0_0.CLOSE_WIDTH = 225
var0_0.DURATION_PARAMETER = 2500

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.super.OnFirstFlush(arg0_1)
	setText(arg0_1._tf:Find("AD/Text"), i18n("black5_bundle_desc"))
	setText(arg0_1._tf:Find("AD/btn/name"), i18n("black5_bundle_button"))
	onButton(arg0_1, arg0_1._tf:Find("AD/btn"), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_GIFT
		})
	end, SFX_PANEL)

	if not arg0_1.activity:GetConfigClientSetting("packageID") then
		return false
	end

	local var0_1 = Goods.Create({
		shop_id = arg0_1.activity:GetConfigClientSetting("packageID")
	}, Goods.TYPE_GIFT_PACKAGE_ACT)

	SetActive(arg0_1._tf:Find("AD/btn/red"), var0_1:isTip())
	SetActive(arg0_1._tf:Find("AD/btn"), var0_1:getBuyCount() ~= 1)
	SetActive(arg0_1._tf:Find("AD/Text"), var0_1:getBuyCount() ~= 1)
	SetActive(arg0_1._tf:Find("AD/Image"), var0_1:getBuyCount() ~= 1)
end

return var0_0
