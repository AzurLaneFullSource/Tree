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

function var0_0.GetUIParent(arg0_5, arg1_5)
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
	arg0_8:OnHide()
end

function var0_0.OnHide(arg0_9)
	return
end

function var0_0.ShowOrHideGameObject(arg0_10, arg1_10, arg2_10)
	local var0_10 = GetOrAddComponent(arg1_10, typeof(CanvasGroup))

	var0_10.alpha = arg2_10 and 1 or 0
	var0_10.blocksRaycasts = arg2_10
end

function var0_0.Execute(arg0_11, arg1_11, ...)
	if arg0_11:IsLoaded() or not arg0_11:IsLoaded() and #arg0_11.__funcList == 0 and arg1_11 == "Show" then
		arg0_11[arg1_11](arg0_11, ...)
	elseif arg0_11.isloading then
		table.insert(arg0_11.__funcList, {
			name = arg1_11,
			args = packEx(...)
		})
	end
end

return var0_0
