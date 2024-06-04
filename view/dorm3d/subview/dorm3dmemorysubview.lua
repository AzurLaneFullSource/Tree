local var0 = class("Dorm3dMemorySubView", import("view.base.BaseSubView"))

function var0.OnLoaded(arg0)
	local var0 = arg0._tf:Find("list/container")

	arg0.itemList = UIItemList.New(var0, var0:Find("tpl"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.ids[arg1]
			local var1 = pg.dorm3D_recall[var0]
			local var2 = arg0.unlockDic[var1.story_id]

			setText(arg2:Find("name"), var2 and var1.name or string.format("locked:%s", var0))
			GetImageSpriteFromAtlasAsync(string.format("dorm3dmemory/%s_list", var1.image), "", arg2:Find("Image"))
			setImageAlpha(arg2:Find("Image"), var2 and 0.6 or 1)
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0:UpdateDisplay(arg1, var0)
				end
			end, SFX_PANEL)
		end
	end)

	arg0.rtInfo = arg0._tf:Find("info")
end

function var0.OnInit(arg0)
	local var0 = arg0.contextData.apartment

	arg0.unlockDic = var0.talkDic

	setText(arg0.rtInfo:Find("count"), string.format("<color=#285cfc>%d</color>/%d", table.getCount(arg0.unlockDic), #var0:getCollectConfig("recall_list")))

	arg0.ids = var0:getCollectConfig("recall_list")

	arg0.itemList:align(#arg0.ids)
	triggerToggle(arg0.itemList.container:GetChild(0), true)
end

function var0.UpdateDisplay(arg0, arg1, arg2)
	local var0 = arg0.rtInfo:Find("content")
	local var1 = pg.dorm3D_recall[arg2]
	local var2 = arg0.unlockDic[var1.story_id]

	GetImageSpriteFromAtlasAsync(string.format("dorm3dmemory/%s_info", var1.image), "", var0:Find("icon"))
	setImageAlpha(var0:Find("icon"), var2 and 1 or 0.25)
	setText(var0:Find("icon/lock/Text"), "wait for unlock")
	setActive(var0:Find("icon/lock"), not var2)
	setActive(var0:Find("icon/play"), var2)
	onButton(arg0, var0:Find("icon/play"), function()
		arg0:emit(Dorm3dCollectionMediator.DO_TALK, var1.story_id)
	end, SFX_CONFIRM)
	setText(var0:Find("pro/Text"), "is pro")
	setActive(var0:Find("pro"), var1.type == 2)
	setImageAlpha(var0:Find("name/bg"), var2 and 1 or 0)

	if var2 then
		setText(var0:Find("name/number"), string.format("%02d.", arg1))
		setText(var0:Find("name/Text"), var1.name)
		setText(var0:Find("name/Text/en"), "ababababababab")
		setText(var0:Find("desc"), var1.desc)
	else
		setText(var0:Find("name/number"), "")
		setText(var0:Find("name/Text"), string.format("<color=#a9a9a9>locked:%s</color>", arg2))
		setText(var0:Find("name/Text/en"), "")
		setText(var0:Find("desc"), var1.unlock)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
