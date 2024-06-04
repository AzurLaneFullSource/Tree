local var0 = class("BackYardEmptyCard", import(".BackYardBaseCard"))

function var0.OnInit(arg0)
	onButton(arg0, arg0._content, function()
		arg0:emit(NewBackYardShipInfoMediator.OPEN_CHUANWU, arg0.type)
	end, SFX_PANEL)
end

return var0
