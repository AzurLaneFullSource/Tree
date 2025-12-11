local var0_0 = class("IslandBaseSubView", import("Mod.Island.Core.View.IslandBaseUnit"))

function var0_0.Init(arg0_1, ...)
	local var0_1 = packEx(...)

	arg0_1:LoadUI(function(arg0_2)
		arg0_1:DoInit(arg0_2, var0_1)
	end)
end

function var0_0.LoadUI(arg0_3, arg1_3)
	arg0_3.loadingId = IslandAssetLoadDispatcher.Instance:Enqueue("UI/" .. arg0_3:GetUIName(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_4)
		local var0_4 = arg0_3:GetUIParent()

		arg0_3.insId = FrameAsyncInstantiateManager.Instance:EnqueueInstantiateUI(arg0_4, var0_4, Vector3.zero, arg1_3)
	end), true, true)
end

function var0_0.DoInit(arg0_5, arg1_5, arg2_5)
	arg0_5._go = arg1_5
	arg0_5._tf = arg1_5.transform

	var0_0.super.Init(arg0_5, arg1_5)

	arg0_5._tf.localPosition = Vector3.zero

	arg1_5.transform:SetAsFirstSibling()
	arg0_5:OnBeforeLoaded()
	arg0_5:FirstFlush()
	arg0_5:Flush(unpackEx(arg2_5))
	arg0_5:OnLoaded()
end

function var0_0.OnDispose(arg0_6)
	arg0_6:UnloadUI()

	arg0_6._go = nil
	arg0_6._tf = nil
end

function var0_0.UnloadUI(arg0_7)
	if not IsNil(arg0_7._go) then
		Object.Destroy(arg0_7._go)
	end

	if arg0_7.loadingId then
		IslandAssetLoadDispatcher.Instance:Cancel(arg0_7.loadingId)

		arg0_7.loadingId = nil
	end

	if arg0_7.insId then
		FrameAsyncInstantiateManager.Instance:Cancel(arg0_7.insId)

		arg0_7.insId = nil
	end
end

function var0_0.ShowMsgbox(arg0_8, arg1_8)
	arg0_8:GetView():ShowMsgbox(arg1_8)
end

function var0_0.GetPlayerUnit(arg0_9)
	return arg0_9:GetView().player
end

function var0_0.CreateSubView(arg0_10, arg1_10)
	return arg1_10.New(arg0_10:GetView())
end

function var0_0.GetUIName(arg0_11)
	assert(false, "overwrite me")
end

function var0_0.GetUIParent(arg0_12, arg1_12)
	assert(false, "overwrite me")
end

function var0_0.Flush(arg0_13, ...)
	return
end

function var0_0.FirstFlush(arg0_14)
	return
end

function var0_0.OnBeforeLoaded(arg0_15)
	return
end

function var0_0.OnLoaded(arg0_16)
	return
end

return var0_0
