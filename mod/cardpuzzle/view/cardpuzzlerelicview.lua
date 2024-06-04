local var0 = class("CardPuzzleRelicView")

function var0.Ctor(arg0, arg1)
	arg0._tf = tf(arg1)
end

function var0.SetData(arg0, arg1)
	arg0.data = arg1
end

function var0.UpdateView(arg0)
	setImageSprite(arg0._tf:Find("Icon"), LoadSprite(arg0.data:GetIconPath(), ""), true)
	setText(arg0._tf:Find("Name"), arg0.data:GetName())
	setText(arg0._tf:Find("Detail"), arg0.data:GetDesc())
	TweenItemAlphaAndWhite(go(arg0._tf))
end

function var0.Clear(arg0)
	ClearTweenItemAlphaAndWhite(go(arg0._tf))
end

return var0
