ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.BattleMainDamagedView = class("BattleMainDamagedView")

local var2 = class("BattleMainDamagedView")

var0.Battle.BattleMainDamagedView = var2
var2.__name = "BattleMainDamagedView"

function var2.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:Init()
end

function var2.Init(arg0)
	arg0._tf = arg0._go.transform
	arg0._bleedView = findTF(arg0._tf, "mainUnitDamaged")
	arg0._bleedAnimation = arg0._bleedView:GetComponent(typeof(Animator))

	arg0._bleedView:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		setActive(arg0._bleedView, false)

		arg0._isPlaying = false
	end)
	setActive(arg0._bleedView, false)

	arg0._isPlaying = false
end

function var2.Play(arg0)
	if not arg0._isPlaying then
		setActive(arg0._bleedView, true)
	end

	arg0._isPlaying = true
end

function var2.Dispose(arg0)
	arg0._bleedView = nil
	arg0._bleedAnimation = nil
	arg0._tf = nil
	arg0._go = nil
end
