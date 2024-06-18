local var0_0 = class("ActivityBossAisaikesiScene", import(".ActivityBossSceneTemplate"))

var0_0.ASKSRemasterStage = 1201204

function var0_0.getUIName(arg0_1)
	return "ActivityBossAisaikesiUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)

	local var0_3 = 0

	onButton(arg0_3, arg0_3.mainTF:Find("logo"), function()
		var0_3 = var0_3 + 1

		if var0_3 >= 10 then
			arg0_3:RemasterSuffering()

			var0_3 = 0

			return
		end

		pg.TipsMgr.GetInstance():ShowTips(10 - var0_3)
	end)
end

function var0_0.UpdatePage(arg0_5)
	var0_0.super.UpdatePage(arg0_5)
end

function var0_0.EnterAnim(arg0_6)
	local function var0_6()
		var0_0.super.EnterAnim(arg0_6)
		arg0_6.loader:GetPrefab("ui/ASKS_Loop", "", function(arg0_8)
			setParent(arg0_8, arg0_6.mainTF)
			setAnchoredPosition(arg0_8, {
				x = -154.7,
				y = -120.9
			})
			tf(arg0_8):SetAsFirstSibling()

			arg0_6.raidarAnim = arg0_8

			setActive(arg0_8, true)
		end)
	end

	if not arg0_6.contextData.showAni then
		var0_6()

		return
	end

	arg0_6.contextData.showAni = nil

	local var1_6 = arg0_6.mainTF:Find("logo")

	setActive(var1_6, false)

	local var2_6

	local function var3_6()
		setActive(var1_6, true)
		setActive(var2_6, false)
		arg0_6.loader:ReturnPrefab(var2_6)
	end

	arg0_6.loader:GetPrefab("ui/asks", "asks", function(arg0_10)
		setParent(arg0_10, arg0_6._tf)

		var2_6 = arg0_10

		local var0_10
		local var1_10 = arg0_10:GetComponent("DftAniEvent")

		var1_10:SetEndEvent(var3_6)
		var1_10:SetTriggerEvent(function()
			var0_6()

			var0_10 = true
		end)
		onButton(arg0_6, arg0_10, function()
			var0_10 = var0_10 or var0_6() or true

			var3_6()
		end)
	end)
end

function var0_0.RemasterSuffering(arg0_13)
	local var0_13 = GameObject.New("Mask")
	local var1_13 = var0_13:AddComponent(typeof(RectTransform))

	var1_13.anchorMin = Vector2.zero
	var1_13.anchorMax = Vector2.one

	local var2_13 = var0_13:AddComponent(typeof(Image))

	var2_13.color = Color.New(0, 0, 0, 1)
	var2_13.raycastTarget = false

	var1_13:SetParent(arg0_13._tf)
	pg.NewStoryMgr.GetInstance():Play("AISAIKESICAIDAN", function()
		arg0_13:emit(arg0_13.contextData.mediatorClass.ON_PERFORM_COMBAT, arg0_13.ASKSRemasterStage)
	end)
end

function var0_0.willExit(arg0_15)
	arg0_15.loader:Clear()
	var0_0.super.willExit(arg0_15)
end

return var0_0
