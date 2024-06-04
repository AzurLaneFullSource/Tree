pg = pg or {}

local var0 = pg
local var1 = singletonClass("EffectMgr")

var0.EffectMgr = var1

function var1.Ctor(arg0)
	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	arg0.effectCbMap = setmetatable({}, {
		__mode = "k"
	})

	function arg0.commonEffectEvent(arg0)
		local var0 = arg0.effectCbMap[arg0]

		if var0 == nil then
			var0:DestroyOb(arg0)

			return
		end

		local var1 = var0[2]

		if var1 ~= nil then
			var1(arg0)
		end

		arg0.effectCbMap[arg0] = nil

		if var0[1] then
			var0:DestroyOb(arg0)
		else
			arg0:SetActive(false)
		end
	end
end

function var1.ClearBattleEffectMap(arg0)
	arg0.effectCbMap = setmetatable({}, {
		__mode = "k"
	})
end

function var1.CommonEffectEvent(arg0, arg1)
	LuaHelper.SetParticleEndEvent(arg1, arg0.commonEffectEvent)
end

function var1.PlayBattleEffect(arg0, arg1, arg2, arg3, arg4, arg5)
	arg1.transform.localPosition = arg2

	arg1:SetActive(true)

	if arg5 then
		LuaHelper.SetParticleSpeed(arg1, 1 / Time.timeScale)
	end

	arg0.effectCbMap[arg1] = {
		arg3,
		arg4
	}
end

function var1.BattleUIEffect(arg0, arg1, arg2)
	assert(string.sub(arg1, -2, -1) == "UI", "UI效果不是以UI结尾，请检查")
	LoadAndInstantiateAsync("UI", arg1, function(arg0)
		local var0 = ys.Battle.BattleState.GetInstance()

		if var0:GetState() ~= var0.BATTLE_STATE_FIGHT then
			Destroy(arg0)

			return
		end

		local var1 = var0.UIMgr.GetInstance().UIMain

		LuaHelper.SetGOParentGO(arg0, var1, false)
		SetActive(arg0, true)
		arg2(arg0)
	end)
end

function var1.EndEffect(arg0, arg1)
	local var0 = arg0._effectMap[arg1]

	if var0 ~= nil then
		var0:GetComponent(typeof(ParticleSystem)):Stop()
	end
end
