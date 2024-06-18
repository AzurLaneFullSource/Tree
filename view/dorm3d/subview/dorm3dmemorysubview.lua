local var0_0 = class("Dorm3dMemorySubView", import("view.base.BaseSubView"))

function var0_0.OnLoaded(arg0_1)
	local var0_1 = arg0_1._tf:Find("list/container")

	arg0_1.itemList = UIItemList.New(var0_1, var0_1:Find("tpl"))

	arg0_1.itemList:make(function(arg0_2, arg1_2, arg2_2)
		arg1_2 = arg1_2 + 1

		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg0_1.ids[arg1_2]
			local var1_2 = pg.dorm3D_recall[var0_2]
			local var2_2 = arg0_1.unlockDic[var1_2.story_id]

			setText(arg2_2:Find("name"), var2_2 and var1_2.name or string.format("locked:%s", var0_2))
			GetImageSpriteFromAtlasAsync(string.format("dorm3dmemory/%s_list", var1_2.image), "", arg2_2:Find("Image"))
			setImageAlpha(arg2_2:Find("Image"), var2_2 and 0.6 or 1)
			onToggle(arg0_1, arg2_2, function(arg0_3)
				if arg0_3 then
					arg0_1:UpdateDisplay(arg1_2, var0_2)
				end
			end, SFX_PANEL)
		end
	end)

	arg0_1.rtInfo = arg0_1._tf:Find("info")
end

function var0_0.OnInit(arg0_4)
	local var0_4 = arg0_4.contextData.apartment

	arg0_4.unlockDic = var0_4.talkDic

	setText(arg0_4.rtInfo:Find("count"), string.format("<color=#285cfc>%d</color>/%d", table.getCount(arg0_4.unlockDic), #var0_4:getCollectConfig("recall_list")))

	arg0_4.ids = var0_4:getCollectConfig("recall_list")

	arg0_4.itemList:align(#arg0_4.ids)
	triggerToggle(arg0_4.itemList.container:GetChild(0), true)
end

function var0_0.UpdateDisplay(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.rtInfo:Find("content")
	local var1_5 = pg.dorm3D_recall[arg2_5]
	local var2_5 = arg0_5.unlockDic[var1_5.story_id]

	GetImageSpriteFromAtlasAsync(string.format("dorm3dmemory/%s_info", var1_5.image), "", var0_5:Find("icon"))
	setImageAlpha(var0_5:Find("icon"), var2_5 and 1 or 0.25)
	setText(var0_5:Find("icon/lock/Text"), "wait for unlock")
	setActive(var0_5:Find("icon/lock"), not var2_5)
	setActive(var0_5:Find("icon/play"), var2_5)
	onButton(arg0_5, var0_5:Find("icon/play"), function()
		arg0_5:emit(Dorm3dCollectionMediator.DO_TALK, var1_5.story_id)
	end, SFX_CONFIRM)
	setText(var0_5:Find("pro/Text"), "is pro")
	setActive(var0_5:Find("pro"), var1_5.type == 2)
	setImageAlpha(var0_5:Find("name/bg"), var2_5 and 1 or 0)

	if var2_5 then
		setText(var0_5:Find("name/number"), string.format("%02d.", arg1_5))
		setText(var0_5:Find("name/Text"), var1_5.name)
		setText(var0_5:Find("name/Text/en"), "ababababababab")
		setText(var0_5:Find("desc"), var1_5.desc)
	else
		setText(var0_5:Find("name/number"), "")
		setText(var0_5:Find("name/Text"), string.format("<color=#a9a9a9>locked:%s</color>", arg2_5))
		setText(var0_5:Find("name/Text/en"), "")
		setText(var0_5:Find("desc"), var1_5.unlock)
	end
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
