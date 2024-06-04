local var0 = class("MainActMedalCollectionBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_medal"
end

function var0.GetActivityID(arg0)
	local var0 = checkExist(arg0.config, {
		"time"
	})

	if not var0 then
		return nil
	end

	return var0[1] == "default" and var0[2] or nil
end

function var0.OnInit(arg0)
	local var0 = arg0:GetActivityID()
	local var1 = getProxy(ActivityProxy):getActivityById(var0)
	local var2 = Activity.IsActivityReady(var1)

	setActive(arg0.tipTr.gameObject, var2)
end

function var0.CustomOnClick(arg0)
	errorMsg("Set activity_link_button param using View's name")
end

return var0
