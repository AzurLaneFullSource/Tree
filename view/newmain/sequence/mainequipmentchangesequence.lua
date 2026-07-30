local var0_0 = class("MainEquipmentChangeSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = {
		equipID = 908601,
		isOpen = false,
		title = "equipment_info_change_tip",
		icon_new = "equips/50860",
		icon_old = "equips/50860",
		name_new = "equipment_info_change_name_b",
		tip_old = "equipment_info_change_text_before",
		tip_new = "equipment_info_change_text_after",
		name_old = "equipment_info_change_name_a"
	}

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
			configData = var0_1,
			onClose = var2_1,
			onYes = var2_1
		})
	else
		arg1_1()
	end
end

return var0_0
