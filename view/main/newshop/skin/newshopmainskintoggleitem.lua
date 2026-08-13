local var0_0 = class("NewShopMainSkinToggleItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onToggle(arg0_2, arg0_2.uiToggle, function(arg0_3)
		if arg0_3 then
			arg0_2:emit(NewShopMainScene.ON_CLICK_SKIN_SHOP, arg0_2.skinShopID)
		end
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_4, arg1_4)
	arg0_4.skinShopID = arg1_4

	local var0_4 = pg.shop_skin_subsheet[arg1_4]

	setText(arg0_4.uiNameText, var0_4.site_tag_text)
	setText(arg0_4.uiNameText2, var0_4.site_tag_text)
end

function var0_0.TriggerToggle(arg0_5)
	triggerToggle(arg0_5.uiToggle, true)
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
	Object.Destroy(arg0_6._go)

	arg0_6._tf = nil
	arg0_6._go = nil
end

return var0_0
