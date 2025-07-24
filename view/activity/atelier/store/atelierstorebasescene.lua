local var0_0 = class("AtelierStoreBaseScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AtelierStoreUI"
end

function var0_0.init(arg0_2)
	arg0_2.storehouseRect = GetComponent(arg0_2:findTF("Window/ScrollView"), "LScrollRect")

	local var0_2 = arg0_2:findTF("Window/ScrollView/Item")

	setActive(var0_2, false)
	arg0_2:InitCustom()
end

function var0_0.InitCustom(arg0_3)
	setText(arg0_3:findTF("Window/Empty"), i18n("ryza_tip_no_item"))
end

function var0_0.didEnter(arg0_4)
	arg0_4.activity = arg0_4.contextData.activity

	onButton(arg0_4, arg0_4:findTF("Window/Close"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4:findTF("BG"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	arg0_4:ShowStoreHouseWindow()
end

function var0_0.ShowStoreHouseWindow(arg0_7)
	local var0_7 = arg0_7.contextData.versionIndex or 1

	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)

	local var1_7 = _.filter(_.values(arg0_7.activity:GetItems()), function(arg0_8)
		return arg0_8.count > 0 and arg0_8:GetVersion() == var0_7 and arg0_8:IsShow() ~= 0
	end)

	table.sort(var1_7, function(arg0_9, arg1_9)
		return arg0_9:GetConfigID() < arg1_9:GetConfigID()
	end)
	setActive(arg0_7:findTF("Window/Empty"), #var1_7 == 0)
	setActive(arg0_7:findTF("Window/ScrollView"), #var1_7 > 0)

	if #var1_7 == 0 then
		return
	end

	function arg0_7.storehouseRect.onUpdateItem(arg0_10, arg1_10)
		arg0_10 = arg0_10 + 1

		local var0_10 = tf(arg1_10)
		local var1_10 = var1_7[arg0_10]

		arg0_7:UpdateRyzaItem(arg0_7:findTF("IconBG", var0_10), var1_10)
		setScrollText(arg0_7:findTF("NameBG/Rect/Name", var0_10), var1_10:GetName())
		onButton(arg0_7, var0_10, function()
			arg0_7:ShowItemDetail(var1_10)
		end, SFX_PANEL)
	end

	arg0_7.storehouseRect:SetTotalCount(#var1_7)
end

function var0_0.UpdateRyzaItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = "icon_frame_" .. arg2_12:GetRarity()

	if small then
		var0_12 = var0_12 .. "_small"
	end

	GetImageSpriteFromAtlasAsync("ui/AtelierCommonUI_atlas", var0_12, arg1_12)
	GetImageSpriteFromAtlasAsync(arg2_12:GetIconPath(), "", arg0_12:findTF("Icon", arg1_12))

	if not IsNil(arg0_12:findTF("Lv", arg1_12)) then
		setText(arg0_12:findTF("Lv/Text", arg1_12), arg2_12:GetLevel())
	end

	local var1_12 = arg2_12:GetProps()
	local var2_12 = CustomIndexLayer.Clone2Full(arg0_12:findTF("List", arg1_12), #var1_12)

	for iter0_12, iter1_12 in ipairs(var2_12) do
		GetImageSpriteFromAtlasAsync("ui/AtelierCommonUI_atlas", "element_" .. AtelierFormulaCircle.ELEMENT_NAME[var1_12[iter0_12]], iter1_12)
	end

	if not IsNil(arg0_12:findTF("Text", arg1_12)) then
		setText(arg0_12:findTF("Text", arg1_12), arg2_12.count)
	end
end

function var0_0.ShowItemDetail(arg0_13, arg1_13)
	arg0_13:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, arg1_13)
end

function var0_0.willExit(arg0_14)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf)
end

return var0_0
