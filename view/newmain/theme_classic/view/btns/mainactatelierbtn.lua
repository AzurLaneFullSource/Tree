local var0_0 = class("MainActAtelierBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_Atelier"
end

function var0_0.OnInit(arg0_2)
	setActive(arg0_2.tipTr.gameObject, false)
end

return var0_0
