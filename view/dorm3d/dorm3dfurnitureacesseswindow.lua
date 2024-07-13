local var0_0 = class("Dorm3dFurnitureAcessesWindow", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dFurnitureAcessesWindow"
end

function var0_0.init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("Mask"), function()
		existCall(arg0_3.contextData.onClose)
		arg0_3:closeView()
	end)
	onButton(arg0_3, arg0_3._tf:Find("Window/Close"), function()
		existCall(arg0_3.contextData.onClose)
		arg0_3:closeView()
	end, SFX_CANCEL)
	setText(arg0_3._tf:Find("Window/Title"), arg0_3.contextData.title)
	setText(arg0_3._tf:Find("Window/Acesses/Text"), i18n("dorm3d_furniture_window_acesses"))
	arg0_3:ShowSingleItemBox(arg0_3.contextData)
	arg0_3:ShowCommonObtainWindow(arg0_3.contextData)
end

function var0_0.ShowSingleItemBox(arg0_6, arg1_6)
	local var0_6 = arg0_6._tf:Find("Window/Icon")

	updateDrop(var0_6, arg1_6.drop)

	local var1_6 = arg1_6.name or arg1_6.drop.cfg.name or ""

	setText(arg0_6._tf:Find("Window/Name"), var1_6)
	setText(arg0_6._tf:Find("Window/Count"), i18n("child_msg_owned", setColorStr(arg1_6.drop.count, "#39bfff")))

	local var2_6 = arg0_6._tf:Find("Window/Content")

	setText(var2_6, arg1_6.drop.cfg.desc)
end

function var0_0.ShowCommonObtainWindow(arg0_7, arg1_7)
	local var0_7 = defaultValue(arg1_7.showGOBtn, false)

	arg0_7.obtainSkipList = arg0_7.obtainSkipList or UIItemList.New(arg0_7._tf:Find("Window/List"), arg0_7._tf:Find("Window/List"):GetChild(0))

	arg0_7.obtainSkipList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg1_7.list[arg1_8 + 1]
			local var1_8 = var0_8[1]
			local var2_8 = var0_8[2]
			local var3_8 = var0_8[3]
			local var4_8 = HXSet.hxLan(var1_8)

			arg2_8:Find("Mask/Text"):GetComponent("ScrollText"):SetText(var4_8)
			setActive(arg2_8:Find("Button"), var0_7 and var2_8[1] ~= "" and var2_8[1] ~= "COLLECTSHIP")

			if var2_8[1] ~= "" then
				onButton(arg0_7, arg2_8:Find("Button"), function()
					if var3_8 and var3_8 ~= 0 then
						local var0_9 = getProxy(ActivityProxy):getActivityById(var3_8)

						if not var0_9 or var0_9:isEnd() then
							pg.TipsMgr.GetInstance():ShowTips(i18n("collection_way_is_unopen"))

							return
						end
					elseif var2_8[1] == "SHOP" and var2_8[2].warp == NewShopsScene.TYPE_MILITARY_SHOP and not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "MilitaryExerciseMediator") then
						pg.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

						return
					elseif var2_8[1] == "LEVEL" and var2_8[2] then
						local var1_9 = var2_8[2].chapterid
						local var2_9 = getProxy(ChapterProxy)
						local var3_9 = var2_9:getChapterById(var1_9)

						if var3_9:isUnlock() then
							local var4_9 = var2_9:getActiveChapter()

							if var4_9 and var4_9.id ~= var1_9 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("collect_chapter_is_activation"))

								return
							else
								local var5_9 = {
									mapIdx = var3_9:getConfig("map")
								}

								if var3_9.active then
									var5_9.chapterId = var3_9.id
								else
									var5_9.openChapterId = var1_9
								end

								pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var5_9)
							end
						else
							pg.TipsMgr.GetInstance():ShowTips(i18n("acquisitionmode_is_not_open"))

							return
						end
					elseif var2_8[1] == "COLLECTSHIP" then
						if arg1_7.mediatorName == CollectionMediator.__cname then
							pg.m02:sendNotification(CollectionMediator.EVENT_OBTAIN_SKIP, {
								toggle = 2,
								displayGroupId = var2_8[2].shipGroupId
							})
						else
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COLLECTSHIP, {
								toggle = 2,
								displayGroupId = var2_8[2].shipGroupId
							})
						end
					elseif var2_8[1] == "SHOP" then
						pg.m02:sendNotification(GAME.GO_SCENE, SCENE[var2_8[1]], var2_8[2])
					else
						pg.m02:sendNotification(GAME.GO_SCENE, SCENE[var2_8[1]], var2_8[2])
					end

					arg0_7:closeView()
				end, SFX_PANEL)
			end
		end
	end)
	arg0_7.obtainSkipList:align(#arg1_7.list)
end

function var0_0.willExit(arg0_10)
	return
end

return var0_0
