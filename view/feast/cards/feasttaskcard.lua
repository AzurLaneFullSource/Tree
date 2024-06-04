local var0 = class("FeastTaskCard")

function var0.Ctor(arg0, arg1, arg2)
	arg0.binder = arg2
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.nameTxt = arg0._tf:Find("name/Text"):GetComponent(typeof(Text))
	arg0.descTxt = arg0._tf:Find("desc"):GetComponent(typeof(Text))
	arg0.progressTxt = arg0._tf:Find("Text"):GetComponent(typeof(Text))
	arg0.progress = arg0._tf:Find("progress/bar")
	arg0.uilist = UIItemList.New(arg0._tf:Find("awards"), arg0._tf:Find("awards/award"))
	arg0.getBtn = arg0._tf:Find("btns/get")
	arg0.gotBtn = arg0._tf:Find("btns/got")
	arg0.goBtn = arg0._tf:Find("btns/go")
	arg0.sprites = {
		GetSpriteFromAtlas("ui/feasttask_atlas", "t_frame_1"),
		GetSpriteFromAtlas("ui/feasttask_atlas", "t_frame_2")
	}
	arg0.barSprites = {
		GetSpriteFromAtlas("ui/feasttask_atlas", "t_progress_1"),
		GetSpriteFromAtlas("ui/feasttask_atlas", "t_progress_2")
	}
	arg0.tags = {
		i18n("feast_task_tag_daily"),
		i18n("feast_task_tag_activity")
	}
	arg0.barImg = arg0._tf:Find("progress/bar"):GetComponent(typeof(Image))
	arg0.bgImg = arg0._tf:GetComponent(typeof(Image))
end

function var0.Flush(arg0, arg1)
	local var0 = getProxy(TaskProxy)
	local var1 = var0:getTaskById(arg1) or var0:getFinishTaskById(arg1)
	local var2 = var1:IsActRoutineType() and 1 or 2

	arg0.nameTxt.text = arg0.tags[var2] .. var1:getConfig("name")
	arg0.descTxt.text = var1:getConfig("desc")
	arg0.bgImg.sprite = arg0.sprites[var2]
	arg0.barImg.sprite = arg0.barSprites[var2]

	local var3 = var1:getProgress()
	local var4 = var1:getConfig("target_num")

	arg0.progressTxt.text = var3 .. "/" .. var4

	setFillAmount(arg0.progress, var3 / var4)

	local var5 = var1:getConfig("award_display")

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var5[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0.binder, arg2, function()
				arg0.binder:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.uilist:align(#var5)

	local var6 = var1:isFinish()
	local var7 = var1:isReceive()

	setActive(arg0.getBtn, var6 and not var7)
	setActive(arg0.gotBtn, var6 and var7)
	setActive(arg0.goBtn, not var6)
	onButton(arg0.binder, arg0.getBtn, function()
		arg0.binder:emit(FeastMediator.ON_SUBMIT, arg1)
	end, SFX_PANEL)
	onButton(arg0.binder, arg0.goBtn, function()
		arg0.binder:emit(FeastMediator.ON_GO, var1)
	end, SFX_PANEL)
end

function var0.Dispose(arg0)
	arg0.sprites = nil
	arg0.barSprites = nil
end

return var0
