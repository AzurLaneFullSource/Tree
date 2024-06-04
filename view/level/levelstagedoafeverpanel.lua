local var0 = class("LevelStageDOAFeverPanel", import("view.base.BaseSubPanel"))

function var0.getUIName(arg0)
	return "LevelStageDOAFeverPanel"
end

function var0.OnInit(arg0)
	arg0.fillImg = arg0._tf:Find("Fill")
	arg0.maxImg = arg0._tf:Find("Max")

	setActive(arg0.maxImg, false)

	arg0.ratioText = arg0._tf:Find("Text")
	arg0.banner = arg0._tf:Find("Banner")

	setActive(arg0.banner, false)

	local var0 = GetComponent(arg0._tf, typeof(ItemList))

	cloneTplTo(var0.prefabItem[0], arg0.fillImg, "Anim")

	arg0.fillAnim = arg0.fillImg:GetChild(0)

	cloneTplTo(var0.prefabItem[1], arg0.maxImg)
end

function var0.UpdateView(arg0, arg1, arg2)
	local var0 = getProxy(ChapterProxy):GetLastDefeatedEnemy(arg1.id)
	local var1 = arg1.defeatEnemies
	local var2 = pg.gameset.doa_fever_count.key_value
	local var3 = var1 / var2
	local var4 = var2 <= var1

	seriesAsync({
		function(arg0)
			LeanTween.cancel(go(arg0.fillImg), true)

			if not var0 or var1 > var2 then
				arg0()

				return
			end

			setActive(arg0.maxImg, false)
			setActive(arg0.fillImg, true)
			setActive(arg0.ratioText, true)
			setActive(arg0.fillAnim, true)

			local var0 = math.max(var1 - 1, 0)
			local var1 = arg0.fillImg:GetComponent(typeof(Image))
			local var2 = arg0.fillImg.rect.height
			local var3 = var2
			local var4 = arg0.fillAnim.rect.height
			local var5 = 3.11526479750779

			LeanTween.value(go(arg0.fillImg), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
				local var0 = Mathf.Lerp(var0, var1, arg0) / var2
				local var1 = var0 * var2

				arg0.fillAnim.anchoredPosition = Vector2(0, var1)

				local var2 = math.sqrt(math.max(var3 * var3 - var1 * var1, 0)) * var5
				local var3 = math.min(1.5 - arg0, 1) * var4

				arg0.fillAnim.sizeDelta = Vector2(var2, var3)
				var1.fillAmount = var0

				setText(arg0.ratioText, string.format("%02d.%d%%", math.floor(var0 * 100), math.round(var0 * 1000) % 10))
			end)):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			setActive(arg0.fillImg, not var4)
			setActive(arg0.ratioText, not var4)
			setActive(arg0.maxImg, var4)
			setActive(arg0.fillAnim, false)

			arg0.fillImg:GetComponent(typeof(Image)).fillAmount = var3

			setText(arg0.ratioText, string.format("%02d.%d%%", math.floor(var3 * 100), math.round(var3 * 1000) % 10))

			if var0 and var1 == var2 then
				arg0.viewParent:emit(LevelUIConst.FROZEN)
				pg.UIMgr.GetInstance():OverlayPanel(arg0.banner)

				local var0 = arg0.banner:Find("Main/Painting")
				local var1 = var0:GetComponent(typeof(Image))
				local var2 = math.random(1, 7)

				setImageSprite(var0, LoadSprite("ui/LevelStageDOAFeverPanel_atlas", tostring(var2)), true)
				setActive(arg0.banner, true)

				var1.enabled = true

				local function var3()
					var1.enabled = false
					var1.sprite = nil

					pg.UIMgr.GetInstance():UnOverlayPanel(arg0.banner, arg0._tf)
					setActive(arg0.banner, false)
					arg0.viewParent:emit(LevelUIConst.UN_FROZEN)
					arg0()
				end

				arg0.banner:GetComponent(typeof(DftAniEvent)):SetEndEvent(var3)
				onButton(arg0, arg0.banner, var3)
			else
				arg0()
			end
		end,
		arg2
	})
end

return var0
