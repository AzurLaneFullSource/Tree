local var0_0 = class("IslandFishingEffectMgr", import("Mod.Island.Core.View.IslandBaseUnit"))

var0_0.EFFECT_NORMAL = "vfx_diaoyu_diandian"
var0_0.EFFECT_ENTER = "vfx_diaoyu_rushui"
var0_0.EFFECT_WAITING = "vfx_diaoyu_dengdai"
var0_0.EFFECT_HOOKED = "vfx_diaoyu_yaogou"
var0_0.EFFECT_SHAKE = "vfx_diaoyu_zhenzha"
var0_0.EFFECT_LEAVE = "vfx_diaoyu_chushui"
var0_0.EFFECT_ENTER_TIME = 1
var0_0.EFFECT_LEAVE_TIME = 0.7

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.effects = {}

	arg0_1:Init()
end

function var0_0.SetFishHook(arg0_2, arg1_2)
	arg0_2.hookTr = arg1_2
end

function var0_0.Preload(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:GetView():GetUnitModuleWithType(IslandConst.UNIT_LIST_FISH_POINT, arg1_3)
	local var1_3 = var0_3._go.transform:Find("vfx")

	arg0_3.effects[var0_0.EFFECT_NORMAL] = var1_3

	local var2_3 = {}

	for iter0_3, iter1_3 in ipairs({
		var0_0.EFFECT_ENTER,
		var0_0.EFFECT_HOOKED,
		var0_0.EFFECT_WAITING,
		var0_0.EFFECT_SHAKE,
		var0_0.EFFECT_LEAVE
	}) do
		table.insert(var2_3, function(arg0_4)
			if arg0_3.eixted then
				return
			end

			local var0_4 = "island/effect/prefab/game/diaoyu/" .. iter1_3

			arg0_3:GetPoolMgr():GetFishingEffect(var0_4, function(arg0_5)
				setParent(arg0_5, var0_3._go.transform)

				arg0_3.effects[iter1_3] = arg0_5

				setActive(arg0_5, false)
				arg0_4()
			end)
		end)
	end

	seriesAsync(var2_3, arg2_3)
end

function var0_0.Play(arg0_6, arg1_6)
	arg0_6:RemoveTimer()

	for iter0_6, iter1_6 in pairs(arg0_6.effects) do
		setActive(iter1_6, iter0_6 == arg1_6)
	end

	if arg1_6 == var0_0.EFFECT_ENTER then
		-- block empty
	end
end

function var0_0.UpdatePositions(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.effects) do
		if iter0_7 ~= var0_0.EFFECT_NORMAL then
			local var0_7 = arg0_7.effects[var0_0.EFFECT_NORMAL].transform.position.y

			iter1_7.transform.position = IsNil(arg0_7.hookTr) and Vector3(0, 0, 0) or Vector3(arg0_7.hookTr.position.x, var0_7, arg0_7.hookTr.position.z)
		end
	end
end

function var0_0.DelayPlay(arg0_8, arg1_8, arg2_8)
	arg0_8:RemoveTimer()
	arg0_8:AddTimer(arg1_8, function()
		arg0_8:Play(arg2_8)
	end)
end

function var0_0.AddTimer(arg0_10, arg1_10, arg2_10)
	arg0_10.timer = Timer.New(arg2_10, arg1_10, 1)

	arg0_10.timer:Start()
end

function var0_0.RemoveTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.OnDestroy(arg0_12)
	arg0_12:RemoveTimer()

	for iter0_12, iter1_12 in pairs(arg0_12.effects) do
		if iter0_12 ~= var0_0.EFFECT_NORMAL then
			local var0_12 = "island/effect/prefab/game/diaoyu/" .. iter0_12

			arg0_12:GetPoolMgr():ReturnFishingEffect(var0_12, iter1_12)
		else
			setActive(iter1_12, true)
		end
	end

	arg0_12.effects = {}
	arg0_12.eixted = true
end

return var0_0
