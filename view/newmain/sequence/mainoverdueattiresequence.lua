local var0_0 = class("MainOverDueAttireSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(AttireProxy):getExpiredChaces()

	if #var0_1 > 0 then
		arg0_1:Display(AttireExpireDisplayPage, var0_1, arg1_1)
	else
		arg1_1()
	end
end

function var0_0.Display(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.page = arg1_2.New(pg.UIMgr.GetInstance().UIMain)

	function arg0_2.page.Hide()
		arg0_2:Clear()
		arg3_2()
	end

	arg0_2.page:ExecuteAction("Show", arg2_2)
end

function var0_0.Clear(arg0_4)
	if arg0_4.page then
		arg0_4.page:Destroy()

		arg0_4.page = nil
	end
end

function var0_0.Dispose(arg0_5)
	arg0_5:Clear()
end

return var0_0
