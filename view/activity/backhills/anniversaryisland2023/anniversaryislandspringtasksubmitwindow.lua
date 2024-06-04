local var0 = class("AnniversaryIslandSpringTaskSubmitWindow", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AnniversaryIslandSpringTaskSubmitWindow"
end

function var0.init(arg0)
	setText(arg0._tf:Find("Content/Tips"), i18n("sub_item_warning"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:onBackPressed()
	end)
	onButton(arg0, arg0._tf:Find("Content/Cancel"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Content/Submit"), function()
		arg0:emit(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK)
	end, SFX_CONFIRM)

	local var0 = arg0.contextData.task
	local var1 = {
		{
			type = tonumber(var0:getConfig("target_id")),
			id = tonumber(var0:getConfig("target_id_2")),
			count = var0:getConfig("target_num")
		}
	}

	UIItemList.StaticAlign(arg0._tf:Find("Content/Icons"), arg0._tf:Find("Content/Icons"):GetChild(0), #var1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var1[arg1 + 1]

		updateDrop(arg2:Find("Mask/IconTpl"), var0)
		onButton(arg0, arg2, function()
			if var0.type == DROP_TYPE_WORKBENCH_DROP then
				arg0:emit(WorkBenchItemDetailMediator.SHOW_DETAIL, WorkBenchItem.New({
					configId = var0.id,
					count = var0.count
				}))
			else
				arg0:emit(BaseUI.ON_DROP, var0)
			end
		end)
	end)
end

function var0.willExit(arg0)
	return
end

return var0
