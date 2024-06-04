local var0 = class("Dorm3dFurnitureAcessesWindow", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dFurnitureAcessesWindow"
end

function var0.init(arg0)
	return
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Mask"), function()
		existCall(arg0.contextData.onClose)
		arg0:closeView()
	end)
	onButton(arg0, arg0._tf:Find("Window/Close"), function()
		existCall(arg0.contextData.onClose)
		arg0:closeView()
	end, SFX_CANCEL)
	setText(arg0._tf:Find("Window/Title"), arg0.contextData.title)
	setText(arg0._tf:Find("Window/Acesses/Text"), i18n("dorm3d_furniture_window_acesses"))
	arg0:ShowSingleItemBox(arg0.contextData)
	arg0:ShowCommonObtainWindow(arg0.contextData)
end

function var0.ShowSingleItemBox(arg0, arg1)
	local var0 = arg0._tf:Find("Window/Icon")

	updateDrop(var0, arg1.drop)

	local var1 = arg1.name or arg1.drop.cfg.name or ""

	setText(arg0._tf:Find("Window/Name"), var1)
	setText(arg0._tf:Find("Window/Count"), i18n("child_msg_owned", setColorStr(arg1.drop.count, "#39bfff")))

	local var2 = arg0._tf:Find("Window/Content")

	setText(var2, arg1.drop.cfg.desc)
end

function var0.ShowCommonObtainWindow(arg0, arg1)
	local var0 = defaultValue(arg1.showGOBtn, false)

	arg0.obtainSkipList = arg0.obtainSkipList or UIItemList.New(arg0._tf:Find("Window/List"), arg0._tf:Find("Window/List"):GetChild(0))

	arg0.obtainSkipList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1.list[arg1 + 1]
			local var1 = var0[1]
			local var2 = var0[2]
			local var3 = var0[3]
			local var4 = HXSet.hxLan(var1)

			arg2:Find("Mask/Text"):GetComponent("ScrollText"):SetText(var4)
			setActive(arg2:Find("Button"), var0 and var2[1] ~= "" and var2[1] ~= "COLLECTSHIP")

			if var2[1] ~= "" then
				onButton(arg0, arg2:Find("Button"), function()
					if var3 and var3 ~= 0 then
						local var0 = getProxy(ActivityProxy):getActivityById(var3)

						if not var0 or var0:isEnd() then
							pg.TipsMgr.GetInstance():ShowTips(i18n("collection_way_is_unopen"))

							return
						end
					elseif var2[1] == "SHOP" and var2[2].warp == NewShopsScene.TYPE_MILITARY_SHOP and not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "MilitaryExerciseMediator") then
						pg.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

						return
					elseif var2[1] == "LEVEL" and var2[2] then
						local var1 = var2[2].chapterid
						local var2 = getProxy(ChapterProxy)
						local var3 = var2:getChapterById(var1)

						if var3:isUnlock() then
							local var4 = var2:getActiveChapter()

							if var4 and var4.id ~= var1 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("collect_chapter_is_activation"))

								return
							else
								local var5 = {
									mapIdx = var3:getConfig("map")
								}

								if var3.active then
									var5.chapterId = var3.id
								else
									var5.openChapterId = var1
								end

								pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var5)
							end
						else
							pg.TipsMgr.GetInstance():ShowTips(i18n("acquisitionmode_is_not_open"))

							return
						end
					elseif var2[1] == "COLLECTSHIP" then
						if arg1.mediatorName == CollectionMediator.__cname then
							pg.m02:sendNotification(CollectionMediator.EVENT_OBTAIN_SKIP, {
								toggle = 2,
								displayGroupId = var2[2].shipGroupId
							})
						else
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COLLECTSHIP, {
								toggle = 2,
								displayGroupId = var2[2].shipGroupId
							})
						end
					elseif var2[1] == "SHOP" then
						pg.m02:sendNotification(GAME.GO_SCENE, SCENE[var2[1]], var2[2])
					else
						pg.m02:sendNotification(GAME.GO_SCENE, SCENE[var2[1]], var2[2])
					end

					arg0:closeView()
				end, SFX_PANEL)
			end
		end
	end)
	arg0.obtainSkipList:align(#arg1.list)
end

function var0.willExit(arg0)
	return
end

return var0
