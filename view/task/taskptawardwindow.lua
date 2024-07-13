local var0_0 = class("TaskPtAwardWindow", import("..activity.Panels.PtAwardWindow"))

function var0_0.UpdateList(arg0_1, arg1_1, arg2_1, arg3_1)
	assert(#arg1_1 == #arg2_1)
	arg0_1.UIlist:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_1[arg1_2 + 1]

			arg0_1:UpdateDrop(arg2_2:Find("award"), var0_2[1])
			arg0_1:UpdateDrop(arg2_2:Find("award1"), var0_2[2])

			local var1_2 = arg2_1[arg1_2 + 1]

			setText(arg2_2:Find("title/Text"), "PHASE " .. arg1_2 + 1)
			setText(arg2_2:Find("target/Text"), var1_2)
			setText(arg2_2:Find("target/title"), arg0_1.resTitle)
			setActive(arg2_2:Find("award/mask"), arg1_2 + 1 <= arg3_1)
			setActive(arg2_2:Find("award1/mask"), arg1_2 + 1 <= arg3_1)

			if arg2_2:Find("target/icon") then
				if arg0_1.resIcon == "" then
					arg0_1.resIcon = nil
				end

				if arg0_1.resIcon then
					LoadImageSpriteAsync(arg0_1.resIcon, arg2_2:Find("target/icon"), false)
				end

				setActive(arg2_2:Find("target/icon"), arg0_1.resIcon)
				setActive(arg2_2:Find("target/mark"), arg0_1.resIcon)
			end
		end
	end)
	arg0_1.UIlist:align(#arg1_1)
end

function var0_0.UpdateDrop(arg0_3, arg1_3, arg2_3)
	if arg2_3 then
		setActive(arg1_3, true)

		local var0_3 = {
			type = arg2_3[1],
			id = arg2_3[2],
			count = arg2_3[3]
		}

		updateDrop(arg1_3, var0_3, {
			hideName = true
		})
		onButton(arg0_3.binder, arg1_3, function()
			arg0_3.binder:emit(BaseUI.ON_DROP, var0_3)
		end, SFX_PANEL)
	else
		setActive(arg1_3, false)
	end
end

return var0_0
