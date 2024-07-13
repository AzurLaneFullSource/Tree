local var0_0 = class("MikasaRepairePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.layer = arg0_1:findTF("layer")
end

function var0_0.OnFirstFlush(arg0_2)
	return
end

function var0_0.OnUpdateFlush(arg0_3)
	arg0_3:update_task_list_mikasa_museum(arg0_3.activity, arg0_3.layer, 1)
end

function var0_0.update_task_list_mikasa_museum(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = getProxy(TaskProxy)
	local var1_4 = arg1_4:getConfig("config_data")
	local var2_4 = getProxy(ActivityProxy)
	local var3_4 = arg2_4:Find("AD")
	local var4_4 = arg2_4:Find("item")
	local var5_4 = var4_4:Find("helpBtn")

	onButton(arg0_4, var5_4, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.word_museum_help.tip
		})
	end, SFX_PANEL)

	local var6_4
	local var7_4
	local var8_4
	local var9_4 = {}
	local var10_4
	local var11_4

	for iter0_4 = 1, 4 do
		local var12_4 = var4_4:Find("Panel/layout_layer/repair_panel" .. iter0_4 .. "/Panel")
		local var13_4 = arg0_4:findTF("btn_repair", var12_4)

		var9_4[iter0_4] = nil

		for iter1_4 = 1, 4 do
			local var14_4 = arg0_4:findTF("repair" .. iter1_4, var12_4)
			local var15_4 = var1_4[(iter0_4 - 1) * 4 + iter1_4]

			arg0_4:set_mikasa_btn(var15_4, var14_4, iter1_4 == 1 and 0 or var1_4[(iter0_4 - 1) * 4 + iter1_4 - 1], iter1_4 >= 4)

			if not var9_4[iter0_4] then
				var9_4[iter0_4] = var0_4:getTaskById(var15_4) and var15_4 or nil
			end
		end

		local var16_4 = var1_4[(iter0_4 - 1) * 4 + 1]
		local var17_4 = var0_4:getTaskById(var16_4) or var0_4:getFinishTaskById(var16_4)

		setActive(var12_4:Find("line1/unselected"), not var17_4:isReceive())
		setActive(var12_4:Find("line1/selected"), var17_4:isReceive())

		local var18_4 = var1_4[(iter0_4 - 1) * 4 + 2]
		local var19_4 = var0_4:getTaskById(var18_4) or var0_4:getFinishTaskById(var18_4)

		setActive(var12_4:Find("line2/unselected"), not var19_4:isReceive())
		setActive(var12_4:Find("line2/selected"), var19_4:isReceive())

		local var20_4 = var1_4[(iter0_4 - 1) * 4 + 3]
		local var21_4 = var0_4:getTaskById(var20_4) or var0_4:getFinishTaskById(var20_4)

		setActive(var12_4:Find("to_award/unselected"), not var21_4:isReceive())
		setActive(var12_4:Find("to_award/selected"), var21_4:isReceive())

		local var22_4 = var1_4[iter0_4 * 4]
		local var23_4 = var0_4:getTaskById(var22_4) or var0_4:getFinishTaskById(var22_4)

		var13_4:GetComponent(typeof(Image)).enabled = not var23_4:isFinish()

		setActive(var13_4:Find("get"), var23_4:isFinish() and not var23_4:isReceive())
		setActive(var13_4:Find("got"), var23_4:isReceive())
		onButton(arg0_4, var13_4, function()
			arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, var0_4:getTaskById(var9_4[iter0_4]))
		end, SFX_PANEL)
		setActive(var12_4:Find("gear"), not var23_4:isFinish())

		if not var23_4:isFinish() then
			local var24_4 = var0_4:getTaskById(var9_4[iter0_4])
			local var25_4 = var2_4:getVirtualItemNumber(tonumber(var24_4:getConfig("target_id")))

			setText(var12_4:Find("gear/test_bg/Text"), var25_4 .. "/" .. var24_4:getConfig("target_num"))
		end

		local var26_4 = var9_4[iter0_4]
		local var27_4 = var26_4 and (var0_4:getTaskById(var26_4) or var0_4:getFinishTaskById(var26_4)) or nil

		setButtonEnabled(var13_4, var27_4 and var27_4:isFinish())
		setActive(var13_4:Find("mask"), var27_4 and var27_4:isFinish())
	end

	local var28_4 = var4_4:Find("btn_main")
	local var29_4 = var1_4[#var1_4]
	local var30_4 = var0_4:getTaskById(var29_4) or var0_4:getFinishTaskById(var29_4)

	var28_4:GetComponent(typeof(Image)).enabled = not var30_4:isFinish()

	setActive(var28_4:Find("get"), var30_4:isFinish() and not var30_4:isReceive())
	setActive(var28_4:Find("got"), var30_4:isReceive())
	onButton(arg0_4, var28_4, function()
		if not var30_4:isFinish() then
			local var0_7 = var2_4:getActivityById(ActivityConst.MIKASA_DAILY_TASK_ACTIVITY)
			local var1_7 = pg.TimeMgr.GetInstance()
			local var2_7 = var1_7:DiffDay(var0_7.data1, var1_7:GetServerTime()) + 1
			local var3_7 = math.clamp(var2_7, 1, #var0_7:getConfig("config_data"))

			if _.all(_.flatten({
				var0_7:getConfig("config_data")[var3_7]
			}), function(arg0_8)
				return var0_4:getFinishTaskById(arg0_8) ~= nil
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_museum_1"))
			else
				arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = "activity"
				})
			end
		else
			arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, var30_4)
		end
	end, SFX_PANEL)
	setButtonEnabled(var28_4, not var30_4:isReceive())

	local var31_4 = var4_4:Find("repair_main")

	arg0_4:set_mikasa_btn(var29_4, var31_4, 0, true, arg1_4:getConfig("config_client").story)

	for iter2_4 = 1, 4 do
		setActive(var4_4:Find("repair_phase/point" .. iter2_4), iter2_4 <= var30_4:getProgress())

		if iter2_4 > 1 then
			setActive(var4_4:Find("repair_phase/line" .. iter2_4 - 1), iter2_4 <= var30_4:getProgress())
		end
	end

	setText(var4_4:Find("repair_phase/Text"), var30_4:getProgress() .. "/4")
end

function var0_0.set_mikasa_btn(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9)
	local var0_9 = getProxy(TaskProxy)
	local var1_9 = var0_9:getTaskById(arg1_9) or var0_9:getFinishTaskById(arg1_9)
	local var2_9 = arg2_9:Find("award")
	local var3_9 = arg2_9:Find("face")

	if arg4_9 then
		setActive(var2_9, true)
		setActive(var3_9, false)

		local var4_9 = pg.task_data_template[arg1_9].award_display[1]
		local var5_9 = {
			type = var4_9[1],
			id = var4_9[2],
			count = var4_9[3]
		}

		setActive(var2_9, var4_9)
		updateDrop(var2_9, var5_9)
		onButton(arg0_9, var2_9, function()
			arg0_9:emit(BaseUI.ON_DROP, var5_9)
		end, SFX_PANEL)
		setActive(var2_9:Find("mask"), var1_9:isReceive())
		setActive(var2_9:Find("black_block"), var1_9:isReceive())
		setActive(arg2_9:Find("Text"), false)
	else
		setActive(var2_9, false)
		setActive(var3_9, true)
		setActive(var3_9:Find("bg_select"), arg3_9 == 0 or var0_9:getFinishTaskById(arg3_9))
		setActive(var3_9:Find("mask"), var0_9:getFinishTaskById(arg1_9))
		setActive(var3_9:Find("black_block"), var0_9:getFinishTaskById(arg1_9))
	end

	if var1_9:getConfig("sub_type") == 90 and arg5_9 then
		for iter0_9, iter1_9 in ipairs(arg5_9) do
			if iter1_9[1] == arg1_9 and iter1_9[2] == var1_9:getProgress() and not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_9[3]) then
				pg.NewStoryMgr.GetInstance():Play(iter1_9[3])

				break
			end
		end
	end
end

return var0_0
