local var0_0 = class("LevelStageDOAFeverPanel", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "LevelStageDOAFeverPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.fillImg = arg0_2._tf:Find("Fill")
	arg0_2.maxImg = arg0_2._tf:Find("Max")

	setActive(arg0_2.maxImg, false)

	arg0_2.ratioText = arg0_2._tf:Find("Text")
	arg0_2.banner = arg0_2._tf:Find("Banner")

	setActive(arg0_2.banner, false)

	local var0_2 = GetComponent(arg0_2._tf, typeof(ItemList))

	cloneTplTo(var0_2.prefabItem[0], arg0_2.fillImg, "Anim")

	arg0_2.fillAnim = arg0_2.fillImg:GetChild(0)

	cloneTplTo(var0_2.prefabItem[1], arg0_2.maxImg)
end

function var0_0.UpdateView(arg0_3, arg1_3, arg2_3)
	local var0_3 = getProxy(ChapterProxy):GetLastDefeatedEnemy(arg1_3.id)
	local var1_3 = arg1_3.defeatEnemies
	local var2_3 = pg.gameset.doa_fever_count.key_value
	local var3_3 = var1_3 / var2_3
	local var4_3 = var2_3 <= var1_3

	seriesAsync({
		function(arg0_4)
			LeanTween.cancel(go(arg0_3.fillImg), true)

			if not var0_3 or var1_3 > var2_3 then
				arg0_4()

				return
			end

			setActive(arg0_3.maxImg, false)
			setActive(arg0_3.fillImg, true)
			setActive(arg0_3.ratioText, true)
			setActive(arg0_3.fillAnim, true)

			local var0_4 = math.max(var1_3 - 1, 0)
			local var1_4 = arg0_3.fillImg:GetComponent(typeof(Image))
			local var2_4 = arg0_3.fillImg.rect.height
			local var3_4 = var2_4
			local var4_4 = arg0_3.fillAnim.rect.height
			local var5_4 = 3.11526479750779

			LeanTween.value(go(arg0_3.fillImg), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_5)
				local var0_5 = Mathf.Lerp(var0_4, var1_3, arg0_5) / var2_3
				local var1_5 = var0_5 * var2_4

				arg0_3.fillAnim.anchoredPosition = Vector2(0, var1_5)

				local var2_5 = math.sqrt(math.max(var3_4 * var3_4 - var1_5 * var1_5, 0)) * var5_4
				local var3_5 = math.min(1.5 - arg0_5, 1) * var4_4

				arg0_3.fillAnim.sizeDelta = Vector2(var2_5, var3_5)
				var1_4.fillAmount = var0_5

				setText(arg0_3.ratioText, string.format("%02d.%d%%", math.floor(var0_5 * 100), math.round(var0_5 * 1000) % 10))
			end)):setOnComplete(System.Action(arg0_4))
		end,
		function(arg0_6)
			setActive(arg0_3.fillImg, not var4_3)
			setActive(arg0_3.ratioText, not var4_3)
			setActive(arg0_3.maxImg, var4_3)
			setActive(arg0_3.fillAnim, false)

			arg0_3.fillImg:GetComponent(typeof(Image)).fillAmount = var3_3

			setText(arg0_3.ratioText, string.format("%02d.%d%%", math.floor(var3_3 * 100), math.round(var3_3 * 1000) % 10))

			if var0_3 and var1_3 == var2_3 then
				arg0_3.viewParent:emit(LevelUIConst.FROZEN)
				pg.UIMgr.GetInstance():OverlayPanel(arg0_3.banner)

				local var0_6 = arg0_3.banner:Find("Main/Painting")
				local var1_6 = var0_6:GetComponent(typeof(Image))
				local var2_6 = math.random(1, 7)

				setImageSprite(var0_6, LoadSprite("ui/LevelStageDOAFeverPanel_atlas", tostring(var2_6)), true)
				setActive(arg0_3.banner, true)

				var1_6.enabled = true

				local function var3_6()
					var1_6.enabled = false
					var1_6.sprite = nil

					pg.UIMgr.GetInstance():UnOverlayPanel(arg0_3.banner, arg0_3._tf)
					setActive(arg0_3.banner, false)
					arg0_3.viewParent:emit(LevelUIConst.UN_FROZEN)
					arg0_6()
				end

				arg0_3.banner:GetComponent(typeof(DftAniEvent)):SetEndEvent(var3_6)
				onButton(arg0_3, arg0_3.banner, var3_6)
			else
				arg0_6()
			end
		end,
		arg2_3
	})
end

return var0_0
