ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleVariable
local var2 = class("BattleInkView")

var0.Battle.BattleInkView = var2
var2.__name = "BattleInkView"
var2.ANIMATION_STATE_INITIAL = "intial"
var2.ANIMATION_STATE_IDLE = "idle"
var2.ANIMATION_STATE_FINALE = "int"

function var2.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:init()
end

function var2.init(arg0)
	arg0._tf = arg0._go.transform
	arg0._hollowTpl = arg0._tf:Find("ink_tpl")
	arg0._hollowContainer = arg0._tf:Find("container")
	arg0._unitHollowList = {}
	arg0._state = var2.ANIMATION_STATE_IDLE
end

function var2.IsActive(arg0)
	return arg0._isActive
end

function var2.Update(arg0)
	for iter0, iter1 in pairs(arg0._unitHollowList) do
		if iter0:IsAlive() then
			local var0 = iter1.pos
			local var1 = iter1.hollow
			local var2 = var0:Copy(iter0:GetPosition())

			var1.position = var1.CameraPosToUICamera(var2 + Vector3(0, 0, 0))
		else
			arg0:RemoveHollow(iter0)
		end
	end
end

function var2.SetActive(arg0, arg1, arg2)
	arg0._isActive = arg1

	if arg1 then
		arg0._state = var2.ANIMATION_STATE_INITIAL

		for iter0, iter1 in ipairs(arg2) do
			arg0:AddHollow(iter1)
		end

		setActive(arg0._go, true)
	else
		local var0 = true

		for iter2, iter3 in pairs(arg0._unitHollowList) do
			local var1 = iter3.hollow
			local var2 = function()
				arg0:RemoveHollow(iter2)
				setActive(arg0._go, false)

				arg0._state = var2.ANIMATION_STATE_IDLE
			end

			arg0.doHollowScaleAnima(var1, 125, 0.3, var0 and var2 or nil)

			var0 = false
		end
	end
end

function var2.AddHollow(arg0, arg1)
	local var0 = arg1:GetAttrByName("blindedHorizon")
	local var1 = arg0._unitHollowList[arg1]

	if var1 then
		if var1.range ~= var0 then
			arg0.doHollowScaleAnima(var1.hollow, var0)
		end

		var1.range = var0

		return
	elseif var0 == 0 then
		return
	end

	local var2 = {}
	local var3 = cloneTplTo(arg0._hollowTpl, arg0._hollowContainer)

	var3.localScale = Vector3(125, 125, 0)

	arg0.doHollowScaleAnima(var3, var0)

	local var4 = Vector3.zero

	var4:Copy(arg1:GetPosition())

	var2.range = var0
	var2.hollow = var3
	var2.pos = var4
	arg0._unitHollowList[arg1] = var2
end

function var2.RemoveHollow(arg0, arg1, arg2)
	local var0 = arg0._unitHollowList[arg1].hollow.gameObject

	LeanTween.cancel(var0)
	Destroy(var0)

	arg0._unitHollowList[arg1] = nil
end

function var2.UpdateHollow(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:AddHollow(iter1)
	end
end

function var2.doHollowScaleAnima(arg0, arg1, arg2, arg3)
	local var0 = arg2 or 0.5

	LeanTween.cancel(go(arg0))

	local var1 = LeanTween.scale(arg0, Vector3(arg1, arg1, 0), var0)

	if arg3 then
		var1:setOnComplete(System.Action(function()
			arg3()
		end))
	end
end

function var2.Dispose(arg0)
	arg0:SetActive(false)

	for iter0, iter1 in pairs(arg0._unitHollowList) do
		local var0 = iter1.hollow.gameObject

		LeanTween.cancel(var0)
		Destroy(var0)
	end

	arg0._go = nil
	arg0._tf = nil
	arg0._unitHollowList = nil
end
