local var0_0 = class("MainEffectView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tr = arg1_1
	arg0_1.loading = false
	arg0_1.caches = {}
end

function var0_0.GetEffect(arg0_2, arg1_2)
	if arg1_2.propose then
		return "jiehuntexiao"
	end

	return nil
end

function var0_0.Init(arg0_3, arg1_3)
	local var0_3 = arg0_3:GetEffect(arg1_3)

	arg0_3:Load(var0_3)
end

function var0_0.Refresh(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetEffect(arg1_4)

	if var0_4 and arg0_4.loading then
		arg0_4:SetDirty(var0_4)

		return
	end

	arg0_4:Load(var0_4)
end

function var0_0.Load(arg0_5, arg1_5)
	if arg0_5.effectName and not arg1_5 then
		arg0_5:Clear()

		return
	end

	if not arg1_5 or arg1_5 == arg0_5.effectName then
		return
	end

	arg0_5:Clear()

	arg0_5.loading = true

	arg0_5:LoadEffect(arg1_5, function(arg0_6)
		arg0_5.loading = false
		arg0_6.transform.localPosition = Vector3.zero
		arg0_6.transform.localScale = Vector3.one
		arg0_5.effectGo = arg0_6
		arg0_5.effectName = arg1_5
	end)

	arg0_5.dirty = nil
end

function var0_0.LoadEffect(arg0_7, arg1_7, arg2_7)
	if arg0_7.caches[arg1_7] then
		local var0_7 = arg0_7.caches[arg1_7]

		setActive(var0_7, true)
		arg2_7(var0_7)
	else
		ResourceMgr.Inst:getAssetAsync("Effect/" .. arg1_7, arg1_7, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_8)
			if arg0_7.exited then
				return
			end

			if arg0_7:IsDirty() then
				arg0_7:Load(arg0_7.dirty)

				return
			end

			local var0_8 = Object.Instantiate(arg0_8, arg0_7.tr)

			arg0_7.caches[arg1_7] = var0_8

			arg2_7(var0_8)
		end), true, true)
	end
end

function var0_0.SetDirty(arg0_9, arg1_9)
	arg0_9.dirty = arg1_9
end

function var0_0.IsDirty(arg0_10)
	return arg0_10.dirty ~= nil
end

function var0_0.Clear(arg0_11)
	if arg0_11.effectGo then
		setActive(arg0_11.effectGo, false)

		arg0_11.effectGo = nil
	end

	arg0_11.effectName = nil
	arg0_11.loading = nil
end

function var0_0.Dispose(arg0_12)
	arg0_12:Clear()

	for iter0_12, iter1_12 in pairs(arg0_12.caches) do
		Object.Destroy(iter1_12)
	end

	arg0_12.caches = nil
	arg0_12.exited = true
	arg0_12.dirty = nil
end

return var0_0
