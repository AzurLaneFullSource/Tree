local var0 = class("MainEquipmentChangeSequence")

function var0.Execute(arg0, arg1)
	local var0 = ItemShowPanel.ConfigData

	if not var0.isOpen then
		arg1()

		return
	end

	local var1 = var0.equipID

	if PlayerPrefs.GetInt("ItemIconChange_" .. var1, 0) == 0 then
		local function var2()
			arg1()
			PlayerPrefs.SetInt("ItemIconChange_" .. var1, 1)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			type = MSGBOX_TYPE_JUST_FOR_SHOW,
			title = pg.MsgboxMgr.TITLE_INFORMATION,
			weight = LayerWeightConst.TOP_LAYER,
			onClose = var2,
			onYes = var2
		})
	else
		arg1()
	end
end

return var0
