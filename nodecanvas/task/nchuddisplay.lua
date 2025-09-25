local var0_0 = class("NcHudDisplay", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	local var0_1 = arg0_1:GetBoolArg("show")
	local var1_1 = arg0_1:GetAgent().gameObject:GetComponent(typeof(WorldObjectItem))
	local var2_1 = var1_1.id
	local var3_1 = var1_1.type

	if var0_1 then
		local function var4_1()
			arg0_1:EndAction()
		end

		local var5_1 = arg0_1:GetStringArg("type")
		local var6_1 = arg0_1:GetStringArg("height")

		arg0_1:SendEvent(ISLAND_EVT.SHOW_UNIT_HUD_OP, {
			id = tonumber(var2_1),
			height = tonumber(var6_1),
			operationType = tonumber(var5_1),
			type = var3_1
		})
	else
		arg0_1:SendEvent(ISLAND_EVT.HIDE_UNIT_HUD_OP, {
			id = tonumber(var2_1),
			type = var3_1
		})
		arg0_1:EndAction()
	end
end

return var0_0
