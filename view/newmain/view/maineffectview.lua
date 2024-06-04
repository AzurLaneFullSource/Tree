local var0 = class("MainEffectView")

function var0.Ctor(arg0, arg1)
	arg0.tr = arg1
	arg0.loading = false
	arg0.caches = {}
end

function var0.GetEffect(arg0, arg1)
	if arg1.propose then
		return "jiehuntexiao"
	end

	return nil
end

function var0.Init(arg0, arg1)
	local var0 = arg0:GetEffect(arg1)

	arg0:Load(var0)
end

function var0.Refresh(arg0, arg1)
	local var0 = arg0:GetEffect(arg1)

	if var0 and arg0.loading then
		arg0:SetDirty(var0)

		return
	end

	arg0:Load(var0)
end

function var0.Load(arg0, arg1)
	if arg0.effectName and not arg1 then
		arg0:Clear()

		return
	end

	if not arg1 or arg1 == arg0.effectName then
		return
	end

	arg0:Clear()

	arg0.loading = true

	arg0:LoadEffect(arg1, function(arg0)
		arg0.loading = false
		arg0.transform.localPosition = Vector3.zero
		arg0.transform.localScale = Vector3.one
		arg0.effectGo = arg0
		arg0.effectName = arg1
	end)

	arg0.dirty = nil
end

function var0.LoadEffect(arg0, arg1, arg2)
	if arg0.caches[arg1] then
		local var0 = arg0.caches[arg1]

		setActive(var0, true)
		arg2(var0)
	else
		ResourceMgr.Inst:getAssetAsync("Effect/" .. arg1, arg1, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited then
				return
			end

			if arg0:IsDirty() then
				arg0:Load(arg0.dirty)

				return
			end

			local var0 = Object.Instantiate(arg0, arg0.tr)

			arg0.caches[arg1] = var0

			arg2(var0)
		end), true, true)
	end
end

function var0.SetDirty(arg0, arg1)
	arg0.dirty = arg1
end

function var0.IsDirty(arg0)
	return arg0.dirty ~= nil
end

function var0.Clear(arg0)
	if arg0.effectGo then
		setActive(arg0.effectGo, false)

		arg0.effectGo = nil
	end

	arg0.effectName = nil
	arg0.loading = nil
end

function var0.Dispose(arg0)
	arg0:Clear()

	for iter0, iter1 in pairs(arg0.caches) do
		Object.Destroy(iter1)
	end

	arg0.caches = nil
	arg0.exited = true
	arg0.dirty = nil
end

return var0
