local var0_0 = class("Dorm3dCollectionItemSubView", import("view.base.BaseSubView"))

function var0_0.OnLoaded(arg0_1)
	local var0_1 = arg0_1._tf:Find("list/container")

	arg0_1.itemList = UIItemList.New(var0_1, var0_1:Find("tpl"))

	arg0_1.itemList:make(function(arg0_2, arg1_2, arg2_2)
		arg1_2 = arg1_2 + 1

		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg0_1.ids[arg1_2]
			local var1_2 = pg.dorm3d_collection_template[var0_2]
			local var2_2 = arg0_1.unlockDic[var0_2]
			local var3_2 = arg0_1.contextData.apartment:checkUnlockConfig(var1_2.unlock)
			local var4_2 = arg1_2

			for iter0_2 = 1, 2 do
				cloneTplTo(arg0_1.numContainer:Find("num_" .. var4_2 % 10), arg2_2:Find("num"))

				var4_2 = math.floor(var4_2 / 10)
			end

			setActive(arg2_2:Find("content/lock"), not var3_2)
			setActive(arg2_2:Find("content/mark"), var3_2 and not var2_2)
			setText(arg2_2:Find("content/name"), var2_2 and var1_2.name or string.format("locked:%s", var0_2))
			onToggle(arg0_1, arg2_2, function(arg0_3)
				if arg0_3 then
					arg0_1:UpdateDisplay(arg1_2, var0_2)
				end

				setTextColor(arg2_2:Find("content/name"), Color.NewHex(not var2_2 and "a9a9a9" or arg0_3 and "2d1dfc" or "393a3c"))
				eachChild(arg2_2:Find("num"), function(arg0_4)
					setImageColor(arg0_4, Color.NewHex(arg0_3 and "2d1dfd" or "393a3c"))
				end)
			end, SFX_PANEL)
		end
	end)

	arg0_1.numContainer = arg0_1._tf:Find("list/number")
	arg0_1.rtInfo = arg0_1._tf:Find("info")
end

function var0_0.OnInit(arg0_5)
	local var0_5 = arg0_5.contextData.apartment

	arg0_5.unlockDic = var0_5.collectItemDic

	setText(arg0_5.rtInfo:Find("count"), string.format("<color=#2d1dfc>%d</color>/%d", table.getCount(arg0_5.unlockDic), #var0_5:getCollectConfig("recall_list")))
	setText(arg0_5.rtInfo:Find("empty"), "with out anything")

	arg0_5.ids = var0_5:getCollectConfig("collection_template_list")

	arg0_5.itemList:align(#arg0_5.ids)
	triggerToggle(arg0_5.itemList.container:GetChild(0), true)
end

function var0_0.UpdateDisplay(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.unlockDic[arg2_6]

	setActive(arg0_6.rtInfo:Find("empty"), not var0_6)

	local var1_6 = arg0_6.rtInfo:Find("content")

	setActive(var1_6, var0_6)

	if not var0_6 then
		return
	end

	local var2_6 = pg.dorm3d_collection_template[arg2_6]

	GetImageSpriteFromAtlasAsync("dorm3dcollection/" .. var2_6.model, "", var1_6:Find("icon"), true)
	setText(var1_6:Find("name/Text"), var2_6.name)
	setText(var1_6:Find("desc"), var2_6.desc)

	local var3_6 = pg.dorm3d_favor_trigger[var2_6.award].num

	setText(var1_6:Find("favor/Text"), string.format("favor plus:%d", var3_6))
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
