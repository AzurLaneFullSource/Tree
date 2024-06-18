local var0_0 = class("MarseillaiseSpPage", import(".TemplatePage.SpTemplatePage"))
local var1_0 = Vector2(225, -270)
local var2_0 = Vector2(515, -270)

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)

	local var0_1 = arg0_1.activity:getConfig("config_client").linkPoolActID

	if not var0_1 then
		pg.TipsMgr.GetInstance():ShowTips("未配置linkPoolActID！！！")
	else
		local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1)
		local var2_1 = var1_0

		if var1_1 and not var1_1:isEnd() then
			var2_1 = var1_0
		else
			var2_1 = var2_0
		end

		setLocalPosition(arg0_1.getBtn, var2_1)
		setLocalPosition(arg0_1.gotBtn, var2_1)
		setLocalPosition(arg0_1.battleBtn, var2_1)
	end
end

return var0_0
