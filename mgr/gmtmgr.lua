pg = pg or {}
pg.GMTMgr = singletonClass("GMTMgr")

local var0_0 = pg.GMTMgr

var0_0.TYPE_DEFAULT_RES = 2
var0_0.TYPE_L2D = 4
var0_0.TYPE_PAINTING = 8
var0_0.TYPE_CIPHER = 16

function var0_0.Init(arg0_1, arg1_1)
	arg0_1._gmtTimer = Timer.New(function()
		arg0_1:onTimer()
	end, 1, -1)

	if arg1_1 then
		arg1_1()
	end
end

function var0_0.initUI(arg0_3, arg1_3)
	if arg0_3._go == nil then
		PoolMgr.GetInstance():GetUI("GMTUI", true, function(arg0_4)
			arg0_3._go = arg0_4

			arg0_3._go:SetActive(false)

			arg0_3._textTf = findTF(arg0_3._go, "ad/text")

			local var0_4 = GameObject.Find("OverlayCamera/Overlay/UITop")

			arg0_3._go.transform:SetParent(var0_4.transform, false)

			arg0_3._animator = GetComponent(arg0_3._go, typeof(Animator))

			arg1_3()
		end)
	end
end

function var0_0.onTimer(arg0_5)
	arg0_5._subTime = arg0_5._gmtTime - pg.TimeMgr:GetInstance():GetServerTime()

	if arg0_5._go == nil then
		arg0_5:initUI(function()
			arg0_5:showTip()
		end)
	else
		arg0_5:showTip()
	end

	if arg0_5._subTime < 0 and arg0_5._gmtTimer.running then
		arg0_5._gmtTimer:Stop()
		arg0_5._go:SetActive(false)
	end
end

function var0_0.showGMT(arg0_7, arg1_7)
	local var0_7 = pg.gameset.maintenance_message.description

	arg0_7._onceTime = Clone(var0_7[1])
	arg0_7._repeatTime = Clone(var0_7[2])
	arg0_7._gmtTime = arg1_7

	if not arg0_7._gmtTimer.running then
		arg0_7._gmtTimer:Start()
	end

	arg0_7._triggerStop = false
end

function var0_0.showTip(arg0_8)
	print(arg0_8._subTime)

	local var0_8 = false

	if arg0_8.focusShowTip then
		var0_8 = true
		arg0_8.focusShowTip = false
	end

	if arg0_8._subTime <= arg0_8._repeatTime then
		var0_8 = true
	else
		for iter0_8 = #arg0_8._onceTime, 1, -1 do
			if arg0_8._subTime <= arg0_8._onceTime[iter0_8] then
				table.remove(arg0_8._onceTime, iter0_8)

				var0_8 = true
			end
		end
	end

	if not var0_8 then
		return
	end

	arg0_8._go:SetActive(false)
	arg0_8._go:SetActive(true)

	if arg0_8._subTime > arg0_8._repeatTime then
		arg0_8._animator:SetTrigger("once")
	elseif not arg0_8._triggerStop then
		arg0_8._triggerStop = true

		arg0_8._animator:SetTrigger("repeat")
	end

	local var1_8 = arg0_8:getTimeTip()

	setText(arg0_8._textTf, var1_8)
end

function var0_0.getTimeTip(arg0_9)
	if arg0_9._subTime > 0 then
		local var0_9 = math.floor(arg0_9._subTime / 3600)
		local var1_9 = math.floor(arg0_9._subTime / 60)
		local var2_9 = arg0_9._subTime % 60
		local var3_9

		if var0_9 > 0 then
			var3_9 = tostring(var0_9) .. i18n("word_hour")
		elseif var1_9 > 0 then
			var3_9 = tostring(var1_9) .. i18n("word_minute")
		else
			var3_9 = tostring(var2_9) .. i18n("word_second")
		end

		return i18n("maintenance_message_text", var3_9)
	end

	return i18n("maintenance_message_stop_text")
end
