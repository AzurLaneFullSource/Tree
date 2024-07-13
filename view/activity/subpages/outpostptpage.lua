local var0_0 = class("OutPostPtPage", import(".MaoziPtPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.getBtn1 = arg0_1:findTF("AD/switcher/phase2/get_btn")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	setActive(arg0_2.displayBtn, true)

	local var0_2 = arg0_2.displayBtn:Find("Image1")
	local var1_2 = arg0_2.displayBtn:Find("Image2")
	local var2_2, var3_2 = arg0_2:GetActTask()
	local var4_2 = var2_2 and var2_2:isReceive() and var3_2

	setActive(var0_2, not var4_2)
	setActive(var1_2, var4_2)

	if var2_2 and not var2_2:isReceive() then
		blinkAni(go(var0_2), 0.8, -1, 0.3)
	else
		LeanTween.cancel(go(var0_2))
	end

	onButton(arg0_2, arg0_2.displayBtn, function()
		if var2_2 and var2_2:isReceive() and not var4_2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("undermist_tip"))

			return
		end

		if var2_2 and not var4_2 then
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = "activity",
				targetId = var2_2.id
			})
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.getBtn1, function()
		triggerButton(arg0_2.getBtn)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)

	local var0_5 = arg0_5.ptData:CanGetAward()

	setActive(arg0_5.getBtn1, var0_5)
end

function var0_0.GetActTask(arg0_6)
	local var0_6 = getProxy(ActivityProxy):getActivityById(ActivityConst.OUTPOST_TASK)

	if not var0_6 or var0_6:isEnd() then
		return
	end

	local var1_6 = _.flatten(var0_6:getConfig("config_data"))
	local var2_6 = getProxy(TaskProxy)
	local var3_6
	local var4_6 = false

	for iter0_6 = #var1_6, 1, -1 do
		local var5_6 = var1_6[iter0_6]
		local var6_6 = var2_6:getTaskById(var5_6) or var2_6:getFinishTaskById(var5_6)

		if var6_6 then
			var3_6 = var6_6

			if iter0_6 == #var1_6 then
				var4_6 = true
			end

			break
		end
	end

	return var3_6, var4_6
end

return var0_0
