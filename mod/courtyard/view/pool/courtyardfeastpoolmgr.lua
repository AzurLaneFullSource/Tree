local var0 = class("CourtYardFeastPoolMgr", import(".CourtYardPoolMgr"))

function var0.GenPool(arg0, arg1)
	local var0 = var0.super.GenPool(arg0, arg1)
	local var1 = {
		"chengbao_aixin",
		"chengbao_xinxin",
		"chengbao_yinfu",
		"chengbao_ZZZ"
	}

	for iter0, iter1 in ipairs(var1) do
		table.insert(var0, function(arg0)
			ResourceMgr.Inst:getAssetAsync("Effect/" .. iter1, "", typeof(Object), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0.exited then
					return
				end

				if arg0 then
					arg0.pools[iter1] = CourtYardEffectPool.New(arg1, arg0, 0, 3, CourtYardConst.FEAST_EFFECT_TIME)
				end

				arg0()
			end), true, true)
		end)
	end

	return var0
end

return var0
