local var0_0 = class("StarsCityCollectPage", import("view.activity.CorePage.EscapeManor.EscapeManorCollectPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.msgBox = StarsCityCollectMsgBox.New(arg0_1._tf, arg0_1.event)
end

function var0_0.AddSpecialBtnListener(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client")

	arg0_2.furnitureThemeBtn = arg0_2.btnList:Find("furniture_theme")

	if arg0_2.furnitureThemeBtn and var0_2.furniture_theme_link then
		onButton(arg0_2, arg0_2.furnitureThemeBtn, function()
			local var0_3 = var0_2.furniture_theme_link
			local var1_3 = var0_3[1]
			local var2_3 = var0_3[2]
			local var3_3 = var0_3[3]

			arg0_2:DoSkip(var1_3, var2_3)
		end, SFX_PANEL)
	end

	arg0_2.medalBtn = arg0_2.btnList:Find("medal")

	if arg0_2.medalBtn and var0_2.medal_link then
		onButton(arg0_2, arg0_2.medalBtn, function()
			local var0_4 = var0_2.medal_link
			local var1_4 = var0_4[1]
			local var2_4 = var0_4[2]
			local var3_4 = var0_4[3]

			arg0_2:DoSkip(var1_4, var2_4)
		end, SFX_PANEL)
	end

	arg0_2.equipSkinBoxBtn = arg0_2.btnList:Find("equip_skin_box")

	if arg0_2.equipSkinBoxBtn and var0_2.equipskin_box_link then
		local var1_2 = Drop.New({
			type = var0_2.equipskin_box_link.drop_type,
			id = var0_2.equipskin_box_link.drop_id
		}):getOwnedCount()

		onButton(arg0_2, arg0_2.equipSkinBoxBtn, function()
			arg0_2.msgBox:ExecuteAction("Show", {
				drop_type = var0_2.equipskin_box_link.drop_type,
				drop_id = var0_2.equipskin_box_link.drop_id,
				count = var1_2,
				skipable_list = var0_2.equipskin_box_link.list
			})
		end, SFX_PANEL)
	end
end

return var0_0
