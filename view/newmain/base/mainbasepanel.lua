local var0_0 = class("MainBasePanel", import(".MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.contextData = arg3_1
	arg0_1.btns = arg0_1:GetBtns()

	arg0_1:Register()
end

function var0_0.Init(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.btns) do
		onButton(arg0_2, iter1_2:GetTarget(), function()
			iter1_2:OnClick()
		end, SFX_PANEL)
		iter1_2:Flush(true)
	end
end

function var0_0.Register(arg0_4)
	arg0_4:bind(PlayerProxy.UPDATED, function(arg0_5)
		arg0_4:Refresh()
	end)
end

function var0_0.Refresh(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.btns) do
		iter1_6:Flush(false)
	end
end

function var0_0.Dispose(arg0_7)
	var0_0.super.Dispose(arg0_7)

	for iter0_7, iter1_7 in ipairs(arg0_7.btns) do
		iter1_7:Dispose()
	end

	arg0_7.btns = {}

	arg0_7:OnDispose()
end

function var0_0.GetBtns(arg0_8)
	return {}
end

function var0_0.OnDispose(arg0_9)
	return
end

return var0_0
