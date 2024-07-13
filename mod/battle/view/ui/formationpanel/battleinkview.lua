ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleVariable
local var2_0 = class("BattleInkView")

var0_0.Battle.BattleInkView = var2_0
var2_0.__name = "BattleInkView"
var2_0.ANIMATION_STATE_INITIAL = "intial"
var2_0.ANIMATION_STATE_IDLE = "idle"
var2_0.ANIMATION_STATE_FINALE = "int"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:init()
end

function var2_0.init(arg0_2)
	arg0_2._tf = arg0_2._go.transform
	arg0_2._hollowTpl = arg0_2._tf:Find("ink_tpl")
	arg0_2._hollowContainer = arg0_2._tf:Find("container")
	arg0_2._unitHollowList = {}
	arg0_2._state = var2_0.ANIMATION_STATE_IDLE
end

function var2_0.IsActive(arg0_3)
	return arg0_3._isActive
end

function var2_0.Update(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4._unitHollowList) do
		if iter0_4:IsAlive() then
			local var0_4 = iter1_4.pos
			local var1_4 = iter1_4.hollow
			local var2_4 = var0_4:Copy(iter0_4:GetPosition())

			var1_4.position = var1_0.CameraPosToUICamera(var2_4 + Vector3(0, 0, 0))
		else
			arg0_4:RemoveHollow(iter0_4)
		end
	end
end

function var2_0.SetActive(arg0_5, arg1_5, arg2_5)
	arg0_5._isActive = arg1_5

	if arg1_5 then
		arg0_5._state = var2_0.ANIMATION_STATE_INITIAL

		for iter0_5, iter1_5 in ipairs(arg2_5) do
			arg0_5:AddHollow(iter1_5)
		end

		setActive(arg0_5._go, true)
	else
		local var0_5 = true

		for iter2_5, iter3_5 in pairs(arg0_5._unitHollowList) do
			local var1_5 = iter3_5.hollow

			local function var2_5()
				arg0_5:RemoveHollow(iter2_5)
				setActive(arg0_5._go, false)

				arg0_5._state = var2_0.ANIMATION_STATE_IDLE
			end

			arg0_5.doHollowScaleAnima(var1_5, 125, 0.3, var0_5 and var2_5 or nil)

			var0_5 = false
		end
	end
end

function var2_0.AddHollow(arg0_7, arg1_7)
	local var0_7 = arg1_7:GetAttrByName("blindedHorizon")
	local var1_7 = arg0_7._unitHollowList[arg1_7]

	if var1_7 then
		if var1_7.range ~= var0_7 then
			arg0_7.doHollowScaleAnima(var1_7.hollow, var0_7)
		end

		var1_7.range = var0_7

		return
	elseif var0_7 == 0 then
		return
	end

	local var2_7 = {}
	local var3_7 = cloneTplTo(arg0_7._hollowTpl, arg0_7._hollowContainer)

	var3_7.localScale = Vector3(125, 125, 0)

	arg0_7.doHollowScaleAnima(var3_7, var0_7)

	local var4_7 = Vector3.zero

	var4_7:Copy(arg1_7:GetPosition())

	var2_7.range = var0_7
	var2_7.hollow = var3_7
	var2_7.pos = var4_7
	arg0_7._unitHollowList[arg1_7] = var2_7
end

function var2_0.RemoveHollow(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8._unitHollowList[arg1_8].hollow.gameObject

	LeanTween.cancel(var0_8)
	Destroy(var0_8)

	arg0_8._unitHollowList[arg1_8] = nil
end

function var2_0.UpdateHollow(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg1_9) do
		arg0_9:AddHollow(iter1_9)
	end
end

function var2_0.doHollowScaleAnima(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg2_10 or 0.5

	LeanTween.cancel(go(arg0_10))

	local var1_10 = LeanTween.scale(arg0_10, Vector3(arg1_10, arg1_10, 0), var0_10)

	if arg3_10 then
		var1_10:setOnComplete(System.Action(function()
			arg3_10()
		end))
	end
end

function var2_0.Dispose(arg0_12)
	arg0_12:SetActive(false)

	for iter0_12, iter1_12 in pairs(arg0_12._unitHollowList) do
		local var0_12 = iter1_12.hollow.gameObject

		LeanTween.cancel(var0_12)
		Destroy(var0_12)
	end

	arg0_12._go = nil
	arg0_12._tf = nil
	arg0_12._unitHollowList = nil
end
