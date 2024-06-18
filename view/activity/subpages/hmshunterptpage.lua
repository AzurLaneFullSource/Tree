local var0_0 = class("HMSHunterPTPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.helpBtn = arg0_1:findTF("help", arg0_1.bg)

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("hunter_npc")
		})
	end, SFX_PANEL)
end

function var0_0.flush_task_list_pt(arg0_3)
	local var0_3 = arg0_3.activity
	local var1_3 = _.flatten(var0_3:getConfig("config_data"))
	local var2_3, var3_3, var4_3 = arg0_3:getDoingTask(var0_3)
	local var5_3 = getProxy(ActivityProxy):getActivityById(var0_3:getConfig("config_client").rank_act_id).data1

	setText(arg0_3.phaseTxt, var2_3 .. "/" .. #var1_3)

	if var4_3 then
		local var6_3 = var4_3:getConfig("target_num")
		local var7_3 = var5_3 .. "/" .. setColorStr(var6_3, "#FFE7B3")

		setText(arg0_3.progressTxt, var7_3)
		setSlider(arg0_3.progress, 0, var6_3, math.min(var5_3, var6_3))

		local var8_3 = var4_3:getConfig("award_display")[1]
		local var9_3 = {
			type = var8_3[1],
			id = var8_3[2],
			count = var8_3[3]
		}

		updateDrop(arg0_3.award, var9_3)
		onButton(arg0_3, arg0_3.award, function()
			arg0_3:emit(BaseUI.ON_DROP, var9_3)
		end, SFX_PANEL)

		arg0_3.btn:GetComponent(typeof(Image)).enabled = not var4_3:isFinish()

		setActive(arg0_3.btn:Find("get"), var4_3:isFinish() and not var4_3:isReceive())
		setActive(arg0_3.btn:Find("achieved"), var4_3:isReceive())
		onButton(arg0_3, arg0_3.btn, function()
			if not var4_3:isFinish() then
				arg0_3:emit(ActivityMediator.ON_TASK_GO, var4_3)
			end
		end, SFX_PANEL)
		onButton(arg0_3, arg0_3.btn:Find("get"), function()
			if var4_3:isFinish() and not var4_3:isReceive() then
				arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, var4_3)
			end
		end)
		setButtonEnabled(arg0_3.btn, not var4_3:isReceive())
	end
end

return var0_0
