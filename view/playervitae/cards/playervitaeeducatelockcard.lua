local var0 = class("PlayerVitaeEducateLockCard", import(".PlayerVitaeEducateBaseCard"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)
	setText(arg1:Find("desc/Text"), i18n("flagship_educate_slot_lock_tip"))
	onButton(arg0, arg1:Find("go"), function()
		arg0:emit(PlayerVitaeMediator.GO_SCENE, SCENE.EDUCATE)
	end, SFX_PANEL)
end

return var0
