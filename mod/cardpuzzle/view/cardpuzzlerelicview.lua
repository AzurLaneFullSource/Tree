local var0_0 = class("CardPuzzleRelicView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = tf(arg1_1)
end

function var0_0.SetData(arg0_2, arg1_2)
	arg0_2.data = arg1_2
end

function var0_0.UpdateView(arg0_3)
	setImageSprite(arg0_3._tf:Find("Icon"), LoadSprite(arg0_3.data:GetIconPath(), ""), true)
	setText(arg0_3._tf:Find("Name"), arg0_3.data:GetName())
	setText(arg0_3._tf:Find("Detail"), arg0_3.data:GetDesc())
	TweenItemAlphaAndWhite(go(arg0_3._tf))
end

function var0_0.Clear(arg0_4)
	ClearTweenItemAlphaAndWhite(go(arg0_4._tf))
end

return var0_0
