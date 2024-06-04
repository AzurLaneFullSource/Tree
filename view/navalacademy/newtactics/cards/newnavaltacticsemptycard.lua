local var0 = class("NewNavalTacticsEmptyCard", import(".NewNavalTacticsBaseCard"))

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(NewNavalTacticsLayer.ON_ADD_STUDENT, arg0.index)
	end, SFX_PANEL)
end

return var0
