local var0_0 = class("MainActivityBtnView4Mellow", import("...theme_classic.view.MainActivityBtnView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.mapEventTr = arg1_1:Find("right/1/act/act_battle")
	arg0_1.mapBtn = MainActivityBtnMellowAdapt.New(MainActMapBtn.New(arg0_1.mapEventTr, arg0_1.event, true))
end

function var0_0.InitBtns(arg0_2)
	arg0_2.actBtnTpl = arg0_2._tf:Find("right/activity/tpl")

	var0_0.super.InitBtns(arg0_2)

	local var0_2 = _.select(arg0_2.activityBtns, function(arg0_3)
		return not isa(arg0_3, MainActMapBtn)
	end)

	arg0_2.activityBtns = _.map(var0_2, function(arg0_4)
		return MainActivityBtnMellowAdapt.New(arg0_4)
	end)
	arg0_2.specailBtns = _.map(arg0_2.specailBtns, function(arg0_5)
		assert(_G[arg0_5.__cname .. "MellowAdapt"])

		return _G[arg0_5.__cname .. "MellowAdapt"].New(arg0_5)
	end)
end

function var0_0.GetBtn(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.activityBtns) do
		if isa(iter1_6.activityBtn, arg1_6) then
			return iter1_6
		end
	end

	for iter2_6, iter3_6 in ipairs(arg0_6.specailBtns) do
		if isa(iter3_6.spActBtn, arg1_6) then
			return iter3_6
		end
	end

	return nil
end

function var0_0.Flush(arg0_7)
	local var0_7, var1_7 = arg0_7:FilterActivityBtns()

	for iter0_7, iter1_7 in ipairs(var0_7) do
		iter1_7:Init(iter0_7)
	end

	for iter2_7, iter3_7 in ipairs(var1_7) do
		iter3_7:Clear()
	end

	local var2_7, var3_7 = arg0_7:FilterSpActivityBtns()

	for iter4_7, iter5_7 in ipairs(var2_7) do
		iter5_7:Init()
	end

	for iter6_7, iter7_7 in ipairs(var3_7) do
		iter7_7:Clear()
	end

	if arg0_7.mapBtn:InShowTime() then
		arg0_7.mapBtn:Init()
	else
		arg0_7.mapBtn:Clear()
	end
end

function var0_0.GetDirection(arg0_8)
	return Vector2.zero
end

function var0_0.Dispose(arg0_9)
	var0_0.super.Dispose(arg0_9)
	arg0_9.mapBtn:Dispose()

	arg0_9.mapBtn = nil
end

return var0_0
