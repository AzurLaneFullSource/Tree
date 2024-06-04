local var0 = class("PlayerVitaeAddCard", import(".PlayerVitaeBaseCard"))

function var0.OnInit(arg0)
	arg0.line1 = arg0._tf:Find("line1")
	arg0.line2 = arg0._tf:Find("line2")
	arg0.txt = arg0._tf:Find("Text")

	onButton(arg0, arg0._tf, function()
		if arg0.inEdit then
			return
		end

		if not arg0.canCilick then
			return
		end

		arg0:emit(PlayerVitaeMediator.CHANGE_PAINT, nil)
	end, SFX_PANEL)
end

function var0.OnUpdate(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg4 == PlayerVitaeShipsPage.RANDOM_FLAG_SHIP_PAGE

	arg0.canCilick = not var0

	setActive(arg0.line1, not var0)
	setActive(arg0.line2, not var0)
	setActive(arg0.txt, not var0)
end

function var0.EditCard(arg0, arg1)
	arg0.inEdit = arg1

	setActive(arg0.mask, arg1)
end

function var0.Disable(arg0)
	var0.super.Disable(arg0)
	arg0:EditCard(false)
end

function var0.OnDispose(arg0)
	arg0:Disable()
end

return var0
