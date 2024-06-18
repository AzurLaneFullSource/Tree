local var0_0 = class("MainServerNoticeSequence", import(".MainSublayerSequence"))

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(ServerNoticeProxy)

	if #var0_1:getServerNotices(false) > 0 and var0_1:needAutoOpen() then
		arg0_1:AddSubLayers(Context.New({
			mediator = NewBulletinBoardMediator,
			viewComponent = NewBulletinBoardLayer,
			onRemoved = arg1_1
		}))
	else
		arg1_1()
	end
end

return var0_0
