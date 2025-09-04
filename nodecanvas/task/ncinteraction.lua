local var0_0 = class("NcInteraction", import("..base.NodeCanvasBaseTask"))

function var0_0.OnExecute(arg0_1)
	local var0_1 = arg0_1:GetBoolArg("show")
	local var1_1 = arg0_1:GetAgent().gameObject:GetComponent(typeof(WorldObjectItem)).id

	if var0_1 then
		local function var2_1()
			arg0_1:EndAction()
		end

		local var3_1 = arg0_1:GetStringArg("type")

		arg0_1:SendEvent(ISLAND_EVT.APPROACH_UNIT, {
			id = tonumber(var1_1),
			type = tonumber(var3_1),
			callback = var2_1
		})
	else
		arg0_1:SendEvent(ISLAND_EVT.LEAVE_UNIT, {
			id = tonumber(var1_1)
		})
		arg0_1:EndAction()
	end
end

return var0_0
