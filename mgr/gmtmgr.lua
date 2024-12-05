pg = pg or {}
pg.GMTMgr = singletonClass("GMTMgr")

local var0_0 = pg.GMTMgr

var0_0.TYPE_DEFAULT_RES = 2
var0_0.TYPE_L2D = 4
var0_0.TYPE_PAINTING = 8
var0_0.TYPE_CIPHER = 16

function var0_0.Init(arg0_1, arg1_1)
	if arg1_1 then
		arg1_1()
	end
end

function var0_0.initUI(arg0_2, arg1_2)
	if arg0_2._go == nil then
		PoolMgr.GetInstance():GetUI("GMTUI", true, function(arg0_3)
			arg0_2._go = arg0_3

			arg0_2._go:SetActive(false)

			arg0_2._textTf = findTF(arg0_2._go, "ad/text")

			local var0_3 = GameObject.Find("OverlayCamera/Overlay/UITop")

			arg0_2._go.transform:SetParent(var0_3.transform, false)

			arg0_2._animator = GetComponent(arg0_2._go, typeof(Animator))

			arg1_2()
		end)
	end
end

function var0_0.showGMT(arg0_4, arg1_4)
	arg0_4._subTime = arg1_4 - pg.TimeMgr:GetInstance():GetServerTime()

	if arg0_4._go == nil then
		arg0_4:initUI(function()
			arg0_4:showTip()
		end)
	else
		arg0_4:showTip()
	end
end

function var0_0.showTip(arg0_6)
	arg0_6._go:SetActive(false)
	arg0_6._go:SetActive(true)

	if arg0_6._subTime >= 10 then
		arg0_6._animator:SetTrigger("once")
	elseif not arg0_6._triggerStop then
		arg0_6._triggerStop = true

		arg0_6._animator:SetTrigger("repeat")
	end

	local var0_6 = arg0_6:getTimeTip()

	setText(arg0_6._textTf, var0_6)
end

function var0_0.getTimeTip(arg0_7)
	if arg0_7._subTime > 0 then
		local var0_7 = math.floor(arg0_7._subTime / 3600)
		local var1_7 = math.floor(arg0_7._subTime / 60)
		local var2_7 = arg0_7._subTime % 60
		local var3_7

		if var0_7 > 0 then
			var3_7 = tostring(var0_7) .. i18n("word_hour")
		elseif var1_7 > 0 then
			var3_7 = tostring(var1_7) .. i18n("word_minute")
		else
			var3_7 = tostring(var2_7) .. i18n("word_second")
		end

		return i18n("maintenance_message_text", var3_7)
	end

	return i18n("maintenance_message_stop_text")
end
