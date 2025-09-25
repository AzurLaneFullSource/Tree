local var0_0 = class("CoreActivityMainMediator", import("view.activity.ActivityMediator"))

function var0_0.getDisplayActivity(arg0_1)
	return getProxy(ActivityProxy):getCorePanelActivities(arg0_1.contextData.coreName)
end

return var0_0
