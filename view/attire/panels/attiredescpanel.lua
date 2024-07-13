local var0_0 = class("AttireDescPanel")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.icon = findTF(arg0_1._tf, "icon")
	arg0_1.frame = findTF(arg0_1._tf, "frame")
	arg0_1.chatContainer = findTF(arg0_1._tf, "chatContainer")
	arg0_1.conditionTF = findTF(arg0_1._tf, "condition")
	arg0_1.nameTxt = findTF(arg0_1._tf, "name/Text"):GetComponent(typeof(Text))
	arg0_1.stateTxt = findTF(arg0_1._tf, "get_info/lock"):GetComponent(typeof(Text))
	arg0_1.timeTxt = findTF(arg0_1._tf, "get_info/time"):GetComponent(typeof(Text))
	arg0_1.conditionTxt = findTF(arg0_1._tf, "condition/Text"):GetComponent(typeof(Text))
	arg0_1.applyBtn = findTF(arg0_1._tf, "apply_btn")
	arg0_1.applyingBtn = findTF(arg0_1._tf, "applying_btn")
	arg0_1.getBtn = findTF(arg0_1._tf, "get_btn")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2:UpdateIconDesc(arg1_2, arg2_2)

	arg0_2.nameTxt.text = HXSet.hxLan(arg1_2:getConfig("name"))

	local var0_2 = arg1_2:isOwned()
	local var1_2 = var0_2 and i18n("word_got") or i18n("word_not_get")

	arg0_2.stateTxt.text = setColorStr(var1_2, var0_2 and "#3DC6FFFF" or "#a5afdf")

	local var2_2 = arg1_2:expiredType()

	arg0_2:RemoveTimer()

	if var0_2 and var2_2 then
		arg0_2:AddTimer(arg1_2, arg2_2)
	elseif var0_2 and not var2_2 then
		arg0_2.timeTxt.text = ""
	elseif not var0_2 then
		arg0_2.timeTxt.text = ""
	end

	arg0_2.conditionTxt.text = HXSet.hxLan(arg1_2:getConfig("desc"))

	local var3_2 = arg1_2:getState()
	local var4_2 = arg2_2:getAttireByType(arg1_2:getType()) == arg1_2.id

	setActive(arg0_2.applyBtn, var3_2 == AttireFrame.STATE_UNLOCK and not var4_2)
	setActive(arg0_2.applyingBtn, var3_2 == AttireFrame.STATE_UNLOCK and var4_2)
	setActive(arg0_2.getBtn, var3_2 == AttireFrame.STATE_LOCK)
end

function var0_0.UpdateIconDesc(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3:getType() == AttireConst.TYPE_ICON_FRAME
	local var1_3 = arg1_3:getType() == AttireConst.TYPE_CHAT_FRAME

	if arg0_3.loadedIcon and arg0_3.loadedIconTF then
		local var2_3 = arg0_3.loadedIcon:getIcon()

		if var1_3 then
			arg0_3.loadedIconTF.transform:Find("Text"):GetComponent(typeof(Text)).supportRichText = false
		end

		PoolMgr.GetInstance():ReturnPrefab(var2_3, arg0_3.loadedIcon.id, arg0_3.loadedIconTF)
	end

	if var0_3 then
		if not arg0_3.startList then
			arg0_3.startList = UIItemList.New(findTF(arg0_3._tf, "stars"), findTF(arg0_3._tf, "stars/tpl"))
		end

		local var3_3 = arg1_3:getIcon()

		PoolMgr.GetInstance():GetPrefab(var3_3, arg1_3:getConfig("id"), true, function(arg0_4)
			arg0_3.loadedIcon = arg1_3
			arg0_3.loadedIconTF = arg0_4

			setParent(arg0_4, arg0_3.frame, false)
		end)

		local var4_3 = arg2_3:GetFlagShip()

		LoadSpriteAsync("qicon/" .. var4_3:getPrefab(), function(arg0_5)
			arg0_3.icon:GetComponent(typeof(Image)).sprite = arg0_5
		end)
		arg0_3.startList:align(var4_3:getStar())
	elseif var1_3 then
		local var5_3 = arg1_3:getIcon()

		PoolMgr.GetInstance():GetPrefab(var5_3, arg1_3:getConfig("id") .. "_self", true, function(arg0_6)
			arg0_3.loadedIcon = arg1_3
			arg0_3.loadedIconTF = arg0_6

			setParent(arg0_6, arg0_3.chatContainer, false)

			tf(arg0_6).localPosition = Vector3(0, 0, 0)
			findTF(arg0_6, "Text"):GetComponent(typeof(Text)).supportRichText = true

			setText(findTF(arg0_6, "Text"), arg1_3:getConfig("desc"))
		end)
	end

	setActive(arg0_3.conditionTF, not var1_3)
end

function var0_0.AddTimer(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7:getExpiredTime()

	arg0_7.timer = Timer.New(function()
		local var0_8 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_8 = var0_7 - var0_8

		if var1_8 > 0 then
			arg0_7.timeTxt.text = "/ " .. attireTimeStamp(var1_8)
		else
			arg0_7:Update(arg1_7, arg2_7)
			arg0_7:RemoveTimer()
		end
	end, 1, -1)

	arg0_7.timer:Start()
	arg0_7.timer.func()
end

function var0_0.RemoveTimer(arg0_9)
	if arg0_9.timer then
		arg0_9.timer:Stop()

		arg0_9.timer = nil
	end
end

function var0_0.Dispose(arg0_10)
	arg0_10:RemoveTimer()
end

return var0_0
