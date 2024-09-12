local var0_0 = class("FullPreviewSceneTemplate", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return arg0_1.UIName
end

function var0_0.BindActivityShop(arg0_2, arg1_2)
	onButton(arg0_2, arg1_2, function()
		arg0_2:emit(FullPreviewMediatorTemplate.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end, SFX_PANEL)
end

function var0_0.BindSkinShop(arg0_4, arg1_4)
	onButton(arg0_4, arg1_4, function()
		arg0_4:emit(FullPreviewMediatorTemplate.GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
end

function var0_0.BindBuildShip(arg0_6, arg1_6)
	onButton(arg0_6, arg1_6, function()
		local var0_7
		local var1_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1)
		local var2_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

		if var1_7 and not var1_7:isEnd() then
			var0_7 = BuildShipScene.PROJECTS.ACTIVITY
		elseif var2_7 and not var2_7:isEnd() then
			var0_7 = ({
				BuildShipScene.PROJECTS.SPECIAL,
				BuildShipScene.PROJECTS.LIGHT,
				BuildShipScene.PROJECTS.HEAVY
			})[var2_7:getConfig("config_client").id]
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_6:emit(FullPreviewMediatorTemplate.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = var0_7
		})
	end, SFX_PANEL)
end

function var0_0.BindBattle(arg0_8, arg1_8)
	onButton(arg0_8, arg1_8, function()
		local var0_9 = getProxy(ChapterProxy)
		local var1_9, var2_9 = var0_9:getLastMapForActivity()

		if not var1_9 or not var0_9:getMapById(var1_9):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_8:emit(FullPreviewMediatorTemplate.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_9,
				mapIdx = var1_9
			})
		end
	end, SFX_PANEL)
end

function var0_0.BindMiniGame(arg0_10, arg1_10, arg2_10)
	onButton(arg0_10, arg1_10, function()
		arg0_10:emit(FullPreviewMediatorTemplate.GO_MINIGAME, arg2_10)
	end, SFX_PANEL)
end

function var0_0.UpdateView(arg0_12)
	return
end

function var0_0.IsMiniGameTip(arg0_13)
	local var0_13 = pg.mini_game[arg0_13].hub_id
	local var1_13 = getProxy(MiniGameProxy):GetHubByHubId(var0_13)

	if var1_13.count > 0 then
		return true
	end

	if var1_13:getConfig("reward") ~= 0 and var1_13.usedtime >= var1_13:getConfig("reward_need") and var1_13.ultimate == 0 then
		return true
	end

	return false
end

function var0_0.IsShowMainTip(arg0_14)
	assert(false, "需要实现主界面入口红点逻辑")
end

return var0_0
