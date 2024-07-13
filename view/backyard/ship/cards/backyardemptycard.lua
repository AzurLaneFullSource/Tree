local var0_0 = class("BackYardEmptyCard", import(".BackYardBaseCard"))

function var0_0.OnInit(arg0_1)
	onButton(arg0_1, arg0_1._content, function()
		arg0_1:emit(NewBackYardShipInfoMediator.OPEN_CHUANWU, arg0_1.type)
	end, SFX_PANEL)
end

return var0_0
