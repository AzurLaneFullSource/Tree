local var0 = class("PlayerVitaeEducateAddCard", import(".PlayerVitaeEducateBaseCard"))

function var0.Flush(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(PlayerVitaeMediator.ON_SEL_EDUCATE_CHAR)
	end, SFX_PANEL)
end

function var0.Clear(arg0)
	removeOnButton(arg0._tf)
end

return var0
