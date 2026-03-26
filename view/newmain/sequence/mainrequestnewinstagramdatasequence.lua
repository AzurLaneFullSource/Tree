local var0_0 = class("MainRequestNewInstagramDataSequence")

function var0_0.Execute(arg0_1, arg1_1)
	if getProxy(InstagramProxy):IsReqNewInstagramData() then
		arg1_1()

		return
	end

	local var0_1 = getProxy(InstagramProxy):GetNewInstagramIds()

	pg.m02:sendNotification(GAME.REQ_NEW_INSTAGRAM_DATA, {
		idList = var0_1,
		callback = arg1_1
	})
end

return var0_0
