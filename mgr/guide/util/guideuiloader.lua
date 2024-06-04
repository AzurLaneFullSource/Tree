local var0 = class("GuideUILoader")

function var0.Ctor(arg0, arg1)
	arg0.root = arg1
	arg0.caches = {}
end

function var0.Load(arg0, arg1, arg2)
	arg0:LoadRes(arg1, arg2)
end

function var0.LoadHighLightArea(arg0, arg1)
	local var0 = arg1.isWorld and "wShowArea" or "wShowArea1"

	arg0:Load(var0, function(arg0)
		if not arg1 then
			return
		end

		arg0.sizeDelta = arg1.sizeDelta
		arg0.pivot = arg1.pivot
		arg0.localPosition = arg1.position
	end)
end

function var0.LoadRes(arg0, arg1, arg2)
	ResourceMgr.Inst:getAssetAsync("guideitem/" .. arg1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if IsNil(arg0) then
			return
		end

		local var0 = Object.Instantiate(arg0, arg0.root).transform

		table.insert(arg0.caches, var0)

		if arg2 then
			arg2(var0)
		end
	end), true, true)
end

function var0.Clear(arg0)
	if arg0.caches and #arg0.caches > 0 then
		for iter0, iter1 in ipairs(arg0.caches) do
			Object.Destroy(iter1.gameObject)
		end

		arg0.caches = {}
	end
end

return var0
