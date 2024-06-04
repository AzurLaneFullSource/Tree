local var0 = class("MikasaRepairePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.layer = arg0:findTF("layer")
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	arg0:update_task_list_mikasa_museum(arg0.activity, arg0.layer, 1)
end

function var0.update_task_list_mikasa_museum(arg0, arg1, arg2, arg3)
	local var0 = getProxy(TaskProxy)
	local var1 = arg1:getConfig("config_data")
	local var2 = getProxy(ActivityProxy)
	local var3 = arg2:Find("AD")
	local var4 = arg2:Find("item")
	local var5 = var4:Find("helpBtn")

	onButton(arg0, var5, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.word_museum_help.tip
		})
	end, SFX_PANEL)

	local var6
	local var7
	local var8
	local var9 = {}
	local var10
	local var11

	for iter0 = 1, 4 do
		local var12 = var4:Find("Panel/layout_layer/repair_panel" .. iter0 .. "/Panel")
		local var13 = arg0:findTF("btn_repair", var12)

		var9[iter0] = nil

		for iter1 = 1, 4 do
			local var14 = arg0:findTF("repair" .. iter1, var12)
			local var15 = var1[(iter0 - 1) * 4 + iter1]

			arg0:set_mikasa_btn(var15, var14, iter1 == 1 and 0 or var1[(iter0 - 1) * 4 + iter1 - 1], iter1 >= 4)

			if not var9[iter0] then
				var9[iter0] = var0:getTaskById(var15) and var15 or nil
			end
		end

		local var16 = var1[(iter0 - 1) * 4 + 1]
		local var17 = var0:getTaskById(var16) or var0:getFinishTaskById(var16)

		setActive(var12:Find("line1/unselected"), not var17:isReceive())
		setActive(var12:Find("line1/selected"), var17:isReceive())

		local var18 = var1[(iter0 - 1) * 4 + 2]
		local var19 = var0:getTaskById(var18) or var0:getFinishTaskById(var18)

		setActive(var12:Find("line2/unselected"), not var19:isReceive())
		setActive(var12:Find("line2/selected"), var19:isReceive())

		local var20 = var1[(iter0 - 1) * 4 + 3]
		local var21 = var0:getTaskById(var20) or var0:getFinishTaskById(var20)

		setActive(var12:Find("to_award/unselected"), not var21:isReceive())
		setActive(var12:Find("to_award/selected"), var21:isReceive())

		local var22 = var1[iter0 * 4]
		local var23 = var0:getTaskById(var22) or var0:getFinishTaskById(var22)

		var13:GetComponent(typeof(Image)).enabled = not var23:isFinish()

		setActive(var13:Find("get"), var23:isFinish() and not var23:isReceive())
		setActive(var13:Find("got"), var23:isReceive())
		onButton(arg0, var13, function()
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0:getTaskById(var9[iter0]))
		end, SFX_PANEL)
		setActive(var12:Find("gear"), not var23:isFinish())

		if not var23:isFinish() then
			local var24 = var0:getTaskById(var9[iter0])
			local var25 = var2:getVirtualItemNumber(tonumber(var24:getConfig("target_id")))

			setText(var12:Find("gear/test_bg/Text"), var25 .. "/" .. var24:getConfig("target_num"))
		end

		local var26 = var9[iter0]
		local var27 = var26 and (var0:getTaskById(var26) or var0:getFinishTaskById(var26)) or nil

		setButtonEnabled(var13, var27 and var27:isFinish())
		setActive(var13:Find("mask"), var27 and var27:isFinish())
	end

	local var28 = var4:Find("btn_main")
	local var29 = var1[#var1]
	local var30 = var0:getTaskById(var29) or var0:getFinishTaskById(var29)

	var28:GetComponent(typeof(Image)).enabled = not var30:isFinish()

	setActive(var28:Find("get"), var30:isFinish() and not var30:isReceive())
	setActive(var28:Find("got"), var30:isReceive())
	onButton(arg0, var28, function()
		if not var30:isFinish() then
			local var0 = var2:getActivityById(ActivityConst.MIKASA_DAILY_TASK_ACTIVITY)
			local var1 = pg.TimeMgr.GetInstance()
			local var2 = var1:DiffDay(var0.data1, var1:GetServerTime()) + 1
			local var3 = math.clamp(var2, 1, #var0:getConfig("config_data"))

			if _.all(_.flatten({
				var0:getConfig("config_data")[var3]
			}), function(arg0)
				return var0:getFinishTaskById(arg0) ~= nil
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_museum_1"))
			else
				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = "activity"
				})
			end
		else
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var30)
		end
	end, SFX_PANEL)
	setButtonEnabled(var28, not var30:isReceive())

	local var31 = var4:Find("repair_main")

	arg0:set_mikasa_btn(var29, var31, 0, true, arg1:getConfig("config_client").story)

	for iter2 = 1, 4 do
		setActive(var4:Find("repair_phase/point" .. iter2), iter2 <= var30:getProgress())

		if iter2 > 1 then
			setActive(var4:Find("repair_phase/line" .. iter2 - 1), iter2 <= var30:getProgress())
		end
	end

	setText(var4:Find("repair_phase/Text"), var30:getProgress() .. "/4")
end

function var0.set_mikasa_btn(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = getProxy(TaskProxy)
	local var1 = var0:getTaskById(arg1) or var0:getFinishTaskById(arg1)
	local var2 = arg2:Find("award")
	local var3 = arg2:Find("face")

	if arg4 then
		setActive(var2, true)
		setActive(var3, false)

		local var4 = pg.task_data_template[arg1].award_display[1]
		local var5 = {
			type = var4[1],
			id = var4[2],
			count = var4[3]
		}

		setActive(var2, var4)
		updateDrop(var2, var5)
		onButton(arg0, var2, function()
			arg0:emit(BaseUI.ON_DROP, var5)
		end, SFX_PANEL)
		setActive(var2:Find("mask"), var1:isReceive())
		setActive(var2:Find("black_block"), var1:isReceive())
		setActive(arg2:Find("Text"), false)
	else
		setActive(var2, false)
		setActive(var3, true)
		setActive(var3:Find("bg_select"), arg3 == 0 or var0:getFinishTaskById(arg3))
		setActive(var3:Find("mask"), var0:getFinishTaskById(arg1))
		setActive(var3:Find("black_block"), var0:getFinishTaskById(arg1))
	end

	if var1:getConfig("sub_type") == 90 and arg5 then
		for iter0, iter1 in ipairs(arg5) do
			if iter1[1] == arg1 and iter1[2] == var1:getProgress() and not pg.NewStoryMgr.GetInstance():IsPlayed(iter1[3]) then
				pg.NewStoryMgr.GetInstance():Play(iter1[3])

				break
			end
		end
	end
end

return var0
