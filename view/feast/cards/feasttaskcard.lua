local var0_0 = class("FeastTaskCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.nameTxt = arg0_1._tf:Find("name/Text"):GetComponent(typeof(Text))
	arg0_1.descTxt = arg0_1._tf:Find("desc"):GetComponent(typeof(Text))
	arg0_1.progressTxt = arg0_1._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_1.progress = arg0_1._tf:Find("progress/bar")
	arg0_1.uilist = UIItemList.New(arg0_1._tf:Find("awards"), arg0_1._tf:Find("awards/award"))
	arg0_1.getBtn = arg0_1._tf:Find("btns/get")
	arg0_1.gotBtn = arg0_1._tf:Find("btns/got")
	arg0_1.goBtn = arg0_1._tf:Find("btns/go")
	arg0_1.sprites = {
		GetSpriteFromAtlas("ui/feasttask_atlas", "t_frame_1"),
		GetSpriteFromAtlas("ui/feasttask_atlas", "t_frame_2")
	}
	arg0_1.barSprites = {
		GetSpriteFromAtlas("ui/feasttask_atlas", "t_progress_1"),
		GetSpriteFromAtlas("ui/feasttask_atlas", "t_progress_2")
	}
	arg0_1.tags = {
		i18n("feast_task_tag_daily"),
		i18n("feast_task_tag_activity")
	}
	arg0_1.barImg = arg0_1._tf:Find("progress/bar"):GetComponent(typeof(Image))
	arg0_1.bgImg = arg0_1._tf:GetComponent(typeof(Image))
end

function var0_0.Flush(arg0_2, arg1_2)
	local var0_2 = getProxy(TaskProxy)
	local var1_2 = var0_2:getTaskById(arg1_2) or var0_2:getFinishTaskById(arg1_2)
	local var2_2 = var1_2:IsActRoutineType() and 1 or 2

	arg0_2.nameTxt.text = arg0_2.tags[var2_2] .. var1_2:getConfig("name")
	arg0_2.descTxt.text = var1_2:getConfig("desc")
	arg0_2.bgImg.sprite = arg0_2.sprites[var2_2]
	arg0_2.barImg.sprite = arg0_2.barSprites[var2_2]

	local var3_2 = var1_2:getProgress()
	local var4_2 = var1_2:getConfig("target_num")

	arg0_2.progressTxt.text = var3_2 .. "/" .. var4_2

	setFillAmount(arg0_2.progress, var3_2 / var4_2)

	local var5_2 = var1_2:getConfig("award_display")

	arg0_2.uilist:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = var5_2[arg1_3 + 1]
			local var1_3 = {
				type = var0_3[1],
				id = var0_3[2],
				count = var0_3[3]
			}

			updateDrop(arg2_3, var1_3)
			onButton(arg0_2.binder, arg2_3, function()
				arg0_2.binder:emit(BaseUI.ON_DROP, var1_3)
			end, SFX_PANEL)
		end
	end)
	arg0_2.uilist:align(#var5_2)

	local var6_2 = var1_2:isFinish()
	local var7_2 = var1_2:isReceive()

	setActive(arg0_2.getBtn, var6_2 and not var7_2)
	setActive(arg0_2.gotBtn, var6_2 and var7_2)
	setActive(arg0_2.goBtn, not var6_2)
	onButton(arg0_2.binder, arg0_2.getBtn, function()
		arg0_2.binder:emit(FeastMediator.ON_SUBMIT, arg1_2)
	end, SFX_PANEL)
	onButton(arg0_2.binder, arg0_2.goBtn, function()
		arg0_2.binder:emit(FeastMediator.ON_GO, var1_2)
	end, SFX_PANEL)
end

function var0_0.Dispose(arg0_7)
	arg0_7.sprites = nil
	arg0_7.barSprites = nil
end

return var0_0
