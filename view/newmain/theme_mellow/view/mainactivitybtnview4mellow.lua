local var0 = class("MainActivityBtnView4Mellow", import("...theme_classic.view.MainActivityBtnView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.mapEventTr = arg1:Find("right/1/act/act_battle")
	arg0.mapBtn = MainActivityBtnMellowAdapt.New(MainActMapBtn.New(arg0.mapEventTr, arg0.event, true))
end

function var0.InitBtns(arg0)
	arg0.actBtnTpl = arg0._tf:Find("right/activity/tpl")

	var0.super.InitBtns(arg0)

	local var0 = _.select(arg0.activityBtns, function(arg0)
		return not isa(arg0, MainActMapBtn)
	end)

	arg0.activityBtns = _.map(var0, function(arg0)
		return MainActivityBtnMellowAdapt.New(arg0)
	end)
	arg0.specailBtns = _.map(arg0.specailBtns, function(arg0)
		assert(_G[arg0.__cname .. "MellowAdapt"])

		return _G[arg0.__cname .. "MellowAdapt"].New(arg0)
	end)
end

function var0.GetBtn(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.activityBtns) do
		if isa(iter1.activityBtn, arg1) then
			return iter1
		end
	end

	for iter2, iter3 in ipairs(arg0.specailBtns) do
		if isa(iter3.spActBtn, arg1) then
			return iter3
		end
	end

	return nil
end

function var0.Flush(arg0)
	local var0, var1 = arg0:FilterActivityBtns()

	for iter0, iter1 in ipairs(var0) do
		iter1:Init(iter0)
	end

	for iter2, iter3 in ipairs(var1) do
		iter3:Clear()
	end

	local var2, var3 = arg0:FilterSpActivityBtns()

	for iter4, iter5 in ipairs(var2) do
		iter5:Init()
	end

	for iter6, iter7 in ipairs(var3) do
		iter7:Clear()
	end

	if arg0.mapBtn:InShowTime() then
		arg0.mapBtn:Init()
	else
		arg0.mapBtn:Clear()
	end
end

function var0.GetDirection(arg0)
	return Vector2.zero
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0.mapBtn:Dispose()

	arg0.mapBtn = nil
end

return var0
