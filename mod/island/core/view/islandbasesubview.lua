local var0_0 = class("IslandBaseSubView", import("Mod.Island.Core.View.IslandBaseUnit"))

function var0_0.Init(arg0_1, ...)
	local var0_1 = packEx(...)

	arg0_1.loadingId = IslandAssetLoadDispatcher.Instance:Enqueue("UI/" .. arg0_1:GetUIName(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_2)
		local var0_2 = arg0_1:SetUIParent()

		arg0_1.uiInstID = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_2, Vector3.zero, Quaternion.identity, var0_2, function(arg0_3)
			arg0_1:DoInit(arg0_3, var0_1)
		end)
	end), true, true)
end

function var0_0.DoInit(arg0_4, arg1_4, arg2_4)
	arg0_4._go = arg1_4
	arg0_4._tf = arg1_4.transform

	var0_0.super.Init(arg0_4, arg1_4)

	arg0_4._tf.localPosition = Vector3.zero

	arg1_4.transform:SetAsFirstSibling()
	arg0_4:OnBeforeLoaded()
	arg0_4:FirstFlush()
	arg0_4:Flush(unpackEx(arg2_4))
	arg0_4:OnLoaded()
end

function var0_0.OnDispose(arg0_5)
	if not IsNil(arg0_5._go) then
		Object.Destroy(arg0_5._go)
	end

	arg0_5._go = nil
	arg0_5._tf = nil

	if arg0_5.uiInstID then
		FrameAsyncInstantiateManager.Instance:Cancel(arg0_5.uiInstID)

		arg0_5.uiInstID = nil
	end

	if arg0_5.loadingId then
		IslandAssetLoadDispatcher.Instance:Cancel(arg0_5.loadingId)

		arg0_5.loadingId = nil
	end
end

function var0_0.ShowMsgbox(arg0_6, arg1_6)
	arg0_6:GetView():ShowMsgbox(arg1_6)
end

function var0_0.GetPlayerUnit(arg0_7)
	return arg0_7:GetView().player
end

function var0_0.GetUIName(arg0_8)
	assert(false, "overwrite me")
end

function var0_0.SetUIParent(arg0_9, arg1_9)
	assert(false, "overwrite me")
end

function var0_0.Flush(arg0_10, ...)
	return
end

function var0_0.FirstFlush(arg0_11)
	return
end

function var0_0.OnBeforeLoaded(arg0_12)
	return
end

function var0_0.OnLoaded(arg0_13)
	return
end

return var0_0
