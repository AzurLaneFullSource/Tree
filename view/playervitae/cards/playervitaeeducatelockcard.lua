local var0_0 = class("PlayerVitaeEducateLockCard", import(".PlayerVitaeEducateBaseCard"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	setText(arg1_1:Find("desc/Text"), i18n("flagship_educate_slot_lock_tip"))
	onButton(arg0_1, arg1_1:Find("go"), function()
		if LOCK_NEW_EDUCATE_SYSTEM then
			arg0_1:emit(PlayerVitaeMediator.GO_SCENE, SCENE.EDUCATE)
		else
			arg0_1:emit(PlayerVitaeMediator.GO_SCENE, SCENE.NEW_EDUCATE_SELECT)
		end
	end, SFX_PANEL)
end

return var0_0
