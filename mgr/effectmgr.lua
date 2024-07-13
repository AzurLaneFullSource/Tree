pg = pg or {}

local var0_0 = pg
local var1_0 = singletonClass("EffectMgr")

var0_0.EffectMgr = var1_0

function var1_0.Ctor(arg0_1)
	local var0_1 = ys.Battle.BattleResourceManager.GetInstance()

	arg0_1.effectCbMap = setmetatable({}, {
		__mode = "k"
	})

	function arg0_1.commonEffectEvent(arg0_2)
		local var0_2 = arg0_1.effectCbMap[arg0_2]

		if var0_2 == nil then
			var0_1:DestroyOb(arg0_2)

			return
		end

		local var1_2 = var0_2[2]

		if var1_2 ~= nil then
			var1_2(arg0_2)
		end

		arg0_1.effectCbMap[arg0_2] = nil

		if var0_2[1] then
			var0_1:DestroyOb(arg0_2)
		else
			arg0_2:SetActive(false)
		end
	end
end

function var1_0.ClearBattleEffectMap(arg0_3)
	arg0_3.effectCbMap = setmetatable({}, {
		__mode = "k"
	})
end

function var1_0.CommonEffectEvent(arg0_4, arg1_4)
	LuaHelper.SetParticleEndEvent(arg1_4, arg0_4.commonEffectEvent)
end

function var1_0.PlayBattleEffect(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	arg1_5.transform.localPosition = arg2_5

	arg1_5:SetActive(true)

	if arg5_5 then
		LuaHelper.SetParticleSpeed(arg1_5, 1 / Time.timeScale)
	end

	arg0_5.effectCbMap[arg1_5] = {
		arg3_5,
		arg4_5
	}
end

function var1_0.BattleUIEffect(arg0_6, arg1_6, arg2_6)
	assert(string.sub(arg1_6, -2, -1) == "UI", "UI效果不是以UI结尾，请检查")
	LoadAndInstantiateAsync("UI", arg1_6, function(arg0_7)
		local var0_7 = ys.Battle.BattleState.GetInstance()

		if var0_7:GetState() ~= var0_7.BATTLE_STATE_FIGHT then
			Destroy(arg0_7)

			return
		end

		local var1_7 = var0_0.UIMgr.GetInstance().UIMain

		LuaHelper.SetGOParentGO(arg0_7, var1_7, false)
		SetActive(arg0_7, true)
		arg2_6(arg0_7)
	end)
end

function var1_0.EndEffect(arg0_8, arg1_8)
	local var0_8 = arg0_8._effectMap[arg1_8]

	if var0_8 ~= nil then
		var0_8:GetComponent(typeof(ParticleSystem)):Stop()
	end
end
