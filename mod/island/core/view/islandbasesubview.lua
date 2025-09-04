local var0_0 = class("IslandBaseSubView", import("Mod.Island.Core.View.IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.__funcList = {}
	arg0_1.isloading = false
end

function var0_0.Init(arg0_2, ...)
	arg0_2.isloading = true

	local var0_2 = packEx(...)

	ResourceMgr.Inst:getAssetAsync("UI/" .. arg0_2:GetUIName(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
		arg0_2.isloading = false

		local var0_3 = Object.Instantiate(arg0_3)

		arg0_2._go = var0_3
		arg0_2._tf = var0_3.transform

		var0_0.super.Init(arg0_2, var0_3)
		arg0_2:SetUIParent(var0_3)
		var0_3.transform:SetAsFirstSibling()
		arg0_2:FirstFlush()
		arg0_2:Flush(unpackEx(var0_2))
		arg0_2:ExecuteFuncList()
	end), true, true)
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

function var0_0.findTF(arg0_5, arg1_5, arg2_5)
	assert(arg0_5._tf, "transform should exist")

	return findTF(arg2_5 or arg0_5._tf, arg1_5)
end

function var0_0.SetUIParent(arg0_6, arg1_6)
	setParent(arg1_6, arg0_6:GetView().pageContianer)
end

function var0_0.OnDispose(arg0_7)
	if not IsNil(arg0_7._go) then
		Object.Destroy(arg0_7._go)
	end

	arg0_7._go = nil
	arg0_7._tf = nil
end

function var0_0.Show(arg0_8, ...)
	if arg0_8:IsEmpty() then
		arg0_8:Init(...)
	else
		setActive(arg0_8._go, true)
		arg0_8:Flush(...)
	end
end

function var0_0.ShowMsgbox(arg0_9, arg1_9)
	arg0_9:GetView():ShowMsgbox(arg1_9)
end

function var0_0.Hide(arg0_10)
	setActive(arg0_10._go, false)
end

function var0_0.Disable(arg0_11)
	setActive(arg0_11._go, false)
end

function var0_0.Enable(arg0_12)
	setActive(arg0_12._go, true)
end

function var0_0.Execute(arg0_13, arg1_13, ...)
	if arg0_13:IsLoaded() or not arg0_13:IsLoaded() and #arg0_13.__funcList == 0 and arg1_13 == "Show" then
		arg0_13[arg1_13](arg0_13, ...)
	elseif arg0_13.isloading then
		table.insert(arg0_13.__funcList, {
			name = arg1_13,
			args = packEx(...)
		})
	end
end

function var0_0.GetUIName(arg0_14)
	assert(false, "overwrite me")
end

function var0_0.Flush(arg0_15, ...)
	return
end

function var0_0.FirstFlush(arg0_16)
	return
end

return var0_0
