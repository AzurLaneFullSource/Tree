local var0 = class("MainBasePanel", import(".MainBaseView"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.contextData = arg3
	arg0.btns = arg0:GetBtns()

	arg0:Register()
end

function var0.Init(arg0)
	for iter0, iter1 in ipairs(arg0.btns) do
		onButton(arg0, iter1:GetTarget(), function()
			iter1:OnClick()
		end, SFX_PANEL)
		iter1:Flush(true)
	end
end

function var0.Register(arg0)
	arg0:bind(PlayerProxy.UPDATED, function(arg0)
		arg0:Refresh()
	end)
end

function var0.Refresh(arg0)
	for iter0, iter1 in ipairs(arg0.btns) do
		iter1:Flush(false)
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	for iter0, iter1 in ipairs(arg0.btns) do
		iter1:Dispose()
	end

	arg0.btns = {}

	arg0:OnDispose()
end

function var0.GetBtns(arg0)
	return {}
end

function var0.OnDispose(arg0)
	return
end

return var0
