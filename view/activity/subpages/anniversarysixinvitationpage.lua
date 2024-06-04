local var0 = class("AnniversarySixInvitationPage", import("...base.BaseActivityPage"))

function var0.OnDataSetting(arg0)
	if arg0.ptData then
		arg0.ptData:Update(arg0.activity)
	else
		arg0.ptData = ActivityPtData.New(arg0.activity)
	end
end

function var0.OnFirstFlush(arg0)
	arg0.rtMarks = arg0._tf:Find("AD/progress")
	arg0.rtFinish = arg0._tf:Find("AD/award")

	local var0 = arg0._tf:Find("AD/btn_list")

	onButton(arg0, var0:Find("go"), function()
		local var0 = underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0)
			return arg0:getConfig("config_id") == 3
		end)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

		if var1 and not var1:isEnd() then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
				wraps = SixthAnniversaryIslandScene.SHOP
			})
		else
			arg0:emit(ActivityMediator.OPEN_LAYER, Context.New({
				mediator = SixthAnniversaryIslandShopMediator,
				viewComponent = SixthAnniversaryIslandShopLayer
			}))
		end
	end, SFX_PANEL)
	onButton(arg0, var0:Find("get"), function()
		local var0, var1 = arg0.ptData:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0.ptData:GetId(),
			arg1 = var1
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0, var1 = arg0.ptData:GetResProgress()
	local var2 = arg0.ptData:CanGetAward()
	local var3 = arg0.ptData:CanGetNextAward()
	local var4 = arg0._tf:Find("AD/btn_list")

	setActive(var4:Find("get"), var2)
	setActive(var4:Find("got"), not var3)
	setActive(var4:Find("go"), not var2 and var3)

	if var3 then
		var0 = math.min(var0, var1)
	else
		var0 = var1 + 1
	end

	local var5 = arg0.rtMarks.childCount

	for iter0 = 1, var5 do
		local var6 = arg0.rtMarks:GetChild(iter0 - 1)

		setActive(var6:Find("mark"), iter0 < var0)
		setActive(var6:Find("icon"), iter0 == var0)
	end

	setGray(arg0.rtFinish:Find("Image"), not var3)
	setActive(arg0.rtFinish:Find("got"), not var3)
end

return var0
