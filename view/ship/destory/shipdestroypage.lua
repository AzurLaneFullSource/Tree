local var0_0 = class("ShipDestroyPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "DestoryInfoUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"energy",
		"shipstatus",
		"shipframe",
		"shiptype",
		"ui/proposeshipcard",
		"ui/heartshipcard",
		"shipyardicon/unknown",
		"ui/iconcolorful"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.getRefreshResList(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg1_3 or {}) do
		local var1_3 = arg2_3[iter1_3]

		if var1_3 then
			arg0_3:insertDockyardShipItemRes(var0_3, var1_3)
		end
	end

	local var2_3, var3_3, var4_3 = var0_0.CalcShipsReturnRes(arg1_3, arg2_3)

	table.insert(var4_3, 1, Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResOil,
		count = var3_3
	}))
	table.insert(var4_3, 1, Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResGold,
		count = var2_3
	}))
	_.each(var4_3, function(arg0_4)
		if arg0_4.count > 0 then
			table.insert(var0_3, arg0_4:getIcon())
		end
	end)

	return var0_3
end

function var0_0.insertDockyardShipItemRes(arg0_5, arg1_5, arg2_5)
	local var0_5 = string.format(ResPathSupport.ConstPath.BG.ShipCard, arg2_5:rarity2bgPrint())

	table.insert(arg1_5, var0_5)

	local var1_5 = ResPathSupport.GetPaintingShipYardIconListByPaintingName(arg2_5:getPainting())

	table.insertto(arg1_5, var1_5)

	local var2_5, var3_5 = arg2_5:GetFrameAndEffect()
	local var4_5 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, var3_5)

	table.insert(arg1_5, var4_5)
end

function var0_0.OnLoaded(arg0_6)
	arg0_6.cardScrollRect = arg0_6._tf:Find("frame/sliders/content"):GetComponent("LScrollRect")

	function arg0_6.cardScrollRect.onInitItem(arg0_7)
		return
	end

	function arg0_6.cardScrollRect.onUpdateItem(arg0_8, arg1_8)
		local var0_8 = arg0_6.shipIds[arg0_8 + 1]
		local var1_8 = DockyardShipItem.New(arg1_8, ShipStatus.TAG_HIDE_DESTROY)

		var1_8:update(arg0_6.shipVOs[var0_8])
		onButton(arg0_6, var1_8.tr, function()
			existCall(arg0_6.OnCardClick, var1_8)
			arg0_6:DisplayShipList()
		end, SFX_PANEL)
	end

	function arg0_6.cardScrollRect.onReturnItem(arg0_10, arg1_10)
		removeOnButton(arg1_10)
	end

	arg0_6.cancelBtn = arg0_6._tf:Find("frame/cancel_button")
	arg0_6.backBtn = arg0_6._tf:Find("frame/top/btnBack")
	arg0_6.confirmBtn = arg0_6._tf:Find("frame/confirm_button")

	setText(arg0_6._tf:Find("frame/bg_award/label"), i18n("disassemble_available") .. ":")

	local var0_6 = arg0_6._tf:Find("frame/bg_award/res_list")

	arg0_6.resList = UIItemList.New(var0_6, var0_6:Find("res"))

	arg0_6.resList:make(function(arg0_11, arg1_11, arg2_11)
		arg1_11 = arg1_11 + 1

		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg0_6.showList[arg1_11]

			GetImageSpriteFromAtlasAsync(var0_11:getIcon(), "", arg2_11:Find("icon"))
			setText(arg2_11:Find("Text"), "X" .. var0_11.count)
		end
	end)
end

function var0_0.OnInit(arg0_12)
	onButton(arg0_12, arg0_12.cancelBtn, function()
		arg0_12:Hide()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.backBtn, function()
		arg0_12:Hide()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.confirmBtn, function()
		if arg0_12.OnConfirm then
			arg0_12.OnConfirm()
		end
	end, SFX_PANEL)
end

function var0_0.SetConfirmCallBack(arg0_16, arg1_16)
	arg0_16.OnConfirm = arg1_16
end

function var0_0.SetCardClickCallBack(arg0_17, arg1_17)
	arg0_17.OnCardClick = arg1_17
end

function var0_0.Refresh(arg0_18, arg1_18, arg2_18)
	arg0_18.shipIds = arg1_18
	arg0_18.shipVOs = arg2_18

	local var0_18 = arg0_18:getRefreshResList(arg1_18, arg2_18)

	SplitPackConst.DownloadByLuaArr(var0_18, function()
		if arg0_18._state == var0_0.STATES.DESTROY then
			return
		end

		arg0_18:DisplayShipList()
		arg0_18:RefreshRes()
		arg0_18:Show()
	end)
end

function var0_0.DisplayShipList(arg0_20)
	arg0_20.cardScrollRect:SetTotalCount(#arg0_20.shipIds)

	if #arg0_20.shipIds == 0 then
		arg0_20:Hide()
	end
end

function var0_0.CalcShipsReturnRes(arg0_21, arg1_21)
	local var0_21 = _.map(arg0_21, function(arg0_22)
		return arg1_21[arg0_22]
	end)

	return ShipCalcHelper.CalcDestoryRes(var0_21)
end

function var0_0.RefreshRes(arg0_23)
	local var0_23, var1_23, var2_23 = var0_0.CalcShipsReturnRes(arg0_23.shipIds, arg0_23.shipVOs)

	table.insert(var2_23, 1, Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResOil,
		count = var1_23
	}))
	table.insert(var2_23, 1, Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResGold,
		count = var0_23
	}))

	arg0_23.showList = underscore.filter(var2_23, function(arg0_24)
		return arg0_24.count > 0
	end)

	arg0_23.resList:align(#arg0_23.showList)
end

function var0_0.Show(arg0_25)
	var0_0.super.Show(arg0_25)
	pg.UIMgr.GetInstance():BlurPanel(arg0_25._tf)
end

function var0_0.Hide(arg0_26)
	var0_0.super.Hide(arg0_26)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_26._tf, arg0_26._parentTf)
end

function var0_0.OnDestroy(arg0_27)
	arg0_27.OnCardClick = nil

	ClearLScrollrect(arg0_27.cardScrollRect)
	arg0_27:Hide()
end

return var0_0
