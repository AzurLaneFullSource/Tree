local var0_0 = class("NewNavalTacticsEmptyCard", import(".NewNavalTacticsBaseCard"))

function var0_0.OnInit(arg0_1)
	onButton(arg0_1, arg0_1._tf, function()
		arg0_1:emit(NewNavalTacticsLayer.ON_ADD_STUDENT, arg0_1.index)
	end, SFX_PANEL)
end

return var0_0
