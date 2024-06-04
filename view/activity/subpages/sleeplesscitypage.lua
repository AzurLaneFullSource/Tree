local var0 = class("SleeplessCityPage", import(".TemplatePage.PtTemplatePage"))

var0.COLOR = "#BD3F40"

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.getBtn, function()
		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getRawData()
		local var3 = pg.gameset.urpt_chapter_max.description[1]
		local var4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3)
		local var5, var6 = Task.StaticJudgeOverflow(var2.gold, var2.oil, var4, true, true, {
			{
				var1.type,
				var1.id,
				var1.count
			}
		})

		if var5 then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6,
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			local var0, var1 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var1,
				callback = function()
					arg0:OnUpdateFlush()
				end
			})
		end)
	end, SFX_PANEL)
	arg0:OnUpdateFlush()
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity:getConfig("config_client").story

	if arg0.level and checkExist(var0, {
		arg0.level
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0[arg0.level][1])
	end

	arg0.level = arg0.ptData:getTargetLevel()

	if arg0.step then
		local var1, var2, var3 = arg0.ptData:GetLevelProgress()

		setText(arg0.step, var1 .. "/" .. var2)
	end

	local var4, var5, var6 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var6 >= 1 and setColorStr(var4, COLOR_GREEN) or setColorStr(var4, var0.COLOR)) .. "/" .. var5)
	setSlider(arg0.slider, 0, 1, var6)

	local var7 = arg0.ptData:CanGetAward()
	local var8 = arg0.ptData:CanGetNextAward()
	local var9 = arg0.ptData:CanGetMorePt()

	setActive(arg0.battleBtn, var9 and not var7 and var8)
	setActive(arg0.getBtn, var7)
	setActive(arg0.gotBtn, not var8)

	local var10 = arg0.ptData:GetAward()

	updateDrop(arg0.awardTF, var10)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var10)
	end, SFX_PANEL)
	setText(arg0:findTF("description", arg0.bg), i18n("activity_victory"))

	if not var8 and var6 >= 1 and not var7 then
		arg0.level = arg0.level + 1
	end
end

return var0
