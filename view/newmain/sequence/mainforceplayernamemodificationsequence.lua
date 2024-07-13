local var0_0 = class("MainForcePlayerNameModificationSequence")

function var0_0.Execute(arg0_1, arg1_1)
	if getProxy(PlayerProxy):getRawData():WhetherServerModifiesName() then
		arg0_1:ShowModityPlayerNameWindow(arg1_1)
	else
		arg1_1()
	end
end

function var0_0.ShowModityPlayerNameWindow(arg0_2, arg1_2)
	arg0_2.renameWindow = arg0_2.renameWindow or ForcePlayerNameModificationPage.New(pg.UIMgr.GetInstance().OverlayMain)

	arg0_2.renameWindow:ExecuteAction("Show", function()
		arg0_2:Clear()
	end)
end

function var0_0.Clear(arg0_4)
	if arg0_4.renameWindow then
		arg0_4.renameWindow:Destroy()

		arg0_4.renameWindow = nil
	end
end

function var0_0.Dispose(arg0_5)
	arg0_5:Clear()
end

return var0_0
