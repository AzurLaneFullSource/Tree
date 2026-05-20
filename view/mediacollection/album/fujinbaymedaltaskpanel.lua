local var0_0 = class("FujinBayMedalTaskPanel", import(".MedalTaskPanel"))

function var0_0.UpdateList(arg0_1, arg1_1)
	arg0_1.UIlist:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_1[arg1_2 + 1]
			local var1_2 = arg2_2:Find("frame/slider"):GetComponent(typeof(Slider))
			local var2_2 = arg2_2:Find("frame/progress")
			local var3_2 = arg2_2:Find("frame/progress_1")
			local var4_2 = arg2_2:Find("frame/awards")
			local var5_2 = arg2_2:Find("frame/desc")
			local var6_2 = arg2_2:Find("frame/get_btn")
			local var7_2 = arg2_2:Find("frame/got_btn")
			local var8_2 = arg2_2:Find("frame/go_btn")

			setText(var5_2, var0_2:getConfig("desc"))

			local var9_2, var10_2 = arg0_1:getTaskProgress(var0_2)
			local var11_2, var12_2 = arg0_1:getTaskTarget(var0_2)

			var1_2.value = var9_2 / var11_2

			setText(var2_2, var10_2)
			setText(var3_2, "/" .. var12_2)

			local var13_2 = var2_2:GetComponent(typeof(Text))
			local var14_2 = var3_2:GetComponent(typeof(Text))
			local var15_2 = var13_2.preferredWidth
			local var16_2 = var14_2.preferredWidth

			var2_2.sizeDelta = Vector2(var15_2, var2_2.sizeDelta.y)
			var3_2.sizeDelta = Vector2(var16_2, var3_2.sizeDelta.y)

			local var17_2 = var3_2.anchoredPosition.x - var16_2 * var3_2.pivot.x - var15_2 * (1 - var2_2.pivot.x)

			var2_2.anchoredPosition = Vector2(var17_2, var2_2.anchoredPosition.y)

			local var18_2 = var4_2:GetChild(0)

			arg0_1:updateAwards(var0_2:getConfig("award_display"), var4_2, var18_2)
			setActive(var7_2, var0_2:getTaskStatus() == 2)
			setActive(var6_2, var0_2:getTaskStatus() == 1)
			setActive(var8_2, var0_2:getTaskStatus() == 0)
			onButton(arg0_1, var8_2, function()
				arg0_1._parent:emit(MedalAlbumTemplateMediator.ON_TASK_GO, var0_2)
			end, SFX_PANEL)
			onButton(arg0_1, var6_2, function()
				arg0_1._parent:emit(MedalAlbumTemplateMediator.ON_TASK_SUBMIT, var0_2)
			end, SFX_PANEL)
		end
	end)
	arg0_1.UIlist:align(#arg1_1)

	if arg0_1._parent.TASK_ANIM and arg0_1._parent.TASK_ENTER_ANIM_Time and arg0_1._parent.TASK_Time then
		local var0_1 = findTF(arg0_1._tf, "panel/list").transform.childCount

		onDelayTick(function()
			for iter0_5 = 0, var0_1 - 1 do
				local var0_5 = findTF(arg0_1._tf, "panel/list"):GetChild(iter0_5)

				onDelayTick(function()
					if arg0_1._parent.exited then
						return
					end

					quickPlayAnimation(var0_5, arg0_1._parent.TASK_ANIM)
				end, arg0_1._parent.TASK_Time * (iter0_5 + 1))
			end
		end, arg0_1._parent.TASK_ENTER_ANIM_Time)
	end
end

return var0_0
