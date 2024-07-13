local var0_0 = class("PlayerVitaeAddCard", import(".PlayerVitaeBaseCard"))

function var0_0.OnInit(arg0_1)
	arg0_1.line1 = arg0_1._tf:Find("line1")
	arg0_1.line2 = arg0_1._tf:Find("line2")
	arg0_1.txt = arg0_1._tf:Find("Text")

	onButton(arg0_1, arg0_1._tf, function()
		if arg0_1.inEdit then
			return
		end

		if not arg0_1.canCilick then
			return
		end

		arg0_1:emit(PlayerVitaeMediator.CHANGE_PAINT, nil)
	end, SFX_PANEL)
end

function var0_0.OnUpdate(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = arg4_3 == PlayerVitaeShipsPage.RANDOM_FLAG_SHIP_PAGE

	arg0_3.canCilick = not var0_3

	setActive(arg0_3.line1, not var0_3)
	setActive(arg0_3.line2, not var0_3)
	setActive(arg0_3.txt, not var0_3)
end

function var0_0.EditCard(arg0_4, arg1_4)
	arg0_4.inEdit = arg1_4

	setActive(arg0_4.mask, arg1_4)
end

function var0_0.Disable(arg0_5)
	var0_0.super.Disable(arg0_5)
	arg0_5:EditCard(false)
end

function var0_0.OnDispose(arg0_6)
	arg0_6:Disable()
end

return var0_0
