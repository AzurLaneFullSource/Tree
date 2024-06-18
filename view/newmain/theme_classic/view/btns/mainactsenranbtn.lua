local var0_0 = class("MainActSenranBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_senran"
end

function var0_0.GetActivityID(arg0_2)
	local var0_2 = checkExist(arg0_2.config, {
		"time"
	})

	if not var0_2 then
		return nil
	end

	return var0_2[1] == "default" and var0_2[2] or nil
end

function var0_0.OnInit(arg0_3)
	local var0_3 = arg0_3:GetActivityID()
	local var1_3 = getProxy(ActivityProxy):getActivityById(var0_3)
	local var2_3 = Activity.IsActivityReady(var1_3)

	setActive(arg0_3.tipTr.gameObject, var2_3)
end

return var0_0
