local var0_0 = class("MainActLayerBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_layer"
end

function var0_0.OnInit(arg0_2)
	local var0_2 = arg0_2:GetActivityID()
	local var1_2 = getProxy(ActivityProxy):getActivityById(var0_2)
	local var2_2 = Activity.IsActivityReady(var1_2)

	setActive(arg0_2.tipTr.gameObject, var2_2)
end

function var0_0.GetActivityID(arg0_3)
	local var0_3 = checkExist(arg0_3.config, {
		"time"
	})

	if not var0_3 then
		return nil
	end

	return var0_3[1] == "default" and var0_3[2] or nil
end

return var0_0
