local var0 = class("TaskPtAwardWindow", import("..activity.Panels.PtAwardWindow"))

function var0.UpdateList(arg0, arg1, arg2, arg3)
	assert(#arg1 == #arg2)
	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]

			arg0:UpdateDrop(arg2:Find("award"), var0[1])
			arg0:UpdateDrop(arg2:Find("award1"), var0[2])

			local var1 = arg2[arg1 + 1]

			setText(arg2:Find("title/Text"), "PHASE " .. arg1 + 1)
			setText(arg2:Find("target/Text"), var1)
			setText(arg2:Find("target/title"), arg0.resTitle)
			setActive(arg2:Find("award/mask"), arg1 + 1 <= arg3)
			setActive(arg2:Find("award1/mask"), arg1 + 1 <= arg3)

			if arg2:Find("target/icon") then
				if arg0.resIcon == "" then
					arg0.resIcon = nil
				end

				if arg0.resIcon then
					LoadImageSpriteAsync(arg0.resIcon, arg2:Find("target/icon"), false)
				end

				setActive(arg2:Find("target/icon"), arg0.resIcon)
				setActive(arg2:Find("target/mark"), arg0.resIcon)
			end
		end
	end)
	arg0.UIlist:align(#arg1)
end

function var0.UpdateDrop(arg0, arg1, arg2)
	if arg2 then
		setActive(arg1, true)

		local var0 = {
			type = arg2[1],
			id = arg2[2],
			count = arg2[3]
		}

		updateDrop(arg1, var0, {
			hideName = true
		})
		onButton(arg0.binder, arg1, function()
			arg0.binder:emit(BaseUI.ON_DROP, var0)
		end, SFX_PANEL)
	else
		setActive(arg1, false)
	end
end

return var0
