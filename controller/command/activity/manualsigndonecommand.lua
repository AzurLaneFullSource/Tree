local var0_0 = class("ManualSignDoneCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1.id)
	local var2_1 = var1_1:getConfig("config_client")
	local var3_1 = var2_1 and var2_1.manulSign == true

	if not var1_1 or var1_1:isEnd() and not var3_1 then
		return
	end

	if var0_1.cmd == ManualSignActivity.OP_SIGN and var1_1:GetSignedDayCnt() < 7 and var1_1:AnyAwardCanGet() then
		arg0_1:sendNotification(GAME.ACT_MANUAL_SIGN, {
			activity_id = var1_1.id,
			cmd = ManualSignActivity.OP_GET_AWARD
		})
	end
end

return var0_0
