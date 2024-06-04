local var0 = class("MainServerNoticeSequence", import(".MainSublayerSequence"))

function var0.Execute(arg0, arg1)
	local var0 = getProxy(ServerNoticeProxy)

	if #var0:getServerNotices(false) > 0 and var0:needAutoOpen() then
		arg0:AddSubLayers(Context.New({
			mediator = NewBulletinBoardMediator,
			viewComponent = NewBulletinBoardLayer,
			onRemoved = arg1
		}))
	else
		arg1()
	end
end

return var0
