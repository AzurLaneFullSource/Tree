local var0_0 = class("URExchangeActivity", import("model.vo.Activity"))

function var0_0.GetConfigClientURPTDrop(arg0_1)
	if arg0_1:isEnd() then
		return nil
	end

	if arg0_1:GetConfigClientSetting("PT_ACT_UR") then
		local var0_1 = getProxy(ActivityProxy):getActivityById(arg0_1:GetConfigClientSetting("PT_ACT_UR"))

		return var0_1 and var0_1:GetPTDrop() or nil
	elseif arg0_1:GetConfigClientSetting("uPtId") then
		return Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = arg0_1:GetConfigClientSetting("uPtId")
		})
	end

	return nil
end

function var0_0.GetConfigClientURPTActivity(arg0_2)
	if arg0_2:isEnd() then
		return nil
	end

	if arg0_2:GetConfigClientSetting("PT_ACT_UR") then
		return getProxy(ActivityProxy):getActivityById(arg0_2:GetConfigClientSetting("PT_ACT_UR"))
	else
		local var0_2 = arg0_2:GetConfigClientURPTDrop()

		return var0_2 and getProxy(ActivityProxy):GetPTActivityByRes(var0_2) or nil
	end
end

return var0_0
