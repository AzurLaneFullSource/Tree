local var0 = class("MainForcePlayerNameModificationSequence")

function var0.Execute(arg0, arg1)
	if getProxy(PlayerProxy):getRawData():WhetherServerModifiesName() then
		arg0:ShowModityPlayerNameWindow(arg1)
	else
		arg1()
	end
end

function var0.ShowModityPlayerNameWindow(arg0, arg1)
	arg0.renameWindow = arg0.renameWindow or ForcePlayerNameModificationPage.New(pg.UIMgr.GetInstance().OverlayMain)

	arg0.renameWindow:ExecuteAction("Show", function()
		arg0:Clear()
	end)
end

function var0.Clear(arg0)
	if arg0.renameWindow then
		arg0.renameWindow:Destroy()

		arg0.renameWindow = nil
	end
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
