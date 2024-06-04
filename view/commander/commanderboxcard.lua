local var0 = class("CommanderBoxCard")

function var0.Ctor(arg0, arg1, arg2)
	arg0._parent = arg1
	arg0._tf = arg2
	arg0._go = go(arg2)
	arg0.startingTF = arg0._tf:Find("ongoing")
	arg0.idleTF = arg0._tf:Find("idle")
	arg0.waitTF = arg0._tf:Find("wait")
	arg0.timerTxt = arg0.startingTF:Find("time/Text"):GetComponent(typeof(Text))
	arg0.slider = arg0.startingTF:Find("slider/bar")
	arg0.boxParent = arg0._tf:Find("char")
	arg0.titleStarting = arg0.startingTF:Find("title_starting")
	arg0.titleFinish = arg0.startingTF:Find("title_finish")
	arg0.quicklyTool = arg0.startingTF:Find("quickly_tool")
end

function var0.Update(arg0, arg1)
	arg0.boxVO = arg1

	local var0 = arg1:getState()

	arg0:removeTimer()
	arg0:removeWaitingTimer()
	removeOnButton(arg0._tf)

	if var0 == CommanderBox.STATE_EMPTY then
		-- block empty
	elseif var0 == CommanderBox.STATE_WAITING then
		local var1 = arg1.beginTime - pg.TimeMgr.GetInstance():GetServerTime()

		arg0.waitTimer = Timer.New(function()
			arg0:removeWaitingTimer()
			arg0:Update(arg1)
			arg0._parent:updateCntLabel()
		end, var1, 1)

		arg0.waitTimer:Start()
	elseif var0 == CommanderBox.STATE_STARTING then
		local var2 = arg1:getFinishTime()
		local var3 = var2 - arg1.beginTime

		arg0.timer = Timer.New(function()
			local var0 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1 = var2 - var0

			if var1 <= 0 then
				arg0:removeTimer()
				arg0:Update(arg1)
			else
				arg0.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1)

				setFillAmount(arg0.slider, 1 - var1 / var3)
			end
		end, 1, -1)

		arg0.timer:Start()
		arg0.timer.func()
		onButton(arg0._parent, arg0.quicklyTool, function()
			arg0._parent:emit(CommanderCatScene.EVENT_QUICKLY_TOOL, arg1.id)
		end, SFX_PANEL)
	elseif var0 == CommanderBox.STATE_FINISHED then
		arg0.timerTxt.text = "COMPLETE"

		setFillAmount(arg0.slider, 1)
		onButton(arg0._parent, arg0._tf, function()
			local var0 = getProxy(CommanderProxy)

			if getProxy(PlayerProxy):getData().commanderBagMax <= var0:getCommanderCnt() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_capcity_is_max"))

				return
			end

			arg0._parent:emit(CommanderCatMediator.GET, arg1.id)
		end, SFX_PANEL)
	end

	setActive(arg0.quicklyTool, var0 == CommanderBox.STATE_STARTING and not LOCK_CATTERY)
	setActive(arg0.titleStarting, var0 == CommanderBox.STATE_STARTING)
	setActive(arg0.titleFinish, var0 == CommanderBox.STATE_FINISHED)
	setActive(arg0.startingTF, var0 == CommanderBox.STATE_STARTING or var0 == CommanderBox.STATE_FINISHED)
	setActive(arg0.idleTF, var0 == CommanderBox.STATE_EMPTY)
	setActive(arg0.waitTF, var0 == CommanderBox.STATE_WAITING)

	local var4 = arg1:getPrefab()

	arg0:loadBox(var4, arg0.boxParent)
end

local var1 = true

function var0.playAnim(arg0, arg1)
	arg0:loadBox(arg0.boxVO:getFetchPrefab(), arg0.boxParent, function(arg0)
		arg0.spineAnimUI = arg0

		arg0:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				arg0:SetActionCallBack(nil)
				arg1()
			end
		end)
	end)
end

function var0.loadBox(arg0, arg1, arg2, arg3)
	if not arg1 then
		arg0:returnChar()
	else
		if arg0.prefabName == arg1 then
			return
		end

		arg0:returnChar()

		arg0.prefabName = arg1

		local var0 = arg1

		PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
			if arg0.exited or var0 ~= arg0.prefabName then
				PoolMgr.GetInstance():ReturnSpineChar(var0, arg0)

				return
			end

			arg0.modelTf = tf(arg0)
			arg0.modelTf.localScale = Vector3(0.7, 0.7, 1)
			arg0.modelTf.localPosition = Vector3(0, -123, 0)

			pg.ViewUtils.SetLayer(arg0.modelTf, Layer.UI)
			setParent(arg0.modelTf, arg2)

			local var0 = arg0:GetComponent("SpineAnimUI")

			var0:SetAction("normal", 0)

			if arg3 then
				arg3(var0)
			end
		end)
	end
end

function var0.removeTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.removeWaitingTimer(arg0)
	if arg0.waitTimer then
		arg0.waitTimer:Stop()

		arg0.waitTimer = nil
	end
end

function var0.returnChar(arg0)
	if arg0.modelTf and arg0.prefabName then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefabName, arg0.modelTf.gameObject)

		arg0.modelTf = nil
		arg0.prefabName = nil
	end
end

function var0.Clear(arg0)
	arg0:removeTimer()
	arg0:removeWaitingTimer()
	removeOnButton(arg0._tf)

	arg0.boxVO = nil
end

function var0.Destroy(arg0)
	arg0:Clear()
	arg0:returnChar()

	arg0.exited = true
	arg0.boxVO = nil
	arg0.loading = nil
end

return var0
