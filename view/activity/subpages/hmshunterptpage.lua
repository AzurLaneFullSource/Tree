local var0 = class("HMSHunterPTPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.helpBtn = arg0:findTF("help", arg0.bg)

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("hunter_npc")
		})
	end, SFX_PANEL)
end

function var0.flush_task_list_pt(arg0)
	local var0 = arg0.activity
	local var1 = _.flatten(var0:getConfig("config_data"))
	local var2, var3, var4 = arg0:getDoingTask(var0)
	local var5 = getProxy(ActivityProxy):getActivityById(var0:getConfig("config_client").rank_act_id).data1

	setText(arg0.phaseTxt, var2 .. "/" .. #var1)

	if var4 then
		local var6 = var4:getConfig("target_num")
		local var7 = var5 .. "/" .. setColorStr(var6, "#FFE7B3")

		setText(arg0.progressTxt, var7)
		setSlider(arg0.progress, 0, var6, math.min(var5, var6))

		local var8 = var4:getConfig("award_display")[1]
		local var9 = {
			type = var8[1],
			id = var8[2],
			count = var8[3]
		}

		updateDrop(arg0.award, var9)
		onButton(arg0, arg0.award, function()
			arg0:emit(BaseUI.ON_DROP, var9)
		end, SFX_PANEL)

		arg0.btn:GetComponent(typeof(Image)).enabled = not var4:isFinish()

		setActive(arg0.btn:Find("get"), var4:isFinish() and not var4:isReceive())
		setActive(arg0.btn:Find("achieved"), var4:isReceive())
		onButton(arg0, arg0.btn, function()
			if not var4:isFinish() then
				arg0:emit(ActivityMediator.ON_TASK_GO, var4)
			end
		end, SFX_PANEL)
		onButton(arg0, arg0.btn:Find("get"), function()
			if var4:isFinish() and not var4:isReceive() then
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var4)
			end
		end)
		setButtonEnabled(arg0.btn, not var4:isReceive())
	end
end

return var0
