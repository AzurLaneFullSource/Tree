local var0_0 = class("Dorm3dCollectionItemSubView", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

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
			local var1_3 = pg.dorm3d_collection_template[var0_3]
			local var2_3 = arg0_2.unlockDic[var0_3]
			local var3_3 = ApartmentProxy.CheckUnlockConfig(var1_3.unlock)
			local var4_3 = arg1_3

			for iter0_3 = 1, 2 do
				cloneTplTo(arg0_2.numContainer:Find("num_" .. var4_3 % 10), arg2_3:Find("num"))

				var4_3 = math.floor(var4_3 / 10)
			end

			setActive(arg2_3:Find("content/lock"), not var3_3)
			setActive(arg2_3:Find("content/mark"), var3_3 and not var2_3)
			setText(arg2_3:Find("content/name"), var2_3 and var1_3.name or var3_3 and i18n("dorm3d_collect_not_found", i18n(var1_3.text)) or i18n("dorm3d_collect_locked", var1_3.unlock[2]))

			local function var5_3(arg0_4)
				setTextColor(arg2_3:Find("content/name"), Color.NewHex(not var2_3 and "a9a9a9" or arg0_4 and "2d1dfc" or "393a3c"))
				eachChild(arg2_3:Find("num"), function(arg0_5)
					setImageColor(arg0_5, Color.NewHex(arg0_4 and "2d1dfd" or "393a3c"))
				end)
			end

			onToggle(arg0_2, arg2_3, function(arg0_6)
				if arg0_6 then
					arg0_2:UpdateDisplay(arg1_3, var0_3)
				end

				var5_3(arg0_6)
			end, SFX_PANEL)
			var5_3()
		end
	end)

	arg0_2.numContainer = arg0_2._tf:Find("list/number")
	arg0_2.rtInfo = arg0_2._tf:Find("info")
end

function var0_0.OnInit(arg0_7)
	arg0_7.dorm3dmainscene = pg.m02:retrieveMediator(Dorm3dRoomMediator.__cname):getViewComponent()

	local var0_7 = getProxy(ApartmentProxy):getRoom(arg0_7.contextData.roomId)

	arg0_7.unlockDic = var0_7.collectItemDic
	arg0_7.ids = Clone(pg.dorm3d_collection_template.get_id_list_by_room_id[var0_7:GetConfigID()] or {})

	table.sort(arg0_7.ids, CompareFuncs({
		function(arg0_8)
			return arg0_7.unlockDic[arg0_8] and 0 or 1
		end,
		function(arg0_9)
			return ApartmentProxy.CheckUnlockConfig(pg.dorm3d_collection_template[arg0_9].unlock) and 0 or 1
		end,
		function(arg0_10)
			return arg0_10
		end
	}))
	setText(arg0_7.rtInfo:Find("count"), string.format("<color=#2d1dfc>%d</color>/%d", table.getCount(arg0_7.unlockDic), #arg0_7.ids))
	arg0_7.itemList:align(#arg0_7.ids)
	triggerToggle(arg0_7.itemList.container:GetChild(0), true)
end

function var0_0.UpdateDisplay(arg0_11, arg1_11, arg2_11)
	local var0_11 = pg.dorm3d_collection_template[arg2_11]
	local var1_11 = arg0_11.unlockDic[arg2_11]

	setActive(arg0_11.rtInfo:Find("empty"), not var1_11)

	if not var1_11 then
		local var2_11

		if not _.any(var0_11.model, function(arg0_12)
			local var0_12
			local var1_12, var2_12 = arg0_11.dorm3dmainscene:CheckSceneItemActiveByPath(arg0_12)

			var2_11 = var2_12

			return var1_12
		end) then
			local var3_11 = Dorm3dFurniture.New({
				configId = var2_11
			}):GetName()

			setText(arg0_11.rtInfo:Find("empty"), i18n("dorm3d_collect_block_by_furniture", var3_11))
		else
			setText(arg0_11.rtInfo:Find("empty"), i18n("dorm3d_collect_nothing"))
		end
	end

	local var4_11 = arg0_11.rtInfo:Find("content")

	setActive(var4_11, var1_11)

	if not var1_11 then
		return
	end

	GetImageSpriteFromAtlasAsync("dorm3dcollection/" .. var0_11.icon, "", var4_11:Find("icon"), true)
	setText(var4_11:Find("name/Text"), var0_11.name)
	setText(var4_11:Find("desc"), var0_11.desc)
	setActive(var4_11:Find("favor"), var0_11.award > 0)

	if var0_11.award > 0 then
		local var5_11 = pg.dorm3d_favor_trigger[var0_11.award].num

		setText(var4_11:Find("favor/Text"), i18n("dorm3d_collect_favor_plus") .. var5_11)
	end
end

return var0_0
