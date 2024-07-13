local var0_0 = class("CryptolaliaListView", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CryptolaliaListui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.cards = {}
	arg0_2.scrollrect = arg0_2:findTF("frame/view"):GetComponent("LScrollRect")

	function arg0_2.scrollrect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollrect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:onUpdateItem(arg0_4, arg1_4)
	end

	arg0_2.frameTr = arg0_2:findTF("frame")
	arg0_2.subTitleTxt = arg0_2:findTF("frame/subtitle"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/title"), i18n("cryptolalia_list_title"))
end

function var0_0.OnInit(arg0_5)
	return
end

function var0_0.OnInitItem(arg0_6, arg1_6)
	local function var0_6()
		if not arg0_6.cryptolaliaId then
			return
		end

		for iter0_7, iter1_7 in pairs(arg0_6.cards) do
			if iter1_7.cryptolalia.id == arg0_6.cryptolaliaId then
				iter1_7:Update(iter1_7.cryptolalia, arg0_6.langType, false)
			end
		end
	end

	local var1_6 = CryptolaliaCard.New(arg1_6)

	onButton(arg0_6, var1_6._go, function()
		if arg0_6:CanSwitch() then
			var0_6()

			arg0_6.cryptolaliaId = var1_6.cryptolalia.id

			var1_6:Update(var1_6.cryptolalia, arg0_6.langType, true)
			arg0_6:SelectCard(arg0_6.cryptolaliaId)
		end
	end, SFX_PANEL)

	arg0_6.cards[arg1_6] = var1_6
end

function var0_0.CanSwitch(arg0_9)
	return not arg0_9.scrollRect.inAnimation
end

function var0_0.onUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cards[arg2_10]

	if not var0_10 then
		arg0_10:OnInitItem(arg2_10)

		var0_10 = arg0_10.cards[arg2_10]
	end

	local var1_10 = arg0_10.displays[arg1_10 + 1]
	local var2_10 = var1_10.id == arg0_10.cryptolaliaId

	var0_10:Update(var1_10, arg0_10.langType, var2_10)
end

function var0_0.Show(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	arg0_11.scrollRect = arg4_11

	var0_0.super.Show(arg0_11)
	seriesAsync({
		function(arg0_12)
			arg0_11:EnterAnimation(arg0_12)
		end,
		function(arg0_13)
			arg0_11:InitList(arg1_11, arg2_11, arg3_11)
			arg0_11:RegisterEvent()
			arg0_13()
		end
	})
end

function var0_0.EnterAnimation(arg0_14, arg1_14)
	local var0_14 = arg0_14.frameTr.sizeDelta.x

	LeanTween.value(arg0_14._tf.gameObject, var0_14, 0, 0.3):setOnUpdate(System.Action_float(function(arg0_15)
		arg0_14._tf.localPosition = Vector3(arg0_15, arg0_14._tf.localPosition.y, 0)
	end)):setFrom(var0_14):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg1_14))
end

function var0_0.InitList(arg0_16, arg1_16, arg2_16, arg3_16)
	arg0_16.cryptolaliaId = arg3_16
	arg0_16.langType = arg2_16
	arg0_16.displays = arg1_16

	arg0_16.scrollrect:SetTotalCount(#arg0_16.displays)

	arg0_16.subTitleTxt.text = i18n("cryptolalia_list_subtitle", #arg0_16.displays)
end

function var0_0.RegisterEvent(arg0_17)
	onButton(arg0_17, arg0_17._tf, function()
		arg0_17:Hide()
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_19)
	var0_0.super.Hide(arg0_19)
	removeOnButton(arg0_19._tf)

	if LeanTween.isTweening(arg0_19._tf.gameObject) then
		LeanTween.cancel(arg0_19._tf.gameObject)
	end
end

function var0_0.SelectCard(arg0_20, arg1_20)
	arg0_20:emit(CryptolaliaScene.ON_SELECT, arg1_20)
end

function var0_0.OnDestroy(arg0_21)
	for iter0_21, iter1_21 in pairs(arg0_21.cards) do
		iter1_21:Dispose()
	end

	arg0_21.cards = {}

	ClearLScrollrect(arg0_21.scrollrect)
end

return var0_0
