local var0_0 = class("CommanderBoxCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._parent = arg1_1
	arg0_1._tf = arg2_1
	arg0_1._go = go(arg2_1)
	arg0_1.startingTF = arg0_1._tf:Find("ongoing")
	arg0_1.idleTF = arg0_1._tf:Find("idle")
	arg0_1.waitTF = arg0_1._tf:Find("wait")
	arg0_1.timerTxt = arg0_1.startingTF:Find("time/Text"):GetComponent(typeof(Text))
	arg0_1.slider = arg0_1.startingTF:Find("slider/bar")
	arg0_1.boxParent = arg0_1._tf:Find("char")
	arg0_1.titleStarting = arg0_1.startingTF:Find("title_starting")
	arg0_1.titleFinish = arg0_1.startingTF:Find("title_finish")
	arg0_1.quicklyTool = arg0_1.startingTF:Find("quickly_tool")
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.boxVO = arg1_2

	local var0_2 = arg1_2:getState()

	arg0_2:removeTimer()
	arg0_2:removeWaitingTimer()
	removeOnButton(arg0_2._tf)

	if var0_2 == CommanderBox.STATE_EMPTY then
		-- block empty
	elseif var0_2 == CommanderBox.STATE_WAITING then
		local var1_2 = arg1_2.beginTime - pg.TimeMgr.GetInstance():GetServerTime()

		arg0_2.waitTimer = Timer.New(function()
			arg0_2:removeWaitingTimer()
			arg0_2:Update(arg1_2)
			arg0_2._parent:updateCntLabel()
		end, var1_2, 1)

		arg0_2.waitTimer:Start()
	elseif var0_2 == CommanderBox.STATE_STARTING then
		local var2_2 = arg1_2:getFinishTime()
		local var3_2 = var2_2 - arg1_2.beginTime

		arg0_2.timer = Timer.New(function()
			local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_4 = var2_2 - var0_4

			if var1_4 <= 0 then
				arg0_2:removeTimer()
				arg0_2:Update(arg1_2)
			else
				arg0_2.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_4)

				setFillAmount(arg0_2.slider, 1 - var1_4 / var3_2)
			end
		end, 1, -1)

		arg0_2.timer:Start()
		arg0_2.timer.func()
		onButton(arg0_2._parent, arg0_2.quicklyTool, function()
			arg0_2._parent:emit(CommanderCatScene.EVENT_QUICKLY_TOOL, arg1_2.id)
		end, SFX_PANEL)
	elseif var0_2 == CommanderBox.STATE_FINISHED then
		arg0_2.timerTxt.text = "COMPLETE"

		setFillAmount(arg0_2.slider, 1)
		onButton(arg0_2._parent, arg0_2._tf, function()
			local var0_6 = getProxy(CommanderProxy)

			if getProxy(PlayerProxy):getData().commanderBagMax <= var0_6:getCommanderCnt() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_capcity_is_max"))

				return
			end

			arg0_2._parent:emit(CommanderCatMediator.GET, arg1_2.id)
		end, SFX_PANEL)
	end

	setActive(arg0_2.quicklyTool, var0_2 == CommanderBox.STATE_STARTING and not LOCK_CATTERY)
	setActive(arg0_2.titleStarting, var0_2 == CommanderBox.STATE_STARTING)
	setActive(arg0_2.titleFinish, var0_2 == CommanderBox.STATE_FINISHED)
	setActive(arg0_2.startingTF, var0_2 == CommanderBox.STATE_STARTING or var0_2 == CommanderBox.STATE_FINISHED)
	setActive(arg0_2.idleTF, var0_2 == CommanderBox.STATE_EMPTY)
	setActive(arg0_2.waitTF, var0_2 == CommanderBox.STATE_WAITING)

	local var4_2 = arg1_2:getPrefab()

	arg0_2:loadBox(var4_2, arg0_2.boxParent)
end

local var1_0 = true

function var0_0.playAnim(arg0_7, arg1_7)
	arg0_7:loadBox(arg0_7.boxVO:getFetchPrefab(), arg0_7.boxParent, function(arg0_8)
		arg0_7.spineAnimUI = arg0_8

		arg0_8:SetActionCallBack(function(arg0_9)
			if arg0_9 == "finish" then
				arg0_8:SetActionCallBack(nil)
				arg1_7()
			end
		end)
	end)
end

function var0_0.loadBox(arg0_10, arg1_10, arg2_10, arg3_10)
	if not arg1_10 then
		arg0_10:returnChar()
	else
		if arg0_10.prefabName == arg1_10 then
			return
		end

		arg0_10:returnChar()

		arg0_10.prefabName = arg1_10

		local var0_10 = arg1_10

		PoolMgr.GetInstance():GetSpineChar(var0_10, true, function(arg0_11)
			if arg0_10.exited or var0_10 ~= arg0_10.prefabName then
				PoolMgr.GetInstance():ReturnSpineChar(var0_10, arg0_11)

				return
			end

			arg0_10.modelTf = tf(arg0_11)
			arg0_10.modelTf.localScale = Vector3(0.7, 0.7, 1)
			arg0_10.modelTf.localPosition = Vector3(0, -123, 0)

			pg.ViewUtils.SetLayer(arg0_10.modelTf, Layer.UI)
			setParent(arg0_10.modelTf, arg2_10)

			local var0_11 = arg0_11:GetComponent("SpineAnimUI")

			var0_11:SetAction("normal", 0)

			if arg3_10 then
				arg3_10(var0_11)
			end
		end)
	end
end

function var0_0.removeTimer(arg0_12)
	if arg0_12.timer then
		arg0_12.timer:Stop()

		arg0_12.timer = nil
	end
end

function var0_0.removeWaitingTimer(arg0_13)
	if arg0_13.waitTimer then
		arg0_13.waitTimer:Stop()

		arg0_13.waitTimer = nil
	end
end

function var0_0.returnChar(arg0_14)
	if arg0_14.modelTf and arg0_14.prefabName then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_14.prefabName, arg0_14.modelTf.gameObject)

		arg0_14.modelTf = nil
		arg0_14.prefabName = nil
	end
end

function var0_0.Clear(arg0_15)
	arg0_15:removeTimer()
	arg0_15:removeWaitingTimer()
	removeOnButton(arg0_15._tf)

	arg0_15.boxVO = nil
end

function var0_0.Destroy(arg0_16)
	arg0_16:Clear()
	arg0_16:returnChar()

	arg0_16.exited = true
	arg0_16.boxVO = nil
	arg0_16.loading = nil
end

return var0_0
