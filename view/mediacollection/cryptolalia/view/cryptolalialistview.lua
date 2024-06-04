local var0 = class("CryptolaliaListView", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CryptolaliaListui"
end

function var0.OnLoaded(arg0)
	arg0.cards = {}
	arg0.scrollrect = arg0:findTF("frame/view"):GetComponent("LScrollRect")

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	arg0.frameTr = arg0:findTF("frame")
	arg0.subTitleTxt = arg0:findTF("frame/subtitle"):GetComponent(typeof(Text))

	setText(arg0:findTF("frame/title"), i18n("cryptolalia_list_title"))
end

function var0.OnInit(arg0)
	return
end

function var0.OnInitItem(arg0, arg1)
	local function var0()
		if not arg0.cryptolaliaId then
			return
		end

		for iter0, iter1 in pairs(arg0.cards) do
			if iter1.cryptolalia.id == arg0.cryptolaliaId then
				iter1:Update(iter1.cryptolalia, arg0.langType, false)
			end
		end
	end

	local var1 = CryptolaliaCard.New(arg1)

	onButton(arg0, var1._go, function()
		if arg0:CanSwitch() then
			var0()

			arg0.cryptolaliaId = var1.cryptolalia.id

			var1:Update(var1.cryptolalia, arg0.langType, true)
			arg0:SelectCard(arg0.cryptolaliaId)
		end
	end, SFX_PANEL)

	arg0.cards[arg1] = var1
end

function var0.CanSwitch(arg0)
	return not arg0.scrollRect.inAnimation
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]
	local var2 = var1.id == arg0.cryptolaliaId

	var0:Update(var1, arg0.langType, var2)
end

function var0.Show(arg0, arg1, arg2, arg3, arg4)
	arg0.scrollRect = arg4

	var0.super.Show(arg0)
	seriesAsync({
		function(arg0)
			arg0:EnterAnimation(arg0)
		end,
		function(arg0)
			arg0:InitList(arg1, arg2, arg3)
			arg0:RegisterEvent()
			arg0()
		end
	})
end

function var0.EnterAnimation(arg0, arg1)
	local var0 = arg0.frameTr.sizeDelta.x

	LeanTween.value(arg0._tf.gameObject, var0, 0, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0._tf.localPosition = Vector3(arg0, arg0._tf.localPosition.y, 0)
	end)):setFrom(var0):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg1))
end

function var0.InitList(arg0, arg1, arg2, arg3)
	arg0.cryptolaliaId = arg3
	arg0.langType = arg2
	arg0.displays = arg1

	arg0.scrollrect:SetTotalCount(#arg0.displays)

	arg0.subTitleTxt.text = i18n("cryptolalia_list_subtitle", #arg0.displays)
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	removeOnButton(arg0._tf)

	if LeanTween.isTweening(arg0._tf.gameObject) then
		LeanTween.cancel(arg0._tf.gameObject)
	end
end

function var0.SelectCard(arg0, arg1)
	arg0:emit(CryptolaliaScene.ON_SELECT, arg1)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = {}

	ClearLScrollrect(arg0.scrollrect)
end

return var0
