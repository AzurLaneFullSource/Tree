local var0_0 = class("ReturnerAwardWindow", import(".PtAwardWindow"))

local function var1_0(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.UIlist:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_1[arg1_2 + 1]
			local var1_2 = arg2_1[arg1_2 + 1]

			arg0_1.resTitle = string.gsub(arg0_1.resTitle, "：", "")

			setText(arg2_2:Find("title/Text"), "PHASE " .. arg1_2 + 1)
			setText(arg2_2:Find("target/Text"), var1_2)
			setText(arg2_2:Find("target/title"), arg0_1.resTitle)

			local var2_2 = {
				type = var0_2[1],
				id = var0_2[2],
				count = var0_2[3]
			}

			updateDrop(arg2_2:Find("award"), var2_2, {
				hideName = true
			})
			onButton(arg0_1.binder, arg2_2:Find("award"), function()
				arg0_1.binder:emit(BaseUI.ON_DROP, var2_2)
			end, SFX_PANEL)
			setActive(arg2_2:Find("award/mask"), table.contains(arg3_1, var1_2))

			if arg2_2:Find("target/icon") and arg0_1.resIcon and arg0_1.resIcon ~= "" then
				setActive(arg2_2:Find("target/icon"), true)
				LoadImageSpriteAsync(arg0_1.resIcon, arg2_2:Find("target/icon"), false)
			else
				setActive(arg2_2:Find("target/icon"), false)
			end
		end
	end)
	arg0_1.UIlist:align(#arg1_1)
end

function var0_0.Show(arg0_4, arg1_4)
	local var0_4 = arg1_4.dropList
	local var1_4 = arg1_4.targets
	local var2_4 = arg1_4.fetchList
	local var3_4 = arg1_4.count
	local var4_4 = arg1_4.resId
	local var5_4 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var4_4
	}):getName()

	arg0_4.resTitle, arg0_4.cntTitle = i18n("pt_count", var5_4), i18n("pt_total_count", var5_4)
	arg0_4.cntTitle = string.gsub(arg0_4.cntTitle, "：", "")

	arg0_4:updateResIcon(arg1_4.resId, arg1_4.resIcon, arg1_4.type)
	var1_0(arg0_4, var0_4, var1_4, var2_4)

	arg0_4.totalTxt.text = var3_4
	arg0_4.totalTitleTxt.text = arg0_4.cntTitle

	setActive(arg0_4._tf, true)
end

return var0_0
