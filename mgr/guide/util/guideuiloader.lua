local var0_0 = class("GuideUILoader")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.root = arg1_1
	arg0_1.caches = {}
end

function var0_0.Load(arg0_2, arg1_2, arg2_2)
	arg0_2:LoadRes(arg1_2, arg2_2)
end

function var0_0.LoadHighLightArea(arg0_3, arg1_3)
	local var0_3 = arg1_3.isWorld and "wShowArea" or "wShowArea1"

	arg0_3:Load(var0_3, function(arg0_4)
		if not arg1_3 then
			return
		end

		arg0_4.sizeDelta = arg1_3.sizeDelta
		arg0_4.pivot = arg1_3.pivot
		arg0_4.localPosition = arg1_3.position
	end)
end

function var0_0.LoadRes(arg0_5, arg1_5, arg2_5)
	ResourceMgr.Inst:getAssetAsync("guideitem/" .. arg1_5, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_6)
		if IsNil(arg0_6) then
			return
		end

		local var0_6 = Object.Instantiate(arg0_6, arg0_5.root).transform

		table.insert(arg0_5.caches, var0_6)

		if arg2_5 then
			arg2_5(var0_6)
		end
	end), true, true)
end

function var0_0.Clear(arg0_7)
	if arg0_7.caches and #arg0_7.caches > 0 then
		for iter0_7, iter1_7 in ipairs(arg0_7.caches) do
			Object.Destroy(iter1_7.gameObject)
		end

		arg0_7.caches = {}
	end
end

return var0_0
