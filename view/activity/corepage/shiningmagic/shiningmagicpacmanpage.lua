local var0_0 = class("ShiningMagicPacmanPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.btnGo = arg0_1.AD:Find("btn_act")
	arg0_1.btnManual = arg0_1.AD:Find("TopPage/top/manual")
	arg0_1.Txtmanual = arg0_1.btnManual:Find("Text")
	arg0_1.redPoint = arg0_1.btnGo:Find("red_point")
	arg0_1.redMalPoint = arg0_1.btnManual:Find("tip")
end

function var0_0.OnFirstFlush(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client").medal_group_id
	local var1_2 = arg0_2.coreActivityUI:GetActivityIdByPageClass("ShiningMagicInvitationPage")

	if arg0_2:GetMallActOpen() then
		onButton(arg0_2, arg0_2.btnGo, function()
			local var0_3 = getProxy(ActivityProxy):getActivityById(var1_2)

			if not (not var0_3 or var0_3:isEnd()) then
				updateActivityTaskStatus(var0_3)

				local var1_3, var2_3 = getActivityTask(var0_3, true)

				if var1_3 and var2_3 and not var2_3:isFinish() then
					pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
						taskId = var1_3
					})
				end
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.REVERSE_PACMAN_HOME)
		end, SFX_PANEL)
	else
		onButton(arg0_2, arg0_2.btnGo, function()
			arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, Context.New({
				mediator = ReversePacmanTaskMediator,
				viewComponent = ReversePacmanTaskScene,
				data = {
					awardHandledByParent = true,
					onExit = function()
						arg0_2:refreshRed()
					end
				}
			}))
		end, SFX_PANEL)
	end

	onButton(arg0_2, arg0_2.btnManual, function()
		local var0_6 = Context.New({
			mediator = MedalAlbumTemplateMediator,
			viewComponent = arg0_2:GetMedalGropClassById(var0_2)
		})

		arg0_2:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_6)
	end, SFX_PANEL)
	setText(arg0_2.Txtmanual, i18n("anniversary_nine_main_page"))
	arg0_2:refreshRed()
end

function var0_0.GetMallActOpen(arg0_7)
	local var0_7 = ReversePacmanTools.GetActivity()

	return var0_7 ~= nil and not var0_7:isEnd()
end

function var0_0.OnUpdateFlush(arg0_8)
	arg0_8:refreshRed()
end

function var0_0.refreshRed(arg0_9)
	local var0_9 = arg0_9.activity:getConfig("config_client")

	if var0_9.is_showMedal then
		local var1_9 = var0_9.medal_group_id

		setActive(arg0_9.redMalPoint, ActivityMedalGroup.showTip(var1_9))
	end

	setActive(arg0_9.redPoint, ReversePacmanTools.GetActivity():readyToAchieve())
end

function var0_0.GetMedalGropClassById(arg0_10, arg1_10)
	local var0_10 = pg.activity_medal_group[arg1_10].ui_prefab.scene

	return _G[var0_10]
end

return var0_0
