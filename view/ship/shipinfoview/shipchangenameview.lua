local var0_0 = class("ShipChangeNameView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipChangeNameView"
end

function var0_0.OnInit(arg0_2)
	arg0_2._renamePanel = arg0_2._tf
	arg0_2._renameConfirmBtn = arg0_2._renamePanel:Find("frame/queren")
	arg0_2._renameCancelBtn = arg0_2._renamePanel:Find("frame/cancel")
	arg0_2._renameRevert = arg0_2._renamePanel:Find("frame/revert_button")
	arg0_2._renameCloseBtn = arg0_2._renamePanel:Find("frame/close_btn")

	setText(findTF(arg0_2._tf, "frame/name_field/Placeholder"), i18n("rename_input"))
	onButton(arg0_2, arg0_2._renameConfirmBtn, function()
		local var0_3 = getInputText(findTF(arg0_2._renamePanel, "frame/name_field"))

		arg0_2:emit(ShipMainMediator.RENAME_SHIP, arg0_2:GetShipVO().id, var0_3)
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2._renameRevert, function()
		local var0_4 = arg0_2:GetShipVO():isRemoulded() and pg.ship_skin_template[arg0_2:GetShipVO():getRemouldSkinId()].name or pg.ship_data_statistics[arg0_2:GetShipVO().configId].name

		setInputText(findTF(arg0_2._renamePanel, "frame/name_field"), var0_4)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._renameCloseBtn, function()
		arg0_2:DisplayRenamePanel(false)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._renameCancelBtn, function()
		arg0_2:DisplayRenamePanel(false)
	end, SFX_CANCEL)
end

function var0_0.SetShareData(arg0_7, arg1_7)
	arg0_7.shareData = arg1_7
end

function var0_0.GetShipVO(arg0_8)
	if arg0_8.shareData and arg0_8.shareData.shipVO then
		return arg0_8.shareData.shipVO
	end

	return nil
end

function var0_0.DisplayRenamePanel(arg0_9, arg1_9)
	arg0_9.isOpenRenamePanel = arg1_9

	SetActive(arg0_9._renamePanel, arg1_9)

	if arg1_9 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_9._renamePanel, false)

		local var0_9 = arg0_9:GetShipVO():getName()

		setInputText(findTF(arg0_9._renamePanel, "frame/name_field"), var0_9)
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_9._renamePanel, arg0_9._tf)
	end
end

function var0_0.OnDestroy(arg0_10)
	arg0_10.shareData = nil
end

return var0_0
