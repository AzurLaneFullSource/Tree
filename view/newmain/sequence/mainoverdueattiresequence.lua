local var0 = class("MainOverDueAttireSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(AttireProxy):getExpiredChaces()

	if #var0 > 0 then
		arg0:Display(AttireExpireDisplayPage, var0, arg1)
	else
		arg1()
	end
end

function var0.Display(arg0, arg1, arg2, arg3)
	arg0.page = arg1.New(pg.UIMgr.GetInstance().UIMain)

	function arg0.page.Hide()
		arg0:Clear()
		arg3()
	end

	arg0.page:ExecuteAction("Show", arg2)
end

function var0.Clear(arg0)
	if arg0.page then
		arg0.page:Destroy()

		arg0.page = nil
	end
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
