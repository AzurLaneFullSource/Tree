local var0_0 = class("MainMailBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	arg0_1:emit(NewMainMediator.OPEN_MAIL)
end

return var0_0
