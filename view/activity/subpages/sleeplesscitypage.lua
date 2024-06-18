local var0_0 = class("SleeplessCityPage", import(".TemplatePage.PtTemplatePage"))

var0_0.COLOR = "#BD3F40"

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.getBtn, function()
		local var0_2 = {}
		local var1_2 = arg0_1.ptData:GetAward()
		local var2_2 = getProxy(PlayerProxy):getRawData()
		local var3_2 = pg.gameset.urpt_chapter_max.description[1]
		local var4_2 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_2)
		local var5_2, var6_2 = Task.StaticJudgeOverflow(var2_2.gold, var2_2.oil, var4_2, true, true, {
			{
				var1_2.type,
				var1_2.id,
				var1_2.count
			}
		})

		if var5_2 then
			table.insert(var0_2, function(arg0_3)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_2,
					onYes = arg0_3
				})
			end)
		end

		seriesAsync(var0_2, function()
			local var0_4, var1_4 = arg0_1.ptData:GetResProgress()

			arg0_1:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_1.ptData:GetId(),
				arg1 = var1_4,
				callback = function()
					arg0_1:OnUpdateFlush()
				end
			})
		end)
	end, SFX_PANEL)
	arg0_1:OnUpdateFlush()
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6.activity:getConfig("config_client").story

	if arg0_6.level and checkExist(var0_6, {
		arg0_6.level
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_6[arg0_6.level][1])
	end

	arg0_6.level = arg0_6.ptData:getTargetLevel()

	if arg0_6.step then
		local var1_6, var2_6, var3_6 = arg0_6.ptData:GetLevelProgress()

		setText(arg0_6.step, var1_6 .. "/" .. var2_6)
	end

	local var4_6, var5_6, var6_6 = arg0_6.ptData:GetResProgress()

	setText(arg0_6.progress, (var6_6 >= 1 and setColorStr(var4_6, COLOR_GREEN) or setColorStr(var4_6, var0_0.COLOR)) .. "/" .. var5_6)
	setSlider(arg0_6.slider, 0, 1, var6_6)

	local var7_6 = arg0_6.ptData:CanGetAward()
	local var8_6 = arg0_6.ptData:CanGetNextAward()
	local var9_6 = arg0_6.ptData:CanGetMorePt()

	setActive(arg0_6.battleBtn, var9_6 and not var7_6 and var8_6)
	setActive(arg0_6.getBtn, var7_6)
	setActive(arg0_6.gotBtn, not var8_6)

	local var10_6 = arg0_6.ptData:GetAward()

	updateDrop(arg0_6.awardTF, var10_6)
	onButton(arg0_6, arg0_6.awardTF, function()
		arg0_6:emit(BaseUI.ON_DROP, var10_6)
	end, SFX_PANEL)
	setText(arg0_6:findTF("description", arg0_6.bg), i18n("activity_victory"))

	if not var8_6 and var6_6 >= 1 and not var7_6 then
		arg0_6.level = arg0_6.level + 1
	end
end

return var0_0
