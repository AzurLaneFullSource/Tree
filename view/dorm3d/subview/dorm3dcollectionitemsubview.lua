local var0 = class("Dorm3dCollectionItemSubView", import("view.base.BaseSubView"))

function var0.OnLoaded(arg0)
	local var0 = arg0._tf:Find("list/container")

	arg0.itemList = UIItemList.New(var0, var0:Find("tpl"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.ids[arg1]
			local var1 = pg.dorm3d_collection_template[var0]
			local var2 = arg0.unlockDic[var0]
			local var3 = arg0.contextData.apartment:checkUnlockConfig(var1.unlock)
			local var4 = arg1

			for iter0 = 1, 2 do
				cloneTplTo(arg0.numContainer:Find("num_" .. var4 % 10), arg2:Find("num"))

				var4 = math.floor(var4 / 10)
			end

			setActive(arg2:Find("content/lock"), not var3)
			setActive(arg2:Find("content/mark"), var3 and not var2)
			setText(arg2:Find("content/name"), var2 and var1.name or string.format("locked:%s", var0))
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0:UpdateDisplay(arg1, var0)
				end

				setTextColor(arg2:Find("content/name"), Color.NewHex(not var2 and "a9a9a9" or arg0 and "2d1dfc" or "393a3c"))
				eachChild(arg2:Find("num"), function(arg0)
					setImageColor(arg0, Color.NewHex(arg0 and "2d1dfd" or "393a3c"))
				end)
			end, SFX_PANEL)
		end
	end)

	arg0.numContainer = arg0._tf:Find("list/number")
	arg0.rtInfo = arg0._tf:Find("info")
end

function var0.OnInit(arg0)
	local var0 = arg0.contextData.apartment

	arg0.unlockDic = var0.collectItemDic

	setText(arg0.rtInfo:Find("count"), string.format("<color=#2d1dfc>%d</color>/%d", table.getCount(arg0.unlockDic), #var0:getCollectConfig("recall_list")))
	setText(arg0.rtInfo:Find("empty"), "with out anything")

	arg0.ids = var0:getCollectConfig("collection_template_list")

	arg0.itemList:align(#arg0.ids)
	triggerToggle(arg0.itemList.container:GetChild(0), true)
end

function var0.UpdateDisplay(arg0, arg1, arg2)
	local var0 = arg0.unlockDic[arg2]

	setActive(arg0.rtInfo:Find("empty"), not var0)

	local var1 = arg0.rtInfo:Find("content")

	setActive(var1, var0)

	if not var0 then
		return
	end

	local var2 = pg.dorm3d_collection_template[arg2]

	GetImageSpriteFromAtlasAsync("dorm3dcollection/" .. var2.model, "", var1:Find("icon"), true)
	setText(var1:Find("name/Text"), var2.name)
	setText(var1:Find("desc"), var2.desc)

	local var3 = pg.dorm3d_favor_trigger[var2.award].num

	setText(var1:Find("favor/Text"), string.format("favor plus:%d", var3))
end

function var0.OnDestroy(arg0)
	return
end

return var0
