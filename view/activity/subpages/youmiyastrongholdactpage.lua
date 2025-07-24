local var0_0 = class("YoumiyaStrongholdActPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = arg0_1._tf:Find("panel/go_btn")

	onButton(arg0_1, var0_1, function()
		arg0_1:emit(ActivityMediator.OPEN_LAYER, Context.New({
			mediator = YoumiyaStrongholdMediator,
			viewComponent = YoumiyaStrongholdLayer
		}))
	end, SFX_PANEL)
	setActive(arg0_1._tf:Find("panel/go_btn/tip"), YoumiyaStrongholdLayer.ShouldShowTip())

	for iter0_1 = 1, 3 do
		setText(arg0_1._tf:Find("bg/" .. tostring(iter0_1) .. "/name"), i18n("yumia_base_name_" .. iter0_1))
	end

	setText(arg0_1._tf:Find("panel/go_btn/text"), i18n("yumia_stronghold_1"))
end

return var0_0
