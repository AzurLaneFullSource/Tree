local var0_0 = class("Dorm3dMemorySubView", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

function var0_0.Init(arg0_1)
	arg0_1:OnLoaded()
	arg0_1:OnInit()
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("list/container")

	arg0_2.itemList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		arg1_3 = arg1_3 + 1

		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2.ids[arg1_3]
			local var1_3 = pg.dorm3d_recall[var0_3]
			local var2_3 = arg0_2.unlockDic[var1_3.story_id]

			setText(arg2_3:Find("name"), var2_3 and var1_3.name or i18n("dorm3d_recall_locked"))
			GetImageSpriteFromAtlasAsync(string.format("dorm3dmemory/%s_list", var1_3.image), "", arg2_3:Find("Image"))
			setImageAlpha(arg2_3:Find("Image"), var2_3 and 1 or 0.6)
			onToggle(arg0_2, arg2_3, function(arg0_4)
				if arg0_4 then
					arg0_2:UpdateDisplay(arg1_3, var0_3)
				end
			end, SFX_PANEL)
		end
	end)

	arg0_2.rtInfo = arg0_2._tf:Find("info")
end

function var0_0.OnInit(arg0_5)
	arg0_5.ids = getProxy(ApartmentProxy):getRoom(arg0_5.contextData.roomId):getConfig("recall_list")
	arg0_5.unlockDic = {}

	local var0_5 = {}
	local var1_5 = 0

	for iter0_5, iter1_5 in ipairs(arg0_5.ids) do
		local var2_5 = pg.dorm3d_recall[iter1_5].story_id
		local var3_5 = pg.dorm3d_dialogue_group[var2_5].char_id

		if var0_5[var3_5] == nil then
			var0_5[var3_5] = getProxy(ApartmentProxy):getApartment(var3_5) or false
		end

		arg0_5.unlockDic[var2_5] = var0_5[var3_5] and var0_5[var3_5].talkDic[var2_5] or false

		if arg0_5.unlockDic[var2_5] then
			var1_5 = var1_5 + 1
		end
	end

	setText(arg0_5.rtInfo:Find("count"), string.format("<color=#285cfc>%d</color>/%d", var1_5, #arg0_5.ids))
	arg0_5.itemList:align(#arg0_5.ids)
	triggerToggle(arg0_5.itemList.container:GetChild(0), true)
end

function var0_0.UpdateDisplay(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.rtInfo:Find("content")
	local var1_6 = pg.dorm3d_recall[arg2_6]
	local var2_6 = arg0_6.unlockDic[var1_6.story_id]

	GetImageSpriteFromAtlasAsync(string.format("dorm3dmemory/%s_info", var1_6.image), "", var0_6:Find("icon"))
	setImageAlpha(var0_6:Find("icon"), var2_6 and 1 or 0.25)
	setText(var0_6:Find("icon/lock/Text"), i18n("dorm3d_reload_unlock"))
	setActive(var0_6:Find("icon/lock"), not var2_6)
	setActive(var0_6:Find("icon/play"), var2_6)
	onButton(arg0_6, var0_6:Find("icon/play"), function()
		arg0_6:emit(Dorm3dCollectionMediator.DO_TALK, var1_6.story_id)
	end, SFX_CONFIRM)
	setText(var0_6:Find("pro/Text"), "is pro")
	setActive(var0_6:Find("pro"), var1_6.type == 2)
	setImageAlpha(var0_6:Find("name/bg"), var2_6 and 1 or 0)
	setActive(var0_6:Find("name"), var2_6)
	setActive(var0_6:Find("name_lock"), not var2_6)

	if var2_6 then
		setText(var0_6:Find("name/number"), string.format("%02d.", arg1_6))
		setText(var0_6:Find("name/Text"), var1_6.name)
		setText(var0_6:Find("name/Text/en"), i18n("dorm3d_collection_title_en"))
		setText(var0_6:Find("desc"), var1_6.desc)
	else
		setText(var0_6:Find("name_lock"), i18n("dorm3d_reload_unlock_name"))
		setText(var0_6:Find("desc"), var1_6.unlock_text)
	end
end

return var0_0
