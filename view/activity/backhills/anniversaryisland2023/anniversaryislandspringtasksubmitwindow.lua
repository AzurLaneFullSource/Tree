local var0_0 = class("AnniversaryIslandSpringTaskSubmitWindow", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryIslandSpringTaskSubmitWindow"
end

function var0_0.init(arg0_2)
	setText(arg0_2._tf:Find("Content/Tips"), i18n("sub_item_warning"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("BG"), function()
		arg0_3:onBackPressed()
	end)
	onButton(arg0_3, arg0_3._tf:Find("Content/Cancel"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("Content/Submit"), function()
		arg0_3:emit(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK)
	end, SFX_CONFIRM)

	local var0_3 = arg0_3.contextData.task
	local var1_3 = {
		{
			type = tonumber(var0_3:getConfig("target_id")),
			id = tonumber(var0_3:getConfig("target_id_2")),
			count = var0_3:getConfig("target_num")
		}
	}

	UIItemList.StaticAlign(arg0_3._tf:Find("Content/Icons"), arg0_3._tf:Find("Content/Icons"):GetChild(0), #var1_3, function(arg0_7, arg1_7, arg2_7)
		if arg0_7 ~= UIItemList.EventUpdate then
			return
		end

		local var0_7 = var1_3[arg1_7 + 1]

		updateDrop(arg2_7:Find("Mask/IconTpl"), var0_7)
		onButton(arg0_3, arg2_7, function()
			if var0_7.type == DROP_TYPE_WORKBENCH_DROP then
				arg0_3:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
					configId = var0_7.id,
					count = var0_7.count
				}))
			else
				arg0_3:emit(BaseUI.ON_DROP, var0_7)
			end
		end)
	end)
end

function var0_0.willExit(arg0_9)
	return
end

return var0_0
