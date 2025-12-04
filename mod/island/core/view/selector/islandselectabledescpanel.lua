local var0_0 = class("IslandSelectableDescPanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.isShowItemCount = arg2_1
	arg0_1.tr = arg1_1
	arg0_1.countBg = arg0_1.tr:Find("bg/item/icon_bg/count_bg")
	arg0_1.itemCntTxt = arg0_1.tr:Find("bg/item/icon_bg/count_bg/count"):GetComponent(typeof(Text))
	arg0_1.iconTr = arg0_1.tr:Find("bg/item/icon_bg/icon")
	arg0_1.detaltipsTf = arg0_1.tr:Find("bg/detaiView/Viewport/detaiViewText"):GetComponent(typeof(Text))
	arg0_1.nameTxt = arg0_1.tr:Find("bg/seedName"):GetComponent(typeof(Text))
end

function var0_0.Show(arg0_2, arg1_2, arg2_2)
	arg0_2.tr.position = arg1_2
	arg0_2.itemCntTxt.text = arg2_2:GetCount()

	setActive(arg0_2.countBg, arg0_2.isShowItemCount)

	local var0_2 = arg2_2:GetIcon()

	GetImageSpriteFromAtlasAsync("island/" .. var0_2, "", arg0_2.iconTr)

	arg0_2.detaltipsTf.text = arg2_2:GetDesc()
	arg0_2.nameTxt.text = arg2_2:GetName()

	setActive(arg0_2.tr, true)
end

function var0_0.IsShowing(arg0_3)
	return isActive(arg0_3.tr)
end

function var0_0.Hide(arg0_4)
	setActive(arg0_4.tr, false)
end

function var0_0.Dispose(arg0_5)
	if arg0_5:IsShowing() then
		arg0_5:Hide()
	end
end

return var0_0
