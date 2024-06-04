local var0 = class("MainActAtelierBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_Atelier"
end

function var0.OnInit(arg0)
	setActive(arg0.tipTr.gameObject, false)
end

return var0
