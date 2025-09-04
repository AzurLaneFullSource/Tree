local var0_0 = class("NcShowHud", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	local var0_1 = arg0_1:GetAgent().gameObject:GetComponent(typeof(WorldObjectItem))
	local var1_1 = arg0_1:GetAgent().transform
	local var2_1 = var0_1.id
	local var3_1 = var0_1.type
	local var4_1 = arg0_1:GetBoolArg("show")
	local var5_1 = arg0_1:GetStringArg("viewLuaName")

	if var4_1 then
		local var6_1 = arg0_1:GetStringArg("uiLuaName")
		local var7_1 = arg0_1:GetStringArg("positionX")
		local var8_1 = arg0_1:GetStringArg("positionY")
		local var9_1 = arg0_1:GetStringArg("param1")
		local var10_1 = arg0_1:GetStringArg("param2")
		local var11_1 = arg0_1:GetStringArg("param3")

		arg0_1:SendEvent(ISLAND_EVT.SHOW_HUD, {
			id = tonumber(var2_1),
			type = tonumber(var3_1),
			unitTransform = var1_1,
			viewLuaName = var5_1,
			uiLuaName = var6_1,
			positionX = tonumber(var7_1),
			positionY = tonumber(var8_1),
			param1 = var9_1,
			param2 = var10_1,
			param3 = var11_1
		})
	else
		arg0_1:SendEvent(ISLAND_EVT.HIDE_HUD, {
			id = tonumber(var2_1),
			type = tonumber(var3_1),
			viewLuaName = var5_1
		})
	end

	arg0_1:EndAction()
end

return var0_0
