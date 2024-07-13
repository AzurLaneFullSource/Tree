local var0_0 = class("CourtYardFeastPoolMgr", import(".CourtYardPoolMgr"))

function var0_0.GenPool(arg0_1, arg1_1)
	local var0_1 = var0_0.super.GenPool(arg0_1, arg1_1)
	local var1_1 = {
		"chengbao_aixin",
		"chengbao_xinxin",
		"chengbao_yinfu",
		"chengbao_ZZZ"
	}

	for iter0_1, iter1_1 in ipairs(var1_1) do
		table.insert(var0_1, function(arg0_2)
			ResourceMgr.Inst:getAssetAsync("Effect/" .. iter1_1, "", typeof(Object), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
				if arg0_1.exited then
					return
				end

				if arg0_3 then
					arg0_1.pools[iter1_1] = CourtYardEffectPool.New(arg1_1, arg0_3, 0, 3, CourtYardConst.FEAST_EFFECT_TIME)
				end

				arg0_2()
			end), true, true)
		end)
	end

	return var0_1
end

return var0_0
