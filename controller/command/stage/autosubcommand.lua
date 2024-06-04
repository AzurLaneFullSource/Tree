local var0 = class("AutoSubCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.isActiveSub
	local var2 = var0.toggle
	local var3 = var0.system
	local var4 = var0.GetAutoSubMark(var3)

	PlayerPrefs.SetInt("autoSubIsAcitve" .. var4, not var1 and 1 or 0)
end

function var0.GetAutoSubMark(arg0)
	if arg0 == SYSTEM_WORLD then
		return "_" .. arg0
	elseif arg0 == SYSTEM_GUILD then
		return "_" .. SYSTEM_GUILD
	else
		return ""
	end
end

return var0
