local var0_0 = class("AutoSubCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.isActiveSub
	local var2_1 = var0_1.toggle
	local var3_1 = var0_1.system
	local var4_1 = var0_0.GetAutoSubMark(var3_1)

	PlayerPrefs.SetInt("autoSubIsAcitve" .. var4_1, not var1_1 and 1 or 0)
end

function var0_0.GetAutoSubMark(arg0_2)
	if arg0_2 == SYSTEM_WORLD then
		return "_" .. arg0_2
	elseif arg0_2 == SYSTEM_GUILD then
		return "_" .. SYSTEM_GUILD
	else
		return ""
	end
end

return var0_0
