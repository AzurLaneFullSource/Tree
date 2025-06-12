local var0_0 = class("MainRequestNewInstagramDataSequence")

function var0_0.Execute(arg0_1, arg1_1)
	if getProxy(InstagramProxy):IsReqNewInstagramData() then
		arg1_1()

		return
	end

	local var0_1, var1_1 = getProxy(InstagramProxy):GetNewInstagramBeginIdAndEndId()

	if var1_1 - var0_1 <= 0 then
		arg1_1()

		return
	end

	pg.m02:sendNotification(GAME.REQ_NEW_INSTAGRAM_DATA, {
		beginId = var0_1,
		endId = var1_1,
		callback = arg1_1
	})
end

return var0_0
