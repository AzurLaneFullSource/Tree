local var0_0 = class("MainPaintingLitUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._parent = arg1_1
	arg0_1._event = arg2_1
	arg0_1._partBtnMaxNum = 3
end

function var0_0.SetShip(arg0_2, arg1_2)
	arg0_2._ship = arg1_2
	arg0_2._paintingName = arg1_2:getPainting()
	arg0_2._shipId = arg1_2.id
	arg0_2._skinId = arg1_2:getSkinId()
	arg0_2._uiName = nil

	local var0_2 = SpinePaintingConst.painting_lit_data[arg0_2._paintingName] and SpinePaintingConst.painting_lit_data[arg0_2._paintingName].lit_ui

	if var0_2 and var0_2 ~= "" then
		arg0_2._uiName = var0_2
	else
		arg0_2._uiName = "mainpaintinglitui"
	end

	arg0_2._partNum = SpinePaintingConst.painting_lit_data[arg0_2._paintingName] and SpinePaintingConst.painting_lit_data[arg0_2._paintingName].part_num

	if not arg0_2._partNum or arg0_2._partNum == "" then
		arg0_2._partNum = {}
	end

	arg0_2:loadLitUI()
end

function var0_0.loadLitUI(arg0_3)
	if arg0_3._loading then
		return
	end

	if arg0_3._litUI then
		return
	end

	arg0_3._loading = true

	PoolMgr.GetInstance():GetUI(arg0_3._uiName, true, function(arg0_4)
		if arg0_3._isDispose then
			PoolMgr.GetInstance():ReturnUI(arg0_3._uiName, arg0_4)

			return
		end

		setParent(tf(arg0_4), arg0_3._parent)
		arg0_3:initLitUI(tf(arg0_4))

		arg0_3._loading = false

		if arg0_3._flushOnLoaded then
			arg0_3:Flush()
			arg0_3:Update()

			arg0_3._flushOnLoaded = false
		end

		arg0_3:SetVisible(false)
	end)
end

function var0_0.initLitUI(arg0_5, arg1_5)
	arg0_5._tf = arg1_5
	arg0_5._litUI = findTF(arg1_5, "ad")
	arg0_5._partBtnsTf = findTF(arg0_5._litUI, "part_btns")
	arg0_5._btnResetTf = findTF(arg0_5._litUI, "btn_reset")
	arg0_5._btnRemindTf = findTF(arg0_5._litUI, "btn_remind")
	arg0_5._sliderTf = findTF(arg0_5._litUI, "slider")
	arg0_5._sliderShowTf = findTF(arg0_5._litUI, "slider_show")
	arg0_5._fillMask = findTF(arg0_5._litUI, "slider_show/mask")

	if arg0_5._fillMask then
		arg0_5._fillImg = GetComponent(arg0_5._fillMask, typeof(Image))
	end

	arg0_5._fillMaskR = findTF(arg0_5._litUI, "slider_show/mask_r")

	if arg0_5._fillMaskR then
		arg0_5._fillImageR = GetComponent(arg0_5._fillMaskR, typeof(Image))
	end

	arg0_5._fillBarAnimator = GetComponent(findTF(arg0_5._litUI, "slider_show/bar"), typeof(Animator))
	arg0_5._fillBarAnimatorName = arg0_5._fillBarAnimator.runtimeAnimatorController.animationClips[0].name
	arg0_5._slider = findTF(arg0_5._litUI, "slider")

	setSlider(arg0_5._slider, 0, 1, SpinePaintingConst.painting_lit_value)
	onSlider(arg0_5._event, findTF(arg0_5._litUI, "slider"), function(arg0_6)
		arg0_5:onSliderValueUpdate(arg0_6)
	end)
	onButton(arg0_5._event, findTF(arg0_5._litUI, "btn_reset"), function()
		arg0_5:ClickResetBtn()
	end)

	for iter0_5 = 1, arg0_5._partBtnMaxNum do
		local var0_5 = iter0_5

		if var0_5 <= #arg0_5._partNum then
			setActive(findTF(arg0_5._litUI, "part_btns/" .. var0_5), true)
			onButton(arg0_5._event, findTF(arg0_5._litUI, "part_btns/" .. var0_5), function()
				if var0_5 <= #arg0_5._partNum then
					SpinePaintingConst.painting_lit_value = arg0_5._partNum[var0_5]

					SpinePaintingDrag.SetPaintingLite(arg0_5._paintingName, arg0_5._shipId, SpinePaintingConst.painting_lit_value)

					arg0_5._selectPart = var0_5

					arg0_5:Update()
				end
			end)
		else
			setActive(findTF(arg0_5._litUI, "part_btns/" .. var0_5), false)
		end
	end
end

function var0_0.ClickResetBtn(arg0_9)
	if arg0_9._partNum and #arg0_9._partNum > 0 then
		triggerButton(findTF(arg0_9._litUI, "part_btns/" .. 1))
	else
		SpinePaintingConst.painting_lit_value = 0.5
		arg0_9._selectPart = 0

		SpinePaintingDrag.SetPaintingLite(arg0_9._paintingName, arg0_9._shipId, SpinePaintingConst.painting_lit_value)
		setSlider(arg0_9._slider, 0, 1, SpinePaintingConst.painting_lit_value)
		arg0_9:Update()
	end
end

function var0_0.onSliderValueUpdate(arg0_10, arg1_10)
	LeanTween.cancel(go(arg0_10._slider))

	local var0_10 = SpinePaintingConst.painting_lit_value

	arg0_10._selectPart = 0

	LeanTween.value(go(arg0_10._slider), var0_10, arg1_10, 0.3):setOnUpdate(System.Action_float(function(arg0_11)
		SpinePaintingConst.painting_lit_value = arg0_11

		SpinePaintingDrag.SetPaintingLite(arg0_10._paintingName, arg0_10._shipId, arg0_11)
		arg0_10:Update()
	end))
end

function var0_0.Flush(arg0_12)
	if arg0_12._litUI then
		arg0_12._selectPart = 0
	else
		arg0_12._flushOnLoaded = true
	end
end

function var0_0.SetVisible(arg0_13, arg1_13)
	if not arg0_13._tf then
		return
	end

	setActive(arg0_13._tf, arg1_13)
	LeanTween.cancel(go(arg0_13._slider))

	if arg1_13 then
		arg0_13:Update()
	end
end

function var0_0.Update(arg0_14)
	if arg0_14._litUI then
		arg0_14:UpdateLit()
	end
end

function var0_0.UpdateLit(arg0_15)
	arg0_15:updateFillAmountBar()
	arg0_15:updateFillImage()
	arg0_15:updateFillImageR()
	arg0_15:updateSelectPartBtn()
	arg0_15:updateUIPosition()
end

function var0_0.updateSelectPartBtn(arg0_16)
	for iter0_16 = 1, #arg0_16._partNum do
		setActive(findTF(arg0_16._litUI, "part_btns/" .. iter0_16 .. "/text_on"), arg0_16._selectPart == iter0_16)
		setActive(findTF(arg0_16._litUI, "part_btns/" .. iter0_16 .. "/text_off"), arg0_16._selectPart ~= iter0_16)
		setActive(findTF(arg0_16._litUI, "part_btns/" .. iter0_16 .. "/bg/on"), arg0_16._selectPart == iter0_16)
	end
end

function var0_0.updateUIPosition(arg0_17)
	local var0_17 = getProxy(SettingsProxy):GetMainSceneThemeStyle()
	local var1_17 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	local var2_17

	if var0_17 == NewMainScene.THEME_MELLOW then
		var2_17 = Vector2(Screen.width / 2, Screen.height / 2)
	else
		var2_17 = Vector2(Screen.width / 2 - 700, Screen.height / 2)
	end

	local var3_17 = var1_17:ScreenToWorldPoint(var2_17)
	local var4_17 = arg0_17._parent:InverseTransformPoint(var3_17)

	arg0_17._litUI.anchoredPosition = var4_17
end

function var0_0.updateFillAmountBar(arg0_18)
	arg0_18._fillBarAnimator:Play(arg0_18._fillBarAnimatorName, -1, math.clamp(SpinePaintingConst.painting_lit_value, 0, 1))
end

function var0_0.updateFillImage(arg0_19)
	if arg0_19._fillImg then
		arg0_19._fillImg.fillAmount = math.clamp(SpinePaintingConst.painting_lit_value, 0, 1)
	end
end

function var0_0.updateFillImageR(arg0_20)
	if arg0_20._fillImageR then
		arg0_20._fillImageR.fillAmount = math.clamp(1 - SpinePaintingConst.painting_lit_value, 0, 1)
	end
end

function var0_0.GetSkinId(arg0_21)
	return arg0_21._skinId
end

function var0_0.Dispose(arg0_22)
	if arg0_22._slider and LeanTween.isTweening(arg0_22._slider) then
		LeanTween.cancel(go(arg0_22._slider))
	end

	if arg0_22._litUI then
		PoolMgr.GetInstance():ReturnUI(arg0_22._uiName, arg0_22._tf)

		arg0_22._litUI = nil
		arg0_22._uiName = nil
	end

	arg0_22._ship = nil
	arg0_22._isDispose = true
end

return var0_0
