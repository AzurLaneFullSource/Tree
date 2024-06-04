local var0 = class("MarseillaiseSpPage", import(".TemplatePage.SpTemplatePage"))
local var1 = Vector2(225, -270)
local var2 = Vector2(515, -270)

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	local var0 = arg0.activity:getConfig("config_client").linkPoolActID

	if not var0 then
		pg.TipsMgr.GetInstance():ShowTips("未配置linkPoolActID！！！")
	else
		local var1 = getProxy(ActivityProxy):getActivityById(var0)
		local var2 = var1

		if var1 and not var1:isEnd() then
			var2 = var1
		else
			var2 = var2
		end

		setLocalPosition(arg0.getBtn, var2)
		setLocalPosition(arg0.gotBtn, var2)
		setLocalPosition(arg0.battleBtn, var2)
	end
end

return var0
