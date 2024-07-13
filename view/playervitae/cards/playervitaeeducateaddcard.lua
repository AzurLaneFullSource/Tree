local var0_0 = class("PlayerVitaeEducateAddCard", import(".PlayerVitaeEducateBaseCard"))

function var0_0.Flush(arg0_1)
	onButton(arg0_1, arg0_1._tf, function()
		arg0_1:emit(PlayerVitaeMediator.ON_SEL_EDUCATE_CHAR)
	end, SFX_PANEL)
end

function var0_0.Clear(arg0_3)
	removeOnButton(arg0_3._tf)
end

return var0_0
