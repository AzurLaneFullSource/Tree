local var0 = class("ShipExpLayer", import("..base.BaseUI"))

var0.TypeDefault = 0
var0.TypeClass = 1

function var0.getUIName(arg0)
	return "ShipExpUI"
end

function var0.init(arg0)
	arg0._grade = arg0:findTF("grade")
	arg0._gradeLabel = arg0:findTF("label", arg0._grade)
	arg0._levelText = arg0:findTF("Text", arg0._grade)
	arg0._main = arg0:findTF("main")
	arg0._leftPanel = arg0:findTF("leftPanel", arg0._main)
	arg0._topBar = arg0:findTF("topBar", arg0._leftPanel)
	arg0._expResult = arg0:findTF("expResult", arg0._leftPanel)
	arg0._expContainer = arg0:findTF("expContainer", arg0._expResult)
	arg0._extpl = arg0:getTpl("ShipCardTpl", arg0._expContainer)
	arg0._skipBtn = arg0:findTF("skipLayer")

	setActive(arg0._topBar, false)
end

function var0.didEnter(arg0)
	arg0.tweenTFs = {}
	arg0.timerId = {}

	onButton(arg0, arg0._skipBtn, function()
		arg0:skip()
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
	arg0:display()
end

function var0.display(arg0)
	setActive(arg0._grade, true)
	setText(arg0._levelText, arg0.contextData.title)

	if arg0.contextData.type == var0.TypeClass then
		setActive(arg0._gradeLabel, false)
	else
		setActive(arg0._gradeLabel, true)

		local var0 = arg0.contextData.isCri and "grade_label_task_perfect" or "grade_label_task_complete"

		LoadImageSpriteAsync("battlescore/" .. var0, arg0._gradeLabel, true)
	end

	local var1 = arg0.contextData.top

	setActive(arg0._topBar, var1)

	if var1 then
		setText(arg0._topBar:Find("text_1"), var1.text1)
		setText(arg0._topBar:Find("text_2"), var1.text2)
		setText(arg0._topBar:Find("text_3"), var1.text3)

		arg0._topBar:Find("progress"):GetComponent(typeof(Image)).fillAmount = var1.progress
	end

	arg0._expTFs = {}
	arg0._skipExp = {}
	arg0._maxRightDelay = 0

	local var2 = {}

	for iter0, iter1 in ipairs(arg0.contextData.newShips) do
		var2[iter1.id] = iter1
	end

	local var3 = arg0.contextData.oldShips
	local var4 = 0.5

	for iter2, iter3 in ipairs(var3) do
		local var5 = var2[iter3.id]
		local var6 = cloneTplTo(arg0._extpl, arg0._expContainer)
		local var7 = var6.transform.anchoredPosition
		local var8 = rtf(var6).rect.width
		local var9 = findTF(var6, "content")

		var6.transform.anchoredPosition = Vector3(var7.x + (16.2 + var8) * (iter2 - 1), var7.y, var7.z)
		arg0._expTFs[#arg0._expTFs + 1] = var6

		flushShipCard(var6, iter3)
		setScrollText(findTF(var9, "info/name_mask/name"), iter3:GetColorName())

		local var10 = findTF(var9, "dockyard/lv/Text")
		local var11 = findTF(var9, "dockyard/lv_bg/levelUpLabel")
		local var12 = findTF(var9, "dockyard/lv_bg/levelup")

		setText(var10, iter3.level)

		local var13 = findTF(var9, "exp")
		local var14 = findTF(var13, "exp_text")
		local var15 = findTF(var13, "exp_progress")

		arg0._maxRightDelay = math.max(arg0._maxRightDelay, var5.level - iter3.level + iter2 * 0.5)

		local function var16()
			SetActive(var13, true)

			local var0 = iter3:getLevelExpConfig().exp
			local var1 = var5:getLevelExpConfig().exp

			var15:GetComponent(typeof(Image)).fillAmount = iter3.exp / var0

			if iter3.level < var5.level then
				local var2 = 0

				for iter0 = iter3.level, var5.level - 1 do
					var2 = var2 + iter3:getLevelExpConfig(iter0).exp
				end

				arg0:PlayAnimation(var6, 0, var2 + var5.exp - iter3.exp, 1, 0, function(arg0)
					setText(var14, "+" .. math.ceil(arg0))
				end)

				local function var3(arg0)
					SetActive(var11, true)
					SetActive(var12, true)

					local var0 = var11.localPosition

					LeanTween.moveY(rtf(var11), var0.y + 30, 0.5):setOnComplete(System.Action(function()
						SetActive(var11, false)

						var11.localPosition = var0

						pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)
					end))
					setText(var10, arg0)
					table.insert(arg0.tweenTFs, var11)
				end

				LeanTween.value(go(var6), iter3.exp / var0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0)
					var15:GetComponent(typeof(Image)).fillAmount = arg0
				end)):setOnComplete(System.Action(function()
					local var0 = iter3.level + 1

					var3(var0)

					local var1 = var0 + 1
					local var2 = 0.1

					while var1 <= var5.level do
						local var3 = var1

						LeanTween.value(go(var6), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
							var15:GetComponent(typeof(Image)).fillAmount = arg0
						end)):setDelay(var2):setOnComplete(System.Action(function()
							var3(var3)
						end))

						var2 = var2 + 1
						var1 = var1 + 1
					end

					arg0.timerId[iter3.id] = pg.TimeMgr.GetInstance():AddTimer("delayTimer", var2, 0, function()
						if var5.level == var5:getMaxLevel() then
							var15:GetComponent(typeof(Image)).fillAmount = 1
							arg0._skipExp[iter2] = false

							return
						end

						arg0:PlayAnimation(var6, 0, var5.exp / var1, 0.5, 0, function(arg0)
							var15:GetComponent(typeof(Image)).fillAmount = arg0
							arg0._skipExp[iter2] = false
						end)
					end)
				end))
				table.insert(arg0.tweenTFs, var6)
			else
				local var4 = math.ceil(var5:getExp() - iter3:getExp())

				setText(var14, "+" .. var4)

				if iter3.level == iter3:getMaxLevel() then
					var15:GetComponent(typeof(Image)).fillAmount = 1
					arg0._skipExp[iter2] = false

					return
				end

				arg0:PlayAnimation(var6, iter3.exp / var0, var5.exp / var0, 1, 0, function(arg0)
					var15:GetComponent(typeof(Image)).fillAmount = arg0
					arg0._skipExp[iter2] = false
				end)
			end
		end

		arg0._skipExp[iter2] = function()
			LeanTween.cancel(go(var11))
			LeanTween.cancel(go(var6))
			SetActive(var6, true)
			SetActive(var13, true)
			setText(var10, var5.level)

			if iter3.level == iter3:getMaxLevel() then
				setText(var14, "+" .. math.ceil(var5:getExp() - iter3:getExp()))

				var15:GetComponent(typeof(Image)).fillAmount = 1
			else
				if iter3.level < var5.level then
					local var0 = 0

					for iter0 = iter3.level, var5.level - 1 do
						var0 = var0 + iter3:getLevelExpConfig(iter0).exp
					end

					setText(var14, "+" .. var0 + var5.exp - iter3.exp)
				else
					setText(var14, "+" .. math.ceil(var5.exp - iter3.exp))
				end

				var15:GetComponent(typeof(Image)).fillAmount = var5.exp / var5:getLevelExpConfig().exp
			end

			SetActive(var11, false)

			var6:GetComponent("CanvasGroup").alpha = 1
			rtf(var6).anchoredPosition = Vector2(rtf(var6).anchoredPosition.x, 0)
		end

		local var17 = var6:GetComponent("CanvasGroup")
		local var18 = iter2 * 0.2

		setActive(var6, false)
		LeanTween.moveY(rtf(var6), 0, 0.2):setOnComplete(System.Action(function()
			setActive(var6, true)
			var16()
		end)):setDelay(var18)
		table.insert(arg0.tweenTFs, var6)
		LeanTween.value(go(var6), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0)
			var17.alpha = arg0
		end)):setDelay(var18)
	end
end

function var0.skip(arg0)
	if _.any(arg0._skipExp, function(arg0)
		return arg0
	end) then
		for iter0 = 1, #arg0._skipExp do
			if arg0._skipExp[iter0] then
				arg0._skipExp[iter0]()

				arg0._skipExp[iter0] = false
			end
		end
	else
		arg0:emit(BaseUI.ON_CLOSE)
	end
end

function var0.PlayAnimation(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	LeanTween.value(arg1.gameObject, arg2, arg3, arg4):setDelay(arg5):setOnUpdate(System.Action_float(function(arg0)
		arg6(arg0)
	end))
	table.insert(arg0.tweenTFs, arg1)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.tweenTFs) do
		if LeanTween.isTweening(go(iter1)) then
			LeanTween.cancel(go(iter1))
		end
	end

	arg0.tweenTFs = nil

	for iter2, iter3 in pairs(arg0.timerId) do
		pg.TimeMgr.GetInstance():RemoveTimer(iter3)
	end

	arg0.timerId = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
