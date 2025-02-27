local var0_0 = class("Dorm3dInstagramCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.iconTF = arg0_1._tf:Find("head/icon")
	arg0_1.nameTxt = arg0_1._tf:Find("name")
	arg0_1.txt = arg0_1._tf:Find("Text")
	arg0_1.like = arg0_1._tf:Find("like/Text")
	arg0_1.likeMark = arg0_1._tf:Find("like/mark")
	arg0_1.tip = arg0_1._tf:Find("head/tip")
	arg0_1.image = arg0_1._tf:Find("image")
	arg0_1.mask = arg0_1._tf:Find("mask")
	arg0_1.maskTxt = arg0_1._tf:Find("mask/content/Text")
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.instagram = arg1_2

	setImageSprite(arg0_2.iconTF, LoadSprite("qicon/" .. arg1_2:GetIcon()), false)
	setText(arg0_2.nameTxt, arg1_2:GetName())
	LoadSpriteAsync("Dorm3dIns/" .. arg1_2:GetPicture(), function(arg0_3)
		setImageSprite(arg0_2.image, arg0_3, false)
	end)
	setActive(arg0_2.likeMark, arg1_2:IsGood())
	setText(arg0_2.txt, arg1_2:GetText())
	setActive(arg0_2.tip, arg1_2:ShouldTip())
	setActive(arg0_2.mask, arg1_2:IsLock())
	setText(arg0_2.maskTxt, arg1_2:GetUnLockConditionDesc())
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
