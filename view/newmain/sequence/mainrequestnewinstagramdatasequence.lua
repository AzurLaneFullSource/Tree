local var0_0 = class("MainRequestNewInstagramDataSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = {}

	if not getProxy(InstagramProxy):IsReqNewInstagramData() then
		table.insert(var0_1, function(arg0_2)
			local var0_2 = getProxy(InstagramProxy):GetNewInstagramIds()

			pg.m02:sendNotification(GAME.REQ_NEW_INSTAGRAM_DATA, {
				idList = var0_2,
				callback = arg0_2
			})
		end)
	end

	seriesAsync(var0_1, arg1_1)
end

return var0_0
