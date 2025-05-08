local var0_0 = class("IslandBasePage", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.islandScene = arg1_1

	local var0_1 = arg1_1._tf.parent
	local var1_1 = arg1_1.event
	local var2_1 = arg1_1.contextData

	var0_0.super.Ctor(arg0_1, var0_1, var1_1, var2_1)

	arg0_1.__callbacks__ = {}
end

function var0_0.GetInstancePage(arg0_2, arg1_2)
	return arg0_2.islandScene:GetInstancePage(arg1_2)
end

function var0_0.GetIsland(arg0_3)
	return arg0_3.islandScene:GetIsland()
end

function var0_0.Show(arg0_4, ...)
	arg0_4:AddListeners()
	var0_0.super.Show(arg0_4)
	arg0_4:OnShow(...)
end

function var0_0.Hide(arg0_5)
	arg0_5:ClosePage(arg0_5)
	arg0_5:RemoveListeners()
	arg0_5:OnHide()
end

function var0_0.Enable(arg0_6)
	var0_0.super.Show(arg0_6)
	arg0_6:OnEnable()
end

function var0_0.Disable(arg0_7)
	var0_0.super.Hide(arg0_7)
	arg0_7:OnDisable()
end

function var0_0.ShowMsgBox(arg0_8, arg1_8)
	return arg0_8.islandScene:ShowMsgbox(arg1_8)
end

function var0_0.OpenPage(arg0_9, arg1_9, ...)
	return arg0_9.islandScene:DoOpenPage(arg0_9, arg1_9, ...)
end

function var0_0.ClosePage(arg0_10, arg1_10)
	arg0_10.islandScene:DoClosePage(arg1_10)
end

function var0_0.AddListener(arg0_11, arg1_11, arg2_11)
	local function var0_11(arg0_12, ...)
		arg2_11(arg0_11, ...)
	end

	local var1_11 = arg0_11:bind(arg1_11, var0_11)

	arg0_11.__callbacks__[arg1_11] = var1_11

	arg0_11:GetIsland():AddListener(arg1_11, var0_11)
end

function var0_0.RemoveListener(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.__callbacks__[arg1_13]

	if var0_13 then
		local var1_13 = arg0_13.eventStore[var0_13]

		arg0_13:GetIsland():RemoveListener(arg1_13, var1_13.callback)
		arg0_13:disconnect(var0_13)

		arg0_13.__callbacks__[arg1_13] = nil
	end
end

function var0_0.Destroy(arg0_14)
	if arg0_14:GetLoaded() then
		arg0_14:Hide()
	end

	arg0_14.__callbacks__ = {}

	var0_0.super.Destroy(arg0_14)
end

function var0_0.SetVisible(arg0_15, arg1_15, arg2_15)
	local var0_15 = GetOrAddComponent(arg1_15, typeof(CanvasGroup))

	var0_15.alpha = arg2_15 and 1 or 0
	var0_15.blocksRaycasts = arg2_15
end

function var0_0.AddListeners(arg0_16)
	return
end

function var0_0.RemoveListeners(arg0_17)
	return
end

function var0_0.OnShow(arg0_18)
	return
end

function var0_0.OnHide(arg0_19)
	return
end

function var0_0.OnEnable(arg0_20)
	return
end

function var0_0.OnDisable(arg0_21)
	return
end

return var0_0
