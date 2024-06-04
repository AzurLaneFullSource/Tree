local var0 = class("ActivityBossAisaikesiScene", import(".ActivityBossSceneTemplate"))

var0.ASKSRemasterStage = 1201204

function var0.getUIName(arg0)
	return "ActivityBossAisaikesiUI"
end

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)

	local var0 = 0

	onButton(arg0, arg0.mainTF:Find("logo"), function()
		var0 = var0 + 1

		if var0 >= 10 then
			arg0:RemasterSuffering()

			var0 = 0

			return
		end

		pg.TipsMgr.GetInstance():ShowTips(10 - var0)
	end)
end

function var0.UpdatePage(arg0)
	var0.super.UpdatePage(arg0)
end

function var0.EnterAnim(arg0)
	local var0 = function()
		var0.super.EnterAnim(arg0)
		arg0.loader:GetPrefab("ui/ASKS_Loop", "", function(arg0)
			setParent(arg0, arg0.mainTF)
			setAnchoredPosition(arg0, {
				x = -154.7,
				y = -120.9
			})
			tf(arg0):SetAsFirstSibling()

			arg0.raidarAnim = arg0

			setActive(arg0, true)
		end)
	end

	if not arg0.contextData.showAni then
		var0()

		return
	end

	arg0.contextData.showAni = nil

	local var1 = arg0.mainTF:Find("logo")

	setActive(var1, false)

	local var2

	local function var3()
		setActive(var1, true)
		setActive(var2, false)
		arg0.loader:ReturnPrefab(var2)
	end

	arg0.loader:GetPrefab("ui/asks", "asks", function(arg0)
		setParent(arg0, arg0._tf)

		var2 = arg0

		local var0
		local var1 = arg0:GetComponent("DftAniEvent")

		var1:SetEndEvent(var3)
		var1:SetTriggerEvent(function()
			var0()

			var0 = true
		end)
		onButton(arg0, arg0, function()
			var0 = var0 or var0() or true

			var3()
		end)
	end)
end

function var0.RemasterSuffering(arg0)
	local var0 = GameObject.New("Mask")
	local var1 = var0:AddComponent(typeof(RectTransform))

	var1.anchorMin = Vector2.zero
	var1.anchorMax = Vector2.one

	local var2 = var0:AddComponent(typeof(Image))

	var2.color = Color.New(0, 0, 0, 1)
	var2.raycastTarget = false

	var1:SetParent(arg0._tf)
	pg.NewStoryMgr.GetInstance():Play("AISAIKESICAIDAN", function()
		arg0:emit(arg0.contextData.mediatorClass.ON_PERFORM_COMBAT, arg0.ASKSRemasterStage)
	end)
end

function var0.willExit(arg0)
	arg0.loader:Clear()
	var0.super.willExit(arg0)
end

return var0
