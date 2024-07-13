local var0_0 = class("ShipExpLayer", import("..base.BaseUI"))

var0_0.TypeDefault = 0
var0_0.TypeClass = 1

function var0_0.getUIName(arg0_1)
	return "ShipExpUI"
end

function var0_0.init(arg0_2)
	arg0_2._grade = arg0_2:findTF("grade")
	arg0_2._gradeLabel = arg0_2:findTF("label", arg0_2._grade)
	arg0_2._levelText = arg0_2:findTF("Text", arg0_2._grade)
	arg0_2._main = arg0_2:findTF("main")
	arg0_2._leftPanel = arg0_2:findTF("leftPanel", arg0_2._main)
	arg0_2._topBar = arg0_2:findTF("topBar", arg0_2._leftPanel)
	arg0_2._expResult = arg0_2:findTF("expResult", arg0_2._leftPanel)
	arg0_2._expContainer = arg0_2:findTF("expContainer", arg0_2._expResult)
	arg0_2._extpl = arg0_2:getTpl("ShipCardTpl", arg0_2._expContainer)
	arg0_2._skipBtn = arg0_2:findTF("skipLayer")

	setActive(arg0_2._topBar, false)
end

function var0_0.didEnter(arg0_3)
	arg0_3.tweenTFs = {}
	arg0_3.timerId = {}

	onButton(arg0_3, arg0_3._skipBtn, function()
		arg0_3:skip()
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
	arg0_3:display()
end

function var0_0.display(arg0_5)
	setActive(arg0_5._grade, true)
	setText(arg0_5._levelText, arg0_5.contextData.title)

	if arg0_5.contextData.type == var0_0.TypeClass then
		setActive(arg0_5._gradeLabel, false)
	else
		setActive(arg0_5._gradeLabel, true)

		local var0_5 = arg0_5.contextData.isCri and "grade_label_task_perfect" or "grade_label_task_complete"

		LoadImageSpriteAsync("battlescore/" .. var0_5, arg0_5._gradeLabel, true)
	end

	local var1_5 = arg0_5.contextData.top

	setActive(arg0_5._topBar, var1_5)

	if var1_5 then
		setText(arg0_5._topBar:Find("text_1"), var1_5.text1)
		setText(arg0_5._topBar:Find("text_2"), var1_5.text2)
		setText(arg0_5._topBar:Find("text_3"), var1_5.text3)

		arg0_5._topBar:Find("progress"):GetComponent(typeof(Image)).fillAmount = var1_5.progress
	end

	arg0_5._expTFs = {}
	arg0_5._skipExp = {}
	arg0_5._maxRightDelay = 0

	local var2_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.contextData.newShips) do
		var2_5[iter1_5.id] = iter1_5
	end

	local var3_5 = arg0_5.contextData.oldShips
	local var4_5 = 0.5

	for iter2_5, iter3_5 in ipairs(var3_5) do
		local var5_5 = var2_5[iter3_5.id]
		local var6_5 = cloneTplTo(arg0_5._extpl, arg0_5._expContainer)
		local var7_5 = var6_5.transform.anchoredPosition
		local var8_5 = rtf(var6_5).rect.width
		local var9_5 = findTF(var6_5, "content")

		var6_5.transform.anchoredPosition = Vector3(var7_5.x + (16.2 + var8_5) * (iter2_5 - 1), var7_5.y, var7_5.z)
		arg0_5._expTFs[#arg0_5._expTFs + 1] = var6_5

		flushShipCard(var6_5, iter3_5)
		setScrollText(findTF(var9_5, "info/name_mask/name"), iter3_5:GetColorName())

		local var10_5 = findTF(var9_5, "dockyard/lv/Text")
		local var11_5 = findTF(var9_5, "dockyard/lv_bg/levelUpLabel")
		local var12_5 = findTF(var9_5, "dockyard/lv_bg/levelup")

		setText(var10_5, iter3_5.level)

		local var13_5 = findTF(var9_5, "exp")
		local var14_5 = findTF(var13_5, "exp_text")
		local var15_5 = findTF(var13_5, "exp_progress")

		arg0_5._maxRightDelay = math.max(arg0_5._maxRightDelay, var5_5.level - iter3_5.level + iter2_5 * 0.5)

		local function var16_5()
			SetActive(var13_5, true)

			local var0_6 = iter3_5:getLevelExpConfig().exp
			local var1_6 = var5_5:getLevelExpConfig().exp

			var15_5:GetComponent(typeof(Image)).fillAmount = iter3_5.exp / var0_6

			if iter3_5.level < var5_5.level then
				local var2_6 = 0

				for iter0_6 = iter3_5.level, var5_5.level - 1 do
					var2_6 = var2_6 + iter3_5:getLevelExpConfig(iter0_6).exp
				end

				arg0_5:PlayAnimation(var6_5, 0, var2_6 + var5_5.exp - iter3_5.exp, 1, 0, function(arg0_7)
					setText(var14_5, "+" .. math.ceil(arg0_7))
				end)

				local function var3_6(arg0_8)
					SetActive(var11_5, true)
					SetActive(var12_5, true)

					local var0_8 = var11_5.localPosition

					LeanTween.moveY(rtf(var11_5), var0_8.y + 30, 0.5):setOnComplete(System.Action(function()
						SetActive(var11_5, false)

						var11_5.localPosition = var0_8

						pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)
					end))
					setText(var10_5, arg0_8)
					table.insert(arg0_5.tweenTFs, var11_5)
				end

				LeanTween.value(go(var6_5), iter3_5.exp / var0_6, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_10)
					var15_5:GetComponent(typeof(Image)).fillAmount = arg0_10
				end)):setOnComplete(System.Action(function()
					local var0_11 = iter3_5.level + 1

					var3_6(var0_11)

					local var1_11 = var0_11 + 1
					local var2_11 = 0.1

					while var1_11 <= var5_5.level do
						local var3_11 = var1_11

						LeanTween.value(go(var6_5), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_12)
							var15_5:GetComponent(typeof(Image)).fillAmount = arg0_12
						end)):setDelay(var2_11):setOnComplete(System.Action(function()
							var3_6(var3_11)
						end))

						var2_11 = var2_11 + 1
						var1_11 = var1_11 + 1
					end

					arg0_5.timerId[iter3_5.id] = pg.TimeMgr.GetInstance():AddTimer("delayTimer", var2_11, 0, function()
						if var5_5.level == var5_5:getMaxLevel() then
							var15_5:GetComponent(typeof(Image)).fillAmount = 1
							arg0_5._skipExp[iter2_5] = false

							return
						end

						arg0_5:PlayAnimation(var6_5, 0, var5_5.exp / var1_6, 0.5, 0, function(arg0_15)
							var15_5:GetComponent(typeof(Image)).fillAmount = arg0_15
							arg0_5._skipExp[iter2_5] = false
						end)
					end)
				end))
				table.insert(arg0_5.tweenTFs, var6_5)
			else
				local var4_6 = math.ceil(var5_5:getExp() - iter3_5:getExp())

				setText(var14_5, "+" .. var4_6)

				if iter3_5.level == iter3_5:getMaxLevel() then
					var15_5:GetComponent(typeof(Image)).fillAmount = 1
					arg0_5._skipExp[iter2_5] = false

					return
				end

				arg0_5:PlayAnimation(var6_5, iter3_5.exp / var0_6, var5_5.exp / var0_6, 1, 0, function(arg0_16)
					var15_5:GetComponent(typeof(Image)).fillAmount = arg0_16
					arg0_5._skipExp[iter2_5] = false
				end)
			end
		end

		arg0_5._skipExp[iter2_5] = function()
			LeanTween.cancel(go(var11_5))
			LeanTween.cancel(go(var6_5))
			SetActive(var6_5, true)
			SetActive(var13_5, true)
			setText(var10_5, var5_5.level)

			if iter3_5.level == iter3_5:getMaxLevel() then
				setText(var14_5, "+" .. math.ceil(var5_5:getExp() - iter3_5:getExp()))

				var15_5:GetComponent(typeof(Image)).fillAmount = 1
			else
				if iter3_5.level < var5_5.level then
					local var0_17 = 0

					for iter0_17 = iter3_5.level, var5_5.level - 1 do
						var0_17 = var0_17 + iter3_5:getLevelExpConfig(iter0_17).exp
					end

					setText(var14_5, "+" .. var0_17 + var5_5.exp - iter3_5.exp)
				else
					setText(var14_5, "+" .. math.ceil(var5_5.exp - iter3_5.exp))
				end

				var15_5:GetComponent(typeof(Image)).fillAmount = var5_5.exp / var5_5:getLevelExpConfig().exp
			end

			SetActive(var11_5, false)

			var6_5:GetComponent("CanvasGroup").alpha = 1
			rtf(var6_5).anchoredPosition = Vector2(rtf(var6_5).anchoredPosition.x, 0)
		end

		local var17_5 = var6_5:GetComponent("CanvasGroup")
		local var18_5 = iter2_5 * 0.2

		setActive(var6_5, false)
		LeanTween.moveY(rtf(var6_5), 0, 0.2):setOnComplete(System.Action(function()
			setActive(var6_5, true)
			var16_5()
		end)):setDelay(var18_5)
		table.insert(arg0_5.tweenTFs, var6_5)
		LeanTween.value(go(var6_5), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_19)
			var17_5.alpha = arg0_19
		end)):setDelay(var18_5)
	end
end

function var0_0.skip(arg0_20)
	if _.any(arg0_20._skipExp, function(arg0_21)
		return arg0_21
	end) then
		for iter0_20 = 1, #arg0_20._skipExp do
			if arg0_20._skipExp[iter0_20] then
				arg0_20._skipExp[iter0_20]()

				arg0_20._skipExp[iter0_20] = false
			end
		end
	else
		arg0_20:emit(BaseUI.ON_CLOSE)
	end
end

function var0_0.PlayAnimation(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22, arg5_22, arg6_22)
	LeanTween.value(arg1_22.gameObject, arg2_22, arg3_22, arg4_22):setDelay(arg5_22):setOnUpdate(System.Action_float(function(arg0_23)
		arg6_22(arg0_23)
	end))
	table.insert(arg0_22.tweenTFs, arg1_22)
end

function var0_0.willExit(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.tweenTFs) do
		if LeanTween.isTweening(go(iter1_24)) then
			LeanTween.cancel(go(iter1_24))
		end
	end

	arg0_24.tweenTFs = nil

	for iter2_24, iter3_24 in pairs(arg0_24.timerId) do
		pg.TimeMgr.GetInstance():RemoveTimer(iter3_24)
	end

	arg0_24.timerId = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_24._tf)
end

return var0_0
