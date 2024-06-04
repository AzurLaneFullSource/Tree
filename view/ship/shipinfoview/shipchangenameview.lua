local var0 = class("ShipChangeNameView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShipChangeNameView"
end

function var0.OnInit(arg0)
	arg0._renamePanel = arg0._tf
	arg0._renameConfirmBtn = arg0._renamePanel:Find("frame/queren")
	arg0._renameCancelBtn = arg0._renamePanel:Find("frame/cancel")
	arg0._renameRevert = arg0._renamePanel:Find("frame/revert_button")
	arg0._renameCloseBtn = arg0._renamePanel:Find("frame/close_btn")

	setText(findTF(arg0._tf, "frame/name_field/Placeholder"), i18n("rename_input"))
	onButton(arg0, arg0._renameConfirmBtn, function()
		local var0 = getInputText(findTF(arg0._renamePanel, "frame/name_field"))

		arg0:emit(ShipMainMediator.RENAME_SHIP, arg0:GetShipVO().id, var0)
	end, SFX_CONFIRM)
	onButton(arg0, arg0._renameRevert, function()
		local var0 = arg0:GetShipVO():isRemoulded() and pg.ship_skin_template[arg0:GetShipVO():getRemouldSkinId()].name or pg.ship_data_statistics[arg0:GetShipVO().configId].name

		setInputText(findTF(arg0._renamePanel, "frame/name_field"), var0)
	end, SFX_PANEL)
	onButton(arg0, arg0._renameCloseBtn, function()
		arg0:DisplayRenamePanel(false)
	end, SFX_PANEL)
	onButton(arg0, arg0._renameCancelBtn, function()
		arg0:DisplayRenamePanel(false)
	end, SFX_CANCEL)
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.GetShipVO(arg0)
	if arg0.shareData and arg0.shareData.shipVO then
		return arg0.shareData.shipVO
	end

	return nil
end

function var0.DisplayRenamePanel(arg0, arg1)
	arg0.isOpenRenamePanel = arg1

	SetActive(arg0._renamePanel, arg1)

	if arg1 then
		pg.UIMgr.GetInstance():BlurPanel(arg0._renamePanel, false)

		local var0 = arg0:GetShipVO():getName()

		setInputText(findTF(arg0._renamePanel, "frame/name_field"), var0)
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0._renamePanel, arg0._tf)
	end
end

function var0.OnDestroy(arg0)
	arg0.shareData = nil
end

return var0
