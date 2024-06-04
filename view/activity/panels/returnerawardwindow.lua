local var0 = class("ReturnerAwardWindow", import(".PtAwardWindow"))

local function var1(arg0, arg1, arg2, arg3)
	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]
			local var1 = arg2[arg1 + 1]

			arg0.resTitle = string.gsub(arg0.resTitle, "：", "")

			setText(arg2:Find("title/Text"), "PHASE " .. arg1 + 1)
			setText(arg2:Find("target/Text"), var1)
			setText(arg2:Find("target/title"), arg0.resTitle)

			local var2 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2:Find("award"), var2, {
				hideName = true
			})
			onButton(arg0.binder, arg2:Find("award"), function()
				arg0.binder:emit(BaseUI.ON_DROP, var2)
			end, SFX_PANEL)
			setActive(arg2:Find("award/mask"), table.contains(arg3, var1))

			if arg2:Find("target/icon") and arg0.resIcon and arg0.resIcon ~= "" then
				setActive(arg2:Find("target/icon"), true)
				LoadImageSpriteAsync(arg0.resIcon, arg2:Find("target/icon"), false)
			else
				setActive(arg2:Find("target/icon"), false)
			end
		end
	end)
	arg0.UIlist:align(#arg1)
end

function var0.Show(arg0, arg1)
	local var0 = arg1.dropList
	local var1 = arg1.targets
	local var2 = arg1.fetchList
	local var3 = arg1.count
	local var4 = arg1.resId
	local var5 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var4
	}):getName()

	arg0.resTitle, arg0.cntTitle = i18n("pt_count", var5), i18n("pt_total_count", var5)
	arg0.cntTitle = string.gsub(arg0.cntTitle, "：", "")

	arg0:updateResIcon(arg1.resId, arg1.resIcon, arg1.type)
	var1(arg0, var0, var1, var2)

	arg0.totalTxt.text = var3
	arg0.totalTitleTxt.text = arg0.cntTitle

	setActive(arg0._tf, true)
end

return var0
