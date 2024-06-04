local var0 = class("ShipDestroyPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "DestoryInfoUI"
end

function var0.OnLoaded(arg0)
	arg0.cardScrollRect = arg0._tf:Find("frame/sliders/content"):GetComponent("LScrollRect")

	function arg0.cardScrollRect.onInitItem(arg0)
		return
	end

	function arg0.cardScrollRect.onUpdateItem(arg0, arg1)
		local var0 = arg0.shipIds[arg0 + 1]
		local var1 = DockyardShipItem.New(arg1, ShipStatus.TAG_HIDE_DESTROY)

		var1:update(arg0.shipVOs[var0])
		onButton(arg0, var1.tr, function()
			existCall(arg0.OnCardClick, var1)
			arg0:DisplayShipList()
		end, SFX_PANEL)
	end

	function arg0.cardScrollRect.onReturnItem(arg0, arg1)
		removeOnButton(arg1)
	end

	arg0.cancelBtn = arg0:findTF("frame/cancel_button")
	arg0.backBtn = arg0:findTF("frame/top/btnBack")
	arg0.confirmBtn = arg0:findTF("frame/confirm_button")

	setText(arg0._tf:Find("frame/bg_award/label"), i18n("disassemble_available") .. ":")

	local var0 = arg0._tf:Find("frame/bg_award/res_list")

	arg0.resList = UIItemList.New(var0, var0:Find("res"))

	arg0.resList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.showList[arg1]

			GetImageSpriteFromAtlasAsync(var0:getIcon(), "", arg2:Find("icon"))
			setText(arg2:Find("Text"), "X" .. var0.count)
		end
	end)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.OnConfirm then
			arg0.OnConfirm()
		end
	end, SFX_PANEL)
end

function var0.SetConfirmCallBack(arg0, arg1)
	arg0.OnConfirm = arg1
end

function var0.SetCardClickCallBack(arg0, arg1)
	arg0.OnCardClick = arg1
end

function var0.Refresh(arg0, arg1, arg2)
	arg0.shipIds = arg1
	arg0.shipVOs = arg2

	arg0:DisplayShipList()
	arg0:RefreshRes()
	arg0:Show()
end

function var0.DisplayShipList(arg0)
	arg0.cardScrollRect:SetTotalCount(#arg0.shipIds)

	if #arg0.shipIds == 0 then
		arg0:Hide()
	end
end

function var0.CalcShipsReturnRes(arg0, arg1)
	local var0 = _.map(arg0, function(arg0)
		return arg1[arg0]
	end)

	return ShipCalcHelper.CalcDestoryRes(var0)
end

function var0.RefreshRes(arg0)
	local var0, var1, var2 = var0.CalcShipsReturnRes(arg0.shipIds, arg0.shipVOs)

	table.insert(var2, 1, Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResOil,
		count = var1
	}))
	table.insert(var2, 1, Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResGold,
		count = var0
	}))

	arg0.showList = underscore.filter(var2, function(arg0)
		return arg0.count > 0
	end)

	arg0.resList:align(#arg0.showList)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr:GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0.OnCardClick = nil

	ClearLScrollrect(arg0.cardScrollRect)
	arg0:Hide()
end

return var0
