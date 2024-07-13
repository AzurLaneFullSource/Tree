local var0_0 = class("ShipDestroyPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "DestoryInfoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.cardScrollRect = arg0_2._tf:Find("frame/sliders/content"):GetComponent("LScrollRect")

	function arg0_2.cardScrollRect.onInitItem(arg0_3)
		return
	end

	function arg0_2.cardScrollRect.onUpdateItem(arg0_4, arg1_4)
		local var0_4 = arg0_2.shipIds[arg0_4 + 1]
		local var1_4 = DockyardShipItem.New(arg1_4, ShipStatus.TAG_HIDE_DESTROY)

		var1_4:update(arg0_2.shipVOs[var0_4])
		onButton(arg0_2, var1_4.tr, function()
			existCall(arg0_2.OnCardClick, var1_4)
			arg0_2:DisplayShipList()
		end, SFX_PANEL)
	end

	function arg0_2.cardScrollRect.onReturnItem(arg0_6, arg1_6)
		removeOnButton(arg1_6)
	end

	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel_button")
	arg0_2.backBtn = arg0_2:findTF("frame/top/btnBack")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm_button")

	setText(arg0_2._tf:Find("frame/bg_award/label"), i18n("disassemble_available") .. ":")

	local var0_2 = arg0_2._tf:Find("frame/bg_award/res_list")

	arg0_2.resList = UIItemList.New(var0_2, var0_2:Find("res"))

	arg0_2.resList:make(function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg0_2.showList[arg1_7]

			GetImageSpriteFromAtlasAsync(var0_7:getIcon(), "", arg2_7:Find("icon"))
			setText(arg2_7:Find("Text"), "X" .. var0_7.count)
		end
	end)
end

function var0_0.OnInit(arg0_8)
	onButton(arg0_8, arg0_8.cancelBtn, function()
		arg0_8:Hide()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:Hide()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		if arg0_8.OnConfirm then
			arg0_8.OnConfirm()
		end
	end, SFX_PANEL)
end

function var0_0.SetConfirmCallBack(arg0_12, arg1_12)
	arg0_12.OnConfirm = arg1_12
end

function var0_0.SetCardClickCallBack(arg0_13, arg1_13)
	arg0_13.OnCardClick = arg1_13
end

function var0_0.Refresh(arg0_14, arg1_14, arg2_14)
	arg0_14.shipIds = arg1_14
	arg0_14.shipVOs = arg2_14

	arg0_14:DisplayShipList()
	arg0_14:RefreshRes()
	arg0_14:Show()
end

function var0_0.DisplayShipList(arg0_15)
	arg0_15.cardScrollRect:SetTotalCount(#arg0_15.shipIds)

	if #arg0_15.shipIds == 0 then
		arg0_15:Hide()
	end
end

function var0_0.CalcShipsReturnRes(arg0_16, arg1_16)
	local var0_16 = _.map(arg0_16, function(arg0_17)
		return arg1_16[arg0_17]
	end)

	return ShipCalcHelper.CalcDestoryRes(var0_16)
end

function var0_0.RefreshRes(arg0_18)
	local var0_18, var1_18, var2_18 = var0_0.CalcShipsReturnRes(arg0_18.shipIds, arg0_18.shipVOs)

	table.insert(var2_18, 1, Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResOil,
		count = var1_18
	}))
	table.insert(var2_18, 1, Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResGold,
		count = var0_18
	}))

	arg0_18.showList = underscore.filter(var2_18, function(arg0_19)
		return arg0_19.count > 0
	end)

	arg0_18.resList:align(#arg0_18.showList)
end

function var0_0.Show(arg0_20)
	var0_0.super.Show(arg0_20)
	pg.UIMgr:GetInstance():BlurPanel(arg0_20._tf)
end

function var0_0.Hide(arg0_21)
	var0_0.super.Hide(arg0_21)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf, arg0_21._parentTf)
end

function var0_0.OnDestroy(arg0_22)
	arg0_22.OnCardClick = nil

	ClearLScrollrect(arg0_22.cardScrollRect)
	arg0_22:Hide()
end

return var0_0
