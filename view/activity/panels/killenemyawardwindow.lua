local var0 = class("KillEnemyAwardWindow", import(".PtAwardWindow"))

local function var1(arg0, arg1, arg2, arg3)
	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]
			local var1 = arg2[arg1 + 1]

			setText(arg2:Find("title/Text"), "PHASE " .. arg1 + 1)
			setActive(arg2:Find("target/Text"), false)
			setText(arg2:Find("target/title"), var1)

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
			setActive(arg2:Find("award/mask"), arg1 + 1 <= arg3)
		end
	end)
	arg0.UIlist:align(#arg1)
end

function var0.Show(arg0, arg1)
	local var0 = arg1.dropList
	local var1 = arg1.descs
	local var2 = arg1.finishedIndex

	var1(arg0, var0, var1, var2)
	setActive(arg0.ptTF, false)
	setActive(arg0._tf, true)
end

return var0
