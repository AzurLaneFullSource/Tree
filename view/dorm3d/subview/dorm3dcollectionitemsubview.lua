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
			local var3_2 = ApartmentProxy.CheckUnlockConfig(var1_2.unlock)
			local var4_2 = arg1_2

			for iter0_2 = 1, 2 do
				cloneTplTo(arg0_1.numContainer:Find("num_" .. var4_2 % 10), arg2_2:Find("num"))

				var4_2 = math.floor(var4_2 / 10)
			end

			setActive(arg2_2:Find("content/lock"), not var3_2)
			setActive(arg2_2:Find("content/mark"), var3_2 and not var2_2)
			setText(arg2_2:Find("content/name"), var2_2 and var1_2.name or var3_2 and i18n("dorm3d_collect_not_found", i18n(var1_2.text)) or i18n("dorm3d_collect_locked", var1_2.unlock[2]))

			local function var5_2(arg0_3)
				setTextColor(arg2_2:Find("content/name"), Color.NewHex(not var2_2 and "a9a9a9" or arg0_3 and "2d1dfc" or "393a3c"))
				eachChild(arg2_2:Find("num"), function(arg0_4)
					setImageColor(arg0_4, Color.NewHex(arg0_3 and "2d1dfd" or "393a3c"))
				end)
			end

			onToggle(arg0_1, arg2_2, function(arg0_5)
				if arg0_5 then
					arg0_1:UpdateDisplay(arg1_2, var0_2)
				end

				var5_2(arg0_5)
			end, SFX_PANEL)
			var5_2()
		end
	end)

	arg0_1.numContainer = arg0_1._tf:Find("list/number")
	arg0_1.rtInfo = arg0_1._tf:Find("info")
end

function var0_0.OnInit(arg0_6)
	arg0_6.dorm3dmainscene = pg.m02:retrieveMediator(Dorm3dRoomMediator.__cname):getViewComponent()

	local var0_6 = getProxy(ApartmentProxy):getRoom(arg0_6.contextData.roomId)

	arg0_6.unlockDic = var0_6.collectItemDic
	arg0_6.ids = Clone(pg.dorm3d_collection_template.get_id_list_by_room_id[var0_6:GetConfigID()] or {})

	table.sort(arg0_6.ids, CompareFuncs({
		function(arg0_7)
			return arg0_6.unlockDic[arg0_7] and 0 or 1
		end,
		function(arg0_8)
			return ApartmentProxy.CheckUnlockConfig(pg.dorm3d_collection_template[arg0_8].unlock) and 0 or 1
		end,
		function(arg0_9)
			return arg0_9
		end
	}))
	setText(arg0_6.rtInfo:Find("count"), string.format("<color=#2d1dfc>%d</color>/%d", table.getCount(arg0_6.unlockDic), #arg0_6.ids))
	arg0_6.itemList:align(#arg0_6.ids)
	triggerToggle(arg0_6.itemList.container:GetChild(0), true)
end

function var0_0.UpdateDisplay(arg0_10, arg1_10, arg2_10)
	local var0_10 = pg.dorm3d_collection_template[arg2_10]
	local var1_10 = arg0_10.unlockDic[arg2_10]

	setActive(arg0_10.rtInfo:Find("empty"), not var1_10)

	if not var1_10 then
		local var2_10

		if not _.any(var0_10.model, function(arg0_11)
			local var0_11
			local var1_11, var2_11 = arg0_10.dorm3dmainscene:CheckSceneItemActiveByPath(arg0_11)

			var2_10 = var2_11

			return var1_11
		end) then
			local var3_10 = Dorm3dFurniture.New({
				configId = var2_10
			}):GetName()

			setText(arg0_10.rtInfo:Find("empty"), i18n("dorm3d_collect_block_by_furniture", var3_10))
		else
			setText(arg0_10.rtInfo:Find("empty"), i18n("dorm3d_collect_nothing"))
		end
	end

	local var4_10 = arg0_10.rtInfo:Find("content")

	setActive(var4_10, var1_10)

	if not var1_10 then
		return
	end

	GetImageSpriteFromAtlasAsync("dorm3dcollection/" .. var0_10.icon, "", var4_10:Find("icon"), true)
	setText(var4_10:Find("name/Text"), var0_10.name)
	setText(var4_10:Find("desc"), var0_10.desc)
	setActive(var4_10:Find("favor"), var0_10.award > 0)

	if var0_10.award > 0 then
		local var5_10 = pg.dorm3d_favor_trigger[var0_10.award].num

		setText(var4_10:Find("favor/Text"), i18n("dorm3d_collect_favor_plus") .. var5_10)
	end
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
