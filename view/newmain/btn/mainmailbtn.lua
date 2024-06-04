local var0 = class("MainMailBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.OPEN_MAIL)
end

return var0
