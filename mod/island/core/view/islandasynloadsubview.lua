local var0_0 = class("IslandASynLoadSubView", import(".IslandBaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.__funcList = {}
	arg0_1.isloading = false
end

function var0_0.Init(arg0_2, ...)
	arg0_2.isloading = true

	var0_0.super.Init(arg0_2, ...)
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.isloading = false

	arg0_3:ExecuteFuncList()
end

function var0_0.ExecuteFuncList(arg0_4)
	if #arg0_4.__funcList <= 0 then
		return
	end

	for iter0_4, iter1_4 in ipairs(arg0_4.__funcList) do
		arg0_4[iter1_4.name](arg0_4, unpackEx(iter1_4.args))
	end

	arg0_4.__funcList = {}
end

function var0_0.SetUIParent(arg0_5, arg1_5)
	return arg0_5:GetView().pageContianer
end

function var0_0.Show(arg0_6, ...)
	if arg0_6:IsEmpty() then
		arg0_6:Init(...)
	else
		arg0_6:ShowOrHideGameObject(arg0_6._go, true)
		arg0_6:Flush(...)
	end

	arg0_6:OnShow()
end

function var0_0.OnShow(arg0_7)
	return
end

function var0_0.Hide(arg0_8)
	arg0_8:ShowOrHideGameObject(arg0_8._go, false)
end

function var0_0.ShowOrHideGameObject(arg0_9, arg1_9, arg2_9)
	local var0_9 = GetOrAddComponent(arg1_9, typeof(CanvasGroup))

	var0_9.alpha = arg2_9 and 1 or 0
	var0_9.blocksRaycasts = arg2_9
end

function var0_0.Execute(arg0_10, arg1_10, ...)
	if arg0_10:IsLoaded() or not arg0_10:IsLoaded() and #arg0_10.__funcList == 0 and arg1_10 == "Show" then
		arg0_10[arg1_10](arg0_10, ...)
	elseif arg0_10.isloading then
		table.insert(arg0_10.__funcList, {
			name = arg1_10,
			args = packEx(...)
		})
	end
end

return var0_0
