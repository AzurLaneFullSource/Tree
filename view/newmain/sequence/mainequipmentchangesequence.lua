local var0_0 = class("MainEquipmentChangeSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = ItemShowPanel.ConfigData

	if not var0_1.isOpen then
		arg1_1()

		return
	end

	local var1_1 = var0_1.equipID

	if PlayerPrefs.GetInt("ItemIconChange_" .. var1_1, 0) == 0 then
		local function var2_1()
			arg1_1()
			PlayerPrefs.SetInt("ItemIconChange_" .. var1_1, 1)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			type = MSGBOX_TYPE_JUST_FOR_SHOW,
			title = pg.MsgboxMgr.TITLE_INFORMATION,
			weight = LayerWeightConst.TOP_LAYER,
			onClose = var2_1,
			onYes = var2_1
		})
	else
		arg1_1()
	end
end

return var0_0
