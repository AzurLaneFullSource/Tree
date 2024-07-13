local var0_0 = class("KillEnemyAwardWindow", import(".PtAwardWindow"))

local function var1_0(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.UIlist:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_1[arg1_2 + 1]
			local var1_2 = arg2_1[arg1_2 + 1]

			setText(arg2_2:Find("title/Text"), "PHASE " .. arg1_2 + 1)
			setActive(arg2_2:Find("target/Text"), false)
			setText(arg2_2:Find("target/title"), var1_2)

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
			setActive(arg2_2:Find("award/mask"), arg1_2 + 1 <= arg3_1)
		end
	end)
	arg0_1.UIlist:align(#arg1_1)
end

function var0_0.Show(arg0_4, arg1_4)
	local var0_4 = arg1_4.dropList
	local var1_4 = arg1_4.descs
	local var2_4 = arg1_4.finishedIndex

	var1_0(arg0_4, var0_4, var1_4, var2_4)
	setActive(arg0_4.ptTF, false)
	setActive(arg0_4._tf, true)
end

return var0_0
