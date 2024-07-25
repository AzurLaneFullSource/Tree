local var0_0 = class("PreviewPtHybridTemplatePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.btnList = arg0_1:findTF("btn_list", arg0_1.bg)
	arg0_1.battleBtn = arg0_1:findTF("fight", arg0_1.btnList)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.btnList)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.btnList)
	arg0_1.ptList = arg0_1:findTF("pt_list", arg0_1.bg)
	arg0_1.slider = arg0_1:findTF("slider", arg0_1.ptList)
	arg0_1.step = arg0_1:findTF("step", arg0_1.ptList)
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.ptList)
	arg0_1.awardTF = arg0_1:findTF("award", arg0_1.ptList)
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2:initBtn()
	eachChild(arg0_2.btnList, function(arg0_3)
		arg0_2.btnFuncList[arg0_3.name](arg0_3)
	end)
end

function var0_0.OnDataSetting(arg0_4)
	if arg0_4.ptData then
		arg0_4.ptData:Update(arg0_4.activity)
	else
		arg0_4.ptData = ActivityPtData.New(arg0_4.activity)
	end
end

function var0_0.initBtn(arg0_5)
	local function var0_5(arg0_6)
		local var0_6 = getProxy(ActivityProxy):getActivityById(arg0_6)

		if not var0_6 or var0_6 and var0_6:isEnd() then
			return true
		else
			return false
		end
	end

	local var1_5 = arg0_5.activity:getConfig("config_client")

	arg0_5.btnFuncList = {
		task = function(arg0_7)
			onButton(arg0_5, arg0_7, function()
				if var1_5.taskLinkActID and var0_5(var1_5.taskLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_5:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = "activity"
				})
			end)
		end,
		shop = function(arg0_9)
			local var0_9 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_10)
				return arg0_10:getConfig("config_client").pt_id == pg.gameset.activity_res_id.key_value
			end)

			onButton(arg0_5, arg0_9, function()
				if var1_5.shopLinkActID and var0_5(var1_5.shopLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_5:emit(ActivityMediator.GO_SHOPS_LAYER, {
					warp = NewShopsScene.TYPE_ACTIVITY,
					actId = var0_9 and var0_9.id
				})
			end)
		end,
		build = function(arg0_12)
			onButton(arg0_5, arg0_12, function()
				if var1_5.buildLinkActID and var0_5(var1_5.buildLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_5:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
					page = BuildShipScene.PAGE_BUILD,
					projectName = BuildShipScene.PROJECTS.ACTIVITY
				})
			end)
		end,
		fight = function(arg0_14)
			onButton(arg0_5, arg0_14, function()
				if var1_5.fightLinkActID and var0_5(var1_5.fightLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_5:emit(ActivityMediator.BATTLE_OPERA)
			end)
		end,
		lottery = function(arg0_16)
			onButton(arg0_5, arg0_16, function()
				if var1_5.lotteryLinkActID and var0_5(var1_5.lotteryLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_5:emit(ActivityMediator.GO_LOTTERY)
			end)
		end,
		memory = function(arg0_18)
			return
		end,
		activity = function(arg0_19)
			return
		end,
		mountain = function(arg0_20)
			return
		end,
		skinshop = function(arg0_21)
			onButton(arg0_5, arg0_21, function()
				arg0_5:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
			end)
		end,
		display_btn = function(arg0_23)
			onButton(arg0_5, arg0_23, function()
				arg0_5:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
					type = arg0_5.ptData.type,
					dropList = arg0_5.ptData.dropList,
					targets = arg0_5.ptData.targets,
					level = arg0_5.ptData.level,
					count = arg0_5.ptData.count,
					resId = arg0_5.ptData.resId,
					unlockStamps = arg0_5.ptData:GetDayUnlockStamps()
				})
			end, SFX_PANEL)
		end,
		get_btn = function(arg0_25)
			onButton(arg0_5, arg0_25, function()
				local var0_26 = {}
				local var1_26 = arg0_5.ptData:GetAward()
				local var2_26 = getProxy(PlayerProxy):getRawData()
				local var3_26 = pg.gameset.urpt_chapter_max.description[1]
				local var4_26 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_26)
				local var5_26, var6_26 = Task.StaticJudgeOverflow(var2_26.gold, var2_26.oil, var4_26, true, true, {
					{
						var1_26.type,
						var1_26.id,
						var1_26.count
					}
				})

				if var5_26 then
					table.insert(var0_26, function(arg0_27)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							type = MSGBOX_TYPE_ITEM_BOX,
							content = i18n("award_max_warning"),
							items = var6_26,
							onYes = arg0_27
						})
					end)
				end

				seriesAsync(var0_26, function()
					local var0_28, var1_28 = arg0_5.ptData:GetResProgress()

					arg0_5:emit(ActivityMediator.EVENT_PT_OPERATION, {
						cmd = 1,
						activity_id = arg0_5.ptData:GetId(),
						arg1 = var1_28
					})
				end)
			end, SFX_PANEL)
		end,
		got_btn = function(arg0_29)
			return
		end,
		boost_btn = function(arg0_30)
			onButton(arg0_5, arg0_30, function()
				if var1_5.boostLinkActID and var0_5(var1_5.boostLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				local var0_31 = getProxy(ActivityProxy):getActivityById(var1_5.boostLinkActID)
				local var1_31 = var0_31:getConfig("config_id")
				local var2_31 = var0_31:getConfig("config_client").icon
				local var3_31 = var0_31:getConfig("config_client").name
				local var4_31 = var0_31:getConfig("config_client").desc

				if var2_31 and var3_31 and var4_31 then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						iconPreservedAspect = true,
						hideNo = true,
						yesText = "text_confirm",
						type = MSGBOX_TYPE_DROP_ITEM,
						content = i18n(var4_31),
						name = i18n(var3_31),
						iconPath = {
							"Props/" .. var2_31,
							var2_31
						}
					})
				end
			end, SFX_PANEL)
		end
	}
end

function var0_0.OnUpdateFlush(arg0_32)
	local var0_32 = arg0_32.ptData:getTargetLevel()
	local var1_32 = arg0_32.activity:getConfig("config_client").story

	if checkExist(var1_32, {
		var0_32
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1_32[var0_32][1])
	end

	if arg0_32.step then
		local var2_32, var3_32, var4_32 = arg0_32.ptData:GetLevelProgress()

		setText(arg0_32.step, var2_32 .. "/" .. var3_32)
	end

	local var5_32, var6_32, var7_32 = arg0_32.ptData:GetResProgress()

	setText(arg0_32.progress, (var7_32 >= 1 and setColorStr(var5_32, COLOR_GREEN) or var5_32) .. "/" .. var6_32)
	setSlider(arg0_32.slider, 0, 1, var7_32)

	local var8_32 = arg0_32.ptData:CanGetAward()
	local var9_32 = arg0_32.ptData:CanGetNextAward()
	local var10_32 = arg0_32.ptData:CanGetMorePt()

	setActive(arg0_32.battleBtn, var10_32 and not var8_32 and var9_32)
	setActive(arg0_32.getBtn, var8_32)
	setActive(arg0_32.gotBtn, not var9_32)

	local var11_32 = arg0_32.ptData:GetAward()

	updateDrop(arg0_32.awardTF, var11_32)
	onButton(arg0_32, arg0_32.awardTF, function()
		arg0_32:emit(BaseUI.ON_DROP, var11_32)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_34)
	return
end

function var0_0.GetWorldPtData(arg0_35, arg1_35)
	if arg1_35 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_35:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_35.ptData:GetId()
		})
	end
end

return var0_0
