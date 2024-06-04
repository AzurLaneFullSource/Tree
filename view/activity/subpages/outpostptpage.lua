local var0 = class("OutPostPtPage", import(".MaoziPtPage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.getBtn1 = arg0:findTF("AD/switcher/phase2/get_btn")
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	setActive(arg0.displayBtn, true)

	local var0 = arg0.displayBtn:Find("Image1")
	local var1 = arg0.displayBtn:Find("Image2")
	local var2, var3 = arg0:GetActTask()
	local var4 = var2 and var2:isReceive() and var3

	setActive(var0, not var4)
	setActive(var1, var4)

	if var2 and not var2:isReceive() then
		blinkAni(go(var0), 0.8, -1, 0.3)
	else
		LeanTween.cancel(go(var0))
	end

	onButton(arg0, arg0.displayBtn, function()
		if var2 and var2:isReceive() and not var4 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("undermist_tip"))

			return
		end

		if var2 and not var4 then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = "activity",
				targetId = var2.id
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn1, function()
		triggerButton(arg0.getBtn)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0 = arg0.ptData:CanGetAward()

	setActive(arg0.getBtn1, var0)
end

function var0.GetActTask(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.OUTPOST_TASK)

	if not var0 or var0:isEnd() then
		return
	end

	local var1 = _.flatten(var0:getConfig("config_data"))
	local var2 = getProxy(TaskProxy)
	local var3
	local var4 = false

	for iter0 = #var1, 1, -1 do
		local var5 = var1[iter0]
		local var6 = var2:getTaskById(var5) or var2:getFinishTaskById(var5)

		if var6 then
			var3 = var6

			if iter0 == #var1 then
				var4 = true
			end

			break
		end
	end

	return var3, var4
end

return var0
